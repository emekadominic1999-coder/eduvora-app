import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cbt.dart';
import 'supabase_service.dart';

/// Serves CBT papers from Supabase's `cbt_questions` table — real questions
/// the student (or their coursemates) have added. There is no fallback
/// sample bank: a paper only ever appears here once someone has actually
/// contributed real questions for it.
class CbtRepository {
  const CbtRepository();

  // The paper list comes from the small `cbt_subject_summaries` view (one row
  // per paper); a paper's questions are only downloaded when it is started
  // (see [withQuestions]). Pulling the whole bank just to draw the list was
  // ~19 MB and slow or failing on a phone connection. Both are cached in
  // memory for a few minutes so navigating back and forth is instant; a
  // genuinely new question added meanwhile takes up to this long to appear.
  static List<CbtSubject>? _cache;
  static DateTime? _cachedAt;
  static final Map<String, ({DateTime at, List<CbtQuestion> questions})>
  _questionCache = <String, ({DateTime at, List<CbtQuestion> questions})>{};
  static const Duration _cacheTtl = Duration(minutes: 5);
  static const int _pageSize = 1000;

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

  /// [subject] with its questions loaded. Returns it unchanged if they
  /// already are. Throws if the download fails.
  Future<CbtSubject> withQuestions(CbtSubject subject) async {
    if (subject.hasQuestions) return subject;

    final ({DateTime at, List<CbtQuestion> questions})? cached =
        _questionCache[subject.id];
    if (cached != null && DateTime.now().difference(cached.at) < _cacheTtl) {
      return subject.withQuestions(cached.questions);
    }

    final List<CbtQuestion> questions = (await _fetchAllRows(
      subjectId: subject.id,
    )).map(CbtQuestion.fromJson).toList();
    _questionCache[subject.id] = (at: DateTime.now(), questions: questions);
    return subject.withQuestions(questions);
  }

  /// A paper with real questions someone has actually contributed always
  /// sorts above a "coming soon" placeholder — the whole point of a
  /// placeholder is to hold a spot in the list, not to compete with real
  /// content for a student's attention. Within each of those two groups,
  /// general-studies papers come first, then alphabetical by name, same
  /// ordering as before placeholders existed.
  static int _bySubstanceThenGroup(CbtSubject a, CbtSubject b) {
    final bool aPlaceholder = a.isPlaceholder;
    final bool bPlaceholder = b.isPlaceholder;
    if (aPlaceholder != bPlaceholder) {
      return aPlaceholder ? 1 : -1;
    }
    if (a.isGeneralStudies != b.isGeneralStudies) {
      return a.isGeneralStudies ? -1 : 1;
    }
    return a.name.compareTo(b.name);
  }

  /// Supabase caps a single `select()` at ~1000 rows by default, so a single
  /// unpaginated fetch silently truncates the result — the tail of a long
  /// paper (or whole papers past the cutoff) would vanish. Page through with
  /// `.range()` until a page comes back short. [subjectId] limits it to one
  /// paper; null reads the entire bank (the fallback when the summaries view
  /// is missing).
  Future<List<Map<String, dynamic>>> _fetchAllRows({String? subjectId}) async {
    if (!SupabaseService.isReady) throw StateError('Supabase is not ready');

    final List<Map<String, dynamic>> all = <Map<String, dynamic>>[];
    int start = 0;
    while (true) {
      final PostgrestFilterBuilder<PostgrestList> select = SupabaseService
          .client
          .from('cbt_questions')
          .select();
      final List<dynamic> page =
          await (subjectId == null
                  ? select
                  : select.eq('subject_id', subjectId))
              .order('created_at')
              .range(start, start + _pageSize - 1);
      all.addAll(page.whereType<Map<String, dynamic>>());
      if (page.length < _pageSize) break;
      start += _pageSize;
    }
    return all;
  }

  Future<List<CbtSubject>> _fetchRemoteSubjects() async {
    if (!SupabaseService.isReady) return <CbtSubject>[];

    final List<CbtSubject>? cached = _cache;
    final DateTime? cachedAt = _cachedAt;
    if (cached != null &&
        cachedAt != null &&
        DateTime.now().difference(cachedAt) < _cacheTtl) {
      return cached;
    }

    List<CbtSubject> subjects;
    try {
      subjects = await _fetchFromSummaries();
    } catch (error) {
      // The view may not exist in this Supabase project yet (or the request
      // failed): fall back to downloading every question, as before.
      debugPrint('[Eduvora] cbt_subject_summaries unavailable: $error');
      try {
        subjects = await _fetchFromFullTable();
      } catch (error) {
        debugPrint('[Eduvora] cbt_questions fetch failed: $error');
        return <CbtSubject>[];
      }
    }
    _cache = subjects;
    _cachedAt = DateTime.now();
    return subjects;
  }

  Future<List<CbtSubject>> _fetchFromSummaries() async {
    final List<CbtSubject> subjects = <CbtSubject>[];
    int start = 0;
    while (true) {
      final List<dynamic> page = await SupabaseService.client
          .from('cbt_subject_summaries')
          .select()
          .order('subject_id')
          .range(start, start + _pageSize - 1);
      for (final Map<String, dynamic> row
          in page.whereType<Map<String, dynamic>>()) {
        final String id = (row['subject_id'] ?? '') as String;
        if (id.isEmpty) continue;
        subjects.add(
          _subjectFrom(
            id,
            row,
            questionCount: (row['question_count'] as num?)?.toInt() ?? 0,
            topics: (row['topics'] as List<dynamic>? ?? <dynamic>[])
                .whereType<String>()
                .toList(),
            onlyPlaceholder: (row['only_placeholder'] as bool?) ?? false,
          ),
        );
      }
      if (page.length < _pageSize) break;
      start += _pageSize;
    }
    return subjects;
  }

  /// The pre-view behaviour: download every question, group by paper.
  Future<List<CbtSubject>> _fetchFromFullTable() async {
    final Map<String, List<Map<String, dynamic>>> bySubject =
        <String, List<Map<String, dynamic>>>{};
    for (final Map<String, dynamic> raw in await _fetchAllRows()) {
      final String subjectId = (raw['subject_id'] ?? '') as String;
      if (subjectId.isEmpty) continue;
      bySubject.putIfAbsent(subjectId, () => <Map<String, dynamic>>[]).add(raw);
    }

    return bySubject.entries.map((
      MapEntry<String, List<Map<String, dynamic>>> entry,
    ) {
      final List<CbtQuestion> questions = entry.value
          .map(CbtQuestion.fromJson)
          .toList();
      return _subjectFrom(
        entry.key,
        entry.value.first,
        questionCount: questions.length,
        questions: questions,
      );
    }).toList();
  }

  /// The `faculty` column can hold more than one faculty as a
  /// comma-separated list — a required ancillary course (MTH 121 and
  /// similar) is often shared by several faculties' departments, not just
  /// the one that authored the question bank.
  static CbtSubject _subjectFrom(
    String id,
    Map<String, dynamic> meta, {
    required int questionCount,
    List<CbtQuestion> questions = const <CbtQuestion>[],
    List<String>? topics,
    bool? onlyPlaceholder,
  }) {
    final List<String> faculties = ((meta['faculty'] ?? '') as String)
        .split(',')
        .map((String f) => f.trim())
        .where((String f) => f.isNotEmpty)
        .toList();
    final String department = (meta['department'] ?? '') as String;

    return CbtSubject(
      id: id,
      name: (meta['subject_name'] ?? id) as String,
      description: department.isEmpty
          ? 'Contributed past questions'
          : 'Past questions for $department',
      questions: questions,
      faculties: faculties,
      minutesPerAttempt: (questionCount * 1.2).ceil().clamp(10, 45),
      isGeneralStudies: (meta['is_general'] ?? false) as bool,
      department: department,
      level: (meta['level'] ?? '') as String,
      semester: (meta['semester'] ?? '') as String,
      units: (meta['units'] as num?)?.toInt() ?? 0,
      questionCount: questionCount,
      topics: topics,
      onlyPlaceholder: onlyPlaceholder,
    );
  }
}
