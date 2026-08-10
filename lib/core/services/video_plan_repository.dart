import 'package:flutter/foundation.dart';

import '../models/course_outline.dart';
import 'supabase_service.dart';

/// Reads the full course-outline library for a school, unfiltered by
/// department or level — the shot list at [VideoPlanScreen] needs to show
/// every department at once, not just the signed-in student's own.
class VideoPlanRepository {
  const VideoPlanRepository();

  // Supabase/PostgREST caps a single response at a fixed row count
  // (commonly 1000) regardless of how large the table actually is, so a
  // plain unpaginated select silently drops every row past that cutoff —
  // whole departments quietly vanish once the library grows past it. Page
  // through the table explicitly instead of trusting one request to return
  // everything.
  static const int _pageSize = 1000;

  Future<List<CourseOutline>> allOutlines(String institution) async {
    if (!SupabaseService.isReady) return <CourseOutline>[];
    try {
      final List<CourseOutline> all = <CourseOutline>[];
      int from = 0;
      while (true) {
        final List<dynamic> rows = await SupabaseService.client
            .from('course_outlines')
            .select()
            .eq('institution', institution)
            .order('department')
            .order('course_code')
            .range(from, from + _pageSize - 1);
        all.addAll(
          rows.whereType<Map<String, dynamic>>().map(CourseOutline.fromJson),
        );
        if (rows.length < _pageSize) break;
        from += _pageSize;
      }
      return all;
    } catch (error) {
      debugPrint('[Eduvora] video plan fetch failed: $error');
      return <CourseOutline>[];
    }
  }
}
