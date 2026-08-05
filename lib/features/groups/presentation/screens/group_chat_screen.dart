import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/models/chat.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/models/study_group.dart';
import '../../../../core/services/group_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../chats/presentation/widgets/message_bubble.dart';
import 'group_info_screen.dart';

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

  /// True when the signed-in student is an admin here — admins may delete
  /// anybody's message, not only their own.
  bool _iAmAdmin = false;

  StreamSubscription<GroupMessage>? _live;

  @override
  void initState() {
    super.initState();
    _load();
    _listen();
  }

  @override
  void dispose() {
    _live?.cancel();
    _input.dispose();
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
  static List<GroupMessage> _merge(
    List<GroupMessage> current,
    GroupMessage incoming,
  ) {
    final List<GroupMessage> next = List<GroupMessage>.from(current);
    final int at = next.indexWhere((GroupMessage m) => m.id == incoming.id);
    if (at >= 0) {
      next[at] = incoming;
    } else {
      next.add(incoming);
    }
    return next
      ..sort((GroupMessage a, GroupMessage b) => a.sentAt.compareTo(b.sentAt));
  }

  Future<void> _load() async {
    final StudentProfile? me = sessionController.profile;
    final List<GroupMessage> messages = await _repo.messages(widget.group.id);
    final List<GroupMember> members = await _repo.members(widget.group.id);
    if (!mounted) return;

    setState(() {
      _messages = messages;
      _iAmAdmin = members.any(
        (GroupMember m) => m.userId == me?.id && m.isAdmin,
      );
      _loading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom());
  }

  /// Long-press actions on a message: reply, copy, delete.
  Future<void> _messageActions(GroupMessage message) async {
    if (message.isDeleted) return;

    final String myId = sessionController.profile?.id ?? '';
    final bool canDelete = message.authorId == myId || _iAmAdmin;

    final String? action = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.reply_rounded),
              title: const Text('Reply'),
              onTap: () => Navigator.of(context).pop('reply'),
            ),
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
    if (body.isEmpty || _sending) return;

    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    final GroupMessage? replyTo = _replyTo;
    setState(() => _sending = true);
    _input.clear();

    try {
      final GroupMessage sent = await _repo.sendMessage(
        profile: profile,
        groupId: widget.group.id,
        body: body,
        isQuestion: _askingQuestion,
        replyTo: replyTo,
      );
      if (!mounted) return;
      setState(() {
        _messages = _merge(_messages, sent);
        _askingQuestion = false;
        _replyTo = null;
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
      if (mounted) setState(() => _sending = false);
    }
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _input,
                    minLines: 1,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: _askingQuestion
                          ? 'Ask your question…'
                          : 'Message the group…',
                      fillColor: AppColours.surfaceMuted,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: 12,
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
                  color: _askingQuestion
                      ? AppColours.accent
                      : AppColours.primary,
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
            ),
          ],
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
