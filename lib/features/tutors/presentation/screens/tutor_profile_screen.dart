import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/models/tutor.dart';
import '../../../../core/services/tutor_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../widgets/book_session_sheet.dart';

/// One tutor in full: what they have been verified to teach, what students
/// have said about them, and the button that starts a booking.
class TutorProfileScreen extends StatefulWidget {
  const TutorProfileScreen({
    super.key,
    required this.tutor,
    this.preselectedSubjectId = '',
  });

  final Tutor tutor;
  final String preselectedSubjectId;

  @override
  State<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends State<TutorProfileScreen> {
  static const TutorRepository _tutors = TutorRepository();

  late Future<List<TutorReview>> _reviews;
  bool _booked = false;

  @override
  void initState() {
    super.initState();
    _reviews = _tutors.reviewsFor(widget.tutor.id);
  }

  Future<void> _book() async {
    final bool? requested = await showBookSessionSheet(
      context,
      tutor: widget.tutor,
      preselectedSubjectId: widget.preselectedSubjectId,
    );
    if (requested != true || !mounted) return;

    setState(() => _booked = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Request sent. You will pay once the tutor accepts.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Tutor tutor = widget.tutor;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? _) {
        if (!didPop) Navigator.of(context).pop(_booked);
      },
      child: Scaffold(
        backgroundColor: AppColours.background,
        appBar: AppBar(
          title: Text(
            tutor.fullName.isEmpty ? 'Tutor' : tutor.fullName,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
          children: <Widget>[
            _Header(tutor: tutor),
            const SectionHeader(
              title: 'Verified to teach',
              subtitle: 'Scores are from the CBT papers in this app',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                children: tutor.courses
                    .map(
                      (TutorCourse c) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _CourseRow(course: c),
                      ),
                    )
                    .toList(),
              ),
            ),
            if (tutor.bio.trim().isNotEmpty) ...<Widget>[
              const SectionHeader(title: 'About'),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                ),
                child: Text(
                  tutor.bio,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ),
            ],
            SectionHeader(
              title: 'Reviews',
              subtitle: tutor.hasRating
                  ? '${tutor.ratingLabel} out of 5 · ${tutor.ratingCount} '
                        '${tutor.ratingCount == 1 ? 'review' : 'reviews'}'
                  : 'No reviews yet',
            ),
            FutureBuilder<List<TutorReview>>(
              future: _reviews,
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<List<TutorReview>> snapshot,
                  ) {
                    final List<TutorReview> reviews =
                        snapshot.data ?? <TutorReview>[];
                    if (reviews.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        child: Text(
                          'Be the first to book a session and leave a review.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColours.textMuted,
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      child: Column(
                        children: reviews
                            .map(
                              (TutorReview r) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm,
                                ),
                                child: _ReviewRow(review: r),
                              ),
                            )
                            .toList(),
                      ),
                    );
                  },
            ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.sm,
              AppSpacing.screenPadding,
              AppSpacing.md,
            ),
            child: FilledButton.icon(
              onPressed: tutor.courses.isEmpty ? null : _book,
              icon: const Icon(Icons.calendar_month_rounded, size: 19),
              label: const Text('Request a session'),
              style: FilledButton.styleFrom(minimumSize: const Size(0, 50)),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.tutor});

  final Tutor tutor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: EduvoraCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 56,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColours.primarySoft,
                    shape: BoxShape.circle,
                    image: (tutor.avatarUrl ?? '').isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(tutor.avatarUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: (tutor.avatarUrl ?? '').isNotEmpty
                      ? null
                      : Text(
                          tutor.initials,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColours.primaryDeep,
                          ),
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        tutor.fullName.isEmpty
                            ? 'Eduvora tutor'
                            : tutor.fullName,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        <String>[
                          if (tutor.level.isNotEmpty) tutor.level,
                          if (tutor.department.isNotEmpty) tutor.department,
                        ].join(' · '),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (tutor.headline.trim().isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              Text(
                tutor.headline,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                Pill(
                  label: tutor.hasRating
                      ? '${tutor.ratingLabel} rating'
                      : 'New tutor',
                  icon: Icons.star_rounded,
                  colour: tutor.hasRating
                      ? AppColours.warning
                      : AppColours.textMuted,
                  dense: true,
                ),
                const SizedBox(width: 6),
                Pill(
                  label: '${tutor.sessionsCompleted} sessions',
                  icon: Icons.school_rounded,
                  colour: AppColours.success,
                  dense: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CourseRow extends StatelessWidget {
  const _CourseRow({required this.course});

  final TutorCourse course;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColours.successSoft,
              borderRadius: AppRadii.sm,
            ),
            child: course.verifiedByCbt
                ? Text(
                    '${course.cbtScore}%',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColours.success,
                    ),
                  )
                : const Icon(
                    Icons.rate_review_rounded,
                    size: 18,
                    color: AppColours.success,
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  course.subjectName.isEmpty
                      ? course.subjectId
                      : course.subjectName,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  course.verifiedByCbt
                      ? 'Verified on the Eduvora CBT paper'
                      : 'Approved by Eduvora after manual review',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColours.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${course.rateLabel}/hr',
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w800,
              color: AppColours.text,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow({required this.review});

  final TutorReview review;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              ...List<Widget>.generate(
                5,
                (int i) => Icon(
                  i < review.rating
                      ? Icons.star_rounded
                      : Icons.star_outline_rounded,
                  size: 15,
                  color: AppColours.warning,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat('d MMM').format(review.createdAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColours.textFaint,
                ),
              ),
            ],
          ),
          if (review.comment.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              review.comment,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(height: 1.5),
            ),
          ],
          if (review.studentName.trim().isNotEmpty) ...<Widget>[
            const SizedBox(height: 6),
            Text(
              review.studentName,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColours.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
