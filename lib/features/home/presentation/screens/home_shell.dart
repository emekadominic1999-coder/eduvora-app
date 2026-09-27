import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/ads/ads.dart';
import '../../../../core/models/cbt.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/activity_repository.dart';
import '../../../../core/services/cbt_progress_store.dart';
import '../../../../core/services/local_store.dart';
import '../../../../core/services/paywall_repository.dart';
import '../../../../core/services/chat_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../cbt/presentation/screens/cbt_exam_screen.dart';
import '../../../chats/presentation/screens/chats_screen.dart';
import '../../../community/presentation/screens/community_screen.dart';
import '../../../materials/presentation/screens/materials_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';
import 'home_screen.dart';

/// The signed-in container: five tabs, kept alive so scroll positions and
/// in-progress work survive tab switches.
///
/// No footer appears here or on any screen inside it — the footer belongs to
/// the landing page only.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const ChatRepository _chats = ChatRepository();

  static const ActivityRepository _activity = ActivityRepository();
  Timer? _heartbeat;

  /// Students who have paid for any CBT access never see the banner.
  bool _paid = false;

  @override
  void initState() {
    super.initState();
    if (AdService.supported) {
      unawaited(
        const PaywallRepository().myEntitlements().then((entitlements) {
          if (mounted) setState(() => _paid = entitlements.isNotEmpty);
        }),
      );
    }
    // "This student has the app open" -- feeds the owner-only Live users
    // screen. Immediately, then every few minutes while the app stays open.
    unawaited(_activity.touch());
    _heartbeat = Timer.periodic(
      const Duration(minutes: 3),
      (_) => unawaited(_activity.touch()),
    );
    // A locked phone can let the browser (or the OS, on a low-end Android
    // device) reclaim a backgrounded tab and reload the app from scratch --
    // for instance right after opening a shared material, which leaves the
    // app in a background tab while the file opens in a new one. Without
    // this, that reload always lands back on Home (tab 0) rather than
    // wherever the student actually was, which reads as "the app took me
    // back to the beginning". Restore the last tab they were on instead,
    // unless this shell was deliberately opened to a specific tab (sign-in,
    // finishing onboarding).
    AppRouter.shellTab.value = widget.initialTab != 0
        ? widget.initialTab
        : _lastSavedTab();
    // Save every subsequent tab change too, however it happens -- a direct
    // tap, or a jump from Ada / a deep link via [AppRouter.go].
    AppRouter.shellTab.addListener(_saveCurrentTab);
    WidgetsBinding.instance.addPostFrameCallback((_) => _resumeCbtIfAny());
  }

  void _saveCurrentTab() {
    unawaited(
      LocalStore.instance.writeString(
        StoreKeys.lastShellTab,
        '${AppRouter.shellTab.value}',
      ),
    );
  }

  // Home, Materials, Community, Chats, Profile -- keep in step with the
  // IndexedStack below and AppRouter.shellTabs.
  static const int _tabCount = 5;

  int _lastSavedTab() {
    final int saved =
        int.tryParse(LocalStore.instance.readString(StoreKeys.lastShellTab) ?? '') ?? 0;
    return saved >= 0 && saved < _tabCount ? saved : 0;
  }

  /// Walks the student straight back into a CBT paper that was interrupted
  /// mid-attempt — a locked phone can let the browser reclaim a backgrounded
  /// tab after a few idle minutes and reload it from scratch, which would
  /// otherwise land here on the dashboard with no memory of the exam that
  /// was open. [CbtExamScreen] restores the saved answers, flags, position
  /// and time-adjusted countdown itself the moment it's reopened for the
  /// matching subject; this just gets the student back to that screen
  /// without them having to notice anything went wrong and find the paper
  /// again themselves.
  Future<void> _resumeCbtIfAny() async {
    final Map<String, dynamic>? saved = CbtProgressStore.readValid();
    if (saved == null || !mounted) return;
    final CbtSubject subject = CbtSubject(
      id: saved['subjectId'] as String,
      name: (saved['subjectName'] as String?) ?? 'Your practice paper',
      description: '',
      questions: const <CbtQuestion>[],
    );
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(builder: (_) => CbtExamScreen(subject: subject)),
    );
  }

  @override
  void dispose() {
    _heartbeat?.cancel();
    AppRouter.shellTab.removeListener(_saveCurrentTab);
    super.dispose();
  }

  void _onTap(int index) {
    if (AppRouter.shellTab.value == index) return;
    AppRouter.shellTab.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: AppRouter.shellTab,
      builder: (BuildContext context, int index, _) {
        return PopScope(
          canPop: index == 0,
          onPopInvokedWithResult: (bool didPop, _) {
            if (!didPop) AppRouter.shellTab.value = 0;
          },
          child: Scaffold(
            backgroundColor: AppColours.background,
            body: IndexedStack(
              index: index,
              children: const <Widget>[
                HomeScreen(),
                MaterialsScreen(embedded: true),
                CommunityScreen(embedded: true),
                ChatsScreen(embedded: true),
                ProfileScreen(embedded: true),
              ],
            ),
            bottomNavigationBar: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (AdService.supported && !_paid)
                  const ColoredBox(
                    color: AppColours.surface,
                    child: Center(child: AdBanner()),
                  ),
                _NavBar(index: index, onTap: _onTap, unread: _unreadBadge()),
              ],
            ),
          ),
        );
      },
    );
  }

  int _unreadBadge() {
    final profile = sessionController.profile;
    if (profile == null) return 0;
    return _chats.unreadTotal(profile);
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    required this.index,
    required this.onTap,
    required this.unread,
  });

  final int index;
  final ValueChanged<int> onTap;
  final int unread;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColours.surface,
        border: Border(top: BorderSide(color: AppColours.border)),
      ),
      child: SafeArea(
        top: false,
        child: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: onTap,
          destinations: <Widget>[
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.folder_outlined),
              selectedIcon: Icon(Icons.folder_rounded),
              label: 'Materials',
            ),
            const NavigationDestination(
              icon: Icon(Icons.forum_outlined),
              selectedIcon: Icon(Icons.forum_rounded),
              label: 'Community',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: unread > 0,
                label: Text('$unread'),
                backgroundColor: AppColours.accent,
                child: const Icon(Icons.chat_bubble_outline_rounded),
              ),
              selectedIcon: const Icon(Icons.chat_bubble_rounded),
              label: 'Chats',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline_rounded),
              selectedIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
