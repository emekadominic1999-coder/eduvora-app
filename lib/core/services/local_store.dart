import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Thin, typed wrapper over [SharedPreferences].
///
/// Every repository in Eduvora writes through this store so that Campus Mode
/// (no Supabase project configured) behaves like a real backend: data survives
/// restarts, and the same read/write shapes are used on both code paths.
class LocalStore {
  LocalStore._(this._prefs);

  final SharedPreferences _prefs;

  static LocalStore? _instance;

  static LocalStore get instance {
    final LocalStore? store = _instance;
    if (store == null) {
      throw StateError(
        'LocalStore.init() must be awaited before the store is used.',
      );
    }
    return store;
  }

  static bool get isReady => _instance != null;

  static Future<LocalStore> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return _instance = LocalStore._(prefs);
  }

  // ---------------------------------------------------------------- primitives

  String? readString(String key) => _prefs.getString(key);

  Future<void> writeString(String key, String value) =>
      _prefs.setString(key, value);

  bool readBool(String key, {bool fallback = false}) =>
      _prefs.getBool(key) ?? fallback;

  Future<void> writeBool(String key, {required bool value}) =>
      _prefs.setBool(key, value);

  Future<void> remove(String key) => _prefs.remove(key);

  bool contains(String key) => _prefs.containsKey(key);

  // --------------------------------------------------------------------- JSON

  Map<String, dynamic>? readMap(String key) {
    final String? raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      final Object? decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  Future<void> writeMap(String key, Map<String, dynamic> value) =>
      _prefs.setString(key, jsonEncode(value));

  List<Map<String, dynamic>> readList(String key) {
    final String? raw = _prefs.getString(key);
    if (raw == null || raw.isEmpty) return <Map<String, dynamic>>[];
    try {
      final Object? decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) return <Map<String, dynamic>>[];
      return decoded
          .whereType<Map<dynamic, dynamic>>()
          .map(Map<String, dynamic>.from)
          .toList();
    } on FormatException {
      return <Map<String, dynamic>>[];
    }
  }

  Future<void> writeList(String key, List<Map<String, dynamic>> value) =>
      _prefs.setString(key, jsonEncode(value));

  /// Clears everything belonging to the signed-in student but keeps
  /// device-level preferences such as whether the tour has been seen.
  Future<void> clearSession() async {
    const List<String> keep = <String>[StoreKeys.hasSeenLanding];
    final Set<String> keys = _prefs.getKeys().toSet();
    for (final String key in keys) {
      if (keep.contains(key)) continue;
      await _prefs.remove(key);
    }
  }
}

/// Canonical key names, kept in one place to avoid typo-driven data loss.
class StoreKeys {
  const StoreKeys._();

  static const String hasSeenLanding = 'eduvora.has_seen_landing';
  static const String localAccounts = 'eduvora.local_accounts';
  static const String currentUser = 'eduvora.current_user';
  static const String profile = 'eduvora.profile';
  static const String materials = 'eduvora.materials';
  static const String videos = 'eduvora.videos';
  static const String savedVideos = 'eduvora.saved_videos';
  static const String communityPosts = 'eduvora.community_posts';
  static const String communityComments = 'eduvora.community_comments';
  static const String likedPosts = 'eduvora.liked_posts';
  static const String conversations = 'eduvora.conversations';
  static const String messages = 'eduvora.messages';
  static const String aiHistory = 'eduvora.ai_history';
  static const String gpaSemesters = 'eduvora.gpa_semesters';
  static const String cbtAttempts = 'eduvora.cbt_attempts';
  static const String bookmarkedNews = 'eduvora.bookmarked_news';
  static const String courseOutlines = 'eduvora.course_outlines';
  static const String myGroups = 'eduvora.my_groups';
  static const String groupMessages = 'eduvora.group_messages';
  static const String classLists = 'eduvora.class_lists';
  static const String classEntries = 'eduvora.class_entries';
  static const String videoPlanChecked = 'eduvora.video_plan_checked';
  static const String cbtFreeTrialUsed = 'eduvora.cbt_free_trial_used';
}
