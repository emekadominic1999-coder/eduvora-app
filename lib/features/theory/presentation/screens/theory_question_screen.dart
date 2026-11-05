import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/models/theory.dart';
import '../../../../core/services/local_store.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'theory_course_screen.dart';

/// Answer on paper (or aloud), then reveal the marking guide and self-mark.
class TheoryQuestionScreen extends StatefulWidget {
  const TheoryQuestionScreen({super.key, required this.question});

  final TheoryQuestion question;

  @override
  State<TheoryQuestionScreen> createState() => _TheoryQuestionScreenState();
}

class _TheoryQuestionScreenState extends State<TheoryQuestionScreen> {
  Timer? _timer;
  int _seconds = 0;
  bool _revealed = false;
  late final List<bool> _ticked = List<bool>.filled(
    widget.question.keyPoints.length,
    false,
  );

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && !_revealed) setState(() => _seconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  int get _score {
    int total = 0;
    for (int i = 0; i < _ticked.length; i++) {
      if (_ticked[i]) total += widget.question.keyPoints[i].marks;
    }
    return total;
  }

  String get _clock {
    final String m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final String s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> _saveBest() async {
    if (!LocalStore.isReady) return;
    final String key = theoryScoreKey(widget.question.id);
    final int old =
        int.tryParse(LocalStore.instance.readString(key) ?? '') ?? -1;
    if (_score > old) await LocalStore.instance.writeString(key, '$_score');
  }

  @override
  Widget build(BuildContext context) {
    final TheoryQuestion q = widget.question;
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: Text('${q.courseCode} theory'),
        actions: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: AppSpacing.lg),
              child: Text(
                _clock,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
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
          const SizedBox(height: AppSpacing.md),
          if (!_revealed) ...<Widget>[
            const EduvoraCard(
              colour: AppColours.primaryTint,
              child: Text(
                'Write your answer on paper, or say it aloud, as if you were '
                'in the exam hall. When you are done, reveal the marking '
                'guide.',
                style: TextStyle(height: 1.4),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColours.primary,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => setState(() => _revealed = true),
              child: const Text('I have answered. Show marking guide'),
            ),
          ] else ...<Widget>[
            const Text(
              'Tick the points you covered',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: AppSpacing.sm),
            for (int i = 0; i < q.keyPoints.length; i++)
              CheckboxListTile(
                value: _ticked[i],
                onChanged: (bool? v) {
                  setState(() => _ticked[i] = v ?? false);
                  unawaited(_saveBest());
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: Text(q.keyPoints[i].text),
                subtitle: Text(
                  q.keyPoints[i].marks == 1
                      ? '1 mark'
                      : '${q.keyPoints[i].marks} marks',
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            EduvoraCard(
              colour: _score * 2 >= q.marks
                  ? AppColours.successSoft
                  : AppColours.warningSoft,
              child: Text(
                'Your score: $_score / ${q.marks}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text(
              'Model answer',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            const SizedBox(height: AppSpacing.sm),
            EduvoraCard(
              child: SelectableText(
                q.modelAnswer,
                style: const TextStyle(height: 1.5),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            OutlinedButton(
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
