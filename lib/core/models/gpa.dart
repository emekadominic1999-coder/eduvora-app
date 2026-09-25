import 'package:flutter/foundation.dart';

/// The 5-point grading scale used across Nigerian higher institutions
/// (score bands as used at the University of Nigeria, Nsukka).
enum Grade {
  a('A', 5, 'Excellent', '70 – 100'),
  b('B', 4, 'Very Good', '60 – 69'),
  c('C', 3, 'Good', '50 – 59'),
  d('D', 2, 'Fair', '45 – 49'),
  e('E', 1, 'Pass', '40 – 44'),
  f('F', 0, 'Fail', '0 – 39');

  const Grade(this.letter, this.point, this.category, this.scoreBand);

  final String letter;
  final int point;
  final String category;
  final String scoreBand;

  /// The grade a percentage score earns, or null if it is not 0–100.
  static Grade? fromScore(num? score) {
    if (score == null || score < 0 || score > 100) return null;
    if (score >= 70) return Grade.a;
    if (score >= 60) return Grade.b;
    if (score >= 50) return Grade.c;
    if (score >= 45) return Grade.d;
    if (score >= 40) return Grade.e;
    return Grade.f;
  }

  static Grade? tryLetter(String? letter) {
    if (letter == null || letter.isEmpty) return null;
    for (final Grade g in Grade.values) {
      if (g.letter == letter.toUpperCase()) return g;
    }
    return null;
  }

  static Grade fromLetter(String? letter) => tryLetter(letter) ?? Grade.a;
}

/// One registered course inside a semester.
///
/// [grade] is null until the student picks one (or types a score); a course
/// without a grade is left out of every total rather than silently counted
/// as an A.
@immutable
class CourseEntry {
  const CourseEntry({
    required this.id,
    required this.code,
    required this.creditUnits,
    this.grade,
    this.score,
  });

  final String id;
  final String code;
  final int creditUnits;
  final Grade? grade;

  /// The percentage the student typed, when they entered a score.
  final int? score;

  bool get isGraded => grade != null;

  /// Course code with spacing and case ignored ("phy 102" == "PHY102").
  String get key => code.replaceAll(RegExp(r'\s+'), '').toUpperCase();

  /// Credit units × grade value (0 while ungraded).
  int get qualityPoints => grade == null ? 0 : creditUnits * grade!.point;

  CourseEntry copyWith({
    String? code,
    int? creditUnits,
    Grade? grade,
    bool clearGrade = false,
    int? score,
    bool clearScore = false,
  }) => CourseEntry(
    id: id,
    code: code ?? this.code,
    creditUnits: creditUnits ?? this.creditUnits,
    grade: clearGrade ? null : (grade ?? this.grade),
    score: clearScore ? null : (score ?? this.score),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'code': code,
    'credit_units': creditUnits,
    'grade': grade?.letter,
    if (score != null) 'score': score,
  };

  factory CourseEntry.fromJson(Map<String, dynamic> json) => CourseEntry(
    id: (json['id'] ?? '') as String,
    code: (json['code'] ?? '') as String,
    creditUnits: (json['credit_units'] as num?)?.toInt() ?? 0,
    grade: Grade.tryLetter(json['grade'] as String?),
    score: (json['score'] as num?)?.toInt(),
  );
}

/// A saved semester result used to build the running CGPA.
@immutable
class SemesterRecord {
  const SemesterRecord({
    required this.id,
    required this.label,
    required this.courses,
    required this.savedAt,
  });

  final String id;
  final String label;
  final List<CourseEntry> courses;
  final DateTime savedAt;

  Iterable<CourseEntry> get _graded =>
      courses.where((CourseEntry c) => c.isGraded);

  /// TNU: total units registered (graded courses).
  int get totalUnits =>
      _graded.fold(0, (int sum, CourseEntry c) => sum + c.creditUnits);

  /// TCP: total credit (quality) points.
  int get totalQualityPoints =>
      _graded.fold(0, (int sum, CourseEntry c) => sum + c.qualityPoints);

  /// Units actually passed (everything except an F).
  int get unitsPassed => _graded
      .where((CourseEntry c) => c.grade != Grade.f)
      .fold(0, (int sum, CourseEntry c) => sum + c.creditUnits);

  int get failedCount =>
      _graded.where((CourseEntry c) => c.grade == Grade.f).length;

  /// GPA = TCP ⁄ TNU
  double get gpa => totalUnits == 0 ? 0 : totalQualityPoints / totalUnits;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'label': label,
    'courses': courses.map((CourseEntry c) => c.toJson()).toList(),
    'saved_at': savedAt.toIso8601String(),
  };

  factory SemesterRecord.fromJson(Map<String, dynamic> json) => SemesterRecord(
    id: (json['id'] ?? '') as String,
    label: (json['label'] ?? '') as String,
    courses: (json['courses'] as List<dynamic>? ?? <dynamic>[])
        .whereType<Map<dynamic, dynamic>>()
        .map(
          (Map<dynamic, dynamic> e) =>
              CourseEntry.fromJson(Map<String, dynamic>.from(e)),
        )
        .toList(),
    savedAt:
        DateTime.tryParse((json['saved_at'] ?? '') as String) ?? DateTime.now(),
  );
}

/// Choices the student makes once for how their CGPA is built.
@immutable
class GpaSettings {
  const GpaSettings({
    this.replaceRetakenFails = false,
    this.previousCgpa = 0,
    this.previousUnits = 0,
  });

  /// When true, an F is dropped from the CGPA once the same course has been
  /// taken again in a later semester. When false (the usual rule) every
  /// attempt stays in the record, so the F and the resit both count.
  final bool replaceRetakenFails;

  /// A CGPA and total units from results entered before using this app.
  final double previousCgpa;
  final int previousUnits;

  int get previousPoints => (previousCgpa * previousUnits).round();
  bool get hasPrevious => previousUnits > 0 && previousCgpa > 0;

  GpaSettings copyWith({
    bool? replaceRetakenFails,
    double? previousCgpa,
    int? previousUnits,
  }) => GpaSettings(
    replaceRetakenFails: replaceRetakenFails ?? this.replaceRetakenFails,
    previousCgpa: previousCgpa ?? this.previousCgpa,
    previousUnits: previousUnits ?? this.previousUnits,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'replace_retaken_fails': replaceRetakenFails,
    'previous_cgpa': previousCgpa,
    'previous_units': previousUnits,
  };

  factory GpaSettings.fromJson(Map<String, dynamic>? json) => json == null
      ? const GpaSettings()
      : GpaSettings(
          replaceRetakenFails: json['replace_retaken_fails'] == true,
          previousCgpa: (json['previous_cgpa'] as num?)?.toDouble() ?? 0,
          previousUnits: (json['previous_units'] as num?)?.toInt() ?? 0,
        );
}

/// The cumulative position across every semester.
@immutable
class CumulativeResult {
  const CumulativeResult({
    required this.units,
    required this.points,
    required this.unitsPassed,
    required this.carryovers,
  });

  final int units;
  final int points;
  final int unitsPassed;

  /// Course codes with an F that has not been passed since.
  final List<String> carryovers;

  double get cgpa => units == 0 ? 0 : points / units;
}

/// Builds the CGPA from semesters, earlier results and the resit rule.
class GpaEngine {
  const GpaEngine._();

  /// [semesters] must be oldest first. [extra] is an unsaved semester that
  /// is treated as the most recent one.
  static CumulativeResult cumulative(
    List<SemesterRecord> semesters,
    GpaSettings settings, {
    SemesterRecord? extra,
  }) {
    final List<SemesterRecord> all = <SemesterRecord>[
      ...semesters,
      ?extra,
    ];

    // The latest attempt of every course, to spot fails that were cleared.
    final Map<String, int> lastAttemptSemester = <String, int>{};
    final Map<String, Grade?> lastGrade = <String, Grade?>{};
    for (int i = 0; i < all.length; i++) {
      for (final CourseEntry c in all[i].courses) {
        if (!c.isGraded || c.key.isEmpty) continue;
        lastAttemptSemester[c.key] = i;
        lastGrade[c.key] = c.grade;
      }
    }

    int units = settings.hasPrevious ? settings.previousUnits : 0;
    int points = settings.hasPrevious ? settings.previousPoints : 0;
    int passed = units;

    for (int i = 0; i < all.length; i++) {
      for (final CourseEntry c in all[i].courses) {
        if (!c.isGraded) continue;
        final bool retakenLater =
            c.key.isNotEmpty && (lastAttemptSemester[c.key] ?? i) > i;
        if (settings.replaceRetakenFails && c.grade == Grade.f && retakenLater) {
          continue; // this F is replaced by the later attempt
        }
        units += c.creditUnits;
        points += c.qualityPoints;
        if (c.grade != Grade.f) passed += c.creditUnits;
      }
    }

    final List<String> carry = <String>[];
    lastGrade.forEach((String key, Grade? g) {
      if (g == Grade.f) carry.add(key);
    });
    // Show codes the way the student typed them.
    final Map<String, String> pretty = <String, String>{};
    for (final SemesterRecord s in all) {
      for (final CourseEntry c in s.courses) {
        if (c.key.isNotEmpty) pretty[c.key] = c.code.trim().toUpperCase();
      }
    }
    return CumulativeResult(
      units: units,
      points: points,
      unitsPassed: passed,
      carryovers: carry.map((String k) => pretty[k] ?? k).toList()..sort(),
    );
  }

  /// The GPA needed over [nextUnits] more units to end on [target].
  /// Returns null when there are no next units.
  static double? neededGpa({
    required double target,
    required int unitsSoFar,
    required int pointsSoFar,
    required int nextUnits,
  }) {
    if (nextUnits <= 0) return null;
    return (target * (unitsSoFar + nextUnits) - pointsSoFar) / nextUnits;
  }
}

/// Degree classification bands used by Nigerian institutions.
class Classification {
  const Classification._();

  static String of(double gpa) {
    if (gpa >= 4.50) return 'First Class';
    if (gpa >= 3.50) return 'Second Class Upper';
    if (gpa >= 2.40) return 'Second Class Lower';
    if (gpa >= 1.50) return 'Third Class';
    if (gpa >= 1.00) return 'Pass';
    if (gpa > 0) return 'Below pass';
    return 'Not classified';
  }

  static String encouragementFor(double gpa) {
    if (gpa >= 4.50) {
      return 'Outstanding work. Hold this standard and finish strongly.';
    }
    if (gpa >= 3.50) {
      return 'A very good result. A First is within reach with steady effort.';
    }
    if (gpa >= 2.40) {
      return 'Solid ground to build on. Target your weakest units next semester.';
    }
    if (gpa >= 1.50) {
      return 'There is real room to climb. Small consistent gains add up quickly.';
    }
    if (gpa > 0) {
      return 'Take heart. Speak to your adviser early and rebuild one course at a time.';
    }
    return 'Add your courses and grades to see where you stand.';
  }
}
