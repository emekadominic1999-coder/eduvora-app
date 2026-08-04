import 'package:eduvora/core/models/course_outline.dart';
import 'package:eduvora/core/models/student_profile.dart';
import 'package:eduvora/core/services/course_repository.dart';
import 'package:eduvora/core/services/local_store.dart';
import 'package:eduvora/core/state/session_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

StudentProfile _student({
  String institution = 'University of Lagos',
  String department = 'Computer Science',
  String level = '100 Level',
}) => StudentProfile(
  id: 'student-1',
  fullName: 'Chinaza Okeke',
  email: 'chinaza@unilag.edu.ng',
  institutionName: institution,
  department: department,
  faculty: 'Faculty of Computing & Information Technology',
  level: level,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const CourseRepository repo = CourseRepository();

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await LocalStore.init();
    await sessionController.signOut();
  });

  group('Institution scoping', () {
    test('a student only sees their own institution’s courses', () async {
      final StudentProfile unilag = _student();
      final StudentProfile unn = _student(
        institution: 'University of Nigeria, Nsukka',
      );

      await repo.addCourse(
        profile: unilag,
        courseCode: 'CSC 101',
        courseTitle: 'Introduction to Computer Science',
        semester: Semester.first,
        creditUnits: 3,
      );
      await repo.addCourse(
        profile: unn,
        courseCode: 'COS 101',
        courseTitle: 'Problem Solving',
        semester: Semester.first,
        creditUnits: 2,
      );

      final List<CourseOutline> mine = await repo.forStudent(unilag);

      expect(mine.length, 1);
      expect(mine.single.courseCode, 'CSC 101');
      expect(
        mine.single.institution,
        'University of Lagos',
        reason: 'another school’s outline must never leak into this list',
      );
    });

    test('other institutions are available separately, never mixed in', () async {
      final StudentProfile unilag = _student();
      final StudentProfile unn = _student(
        institution: 'University of Nigeria, Nsukka',
      );

      await repo.addCourse(
        profile: unilag,
        courseCode: 'CSC 101',
        courseTitle: 'Intro',
        semester: Semester.first,
        creditUnits: 3,
      );
      await repo.addCourse(
        profile: unn,
        courseCode: 'COS 101',
        courseTitle: 'Problem Solving',
        semester: Semester.first,
        creditUnits: 2,
      );

      final List<CourseOutline> others = await repo.fromOtherInstitutions(
        unilag,
      );

      expect(others.length, 1);
      expect(others.single.institution, 'University of Nigeria, Nsukka');
    });

    test('a different level is not shown', () async {
      final StudentProfile hundredLevel = _student();
      final StudentProfile twoHundred = _student(level: '200 Level');

      await repo.addCourse(
        profile: twoHundred,
        courseCode: 'CSC 201',
        courseTitle: 'Data Structures',
        semester: Semester.first,
        creditUnits: 3,
      );

      expect(await repo.forStudent(hundredLevel), isEmpty);
      expect((await repo.forStudent(twoHundred)).length, 1);
    });
  });

  group('Semester grouping', () {
    test('splits courses and totals the credit load', () async {
      final StudentProfile student = _student();

      await repo.addCourse(
        profile: student,
        courseCode: 'CSC 101',
        courseTitle: 'Intro',
        semester: Semester.first,
        creditUnits: 3,
      );
      await repo.addCourse(
        profile: student,
        courseCode: 'MTH 101',
        courseTitle: 'Elementary Mathematics I',
        semester: Semester.first,
        creditUnits: 4,
      );
      await repo.addCourse(
        profile: student,
        courseCode: 'CSC 102',
        courseTitle: 'Intro II',
        semester: Semester.second,
        creditUnits: 3,
      );

      final List<SemesterOutline> semesters = repo.bySemester(
        await repo.forStudent(student),
      );

      final SemesterOutline first = semesters.firstWhere(
        (SemesterOutline s) => s.semester == Semester.first,
      );
      final SemesterOutline second = semesters.firstWhere(
        (SemesterOutline s) => s.semester == Semester.second,
      );

      expect(first.courses.length, 2);
      expect(first.totalUnits, 7);
      expect(second.courses.length, 1);
      expect(second.totalUnits, 3);
      expect(
        first.courses.map((CourseOutline c) => c.courseCode).toList(),
        <String>['CSC 101', 'MTH 101'],
        reason: 'courses should be listed by code',
      );
    });
  });

  group('Course entry', () {
    test('normalises the code and drops blank topic lines', () async {
      final StudentProfile student = _student();

      final CourseOutline course = await repo.addCourse(
        profile: student,
        courseCode: '  mth 101 ',
        courseTitle: '  Elementary Mathematics I  ',
        semester: Semester.first,
        creditUnits: 4,
        topics: <String>['Set theory', '', '   ', 'Sequences and series'],
      );

      expect(course.courseCode, 'MTH 101');
      expect(course.courseTitle, 'Elementary Mathematics I');
      expect(course.topics, <String>['Set theory', 'Sequences and series']);
      expect(course.hasOutline, isTrue);
      expect(course.contributorName, 'Chinaza Okeke');
    });

    test('a course with no topics is still valid, just without an outline', () async {
      final CourseOutline course = await repo.addCourse(
        profile: _student(),
        courseCode: 'GST 101',
        courseTitle: 'Use of English',
        semester: Semester.first,
        creditUnits: 2,
      );

      expect(course.hasOutline, isFalse);
      expect(course.unitsLabel, '2 units');
    });

    test('survives a JSON round trip', () async {
      final CourseOutline original = await repo.addCourse(
        profile: _student(),
        courseCode: 'PHY 101',
        courseTitle: 'General Physics I',
        semester: Semester.second,
        creditUnits: 3,
        topics: <String>['Kinematics', 'Newton’s laws'],
        isElective: true,
      );

      final CourseOutline restored = CourseOutline.fromJson(original.toJson());

      expect(restored.courseCode, 'PHY 101');
      expect(restored.semester, Semester.second);
      expect(restored.topics.length, 2);
      expect(restored.isElective, isTrue);
      expect(restored.institution, original.institution);
    });
  });
}
