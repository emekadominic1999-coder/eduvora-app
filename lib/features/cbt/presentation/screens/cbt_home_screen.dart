import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/services/cbt_repository.dart';
import '../../../../core/services/study_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../widgets/exam_setup_sheet.dart';
import 'cbt_exam_screen.dart';

/// The CBT lobby: papers relevant to the student, plus their own record.
class CbtHomeScreen extends StatefulWidget {
  const CbtHomeScreen({super.key});

  @override
  State<CbtHomeScreen> createState() => _CbtHomeScreenState();
}

class _CbtHomeScreenState extends State<CbtHomeScreen> {
  static const StudyRepository _study = StudyRepository();
  static const CbtRepository _cbt = CbtRepository();

  bool _showAllPapers = false;
  late Future<List<CbtSubject>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<CbtSubject>> _load() {
    final StudentProfile? profile = sessionController.profile;
    return _showAllPapers
        ? _cbt.all()
        : _cbt.forFaculty(profile?.faculty ?? '');
  }

  void _toggleShowAll() {
    setState(() {
      _showAllPapers = !_showAllPapers;
      _future = _load();
    });
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  Future<void> _start(CbtSubject subject) async {
    // Ask how they want to sit it before the clock starts.
    final CbtExamConfig? config = await showExamSetupSheet(context, subject);
    if (config == null || !mounted) return;

    final bool? completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CbtExamScreen(subject: subject, config: config),
      ),
    );
    if ((completed ?? false) && mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final StudentProfile? profile = sessionController.profile;
    final List<CbtAttempt> attempts = _study.attempts();
    final double average = _study.averageScore();

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('CBT practice'),
        actions: <Widget>[
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColours.primary,
        child: FutureBuilder<List<CbtSubject>>(
          future: _future,
          builder:
              (BuildContext context, AsyncSnapshot<List<CbtSubject>> snapshot) {
                final List<CbtSubject> papers = snapshot.data ?? <CbtSubject>[];
                final bool loading =
                    snapshot.connectionState == ConnectionState.waiting;

                return ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  children: <Widget>[
                    _summary(
                      attempts.length,
                      average,
                      papers.fold(
                        0,
                        (int sum, CbtSubject s) => sum + s.questions.length,
                      ),
                    ),
                    SectionHeader(
                      title: _showAllPapers ? 'All papers' : 'Papers for you',
                      subtitle: _showAllPapers
                          ? 'Every paper in the Eduvora bank'
                          : 'Matched to ${profile?.faculty.isNotEmpty == true ? profile!.faculty : 'your faculty'}',
                      actionLabel: _showAllPapers ? 'Show mine' : 'Show all',
                      onAction: _toggleShowAll,
                    ),
                    if (loading && papers.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (papers.isEmpty)
                      EmptyState(
                        icon: Icons.quiz_outlined,
                        title: 'No papers yet',
                        message: _showAllPapers
                            ? 'Real past questions will appear here once '
                                  'they are added.'
                            : 'Nothing has been added for '
                                  '${profile?.faculty.isNotEmpty == true ? profile!.faculty : 'your faculty'} '
                                  'yet — tap "Show all" to see every paper in '
                                  'the bank.',
                        compact: true,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        child: Column(
                          children: papers.map((CbtSubject s) {
                            final CbtAttempt? best = _study.bestAttemptFor(
                              s.id,
                            );
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: _PaperCard(
                                subject: s,
                                best: best,
                                onStart: () => _start(s),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (attempts.isNotEmpty) ...<Widget>[
                      const SectionHeader(
                        title: 'Your record',
                        subtitle: 'Every paper you have sat, most recent first',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        child: Column(
                          children: attempts
                              .take(12)
                              .map(
                                (CbtAttempt a) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: _AttemptRow(attempt: a),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ],
                );
              },
        ),
      ),
    );
  }

  Widget _summary(int papers, double average, int totalQuestions) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: AppColours.brandGradient,
          borderRadius: AppRadii.lg,
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                const Icon(Icons.quiz_rounded, color: Colors.white, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Practise like it is the real thing',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.96),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Timed papers, a question grid, flags for items to revisit, and '
              'a full explanation for every answer once you submit.',
              style: TextStyle(
                fontSize: 13,
                height: 1.55,
                color: Colors.white.withValues(alpha: 0.78),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: <Widget>[
                _MiniStat(
                  value: '$papers',
                  label: papers == 1 ? 'paper sat' : 'papers sat',
                ),
                const SizedBox(width: AppSpacing.xl),
                _MiniStat(
                  value: papers == 0 ? '—' : '${average.round()}%',
                  label: 'average score',
                ),
                const SizedBox(width: AppSpacing.xl),
                _MiniStat(value: '$totalQuestions', label: 'in the bank'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
      ],
    );
  }
}

class _PaperCard extends StatelessWidget {
  const _PaperCard({
    required this.subject,
    required this.best,
    required this.onStart,
  });

  final CbtSubject subject;
  final CbtAttempt? best;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      shadows: AppShadows.subtle,
      onTap: onStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color:
                      (subject.isGeneralStudies
                              ? AppColours.accent
                              : AppColours.primary)
                          .withValues(alpha: 0.12),
                  borderRadius: AppRadii.sm,
                ),
                child: Icon(
                  subject.isGeneralStudies
                      ? Icons.public_rounded
                      : Icons.menu_book_rounded,
                  size: 20,
                  color: subject.isGeneralStudies
                      ? AppColours.accent
                      : AppColours.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      subject.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subject.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Pill(
                label: '${subject.questions.length} questions',
                icon: Icons.list_alt_rounded,
                dense: true,
              ),
              const SizedBox(width: 6),
              Pill(
                label: '${subject.minutesPerAttempt} min',
                icon: Icons.timer_outlined,
                colour: AppColours.accent,
                dense: true,
              ),
              if (best != null) ...<Widget>[
                const SizedBox(width: 6),
                Pill(
                  label:
                      'Best ${best!.marksAwarded}/${CbtAttempt.totalMarks}',
                  icon: Icons.emoji_events_rounded,
                  colour: AppColours.success,
                  dense: true,
                ),
              ],
              const Spacer(),
              const Icon(
                Icons.play_circle_fill_rounded,
                color: AppColours.primary,
                size: 26,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttemptRow extends StatelessWidget {
  const _AttemptRow({required this.attempt});

  final CbtAttempt attempt;

  Color get _colour {
    final double p = attempt.percentage;
    if (p >= 70) return AppColours.success;
    if (p >= 50) return AppColours.info;
    if (p >= 40) return AppColours.warning;
    return AppColours.danger;
  }

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _colour.withValues(alpha: 0.12),
              borderRadius: AppRadii.sm,
            ),
            child: Text(
              attempt.grade,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: _colour,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  attempt.subjectName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColours.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${attempt.score}/${attempt.totalQuestions} · '
                  '${attempt.verdict} · ${relativeTime(attempt.takenAt)}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColours.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${attempt.marksAwarded}/${CbtAttempt.totalMarks}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _colour,
                ),
              ),
              Text(
                '${attempt.percentage.round()}%',
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColours.textFaint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
