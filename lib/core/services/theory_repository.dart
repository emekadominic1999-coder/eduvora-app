import 'package:flutter/foundation.dart';

import '../models/theory.dart';
import 'supabase_service.dart';

/// Reads written (theory) questions from the `theory_questions` table.
class TheoryRepository {
  const TheoryRepository();

  static List<TheoryQuestion>? _cache;
  static DateTime? _cachedAt;
  static const Duration _ttl = Duration(minutes: 5);

  /// Every theory question, newest course first sorted by code. Empty when
  /// the backend is unreachable.
  Future<List<TheoryQuestion>> all() async {
    final List<TheoryQuestion>? cached = _cache;
    if (cached != null &&
        _cachedAt != null &&
        DateTime.now().difference(_cachedAt!) < _ttl) {
      return cached;
    }
    if (!SupabaseService.isReady) return const <TheoryQuestion>[];
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('theory_questions')
          .select()
          .order('course_code')
          .order('created_at');
      final List<TheoryQuestion> list = rows
          .map(
            (dynamic r) =>
                TheoryQuestion.fromJson(Map<String, dynamic>.from(r as Map)),
          )
          .toList();
      _cache = list;
      _cachedAt = DateTime.now();
      return list;
    } catch (error) {
      debugPrint('[Eduvora] theory questions failed: $error');
      return cached ?? const <TheoryQuestion>[];
    }
  }
}
