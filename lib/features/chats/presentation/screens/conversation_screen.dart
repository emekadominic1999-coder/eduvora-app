import 'package:flutter/material.dart';

import '../../../../core/models/chat.dart';
import '../../../../core/services/chat_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../widgets/message_bubble.dart';

/// A one-to-one thread or study group conversation.
class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key, required this.conversation});

  final Conversation conversation;

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  static const ChatRepository _repo = ChatRepository();

  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  late List<ChatMessage> _messages;

  @override
  void initState() {
    super.initState();
    _messages = _repo.messages(widget.conversation.id);
    WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom());
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
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
    if (body.isEmpty) return;

    _input.clear();
    await _repo.send(
      conversationId: widget.conversation.id,
      body: body,
      author: MessageAuthor.student,
      senderName: sessionController.profile?.fullName ?? 'You',
    );
    setState(() => _messages = _repo.messages(widget.conversation.id));
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _toBottom(animate: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            if (widget.conversation.isGroup)
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColours.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  color: AppColours.primary,
                  size: 18,
                ),
              )
            else
              InitialsAvatar(
                initials: widget.conversation.title.isEmpty
                    ? 'S'
                    : widget.conversation.title.substring(0, 1).toUpperCase(),
                size: 36,
              ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.conversation.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      color: AppColours.text,
                    ),
                  ),
                  Text(
                    widget.conversation.isGroup
                        ? '${widget.conversation.members} members'
                        : widget.conversation.subtitle,
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _messages.isEmpty
                ? const EmptyState(
                    icon: Icons.waving_hand_rounded,
                    title: 'Say hello',
                    message:
                        'Nothing here yet. Start the conversation — someone '
                        'will be glad you did.',
                  )
                : ListView.builder(
                    controller: _scroll,
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ChatMessage m = _messages[index];
                      final bool showName = widget.conversation.isGroup &&
                          !m.isMine &&
                          (index == 0 ||
                              _messages[index - 1].senderName != m.senderName);
                      return MessageBubble(
                        message: m,
                        showSenderName: showName,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _input,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (_) => _send(),
                decoration: const InputDecoration(
                  hintText: 'Type a message…',
                  fillColor: AppColours.surfaceMuted,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.xl,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadii.xl,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadii.xl,
                    borderSide:
                        BorderSide(color: AppColours.primary, width: 1.4),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Material(
              color: AppColours.primary,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: _send,
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(11),
                  child: Icon(
                    Icons.send_rounded,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
