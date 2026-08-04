import 'package:flutter/foundation.dart';

/// The 5-point grading scale used across Nigerian higher institutions,
/// exactly as specified in the Eduvora technical documentation.
enum Grade {
  a('A', 5, 'Excellent'),
  b('B', 4, 'Very Good'),
  c('C', 3, 'Good'),
  d('D', 2, 'Fair'),
  e('E', 1, 'Pass'),
  f('F', 0, 'Fail');

  const Grade(this.letter, this.point, this.category);

  final String letter;
  final int point;
  final String category;

  static Grade fromLetter(String? letter) => Grade.values.firstWhere(
        (Grade g) => g.letter == letter?.toUpperCase(),
        orElse: () => Grade.a,
      );
}

/// One registered course inside a semester.
@immutable
class CourseEntry {
  const CourseEntry({
    required this.id,
    required this.code,
    required this.creditUnits,
    required this.grade,
  });

  final String id;
  final String code;
  final int creditUnits;
  final Grade grade;

  /// Credit units × grade value.
  int get qualityPoints => creditUnits * grade.point;

  CourseEntry copyWith({String? code, int? creditUnits, Grade? grade}) =>
      CourseEntry(
        id: id,
        code: code ?? this.code,
        creditUnits: creditUnits ?? this.creditUnits,
        grade: grade ?? this.grade,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'code': code,
        'credit_units': creditUnits,
        'grade': grade.letter,
      };

  factory CourseEntry.fromJson(Map<String, dynamic> json) => CourseEntry(
        id: (json['id'] ?? '') as String,
        code: (json['code'] ?? '') as String,
        creditUnits: (json['credit_units'] as num?)?.toInt() ?? 0,
        grade: Grade.fromLetter(json['grade'] as String?),
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

  int get totalUnits =>
      courses.fold(0, (int sum, CourseEntry c) => sum + c.creditUnits);

  int get totalQualityPoints =>
      courses.fold(0, (int sum, CourseEntry c) => sum + c.qualityPoints);

  /// GPA = Σ (credit units × grade value) ⁄ Σ credit units
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
            .map((Map<dynamic, dynamic> e) =>
                CourseEntry.fromJson(Map<String, dynamic>.from(e)))
            .toList(),
        savedAt: DateTime.tryParse((json['saved_at'] ?? '') as String) ??
            DateTime.now(),
      );
}

/// Degree classification bands used by Nigerian institutions.
class Classification {
  const Classification._();

  static String of(double gpa) {
    if (gpa >= 4.50) return 'First Class';
    if (gpa >= 3.50) return 'Second Class Upper';
    if (gpa >= 2.40) return 'Second Class Lower';
    if (gpa >= 1.50) return 'Third Class';
    if (gpa > 0) return 'Pass';
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
    return 'Add your courses to see where you stand.';
  }
}
