import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/models/academic_video.dart';
import '../../../../core/services/content_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// In-app lecture playback with custom controls.
///
/// Direct video files play here; anything else (a YouTube link, for instance)
/// is opened in the device's own player so no lecture is ever a dead end.
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key, required this.video});

  final AcademicVideo video;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  static const ContentRepository _content = ContentRepository();

  VideoPlayerController? _controller;
  bool _initialising = true;
  String? _error;
  double _speed = 1.0;

  static const List<double> _speeds = <double>[0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _setUp();
    _content.registerView(widget.video);
  }

  Future<void> _setUp() async {
    if (!widget.video.isStreamable) {
      setState(() {
        _initialising = false;
        _error = 'external';
      });
      return;
    }

    try {
      final VideoPlayerController controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.videoUrl),
      );
      await controller.initialize();
      await controller.setLooping(false);
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _initialising = false;
      });
      controller.addListener(_onTick);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _initialising = false;
        _error =
            'We could not start this lecture. Please check your '
            'connection and try again.';
      });
    }
  }

  void _onTick() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.removeListener(_onTick);
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    final VideoPlayerController? c = _controller;
    if (c == null) return;
    c.value.isPlaying ? c.pause() : c.play();
  }

  void _seekBy(int seconds) {
    final VideoPlayerController? c = _controller;
    if (c == null) return;
    final Duration target = c.value.position + Duration(seconds: seconds);
    final Duration clamped = target < Duration.zero
        ? Duration.zero
        : (target > c.value.duration ? c.value.duration : target);
    c.seekTo(clamped);
  }

  Future<void> _openExternally() async {
    final Uri uri = Uri.parse(widget.video.videoUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      showEduvoraSnack(
        context,
        'We could not open this lecture externally.',
        isError: true,
      );
    }
  }

  static String _clock(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final int hours = d.inHours;
    final String mm = two(d.inMinutes.remainder(60));
    final String ss = two(d.inSeconds.remainder(60));
    return hours > 0 ? '$hours:$mm:$ss' : '$mm:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final AcademicVideo v = widget.video;

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Now playing')),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _stage(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Pill(label: v.courseCode),
                    const SizedBox(width: 6),
                    Pill(
                      label: v.level.isEmpty ? 'All levels' : v.level,
                      colour: AppColours.accent,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(v.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.person_outline_rounded,
                      size: 15,
                      color: AppColours.textMuted,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        '${v.lecturer} · ${v.viewsLabel}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                if (v.description.isNotEmpty) ...<Widget>[
                  Text(
                    'About this lecture',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    v.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
                EduvoraCard(
                  colour: AppColours.primaryTint,
                  shadows: const <BoxShadow>[],
                  border: Border.all(color: AppColours.primarySoft),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 19,
                        color: AppColours.primary,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          'Watch once at normal speed, then close the video '
                          'and attempt the questions from memory. Retrieval '
                          'is what makes a lecture stick.',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(height: 1.55),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stage() {
    final VideoPlayerController? c = _controller;

    if (_initialising) {
      return const AspectRatio(
        aspectRatio: 16 / 9,
        child: ColoredBox(
          color: Color(0xFF0F172A),
          child: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      );
    }

    if (_error == 'external' || c == null) {
      return AspectRatio(
        aspectRatio: 16 / 9,
        child: Container(
          color: const Color(0xFF0F172A),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.open_in_new_rounded,
                  color: Colors.white,
                  size: 34,
                ),
                const SizedBox(height: AppSpacing.md),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Text(
                    _error == 'external'
                        ? 'This lecture opens in your video app.'
                        : _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                FilledButton.tonal(
                  onPressed: _openExternally,
                  child: const Text('Open lecture'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final VideoPlayerValue value = c.value;

    return Column(
      children: <Widget>[
        AspectRatio(
          aspectRatio: value.aspectRatio == 0 ? 16 / 9 : value.aspectRatio,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              ColoredBox(color: const Color(0xFF0F172A), child: VideoPlayer(c)),
              GestureDetector(
                onTap: _togglePlay,
                behavior: HitTestBehavior.opaque,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  opacity: value.isPlaying ? 0 : 1,
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.28),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.play_circle_fill_rounded,
                      size: 62,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: const Color(0xFF0F172A),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            children: <Widget>[
              VideoProgressIndicator(
                c,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(vertical: 6),
                colors: const VideoProgressColors(
                  playedColor: AppColours.accent,
                  bufferedColor: Colors.white24,
                  backgroundColor: Colors.white12,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: <Widget>[
                  Text(
                    '${_clock(value.position)} / ${_clock(value.duration)}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                    ),
                  ),
                  const Spacer(),
                  _ControlButton(
                    icon: Icons.replay_10_rounded,
                    onTap: () => _seekBy(-10),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _ControlButton(
                    icon: value.isPlaying
                        ? Icons.pause_rounded
                        : Icons.play_arrow_rounded,
                    onTap: _togglePlay,
                    primary: true,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _ControlButton(
                    icon: Icons.forward_10_rounded,
                    onTap: () => _seekBy(10),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _cycleSpeed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        '${_speed}x',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _cycleSpeed() {
    final int next = (_speeds.indexOf(_speed) + 1) % _speeds.length;
    setState(() => _speed = _speeds[next]);
    _controller?.setPlaybackSpeed(_speed);
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.primary = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary ? AppColours.accent : Colors.white.withValues(alpha: 0.13),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(primary ? 9 : 7),
          child: Icon(icon, size: primary ? 24 : 20, color: Colors.white),
        ),
      ),
    );
  }
}
