import 'package:eduvora/core/models/student_profile.dart';
import 'package:eduvora/core/state/profile_refresh_mixin.dart';
import 'package:eduvora/core/state/session_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Probe extends StatefulWidget {
  const _Probe();

  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> with ProfileRefreshMixin<_Probe> {
  int reloads = 0;

  @override
  void initState() {
    super.initState();
    initProfileRefresh();
  }

  @override
  void dispose() {
    disposeProfileRefresh();
    super.dispose();
  }

  @override
  void onProfileChanged() => reloads++;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

void main() {
  testWidgets(
    'ProfileRefreshMixin reloads only when the profile object actually changes',
    (WidgetTester tester) async {
      await tester.pumpWidget(const _Probe());
      final _ProbeState state = tester.state(find.byType(_Probe));
      expect(state.reloads, 0);

      // A notification with no real profile change (e.g. a busy flag
      // toggling elsewhere) must not trigger a reload.
      sessionController.notifyListenersForTest();
      expect(state.reloads, 0);

      // Editing academic details replaces the profile object -- that must
      // trigger exactly one reload, this is the fix for the bug where
      // Materials/Home kept showing the old faculty until a manual refresh.
      const StudentProfile updated = StudentProfile(
        id: '1',
        fullName: 'Chinaza',
        email: 'c@example.com',
        faculty: 'Faculty of Biological Sciences',
        department: 'Microbiology',
      );
      sessionController.setProfileForTest(updated);
      expect(state.reloads, 1);
      expect(sessionController.profile, same(updated));
    },
  );
}
