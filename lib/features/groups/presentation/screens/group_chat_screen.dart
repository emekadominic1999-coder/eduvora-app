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

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final List<GroupMessage> messages = await _repo.messages(widget.group.id);
    if (!mounted) return;
    setState(() {
      _messages = messages;
      _loading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom());
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

    setState(() => _sending = true);
    _input.clear();

    try {
      await _repo.sendMessage(
        profile: profile,
        groupId: widget.group.id,
        body: body,
        isQuestion: _askingQuestion,
      );
      final List<GroupMessage> messages = await _repo.messages(
        widget.group.id,
      );
      if (!mounted) return;
      setState(() {
        _messages = messages;
        _askingQuestion = false;
      });
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _toBottom(animate: true));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _showMembers() async {
    final List<GroupMember> members = await _repo.members(widget.group.id);
    if (!mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        builder: (BuildContext context, ScrollController controller) => Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.sm,
                AppSpacing.xl,
                AppSpacing.md,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Members',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Pill(label: '${members.length}'),
                ],
              ),
            ),
            Expanded(
              child: members.isEmpty
                  ? const EmptyState(
                      icon: Icons.person_outline_rounded,
                      title: 'No members listed',
                      message:
                          'Members appear here once the group has synced.',
                      compact: true,
                    )
                  : ListView.builder(
                      controller: controller,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                      ),
                      itemCount: members.length,
                      itemBuilder: (BuildContext context, int i) {
                        final GroupMember m = members[i];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: InitialsAvatar(initials: m.initials),
                          title: Text(m.fullName),
                          subtitle: m.headline.isEmpty
                              ? null
                              : Text(
                                  m.headline,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                          trailing: m.isAdmin
                              ? const Pill(label: 'Admin', dense: true)
                              : null,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

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
                  title: Text('View members'),
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

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (m.isQuestion)
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
                          MessageBubble(
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
