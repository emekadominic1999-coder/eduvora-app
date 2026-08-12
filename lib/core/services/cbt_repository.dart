import 'package:flutter/foundation.dart';

import '../models/cbt.dart';
import 'supabase_service.dart';

/// Serves CBT papers from Supabase's `cbt_questions` table — real questions
/// the student (or their coursemates) have added. There is no fallback
/// sample bank: a paper only ever appears here once someone has actually
/// contributed real questions for it.
class CbtRepository {
  const CbtRepository();

  /// Real papers relevant to this faculty — general-studies papers plus
  /// whatever is specifically tagged for it.
  Future<List<CbtSubject>> forFaculty(String faculty) async {
    final List<CbtSubject> remote = await _fetchRemoteSubjects();
    final List<CbtSubject> relevant = remote
        .where((CbtSubject s) => s.isRelevantTo(faculty))
        .toList();
    relevant.sort((CbtSubject a, CbtSubject b) {
      if (a.isGeneralStudies != b.isGeneralStudies) {
        return a.isGeneralStudies ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });
    return relevant;
  }

  /// Every real paper, regardless of faculty relevance.
  Future<List<CbtSubject>> all() async {
    final List<CbtSubject> remote = await _fetchRemoteSubjects();
    remote.sort((CbtSubject a, CbtSubject b) {
      if (a.isGeneralStudies != b.isGeneralStudies) {
        return a.isGeneralStudies ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });
    return remote;
  }

  Future<List<CbtSubject>> _fetchRemoteSubjects() async {
    if (!SupabaseService.isReady) return <CbtSubject>[];

    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('cbt_questions')
          .select()
          .order('created_at');

      final Map<String, List<Map<String, dynamic>>> bySubject =
          <String, List<Map<String, dynamic>>>{};
      for (final dynamic raw in rows) {
        if (raw is! Map<String, dynamic>) continue;
        final String subjectId = (raw['subject_id'] ?? '') as String;
        if (subjectId.isEmpty) continue;
        bySubject
            .putIfAbsent(subjectId, () => <Map<String, dynamic>>[])
            .add(raw);
      }

      return bySubject.entries.map((
        MapEntry<String, List<Map<String, dynamic>>> entry,
      ) {
        final Map<String, dynamic> first = entry.value.first;
        final List<CbtQuestion> questions = entry.value
            .map(CbtQuestion.fromJson)
            .toList();
        final String faculty = (first['faculty'] ?? '') as String;
        final String department = (first['department'] ?? '') as String;

        return CbtSubject(
          id: entry.key,
          name: (first['subject_name'] ?? entry.key) as String,
          description: department.isEmpty
              ? 'Contributed past questions'
              : 'Past questions for $department',
          questions: questions,
          faculties: faculty.isEmpty ? const <String>[] : <String>[faculty],
          minutesPerAttempt: (questions.length * 1.2).ceil().clamp(10, 45),
          isGeneralStudies: (first['is_general'] ?? false) as bool,
          department: department,
          level: (first['level'] ?? '') as String,
          semester: (first['semester'] ?? '') as String,
          units: (first['units'] as num?)?.toInt() ?? 0,
        );
      }).toList();
    } catch (error) {
      debugPrint('[Eduvora] cbt_questions fetch failed: $error');
      return <CbtSubject>[];
    }
  }
}
