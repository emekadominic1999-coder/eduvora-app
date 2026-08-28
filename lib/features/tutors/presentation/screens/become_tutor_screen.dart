import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/models/tutor.dart';
import '../../../../core/services/cbt_repository.dart';
import '../../../../core/services/study_repository.dart';
import '../../../../core/services/tutor_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// Apply to teach. A course can only be chosen once the student has actually
/// scored [TutorRepository.minCbtScore] or better on that paper — the list
/// shows every paper with their best score, so what is still needed is
/// obvious rather than a rejection after the fact.
///
/// The bar is re-checked server-side on submit; the gating here is purely so
/// the screen is honest about what will be accepted.
class BecomeTutorScreen extends StatefulWidget {
  const BecomeTutorScreen({super.key, this.existing});

  final Tutor? existing;

  @override
  State<BecomeTutorScreen> createState() => _BecomeTutorScreenState();
}

class _BecomeTutorScreenState extends State<BecomeTutorScreen> {
  static const TutorRepository _tutors = TutorRepository();
  static const CbtRepository _cbt = CbtRepository();
  static const StudyRepository _study = StudyRepository();

  final TextEditingController _headline = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  late Future<List<CbtSubject>> _subjects;

  /// subjectId -> chosen hourly rate in naira.
  final Map<String, int> _selected = <String, int>{};

  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _subjects = _cbt.all();
    final Tutor? existing = widget.existing;
    if (existing != null) {
      _headline.text = existing.headline;
      _bio.text = existing.bio;
      for (final TutorCourse c in existing.courses) {
        _selected[c.subjectId] = (c.hourlyRateKobo / 100).round();
      }
    }
  }

  @override
  void dispose() {
    _headline.dispose();
    _bio.dispose();
    super.dispose();
  }

  /// The student's best percentage on a paper, counting only attempts
  /// substantial enough to actually demonstrate mastery — the same floor
  /// the edge function enforces server-side, so this screen never shows
  /// "eligible" for something a lucky free-trial score would only get
  /// rejected for on submit.
  int _bestScore(String subjectId) {
    final List<CbtAttempt> real = _study
        .attemptsFor(subjectId)
        .where(
          (CbtAttempt a) =>
              a.totalQuestions >= TutorRepository.minAttemptQuestions,
        )
        .toList();
    if (real.isEmpty) return 0;
    return real
        .map((CbtAttempt a) => a.percentage.round())
        .reduce((int a, int b) => a > b ? a : b);
  }

  bool _eligible(String subjectId) =>
      _bestScore(subjectId) >= TutorRepository.minCbtScore;

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final List<CbtSubject> subjects = await _subjects;
      final List<({String subjectId, String subjectName, int hourlyRateKobo})>
      courses = _selected.entries.map((MapEntry<String, int> entry) {
        final CbtSubject subject = subjects.firstWhere(
          (CbtSubject s) => s.id == entry.key,
          orElse: () => CbtSubject(
            id: entry.key,
            name: entry.key,
            description: '',
            questions: const <CbtQuestion>[],
          ),
        );
        return (
          subjectId: entry.key,
          subjectName: subject.name,
          hourlyRateKobo: entry.value * 100,
        );
      }).toList();

      await _tutors.apply(
        headline: _headline.text.trim(),
        bio: _bio.text.trim(),
        courses: courses,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You are live. Students can now find you.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = error is StateError
            ? error.message
            : 'Could not save that. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: Text(
          widget.existing == null ? 'Become a tutor' : 'Edit my tutoring',
        ),
      ),
      body: FutureBuilder<List<CbtSubject>>(
        future: _subjects,
        builder:
            (BuildContext context, AsyncSnapshot<List<CbtSubject>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<CbtSubject> subjects =
                  snapshot.data ?? <CbtSubject>[];
              final List<CbtSubject> eligible = subjects
                  .where((CbtSubject s) => _eligible(s.id))
                  .toList();
              final List<CbtSubject> locked = subjects
                  .where((CbtSubject s) => !_eligible(s.id))
                  .toList();

              return ListView(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                children: <Widget>[
                  const _Explainer(),
                  const SectionHeader(
                    title: 'Your headline',
                    subtitle: 'One line students see first',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: TextField(
                      controller: _headline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: '300L Maths · patient with first-years',
                      ),
                    ),
                  ),
                  const SectionHeader(title: 'About you'),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: TextField(
                      controller: _bio,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText:
                            'How you teach, when you are usually free, '
                            'anything a student should know.',
                      ),
                    ),
                  ),

                  SectionHeader(
                    title: 'Courses you can teach',
                    subtitle:
                        '${TutorRepository.minCbtScore}% or above on a '
                        'full sitting (${TutorRepository.minAttemptQuestions}+ '
                        'questions) unlocks a course — the free trial is too '
                        'short to count',
                  ),
                  if (eligible.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      child: EmptyState(
                        icon: Icons.workspace_premium_outlined,
                        title: 'No courses unlocked yet',
                        message:
                            'Sit a CBT paper and score '
                            '${TutorRepository.minCbtScore}% or above, and it '
                            'will appear here for you to teach.',
                        compact: true,
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      child: Column(
                        children: eligible
                            .map(
                              (CbtSubject s) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: _EligibleCourse(
                                  subject: s,
                                  score: _bestScore(s.id),
                                  rateNaira: _selected[s.id],
                                  onToggle: (bool on) => setState(() {
                                    if (on) {
                                      _selected[s.id] = 1500;
                                    } else {
                                      _selected.remove(s.id);
                                    }
                                  }),
                                  onRateChanged: (int rate) =>
                                      setState(() => _selected[s.id] = rate),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),

                  if (locked.isNotEmpty) ...<Widget>[
                    const SectionHeader(
                      title: 'Not unlocked yet',
                      subtitle: 'Score higher on these to teach them',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      child: Column(
                        children: locked
                            .map(
                              (CbtSubject s) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: _LockedCourse(
                                  subject: s,
                                  score: _bestScore(s.id),
                                  triedOnlyShortAttempts: _study
                                      .attemptsFor(s.id)
                                      .isNotEmpty,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],

                  if (_error != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.lg),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColours.danger,
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: AppSpacing.xl),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: FilledButton.icon(
                      onPressed: _selected.isEmpty || _busy ? null : _submit,
                      icon: _busy
                          ? const SizedBox(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_rounded, size: 19),
                      label: Text(
                        _busy
                            ? 'Saving…'
                            : _selected.isEmpty
                            ? 'Choose at least one course'
                            : 'Go live as a tutor',
                      ),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 50),
                      ),
                    ),
                  ),
                ],
              );
            },
      ),
    );
  }
}

class _Explainer extends StatelessWidget {
  const _Explainer();

  @override
  Widget build(BuildContext context) {
    final int percent = (TutorRepository.commission * 100).round();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: EduvoraCard(
        colour: AppColours.primaryTint,
        shadows: AppShadows.subtle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(
                  Icons.payments_rounded,
                  size: 19,
                  color: AppColours.primary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'You keep ${100 - percent}%',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Students pay through the app. Eduvora takes $percent% of each '
              'session; the rest is added to your balance the moment the '
              'student confirms the session happened. Withdraw any time you '
              'are above ₦${TutorRepository.minPayoutKobo ~/ 100}.',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _EligibleCourse extends StatelessWidget {
  const _EligibleCourse({
    required this.subject,
    required this.score,
    required this.rateNaira,
    required this.onToggle,
    required this.onRateChanged,
  });

  final CbtSubject subject;
  final int score;
  final int? rateNaira;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onRateChanged;

  static const List<int> _rates = <int>[500, 1000, 1500, 2000, 3000, 5000];

  @override
  Widget build(BuildContext context) {
    final bool selected = rateNaira != null;
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      colour: selected ? AppColours.primaryTint : AppColours.surface,
      border: Border.all(
        color: selected ? AppColours.primary : AppColours.border,
        width: selected ? 1.7 : 1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Checkbox(
                value: selected,
                onChanged: (bool? v) => onToggle(v ?? false),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      subject.name,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Your best score: $score%',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColours.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Pill(
                label: 'Unlocked',
                icon: Icons.verified_rounded,
                colour: AppColours.success,
                dense: true,
              ),
            ],
          ),
          if (selected) ...<Widget>[
            const Divider(height: AppSpacing.xl),
            Text(
              'Your rate an hour',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _rates.map((int rate) {
                final bool on = rate == rateNaira;
                return ChoiceChip(
                  label: Text('₦$rate'),
                  selected: on,
                  onSelected: (_) => onRateChanged(rate),
                  selectedColor: AppColours.primary,
                  labelStyle: TextStyle(
                    fontSize: 12.5,
                    color: on ? Colors.white : AppColours.text,
                    fontWeight: on ? FontWeight.w700 : FontWeight.w500,
                  ),
                  side: BorderSide(
                    color: on ? AppColours.primary : AppColours.border,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _LockedCourse extends StatelessWidget {
  const _LockedCourse({
    required this.subject,
    required this.score,
    required this.triedOnlyShortAttempts,
  });

  final CbtSubject subject;
  final int score;

  /// True when the student has sat this paper, but only ever in attempts
  /// too short to count (e.g. the free trial) — score is 0 in that case
  /// even though they have genuinely tried it, so the message must say
  /// that rather than the flatly untrue "you have not sat this paper yet".
  final bool triedOnlyShortAttempts;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Opacity(
        opacity: 0.75,
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.lock_outline_rounded,
              size: 19,
              color: AppColours.textFaint,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    subject.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    score > 0
                        ? 'Your best is $score% — '
                              '${TutorRepository.minCbtScore}% needed'
                        : triedOnlyShortAttempts
                        ? 'Only the free trial so far — sit a full '
                              '${TutorRepository.minAttemptQuestions}+ '
                              'question paper to count'
                        : 'You have not sat this paper yet',
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
    );
  }
}
