import 'package:flutter/material.dart';

import '../../../../core/models/academic_video.dart';
import '../../../../core/models/news_item.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/content_repository.dart';
import '../../../../core/services/study_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/eduvora_logo.dart';
import '../../../chats/presentation/screens/assistant_screen.dart';
import '../../../videos/presentation/screens/video_player_screen.dart';
import '../widgets/quick_action_grid.dart';

/// The dashboard: greeting, progress, quick access to every feature, the
/// latest lectures for the student's department and the noticeboard strip.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  static const ContentRepository _content = ContentRepository();
  static const StudyRepository _study = StudyRepository();

  late Future<_DashboardData> _future;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_DashboardData> _load() async {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) {
      return const _DashboardData(
        videos: <AcademicVideo>[],
        news: <NewsItem>[],
      );
    }
    final List<AcademicVideo> videos = await _content.videos(profile);
    final List<NewsItem> news = await _content.news();
    return _DashboardData(videos: videos, news: news);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ListenableBuilder(
      listenable: sessionController,
      builder: (BuildContext context, _) {
        final StudentProfile? profile = sessionController.profile;
        if (profile == null) return const SizedBox.shrink();

        return Scaffold(
          backgroundColor: AppColours.background,
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const AssistantScreen()),
            ),
            backgroundColor: AppColours.accent,
            foregroundColor: Colors.white,
            elevation: 3,
            tooltip: 'Ask Ada',
            child: const Icon(Icons.auto_awesome_rounded),
          ),
          body: RefreshIndicator(
            onRefresh: _refresh,
            color: AppColours.primary,
            child: FutureBuilder<_DashboardData>(
              future: _future,
              builder: (
                BuildContext context,
                AsyncSnapshot<_DashboardData> snapshot,
              ) {
                final _DashboardData data = snapshot.data ??
                    const _DashboardData(
                      videos: <AcademicVideo>[],
                      news: <NewsItem>[],
                    );
                final bool loading =
                    snapshot.connectionState == ConnectionState.waiting;

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: <Widget>[
                    SliverToBoxAdapter(child: _Greeting(profile: profile)),
                    SliverToBoxAdapter(child: _ProgressStrip(study: _study)),
                    const SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Everything you need',
                        subtitle: 'Tap any tile to jump straight in',
                      ),
                    ),
                    const SliverToBoxAdapter(child: QuickActionGrid()),
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Latest for ${_shorten(profile.department)}',
                        subtitle: profile.level.isEmpty
                            ? 'Recorded lectures for your course'
                            : '${profile.level} · recorded lectures',
                        actionLabel: 'See all',
                        onAction: () => Navigator.of(context)
                            .pushNamed(AppRouter.videos),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _VideoStrip(
                        videos: data.videos.take(6).toList(),
                        loading: loading,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SectionHeader(
                        title: 'Noticeboard',
                        subtitle: 'Scholarships and opportunities worth a look',
                        actionLabel: 'Open',
                        onAction: () =>
                            Navigator.of(context).pushNamed(AppRouter.news),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: _NewsStrip(
                        items: data.news.take(5).toList(),
                        loading: loading,
                      ),
                    ),
                    const SliverToBoxAdapter(child: _AdaPrompt()),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.xxxl + 24),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  static String _shorten(String department) {
    if (department.isEmpty) return 'your course';
    if (department.length <= 26) return department;
    return '${department.substring(0, 24)}…';
  }
}

class _DashboardData {
  const _DashboardData({required this.videos, required this.news});

  final List<AcademicVideo> videos;
  final List<NewsItem> news;
}

class _Greeting extends StatelessWidget {
  const _Greeting({required this.profile});

  final StudentProfile profile;

  String get _salutation {
    final int hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColours.brandGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        MediaQuery.of(context).padding.top + AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const EduvoraLogo(size: 34, onDark: true),
              const SizedBox(width: AppSpacing.md),
              const Text(
                'Eduvora',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              _HeaderIcon(
                icon: Icons.notifications_none_rounded,
                onTap: () => Navigator.of(context).pushNamed(AppRouter.news),
              ),
              const SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: () => AppRouter.shellTab.value = 4,
                child: InitialsAvatar(
                  initials: profile.initials,
                  size: 38,
                  colour: Colors.white,
                  imageUrl: profile.avatarUrl,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            '$_salutation, ${profile.firstName}',
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            profile.academicSummary,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          if (profile.institutionName.isNotEmpty) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.14),
                borderRadius: AppRadii.pill,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    profile.institutionType.icon,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  const SizedBox(width: 6),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Text(
                      profile.institutionName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withValues(alpha: 0.92),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.14),
      borderRadius: AppRadii.sm,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.sm,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 21, color: Colors.white),
        ),
      ),
    );
  }
}

class _ProgressStrip extends StatelessWidget {
  const _ProgressStrip({required this.study});

  final StudyRepository study;

  @override
  Widget build(BuildContext context) {
    final double cgpa = study.cumulativeGpa();
    final double average = study.averageScore();
    final int semesters = study.semesters().length;
    final int papers = study.attempts().length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: StatTile(
              label: semesters == 0
                  ? 'Add a semester'
                  : 'CGPA · $semesters saved',
              value: cgpa > 0 ? cgpa.toStringAsFixed(2) : '—',
              icon: Icons.calculate_rounded,
              colour: AppColours.success,
              onTap: () => Navigator.of(context).pushNamed(AppRouter.gpa),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: StatTile(
              label: papers == 0 ? 'Try a paper' : 'CBT average',
              value: papers > 0 ? '${average.round()}%' : '—',
              icon: Icons.quiz_rounded,
              colour: AppColours.accent,
              onTap: () => Navigator.of(context).pushNamed(AppRouter.cbt),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: StatTile(
              label: 'Papers sat',
              value: '$papers',
              icon: Icons.emoji_events_rounded,
              colour: AppColours.primary,
              onTap: () => Navigator.of(context).pushNamed(AppRouter.cbt),
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoStrip extends StatelessWidget {
  const _VideoStrip({required this.videos, required this.loading});

  final List<AcademicVideo> videos;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading && videos.isEmpty) {
      return const SizedBox(
        height: 178,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (videos.isEmpty) {
      return const EmptyState(
        icon: Icons.ondemand_video_rounded,
        title: 'No lectures yet',
        message: 'Once material is added for your department it appears here.',
        compact: true,
      );
    }

    return SizedBox(
      height: 186,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: videos.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (BuildContext context, int index) {
          final AcademicVideo v = videos[index];
          return SizedBox(
            width: 232,
            child: EduvoraCard(
              padding: EdgeInsets.zero,
              shadows: AppShadows.subtle,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => VideoPlayerScreen(video: v),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 96,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[
                          AppColours.primary.withValues(alpha: 0.90),
                          AppColours.primaryDeep,
                        ],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      children: <Widget>[
                        const Center(
                          child: Icon(
                            Icons.play_circle_fill_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        Positioned(
                          right: 8,
                          bottom: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.55),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              v.durationLabel,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Pill(
                            label: v.courseCode,
                            colour: Colors.white,
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              v.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                height: 1.32,
                                fontWeight: FontWeight.w700,
                                color: AppColours.text,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${v.lecturer} · ${v.viewsLabel}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColours.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NewsStrip extends StatelessWidget {
  const _NewsStrip({required this.items, required this.loading});

  final List<NewsItem> items;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading && items.isEmpty) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
      ),
      child: Column(
        children: items.map((NewsItem item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: EduvoraCard(
              padding: const EdgeInsets.all(AppSpacing.md),
              shadows: AppShadows.subtle,
              onTap: () => Navigator.of(context).pushNamed(AppRouter.news),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: item.category.colour.withValues(alpha: 0.12),
                      borderRadius: AppRadii.sm,
                    ),
                    child: Icon(
                      item.category.icon,
                      size: 18,
                      color: item.category.colour,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            height: 1.35,
                            fontWeight: FontWeight.w600,
                            color: AppColours.text,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: <Widget>[
                            Pill(
                              label: item.category.label,
                              colour: item.category.colour,
                              dense: true,
                            ),
                            if (item.hasDeadline) ...<Widget>[
                              const SizedBox(width: 6),
                              Text(
                                item.deadlineLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: (item.daysLeft ?? 99) <= 7
                                      ? AppColours.danger
                                      : AppColours.textMuted,
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
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _AdaPrompt extends StatelessWidget {
  const _AdaPrompt();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.xl,
        AppSpacing.screenPadding,
        0,
      ),
      child: EduvoraCard(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => const AssistantScreen()),
        ),
        colour: AppColours.primaryTint,
        shadows: const <BoxShadow>[],
        border: Border.all(color: AppColours.primarySoft),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                gradient: AppColours.accentGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Not sure where to start?',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: AppColours.primaryDeep,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Ask Ada. She knows every corner of Eduvora — and she is '
                    'happy to listen too.',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: AppColours.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColours.primary,
            ),
          ],
        ),
      ),
    );
  }
}
