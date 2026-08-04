import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../models/course_outline.dart';
import '../models/student_profile.dart';
import 'local_store.dart';
import 'supabase_service.dart';

/// Reads and writes course outlines.
///
/// Lookups are scoped to the student's own institution by default. Outlines
/// from other schools are available separately and always labelled, never
/// silently mixed in — a UNN syllabus shown to a FUTO student as though it
/// were their own would be worse than showing nothing.
class CourseRepository {
  const CourseRepository();

  static const Uuid _uuid = Uuid();

  /// Courses for this student's own institution, department and level.
  Future<List<CourseOutline>> forStudent(StudentProfile profile) async {
    final List<CourseOutline> all = await _fetch(
      department: profile.department,
      level: profile.level,
    );
    return all
        .where((CourseOutline c) => c.institution == profile.institutionName)
        .toList();
  }

  /// The same department and level at *other* institutions, offered as
  /// clearly-labelled reference material.
  Future<List<CourseOutline>> fromOtherInstitutions(
    StudentProfile profile,
  ) async {
    final List<CourseOutline> all = await _fetch(
      department: profile.department,
      level: profile.level,
    );
    return all
        .where((CourseOutline c) => c.institution != profile.institutionName)
        .toList();
  }

  /// Groups a flat course list into its two semesters.
  List<SemesterOutline> bySemester(List<CourseOutline> courses) {
    return Semester.values.map((Semester s) {
      final List<CourseOutline> inSemester =
          courses.where((CourseOutline c) => c.semester == s).toList()..sort(
            (CourseOutline a, CourseOutline b) =>
                a.courseCode.compareTo(b.courseCode),
          );
      return SemesterOutline(semester: s, courses: inSemester);
    }).toList();
  }

  Future<List<CourseOutline>> _fetch({
    required String department,
    required String level,
  }) async {
    final List<CourseOutline> local = LocalStore.instance
        .readList(StoreKeys.courseOutlines)
        .map(CourseOutline.fromJson)
        .where(
          (CourseOutline c) => c.department == department && c.level == level,
        )
        .toList();

    List<CourseOutline> remote = <CourseOutline>[];
    if (SupabaseService.isReady) {
      try {
        final List<dynamic> rows = await SupabaseService.client
            .from('course_outlines')
            .select()
            .eq('department', department)
            .eq('level', level)
            .order('course_code');
        remote = rows
            .whereType<Map<String, dynamic>>()
            .map(CourseOutline.fromJson)
            .toList();
      } catch (error) {
        debugPrint('[Eduvora] course outline fetch failed: $error');
      }
    }

    // Locally added entries win, so a contribution shows up immediately even
    // before it has synced.
    final Map<String, CourseOutline> byId = <String, CourseOutline>{};
    for (final CourseOutline c in <CourseOutline>[...remote, ...local]) {
      byId[c.id] = c;
    }
    return byId.values.toList();
  }

  Future<CourseOutline> addCourse({
    required StudentProfile profile,
    required String courseCode,
    required String courseTitle,
    required Semester semester,
    required int creditUnits,
    String description = '',
    List<String> topics = const <String>[],
    String lecturer = '',
    bool isElective = false,
  }) async {
    final CourseOutline course = CourseOutline(
      id: _uuid.v4(),
      courseCode: courseCode.trim().toUpperCase(),
      courseTitle: courseTitle.trim(),
      institution: profile.institutionName,
      faculty: profile.faculty,
      department: profile.department,
      level: profile.level,
      semester: semester,
      creditUnits: creditUnits,
      description: description.trim(),
      topics: topics
          .map((String t) => t.trim())
          .where((String t) => t.isNotEmpty)
          .toList(),
      lecturer: lecturer.trim(),
      isElective: isElective,
      contributedBy: profile.id,
      contributorName: profile.fullName,
      createdAt: DateTime.now(),
    );

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('course_outlines')
            .insert(course.toJson());
      } catch (error) {
        debugPrint('[Eduvora] course outline insert failed: $error');
      }
    }

    final List<Map<String, dynamic>> cached = LocalStore.instance.readList(
      StoreKeys.courseOutlines,
    )..insert(0, course.toJson());
    await LocalStore.instance.writeList(StoreKeys.courseOutlines, cached);

    return course;
  }
}
