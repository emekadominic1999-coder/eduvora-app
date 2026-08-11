import 'package:eduvora/core/data/academic_structure.dart';
import 'package:eduvora/core/data/nigerian_institutions.dart';
import 'package:eduvora/core/models/cbt.dart';
import 'package:eduvora/core/models/gpa.dart';
import 'package:eduvora/core/models/institution.dart';
import 'package:eduvora/core/models/student_profile.dart';
import 'package:eduvora/core/services/eduvora_ai.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GPA computation', () {
    test('applies the documented 5-point formula', () {
      // 3 units at A (5) + 2 units at C (3) = 15 + 6 = 21 quality points
      // over 5 credit units => 4.20.
      final SemesterRecord record = SemesterRecord(
        id: 's1',
        label: 'First semester',
        savedAt: DateTime(2026),
        courses: <CourseEntry>[
          const CourseEntry(
            id: 'c1',
            code: 'MEE 301',
            creditUnits: 3,
            grade: Grade.a,
          ),
          const CourseEntry(
            id: 'c2',
            code: 'MEE 303',
            creditUnits: 2,
            grade: Grade.c,
          ),
        ],
      );

      expect(record.totalUnits, 5);
      expect(record.totalQualityPoints, 21);
      expect(record.gpa, closeTo(4.20, 0.0001));
    });

    test('a failed course contributes units but no points', () {
      final SemesterRecord record = SemesterRecord(
        id: 's2',
        label: 'Second semester',
        savedAt: DateTime(2026),
        courses: <CourseEntry>[
          const CourseEntry(
            id: 'c1',
            code: 'GST 101',
            creditUnits: 2,
            grade: Grade.a,
          ),
          const CourseEntry(
            id: 'c2',
            code: 'CHM 101',
            creditUnits: 3,
            grade: Grade.f,
          ),
        ],
      );

      expect(record.totalUnits, 5);
      expect(record.totalQualityPoints, 10);
      expect(record.gpa, closeTo(2.0, 0.0001));
    });

    test('an empty semester does not divide by zero', () {
      final SemesterRecord record = SemesterRecord(
        id: 's3',
        label: 'Empty',
        savedAt: DateTime(2026),
        courses: const <CourseEntry>[],
      );
      expect(record.gpa, 0);
    });

    test('classification bands match Nigerian practice', () {
      expect(Classification.of(4.60), 'First Class');
      expect(Classification.of(4.50), 'First Class');
      expect(Classification.of(3.50), 'Second Class Upper');
      expect(Classification.of(2.40), 'Second Class Lower');
      expect(Classification.of(1.50), 'Third Class');
      expect(Classification.of(1.20), 'Pass');
      expect(Classification.of(0), 'Not classified');
    });

    test('grade points follow the documentation table', () {
      expect(Grade.a.point, 5);
      expect(Grade.b.point, 4);
      expect(Grade.c.point, 3);
      expect(Grade.d.point, 2);
      expect(Grade.e.point, 1);
      expect(Grade.f.point, 0);
    });

    test('a semester record survives a JSON round trip', () {
      final SemesterRecord original = SemesterRecord(
        id: 's4',
        label: 'Harmattan',
        savedAt: DateTime(2026, 3, 14),
        courses: <CourseEntry>[
          const CourseEntry(
            id: 'c1',
            code: 'PHY 101',
            creditUnits: 4,
            grade: Grade.b,
          ),
        ],
      );
      final SemesterRecord restored =
          SemesterRecord.fromJson(original.toJson());

      expect(restored.label, original.label);
      expect(restored.courses.single.code, 'PHY 101');
      expect(restored.gpa, original.gpa);
    });
  });

  group('CBT bank', () {
    test('a general-studies subject is relevant to every faculty', () {
      const CbtSubject general = CbtSubject(
        id: 'gst-use-of-english',
        name: 'Use of English',
        description: 'General studies',
        questions: <CbtQuestion>[],
        isGeneralStudies: true,
      );
      expect(general.isRelevantTo('Faculty of Law'), isTrue);
      expect(general.isRelevantTo('Faculty of Physical Sciences'), isTrue);
    });

    test('a faculty-scoped subject is not relevant to other faculties', () {
      const CbtSubject scoped = CbtSubject(
        id: 'mth-121-calculus',
        name: 'MTH 121',
        description: 'Past questions for Mathematics',
        questions: <CbtQuestion>[],
        faculties: <String>['Faculty of Physical Sciences'],
      );
      expect(scoped.isRelevantTo('Faculty of Physical Sciences'), isTrue);
      expect(scoped.isRelevantTo('Faculty of Social Sciences'), isFalse);
    });

    test('attempt scoring produces the expected grade band', () {
      final CbtAttempt attempt = CbtAttempt(
        subjectId: 'x',
        subjectName: 'X',
        totalQuestions: 10,
        answers: const <String, int>{},
        score: 7,
        durationSeconds: 300,
        takenAt: DateTime(2026),
      );

      expect(attempt.percentage, 70);
      expect(attempt.grade, 'A');
      expect(attempt.verdict, 'Excellent');
    });

    test('a zero-question attempt does not divide by zero', () {
      final CbtAttempt attempt = CbtAttempt(
        subjectId: 'x',
        subjectName: 'X',
        totalQuestions: 0,
        answers: const <String, int>{},
        score: 0,
        durationSeconds: 0,
        takenAt: DateTime(2026),
      );
      expect(attempt.percentage, 0);
      expect(attempt.grade, 'F');
    });
  });

  group('Institution directory', () {
    test('covers all three institution types', () {
      for (final InstitutionType type in InstitutionType.values) {
        expect(
          NigerianInstitutions.countOf(type),
          greaterThan(5),
          reason: '${type.plural} are under-represented',
        );
      }
    });

    test('search matches by name, abbreviation and state', () {
      expect(
        NigerianInstitutions.search('unilag')
            .any((Institution i) => i.abbreviation == 'UNILAG'),
        isTrue,
      );
      expect(
        NigerianInstitutions.search('yabatech')
            .any((Institution i) => i.type == InstitutionType.polytechnic),
        isTrue,
      );
      expect(
        NigerianInstitutions.search('', state: 'Kano')
            .every((Institution i) => i.state == 'Kano'),
        isTrue,
      );
    });

    test('type filter is respected', () {
      final List<Institution> polys = NigerianInstitutions.search(
        '',
        type: InstitutionType.polytechnic,
      );
      expect(polys, isNotEmpty);
      expect(
        polys.every((Institution i) => i.type == InstitutionType.polytechnic),
        isTrue,
      );
    });

    test('institution names are unique', () {
      final Set<String> seen = <String>{};
      for (final Institution i in NigerianInstitutions.all) {
        expect(seen.add(i.name), isTrue, reason: 'duplicate: ${i.name}');
      }
    });

    test('every institution sits in a recognised state', () {
      for (final Institution i in NigerianInstitutions.all) {
        expect(
          NigerianInstitutions.states,
          contains(i.state),
          reason: '${i.name} has an unknown state "${i.state}"',
        );
      }
    });
  });

  group('Academic structure', () {
    test('each institution type has faculties with departments', () {
      for (final InstitutionType type in InstitutionType.values) {
        final List<Faculty> faculties = AcademicStructure.facultiesFor(type);
        expect(faculties, isNotEmpty, reason: type.label);
        for (final Faculty f in faculties) {
          expect(f.departments, isNotEmpty, reason: f.name);
        }
      }
    });

    test('levels differ appropriately by institution type', () {
      expect(
        AcademicStructure.levelsFor(InstitutionType.university),
        contains('300 Level'),
      );
      expect(
        AcademicStructure.levelsFor(InstitutionType.polytechnic),
        contains('HND 1'),
      );
      expect(
        AcademicStructure.levelsFor(InstitutionType.collegeOfEducation),
        contains('NCE 2'),
      );
    });

    test('a department resolves back to its faculty', () {
      final Faculty? f = AcademicStructure.facultyOfDepartment(
        InstitutionType.university,
        'Mechanical Engineering',
      );
      expect(f?.name, 'Faculty of Engineering & Technology');
    });
  });

  group('Student profile', () {
    test('is incomplete until every academic field is chosen', () {
      StudentProfile p = StudentProfile.empty('id', 'a@b.ng', 'Ada Obi');
      expect(p.isComplete, isFalse);

      p = p
          .withInstitution(NigerianInstitutions.byName('University of Lagos')!)
          .copyWith(
            faculty: 'Faculty of Science',
            department: 'Microbiology',
            level: '200 Level',
          );

      expect(p.isComplete, isTrue);
      expect(p.institutionAbbreviation, 'UNILAG');
      expect(p.academicSummary, contains('Microbiology'));
    });

    test('initials handle one-word, multi-word and empty names', () {
      expect(StudentProfile.empty('1', 'a@b.ng', 'Ada').initials, 'A');
      expect(
        StudentProfile.empty('2', 'a@b.ng', 'Ada Nkechi Obi').initials,
        'AO',
      );
      expect(StudentProfile.empty('3', 'a@b.ng', '').initials, 'E');
    });

    test('survives a JSON round trip', () {
      final StudentProfile original = StudentProfile.empty(
        'id-1',
        'chinaza@unilag.edu.ng',
        'Chinaza Okeke',
      ).copyWith(
        faculty: 'Faculty of Law',
        department: 'Law (LL.B)',
        level: '400 Level',
        matricNumber: 'LAW/2021/044',
      );
      final StudentProfile restored =
          StudentProfile.fromJson(original.toJson());

      expect(restored.fullName, original.fullName);
      expect(restored.department, original.department);
      expect(restored.matricNumber, original.matricNumber);
    });
  });

  group('Ada, the Eduvora assistant', () {
    final StudentProfile profile = StudentProfile.empty(
      'id',
      'ada@unilag.edu.ng',
      'Chinaza Okeke',
    ).copyWith(
      faculty: 'Faculty of Engineering & Technology',
      department: 'Mechanical Engineering',
      level: '300 Level',
    );

    test('points navigation questions at the right screen', () {
      expect(
        EduvoraAi.respond('where are the academic videos?', profile).route,
        '/videos',
      );
      expect(
        EduvoraAi.respond('how does the gp calculator work', profile).route,
        '/gpa',
      );
      expect(
        EduvoraAi.respond('I want to practise a CBT exam', profile).route,
        '/cbt',
      );
      expect(
        EduvoraAi.respond('show me scholarship news', profile).route,
        '/news',
      );
      expect(
        EduvoraAi.respond('how do I change my department', profile).route,
        '/profile',
      );
    });

    test('responds with compassion when a student is struggling', () {
      final AiReply reply =
          EduvoraAi.respond('I am so overwhelmed and tired', profile);
      expect(reply.message.toLowerCase(), contains('thank you for telling me'));
      expect(reply.suggestions, isNotEmpty);
    });

    test('handles a carry-over kindly and offers a concrete next step', () {
      final AiReply reply =
          EduvoraAi.respond('I have a carry over in thermodynamics', profile);
      expect(reply.route, '/gpa');
      expect(reply.message, contains('yet'));
    });

    test('personalises replies with the student first name', () {
      final AiReply reply = EduvoraAi.respond('hello', profile);
      expect(reply.message, contains('Chinaza'));
    });

    test('falls back gracefully on an unknown question', () {
      final AiReply reply = EduvoraAi.respond('qwertyuiop zxcvbnm', profile);
      expect(reply.suggestions, isNotEmpty);
      expect(reply.message, isNotEmpty);
    });

    test('copes with an empty message and a null profile', () {
      expect(EduvoraAi.respond('', null).message, isNotEmpty);
      expect(EduvoraAi.respond('hello', null).message, contains('friend'));
    });
  });
}
