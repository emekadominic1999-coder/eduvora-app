import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/eduvora_logo.dart';
import '../../../home/presentation/screens/home_shell.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';
import 'auth_screen.dart';

/// The session guard described in the Eduvora architecture.
///
/// It restores any persisted session and then sends the student to exactly one
/// of three places: the sign-in screen, onboarding, or the dashboard. The
/// **sign-in screen is what a new or signed-out student sees first**, by design.
class SplashGate extends StatefulWidget {
  const SplashGate({super.key});

  @override
  State<SplashGate> createState() => _SplashGateState();
}

class _SplashGateState extends State<SplashGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Both mark variants appear across the app (this splash, auth,
      // onboarding); warming the cache once here means none of them ever
      // shows the bare tile a slow first fetch would otherwise leave blank.
      unawaited(precacheImage(
        const AssetImage('assets/branding/eduvora_mark_blue.png'),
        context,
      ));
      unawaited(precacheImage(
        const AssetImage('assets/branding/eduvora_mark_white.png'),
        context,
      ));
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    // Held long enough for the splash's entrance and at least one full lap
    // of its slow breathing hop to actually be seen, not just flashed past
    // on fast devices with a cached session.
    await Future.wait(<Future<void>>[
      sessionController.bootstrap(),
      Future<void>.delayed(const Duration(milliseconds: 2900)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: sessionController,
      builder: (BuildContext context, _) {
        switch (sessionController.status) {
          case AuthStatus.unknown:
            return const _SplashView();
          case AuthStatus.signedOut:
            return const AuthScreen();
          case AuthStatus.needsOnboarding:
            return const OnboardingScreen();
          case AuthStatus.ready:
            return const HomeShell();
        }
      },
    );
  }
}

class _SplashView extends StatefulWidget {
  const _SplashView();

  @override
  State<_SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<_SplashView>
    with TickerProviderStateMixin {
  // A springy pop-in, then a playful, continuous hop: the logo bounces up
  // with a little sideways wiggle and a squash-and-stretch on top, like a
  // cheerful character rather than a static badge. All driven off one
  // repeating 0->1 controller via sine so the motion loops seamlessly. Kept
  // slow and unhurried -- a quick twitch reads as a glitch, not a bounce.
  late final AnimationController _entrance = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();
  late final AnimationController _bounce = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1900),
  );

  late final Animation<double> _entranceScale = CurvedAnimation(
    parent: _entrance,
    curve: Curves.easeOutBack,
  );
  late final Animation<double> _entranceFade = CurvedAnimation(
    parent: _entrance,
    curve: const Interval(0, 0.6, curve: Curves.easeOut),
  );

  @override
  void initState() {
    super.initState();
    _entrance.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) _bounce.repeat();
    });
  }

  @override
  void dispose() {
    _entrance.dispose();
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColours.brandGradient),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Spacer(),
            AnimatedBuilder(
              animation: Listenable.merge(<Listenable>[_entrance, _bounce]),
              builder: (BuildContext context, Widget? child) {
                // One full sine cycle per lap of _bounce: 0 on the ground at
                // t=0, peak of the hop at t=0.5, back down at t=1.
                final double lift = math.sin(math.pi * _bounce.value);
                final double hopDy = -16 * lift;
                final double squash = 1 + 0.06 * lift;
                // A second, faster cycle for the wiggle so it tilts one way
                // on the way up and the other on the way down.
                final double wiggle =
                    0.11 * math.sin(2 * math.pi * _bounce.value);

                return Transform.translate(
                  offset: Offset(0, hopDy),
                  child: Transform.rotate(
                    angle: wiggle,
                    child: Opacity(
                      opacity: _entranceFade.value.clamp(0, 1),
                      child: Transform.scale(
                        scale: _entranceScale.value * squash,
                        child: child,
                      ),
                    ),
                  ),
                );
              },
              child: const EduvoraLogo(size: 88, onDark: true),
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              'Eduvora',
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Learn together. Graduate stronger.',
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(
                strokeWidth: 2.4,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }
}
