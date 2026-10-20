import 'package:flutter/foundation.dart';

import '../models/content_report.dart';
import 'local_store.dart';
import 'supabase_service.dart';

/// Raised when a report or block action fails in a way worth telling the
/// student about.
class ModerationFailure implements Exception {
  const ModerationFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Reporting content and blocking other students.
///
/// See supabase/MODERATION_reports_and_blocks.sql for the database side. A
/// report is write-only from here -- nobody but the app owner can ever read
/// one back, and only through a dedicated RPC (`owner_content_reports`), the
/// same pattern ActivityRepository uses for `owner_active_users`.
///
/// A block is enforced on the client: GroupRepository and CommunityRepository
/// both call [blockedUserIds] and filter a blocked student's messages, posts
/// and comments out of whatever they return.
class ModerationRepository {
  const ModerationRepository();

  // --------------------------------------------------------------- reporting

  Future<void> reportContent({
    required ReportedContentType contentType,
    required String contentId,
    required ReportReason reason,
    String note = '',
  }) async {
    if (!SupabaseService.isReady) {
      throw const ModerationFailure(
        'Reporting needs a connection, so it can reach us. Please try again '
        'once you are online.',
      );
    }
    final String? userId = SupabaseService.currentUser?.id;
    if (userId == null) {
      throw const ModerationFailure('Not signed in.');
    }

    try {
      await SupabaseService.client
          .from('content_reports')
          .insert(<String, dynamic>{
            'reporter_id': userId,
            'content_type': contentType.value,
            'content_id': contentId,
            'reason': reason.name,
            'note': note.trim(),
          });
    } catch (error) {
      debugPrint('[Eduvora] report insert failed: $error');
      throw const ModerationFailure(
        'We could not send that report just now. Please try again.',
      );
    }
  }

  // ------------------------------------------------------------------ blocks

  Set<String> _cachedBlockedIds() => LocalStore.instance
      .readList(StoreKeys.blockedUsers)
      .map((Map<String, dynamic> m) => (m['id'] ?? '') as String)
      .where((String id) => id.isNotEmpty)
      .toSet();

  Future<void> _cacheBlockedIds(Set<String> ids) =>
      LocalStore.instance.writeList(
        StoreKeys.blockedUsers,
        ids.map((String id) => <String, dynamic>{'id': id}).toList(),
      );

  /// Ids of everyone the signed-in student has blocked. Reads the server
  /// when possible and caches the result, so a blocked student's content
  /// stays hidden even when offline rather than reappearing until the next
  /// successful fetch.
  Future<Set<String>> blockedUserIds() async {
    if (!SupabaseService.isReady) return _cachedBlockedIds();
    final String? userId = SupabaseService.currentUser?.id;
    if (userId == null) return _cachedBlockedIds();

    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('user_blocks')
          .select('blocked_id')
          .eq('blocker_id', userId);
      final Set<String> ids = rows
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> r) => (r['blocked_id'] ?? '') as String)
          .where((String id) => id.isNotEmpty)
          .toSet();
      await _cacheBlockedIds(ids);
      return ids;
    } catch (error) {
      debugPrint('[Eduvora] blocked users fetch failed: $error');
      return _cachedBlockedIds();
    }
  }

  /// Blocks a student. Safe to call again on someone already blocked.
  Future<void> blockUser(String userId) async {
    if (!SupabaseService.isReady) {
      throw const ModerationFailure(
        'Blocking needs a connection, so it can reach us. Please try again '
        'once you are online.',
      );
    }
    final String? me = SupabaseService.currentUser?.id;
    if (me == null) throw const ModerationFailure('Not signed in.');
    if (me == userId || userId.isEmpty) return;

    try {
      await SupabaseService.client.from('user_blocks').upsert(<String, dynamic>{
        'blocker_id': me,
        'blocked_id': userId,
      }, onConflict: 'blocker_id,blocked_id');
    } catch (error) {
      debugPrint('[Eduvora] block failed: $error');
      throw const ModerationFailure(
        'We could not block that student just now. Please try again.',
      );
    }

    final Set<String> cached = _cachedBlockedIds()..add(userId);
    await _cacheBlockedIds(cached);
  }

  /// Unblocks a student. Best-effort: a failed remote delete still clears the
  /// local cache, since leaving a stale block behind is the worse mistake.
  Future<void> unblockUser(String userId) async {
    if (SupabaseService.isReady) {
      final String? me = SupabaseService.currentUser?.id;
      if (me != null) {
        try {
          await SupabaseService.client
              .from('user_blocks')
              .delete()
              .eq('blocker_id', me)
              .eq('blocked_id', userId);
        } catch (error) {
          debugPrint('[Eduvora] unblock failed: $error');
        }
      }
    }

    final Set<String> cached = _cachedBlockedIds()..remove(userId);
    await _cacheBlockedIds(cached);
  }
}
