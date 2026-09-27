import 'package:flutter/widgets.dart';

import '../models/student_profile.dart';
import 'session_controller.dart';

/// Reloads a screen's data the moment the signed-in student's profile
/// actually changes, not on every unrelated notification from
/// [SessionController].
///
/// A handful of screens (the home dashboard, the materials library) sit
/// inside [HomeShell]'s `IndexedStack` and are kept alive for the whole
/// session, so their `initState` only ever runs once. If a student edits
/// their academic details (say, their faculty and department) from the
/// Profile tab, those screens would otherwise keep showing data for their
/// *old* faculty until something else happened to rebuild them -- which
/// reads as the app simply being wrong, not merely out of date.
///
/// Mix this in alongside a screen's own mixins, call [initProfileRefresh]
/// from `initState` and [disposeProfileRefresh] from `dispose`, and
/// implement [onProfileChanged] to reload whatever the screen shows.
mixin ProfileRefreshMixin<T extends StatefulWidget> on State<T> {
  StudentProfile? _lastProfile;

  void initProfileRefresh() {
    _lastProfile = sessionController.profile;
    sessionController.addListener(_onSessionNotified);
  }

  void disposeProfileRefresh() {
    sessionController.removeListener(_onSessionNotified);
  }

  void _onSessionNotified() {
    if (!mounted) return;
    final StudentProfile? current = sessionController.profile;
    // SessionController also notifies for things this screen doesn't care
    // about (a busy flag toggling during sign-in, for instance), which
    // leaves the same profile object in place -- only reload on a genuine
    // change of profile.
    if (identical(current, _lastProfile)) return;
    _lastProfile = current;
    onProfileChanged();
  }

  /// Called once the profile has genuinely changed. Typically:
  /// `setState(() => _future = _load());`
  void onProfileChanged();
}
