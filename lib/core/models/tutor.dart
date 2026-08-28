import 'package:flutter/foundation.dart';

/// Where a tutor profile stands.
enum TutorStatus {
  pending,
  approved,
  suspended;

  static TutorStatus fromName(String? name) => switch (name) {
    'approved' => TutorStatus.approved,
    'suspended' => TutorStatus.suspended,
    _ => TutorStatus.pending,
  };
}

/// One course a tutor is cleared to teach, and what they charge for it.
///
/// [cbtScore] is the percentage they actually scored on that paper in the
/// app's own CBT bank — it is verified server-side before the listing is
/// created, which is what makes it worth showing to a student.
@immutable
class TutorCourse {
  const TutorCourse({
    required this.subjectId,
    required this.subjectName,
    required this.cbtScore,
    required this.hourlyRateKobo,
    this.verifiedByCbt = true,
  });

  final String subjectId;
  final String subjectName;
  final int cbtScore;
  final int hourlyRateKobo;

  /// False for a course an operator approved by hand (no paper was sat,
  /// so [cbtScore] is meaningless — always 0 for these) rather than the
  /// automatic CBT-score check.
  final bool verifiedByCbt;

  double get hourlyRateNaira => hourlyRateKobo / 100;

  /// What an hour with this tutor costs, e.g. "₦1,500".
  String get rateLabel => '₦${hourlyRateNaira.round()}';

  factory TutorCourse.fromJson(Map<String, dynamic> json) => TutorCourse(
    subjectId: (json['subject_id'] ?? '') as String,
    subjectName: (json['subject_name'] ?? '') as String,
    cbtScore: (json['cbt_score'] as num?)?.toInt() ?? 0,
    hourlyRateKobo: (json['hourly_rate_kobo'] as num?)?.toInt() ?? 0,
    verifiedByCbt: (json['verification_method'] as String? ?? 'cbt') == 'cbt',
  );
}

/// A student who has been verified to teach one or more papers.
@immutable
class Tutor {
  const Tutor({
    required this.id,
    required this.userId,
    required this.headline,
    required this.bio,
    required this.status,
    required this.courses,
    this.applicationNote = '',
    this.fullName = '',
    this.department = '',
    this.level = '',
    this.avatarUrl,
    this.ratingSum = 0,
    this.ratingCount = 0,
    this.sessionsCompleted = 0,
    this.balanceKobo = 0,
    this.lifetimeEarnedKobo = 0,
  });

  final String id;
  final String userId;
  final String headline;
  final String bio;
  final TutorStatus status;
  final List<TutorCourse> courses;

  /// Set only on the manual-review path — why this student says they'd be
  /// a good tutor, for whoever approves the application to read.
  final String applicationNote;

  /// Joined from the student's profile for display.
  final String fullName;
  final String department;
  final String level;
  final String? avatarUrl;

  final int ratingSum;
  final int ratingCount;
  final int sessionsCompleted;

  /// Only ever populated for the signed-in tutor's own profile.
  final int balanceKobo;
  final int lifetimeEarnedKobo;

  bool get hasRating => ratingCount > 0;

  double get rating => ratingCount == 0 ? 0 : ratingSum / ratingCount;

  String get ratingLabel => hasRating ? rating.toStringAsFixed(1) : 'New';

  double get balanceNaira => balanceKobo / 100;

  double get lifetimeEarnedNaira => lifetimeEarnedKobo / 100;

  TutorCourse? courseFor(String subjectId) {
    for (final TutorCourse course in courses) {
      if (course.subjectId == subjectId) return course;
    }
    return null;
  }

  bool teaches(String subjectId) => courseFor(subjectId) != null;

  String get initials {
    final List<String> parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'T';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  factory Tutor.fromJson(
    Map<String, dynamic> json, {
    List<TutorCourse> courses = const <TutorCourse>[],
  }) {
    final Map<String, dynamic>? profile =
        json['profiles'] as Map<String, dynamic>?;
    return Tutor(
      id: (json['id'] ?? '') as String,
      userId: (json['user_id'] ?? '') as String,
      headline: (json['headline'] ?? '') as String,
      bio: (json['bio'] ?? '') as String,
      status: TutorStatus.fromName(json['status'] as String?),
      courses: courses,
      applicationNote: (json['application_note'] ?? '') as String,
      fullName: (profile?['full_name'] ?? '') as String,
      department: (profile?['department'] ?? '') as String,
      level: (profile?['level'] ?? '') as String,
      avatarUrl: profile?['avatar_url'] as String?,
      ratingSum: (json['rating_sum'] as num?)?.toInt() ?? 0,
      ratingCount: (json['rating_count'] as num?)?.toInt() ?? 0,
      sessionsCompleted: (json['sessions_completed'] as num?)?.toInt() ?? 0,
      balanceKobo: (json['balance_kobo'] as num?)?.toInt() ?? 0,
      lifetimeEarnedKobo: (json['lifetime_earned_kobo'] as num?)?.toInt() ?? 0,
    );
  }
}

/// How far along a booking is.
enum TutorSessionStatus {
  requested,
  accepted,
  paid,
  completed,
  cancelled,
  disputed;

  static TutorSessionStatus fromName(String? name) => switch (name) {
    'accepted' => TutorSessionStatus.accepted,
    'paid' => TutorSessionStatus.paid,
    'completed' => TutorSessionStatus.completed,
    'cancelled' => TutorSessionStatus.cancelled,
    'disputed' => TutorSessionStatus.disputed,
    _ => TutorSessionStatus.requested,
  };

  String get wireName => switch (this) {
    TutorSessionStatus.requested => 'requested',
    TutorSessionStatus.accepted => 'accepted',
    TutorSessionStatus.paid => 'paid',
    TutorSessionStatus.completed => 'completed',
    TutorSessionStatus.cancelled => 'cancelled',
    TutorSessionStatus.disputed => 'disputed',
  };

  /// What the student sees.
  String get studentLabel => switch (this) {
    TutorSessionStatus.requested => 'Waiting for the tutor',
    TutorSessionStatus.accepted => 'Accepted — pay to confirm',
    TutorSessionStatus.paid => 'Confirmed',
    TutorSessionStatus.completed => 'Completed',
    TutorSessionStatus.cancelled => 'Cancelled',
    TutorSessionStatus.disputed => 'Reported',
  };

  /// What the tutor sees.
  String get tutorLabel => switch (this) {
    TutorSessionStatus.requested => 'New request',
    TutorSessionStatus.accepted => 'Waiting for payment',
    TutorSessionStatus.paid => 'Confirmed — go ahead',
    TutorSessionStatus.completed => 'Completed',
    TutorSessionStatus.cancelled => 'Cancelled',
    TutorSessionStatus.disputed => 'Reported',
  };
}

/// Where a session takes place.
enum TutorMeetingMode {
  online,
  inPerson;

  static TutorMeetingMode fromName(String? name) =>
      name == 'in_person' ? TutorMeetingMode.inPerson : TutorMeetingMode.online;

  String get wireName =>
      this == TutorMeetingMode.inPerson ? 'in_person' : 'online';

  String get label =>
      this == TutorMeetingMode.inPerson ? 'In person' : 'Online';
}

/// A booking between a student and a tutor.
@immutable
class TutorSession {
  const TutorSession({
    required this.id,
    required this.studentId,
    required this.tutorId,
    required this.subjectId,
    required this.subjectName,
    required this.status,
    required this.durationMinutes,
    required this.createdAt,
    this.topic = '',
    this.meetingMode = TutorMeetingMode.online,
    this.scheduledAt,
    this.amountKobo = 0,
    this.platformFeeKobo = 0,
    this.tutorEarningsKobo = 0,
    this.tutorName = '',
    this.studentName = '',
  });

  final String id;
  final String studentId;
  final String tutorId;
  final String subjectId;
  final String subjectName;
  final String topic;
  final TutorMeetingMode meetingMode;
  final DateTime? scheduledAt;
  final int durationMinutes;
  final int amountKobo;
  final int platformFeeKobo;
  final int tutorEarningsKobo;
  final TutorSessionStatus status;
  final DateTime createdAt;

  /// Joined for display; not columns on the row itself.
  final String tutorName;
  final String studentName;

  double get amountNaira => amountKobo / 100;

  double get tutorEarningsNaira => tutorEarningsKobo / 100;

  bool get awaitingPayment => status == TutorSessionStatus.accepted;

  bool get isSettled =>
      status == TutorSessionStatus.completed ||
      status == TutorSessionStatus.cancelled;

  String get durationLabel {
    if (durationMinutes % 60 == 0) {
      final int hours = durationMinutes ~/ 60;
      return hours == 1 ? '1 hour' : '$hours hours';
    }
    return '$durationMinutes min';
  }

  factory TutorSession.fromJson(Map<String, dynamic> json) => TutorSession(
    id: (json['id'] ?? '') as String,
    studentId: (json['student_id'] ?? '') as String,
    tutorId: (json['tutor_id'] ?? '') as String,
    subjectId: (json['subject_id'] ?? '') as String,
    subjectName: (json['subject_name'] ?? '') as String,
    topic: (json['topic'] ?? '') as String,
    meetingMode: TutorMeetingMode.fromName(json['meeting_mode'] as String?),
    scheduledAt: DateTime.tryParse((json['scheduled_at'] ?? '') as String),
    durationMinutes: (json['duration_minutes'] as num?)?.toInt() ?? 60,
    amountKobo: (json['amount_kobo'] as num?)?.toInt() ?? 0,
    platformFeeKobo: (json['platform_fee_kobo'] as num?)?.toInt() ?? 0,
    tutorEarningsKobo: (json['tutor_earnings_kobo'] as num?)?.toInt() ?? 0,
    status: TutorSessionStatus.fromName(json['status'] as String?),
    createdAt:
        DateTime.tryParse((json['created_at'] ?? '') as String) ??
        DateTime.now(),
  );

  TutorSession withNames({String? tutorName, String? studentName}) =>
      TutorSession(
        id: id,
        studentId: studentId,
        tutorId: tutorId,
        subjectId: subjectId,
        subjectName: subjectName,
        topic: topic,
        meetingMode: meetingMode,
        scheduledAt: scheduledAt,
        durationMinutes: durationMinutes,
        amountKobo: amountKobo,
        platformFeeKobo: platformFeeKobo,
        tutorEarningsKobo: tutorEarningsKobo,
        status: status,
        createdAt: createdAt,
        tutorName: tutorName ?? this.tutorName,
        studentName: studentName ?? this.studentName,
      );
}

/// A student's review of a completed session.
@immutable
class TutorReview {
  const TutorReview({
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.studentName = '',
  });

  final int rating;
  final String comment;
  final DateTime createdAt;
  final String studentName;

  factory TutorReview.fromJson(Map<String, dynamic> json) => TutorReview(
    rating: (json['rating'] as num?)?.toInt() ?? 0,
    comment: (json['comment'] ?? '') as String,
    createdAt:
        DateTime.tryParse((json['created_at'] ?? '') as String) ??
        DateTime.now(),
  );
}
