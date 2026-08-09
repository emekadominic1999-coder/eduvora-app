import 'package:flutter/material.dart';

import '../../../../core/models/course_outline.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/services/local_store.dart';
import '../../../../core/services/video_plan_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/video_clip_splitter.dart';
import '../../../../core/widgets/common.dart';

/// The real shot list: every loaded course outline, broken down into
/// short-video-sized clips, with a personal filming checklist.
///
/// This is a planning surface, not a student feed — it deliberately shows
/// every department at once (not just the signed-in student's own) so
/// whoever is producing lecture videos can browse the whole library, decide
/// what to film next, tick it off once it's recorded, and hand the file or
/// link off to be added as a real row in `academic_videos`.
class VideoPlanScreen extends StatefulWidget {
  const VideoPlanScreen({super.key});

  @override
  State<VideoPlanScreen> createState() => _VideoPlanScreenState();
}

class _DeptStats {
  const _DeptStats({
    required this.courses,
    required this.clips,
    required this.done,
  });

  final int courses;
  final int clips;
  final int done;
}

class _VideoPlanScreenState extends State<VideoPlanScreen> {
  static const VideoPlanRepository _repo = VideoPlanRepository();

  late final Future<List<CourseOutline>> _future;
  Map<String, dynamic> _checked = <String, dynamic>{};

  String? _faculty;
  String? _department;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _checked = Map<String, dynamic>.from(
      LocalStore.instance.readMap(StoreKeys.videoPlanChecked) ??
          <String, dynamic>{},
    );
    final StudentProfile? profile = sessionController.profile;
    _future = profile == null
        ? Future<List<CourseOutline>>.value(<CourseOutline>[])
        : _repo.allOutlines(profile.institutionName);
  }

  bool _isChecked(String key) => _checked[key] == true;

  Future<void> _toggle(String key) async {
    setState(() {
      if (_checked[key] == true) {
        _checked.remove(key);
      } else {
        _checked[key] = true;
      }
    });
    await LocalStore.instance.writeMap(StoreKeys.videoPlanChecked, _checked);
  }

  void _openDepartment(String faculty, String department) {
    setState(() {
      _faculty = faculty;
      _department = department;
      _query = '';
    });
  }

  void _backToLanding() {
    setState(() {
      _faculty = null;
      _department = null;
      _query = '';
    });
  }

  Map<String, Map<String, List<CourseOutline>>> _groupByFacultyDept(
    List<CourseOutline> all,
  ) {
    final Map<String, Map<String, List<CourseOutline>>> out =
        <String, Map<String, List<CourseOutline>>>{};
    for (final CourseOutline c in all) {
      out
          .putIfAbsent(c.faculty, () => <String, List<CourseOutline>>{})
          .putIfAbsent(c.department, () => <CourseOutline>[])
          .add(c);
    }
    return out;
  }

  _DeptStats _statsFor(String department, List<CourseOutline> courses) {
    int clips = 0;
    int done = 0;
    for (final CourseOutline c in courses) {
      for (final VideoClip clip in VideoClipSplitter.clipsForTopics(
        c.topics,
      )) {
        clips++;
        if (_isChecked(clip.key(department, c.courseCode))) done++;
      }
    }
    return _DeptStats(courses: courses.length, clips: clips, done: done);
  }

  @override
  Widget build(BuildContext context) {
    final bool inDepartment = _department != null;
    return PopScope(
      canPop: !inDepartment,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) return;
        _backToLanding();
      },
      child: Scaffold(
        backgroundColor: AppColours.background,
        appBar: AppBar(
          title: Text(_department ?? 'Video plan'),
          leading: inDepartment
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_rounded),
                  onPressed: _backToLanding,
                )
              : null,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: AppColours.border),
          ),
        ),
        body: FutureBuilder<List<CourseOutline>>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<List<CourseOutline>> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<CourseOutline> all =
                snapshot.data ?? <CourseOutline>[];
            if (all.isEmpty) {
              return const EmptyState(
                icon: Icons.movie_creation_outlined,
                title: 'No course outlines loaded yet',
                message:
                    'Once outlines are loaded for your school, every course '
                    'shows up here broken into short-video clips.',
              );
            }
            return inDepartment
                ? _buildDepartment(context, all)
                : _buildLanding(context, all);
          },
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- landing

  Widget _buildLanding(BuildContext context, List<CourseOutline> all) {
    final TextTheme text = Theme.of(context).textTheme;
    final Map<String, Map<String, List<CourseOutline>>> grouped =
        _groupByFacultyDept(all);
    final String q = _query.trim().toLowerCase();

    final List<Widget> sections = <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          0,
        ),
        child: SearchField(
          hint: 'Search all departments…',
          onChanged: (String v) => setState(() => _query = v),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.lg,
          AppSpacing.screenPadding,
          0,
        ),
        child: EduvoraCard(
          colour: AppColours.accentSoft,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Icon(
                Icons.movie_filter_rounded,
                color: AppColours.accentDark,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'One idea, one short clip — aim for 5–12 minutes each, '
                  'not a full lecture. Check off what you film, then send '
                  'the file or link over so it can go live.',
                  style: text.bodySmall?.copyWith(color: AppColours.text),
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    final List<String> facultyNames = grouped.keys.toList()..sort();
    bool anyMatched = false;

    for (final String faculty in facultyNames) {
      final List<MapEntry<String, List<CourseOutline>>> deptEntries =
          grouped[faculty]!.entries.where((
            MapEntry<String, List<CourseOutline>> e,
          ) {
            if (q.isEmpty) return true;
            if (e.key.toLowerCase().contains(q)) return true;
            return e.value.any(
              (CourseOutline c) =>
                  c.courseCode.toLowerCase().contains(q) ||
                  c.courseTitle.toLowerCase().contains(q) ||
                  c.topics.any((String t) => t.toLowerCase().contains(q)),
            );
          }).toList()..sort(
            (
              MapEntry<String, List<CourseOutline>> a,
              MapEntry<String, List<CourseOutline>> b,
            ) => a.key.compareTo(b.key),
          );

      if (deptEntries.isEmpty) continue;
      anyMatched = true;

      sections.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.xl,
            AppSpacing.screenPadding,
            AppSpacing.sm,
          ),
          child: Text(
            faculty.toUpperCase(),
            style: text.labelSmall?.copyWith(
              letterSpacing: 0.6,
              color: AppColours.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );

      for (final MapEntry<String, List<CourseOutline>> entry in deptEntries) {
        sections.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              AppSpacing.sm,
            ),
            child: _departmentCard(context, faculty, entry.key, entry.value),
          ),
        );
      }
    }

    if (!anyMatched) {
      sections.add(
        EmptyState(
          icon: Icons.search_off_rounded,
          title: 'Nothing matches "$_query"',
          message: 'Try a shorter search term, or clear it.',
          compact: true,
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: sections,
    );
  }

  Widget _departmentCard(
    BuildContext context,
    String faculty,
    String department,
    List<CourseOutline> courses,
  ) {
    final TextTheme text = Theme.of(context).textTheme;
    final _DeptStats stats = _statsFor(department, courses);
    final double pct = stats.clips == 0 ? 0 : stats.done / stats.clips;

    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      onTap: () => _openDepartment(faculty, department),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(department, style: text.titleSmall),
                const SizedBox(height: 4),
                Text(
                  '${stats.courses} courses · ${stats.clips} clips'
                  '${stats.done > 0 ? ' · ${stats.done} filmed' : ''}',
                  style: text.bodySmall?.copyWith(color: AppColours.textMuted),
                ),
                const SizedBox(height: AppSpacing.sm),
                ClipRRect(
                  borderRadius: AppRadii.pill,
                  child: LinearProgressIndicator(
                    value: pct,
                    minHeight: 4,
                    backgroundColor: AppColours.surfaceMuted,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColours.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.chevron_right_rounded, color: AppColours.textFaint),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ department

  Widget _buildDepartment(BuildContext context, List<CourseOutline> all) {
    final TextTheme text = Theme.of(context).textTheme;
    final List<CourseOutline> courses = all
        .where((CourseOutline c) => c.faculty == _faculty && c.department == _department)
        .toList();

    final String q = _query.trim().toLowerCase();
    final List<CourseOutline> filtered = q.isEmpty
        ? courses
        : courses
              .where(
                (CourseOutline c) =>
                    c.courseCode.toLowerCase().contains(q) ||
                    c.courseTitle.toLowerCase().contains(q) ||
                    c.topics.any((String t) => t.toLowerCase().contains(q)),
              )
              .toList();

    final Map<String, Map<Semester, List<CourseOutline>>> byLevel =
        <String, Map<Semester, List<CourseOutline>>>{};
    for (final CourseOutline c in filtered) {
      byLevel
          .putIfAbsent(c.level, () => <Semester, List<CourseOutline>>{})
          .putIfAbsent(c.semester, () => <CourseOutline>[])
          .add(c);
    }
    final List<String> levels = byLevel.keys.toList()..sort();

    final _DeptStats stats = _statsFor(_department!, courses);

    final List<Widget> items = <Widget>[
      Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          0,
        ),
        child: SearchField(
          hint: 'Search within $_department…',
          onChanged: (String v) => setState(() => _query = v),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.sm,
          AppSpacing.screenPadding,
          0,
        ),
        child: Text(
          '${stats.done} / ${stats.clips} clips filmed',
          style: text.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColours.success,
          ),
        ),
      ),
    ];

    if (levels.isEmpty) {
      items.add(
        EmptyState(
          icon: Icons.search_off_rounded,
          title: 'Nothing matches "$_query"',
          message: 'Try a shorter search term, or clear it.',
          compact: true,
        ),
      );
    }

    for (final String level in levels) {
      items.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPadding,
            AppSpacing.xl,
            AppSpacing.screenPadding,
            AppSpacing.xs,
          ),
          child: Text(level, style: text.titleMedium),
        ),
      );
      for (final Semester sem in Semester.values) {
        final List<CourseOutline>? list = byLevel[level]?[sem];
        if (list == null || list.isEmpty) continue;
        list.sort(
          (CourseOutline a, CourseOutline b) =>
              a.courseCode.compareTo(b.courseCode),
        );
        items.add(
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.sm,
              AppSpacing.screenPadding,
              AppSpacing.xs,
            ),
            child: Text(
              sem.label.toUpperCase(),
              style: text.labelSmall?.copyWith(
                color: AppColours.accentDark,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
        for (final CourseOutline course in list) {
          items.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                0,
                AppSpacing.screenPadding,
                AppSpacing.sm,
              ),
              child: _courseCard(context, course),
            ),
          );
        }
      }
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
      children: items,
    );
  }

  Widget _courseCard(BuildContext context, CourseOutline course) {
    final TextTheme text = Theme.of(context).textTheme;
    final List<VideoClip> clips = VideoClipSplitter.clipsForTopics(
      course.topics,
    );

    return EduvoraCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                course.courseCode,
                style: text.labelLarge?.copyWith(
                  color: AppColours.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(course.courseTitle, style: text.titleSmall),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                course.unitsLabel,
                style: text.bodySmall?.copyWith(color: AppColours.textFaint),
              ),
            ],
          ),
          if (clips.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Text(
                'No topics transcribed for this course yet',
                style: text.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColours.textFaint,
                ),
              ),
            )
          else
            ...clips.map((VideoClip clip) {
              final String key = clip.key(_department!, course.courseCode);
              final bool checked = _isChecked(key);
              return InkWell(
                onTap: () => _toggle(key),
                borderRadius: AppRadii.sm,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        value: checked,
                        onChanged: (_) => _toggle(key),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        activeColor: AppColours.success,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Text(
                            clip.text,
                            style: text.bodyMedium?.copyWith(
                              decoration: checked
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: checked
                                  ? AppColours.textFaint
                                  : AppColours.text,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
