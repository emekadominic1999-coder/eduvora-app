import 'dart:async';
import 'dart:typed_data';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:record/record.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/models/chat.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/models/study_group.dart';
import '../../../../core/services/group_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/wav_encoder.dart';
import '../../../../core/widgets/common.dart';
import '../../../chats/presentation/widgets/message_bubble.dart';
import 'group_info_screen.dart';

/// Emoji offered on every message — small and deliberate, the way a
/// classroom's reactions are a handful of gestures, not an open keyboard.
const List<String> _quickReactions = <String>['👍', '❤️', '😂', '😮', '😢', '🙏'];

/// "0:07" for anything under an hour, "1:02:30" past it — a voice note is
/// never that long, but a stray double-length recording should still read
/// sensibly rather than overflow its own label.
String _formatDuration(Duration d) {
  final int hours = d.inHours;
  final int minutes = d.inMinutes.remainder(60);
  final int seconds = d.inSeconds.remainder(60);
  final String ss = seconds.toString().padLeft(2, '0');
  if (hours > 0) {
    return '$hours:${minutes.toString().padLeft(2, '0')}:$ss';
  }
  return '$minutes:$ss';
}

/// A real group conversation: members, messages, and a question filter.
class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key, required this.group});

  final StudyGroup group;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  static const GroupRepository _repo = GroupRepository();

  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  List<GroupMessage> _messages = <GroupMessage>[];
  bool _loading = true;
  bool _sending = false;
  bool _askingQuestion = false;
  bool _questionsOnly = false;

  /// The message being replied to, shown above the composer until sent.
  GroupMessage? _replyTo;

  /// A photo, document or voice note chosen but not yet sent, shown above
  /// the composer the same way a pending reply is.
  PlatformFile? _pendingAttachment;
  GroupAttachmentType? _pendingAttachmentType;

  /// Only meaningful when [_pendingAttachmentType] is
  /// [GroupAttachmentType.voice] — a photo or document has no playback
  /// length.
  int _pendingAttachmentDurationMs = 0;
  bool _uploading = false;

  /// True when the signed-in student is an admin here — admins may delete
  /// anybody's message, not only their own.
  bool _iAmAdmin = false;

  StreamSubscription<GroupMessage>? _live;
  StreamSubscription<GroupMessageReaction>? _liveReactions;

  // --------------------------------------------------------- voice recording
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _recordSub;
  BytesBuilder? _pcmBuffer;
  bool _recording = false;
  Duration _recordElapsed = Duration.zero;
  Timer? _recordTicker;

  /// The rate the microphone is *actually* delivering, which is not
  /// necessarily the rate asked for — browsers hand back their AudioContext's
  /// rate (48 kHz, typically) whatever is requested. Seeded with the
  /// requested value and corrected by the recorder's own
  /// onConfigChanged callback, which only fires when the platform overrode
  /// something.
  int _captureSampleRate = WavEncoder.preferredSampleRate;
  int _captureChannels = WavEncoder.numChannels;

  // ------------------------------------------------------------- emoji panel
  final FocusNode _inputFocus = FocusNode();
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _load();
    _listen();
    _listenReactions();
  }

  @override
  void dispose() {
    _live?.cancel();
    _liveReactions?.cancel();
    _recordTicker?.cancel();
    _recordSub?.cancel();
    // Stopping is best-effort here — the screen is on its way out either
    // way, and a recorder left running would otherwise leak the microphone.
    if (_recording) unawaited(_recorder.stop());
    _recorder.dispose();
    _input.dispose();
    _inputFocus.dispose();
    _scroll.dispose();
    super.dispose();
  }

  /// Messages arrive as they are sent rather than on a pull-to-refresh, which
  /// is the whole difference between a message board and a chat.
  void _listen() {
    _live = _repo.watchMessages(widget.group.id).listen((GroupMessage m) {
      if (!mounted) return;
      final bool atBottom =
          !_scroll.hasClients ||
          _scroll.position.pixels >= _scroll.position.maxScrollExtent - 80;

      setState(() => _messages = _merge(_messages, m));

      // Only follow the conversation down if they were already at the end.
      // Yanking the view while somebody is reading back is maddening.
      if (atBottom) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _toBottom(animate: true),
        );
      }
    });
  }

  /// Inserts or replaces a message, keeping the thread in time order. An
  /// update — a deletion, say — replaces the row rather than duplicating it.
  /// A message already carrying reactions keeps them, since neither the
  /// realtime message stream nor a plain refetch of `messages` knows
  /// anything about reactions — those come from their own table.
  static List<GroupMessage> _merge(
    List<GroupMessage> current,
    GroupMessage incoming,
  ) {
    final List<GroupMessage> next = List<GroupMessage>.from(current);
    final int at = next.indexWhere((GroupMessage m) => m.id == incoming.id);
    if (at >= 0) {
      next[at] = incoming.reactions.isEmpty
          ? incoming.copyWith(reactions: next[at].reactions)
          : incoming;
    } else {
      next.add(incoming);
    }
    return next
      ..sort((GroupMessage a, GroupMessage b) => a.sentAt.compareTo(b.sentAt));
  }

  /// Reactions arrive from their own table, one change at a time. Rather than
  /// trust the shape of the changed row — a deleted row's payload can be
  /// partial depending on the database's replica settings — this simply
  /// refetches the affected message's reactions and replaces them wholesale.
  /// Reactions are rare next to messages, so the extra round trip costs
  /// nothing worth avoiding.
  void _listenReactions() {
    _liveReactions = _repo.watchReactions(widget.group.id).listen((
      GroupMessageReaction event,
    ) async {
      if (!mounted || event.messageId.isEmpty) return;
      final List<GroupMessageReaction> fresh = await _repo.reactionsFor(
        <String>[event.messageId],
      );
      if (!mounted) return;
      setState(() {
        _messages = _messages
            .map(
              (GroupMessage m) => m.id == event.messageId
                  ? m.copyWith(reactions: fresh)
                  : m,
            )
            .toList();
      });
    });
  }

  Future<void> _load() async {
    final StudentProfile? me = sessionController.profile;
    final List<GroupMessage> messages = await _repo.messages(widget.group.id);
    final List<GroupMember> members = await _repo.members(widget.group.id);
    final List<GroupMessageReaction> reactions = await _repo.reactionsFor(
      messages.map((GroupMessage m) => m.id).toList(),
    );
    if (!mounted) return;

    final Map<String, List<GroupMessageReaction>> byMessage =
        <String, List<GroupMessageReaction>>{};
    for (final GroupMessageReaction r in reactions) {
      byMessage.putIfAbsent(r.messageId, () => <GroupMessageReaction>[]).add(r);
    }

    setState(() {
      _messages = messages
          .map(
            (GroupMessage m) => m.copyWith(
              reactions: byMessage[m.id] ?? const <GroupMessageReaction>[],
            ),
          )
          .toList();
      _iAmAdmin = members.any(
        (GroupMember m) => m.userId == me?.id && m.isAdmin,
      );
      _loading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom());
  }

  /// Sets or clears this student's reaction, updating the screen immediately
  /// and reconciling with the server in the background — a reaction should
  /// feel instant, the way tapping a like does anywhere else.
  Future<void> _toggleReaction(GroupMessage message, String emoji) async {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    final String? current = message.myReaction(profile.id);
    final bool removing = current == emoji;

    final List<GroupMessageReaction> optimistic = removing
        ? message.reactions
              .where((GroupMessageReaction r) => r.userId != profile.id)
              .toList()
        : <GroupMessageReaction>[
            ...message.reactions.where(
              (GroupMessageReaction r) => r.userId != profile.id,
            ),
            GroupMessageReaction(
              id: 'pending',
              messageId: message.id,
              userId: profile.id,
              userName: profile.fullName,
              emoji: emoji,
            ),
          ];

    setState(() {
      _messages = _messages
          .map(
            (GroupMessage m) =>
                m.id == message.id ? m.copyWith(reactions: optimistic) : m,
          )
          .toList();
    });

    try {
      if (removing) {
        await _repo.unreact(profile: profile, message: message);
      } else {
        await _repo.react(profile: profile, message: message, emoji: emoji);
      }
    } catch (error) {
      if (!mounted) return;
      final List<GroupMessageReaction> fresh = await _repo.reactionsFor(
        <String>[message.id],
      );
      if (!mounted) return;
      setState(() {
        _messages = _messages
            .map(
              (GroupMessage m) =>
                  m.id == message.id ? m.copyWith(reactions: fresh) : m,
            )
            .toList();
      });
      showEduvoraSnack(context, '$error', isError: true);
    }
  }

  /// Long-press actions on a message: react, reply, copy, delete.
  Future<void> _messageActions(GroupMessage message) async {
    if (message.isDeleted) return;

    final StudentProfile? profile = sessionController.profile;
    final String myId = profile?.id ?? '';
    final bool canDelete = message.authorId == myId || _iAmAdmin;
    final String? myReaction = profile == null
        ? null
        : message.myReaction(profile.id);

    final String? action = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _quickReactions
                    .map(
                      (String emoji) => GestureDetector(
                        onTap: () =>
                            Navigator.of(context).pop('react:$emoji'),
                        child: AnimatedScale(
                          scale: myReaction == emoji ? 1.25 : 1,
                          duration: const Duration(milliseconds: 150),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 27),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.reply_rounded),
              title: const Text('Reply'),
              onTap: () => Navigator.of(context).pop('reply'),
            ),
            if (message.body.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.copy_rounded),
                title: const Text('Copy text'),
                onTap: () => Navigator.of(context).pop('copy'),
              ),
            if (canDelete)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppColours.danger,
                ),
                title: Text(
                  message.authorId == myId
                      ? 'Delete my message'
                      : 'Delete as admin',
                  style: const TextStyle(color: AppColours.danger),
                ),
                onTap: () => Navigator.of(context).pop('delete'),
              ),
          ],
        ),
      ),
    );
    if (action == null || !mounted) return;

    if (action.startsWith('react:')) {
      await _toggleReaction(message, action.substring(6));
      return;
    }

    switch (action) {
      case 'reply':
        setState(() => _replyTo = message);
      case 'copy':
        await Clipboard.setData(ClipboardData(text: message.body));
        if (mounted) showEduvoraSnack(context, 'Message copied.');
      case 'delete':
        await _delete(message);
    }
  }

  Future<void> _delete(GroupMessage message) async {
    try {
      final GroupMessage cleared = await _repo.deleteMessage(message: message);
      if (!mounted) return;
      setState(() => _messages = _merge(_messages, cleared));
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(context, '$error', isError: true);
    }
  }

  void _toBottom({bool animate = false}) {
    if (!_scroll.hasClients) return;
    final double target = _scroll.position.maxScrollExtent;
    if (animate) {
      _scroll.animateTo(
        target,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
      );
    } else {
      _scroll.jumpTo(target);
    }
  }

  Future<void> _send() async {
    final String body = _input.text.trim();
    final PlatformFile? attachment = _pendingAttachment;
    final GroupAttachmentType? attachmentType = _pendingAttachmentType;
    final int attachmentDurationMs = _pendingAttachmentDurationMs;
    if (body.isEmpty && attachment == null) return;
    if (_sending) return;

    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    final GroupMessage? replyTo = _replyTo;
    setState(() => _sending = true);
    _input.clear();

    try {
      String attachmentUrl = '';
      if (attachment != null) {
        setState(() => _uploading = true);
        attachmentUrl = await _repo.uploadAttachment(
          profile: profile,
          groupId: widget.group.id,
          fileName: attachment.name,
          bytes: attachment.bytes!,
        );
      }

      final GroupMessage sent = await _repo.sendMessage(
        profile: profile,
        groupId: widget.group.id,
        body: body,
        isQuestion: _askingQuestion,
        replyTo: replyTo,
        attachmentUrl: attachmentUrl,
        attachmentName: attachment?.name ?? '',
        attachmentType: attachment == null ? null : attachmentType,
        attachmentSize: attachment?.size ?? 0,
        attachmentDurationMs: attachment == null ? 0 : attachmentDurationMs,
      );
      if (!mounted) return;
      setState(() {
        _messages = _merge(_messages, sent);
        _askingQuestion = false;
        _replyTo = null;
        _pendingAttachment = null;
        _pendingAttachmentType = null;
        _pendingAttachmentDurationMs = 0;
      });
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _toBottom(animate: true));
    } catch (error) {
      // The message is already in the local thread; say plainly that it has
      // not reached the group rather than letting them believe it sent.
      if (!mounted) return;
      final List<GroupMessage> messages = await _repo.messages(
        widget.group.id,
      );
      if (!mounted) return;
      setState(() {
        _messages = messages;
        _replyTo = null;
      });
      showEduvoraSnack(context, '$error', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          _sending = false;
          _uploading = false;
        });
      }
    }
  }

  /// Offers a photo or a document, then hands the picked file to the pending
  /// attachment preview above the composer.
  Future<void> _pickAttachment() async {
    final String? kind = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(
                Icons.photo_rounded,
                color: AppColours.primary,
              ),
              title: const Text('Photo'),
              onTap: () => Navigator.of(context).pop('image'),
            ),
            ListTile(
              leading: const Icon(
                Icons.description_rounded,
                color: AppColours.accent,
              ),
              title: const Text('Document'),
              subtitle: const Text('PDF, Word, PowerPoint, Excel'),
              onTap: () => Navigator.of(context).pop('file'),
            ),
          ],
        ),
      ),
    );
    if (kind == null || !mounted) return;

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
        type: kind == 'image' ? FileType.image : FileType.custom,
        allowedExtensions: kind == 'image'
            ? null
            : const <String>[
                'pdf',
                'doc',
                'docx',
                'ppt',
                'pptx',
                'xls',
                'xlsx',
                'txt',
              ],
      );
      if (result == null || result.files.isEmpty || !mounted) return;

      final PlatformFile picked = result.files.first;
      if (picked.bytes == null) {
        showEduvoraSnack(
          context,
          'We could not read that file on this device.',
          isError: true,
        );
        return;
      }
      if (picked.size > AppConfig.maxAttachmentBytes) {
        final int limitMb = AppConfig.maxAttachmentBytes ~/ (1024 * 1024);
        showEduvoraSnack(
          context,
          'That file is larger than ${limitMb}MB. Please share a smaller one.',
          isError: true,
        );
        return;
      }

      setState(() {
        _pendingAttachment = picked;
        _pendingAttachmentType = kind == 'image'
            ? GroupAttachmentType.image
            : GroupAttachmentType.file;
      });
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(
        context,
        'We could not open the file picker on this device.',
        isError: true,
      );
    }
  }

  // ------------------------------------------------------- voice recording
  //
  // Captured as a raw PCM stream rather than to a file path: a file path
  // means a real filesystem, which Flutter Web does not have. Streaming
  // works identically everywhere — the bytes are accumulated here and wrapped
  // into a WAV file only once recording stops, by [WavEncoder].

  Future<void> _startRecording() async {
    if (_recording || _pendingAttachment != null || _sending) return;

    // No separate permission pre-check: on the web, record's hasPermission()
    // has been seen to report false even when the browser's own site
    // settings already show the microphone allowed — presumably a mismatch
    // between the plugin's check and the browser's actual permission state.
    // Going straight to startStream() lets the browser be the single source
    // of truth: if it already has permission, recording just begins; if it
    // does not, the browser raises its own prompt or its own error, and
    // that error is what gets read below.
    // Reset to what is about to be requested: the callback below only fires
    // when the platform overrides something, so a rate left over from a
    // previous recording would otherwise be reused and mislabel this one.
    _captureSampleRate = WavEncoder.preferredSampleRate;
    _captureChannels = WavEncoder.numChannels;

    try {
      await _recorder.setOnConfigChanged((RecordConfig effective) {
        _captureSampleRate = effective.sampleRate;
        _captureChannels = effective.numChannels;
        debugPrint(
          '[Eduvora] recorder adjusted config: '
          '${effective.sampleRate}Hz, ${effective.numChannels}ch',
        );
      });

      final Stream<Uint8List> stream = await _recorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: WavEncoder.preferredSampleRate,
          numChannels: WavEncoder.numChannels,
        ),
      );

      _pcmBuffer = BytesBuilder(copy: false);
      _recordSub = stream.listen((Uint8List chunk) {
        _pcmBuffer?.add(chunk);
      });

      setState(() {
        _recording = true;
        _recordElapsed = Duration.zero;
      });

      // A ticking display is what tells a student the mic is actually live —
      // without it, a silently-failed recording looks identical to a working
      // one until they hit send.
      _recordTicker = Timer.periodic(const Duration(milliseconds: 100), (
        Timer timer,
      ) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(
          () => _recordElapsed += const Duration(milliseconds: 100),
        );
        if (_recordElapsed.inSeconds >= AppConfig.maxVoiceNoteSeconds) {
          _stopRecording(send: true);
        }
      });
    } catch (error) {
      debugPrint('[Eduvora] voice recording failed to start: $error');
      if (!mounted) return;
      final String raw = error.toString();
      final String detail = raw.toLowerCase();
      final bool isPermission =
          detail.contains('permission') ||
          detail.contains('notallowed') ||
          detail.contains('denied');
      // The error's own message, not its (minified, unreadable) runtime type
      // — release builds mangle Dart class names but never the text of a
      // thrown message, so this is the only part of the failure that stays
      // legible enough to act on.
      final String shown = raw.length > 140 ? '${raw.substring(0, 140)}…' : raw;
      showEduvoraSnack(
        context,
        isPermission
            ? 'Eduvora needs microphone access to record a voice note. '
                  "Check your browser's site permissions and allow the "
                  'microphone, then reload the page and try again.'
            : 'We could not start recording: $shown',
        isError: true,
      );
    }
  }

  /// Stops the microphone. [send] true queues the clip above the composer
  /// exactly like a picked photo or document; false — cancelling mid-record —
  /// throws the audio away.
  Future<void> _stopRecording({required bool send}) async {
    if (!_recording) return;
    _recordTicker?.cancel();
    _recordTicker = null;
    final Duration elapsed = _recordElapsed;

    try {
      await _recorder.stop();
    } catch (_) {
      // The stream has already delivered every byte it is going to by the
      // time this is called, so a failure here does not lose the recording.
    }
    await _recordSub?.cancel();
    _recordSub = null;

    final Uint8List pcm = _pcmBuffer?.toBytes() ?? Uint8List(0);
    _pcmBuffer = null;

    if (!mounted) return;
    setState(() => _recording = false);

    // Under a second is almost always an accidental tap, not a message.
    if (!send || elapsed.inMilliseconds < 800 || pcm.isEmpty) return;

    final EncodedVoiceNote note = WavEncoder.encode(
      pcm,
      sourceSampleRate: _captureSampleRate,
      channels: _captureChannels,
    );
    setState(() {
      _pendingAttachment = PlatformFile(
        name: 'voice-note-${DateTime.now().millisecondsSinceEpoch}.wav',
        size: note.bytes.length,
        bytes: note.bytes,
      );
      _pendingAttachmentType = GroupAttachmentType.voice;
      _pendingAttachmentDurationMs = note.duration.inMilliseconds;
    });
  }

  /// Opens the full group info screen: members, admins and the invite code.
  Future<void> _showMembers() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GroupInfoScreen(group: widget.group),
      ),
    );
    // Admin rights may have changed while they were in there.
    if (mounted) await _load();
  }

  static bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _shareCode() async {
    await Clipboard.setData(ClipboardData(text: widget.group.joinCode));
    if (!mounted) return;
    showEduvoraSnack(
      context,
      'Code ${widget.group.joinCode} copied — share it with your coursemates.',
      icon: Icons.copy_rounded,
    );
  }

  Future<void> _leave() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Leave ${widget.group.name}?'),
        content: const Text(
          'You will stop seeing its messages. You can rejoin later with the '
          'group code.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColours.danger),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    if (!(confirm ?? false)) return;

    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    await _repo.leaveGroup(profile: profile, groupId: widget.group.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final List<GroupMessage> shown = _questionsOnly
        ? _messages.where((GroupMessage m) => m.isQuestion).toList()
        : _messages;
    final String myId = sessionController.profile?.id ?? '';

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: GestureDetector(
          onTap: _showMembers,
          child: Row(
            children: <Widget>[
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppColours.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: AppColours.primary,
                  size: 19,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.group.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w700,
                        color: AppColours.text,
                      ),
                    ),
                    Text(
                      '${widget.group.memberCount} members · tap for details',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColours.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => setState(() => _questionsOnly = !_questionsOnly),
            tooltip: _questionsOnly ? 'Show all messages' : 'Questions only',
            icon: Icon(
              _questionsOnly
                  ? Icons.help_rounded
                  : Icons.help_outline_rounded,
              color: _questionsOnly ? AppColours.accent : null,
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == 'code') _shareCode();
              if (value == 'members') _showMembers();
              if (value == 'leave') _leave();
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'code',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.share_rounded, size: 20),
                  title: Text('Share group code'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'members',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.people_rounded, size: 20),
                  title: Text('Group info'),
                ),
              ),
              const PopupMenuItem<String>(
                value: 'leave',
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.logout_rounded,
                    size: 20,
                    color: AppColours.danger,
                  ),
                  title: Text(
                    'Leave group',
                    style: TextStyle(color: AppColours.danger),
                  ),
                ),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: Column(
        children: <Widget>[
          if (_questionsOnly)
            Container(
              width: double.infinity,
              color: AppColours.accent.withValues(alpha: 0.10),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Text(
                'Showing questions only — ${shown.length} of ${_messages.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColours.accentDark,
                ),
              ),
            ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : shown.isEmpty
                ? EmptyState(
                    icon: _questionsOnly
                        ? Icons.help_outline_rounded
                        : Icons.forum_outlined,
                    title: _questionsOnly
                        ? 'No questions yet'
                        : 'Start the conversation',
                    message: _questionsOnly
                        ? 'Messages sent with the question mark turned on '
                              'appear here, so they are easy to find later.'
                        : 'Say hello, or share the group code so your '
                              'coursemates can join.',
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                    ),
                    itemCount: shown.length,
                    itemBuilder: (BuildContext context, int index) {
                      final GroupMessage m = shown[index];
                      final bool mine = m.authorId == myId;
                      final bool showName =
                          !mine &&
                          (index == 0 ||
                              shown[index - 1].authorName != m.authorName);
                      final bool newDay =
                          index == 0 ||
                          !_sameDay(shown[index - 1].sentAt, m.sentAt);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (newDay) _DayDivider(day: m.sentAt),
                          if (m.isQuestion && !m.isDeleted)
                            Padding(
                              padding: EdgeInsets.only(
                                left: mine ? 0 : 14,
                                right: mine ? 14 : 0,
                                bottom: 3,
                              ),
                              child: Align(
                                alignment: mine
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: const Pill(
                                  label: 'Question',
                                  colour: AppColours.accent,
                                  icon: Icons.help_rounded,
                                  dense: true,
                                ),
                              ),
                            ),
                          if (m.isReply && !m.isDeleted)
                            _QuotedReply(message: m, mine: mine),
                          GestureDetector(
                            onLongPress: () => _messageActions(m),
                            child: m.isDeleted
                                ? _DeletedBubble(mine: mine)
                                : m.hasAttachment
                                ? _AttachmentBubble(
                                    message: m,
                                    mine: mine,
                                    showSenderName: showName,
                                  )
                                : MessageBubble(
                                    message: ChatMessage(
                                      id: m.id,
                                      conversationId: m.groupId,
                                      author: mine
                                          ? MessageAuthor.student
                                          : MessageAuthor.peer,
                                      senderName: m.authorName,
                                      body: m.body,
                                      sentAt: m.sentAt,
                                    ),
                                    showSenderName: showName,
                                  ),
                          ),
                          if (!m.isDeleted)
                            _ReactionsRow(
                              message: m,
                              mine: mine,
                              myUserId: myId,
                              onTap: (String emoji) =>
                                  _toggleReaction(m, emoji),
                            ),
                        ],
                      );
                    },
                  ),
          ),
          _composer(),
        ],
      ),
    );
  }

  Widget _composer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColours.surface,
        border: Border(top: BorderSide(color: AppColours.border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            if (_replyTo != null) ...<Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
                decoration: BoxDecoration(
                  color: AppColours.surfaceMuted,
                  borderRadius: AppRadii.md,
                  border: const Border(
                    left: BorderSide(color: AppColours.primary, width: 3),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Replying to ${_replyTo!.authorName}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColours.primary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _replyTo!.body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColours.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(() => _replyTo = null),
                      icon: const Icon(Icons.close_rounded, size: 18),
                      tooltip: 'Cancel reply',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            if (_pendingAttachment != null) ...<Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColours.surfaceMuted,
                  borderRadius: AppRadii.md,
                  border: const Border(
                    left: BorderSide(color: AppColours.accent, width: 3),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    if (_pendingAttachmentType == GroupAttachmentType.image)
                      ClipRRect(
                        borderRadius: AppRadii.sm,
                        child: Image.memory(
                          _pendingAttachment!.bytes!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColours.accent.withValues(alpha: 0.14),
                          borderRadius: AppRadii.sm,
                        ),
                        child: Icon(
                          _pendingAttachmentType == GroupAttachmentType.voice
                              ? Icons.mic_rounded
                              : Icons.insert_drive_file_rounded,
                          color: AppColours.accent,
                          size: 20,
                        ),
                      ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _pendingAttachmentType == GroupAttachmentType.voice
                                ? 'Voice note · ${_formatDuration(Duration(milliseconds: _pendingAttachmentDurationMs))}'
                                : _pendingAttachment!.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: AppColours.text,
                            ),
                          ),
                          Text(
                            _uploading ? 'Uploading…' : 'Ready to send',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColours.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!_uploading)
                      IconButton(
                        onPressed: () => setState(() {
                          _pendingAttachment = null;
                          _pendingAttachmentType = null;
                          _pendingAttachmentDurationMs = 0;
                        }),
                        icon: const Icon(Icons.close_rounded, size: 18),
                        tooltip: _pendingAttachmentType ==
                                GroupAttachmentType.voice
                            ? 'Discard voice note'
                            : 'Remove attachment',
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
            ],
            // Marking a message as a question makes it findable later, which
            // is the difference between a group chat and a study group.
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () =>
                      setState(() => _askingQuestion = !_askingQuestion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: _askingQuestion
                          ? AppColours.accent
                          : AppColours.surfaceMuted,
                      borderRadius: AppRadii.pill,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.help_rounded,
                          size: 13,
                          color: _askingQuestion
                              ? Colors.white
                              : AppColours.textMuted,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _askingQuestion
                              ? 'Sending as a question'
                              : 'Mark as question',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: _askingQuestion
                                ? Colors.white
                                : AppColours.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            if (_recording) _recordingBar() else _inputRow(),
            if (_showEmojiPicker && !_recording)
              SizedBox(
                height: 256,
                child: EmojiPicker(
                  textEditingController: _input,
                  config: Config(
                    height: 256,
                    emojiViewConfig: const EmojiViewConfig(emojiSizeMax: 26),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// The ordinary composer: attach, mic, message field, send.
  Widget _inputRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Material(
          color: AppColours.surfaceMuted,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: _pendingAttachment != null || _sending
                ? null
                : _pickAttachment,
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(11),
              child: Icon(
                Icons.attach_file_rounded,
                size: 20,
                color: AppColours.textMuted,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Material(
          color: AppColours.surfaceMuted,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: _pendingAttachment != null || _sending
                ? null
                : _startRecording,
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(11),
              child: Icon(
                Icons.mic_none_rounded,
                size: 20,
                color: AppColours.textMuted,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: TextField(
            controller: _input,
            focusNode: _inputFocus,
            minLines: 1,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            onTap: () {
              if (_showEmojiPicker) setState(() => _showEmojiPicker = false);
            },
            decoration: InputDecoration(
              hintText: _pendingAttachment != null
                  ? 'Add a caption (optional)…'
                  : _askingQuestion
                  ? 'Ask your question…'
                  : 'Message the group…',
              fillColor: AppColours.surfaceMuted,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 12,
              ),
              // Toggling the emoji panel drops the keyboard first — the two
              // fighting for the bottom of the screen at once is what makes
              // a picker feel broken rather than just a second keyboard.
              prefixIcon: IconButton(
                onPressed: () {
                  final bool opening = !_showEmojiPicker;
                  setState(() => _showEmojiPicker = opening);
                  if (opening) {
                    _inputFocus.unfocus();
                  } else {
                    _inputFocus.requestFocus();
                  }
                },
                icon: Icon(
                  _showEmojiPicker
                      ? Icons.keyboard_rounded
                      : Icons.emoji_emotions_outlined,
                  size: 21,
                  color: AppColours.textMuted,
                ),
                tooltip: _showEmojiPicker ? 'Show keyboard' : 'Emoji',
              ),
              border: const OutlineInputBorder(
                borderRadius: AppRadii.xl,
                borderSide: BorderSide.none,
              ),
              enabledBorder: const OutlineInputBorder(
                borderRadius: AppRadii.xl,
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: AppRadii.xl,
                borderSide: BorderSide(
                  color: AppColours.primary,
                  width: 1.4,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Material(
          color: _askingQuestion ? AppColours.accent : AppColours.primary,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: _sending ? null : _send,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(11),
              child: _sending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.send_rounded,
                      size: 20,
                      color: Colors.white,
                    ),
            ),
          ),
        ),
      ],
    );
  }

  /// Replaces the whole composer while the microphone is live: a pulsing
  /// dot and running timer make it unmistakable that recording is actually
  /// happening, and cancel sits well clear of send so a slip of the thumb
  /// does not post a voice note nobody meant to keep.
  Widget _recordingBar() {
    return Row(
      children: <Widget>[
        Material(
          color: AppColours.danger.withValues(alpha: 0.12),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () => _stopRecording(send: false),
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(11),
              child: Icon(
                Icons.delete_outline_rounded,
                size: 20,
                color: AppColours.danger,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: AppColours.surfaceMuted,
              borderRadius: AppRadii.xl,
            ),
            child: Row(
              children: <Widget>[
                _PulsingDot(),
                const SizedBox(width: 10),
                Text(
                  'Recording ${_formatDuration(_recordElapsed)}',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColours.text,
                  ),
                ),
                const Spacer(),
                Text(
                  '${AppConfig.maxVoiceNoteSeconds ~/ 60}:${(AppConfig.maxVoiceNoteSeconds % 60).toString().padLeft(2, '0')} max',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColours.textFaint,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Material(
          color: AppColours.primary,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: () => _stopRecording(send: true),
            customBorder: const CircleBorder(),
            child: const Padding(
              padding: EdgeInsets.all(11),
              child: Icon(Icons.check_rounded, size: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

/// A small dot that fades in and out on a loop, the cheapest possible signal
/// that something live is happening — the same shorthand every recording app
/// uses, so nobody has to learn a new one here.
class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
      child: Container(
        width: 9,
        height: 9,
        decoration: const BoxDecoration(
          color: AppColours.danger,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// Groups a run of messages under the day they were sent, so scrolling back
/// through a busy week stays legible.
class _DayDivider extends StatelessWidget {
  const _DayDivider({required this.day});

  final DateTime day;

  String get _label {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime that = DateTime(day.year, day.month, day.day);
    final int difference = today.difference(that).inDays;

    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    if (difference < 7) return _weekdays[that.weekday - 1];
    return '${that.day} ${_months[that.month - 1]} ${that.year}';
  }

  static const List<String> _weekdays = <String>[
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  static const List<String> _months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColours.surfaceMuted,
            borderRadius: AppRadii.pill,
          ),
          child: Text(
            _label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColours.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

/// The quoted original above a reply. The text is stored on the reply itself,
/// so this still reads correctly after the original has been deleted.
class _QuotedReply extends StatelessWidget {
  const _QuotedReply({required this.message, required this.mine});

  final GroupMessage message;
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: mine ? 48 : 14,
        right: mine ? 14 : 48,
        bottom: 2,
      ),
      child: Align(
        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.fromLTRB(9, 6, 10, 6),
          decoration: BoxDecoration(
            color: AppColours.surfaceMuted,
            borderRadius: AppRadii.sm,
            border: const Border(
              left: BorderSide(color: AppColours.primary, width: 2.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                message.replyToAuthor,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: AppColours.primary,
                ),
              ),
              const SizedBox(height: 1),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 230),
                child: Text(
                  message.replyToBody,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColours.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A deleted message keeps its place so replies above it still make sense.
class _DeletedBubble extends StatelessWidget {
  const _DeletedBubble({required this.mine});

  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 14),
      child: Align(
        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
          decoration: BoxDecoration(
            color: AppColours.surfaceMuted,
            borderRadius: AppRadii.lg,
            border: Border.all(color: AppColours.border),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.block_rounded,
                size: 14,
                color: AppColours.textFaint,
              ),
              SizedBox(width: 6),
              Text(
                'This message was deleted',
                style: TextStyle(
                  fontSize: 12.5,
                  fontStyle: FontStyle.italic,
                  color: AppColours.textFaint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A photo shown inline, or a document card, in the same bubble language as
/// an ordinary text message. Tapping either opens it — a photo full-size in
/// the browser or gallery, a document in whatever app the phone hands it to.
class _AttachmentBubble extends StatelessWidget {
  const _AttachmentBubble({
    required this.message,
    required this.mine,
    required this.showSenderName,
  });

  final GroupMessage message;
  final bool mine;
  final bool showSenderName;

  Future<void> _open() async {
    final Uri uri = Uri.tryParse(message.attachmentUrl) ?? Uri();
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool image = message.isImageAttachment;
    final bool voice = message.isVoiceAttachment;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: mine
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: <Widget>[
          if (showSenderName)
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 3),
              child: Text(
                message.authorName,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColours.primary,
                ),
              ),
            ),
          Align(
            alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              child: GestureDetector(
                onTap: voice ? null : _open,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: mine ? AppColours.primary : AppColours.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(mine ? 18 : 5),
                      bottomRight: Radius.circular(mine ? 5 : 18),
                    ),
                    boxShadow: AppShadows.subtle,
                    border: mine
                        ? null
                        : Border.all(color: AppColours.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (image)
                        AspectRatio(
                          aspectRatio: 4 / 3,
                          child: Image.network(
                            message.attachmentUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: AppColours.surfaceMuted,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.broken_image_rounded,
                                color: AppColours.textFaint,
                              ),
                            ),
                            loadingBuilder:
                                (
                                  BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? progress,
                                ) => progress == null
                                ? child
                                : const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(28),
                                      child: SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                        )
                      else if (voice)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 8, 14, 8),
                          child: _VoicePlayer(
                            url: message.attachmentUrl,
                            totalDuration: Duration(
                              milliseconds: message.attachmentDurationMs,
                            ),
                            mine: mine,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color:
                                      (mine ? Colors.white : AppColours.primary)
                                          .withValues(alpha: mine ? 0.18 : 0.10),
                                  borderRadius: AppRadii.sm,
                                ),
                                child: Icon(
                                  Icons.insert_drive_file_rounded,
                                  color: mine ? Colors.white : AppColours.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      message.attachmentName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: mine
                                            ? Colors.white
                                            : AppColours.text,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _fileSize(message.attachmentSize),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: mine
                                            ? Colors.white.withValues(alpha: 0.75)
                                            : AppColours.textMuted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (message.body.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                            14,
                            image ? 10 : 0,
                            14,
                            4,
                          ),
                          child: Text(
                            message.body,
                            style: TextStyle(
                              fontSize: 14.5,
                              height: 1.4,
                              color: mine ? Colors.white : AppColours.text,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                        child: Text(
                          _time(message.sentAt),
                          style: TextStyle(
                            fontSize: 10,
                            color: mine
                                ? Colors.white.withValues(alpha: 0.7)
                                : AppColours.textFaint,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _fileSize(int bytes) {
    if (bytes <= 0) return '';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static String _time(DateTime moment) {
    final int hour = moment.hour % 12 == 0 ? 12 : moment.hour % 12;
    final String minute = moment.minute.toString().padLeft(2, '0');
    final String period = moment.hour < 12 ? 'am' : 'pm';
    return '$hour:$minute $period';
  }
}

/// The emoji picked under a message, each showing how many members chose it.
/// Tapping one joins it — or, if it is already this student's, removes it.
class _ReactionsRow extends StatelessWidget {
  const _ReactionsRow({
    required this.message,
    required this.mine,
    required this.myUserId,
    required this.onTap,
  });

  final GroupMessage message;
  final bool mine;
  final String myUserId;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final List<MapEntry<String, List<GroupMessageReaction>>> groups =
        message.reactionGroups;
    if (groups.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(
        left: mine ? 0 : 14,
        right: mine ? 14 : 0,
        bottom: 6,
      ),
      child: Align(
        alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
        child: Wrap(
          spacing: 5,
          runSpacing: 4,
          children: groups.map((
            MapEntry<String, List<GroupMessageReaction>> entry,
          ) {
            final bool isMine = entry.value.any(
              (GroupMessageReaction r) => r.userId == myUserId,
            );
            return GestureDetector(
              onTap: () => onTap(entry.key),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: isMine
                      ? AppColours.primaryTint
                      : AppColours.surfaceMuted,
                  borderRadius: AppRadii.pill,
                  border: Border.all(
                    color: isMine
                        ? AppColours.primarySoft
                        : AppColours.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(entry.key, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 3),
                    Text(
                      '${entry.value.length}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: isMine
                            ? AppColours.primary
                            : AppColours.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Play/pause and a scrub bar for a voice note. The player itself is not
/// created until the first tap: a busy thread can hold dozens of voice
/// messages, and standing up an [AudioPlayer] — and the platform decoder
/// behind it — for every one of them the moment the screen opens would be a
/// lot of dead weight for notes nobody ever plays.
class _VoicePlayer extends StatefulWidget {
  const _VoicePlayer({
    required this.url,
    required this.totalDuration,
    required this.mine,
  });

  final String url;
  final Duration totalDuration;
  final bool mine;

  @override
  State<_VoicePlayer> createState() => _VoicePlayerState();
}

class _VoicePlayerState extends State<_VoicePlayer> {
  AudioPlayer? _player;
  bool _loading = false;
  Duration _position = Duration.zero;
  bool _playing = false;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;

  @override
  void dispose() {
    _positionSub?.cancel();
    _stateSub?.cancel();
    _player?.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    AudioPlayer? player = _player;

    if (player == null) {
      setState(() => _loading = true);
      player = AudioPlayer();
      try {
        await player.setUrl(widget.url);
      } catch (_) {
        if (mounted) {
          setState(() => _loading = false);
          showEduvoraSnack(
            context,
            'That voice note could not be played just now.',
            isError: true,
          );
        }
        await player.dispose();
        return;
      }
      if (!mounted) {
        await player.dispose();
        return;
      }
      _player = player;
      _positionSub = player.positionStream.listen((Duration p) {
        if (mounted) setState(() => _position = p);
      });
      // A note that finishes stays finished rather than sitting on "playing"
      // with a frozen scrubber — tapping again starts it over from the top.
      _stateSub = player.playerStateStream.listen((PlayerState state) {
        if (!mounted) return;
        setState(() => _playing = state.playing);
        if (state.processingState == ProcessingState.completed) {
          player!.seek(Duration.zero);
          setState(() {
            _playing = false;
            _position = Duration.zero;
          });
        }
      });
      setState(() => _loading = false);
      await player.play();
      return;
    }

    if (_playing) {
      await player.pause();
    } else {
      await player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color fg = widget.mine ? Colors.white : AppColours.primary;
    final Color track = widget.mine
        ? Colors.white.withValues(alpha: 0.35)
        : AppColours.primarySoft;
    final Duration total = widget.totalDuration > Duration.zero
        ? widget.totalDuration
        : _position;
    final double progress = total.inMilliseconds == 0
        ? 0
        : (_position.inMilliseconds / total.inMilliseconds).clamp(0, 1);

    return SizedBox(
      width: 200,
      child: Row(
        children: <Widget>[
          Material(
            color: fg.withValues(alpha: widget.mine ? 0.22 : 0.12),
            shape: const CircleBorder(),
            child: InkWell(
              onTap: _loading ? null : _toggle,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _loading
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(fg),
                        ),
                      )
                    : Icon(
                        _playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        color: fg,
                        size: 20,
                      ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: LinearProgressIndicator(
                    value: progress.toDouble(),
                    minHeight: 4,
                    backgroundColor: track,
                    valueColor: AlwaysStoppedAnimation<Color>(fg),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDuration(_playing || _position > Duration.zero
                      ? _position
                      : total),
                  style: TextStyle(
                    fontSize: 10.5,
                    color: widget.mine
                        ? Colors.white.withValues(alpha: 0.75)
                        : AppColours.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
