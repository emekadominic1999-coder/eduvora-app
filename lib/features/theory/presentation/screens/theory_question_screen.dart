import 'package:flutter/material.dart';

import '../../../../core/models/theory.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// One theory question: read it, think it through, then show the answer.
class TheoryQuestionScreen extends StatefulWidget {
  const TheoryQuestionScreen({
    super.key,
    required this.questions,
    required this.index,
  });

  final List<TheoryQuestion> questions;
  final int index;

  @override
  State<TheoryQuestionScreen> createState() => _TheoryQuestionScreenState();
}

class _TheoryQuestionScreenState extends State<TheoryQuestionScreen> {
  bool _revealed = false;

  TheoryQuestion get _q => widget.questions[widget.index];
  bool get _hasNext => widget.index + 1 < widget.questions.length;

  void _next() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => TheoryQuestionScreen(
          questions: widget.questions,
          index: widget.index + 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TheoryQuestion q = _q;
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: Text('${q.courseCode} theory'),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: Text(
                '${widget.index + 1} of ${widget.questions.length}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColours.textMuted,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: <Widget>[
          EduvoraCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${q.topic.isEmpty ? 'Theory' : q.topic}  -  ${q.marks} marks',
                  style: const TextStyle(
                    color: AppColours.textMuted,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  q.question,
                  style: const TextStyle(
                    fontSize: 17,
                    height: 1.45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (!_revealed)
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColours.primary,
                minimumSize: const Size.fromHeight(52),
              ),
              onPressed: () => setState(() => _revealed = true),
              child: const Text('Show answer'),
            )
          else ...<Widget>[
            const Text(
              'Answer',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: AppSpacing.sm),
            EduvoraCard(
              child: SelectableText(
                q.modelAnswer,
                style: const TextStyle(fontSize: 15, height: 1.55),
              ),
            ),
            if (q.keyPoints.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Key points to remember',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.sm),
              EduvoraCard(
                colour: AppColours.primaryTint,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    for (final TheoryKeyPoint p in q.keyPoints)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding: EdgeInsets.only(top: 2, right: 8),
                              child: Icon(
                                Icons.check_circle_rounded,
                                size: 18,
                                color: AppColours.primary,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                p.text,
                                style: const TextStyle(height: 1.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            if (_hasNext)
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppColours.primary,
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: _next,
                child: const Text('Next question'),
              )
            else
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Back to questions'),
              ),
          ],
          const SizedBox(height: AppSpacing.xxxl),
        ],
      ),
    );
  }
}
