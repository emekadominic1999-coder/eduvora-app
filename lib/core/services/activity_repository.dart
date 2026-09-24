import 'package:flutter/foundation.dart';

import 'supabase_service.dart';

/// Counts of students by how recently they had the app open. Numbers only —
/// no names or emails ever come back from the database for this.
@immutable
class ActiveUserCounts {
  const ActiveUserCounts({
    required this.onlineNow,
    required this.activeToday,
    required this.active7Days,
    required this.active30Days,
    required this.totalUsers,
  });

  final int onlineNow;
  final int activeToday;
  final int active7Days;
  final int active30Days;
  final int totalUsers;
}

/// Records "this student has the app open" and, for the owner only, reads the
/// resulting counts. See supabase/ACTIVE_USERS.sql for the database side.
///
/// The owner check here only decides whether to *show* the entry point; the
/// database function refuses anyone but the owner's account on its own, so
/// nobody can read the counts by editing this list.
class ActivityRepository {
  const ActivityRepository();

  static const List<String> _ownerEmails = <String>[
    'emekadominic1999@gmail.com',
    'eduvora264@gmail.com',
  ];

  static bool isOwnerEmail(String? email) =>
      email != null && _ownerEmails.contains(email.trim().toLowerCase());

  /// Whether the account that is actually signed in is the owner's. Reads the
  /// email from the login session (the same one the database checks), not the
  /// profile row -- a profile created through Google sign-in can carry an
  /// empty email, which hid the owner's entry point.
  static bool get currentUserIsOwner {
    if (!SupabaseService.isReady) return false;
    return isOwnerEmail(SupabaseService.auth.currentUser?.email);
  }

  /// Marks the signed-in student as seen just now. Never throws: a missed
  /// heartbeat must not disturb the student.
  Future<void> touch() async {
    if (!SupabaseService.isReady) return;
    try {
      await SupabaseService.client.rpc('touch_last_seen');
    } catch (error) {
      debugPrint('[Eduvora] heartbeat skipped: $error');
    }
  }

  /// Owner-only. Throws if the database refuses or the function is missing.
  Future<ActiveUserCounts> ownerCounts() async {
    final dynamic result = await SupabaseService.client.rpc(
      'owner_active_users',
    );
    final Map<String, dynamic> row = result is List
        ? (result.first as Map<String, dynamic>)
        : (result as Map<String, dynamic>);
    int n(String key) => (row[key] as num?)?.toInt() ?? 0;
    return ActiveUserCounts(
      onlineNow: n('online_now'),
      activeToday: n('active_today'),
      active7Days: n('active_7d'),
      active30Days: n('active_30d'),
      totalUsers: n('total_users'),
    );
  }
}
