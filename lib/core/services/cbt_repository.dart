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
    relevant.sort(_bySubstanceThenGroup);
    return relevant;
  }

  /// Every real paper, regardless of faculty relevance.
  Future<List<CbtSubject>> all() async {
    final List<CbtSubject> remote = await _fetchRemoteSubjects();
    remote.sort(_bySubstanceThenGroup);
    return remote;
  }

  /// A paper with real questions someone has actually contributed always
  /// sorts above a "coming soon" placeholder — the whole point of a
  /// placeholder is to hold a spot in the list, not to compete with real
  /// content for a student's attention. Within each of those two groups,
  /// general-studies papers come first, then alphabetical by name, same
  /// ordering as before placeholders existed.
  static int _bySubstanceThenGroup(CbtSubject a, CbtSubject b) {
    final bool aPlaceholder = _isPlaceholder(a);
    final bool bPlaceholder = _isPlaceholder(b);
    if (aPlaceholder != bPlaceholder) {
      return aPlaceholder ? 1 : -1;
    }
    if (a.isGeneralStudies != b.isGeneralStudies) {
      return a.isGeneralStudies ? -1 : 1;
    }
    return a.name.compareTo(b.name);
  }

  static bool _isPlaceholder(CbtSubject s) =>
      s.questions.every((CbtQuestion q) => q.topic == 'Coming Soon');

  /// Supabase caps a single `select()` at ~1000 rows by default, so with the
  /// bank now well past that across all papers combined, a single
  /// unpaginated fetch silently truncated the result — whole papers past
  /// the cutoff (by insertion order) would vanish from the list even though
  /// their rows were still sitting untouched in the database. Page through
  /// with `.range()` until a page comes back short, so every paper's every
  /// question is always fetched regardless of how large the bank grows.
  Future<List<Map<String, dynamic>>> _fetchAllRows() async {
    const int pageSize = 1000;
    final List<Map<String, dynamic>> all = <Map<String, dynamic>>[];
    int start = 0;
    while (true) {
      final List<dynamic> page = await SupabaseService.client
          .from('cbt_questions')
          .select()
          .order('created_at')
          .range(start, start + pageSize - 1);
      all.addAll(page.whereType<Map<String, dynamic>>());
      if (page.length < pageSize) break;
      start += pageSize;
    }
    return all;
  }

  Future<List<CbtSubject>> _fetchRemoteSubjects() async {
    if (!SupabaseService.isReady) return <CbtSubject>[];

    try {
      final List<Map<String, dynamic>> rows = await _fetchAllRows();

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
        // The `faculty` column can hold more than one faculty as a
        // comma-separated list — a required ancillary course (MTH 121 and
        // similar) is often shared by several faculties' departments, not
        // just the one that authored the question bank.
        final String facultyRaw = (first['faculty'] ?? '') as String;
        final List<String> faculties = facultyRaw
            .split(',')
            .map((String f) => f.trim())
            .where((String f) => f.isNotEmpty)
            .toList();
        final String department = (first['department'] ?? '') as String;

        return CbtSubject(
          id: entry.key,
          name: (first['subject_name'] ?? entry.key) as String,
          description: department.isEmpty
              ? 'Contributed past questions'
              : 'Past questions for $department',
          questions: questions,
          faculties: faculties,
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
