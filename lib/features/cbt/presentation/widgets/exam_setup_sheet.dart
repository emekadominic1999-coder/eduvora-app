import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// Distinct topics in [questions], sorted alphabetically, blank ones
/// dropped — a paper with no topic tags at all yields an empty list, and
/// the caller falls back to hiding the topic picker entirely.
List<String> _topicsIn(List<CbtQuestion> questions) {
  final Set<String> topics = <String>{
    for (final CbtQuestion q in questions)
      if (q.topic.trim().isNotEmpty) q.topic,
  };
  final List<String> sorted = topics.toList()..sort();
  return sorted;
}

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
  String? _selectedTopic;
  String _topicQuery = '';
  late final List<String> _topics = _topicsIn(widget.subject.questions);

  /// Starts at the whole paper, but never above the custom ceiling — a
  /// two-hundred-question bank must not open the stepper on a value its own
  /// maximum forbids.
  late int _questions = _maxCustom;
  late int _minutes = widget.subject.minutesPerAttempt;
  bool _shuffleQuestions = true;
  bool _shuffleOptions = false;

  int get _total => widget.subject.questions.length;

  /// How many questions actually match the topic a custom paper is
  /// restricted to — the whole subject when no topic is chosen.
  int get _customPoolSize {
    final String? topic = _selectedTopic;
    if (topic == null) return _total;
    return widget.subject.questions.where((CbtQuestion q) => q.topic == topic).length;
  }

  /// How many questions a standard sitting actually draws — the fixed
  /// count, unless the paper itself holds fewer than that. Standard mode
  /// always spans the whole paper, ignoring any topic chosen for custom.
  int get _standardCount =>
      _total < CbtExamConfig.standardQuestionCount
      ? _total
      : CbtExamConfig.standardQuestionCount;

  /// A custom paper may go up to a hundred questions, but never beyond what
  /// its (possibly topic-narrowed) pool actually holds — offering a number
  /// the pool cannot fill would silently hand back a shorter paper than was
  /// asked for.
  int get _maxCustom {
    final int pool = _customPoolSize;
    return pool < CbtExamConfig.maxCustomQuestions
        ? pool
        : CbtExamConfig.maxCustomQuestions;
  }

  void _selectTopic(String? topic) {
    setState(() {
      _selectedTopic = topic;
      _questions = _maxCustom == 0 ? 1 : _maxCustom;
    });
  }

  int _countFor(String? topic) => topic == null
      ? widget.subject.questions.length
      : widget.subject.questions.where((CbtQuestion q) => q.topic == topic).length;

  void _start() {
    final CbtExamConfig config = _custom
        ? CbtExamConfig(
            questionCount: _questions,
            minutes: _minutes,
            shuffleQuestions: _shuffleQuestions,
            shuffleOptions: _shuffleOptions,
            isCustom: true,
            topic: _selectedTopic,
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
            body: _total <= CbtExamConfig.standardQuestionCount
                ? 'All $_total questions, ${CbtExamConfig.standardMinutes} '
                      'minutes on the clock, marked out of '
                      '${CbtExamConfig.totalMarks}. This is the one that '
                      'mirrors the real hall.'
                : '$_standardCount questions drawn at random from the paper, '
                      '${CbtExamConfig.standardMinutes} minutes on the clock, '
                      'marked out of ${CbtExamConfig.totalMarks}. This is the '
                      'one that mirrors the real hall.',
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
            if (_topics.isNotEmpty) ...<Widget>[
              Text('Topic', style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 3),
              Text(
                'Practice one topic at a time, or sit the whole paper.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              _InlineTopicPicker(
                topics: _topics,
                selected: _selectedTopic,
                query: _topicQuery,
                countFor: _countFor,
                onQueryChanged: (String v) => setState(() => _topicQuery = v),
                onSelected: _selectTopic,
              ),
              const SizedBox(height: AppSpacing.lg),
              const Divider(),
              const SizedBox(height: AppSpacing.lg),
            ],
            _Stepper(
              label: 'Questions',
              value: _questions,
              suffix: _questions == 1 ? 'question' : 'questions',
              min: 1,
              max: _maxCustom == 0 ? 1 : _maxCustom,
              step: _maxCustom > 40 ? 5 : 1,
              onChanged: (int v) => setState(() => _questions = v),
            ),
            if (_customPoolSize < CbtExamConfig.maxCustomQuestions) ...<Widget>[
              const SizedBox(height: 6),
              Text(
                _selectedTopic == null
                    ? 'This paper holds $_customPoolSize '
                          '${_customPoolSize == 1 ? 'question' : 'questions'} at '
                          'the moment. It will stretch further as more past '
                          'questions are added.'
                    : '"$_selectedTopic" holds $_customPoolSize '
                          '${_customPoolSize == 1 ? 'question' : 'questions'} at '
                          'the moment.',
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
                  : 'Start — $_standardCount questions, '
                        '${CbtExamConfig.standardMinutes} min',
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

/// The primary, inline topic selector for a custom paper — shown directly
/// in the setup sheet rather than behind a tap-through, since picking a
/// topic is meant to be the first decision a custom sitting makes, not an
/// optional afterthought. Searchable since a large bank can hold well over
/// a hundred distinct topics; height-capped so it can't swallow the rest
/// of the sheet.
class _InlineTopicPicker extends StatelessWidget {
  const _InlineTopicPicker({
    required this.topics,
    required this.selected,
    required this.query,
    required this.countFor,
    required this.onQueryChanged,
    required this.onSelected,
  });

  final List<String> topics;
  final String? selected;
  final String query;
  final int Function(String? topic) countFor;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final List<String> filtered = query.trim().isEmpty
        ? topics
        : topics
              .where((String t) => t.toLowerCase().contains(query.toLowerCase()))
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (topics.length > 6) ...<Widget>[
          SearchField(hint: 'Search topics', onChanged: onQueryChanged),
          const SizedBox(height: AppSpacing.sm),
        ],
        Container(
          constraints: const BoxConstraints(maxHeight: 260),
          decoration: BoxDecoration(
            border: Border.all(color: AppColours.border),
            borderRadius: AppRadii.sm,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: 2,
            ),
            itemCount: filtered.length + 1,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(height: 1),
            itemBuilder: (BuildContext context, int index) {
              if (index == 0) {
                return _TopicTile(
                  label: 'All topics',
                  count: countFor(null),
                  selected: selected == null,
                  onTap: () => onSelected(null),
                );
              }
              final String topic = filtered[index - 1];
              return _TopicTile(
                label: topic,
                count: countFor(topic),
                selected: selected == topic,
                onTap: () => onSelected(topic),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _TopicTile extends StatelessWidget {
  const _TopicTile({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: Theme.of(context).textTheme.titleSmall),
      trailing: selected
          ? const Icon(
              Icons.check_circle_rounded,
              size: 20,
              color: AppColours.primary,
            )
          : Text(
              '$count',
              style: Theme.of(context).textTheme.bodySmall,
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
