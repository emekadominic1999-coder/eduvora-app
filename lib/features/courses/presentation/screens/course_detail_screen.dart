import 'package:flutter/material.dart';

import '../../../../core/models/course_outline.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/math_text.dart';

/// One course: its particulars, and the syllabus it covers.
class CourseDetailScreen extends StatelessWidget {
  const CourseDetailScreen({super.key, required this.course});

  final CourseOutline course;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: Text(course.courseCode)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: <Widget>[
          _header(context),
          if (course.description.isNotEmpty) ...<Widget>[
            const SectionHeader(title: 'About this course'),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: EduvoraCard(
                shadows: AppShadows.subtle,
                child: MathText(
                  course.description,
                  style: const TextStyle(
                    fontSize: 14.5,
                    height: 1.6,
                    color: AppColours.text,
                  ),
                ),
              ),
            ),
          ],
          SectionHeader(
            title: 'Course outline',
            subtitle: course.hasOutline
                ? '${course.topics.length} topics, in teaching order'
                : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: course.hasOutline
                ? _topics(context)
                : const EmptyState(
                    icon: Icons.playlist_add_rounded,
                    title: 'No outline added yet',
                    message:
                        'The course is listed, but nobody has added its '
                        'topics. If you have the outline from your lecturer, '
                        'do add it.',
                    compact: true,
                  ),
          ),
          if (course.contributorName.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Text(
                'Contributed by ${course.contributorName}'
                '${course.createdAt != null ? ' · ${relativeTime(course.createdAt!)}' : ''}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: EduvoraCard(
        shadows: AppShadows.card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Pill(label: course.courseCode),
                const SizedBox(width: 6),
                Pill(label: course.unitsLabel, colour: AppColours.success),
                const SizedBox(width: 6),
                Pill(
                  label: course.isElective ? 'Elective' : 'Compulsory',
                  colour: course.isElective
                      ? AppColours.accent
                      : AppColours.info,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              course.courseTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            _row(Icons.account_balance_rounded, course.institution),
            _row(Icons.workspaces_rounded, course.department),
            _row(
              Icons.stairs_rounded,
              '${course.level} · ${course.semester.label}',
            ),
            if (course.lecturer.isNotEmpty)
              _row(Icons.person_outline_rounded, course.lecturer),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String value) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 16, color: AppColours.textMuted),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColours.text,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topics(BuildContext context) {
    return Column(
      children: List<Widget>.generate(course.topics.length, (int i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: EduvoraCard(
            padding: const EdgeInsets.all(AppSpacing.md),
            shadows: AppShadows.subtle,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColours.primaryTint,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColours.primary,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: MathText(
                      course.topics[i],
                      style: const TextStyle(
                        fontSize: 14.5,
                        height: 1.5,
                        color: AppColours.text,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
