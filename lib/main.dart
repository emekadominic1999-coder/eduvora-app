import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/config/app_config.dart';
import 'core/routing/app_router.dart';
import 'core/services/local_store.dart';
import 'core/services/supabase_service.dart';
import 'core/state/session_controller.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/splash_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(AppTheme.lightOverlay);
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // On-device store first: it is what keeps Eduvora usable on a weak network.
  await LocalStore.init();

  // Then the backend, which degrades gracefully into Campus Mode.
  await SupabaseService.initialise();
  sessionController.listenToAuthChanges();

  runApp(const EduvoraApp());
}

class EduvoraApp extends StatelessWidget {
  const EduvoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      navigatorKey: AppRouter.navigatorKey,
      onGenerateRoute: AppRouter.onGenerateRoute,
      home: const SplashGate(),
      builder: (BuildContext context, Widget? child) {
        // Keep typography legible regardless of very large system font scales.
        final MediaQueryData media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: media.textScaler.clamp(
              minScaleFactor: 0.85,
              maxScaleFactor: 1.30,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
