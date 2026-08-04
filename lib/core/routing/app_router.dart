import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/auth/presentation/screens/splash_gate.dart';
import '../../features/cbt/presentation/screens/cbt_home_screen.dart';
import '../../features/chats/presentation/screens/assistant_screen.dart';
import '../../features/chats/presentation/screens/chats_screen.dart';
import '../../features/community/presentation/screens/community_screen.dart';
import '../../features/gpa/presentation/screens/gpa_calculator_screen.dart';
import '../../features/home/presentation/screens/home_shell.dart';
import '../../features/landing/presentation/screens/landing_screen.dart';
import '../../features/materials/presentation/screens/materials_screen.dart';
import '../../features/materials/presentation/screens/upload_material_screen.dart';
import '../../features/news/presentation/screens/news_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/videos/presentation/screens/academic_videos_screen.dart';

/// Named routes and the shell-aware navigation helper.
class AppRouter {
  const AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static const String splash = '/';
  static const String landing = '/landing';
  static const String auth = '/auth';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String videos = '/videos';
  static const String materials = '/materials';
  static const String upload = '/upload';
  static const String cbt = '/cbt';
  static const String gpa = '/gpa';
  static const String community = '/community';
  static const String chats = '/chats';
  static const String assistant = '/assistant';
  static const String news = '/news';
  static const String profile = '/profile';

  /// Routes that are tabs inside [HomeShell] rather than pushed pages.
  static const Map<String, int> shellTabs = <String, int>{
    home: 0,
    materials: 1,
    community: 2,
    chats: 3,
    profile: 4,
  };

  /// The currently selected shell tab, so deep links from Ada and the
  /// dashboard can move between tabs rather than stacking duplicates.
  static final ValueNotifier<int> shellTab = ValueNotifier<int>(0);

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    Widget page;
    switch (settings.name) {
      case splash:
        page = const SplashGate();
      case landing:
        page = const LandingScreen();
      case auth:
        page = const AuthScreen();
      case onboarding:
        page = const OnboardingScreen();
      case home:
        page = const HomeShell();
      case videos:
        page = const AcademicVideosScreen();
      case materials:
        page = const MaterialsScreen();
      case upload:
        page = const UploadMaterialScreen();
      case cbt:
        page = const CbtHomeScreen();
      case gpa:
        page = const GpaCalculatorScreen();
      case community:
        page = const CommunityScreen();
      case chats:
        page = const ChatsScreen();
      case assistant:
        page = const AssistantScreen();
      case news:
        page = const NewsScreen();
      case profile:
        page = const ProfileScreen();
      default:
        page = const SplashGate();
    }

    return MaterialPageRoute<dynamic>(
      builder: (_) => page,
      settings: settings,
    );
  }

  /// Navigates to [route], switching shell tabs where that is the right move.
  static void go(BuildContext context, String route) {
    final int? tab = shellTabs[route];
    if (tab != null) {
      Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
      shellTab.value = tab;
      return;
    }
    Navigator.of(context).pushNamed(route);
  }

  /// Replaces the whole stack — used after sign-in, onboarding and sign-out.
  static void reset(BuildContext context, String route) {
    Navigator.of(context).pushNamedAndRemoveUntil(route, (Route<dynamic> _) => false);
  }
}
