import 'package:flutter/foundation.dart';

import '../models/cbt.dart';
import '../models/gpa.dart';
import 'local_store.dart';
import 'supabase_service.dart';

/// Persists semester results and CBT attempts.
///
/// Results are always written locally first — a student mid-revision should
/// never lose a computed GPA because the network dropped.
class StudyRepository {
  const StudyRepository();

  // ------------------------------------------------------------------ GPA

  List<SemesterRecord> semesters() {
    final List<SemesterRecord> saved =
        LocalStore.instance
            .readList(StoreKeys.gpaSemesters)
            .map(SemesterRecord.fromJson)
            .toList()
          ..sort(
            (SemesterRecord a, SemesterRecord b) =>
                a.savedAt.compareTo(b.savedAt),
          );
    return saved;
  }

  Future<void> saveSemester(SemesterRecord record) async {
    final List<SemesterRecord> current = semesters();
    final int index = current.indexWhere(
      (SemesterRecord s) => s.id == record.id,
    );
    if (index >= 0) {
      current[index] = record;
    } else {
      current.add(record);
    }
    await LocalStore.instance.writeList(
      StoreKeys.gpaSemesters,
      current.map((SemesterRecord s) => s.toJson()).toList(),
    );
    await _mirrorSemester(record);
  }

  Future<void> deleteSemester(String id) async {
    final List<SemesterRecord> current = semesters()
      ..removeWhere((SemesterRecord s) => s.id == id);
    await LocalStore.instance.writeList(
      StoreKeys.gpaSemesters,
      current.map((SemesterRecord s) => s.toJson()).toList(),
    );
  }

  GpaSettings gpaSettings() => GpaSettings.fromJson(
    LocalStore.instance.readMap(StoreKeys.gpaSettings),
  );

  Future<void> saveGpaSettings(GpaSettings settings) =>
      LocalStore.instance.writeMap(StoreKeys.gpaSettings, settings.toJson());

  /// The cumulative position across every saved semester, honouring the
  /// student's resit rule and any earlier CGPA they entered.
  CumulativeResult cumulative({SemesterRecord? extra}) =>
      GpaEngine.cumulative(semesters(), gpaSettings(), extra: extra);

  /// Cumulative GPA across every saved semester.
  double cumulativeGpa() => cumulative().cgpa;

  int totalUnitsPassed() => cumulative().unitsPassed;

  Future<void> _mirrorSemester(SemesterRecord record) async {
    if (!SupabaseService.isReady) return;
    try {
      await SupabaseService.client
          .from('gpa_semesters')
          .upsert(<String, dynamic>{
            ...record.toJson(),
            'user_id': SupabaseService.currentUser?.id,
            'gpa': record.gpa,
          });
    } catch (error) {
      debugPrint('[Eduvora] semester sync failed: $error');
    }
  }

  // ------------------------------------------------------------------ CBT

  List<CbtAttempt> attempts() {
    final List<CbtAttempt> saved =
        LocalStore.instance
            .readList(StoreKeys.cbtAttempts)
            .map(CbtAttempt.fromJson)
            .toList()
          ..sort(
            (CbtAttempt a, CbtAttempt b) => b.takenAt.compareTo(a.takenAt),
          );
    return saved;
  }

  List<CbtAttempt> attemptsFor(String subjectId) =>
      attempts().where((CbtAttempt a) => a.subjectId == subjectId).toList();

  CbtAttempt? bestAttemptFor(String subjectId) {
    final List<CbtAttempt> list = attemptsFor(subjectId);
    if (list.isEmpty) return null;
    list.sort((CbtAttempt a, CbtAttempt b) => b.score.compareTo(a.score));
    return list.first;
  }

  Future<void> saveAttempt(CbtAttempt attempt) async {
    final List<Map<String, dynamic>> current = LocalStore.instance.readList(
      StoreKeys.cbtAttempts,
    )..insert(0, attempt.toJson());
    // Keep the history bounded so the store stays small on low-end devices.
    final List<Map<String, dynamic>> trimmed = current.length > 200
        ? current.sublist(0, 200)
        : current;
    await LocalStore.instance.writeList(StoreKeys.cbtAttempts, trimmed);

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client.from('cbt_attempts').insert(
          <String, dynamic>{
            ...attempt.toJson(),
            'user_id': SupabaseService.currentUser?.id,
          },
        );
      } catch (error) {
        debugPrint('[Eduvora] attempt sync failed: $error');
      }
    }
  }

  /// Average percentage across every paper attempted.
  double averageScore() {
    final List<CbtAttempt> all = attempts();
    if (all.isEmpty) return 0;
    final double total = all.fold(
      0,
      (double sum, CbtAttempt a) => sum + a.percentage,
    );
    return total / all.length;
  }

  int totalQuestionsAnswered() =>
      attempts().fold(0, (int sum, CbtAttempt a) => sum + a.answers.length);
}
