import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// Asks how the student would like to sit a paper before the clock starts.
///
/// Returns the chosen [CbtExamConfig], or null if they backed out.
Future<CbtExamConfig?> showExamSetupSheet(
  BuildContext context,
  CbtSubject subject,
) {
  return showModalBottomSheet<CbtExamConfig>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => _ExamSetupSheet(subject: subject),
  );
}

class _ExamSetupSheet extends StatefulWidget {
  const _ExamSetupSheet({required this.subject});

  final CbtSubject subject;

  @override
  State<_ExamSetupSheet> createState() => _ExamSetupSheetState();
}

class _ExamSetupSheetState extends State<_ExamSetupSheet> {
  bool _custom = false;

  /// Starts at the whole paper, but never above the custom ceiling — a
  /// two-hundred-question bank must not open the stepper on a value its own
  /// maximum forbids.
  late int _questions = _maxCustom;
  late int _minutes = widget.subject.minutesPerAttempt;
  bool _shuffleQuestions = true;
  bool _shuffleOptions = false;

  int get _total => widget.subject.questions.length;

  /// A custom paper may go up to a hundred questions, but never beyond what
  /// the subject actually holds — offering a number the pool cannot fill
  /// would silently hand back a shorter paper than was asked for.
  int get _maxCustom =>
      _total < CbtExamConfig.maxCustomQuestions
      ? _total
      : CbtExamConfig.maxCustomQuestions;

  void _start() {
    final CbtExamConfig config = _custom
        ? CbtExamConfig(
            questionCount: _questions,
            minutes: _minutes,
            shuffleQuestions: _shuffleQuestions,
            shuffleOptions: _shuffleOptions,
            isCustom: true,
          )
        : CbtExamConfig.standard(widget.subject);
    Navigator.of(context).pop(config);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.xl + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.subject.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'How would you like to sit this paper?',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),

          _ModeCard(
            title: 'Standard exam',
            body:
                'The full paper exactly as written — all $_total questions in '
                '${widget.subject.minutesPerAttempt} minutes, in order, marked '
                'out of ${CbtExamConfig.totalMarks}. This is the one that '
                'mirrors the real hall.',
            icon: Icons.assignment_rounded,
            selected: !_custom,
            onTap: () => setState(() => _custom = false),
          ),
          const SizedBox(height: AppSpacing.md),
          _ModeCard(
            title: 'Custom exam',
            body:
                'Set your own time and number of questions, up to '
                '$_maxCustom — useful for a quick revision run, or for giving '
                'yourself extra time while you are still learning the topic.',
            icon: Icons.tune_rounded,
            selected: _custom,
            onTap: () => setState(() => _custom = true),
          ),

          if (_custom) ...<Widget>[
            const SizedBox(height: AppSpacing.xl),
            const Divider(),
            const SizedBox(height: AppSpacing.lg),
            _Stepper(
              label: 'Questions',
              value: _questions,
              suffix: _questions == 1 ? 'question' : 'questions',
              min: 1,
              max: _maxCustom,
              step: _maxCustom > 40 ? 5 : 1,
              onChanged: (int v) => setState(() => _questions = v),
            ),
            if (_total < CbtExamConfig.maxCustomQuestions) ...<Widget>[
              const SizedBox(height: 6),
              Text(
                'This paper holds $_total '
                '${_total == 1 ? 'question' : 'questions'} at the moment. '
                'It will stretch further as more past questions are added.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            _Stepper(
              label: 'Time limit',
              value: _minutes,
              suffix: _minutes == 1 ? 'minute' : 'minutes',
              min: 1,
              max: 180,
              step: 5,
              onChanged: (int v) => setState(() => _minutes = v),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ToggleRow(
              label: 'Shuffle questions',
              subtitle: 'A different order each attempt',
              value: _shuffleQuestions,
              onChanged: (bool v) => setState(() => _shuffleQuestions = v),
            ),
            _ToggleRow(
              label: 'Shuffle options',
              subtitle: 'Stops you memorising "the answer is B"',
              value: _shuffleOptions,
              onChanged: (bool v) => setState(() => _shuffleOptions = v),
            ),
            const SizedBox(height: AppSpacing.md),
            _PaceHint(questions: _questions, minutes: _minutes),
          ],

          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: _start,
            icon: const Icon(Icons.play_arrow_rounded, size: 20),
            label: Text(
              _custom
                  ? 'Start — $_questions questions, $_minutes min'
                  : 'Start standard exam',
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.title,
    required this.body,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String body;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      shadows: selected ? AppShadows.card : AppShadows.subtle,
      colour: selected ? AppColours.primaryTint : AppColours.surface,
      border: Border.all(
        color: selected ? AppColours.primary : AppColours.border,
        width: selected ? 1.7 : 1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: selected ? AppColours.primary : AppColours.surfaceMuted,
              borderRadius: AppRadii.sm,
            ),
            child: Icon(
              icon,
              size: 20,
              color: selected ? Colors.white : AppColours.textMuted,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 3),
                Text(
                  body,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(height: 1.5),
                ),
              ],
            ),
          ),
          Icon(
            selected
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 21,
            color: selected ? AppColours.primary : AppColours.borderStrong,
          ),
        ],
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.suffix,
    required this.min,
    required this.max,
    required this.step,
    required this.onChanged,
  });

  final String label;
  final int value;
  final String suffix;
  final int min;
  final int max;
  final int step;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final bool canDecrease = value > min;
    final bool canIncrease = value < max;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.titleSmall),
            ),
            Text(
              '$value $suffix',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColours.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: <Widget>[
            _RoundButton(
              icon: Icons.remove_rounded,
              enabled: canDecrease,
              onTap: () => onChanged((value - step).clamp(min, max)),
            ),
            Expanded(
              child: Slider(
                value: value.toDouble().clamp(min.toDouble(), max.toDouble()),
                min: min.toDouble(),
                max: max.toDouble(),
                onChanged: (double v) => onChanged(v.round()),
              ),
            ),
            _RoundButton(
              icon: Icons.add_rounded,
              enabled: canIncrease,
              onTap: () => onChanged((value + step).clamp(min, max)),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled ? AppColours.primaryTint : AppColours.surfaceMuted,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Icon(
            icon,
            size: 19,
            color: enabled ? AppColours.primary : AppColours.textFaint,
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label, style: Theme.of(context).textTheme.titleSmall),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

/// A quiet nudge about how much time per question the chosen settings allow.
class _PaceHint extends StatelessWidget {
  const _PaceHint({required this.questions, required this.minutes});

  final int questions;
  final int minutes;

  @override
  Widget build(BuildContext context) {
    final double secondsEach = (minutes * 60) / questions;
    final bool tight = secondsEach < 30;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: tight ? AppColours.warningSoft : AppColours.surfaceMuted,
        borderRadius: AppRadii.sm,
      ),
      child: Row(
        children: <Widget>[
          Icon(
            tight ? Icons.speed_rounded : Icons.schedule_rounded,
            size: 17,
            color: tight ? AppColours.warning : AppColours.textMuted,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              tight
                  ? 'That is about ${secondsEach.round()} seconds a question — '
                        'brisk, but good for building speed.'
                  : 'That gives you about ${secondsEach.round()} seconds a '
                        'question.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(height: 1.45),
            ),
          ),
        ],
      ),
    );
  }
}
