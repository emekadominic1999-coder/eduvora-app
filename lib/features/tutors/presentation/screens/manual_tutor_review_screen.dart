import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/services/cbt_repository.dart';
import '../../../../core/services/tutor_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// The slower way in: no CBT score required. A student explains why they'd
/// be a good tutor and picks whichever courses they want to teach — an
/// operator reads the note and approves or rejects it by hand, since there
/// is nothing here the server can verify automatically the way a score can
/// be. Submitting leaves the profile 'pending' until that happens.
class ManualTutorReviewScreen extends StatefulWidget {
  const ManualTutorReviewScreen({super.key});

  @override
  State<ManualTutorReviewScreen> createState() =>
      _ManualTutorReviewScreenState();
}

class _ManualTutorReviewScreenState extends State<ManualTutorReviewScreen> {
  static const TutorRepository _tutors = TutorRepository();
  static const CbtRepository _cbt = CbtRepository();

  final TextEditingController _headline = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _note = TextEditingController();

  late final Future<List<CbtSubject>> _subjects = _cbt.all().then(
    (List<CbtSubject> all) => all
        .where((CbtSubject s) => s.questions.any((CbtQuestion q) => q.topic != 'Coming Soon'))
        .toList(),
  );

  /// subjectId -> chosen hourly rate in naira.
  final Map<String, int> _selected = <String, int>{};

  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _headline.dispose();
    _bio.dispose();
    _note.dispose();
    super.dispose();
  }

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

      await _tutors.applyManual(
        headline: _headline.text.trim(),
        bio: _bio.text.trim(),
        applicationNote: _note.text.trim(),
        courses: courses,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Application submitted — you will be able to teach once it is reviewed.',
          ),
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

  bool get _noteLongEnough => _note.text.trim().length >= 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Apply for manual review')),
      body: FutureBuilder<List<CbtSubject>>(
        future: _subjects,
        builder:
            (BuildContext context, AsyncSnapshot<List<CbtSubject>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<CbtSubject> subjects = snapshot.data ?? <CbtSubject>[];

              return ListView(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.lg,
                      AppSpacing.screenPadding,
                      0,
                    ),
                    child: EduvoraCard(
                      colour: AppColours.primaryTint,
                      shadows: AppShadows.subtle,
                      child: Text(
                        'No CBT paper needed here — an operator reads your '
                        'note and course choices directly and approves or '
                        'rejects your application by hand. It usually takes '
                        'longer than the instant CBT path.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(height: 1.5),
                      ),
                    ),
                  ),
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
                  const SectionHeader(
                    title: 'Why would you be a good tutor?',
                    subtitle:
                        'This is what gets reviewed — be specific (grades, '
                        'experience helping coursemates, anything relevant)',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: TextField(
                      controller: _note,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText:
                            'e.g. I scored an A in this course last session '
                            'and have been helping my coursemates with it '
                            'all semester...',
                      ),
                    ),
                  ),
                  const SectionHeader(
                    title: 'Courses you want to teach',
                    subtitle: 'Pick any — these are reviewed, not auto-checked',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Column(
                      children: subjects
                          .map(
                            (CbtSubject s) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                              child: _ManualCourseCard(
                                subject: s,
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
                      onPressed:
                          _selected.isEmpty || !_noteLongEnough || _busy
                          ? null
                          : _submit,
                      icon: _busy
                          ? const SizedBox(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded, size: 19),
                      label: Text(
                        _busy
                            ? 'Submitting…'
                            : _selected.isEmpty
                            ? 'Choose at least one course'
                            : !_noteLongEnough
                            ? 'Say a bit more above'
                            : 'Submit for review',
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

class _ManualCourseCard extends StatelessWidget {
  const _ManualCourseCard({
    required this.subject,
    required this.rateNaira,
    required this.onToggle,
    required this.onRateChanged,
  });

  final CbtSubject subject;
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
                child: Text(
                  subject.name,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
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
