import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FunctionException;

import '../models/tutor.dart';
import 'supabase_service.dart';

/// Fronts the tutor marketplace: finding tutors, applying to become one,
/// booking and paying for sessions, and a tutor's own earnings.
///
/// Anything involving money — pricing a session, marking it paid, crediting
/// a balance, requesting a payout — goes through an edge function running
/// with the service-role key. This repository never writes those columns
/// directly, so there is no client-side path to a free session or an
/// invented balance.
class TutorRepository {
  const TutorRepository();

  /// The score a tutor must reach on a paper before they may teach it.
  /// Mirrors TUTOR_MIN_SCORE in the edge functions, for display only — the
  /// binding check is server-side.
  static const int minCbtScore = 75;

  /// The smallest attempt that counts towards that score. Mirrors
  /// MIN_ATTEMPT_QUESTIONS_FOR_TUTOR in the edge functions — without this, a
  /// lucky score on the 5-question free trial would look eligible here and
  /// then be rejected on submit, for reasons the screen never explained.
  static const int minAttemptQuestions = 20;

  /// Eduvora's cut, for display on the tutor's earnings screen.
  static const double commission = 0.15;

  static const int minHourlyRateKobo = 50000;
  static const int maxHourlyRateKobo = 1000000;
  static const int minPayoutKobo = 100000;

  // ------------------------------------------------------------- discovery

  /// Approved tutors, newest-rated first. [subjectId] narrows to those
  /// cleared to teach one specific paper.
  Future<List<Tutor>> browse({String subjectId = ''}) async {
    if (!SupabaseService.isReady) return <Tutor>[];
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('tutors')
          .select()
          .eq('status', 'approved');

      final List<Tutor> tutors = await _attachCourses(
        rows.whereType<Map<String, dynamic>>().toList(),
      );

      final List<Tutor> relevant = subjectId.isEmpty
          ? tutors
          : tutors.where((Tutor t) => t.teaches(subjectId)).toList();

      // A tutor with no rating yet still deserves to be found, so newcomers
      // sort by sessions completed rather than falling to the bottom
      // forever behind anyone with a single five-star review.
      relevant.sort((Tutor a, Tutor b) {
        if (a.hasRating != b.hasRating) return a.hasRating ? -1 : 1;
        if (a.hasRating && b.hasRating) {
          final int byRating = b.rating.compareTo(a.rating);
          if (byRating != 0) return byRating;
        }
        return b.sessionsCompleted.compareTo(a.sessionsCompleted);
      });
      return relevant;
    } catch (error) {
      debugPrint('[Eduvora] tutor browse failed: $error');
      return <Tutor>[];
    }
  }

  /// The signed-in student's own tutor profile, if they have one.
  Future<Tutor?> myTutorProfile() async {
    final String? userId = SupabaseService.currentUser?.id;
    if (!SupabaseService.isReady || userId == null) return null;
    try {
      final Map<String, dynamic>? row = await SupabaseService.client
          .from('tutors')
          .select()
          .eq('user_id', userId)
          .maybeSingle();
      if (row == null) return null;
      final List<Tutor> withCourses = await _attachCourses(<Map<String, dynamic>>[row]);
      return withCourses.isEmpty ? null : withCourses.first;
    } catch (error) {
      debugPrint('[Eduvora] tutor profile fetch failed: $error');
      return null;
    }
  }

  Future<List<TutorReview>> reviewsFor(String tutorId) async {
    if (!SupabaseService.isReady) return <TutorReview>[];
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('tutor_reviews')
          .select()
          .eq('tutor_id', tutorId)
          .order('created_at', ascending: false)
          .limit(20);

      final List<Map<String, dynamic>> reviews =
          rows.whereType<Map<String, dynamic>>().toList();
      final Map<String, Map<String, dynamic>> profiles = await _profilesFor(
        reviews
            .map((Map<String, dynamic> r) => (r['student_id'] ?? '') as String)
            .where((String id) => id.isNotEmpty)
            .toList(),
      );

      return reviews.map((Map<String, dynamic> row) {
        final String studentId = (row['student_id'] ?? '') as String;
        final TutorReview review = TutorReview.fromJson(row);
        return TutorReview(
          rating: review.rating,
          comment: review.comment,
          createdAt: review.createdAt,
          studentName: (profiles[studentId]?['full_name'] ?? '') as String,
        );
      }).toList();
    } catch (error) {
      debugPrint('[Eduvora] tutor reviews fetch failed: $error');
      return <TutorReview>[];
    }
  }

  /// Loads each tutor's course listings and display name in one round trip
  /// each, rather than a pair of queries per tutor.
  ///
  /// `tutors.user_id` points at `auth.users`, not `profiles`, so there is no
  /// foreign key for PostgREST to embed across — the names are fetched
  /// separately and merged here.
  Future<List<Tutor>> _attachCourses(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return <Tutor>[];
    final List<String> ids = rows
        .map((Map<String, dynamic> r) => (r['id'] ?? '') as String)
        .where((String id) => id.isNotEmpty)
        .toList();
    if (ids.isEmpty) return <Tutor>[];

    final List<dynamic> courseRows = await SupabaseService.client
        .from('tutor_courses')
        .select()
        .inFilter('tutor_id', ids);

    final Map<String, List<TutorCourse>> byTutor =
        <String, List<TutorCourse>>{};
    for (final dynamic raw in courseRows) {
      if (raw is! Map<String, dynamic>) continue;
      final String tutorId = (raw['tutor_id'] ?? '') as String;
      byTutor
          .putIfAbsent(tutorId, () => <TutorCourse>[])
          .add(TutorCourse.fromJson(raw));
    }

    final Map<String, Map<String, dynamic>> profiles = await _profilesFor(
      rows
          .map((Map<String, dynamic> r) => (r['user_id'] ?? '') as String)
          .where((String id) => id.isNotEmpty)
          .toList(),
    );

    return rows.map((Map<String, dynamic> row) {
      final String id = (row['id'] ?? '') as String;
      final String userId = (row['user_id'] ?? '') as String;
      return Tutor.fromJson(
        <String, dynamic>{...row, 'profiles': profiles[userId]},
        courses: byTutor[id] ?? const <TutorCourse>[],
      );
    }).toList();
  }

  /// Display details for a set of users, keyed by id. Missing rows simply
  /// come back absent — a tutor whose profile has not been filled in yet
  /// still lists, just without a name attached.
  Future<Map<String, Map<String, dynamic>>> _profilesFor(
    List<String> userIds,
  ) async {
    if (userIds.isEmpty) return <String, Map<String, dynamic>>{};
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('profiles')
          .select('id, full_name, department, level, avatar_url')
          .inFilter('id', userIds.toSet().toList());
      return <String, Map<String, dynamic>>{
        for (final dynamic raw in rows)
          if (raw is Map<String, dynamic>) (raw['id'] ?? '') as String: raw,
      };
    } catch (error) {
      debugPrint('[Eduvora] tutor profile names fetch failed: $error');
      return <String, Map<String, dynamic>>{};
    }
  }

  // ------------------------------------------------------------- becoming one

  /// Applies to teach [courses]. Each one is verified against the student's
  /// real CBT attempts server-side; the whole application is refused if any
  /// course falls short, with a message naming the paper and their score.
  Future<void> apply({
    required String headline,
    required String bio,
    required List<({String subjectId, String subjectName, int hourlyRateKobo})>
    courses,
  }) => _invoke('tutor-apply', <String, dynamic>{
    'headline': headline,
    'bio': bio,
    'courses': courses
        .map(
          (({String subjectId, String subjectName, int hourlyRateKobo}) c) =>
              <String, dynamic>{
                'subjectId': c.subjectId,
                'subjectName': c.subjectName,
                'hourlyRateKobo': c.hourlyRateKobo,
              },
        )
        .toList(),
  });

  /// The slower path in: no CBT score required, just [applicationNote]
  /// explaining why this student would be a good tutor. Creates or updates
  /// a 'pending' profile for an operator to approve by hand — never
  /// approves automatically, since there is nothing here the server can
  /// verify itself. Only for a first-time applicant; an already-approved
  /// tutor should add courses through [apply] instead.
  Future<void> applyManual({
    required String headline,
    required String bio,
    required String applicationNote,
    required List<({String subjectId, String subjectName, int hourlyRateKobo})>
    courses,
  }) => _invoke('tutor-apply-manual', <String, dynamic>{
    'headline': headline,
    'bio': bio,
    'applicationNote': applicationNote,
    'courses': courses
        .map(
          (({String subjectId, String subjectName, int hourlyRateKobo}) c) =>
              <String, dynamic>{
                'subjectId': c.subjectId,
                'subjectName': c.subjectName,
                'hourlyRateKobo': c.hourlyRateKobo,
              },
        )
        .toList(),
  });

  // ---------------------------------------------------------------- sessions

  /// Every session the signed-in student is part of, on either side.
  Future<List<TutorSession>> mySessions() async {
    if (!SupabaseService.isReady) return <TutorSession>[];
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('tutor_sessions')
          .select()
          .order('created_at', ascending: false);
      return rows
          .whereType<Map<String, dynamic>>()
          .map(TutorSession.fromJson)
          .toList();
    } catch (error) {
      debugPrint('[Eduvora] sessions fetch failed: $error');
      return <TutorSession>[];
    }
  }

  /// Asks a tutor for a slot. No money is attached yet — the price is set
  /// server-side once the tutor accepts, from their own listed rate.
  Future<void> requestSession({
    required String tutorId,
    required String subjectId,
    required String subjectName,
    required String topic,
    required TutorMeetingMode mode,
    required int durationMinutes,
    DateTime? scheduledAt,
  }) async {
    final String? userId = SupabaseService.currentUser?.id;
    if (!SupabaseService.isReady || userId == null) {
      throw StateError('Booking a session needs you to be signed in.');
    }
    await SupabaseService.client.from('tutor_sessions').insert(<String, dynamic>{
      'student_id': userId,
      'tutor_id': tutorId,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'topic': topic,
      'meeting_mode': mode.wireName,
      'duration_minutes': durationMinutes,
      'scheduled_at': scheduledAt?.toIso8601String(),
      'status': 'requested',
    });
  }

  /// Tutor accepts a request, or either side cancels one. Both are
  /// money-free status moves, so they go straight through RLS.
  Future<void> setSessionStatus(
    String sessionId,
    TutorSessionStatus status,
  ) async {
    if (!SupabaseService.isReady) return;
    await SupabaseService.client
        .from('tutor_sessions')
        .update(<String, dynamic>{'status': status.wireName})
        .eq('id', sessionId);
  }

  /// Opens a Paystack checkout for an accepted session.
  Future<({String authorizationUrl, String reference, int amountKobo})>
  paySession(String sessionId) async {
    final Map<String, dynamic> data = await _invoke(
      'tutor-session-pay',
      <String, dynamic>{'sessionId': sessionId},
    );
    return (
      authorizationUrl: data['authorizationUrl'] as String,
      reference: data['reference'] as String,
      amountKobo: (data['amountKobo'] as num).toInt(),
    );
  }

  /// Re-checks a session's payment with Paystack. Shares the same endpoint
  /// as CBT purchases, which is also the single webhook URL.
  Future<bool> verifyPayment(String reference) async {
    if (!SupabaseService.isReady) return false;
    try {
      final response = await SupabaseService.client.functions.invoke(
        'paystack-verify',
        body: <String, dynamic>{'reference': reference},
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      return data['verified'] == true;
    } catch (error) {
      debugPrint('[Eduvora] session payment verify failed: $error');
      return false;
    }
  }

  /// The student confirms the session happened — the only thing that credits
  /// the tutor. A rating may ride along in the same call.
  Future<void> completeSession(
    String sessionId, {
    int? rating,
    String comment = '',
  }) => _invoke('tutor-session-complete', <String, dynamic>{
    'sessionId': sessionId,
    'rating': ?rating,
    if (comment.isNotEmpty) 'comment': comment,
  });

  // ----------------------------------------------------------------- payouts

  Future<void> requestPayout({
    required int amountKobo,
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) => _invoke('tutor-payout-request', <String, dynamic>{
    'amountKobo': amountKobo,
    'bankName': bankName,
    'accountNumber': accountNumber,
    'accountName': accountName,
  });

  // ----------------------------------------------------------------- helpers

  /// Calls an edge function and turns its JSON `error` into a plain-English
  /// [StateError], so screens can show the real reason (score too low, rate
  /// out of range, balance too small) rather than a raw HTTP failure.
  Future<Map<String, dynamic>> _invoke(
    String name,
    Map<String, dynamic> body,
  ) async {
    if (!SupabaseService.isReady) {
      throw StateError('This needs the Eduvora backend to be connected.');
    }
    try {
      final response = await SupabaseService.client.functions.invoke(
        name,
        body: body,
      );
      return (response.data as Map<String, dynamic>?) ?? <String, dynamic>{};
    } on FunctionException catch (error) {
      final Object? details = error.details;
      final String? reason = details is Map && details['error'] is String
          ? details['error'] as String
          : null;
      throw StateError(reason ?? 'That did not go through. Please try again.');
    }
  }
}
