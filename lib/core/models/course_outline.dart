import 'package:flutter/foundation.dart';

/// Which half of the session a course runs in.
enum Semester {
  first('First semester'),
  second('Second semester');

  const Semester(this.label);

  final String label;

  static Semester fromName(String? name) => Semester.values.firstWhere(
    (Semester s) => s.name == name || s.label == name,
    orElse: () => Semester.first,
  );
}

/// One registered course, with the syllabus it covers.
///
/// Deliberately keyed to a specific institution as well as a department and
/// level: the same nominal subject genuinely differs between schools. UNILAG's
/// CSC 101 is not UNN's CSC 101 — different code conventions, different credit
/// loading, different topics — so an outline is only trustworthy when it is
/// attributed to the school it actually came from.
@immutable
class CourseOutline {
  const CourseOutline({
    required this.id,
    required this.courseCode,
    required this.courseTitle,
    required this.institution,
    required this.department,
    required this.level,
    this.faculty = '',
    this.semester = Semester.first,
    this.creditUnits = 0,
    this.description = '',
    this.topics = const <String>[],
    this.lecturer = '',
    this.isElective = false,
    this.contributedBy = '',
    this.contributorName = '',
    this.createdAt,
  });

  final String id;
  final String courseCode;
  final String courseTitle;
  final String institution;
  final String faculty;
  final String department;
  final String level;
  final Semester semester;
  final int creditUnits;
  final String description;

  /// The syllabus proper — the topics the course covers, in teaching order.
  final List<String> topics;
  final String lecturer;
  final bool isElective;
  final String contributedBy;
  final String contributorName;
  final DateTime? createdAt;

  bool get hasOutline => topics.isNotEmpty;

  String get unitsLabel => creditUnits == 1 ? '1 unit' : '$creditUnits units';

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'course_code': courseCode,
    'course_title': courseTitle,
    'institution': institution,
    'faculty': faculty,
    'department': department,
    'level': level,
    'semester': semester.name,
    'credit_units': creditUnits,
    'description': description,
    'topics': topics,
    'lecturer': lecturer,
    'is_elective': isElective,
    'contributed_by': contributedBy,
    'contributor_name': contributorName,
    'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
  };

  factory CourseOutline.fromJson(Map<String, dynamic> json) => CourseOutline(
    id: (json['id'] ?? '') as String,
    courseCode: (json['course_code'] ?? '') as String,
    courseTitle: (json['course_title'] ?? '') as String,
    institution: (json['institution'] ?? '') as String,
    faculty: (json['faculty'] ?? '') as String,
    department: (json['department'] ?? '') as String,
    level: (json['level'] ?? '') as String,
    semester: Semester.fromName(json['semester'] as String?),
    creditUnits: (json['credit_units'] as num?)?.toInt() ?? 0,
    description: (json['description'] ?? '') as String,
    topics: (json['topics'] as List<dynamic>? ?? <dynamic>[])
        .map((dynamic e) => e.toString())
        .where((String e) => e.trim().isNotEmpty)
        .toList(),
    lecturer: (json['lecturer'] ?? '') as String,
    isElective: (json['is_elective'] ?? false) as bool,
    contributedBy: (json['contributed_by'] ?? '') as String,
    contributorName: (json['contributor_name'] ?? '') as String,
    createdAt: DateTime.tryParse((json['created_at'] ?? '') as String),
  );
}

/// A semester's worth of courses, with the total credit load.
@immutable
class SemesterOutline {
  const SemesterOutline({required this.semester, required this.courses});

  final Semester semester;
  final List<CourseOutline> courses;

  int get totalUnits =>
      courses.fold(0, (int sum, CourseOutline c) => sum + c.creditUnits);

  int get compulsoryCount =>
      courses.where((CourseOutline c) => !c.isElective).length;
}
