import 'package:flutter/material.dart';

import '../../../../core/routing/app_router.dart';
import '../../../../core/services/chat_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
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

  @override
  void initState() {
    super.initState();
    AppRouter.shellTab.value = widget.initialTab;
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
            bottomNavigationBar: _NavBar(
              index: index,
              onTap: _onTap,
              unread: _unreadBadge(),
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
