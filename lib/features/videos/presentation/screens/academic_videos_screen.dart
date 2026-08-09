import 'package:flutter/material.dart';

import '../../../../core/models/academic_video.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/services/content_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'video_plan_screen.dart';
import 'video_player_screen.dart';

/// The lecture feed for the student's department and level.
class AcademicVideosScreen extends StatefulWidget {
  const AcademicVideosScreen({super.key});

  @override
  State<AcademicVideosScreen> createState() => _AcademicVideosScreenState();
}

class _AcademicVideosScreenState extends State<AcademicVideosScreen> {
  static const ContentRepository _content = ContentRepository();

  late Future<List<AcademicVideo>> _future;
  String _query = '';
  String _sort = 'Newest';

  static const List<String> _sorts = <String>['Newest', 'Most watched', 'A–Z'];

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<AcademicVideo>> _load() {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) {
      return Future<List<AcademicVideo>>.value(<AcademicVideo>[]);
    }
    return _content.videos(profile);
  }

  List<AcademicVideo> _apply(List<AcademicVideo> source) {
    final String q = _query.trim().toLowerCase();
    List<AcademicVideo> list = q.isEmpty
        ? List<AcademicVideo>.from(source)
        : source
              .where(
                (AcademicVideo v) =>
                    v.title.toLowerCase().contains(q) ||
                    v.courseCode.toLowerCase().contains(q) ||
                    v.lecturer.toLowerCase().contains(q),
              )
              .toList();

    switch (_sort) {
      case 'Most watched':
        list.sort(
          (AcademicVideo a, AcademicVideo b) => b.views.compareTo(a.views),
        );
      case 'A–Z':
        list.sort(
          (AcademicVideo a, AcademicVideo b) => a.title.compareTo(b.title),
        );
      default:
        list.sort(
          (AcademicVideo a, AcademicVideo b) => (b.createdAt ?? DateTime(2000))
              .compareTo(a.createdAt ?? DateTime(2000)),
        );
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final StudentProfile? profile = sessionController.profile;

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('Academic videos'),
        actions: <Widget>[
          IconButton(
            tooltip: 'Video plan',
            icon: const Icon(Icons.movie_filter_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const VideoPlanScreen(),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              AppSpacing.md,
              AppSpacing.screenPadding,
              AppSpacing.md,
            ),
            child: SearchField(
              hint: 'Search by topic, course code or lecturer',
              onChanged: (String v) => setState(() => _query = v),
            ),
          ),
          if (profile != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenPadding,
                0,
                AppSpacing.screenPadding,
                AppSpacing.md,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${profile.department} · ${profile.level}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  _SortMenu(
                    values: _sorts,
                    selected: _sort,
                    onSelected: (String s) => setState(() => _sort = s),
                  ),
                ],
              ),
            ),
          Expanded(
            child: FutureBuilder<List<AcademicVideo>>(
              future: _future,
              builder:
                  (
                    BuildContext context,
                    AsyncSnapshot<List<AcademicVideo>> snapshot,
                  ) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final List<AcademicVideo> videos = _apply(
                      snapshot.data ?? <AcademicVideo>[],
                    );

                    if (videos.isEmpty) {
                      return EmptyState(
                        icon: Icons.ondemand_video_rounded,
                        title: _query.isEmpty
                            ? 'No lectures yet'
                            : 'Nothing matches that search',
                        message: _query.isEmpty
                            ? 'Lectures for your department will appear here as '
                                  'soon as they are added.'
                            : 'Try a shorter search term, or clear it to see '
                                  'everything.',
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPadding,
                        0,
                        AppSpacing.screenPadding,
                        AppSpacing.xxl,
                      ),
                      itemCount: videos.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (BuildContext context, int index) =>
                          _VideoRow(video: videos[index]),
                    );
                  },
            ),
          ),
        ],
      ),
    );
  }
}

/// Compact sort control that sits beside the department label.
class _SortMenu extends StatelessWidget {
  const _SortMenu({
    required this.values,
    required this.selected,
    required this.onSelected,
  });

  final List<String> values;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.md),
      itemBuilder: (BuildContext context) => values
          .map(
            (String v) => PopupMenuItem<String>(
              value: v,
              child: Row(
                children: <Widget>[
                  Icon(
                    v == selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 17,
                    color: v == selected
                        ? AppColours.primary
                        : AppColours.borderStrong,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(v),
                ],
              ),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: const BoxDecoration(
          color: AppColours.surfaceMuted,
          borderRadius: AppRadii.pill,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.sort_rounded,
              size: 15,
              color: AppColours.textMuted,
            ),
            const SizedBox(width: 5),
            Text(
              selected,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColours.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoRow extends StatelessWidget {
  const _VideoRow({required this.video});

  final AcademicVideo video;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => VideoPlayerScreen(video: video),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 96,
            height: 72,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[AppColours.primary, AppColours.primaryDeep],
              ),
              borderRadius: AppRadii.sm,
            ),
            child: Stack(
              children: <Widget>[
                const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      video.durationLabel,
                      style: const TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
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
                Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.32,
                    fontWeight: FontWeight.w700,
                    color: AppColours.text,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  video.lecturer,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColours.textMuted,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: <Widget>[
                    Pill(label: video.courseCode, dense: true),
                    const SizedBox(width: 6),
                    Text(
                      video.viewsLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColours.textFaint,
                      ),
                    ),
                    if (video.createdAt != null) ...<Widget>[
                      const Text(
                        '  ·  ',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColours.textFaint,
                        ),
                      ),
                      Text(
                        relativeTime(video.createdAt!),
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColours.textFaint,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
