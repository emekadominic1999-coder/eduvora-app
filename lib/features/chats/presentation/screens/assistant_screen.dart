import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/chat.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/eduvora_ai.dart';
import '../../../../core/services/local_store.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/message_bubble.dart';

/// Ada — the Eduvora assistant.
///
/// She answers questions about finding your way around the app, and she
/// responds with warmth when a student says the term is going badly. Her
/// replies run on the device, so she is available with no network at all.
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  static const Uuid _uuid = Uuid();

  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  final List<ChatMessage> _messages = <ChatMessage>[];
  List<String> _suggestions = EduvoraAi.starterPrompts;
  String? _pendingRoute;
  String? _pendingRouteLabel;
  bool _thinking = false;
  Timer? _replyTimer;

  @override
  void initState() {
    super.initState();
    _restore();
  }

  @override
  void dispose() {
    _replyTimer?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _restore() {
    final List<ChatMessage> saved = LocalStore.instance
        .readList(StoreKeys.aiHistory)
        .map(ChatMessage.fromJson)
        .toList();

    if (saved.isEmpty) {
      _messages.add(
        ChatMessage(
          id: _uuid.v4(),
          conversationId: 'ada',
          author: MessageAuthor.assistant,
          senderName: EduvoraAi.assistantName,
          body: EduvoraAi.greeting,
          sentAt: DateTime.now(),
        ),
      );
      _persist();
    } else {
      _messages.addAll(saved);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _toBottom());
  }

  Future<void> _persist() async {
    // Keep the tail only; the whole history is not worth carrying about.
    final List<ChatMessage> tail = _messages.length > 60
        ? _messages.sublist(_messages.length - 60)
        : _messages;
    await LocalStore.instance.writeList(
      StoreKeys.aiHistory,
      tail.map((ChatMessage m) => m.toJson()).toList(),
    );
  }

  void _toBottom({bool animate = false}) {
    if (!_scroll.hasClients) return;
    final double target = _scroll.position.maxScrollExtent + 120;
    if (animate) {
      _scroll.animateTo(
        target.clamp(0.0, _scroll.position.maxScrollExtent),
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    } else {
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    }
  }

  void _ask(String text) {
    final String question = text.trim();
    if (question.isEmpty || _thinking) return;

    _input.clear();
    setState(() {
      _messages.add(
        ChatMessage(
          id: _uuid.v4(),
          conversationId: 'ada',
          author: MessageAuthor.student,
          senderName: 'You',
          body: question,
          sentAt: DateTime.now(),
        ),
      );
      _thinking = true;
      _suggestions = const <String>[];
      _pendingRoute = null;
      _pendingRouteLabel = null;
    });
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _toBottom(animate: true));

    // A short pause so the conversation feels considered rather than instant.
    _replyTimer?.cancel();
    _replyTimer = Timer(const Duration(milliseconds: 620), () {
      if (!mounted) return;
      final AiReply reply =
          EduvoraAi.respond(question, sessionController.profile);
      setState(() {
        _thinking = false;
        _messages.add(
          ChatMessage(
            id: _uuid.v4(),
            conversationId: 'ada',
            author: MessageAuthor.assistant,
            senderName: EduvoraAi.assistantName,
            body: reply.message,
            sentAt: DateTime.now(),
          ),
        );
        _suggestions = reply.suggestions;
        _pendingRoute = reply.route;
        _pendingRouteLabel = reply.routeLabel;
      });
      _persist();
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _toBottom(animate: true));
    });
  }

  Future<void> _clear() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Clear this conversation?'),
        content: const Text(
          'Our chat will start afresh. Nothing else in Eduvora is affected.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColours.danger),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (!(confirm ?? false)) return;

    await LocalStore.instance.remove(StoreKeys.aiHistory);
    setState(() {
      _messages.clear();
      _suggestions = EduvoraAi.starterPrompts;
      _pendingRoute = null;
      _pendingRouteLabel = null;
    });
    _restore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                gradient: AppColours.accentGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 19,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Ada',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColours.text,
                    ),
                  ),
                  Text(
                    _thinking ? 'Typing…' : 'Your Eduvora companion',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: _thinking
                          ? AppColours.success
                          : AppColours.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _clear,
            icon: const Icon(Icons.delete_outline_rounded),
            tooltip: 'Clear conversation',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.md,
              ),
              children: <Widget>[
                ..._messages.map(
                  (ChatMessage m) => MessageBubble(message: m),
                ),
                if (_thinking) const _TypingBubble(),
                if (_pendingRoute != null && _pendingRouteLabel != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 33,
                      top: AppSpacing.xs,
                      bottom: AppSpacing.sm,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FilledButton.tonalIcon(
                        onPressed: () {
                          final String route = _pendingRoute!;
                          Navigator.of(context).pop();
                          AppRouter.go(context, route);
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColours.primaryTint,
                          foregroundColor: AppColours.primary,
                          minimumSize: const Size(0, 42),
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                        ),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 17),
                        label: Text(_pendingRouteLabel!),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (_suggestions.isNotEmpty) _suggestionRow(),
          _composer(),
        ],
      ),
    );
  }

  Widget _suggestionRow() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          0,
          AppSpacing.md,
          AppSpacing.sm,
        ),
        itemCount: _suggestions.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (BuildContext context, int index) {
          return Material(
            color: AppColours.surface,
            borderRadius: AppRadii.pill,
            child: InkWell(
              onTap: () => _ask(_suggestions[index]),
              borderRadius: AppRadii.pill,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: AppRadii.pill,
                  border: Border.all(color: AppColours.primarySoft),
                ),
                child: Center(
                  child: Text(
                    _suggestions[index],
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColours.primary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
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
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: _ask,
                decoration: const InputDecoration(
                  hintText: 'Ask Ada anything…',
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
              color: _thinking ? AppColours.borderStrong : AppColours.accent,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () => _ask(_input.text),
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

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: <Widget>[
          Container(
            width: 26,
            height: 26,
            margin: const EdgeInsets.only(right: 7),
            decoration: const BoxDecoration(
              gradient: AppColours.accentGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 13,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColours.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(5),
              ),
              border: Border.all(color: AppColours.border),
              boxShadow: AppShadows.subtle,
            ),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, _) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(3, (int i) {
                    final double t =
                        ((_controller.value * 3) - i).clamp(0.0, 1.0);
                    final double scale =
                        0.7 + 0.5 * (t < 0.5 ? t * 2 : (1 - t) * 2);
                    return Container(
                      width: 7,
                      height: 7,
                      margin: EdgeInsets.only(right: i == 2 ? 0 : 5),
                      transform: Matrix4.diagonal3Values(scale, scale, 1),
                      transformAlignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColours.accent.withValues(
                          alpha: 0.45 + 0.45 * scale.clamp(0.0, 1.0),
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
