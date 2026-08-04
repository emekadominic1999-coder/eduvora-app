import 'package:flutter/material.dart';

import '../../../../core/models/course_outline.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/services/course_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'add_course_screen.dart';
import 'course_detail_screen.dart';

/// The course outline for the student's own institution, department and level.
class CourseOutlineScreen extends StatefulWidget {
  const CourseOutlineScreen({super.key});

  @override
  State<CourseOutlineScreen> createState() => _CourseOutlineScreenState();
}

class _CourseOutlineScreenState extends State<CourseOutlineScreen> {
  static const CourseRepository _repo = CourseRepository();

  late Future<_OutlineData> _future;
  bool _showOtherSchools = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_OutlineData> _load() async {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) {
      return const _OutlineData(mine: <CourseOutline>[], others: 0);
    }
    final List<CourseOutline> mine = await _repo.forStudent(profile);
    final List<CourseOutline> others = await _repo.fromOtherInstitutions(
      profile,
    );
    return _OutlineData(mine: mine, others: others.length);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  Future<void> _add() async {
    final bool? added = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => const AddCourseScreen()),
    );
    if ((added ?? false) && mounted) await _refresh();
  }

  Future<void> _openOtherSchools() async {
    setState(() => _showOtherSchools = true);
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const _OtherSchoolsScreen()),
    );
    if (mounted) setState(() => _showOtherSchools = false);
  }

  @override
  Widget build(BuildContext context) {
    final StudentProfile? profile = sessionController.profile;

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('Course outline'),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _add,
        backgroundColor: AppColours.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add a course'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColours.primary,
        child: FutureBuilder<_OutlineData>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<_OutlineData> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final _OutlineData data =
                snap.data ??
                const _OutlineData(mine: <CourseOutline>[], others: 0);

            if (data.mine.isEmpty) {
              return ListView(
                children: <Widget>[
                  if (profile != null) _Header(profile: profile, units: 0),
                  EmptyState(
                    icon: Icons.list_alt_rounded,
                    title: 'No outline yet for your school',
                    message:
                        'Course outlines differ from one institution to the '
                        'next, so this list only shows '
                        '${profile?.institutionAbbreviation.isNotEmpty == true ? profile!.institutionAbbreviation : 'your school'}. '
                        'Be the first to add yours — your coursemates will '
                        'thank you.',
                    actionLabel: 'Add a course',
                    onAction: _add,
                  ),
                  if (data.others > 0)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        0,
                        AppSpacing.screenPadding,
                        AppSpacing.xxl,
                      ),
                      child: _OtherSchoolsCard(
                        count: data.others,
                        onTap: _openOtherSchools,
                        busy: _showOtherSchools,
                      ),
                    ),
                ],
              );
            }

            final List<SemesterOutline> semesters = _repo.bySemester(data.mine);
            final int totalUnits = data.mine.fold(
              0,
              (int sum, CourseOutline c) => sum + c.creditUnits,
            );

            return ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: <Widget>[
                if (profile != null)
                  _Header(profile: profile, units: totalUnits),
                ...semesters
                    .where((SemesterOutline s) => s.courses.isNotEmpty)
                    .map((SemesterOutline s) => _SemesterSection(semester: s)),
                if (data.others > 0)
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: _OtherSchoolsCard(
                      count: data.others,
                      onTap: _openOtherSchools,
                      busy: _showOtherSchools,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _OutlineData {
  const _OutlineData({required this.mine, required this.others});

  final List<CourseOutline> mine;
  final int others;
}

class _Header extends StatelessWidget {
  const _Header({required this.profile, required this.units});

  final StudentProfile profile;
  final int units;

  @override
  Widget build(BuildContext context) {
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
                const Icon(Icons.school_rounded, color: Colors.white, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    profile.institutionName.isEmpty
                        ? 'Your institution'
                        : profile.institutionName,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      color: Colors.white.withValues(alpha: 0.96),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              '${profile.department} · ${profile.level}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
            if (units > 0) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: AppRadii.pill,
                ),
                child: Text(
                  '$units credit units this session',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SemesterSection extends StatelessWidget {
  const _SemesterSection({required this.semester});

  final SemesterOutline semester;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(
          title: semester.semester.label,
          subtitle:
              '${semester.courses.length} courses · '
              '${semester.totalUnits} credit units',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: Column(
            children: semester.courses
                .map(
                  (CourseOutline c) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _CourseRow(course: c),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _CourseRow extends StatelessWidget {
  const _CourseRow({required this.course, this.showInstitution = false});

  final CourseOutline course;
  final bool showInstitution;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => CourseDetailScreen(course: course),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: course.isElective
                  ? AppColours.accent.withValues(alpha: 0.12)
                  : AppColours.primaryTint,
              borderRadius: AppRadii.sm,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${course.creditUnits}',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: course.isElective
                        ? AppColours.accent
                        : AppColours.primary,
                  ),
                ),
                Text(
                  course.creditUnits == 1 ? 'unit' : 'units',
                  style: TextStyle(
                    fontSize: 9,
                    color: course.isElective
                        ? AppColours.accent
                        : AppColours.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        course.courseCode,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColours.text,
                        ),
                      ),
                    ),
                    if (course.isElective) ...<Widget>[
                      const SizedBox(width: 6),
                      const Pill(
                        label: 'Elective',
                        colour: AppColours.accent,
                        dense: true,
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  course.courseTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    height: 1.35,
                    color: AppColours.text,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Icon(
                      course.hasOutline
                          ? Icons.checklist_rounded
                          : Icons.info_outline_rounded,
                      size: 13,
                      color: course.hasOutline
                          ? AppColours.success
                          : AppColours.textFaint,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        showInstitution
                            ? course.institution
                            : (course.hasOutline
                                  ? '${course.topics.length} topics in the outline'
                                  : 'Outline not added yet'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColours.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColours.borderStrong,
          ),
        ],
      ),
    );
  }
}

class _OtherSchoolsCard extends StatelessWidget {
  const _OtherSchoolsCard({
    required this.count,
    required this.onTap,
    required this.busy,
  });

  final int count;
  final VoidCallback onTap;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      onTap: busy ? null : onTap,
      colour: AppColours.surfaceMuted,
      shadows: const <BoxShadow>[],
      border: Border.all(color: AppColours.border),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.compare_arrows_rounded,
            size: 20,
            color: AppColours.textMuted,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Compare with other institutions',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 3),
                Text(
                  '$count ${count == 1 ? 'course' : 'courses'} for the same '
                  'department elsewhere. Useful as reference — but always '
                  'follow your own school’s outline.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(height: 1.45),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColours.borderStrong,
          ),
        ],
      ),
    );
  }
}

/// The same department and level at other schools, grouped by institution and
/// always labelled with where each outline came from.
class _OtherSchoolsScreen extends StatefulWidget {
  const _OtherSchoolsScreen();

  @override
  State<_OtherSchoolsScreen> createState() => _OtherSchoolsScreenState();
}

class _OtherSchoolsScreenState extends State<_OtherSchoolsScreen> {
  static const CourseRepository _repo = CourseRepository();

  late final Future<List<CourseOutline>> _future = _load();

  Future<List<CourseOutline>> _load() {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) {
      return Future<List<CourseOutline>>.value(<CourseOutline>[]);
    }
    return _repo.fromOtherInstitutions(profile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Other institutions')),
      body: FutureBuilder<List<CourseOutline>>(
        future: _future,
        builder: (BuildContext context, AsyncSnapshot<List<CourseOutline>> s) {
          if (s.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final List<CourseOutline> courses = s.data ?? <CourseOutline>[];
          if (courses.isEmpty) {
            return const EmptyState(
              icon: Icons.school_outlined,
              title: 'Nothing to compare yet',
              message:
                  'No other institution has added an outline for this '
                  'department and level.',
            );
          }

          final Map<String, List<CourseOutline>> byInstitution =
              <String, List<CourseOutline>>{};
          for (final CourseOutline c in courses) {
            byInstitution
                .putIfAbsent(c.institution, () => <CourseOutline>[])
                .add(c);
          }

          return ListView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColours.warningSoft,
                    borderRadius: AppRadii.sm,
                  ),
                  child: Row(
                    children: <Widget>[
                      const Icon(
                        Icons.info_outline_rounded,
                        size: 18,
                        color: AppColours.warning,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Expanded(
                        child: Text(
                          'These belong to other schools. Codes, units and '
                          'topics often differ — revise from your own '
                          'institution’s outline.',
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
              ...byInstitution.entries.map(
                (MapEntry<String, List<CourseOutline>> entry) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SectionHeader(
                      title: entry.key,
                      subtitle: '${entry.value.length} courses',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      child: Column(
                        children: entry.value
                            .map(
                              (CourseOutline c) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: _CourseRow(
                                  course: c,
                                  showInstitution: true,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
