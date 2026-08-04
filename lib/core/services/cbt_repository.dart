import 'package:flutter/foundation.dart';

import '../data/cbt_question_bank.dart';
import '../models/cbt.dart';
import 'supabase_service.dart';

/// Serves CBT papers from Supabase's `cbt_questions` table — real questions
/// the student (or their coursemates) have added — falling back to the
/// bundled starter bank whenever no real questions exist yet for a faculty,
/// or when running in Campus Mode.
///
/// This mirrors the merge pattern used by [ContentRepository] for materials
/// and videos: real, teacher- or student-supplied content always takes
/// priority over the sample bank, and nothing is ever left empty.
class CbtRepository {
  const CbtRepository();

  Future<List<CbtSubject>> forFaculty(String faculty) async {
    final List<CbtSubject> remote = await _fetchRemoteSubjects();
    final List<CbtSubject> seeded = CbtQuestionBank.forFaculty(faculty);

    // Real, contributed papers relevant to this faculty.
    final List<CbtSubject> relevantRemote = remote
        .where((CbtSubject s) => s.isRelevantTo(faculty))
        .toList();

    final List<CbtSubject> combined = <CbtSubject>[
      ...relevantRemote,
      ...seeded,
    ];
    combined.sort((CbtSubject a, CbtSubject b) {
      if (a.isGeneralStudies != b.isGeneralStudies) {
        return a.isGeneralStudies ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });
    return combined;
  }

  /// Every paper, contributed or bundled, regardless of faculty relevance.
  Future<List<CbtSubject>> all() async {
    final List<CbtSubject> remote = await _fetchRemoteSubjects();
    final List<CbtSubject> combined = <CbtSubject>[
      ...remote,
      ...CbtQuestionBank.subjects,
    ];
    combined.sort((CbtSubject a, CbtSubject b) {
      if (a.isGeneralStudies != b.isGeneralStudies) {
        return a.isGeneralStudies ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });
    return combined;
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
        );
      }).toList();
    } catch (error) {
      debugPrint('[Eduvora] cbt_questions fetch failed: $error');
      return <CbtSubject>[];
    }
  }
}
