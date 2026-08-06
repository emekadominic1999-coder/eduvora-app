import 'package:eduvora/core/data/academic_structure.dart';
import 'package:eduvora/core/data/institution_faculties.dart';
import 'package:eduvora/core/data/nigerian_institutions.dart';
import 'package:eduvora/core/models/institution.dart';
import 'package:flutter_test/flutter_test.dart';

const String unn = 'University of Nigeria, Nsukka';

void main() {
  group('UNN structure', () {
    test('is recognised as a mapped institution', () {
      expect(InstitutionFaculties.hasStructureFor(unn), isTrue);
    });

    test('the name matches the directory exactly', () {
      // A mismatch here would silently fall back to the generic taxonomy,
      // which is the failure this whole file exists to prevent.
      expect(NigerianInstitutions.byName(unn), isNotNull);
      for (final String name in InstitutionFaculties.mappedInstitutions) {
        expect(
          NigerianInstitutions.byName(name),
          isNotNull,
          reason: '$name is mapped but not in the institution directory',
        );
      }
    });

    test('has seventeen faculties', () {
      expect(InstitutionFaculties.unnFaculties, hasLength(17));
    });

    test('carries the faculties UNN actually publishes', () {
      final Set<String> names = InstitutionFaculties.unnFaculties
          .map((Faculty f) => f.name)
          .toSet();

      expect(
        names,
        containsAll(<String>[
          'Faculty of Agriculture',
          'Faculty of Arts',
          'Faculty of Basic Medical Sciences',
          'Faculty of Biological Sciences',
          'Faculty of Business Administration',
          'Faculty of Dentistry',
          'Faculty of Education',
          'Faculty of Engineering',
          'Faculty of Environmental Studies',
          'Faculty of Health Sciences and Technology',
          'Faculty of Law',
          'Faculty of Medicine',
          'Faculty of Pharmaceutical Sciences',
          'Faculty of Physical Sciences',
          'Faculty of Social Sciences',
          'Faculty of Veterinary Medicine',
          'Faculty of Vocational Technical Education',
        ]),
      );
    });

    test('splits science the way UNN does, not into one Faculty of Science', () {
      final Set<String> names = InstitutionFaculties.unnFaculties
          .map((Faculty f) => f.name)
          .toSet();

      expect(names, contains('Faculty of Physical Sciences'));
      expect(names, contains('Faculty of Biological Sciences'));
      expect(names, isNot(contains('Faculty of Science')));
    });

    test('every faculty has at least one department', () {
      for (final Faculty f in InstitutionFaculties.unnFaculties) {
        expect(f.departments, isNotEmpty, reason: f.name);
      }
    });

    test('no faculty lists the same department twice', () {
      for (final Faculty f in InstitutionFaculties.unnFaculties) {
        expect(
          f.departments.toSet().length,
          f.departments.length,
          reason: '${f.name} repeats a department',
        );
      }
    });

    test('no department appears under two faculties', () {
      final Map<String, String> seen = <String, String>{};
      for (final Faculty f in InstitutionFaculties.unnFaculties) {
        for (final String d in f.departments) {
          expect(
            seen.containsKey(d),
            isFalse,
            reason: '$d is under both ${seen[d]} and ${f.name}',
          );
          seen[d] = f.name;
        }
      }
    });

    test('departments are listed alphabetically within a faculty', () {
      for (final Faculty f in InstitutionFaculties.unnFaculties) {
        final List<String> sorted = List<String>.from(f.departments)..sort();
        expect(f.departments, sorted, reason: f.name);
      }
    });
  });

  group('Physical Sciences', () {
    Faculty physical() => InstitutionFaculties.unnFaculties.firstWhere(
      (Faculty f) => f.name == 'Faculty of Physical Sciences',
    );

    test('holds the six departments UNN publishes', () {
      expect(physical().departments, <String>[
        'Computer Science',
        'Geology',
        'Mathematics',
        'Physics and Astronomy',
        'Pure and Industrial Chemistry',
        'Statistics',
      ]);
    });

    test('carries every department whose outline has been loaded', () {
      // These five have real course outlines in the database. If a name here
      // ever drifts, a student would pick a department whose outline cannot
      // be found.
      expect(
        physical().departments,
        containsAll(<String>[
          'Geology',
          'Mathematics',
          'Physics and Astronomy',
          'Pure and Industrial Chemistry',
          'Statistics',
        ]),
      );
    });
  });

  group('generic departments UNN does not teach', () {
    test('are no longer offered to a UNN student', () {
      final Set<String> unnDepartments = <String>{
        for (final Faculty f in InstitutionFaculties.unnFaculties)
          ...f.departments,
      };

      // All of these sit in the generic university taxonomy and are wrong
      // for UNN — that is the whole point of mapping the school.
      for (final String absent in <String>[
        'Marine Biology',
        'Physics with Electronics',
        'Applied Geophysics',
        'Quantity Surveying',
        'Industrial Chemistry',
        'Botany / Plant Science',
      ]) {
        expect(
          unnDepartments,
          isNot(contains(absent)),
          reason: 'UNN does not teach $absent',
        );
      }
    });
  });

  group('UNIZIK structure', () {
    const String unizik = 'Nnamdi Azikiwe University, Awka';

    test('is recognised as a mapped institution', () {
      expect(InstitutionFaculties.hasStructureFor(unizik), isTrue);
    });

    test('has seventeen faculties', () {
      expect(InstitutionFaculties.unizikFaculties, hasLength(17));
    });

    test('every faculty has at least one department', () {
      for (final Faculty f in InstitutionFaculties.unizikFaculties) {
        expect(f.departments, isNotEmpty, reason: f.name);
      }
    });

    test('no faculty lists the same department twice', () {
      for (final Faculty f in InstitutionFaculties.unizikFaculties) {
        expect(
          f.departments.toSet().length,
          f.departments.length,
          reason: '${f.name} repeats a department',
        );
      }
    });

    test('departments are listed alphabetically within a faculty', () {
      for (final Faculty f in InstitutionFaculties.unizikFaculties) {
        final List<String> sorted = List<String>.from(f.departments)..sort();
        expect(f.departments, sorted, reason: f.name);
      }
    });

    test('carries the departments UNIZIK publishes for Physical Sciences', () {
      final Faculty physical = InstitutionFaculties.unizikFaculties.firstWhere(
        (Faculty f) => f.name == 'Faculty of Physical Sciences',
      );
      expect(physical.departments, <String>[
        'Computer Science',
        'Industrial Physics',
        'Information Technology',
        'Mathematics',
        'Physics',
        'Statistics',
      ]);
    });

    test('splits its sciences differently from UNN', () {
      // UNIZIK has Bio-Sciences and Physical Sciences; UNN has Biological
      // Sciences and Physical Sciences. Mapping each school separately is
      // the entire point — the names are not interchangeable.
      final Set<String> names = InstitutionFaculties.unizikFaculties
          .map((Faculty f) => f.name)
          .toSet();
      expect(names, contains('Faculty of Bio-Sciences'));
      expect(names, isNot(contains('Faculty of Biological Sciences')));
    });

    test('the misspelling on the source site is corrected', () {
      final Faculty environmental = InstitutionFaculties.unizikFaculties
          .firstWhere(
            (Faculty f) => f.name == 'Faculty of Environmental Sciences',
          );
      // Published as "Meterology"; a student searching the ordinary
      // spelling must still find it.
      expect(environmental.departments, contains('Geography and Meteorology'));
      expect(
        environmental.departments,
        isNot(contains('Geography and Meterology')),
      );
    });

    test('no department keeps a stray "Department of" prefix', () {
      for (final Faculty f in InstitutionFaculties.unizikFaculties) {
        for (final String d in f.departments) {
          expect(
            d.toLowerCase().startsWith('department of'),
            isFalse,
            reason: '$d in ${f.name}',
          );
        }
      }
    });

    test('a UNIZIK student gets UNIZIK faculties', () {
      expect(
        AcademicStructure.facultiesForInstitution(
          unizik,
          InstitutionType.university,
        ),
        InstitutionFaculties.unizikFaculties,
      );
    });

    test('UNIZIK and UNN do not share a structure', () {
      expect(
        InstitutionFaculties.forInstitution(unizik),
        isNot(InstitutionFaculties.forInstitution(unn)),
      );
    });
  });

  group('lookup', () {
    test('a UNN student gets UNN faculties, not the generic list', () {
      final List<Faculty> faculties =
          AcademicStructure.facultiesForInstitution(
            unn,
            InstitutionType.university,
          );
      expect(faculties, InstitutionFaculties.unnFaculties);
    });

    test('an unmapped university still gets the generic list', () {
      final List<Faculty> faculties =
          AcademicStructure.facultiesForInstitution(
            'University of Lagos',
            InstitutionType.university,
          );
      expect(faculties, AcademicStructure.universityFaculties);
      expect(faculties, isNot(InstitutionFaculties.unnFaculties));
    });

    test('an empty institution name falls back rather than failing', () {
      expect(
        AcademicStructure.facultiesForInstitution(
          '',
          InstitutionType.university,
        ),
        AcademicStructure.universityFaculties,
      );
    });

    test('a polytechnic is unaffected by university mappings', () {
      expect(
        AcademicStructure.facultiesForInstitution(
          'Yaba College of Technology',
          InstitutionType.polytechnic,
        ),
        AcademicStructure.polytechnicSchools,
      );
    });

    test('facultyByName resolves a UNN-only faculty', () {
      final Faculty? f = AcademicStructure.facultyByName(
        InstitutionType.university,
        'Faculty of Physical Sciences',
        institutionName: unn,
      );
      expect(f, isNotNull);
      expect(f!.departments, contains('Pure and Industrial Chemistry'));
    });

    test('departmentsFor returns UNN departments for a UNN faculty', () {
      final List<String> departments = AcademicStructure.departmentsFor(
        InstitutionType.university,
        'Faculty of Physical Sciences',
        institutionName: unn,
      );
      expect(departments, contains('Geology'));
      expect(departments, isNot(contains('Marine Biology')));
    });

    test('a faculty saved before the school was mapped is not lost', () {
      // A student who picked "Faculty of Science" under the old generic list
      // must still resolve, rather than having their profile silently blanked.
      final Faculty? f = AcademicStructure.facultyByName(
        InstitutionType.university,
        'Faculty of Science',
        institutionName: unn,
      );
      expect(f, isNotNull);
    });

    test('an unknown faculty name still returns null', () {
      expect(
        AcademicStructure.facultyByName(
          InstitutionType.university,
          'Faculty of Nonsense',
          institutionName: unn,
        ),
        isNull,
      );
    });
  });

  group('allDepartments', () {
    test('includes departments only a mapped school teaches', () {
      expect(
        AcademicStructure.allDepartments,
        contains('Pure and Industrial Chemistry'),
      );
    });

    test('is sorted and free of duplicates', () {
      final List<String> all = AcademicStructure.allDepartments;
      final List<String> sorted = List<String>.from(all)..sort();
      expect(all, sorted);
      expect(all.toSet().length, all.length);
    });
  });
}
