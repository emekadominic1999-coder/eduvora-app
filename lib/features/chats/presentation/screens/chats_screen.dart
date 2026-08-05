import 'package:flutter/material.dart';

import '../../../../core/models/chat.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/chat_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'assistant_screen.dart';
import 'conversation_screen.dart';

/// Study groups, one-to-one threads, and Ada pinned at the top.
class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with AutomaticKeepAliveClientMixin {
  static const ChatRepository _repo = ChatRepository();

  String _query = '';

  @override
  bool get wantKeepAlive => true;

  Future<void> _open(Conversation conversation) async {
    await _repo.markRead(conversation.id);
    if (!mounted) return;

    if (conversation.isAssistant) {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const AssistantScreen()));
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ConversationScreen(conversation: conversation),
        ),
      );
    }
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final StudentProfile? profile = sessionController.profile;

    if (profile == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final List<Conversation> all = _repo.conversations(profile);
    final String q = _query.trim().toLowerCase();
    final List<Conversation> conversations = q.isEmpty
        ? all
        : all
              .where(
                (Conversation c) =>
                    c.title.toLowerCase().contains(q) ||
                    c.subtitle.toLowerCase().contains(q),
              )
              .toList();

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        automaticallyImplyLeading: !widget.embedded,
        title: const Text('Chats'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.md,
              AppSpacing.screenPadding,
              AppSpacing.md,
            ),
            child: SearchField(
              hint: 'Search chats and study groups',
              onChanged: (String v) => setState(() => _query = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              AppSpacing.md,
            ),
            child: EduvoraCard(
              onTap: () =>
                  Navigator.of(context).pushNamed(AppRouter.groups),
              colour: AppColours.primaryTint,
              shadows: const <BoxShadow>[],
              border: Border.all(color: AppColours.primarySoft),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: AppColours.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.groups_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Your study groups',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Create one for your class, or join with a code',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColours.primary,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: conversations.isEmpty
                ? const EmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: 'No chats match',
                    message: 'Try a different word, or clear the search.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      0,
                      AppSpacing.screenPadding,
                      AppSpacing.xxl,
                    ),
                    itemCount: conversations.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.sm),
                    itemBuilder: (BuildContext context, int index) {
                      return _ConversationRow(
                        conversation: conversations[index],
                        onTap: () => _open(conversations[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _ConversationRow extends StatelessWidget {
  const _ConversationRow({required this.conversation, required this.onTap});

  final Conversation conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bool ada = conversation.isAssistant;

    return EduvoraCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      colour: ada ? AppColours.primaryTint : AppColours.surface,
      border: ada ? Border.all(color: AppColours.primarySoft) : null,
      child: Row(
        children: <Widget>[
          if (ada)
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                gradient: AppColours.accentGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 22,
              ),
            )
          else if (conversation.isGroup)
            Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                color: AppColours.primaryTint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups_rounded,
                color: AppColours.primary,
                size: 22,
              ),
            )
          else
            InitialsAvatar(initials: _initials(conversation.title), size: 46),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        conversation.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColours.text,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      relativeTime(conversation.lastActivity),
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: AppColours.textFaint,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        conversation.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: conversation.unread > 0
                              ? AppColours.text
                              : AppColours.textMuted,
                          fontWeight: conversation.unread > 0
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    if (conversation.unread > 0) ...<Widget>[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColours.accent,
                          borderRadius: AppRadii.pill,
                        ),
                        child: Text(
                          '${conversation.unread}',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (conversation.isGroup) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    '${conversation.members} members · '
                    '${conversation.subtitle}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColours.textFaint,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _initials(String name) {
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }
}
