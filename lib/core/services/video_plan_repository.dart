import 'package:flutter/foundation.dart';

import '../models/course_outline.dart';
import 'supabase_service.dart';

/// Reads the full course-outline library for a school, unfiltered by
/// department or level — the shot list at [VideoPlanScreen] needs to show
/// every department at once, not just the signed-in student's own.
class VideoPlanRepository {
  const VideoPlanRepository();

  Future<List<CourseOutline>> allOutlines(String institution) async {
    if (!SupabaseService.isReady) return <CourseOutline>[];
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('course_outlines')
          .select()
          .eq('institution', institution)
          .order('department')
          .order('course_code');
      return rows
          .whereType<Map<String, dynamic>>()
          .map(CourseOutline.fromJson)
          .toList();
    } catch (error) {
      debugPrint('[Eduvora] video plan fetch failed: $error');
      return <CourseOutline>[];
    }
  }
}
