import 'package:flutter/material.dart';

import '../../../../core/models/tutor.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// One tutor in the directory: who they are, what they have proved they
/// know, and what they charge.
class TutorCard extends StatelessWidget {
  const TutorCard({
    super.key,
    required this.tutor,
    required this.onTap,
    this.highlightSubjectId = '',
  });

  final Tutor tutor;
  final VoidCallback onTap;

  /// When browsing for one paper, that paper's rate and score lead the card
  /// rather than whichever course happens to be first.
  final String highlightSubjectId;

  @override
  Widget build(BuildContext context) {
    final TutorCourse? headline = highlightSubjectId.isEmpty
        ? (tutor.courses.isEmpty ? null : tutor.courses.first)
        : tutor.courseFor(highlightSubjectId);

    return EduvoraCard(
      onTap: onTap,
      shadows: AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Avatar(tutor: tutor),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      tutor.fullName.isEmpty ? 'Eduvora tutor' : tutor.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tutor.headline.isNotEmpty
                          ? tutor.headline
                          : <String>[
                              if (tutor.level.isNotEmpty) tutor.level,
                              if (tutor.department.isNotEmpty) tutor.department,
                            ].join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
              if (headline != null)
                Text(
                  headline.rateLabel,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColours.text,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              if (headline != null) ...<Widget>[
                Pill(
                  label: headline.verifiedByCbt
                      ? 'Verified · ${headline.cbtScore}%'
                      : 'Reviewed',
                  icon: Icons.verified_rounded,
                  colour: AppColours.success,
                  dense: true,
                ),
                const SizedBox(width: 6),
              ],
              Pill(
                label: tutor.hasRating
                    ? '${tutor.ratingLabel} (${tutor.ratingCount})'
                    : 'New tutor',
                icon: Icons.star_rounded,
                colour: tutor.hasRating
                    ? AppColours.warning
                    : AppColours.textMuted,
                dense: true,
              ),
              if (tutor.sessionsCompleted > 0) ...<Widget>[
                const SizedBox(width: 6),
                Pill(
                  label: '${tutor.sessionsCompleted} sessions',
                  icon: Icons.school_rounded,
                  dense: true,
                ),
              ],
              const Spacer(),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColours.textFaint,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.tutor});

  final Tutor tutor;

  @override
  Widget build(BuildContext context) {
    final String? url = tutor.avatarUrl;
    return Container(
      width: 46,
      height: 46,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColours.primarySoft,
        shape: BoxShape.circle,
        image: url != null && url.isNotEmpty
            ? DecorationImage(image: NetworkImage(url), fit: BoxFit.cover)
            : null,
      ),
      child: url != null && url.isNotEmpty
          ? null
          : Text(
              tutor.initials,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColours.primaryDeep,
              ),
            ),
    );
  }
}
