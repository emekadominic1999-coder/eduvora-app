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

  group('every mapped institution', () {
    // These run against whatever is in the map, so a school added later is
    // held to the same standard without anyone remembering to add a test.
    test('names a real institution from the directory', () {
      for (final String name in InstitutionFaculties.mappedInstitutions) {
        expect(
          NigerianInstitutions.byName(name),
          isNotNull,
          reason: '$name is mapped but not in the directory',
        );
      }
    });

    test('has no empty faculty', () {
      for (final String name in InstitutionFaculties.mappedInstitutions) {
        for (final Faculty f in InstitutionFaculties.forInstitution(name)!) {
          expect(f.departments, isNotEmpty, reason: '$name — ${f.name}');
        }
      }
    });

    test('never repeats a faculty name', () {
      for (final String name in InstitutionFaculties.mappedInstitutions) {
        final List<Faculty> faculties =
            InstitutionFaculties.forInstitution(name)!;
        final Set<String> names = faculties
            .map((Faculty f) => f.name)
            .toSet();
        expect(names.length, faculties.length, reason: name);
      }
    });

    test('never repeats a department inside one faculty', () {
      for (final String name in InstitutionFaculties.mappedInstitutions) {
        for (final Faculty f in InstitutionFaculties.forInstitution(name)!) {
          expect(
            f.departments.toSet().length,
            f.departments.length,
            reason: '$name — ${f.name}',
          );
        }
      }
    });

    test('lists departments alphabetically', () {
      for (final String name in InstitutionFaculties.mappedInstitutions) {
        for (final Faculty f in InstitutionFaculties.forInstitution(name)!) {
          final List<String> sorted = List<String>.from(f.departments)..sort();
          expect(f.departments, sorted, reason: '$name — ${f.name}');
        }
      }
    });

    test('carries no leftover markup or encoding', () {
      // "&#038;" and "&amp;" both reached a department name during scraping.
      for (final String name in InstitutionFaculties.mappedInstitutions) {
        for (final Faculty f in InstitutionFaculties.forInstitution(name)!) {
          for (final String d in <String>[f.name, ...f.departments]) {
            expect(d, isNot(contains('&#')), reason: '$name — $d');
            expect(d, isNot(contains('&amp;')), reason: '$name — $d');
            expect(d, isNot(contains('<')), reason: '$name — $d');
            expect(d.trim(), d, reason: '$name — "$d" has stray whitespace');
          }
        }
      }
    });

    test('drops menu shorthand a student would not search for', () {
      for (final String name in InstitutionFaculties.mappedInstitutions) {
        for (final Faculty f in InstitutionFaculties.forInstitution(name)!) {
          for (final String d in f.departments) {
            expect(
              RegExp(r'\b(Edu|Mgt|Agric)\.?\s').hasMatch(d),
              isFalse,
              reason: '$name — "$d" still uses menu shorthand',
            );
            expect(
              d.toLowerCase().startsWith('department of'),
              isFalse,
              reason: '$name — $d',
            );
          }
        }
      }
    });

    test('is served ahead of the generic taxonomy', () {
      for (final String name in InstitutionFaculties.mappedInstitutions) {
        final Institution institution = NigerianInstitutions.byName(name)!;
        expect(
          AcademicStructure.facultiesForInstitution(name, institution.type),
          InstitutionFaculties.forInstitution(name),
          reason: name,
        );
      }
    });
  });

  group('UNIUYO structure', () {
    const String uniuyo = 'University of Uyo';

    test('is recognised as a mapped institution', () {
      expect(InstitutionFaculties.hasStructureFor(uniuyo), isTrue);
    });

    test('has fourteen faculties', () {
      expect(InstitutionFaculties.uniuyoFaculties, hasLength(14));
    });

    test('has a Faculty of Computing, which UNN and UNIZIK do not', () {
      final Set<String> names = InstitutionFaculties.uniuyoFaculties
          .map((Faculty f) => f.name)
          .toSet();
      expect(names, contains('Faculty of Computing'));
    });

    test('expands the abbreviations its own menu uses', () {
      final Faculty education = InstitutionFaculties.uniuyoFaculties
          .firstWhere((Faculty f) => f.name == 'Faculty of Education');
      expect(
        education.departments,
        contains('Educational Technology and Library Science'),
      );
      expect(
        education.departments,
        isNot(contains('Edu. Tech and Library Science')),
      );
    });

    test('corrects the misspellings on the source site', () {
      final Faculty clinical = InstitutionFaculties.uniuyoFaculties.firstWhere(
        (Faculty f) => f.name == 'Faculty of Clinical Sciences',
      );
      // Published as "Padiatrics".
      expect(clinical.departments, contains('Paediatrics'));
      expect(clinical.departments, isNot(contains('Padiatrics')));
    });
  });

  group('UNILORIN structure', () {
    const String unilorin = 'University of Ilorin';

    test('is recognised as a mapped institution', () {
      expect(InstitutionFaculties.hasStructureFor(unilorin), isTrue);
    });

    test('has sixteen faculties', () {
      expect(InstitutionFaculties.unilorinFaculties, hasLength(16));
    });

    test('includes the health faculties missing from its own index', () {
      // unilorin.edu.ng/faculties lists only thirteen; the three College of
      // Health Sciences faculties sit on separate subdomains. Reading just
      // the index would leave a medical student with no faculty to pick.
      final Set<String> names = InstitutionFaculties.unilorinFaculties
          .map((Faculty f) => f.name)
          .toSet();
      expect(names, contains('Faculty of Basic Medical Sciences'));
      expect(names, contains('Faculty of Basic Clinical Sciences'));
      expect(names, contains('Faculty of Clinical Sciences'));
    });

    test('a medical student can find Medicine', () {
      final List<String> clinical = AcademicStructure.departmentsFor(
        InstitutionType.university,
        'Faculty of Clinical Sciences',
        institutionName: unilorin,
      );
      expect(clinical, contains('Medicine'));
      expect(clinical, contains('Surgery'));
      expect(clinical, contains('Nursing Science'));
    });

    test('corrects the misspelling on the source site', () {
      final Faculty basicClinical = InstitutionFaculties.unilorinFaculties
          .firstWhere(
            (Faculty f) => f.name == 'Faculty of Basic Clinical Sciences',
          );
      // Published as "Heamatology".
      expect(
        basicClinical.departments,
        contains('Haematology & Blood Transfusion'),
      );
    });

    test('keeps Islamic Law, which the other mapped schools do not teach', () {
      final Faculty law = InstitutionFaculties.unilorinFaculties.firstWhere(
        (Faculty f) => f.name == 'Faculty of Law',
      );
      expect(law.departments, contains('Islamic Law'));
    });
  });

  group('UNICAL structure', () {
    const String unical = 'University of Calabar';

    test('is recognised as a mapped institution', () {
      expect(InstitutionFaculties.hasStructureFor(unical), isTrue);
    });

    test('has twenty-three faculties', () {
      expect(InstitutionFaculties.unicalFaculties, hasLength(23));
    });

    test('leaves out what is not a faculty a student belongs to', () {
      // The source lists 28 faculty_details pages; five are the library, a
      // "non-academic" entry and three research institutes.
      final Set<String> names = InstitutionFaculties.unicalFaculties
          .map((Faculty f) => f.name.toLowerCase())
          .toSet();
      for (final String absent in <String>[
        'faculty of library',
        'faculty of non-academic',
        'faculty of institute of education',
      ]) {
        expect(names, isNot(contains(absent)));
      }
    });

    test('has a Faculty of Oceanography, unique among the mapped schools', () {
      final Faculty ocean = InstitutionFaculties.unicalFaculties.firstWhere(
        (Faculty f) => f.name == 'Faculty of Oceanography',
      );
      expect(ocean.departments, contains('Marine Oceanography'));
    });

    test('normalises the shouted names on the source site', () {
      // UNICAL publishes some departments in capitals and others in title
      // case on the same site; a picker mixing both looks broken.
      for (final Faculty f in InstitutionFaculties.unicalFaculties) {
        for (final String d in f.departments) {
          final String letters = d.replaceAll(RegExp('[^A-Za-z]'), '');
          expect(
            letters == letters.toUpperCase() && letters.length > 3,
            isFalse,
            reason: '"$d" in ${f.name} is still shouted',
          );
        }
      }
    });

    test('splits education across five faculties, as UNICAL does', () {
      // Arts and Social Science Education, Educational Foundation Studies,
      // Science Education, Vocational and Entrepreneurial Education, and
      // Vocational and Science Education — the generic taxonomy has one
      // Faculty of Education, which is exactly what mapping fixes.
      final List<String> educationFaculties = InstitutionFaculties
          .unicalFaculties
          .where((Faculty f) => f.name.contains('Education'))
          .map((Faculty f) => f.name)
          .toList();
      expect(educationFaculties, hasLength(5), reason: '$educationFaculties');
    });
  });

  group('BUK structure', () {
    const String buk = 'Bayero University, Kano';

    test('is recognised as a mapped institution', () {
      expect(InstitutionFaculties.hasStructureFor(buk), isTrue);
    });

    test('has eighteen faculties', () {
      expect(InstitutionFaculties.bukFaculties, hasLength(18));
    });

    test(
      'found the two faculties whose menu pointed at a staff list, not a submenu',
      () {
        // Economics & Management Sciences and Social Sciences both link
        // "Departments" straight to a staff-by-department page rather than a
        // dropdown; reading only the dropdown would have left both empty.
        final Faculty ems = InstitutionFaculties.bukFaculties.firstWhere(
          (Faculty f) => f.name == 'Faculty of Economics & Management Sciences',
        );
        final Faculty ss = InstitutionFaculties.bukFaculties.firstWhere(
          (Faculty f) => f.name == 'Faculty of Social Sciences',
        );
        expect(ems.departments, isNotEmpty);
        expect(ss.departments, isNotEmpty);
        expect(ems.departments, contains('Public Administration'));
        expect(ss.departments, contains('Sociology'));
      },
    );

    test('gives engineering departments their full name', () {
      // BUK's own menu prints these as bare adjectives ("Civil",
      // "Mechanical") with "Engineering" implied by the page — wrong once
      // shown on its own.
      final Faculty engineering = InstitutionFaculties.bukFaculties
          .firstWhere((Faculty f) => f.name == 'Faculty of Engineering');
      expect(engineering.departments, contains('Civil Engineering'));
      expect(engineering.departments, isNot(contains('Civil')));
    });

    test('corrects the misspellings on the source site', () {
      final Faculty allied = InstitutionFaculties.bukFaculties.firstWhere(
        (Faculty f) => f.name == 'Faculty of Allied Health Sciences',
      );
      // Published as "Enviromental Health Science".
      expect(allied.departments, contains('Environmental Health Science'));

      final Faculty dentistry = InstitutionFaculties.bukFaculties.firstWhere(
        (Faculty f) => f.name == 'Faculty of Dentistry',
      );
      // Published as "Oral and Maxilofacial".
      expect(
        dentistry.departments,
        contains('Oral and Maxillofacial Surgery'),
      );
    });

    test('keeps Islamic Law, alongside UNILORIN and no one else mapped', () {
      final Faculty law = InstitutionFaculties.bukFaculties.firstWhere(
        (Faculty f) => f.name == 'Faculty of Law',
      );
      expect(law.departments, contains('Islamic Law'));
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
