import 'package:flutter/material.dart';

import '../../../../core/models/chat.dart';
import '../../../../core/theme/app_theme.dart';

/// One message in a thread.
///
/// The student's own messages sit right in royal blue; everyone else, and
/// Ada, sit left on white.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    this.showSenderName = false,
  });

  final ChatMessage message;
  final bool showSenderName;

  bool get _isAssistant => message.author == MessageAuthor.assistant;

  @override
  Widget build(BuildContext context) {
    final bool mine = message.isMine;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment:
            mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          if (showSenderName)
            Padding(
              padding: const EdgeInsets.only(left: 14, bottom: 3),
              child: Text(
                message.senderName,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColours.primary,
                ),
              ),
            ),
          Row(
            mainAxisAlignment:
                mine ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              if (_isAssistant) ...<Widget>[
                Container(
                  width: 26,
                  height: 26,
                  margin: const EdgeInsets.only(right: 7, bottom: 2),
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
              ],
              Flexible(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
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
                      children: <Widget>[
                        _RichBody(
                          text: message.body,
                          colour: mine ? Colors.white : AppColours.text,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _time(message.sentAt),
                          style: TextStyle(
                            fontSize: 10,
                            color: mine
                                ? Colors.white.withValues(alpha: 0.7)
                                : AppColours.textFaint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _time(DateTime moment) {
    final int hour = moment.hour % 12 == 0 ? 12 : moment.hour % 12;
    final String minute = moment.minute.toString().padLeft(2, '0');
    final String period = moment.hour < 12 ? 'am' : 'pm';
    return '$hour:$minute $period';
  }
}

/// Renders the light `**bold**` emphasis Ada uses in her replies.
class _RichBody extends StatelessWidget {
  const _RichBody({required this.text, required this.colour});

  final String text;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    final List<TextSpan> spans = <TextSpan>[];
    final RegExp bold = RegExp(r'\*\*(.+?)\*\*', dotAll: true);
    int cursor = 0;

    for (final RegExpMatch match in bold.allMatches(text)) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      );
      cursor = match.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    // Text.rich rather than RichText so the bubble honours the system text
    // scale and the ambient default style.
    return Text.rich(
      TextSpan(
        children: spans.isEmpty ? <TextSpan>[TextSpan(text: text)] : spans,
      ),
      style: TextStyle(
        fontSize: 14.5,
        height: 1.55,
        color: colour,
      ),
    );
  }
}
