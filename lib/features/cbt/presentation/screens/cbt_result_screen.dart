import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/math_text.dart';
import 'cbt_exam_screen.dart';

/// The score report and full answer review.
///
/// The review is where the learning happens, so it is the larger half of the
/// screen and every question shows the correct answer with its explanation —
/// including the ones the student got right.
class CbtResultScreen extends StatelessWidget {
  const CbtResultScreen({
    super.key,
    required this.subject,
    required this.attempt,
    required this.questions,
    this.config,
    this.autoSubmitted = false,
  });

  final CbtSubject subject;
  final CbtAttempt attempt;

  /// The paper as actually sat — after any shuffling or shortening — so the
  /// review matches what the student saw rather than the original order.
  final List<CbtQuestion> questions;

  /// Carried through so "Try again" repeats the same settings.
  final CbtExamConfig? config;
  final bool autoSubmitted;

  Color get _colour {
    final double p = attempt.percentage;
    if (p >= 70) return AppColours.success;
    if (p >= 50) return AppColours.info;
    if (p >= 40) return AppColours.warning;
    return AppColours.danger;
  }

  String get _message {
    final double p = attempt.percentage;
    if (p >= 80) {
      return 'Outstanding. You have this topic well in hand — keep the pace.';
    }
    if (p >= 70) {
      return 'A strong result. Read the review for the few you dropped and '
          'you will be very solid indeed.';
    }
    if (p >= 50) {
      return 'A decent foundation. Work through the explanations below and '
          'sit the paper again in a day or two.';
    }
    if (p >= 40) {
      return 'You are on the board, and that matters. The review below is '
          'where the marks are hiding — do read it slowly.';
    }
    return 'This one was hard going, and that is genuinely all right. Every '
        'question below has a full explanation. Take them one at a time.';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (!didPop) Navigator.of(context).pop(true);
      },
      child: Scaffold(
        backgroundColor: AppColours.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.of(context).pop(true),
          ),
          title: const Text('Your result'),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.md,
            AppSpacing.screenPadding,
            AppSpacing.lg,
          ),
          decoration: const BoxDecoration(
            color: AppColours.surface,
            border: Border(top: BorderSide(color: AppColours.border)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Done'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            CbtExamScreen(subject: subject, config: config),
                      ),
                    ),
                    child: const Text('Try again'),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: <Widget>[
            _scoreCard(context),
            if (autoSubmitted)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  AppSpacing.md,
                  AppSpacing.screenPadding,
                  0,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColours.warningSoft,
                    borderRadius: AppRadii.sm,
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.timer_off_rounded,
                        size: 18,
                        color: AppColours.warning,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Expanded(
                        child: Text(
                          'Time ran out, so the paper was submitted for you — '
                          'just as it would be in the hall.',
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.45,
                            color: Color(0xFF854D0E),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SectionHeader(
              title: 'Full review',
              subtitle: 'Every question, with the reasoning',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                children: List<Widget>.generate(questions.length, (int index) {
                  final CbtQuestion q = questions[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _ReviewCard(
                      number: index + 1,
                      question: q,
                      chosen: attempt.answers[q.id],
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scoreCard(BuildContext context) {
    final int minutes = attempt.durationSeconds ~/ 60;
    final int seconds = attempt.durationSeconds % 60;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: EduvoraCard(
        padding: const EdgeInsets.all(AppSpacing.xl),
        shadows: AppShadows.card,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: 128,
              height: 128,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 128,
                    height: 128,
                    child: CircularProgressIndicator(
                      value: attempt.percentage / 100,
                      strokeWidth: 10,
                      strokeCap: StrokeCap.round,
                      backgroundColor: AppColours.border,
                      valueColor: AlwaysStoppedAnimation<Color>(_colour),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '${attempt.percentage.round()}%',
                        style: TextStyle(
                          fontSize: 31,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          color: _colour,
                        ),
                      ),
                      Text(
                        'Grade ${attempt.grade}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColours.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              subject.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 5),
            Text(
              '${attempt.score} correct out of ${attempt.totalQuestions}  ·  '
              '${attempt.verdict}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _colour.withValues(alpha: 0.08),
                borderRadius: AppRadii.sm,
              ),
              child: Text(
                _message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.55,
                  color: AppColours.text,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _MetricCell(
                  icon: Icons.check_circle_outline_rounded,
                  value: '${attempt.score}',
                  label: 'Correct',
                  colour: AppColours.success,
                ),
                _MetricCell(
                  icon: Icons.cancel_outlined,
                  value: '${attempt.totalQuestions - attempt.score}',
                  label: 'Missed',
                  colour: AppColours.danger,
                ),
                _MetricCell(
                  icon: Icons.timer_outlined,
                  value: '${minutes}m ${seconds}s',
                  label: 'Taken',
                  colour: AppColours.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.icon,
    required this.value,
    required this.label,
    required this.colour,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, size: 19, color: colour),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColours.text,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColours.textMuted),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({
    required this.number,
    required this.question,
    required this.chosen,
  });

  final int number;
  final CbtQuestion question;
  final int? chosen;

  bool get _correct => chosen == question.correctIndex;
  bool get _skipped => chosen == null;

  @override
  Widget build(BuildContext context) {
    final Color statusColour = _skipped
        ? AppColours.textMuted
        : (_correct ? AppColours.success : AppColours.danger);

    return EduvoraCard(
      shadows: AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: statusColour.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _skipped
                      ? Icons.remove_rounded
                      : (_correct ? Icons.check_rounded : Icons.close_rounded),
                  size: 15,
                  color: statusColour,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Question $number',
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColours.textMuted,
                ),
              ),
              const Spacer(),
              Pill(
                label: _skipped
                    ? 'Not answered'
                    : (_correct ? 'Correct' : 'Incorrect'),
                colour: statusColour,
                dense: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          MathText(
            question.question.replaceAll('**', ''),
            style: const TextStyle(
              fontSize: 16.5,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: AppColours.text,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...List<Widget>.generate(question.options.length, (int i) {
            final bool isCorrect = i == question.correctIndex;
            final bool isChosen = i == chosen;
            if (!isCorrect && !isChosen) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 22,
                      child: Text(
                        '${CbtQuestion.letterFor(i)}.',
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: AppColours.textFaint,
                        ),
                      ),
                    ),
                    Expanded(
                      child: MathText(
                        question.options[i],
                        style: const TextStyle(
                          fontSize: 14.5,
                          height: 1.45,
                          color: AppColours.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            final Color colour = isCorrect
                ? AppColours.success
                : AppColours.danger;
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: colour.withValues(alpha: 0.08),
                borderRadius: AppRadii.sm,
                border: Border.all(color: colour.withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Icon(
                    isCorrect
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                    size: 15,
                    color: colour,
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: MathText(
                      question.options[i],
                      style: TextStyle(
                        fontSize: 14.5,
                        height: 1.45,
                        fontWeight: FontWeight.w600,
                        color: colour,
                      ),
                    ),
                  ),
                  if (isChosen && !isCorrect)
                    const Text(
                      'You',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColours.danger,
                      ),
                    ),
                ],
              ),
            );
          }),
          if (question.explanation.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColours.primaryTint,
                borderRadius: AppRadii.sm,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.lightbulb_outline_rounded,
                    size: 16,
                    color: AppColours.primary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: MathText(
                      question.explanation,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        color: AppColours.primaryDeep,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
