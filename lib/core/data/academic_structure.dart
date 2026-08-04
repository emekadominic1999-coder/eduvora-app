import 'package:flutter/material.dart';

import '../models/institution.dart';
import '../theme/app_theme.dart';

/// A faculty (university), school (polytechnic) or school of study (college of
/// education) together with the departments that sit inside it.
@immutable
class Faculty {
  const Faculty({
    required this.name,
    required this.departments,
    required this.icon,
    required this.colour,
  });

  final String name;
  final List<String> departments;
  final IconData icon;
  final Color colour;
}

/// The academic taxonomy Eduvora filters every feed against.
///
/// Coverage is deliberately broad — a Quantity Surveying student at FUTA and a
/// Primary Education Studies student at FCE Zuba should both find themselves
/// here without having to type a free-text department.
class AcademicStructure {
  const AcademicStructure._();

  // ------------------------------------------------------------------ levels

  static const List<String> universityLevels = <String>[
    'Foundation / JUPEB',
    '100 Level',
    '200 Level',
    '300 Level',
    '400 Level',
    '500 Level',
    '600 Level',
    'Postgraduate',
  ];

  static const List<String> polytechnicLevels = <String>[
    'Pre-ND',
    'ND 1',
    'ND 2',
    'Industrial Training (SIWES)',
    'HND 1',
    'HND 2',
    'Postgraduate Diploma',
  ];

  static const List<String> collegeLevels = <String>[
    'Pre-NCE',
    'NCE 1',
    'NCE 2',
    'NCE 3',
    'Degree Programme',
  ];

  static List<String> levelsFor(InstitutionType type) {
    switch (type) {
      case InstitutionType.university:
        return universityLevels;
      case InstitutionType.polytechnic:
        return polytechnicLevels;
      case InstitutionType.collegeOfEducation:
        return collegeLevels;
    }
  }

  /// What the grouping is called for a given institution type.
  static String facultyLabelFor(InstitutionType type) {
    switch (type) {
      case InstitutionType.university:
        return 'Faculty';
      case InstitutionType.polytechnic:
        return 'School';
      case InstitutionType.collegeOfEducation:
        return 'School';
    }
  }

  // -------------------------------------------------------------- faculties

  static List<Faculty> facultiesFor(InstitutionType type) {
    switch (type) {
      case InstitutionType.university:
        return universityFaculties;
      case InstitutionType.polytechnic:
        return polytechnicSchools;
      case InstitutionType.collegeOfEducation:
        return collegeSchools;
    }
  }

  static const List<Faculty> universityFaculties = <Faculty>[
    Faculty(
      name: 'Faculty of Engineering & Technology',
      icon: Icons.engineering_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Aeronautical & Astronautical Engineering',
        'Agricultural & Bioresources Engineering',
        'Automobile Engineering',
        'Biomedical Engineering',
        'Chemical Engineering',
        'Civil Engineering',
        'Computer Engineering',
        'Electrical & Electronics Engineering',
        'Food Engineering',
        'Industrial & Production Engineering',
        'Marine Engineering',
        'Materials & Metallurgical Engineering',
        'Mechanical Engineering',
        'Mechatronics Engineering',
        'Mining Engineering',
        'Petroleum & Gas Engineering',
        'Polymer & Textile Engineering',
        'Structural Engineering',
        'Systems Engineering',
        'Telecommunications Engineering',
        'Water Resources & Environmental Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Science',
      icon: Icons.science_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Applied Geophysics',
        'Biochemistry',
        'Biotechnology',
        'Botany / Plant Science',
        'Chemistry',
        'Environmental Biology',
        'Geology',
        'Industrial Chemistry',
        'Marine Biology',
        'Mathematics',
        'Microbiology',
        'Physics',
        'Physics with Electronics',
        'Science Laboratory Technology',
        'Statistics',
        'Zoology',
      ],
    ),
    Faculty(
      name: 'Faculty of Computing & Information Technology',
      icon: Icons.memory_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Artificial Intelligence',
        'Computer Science',
        'Cyber Security',
        'Data Science',
        'Information & Communication Technology',
        'Information Systems',
        'Information Technology',
        'Software Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Anatomy',
        'Chemical Pathology',
        'Haematology',
        'Medical Biochemistry',
        'Medical Microbiology',
        'Pharmacology & Therapeutics',
        'Physiology',
      ],
    ),
    Faculty(
      name: 'Faculty of Clinical Sciences',
      icon: Icons.local_hospital_rounded,
      colour: Color(0xFFE11D48),
      departments: <String>[
        'Community Medicine',
        'Dentistry',
        'Medicine & Surgery (MBBS)',
        'Obstetrics & Gynaecology',
        'Ophthalmology',
        'Paediatrics',
        'Psychiatry',
        'Radiology',
        'Surgery',
      ],
    ),
    Faculty(
      name: 'Faculty of Allied Health Sciences',
      icon: Icons.healing_rounded,
      colour: Color(0xFF0D9488),
      departments: <String>[
        'Audiology & Speech Therapy',
        'Environmental Health Science',
        'Health Information Management',
        'Human Nutrition & Dietetics',
        'Medical Laboratory Science',
        'Nursing Science',
        'Optometry',
        'Physiotherapy',
        'Public Health',
        'Radiography & Radiation Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Pharmaceutical Sciences',
      icon: Icons.medication_rounded,
      colour: Color(0xFF059669),
      departments: <String>[
        'Clinical Pharmacy & Pharmacy Practice',
        'Pharmaceutical Chemistry',
        'Pharmaceutical Microbiology',
        'Pharmaceutics & Pharmaceutical Technology',
        'Pharmacognosy',
        'Pharmacology & Toxicology',
      ],
    ),
    Faculty(
      name: 'Faculty of Agriculture',
      icon: Icons.agriculture_rounded,
      colour: Color(0xFF65A30D),
      departments: <String>[
        'Agricultural Economics',
        'Agricultural Extension & Rural Development',
        'Agronomy',
        'Animal Science',
        'Crop Science',
        'Fisheries & Aquaculture',
        'Food Science & Technology',
        'Forestry & Wildlife Management',
        'Home Science & Management',
        'Soil Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Veterinary Medicine',
      icon: Icons.pets_rounded,
      colour: Color(0xFF854D0E),
      departments: <String>[
        'Animal Health & Production',
        'Veterinary Anatomy',
        'Veterinary Medicine',
        'Veterinary Pathology',
        'Veterinary Physiology & Biochemistry',
        'Veterinary Public Health',
      ],
    ),
    Faculty(
      name: 'Faculty of Environmental Sciences',
      icon: Icons.architecture_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Architecture',
        'Building Technology',
        'Environmental Management',
        'Estate Management',
        'Fine & Applied Arts',
        'Industrial Design',
        'Quantity Surveying',
        'Surveying & Geoinformatics',
        'Urban & Regional Planning',
      ],
    ),
    Faculty(
      name: 'Faculty of Management Sciences',
      icon: Icons.insights_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Accounting',
        'Actuarial Science',
        'Banking & Finance',
        'Business Administration',
        'Cooperative Economics & Management',
        'Entrepreneurship',
        'Hospitality & Tourism Management',
        'Human Resource Management',
        'Insurance',
        'Marketing',
        'Office & Information Management',
        'Procurement & Supply Chain Management',
        'Taxation',
        'Transport Management',
      ],
    ),
    Faculty(
      name: 'Faculty of Social Sciences',
      icon: Icons.groups_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Anthropology',
        'Criminology & Security Studies',
        'Demography & Social Statistics',
        'Economics',
        'Geography',
        'International Relations',
        'Peace & Conflict Studies',
        'Political Science',
        'Psychology',
        'Public Administration',
        'Social Work',
        'Sociology',
      ],
    ),
    Faculty(
      name: 'Faculty of Communication & Media Studies',
      icon: Icons.podcasts_rounded,
      colour: Color(0xFFEA580C),
      departments: <String>[
        'Broadcasting',
        'Film & Multimedia Studies',
        'Journalism & Media Studies',
        'Mass Communication',
        'Public Relations & Advertising',
      ],
    ),
    Faculty(
      name: 'Faculty of Arts & Humanities',
      icon: Icons.auto_stories_rounded,
      colour: Color(0xFF9333EA),
      departments: <String>[
        'Arabic Studies',
        'Archaeology & Tourism',
        'Christian Religious Studies',
        'English & Literary Studies',
        'French',
        'Hausa Language & Culture',
        'History & International Studies',
        'Igbo Language & Culture',
        'Islamic Studies',
        'Linguistics',
        'Music',
        'Philosophy',
        'Theatre & Film Studies',
        'Yoruba Language & Culture',
      ],
    ),
    Faculty(
      name: 'Faculty of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF1E3A8A),
      departments: <String>[
        'Commercial & Industrial Law',
        'International Law & Jurisprudence',
        'Islamic Law (Sharia)',
        'Law (LL.B)',
        'Private & Property Law',
        'Public Law',
      ],
    ),
    Faculty(
      name: 'Faculty of Education',
      icon: Icons.school_rounded,
      colour: Color(0xFF0284C7),
      departments: <String>[
        'Adult & Non-Formal Education',
        'Arts Education',
        'Business Education',
        'Early Childhood Education',
        'Educational Foundations',
        'Educational Management',
        'Educational Psychology',
        'Guidance & Counselling',
        'Human Kinetics & Health Education',
        'Library & Information Science',
        'Science Education',
        'Social Science Education',
        'Special Education',
        'Vocational & Technical Education',
      ],
    ),
  ];

  static const List<Faculty> polytechnicSchools = <Faculty>[
    Faculty(
      name: 'School of Engineering Technology',
      icon: Icons.engineering_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Agricultural & Bio-Environmental Engineering Technology',
        'Chemical Engineering Technology',
        'Civil Engineering Technology',
        'Computer Engineering Technology',
        'Electrical / Electronic Engineering Technology',
        'Mechanical Engineering Technology',
        'Mechatronics Engineering Technology',
        'Metallurgical Engineering Technology',
        'Petroleum Engineering Technology',
        'Welding & Fabrication Engineering Technology',
      ],
    ),
    Faculty(
      name: 'School of Environmental Studies',
      icon: Icons.architecture_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Architectural Technology',
        'Building Technology',
        'Estate Management & Valuation',
        'Quantity Surveying',
        'Surveying & Geo-Informatics',
        'Urban & Regional Planning',
      ],
    ),
    Faculty(
      name: 'School of Business & Management Studies',
      icon: Icons.insights_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Accountancy',
        'Banking & Finance',
        'Business Administration & Management',
        'Insurance',
        'Local Government Studies',
        'Marketing',
        'Office Technology & Management',
        'Public Administration',
        'Purchasing & Supply',
        'Taxation',
      ],
    ),
    Faculty(
      name: 'School of Applied Sciences',
      icon: Icons.science_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Biology Technology',
        'Chemical Science Technology',
        'Environmental Health Technology',
        'Food Technology',
        'Nutrition & Dietetics',
        'Physics with Electronics',
        'Science Laboratory Technology',
        'Statistics',
      ],
    ),
    Faculty(
      name: 'School of Information & Communication Technology',
      icon: Icons.memory_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Computer Science',
        'Cyber Security',
        'Data Processing',
        'Information Technology',
        'Library & Information Science',
        'Mass Communication',
      ],
    ),
    Faculty(
      name: 'School of Art, Design & Printing Technology',
      icon: Icons.palette_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Ceramics',
        'Fashion Design & Clothing Technology',
        'Fine Art',
        'Graphic Design',
        'Printing Technology',
        'Sculpture',
        'Textile Technology',
      ],
    ),
    Faculty(
      name: 'School of Agricultural Technology',
      icon: Icons.agriculture_rounded,
      colour: Color(0xFF65A30D),
      departments: <String>[
        'Agricultural Extension & Management',
        'Agricultural Technology',
        'Animal Health & Production Technology',
        'Crop Production Technology',
        'Fisheries Technology',
        'Forestry Technology',
      ],
    ),
    Faculty(
      name: 'School of Liberal & General Studies',
      icon: Icons.auto_stories_rounded,
      colour: Color(0xFF9333EA),
      departments: <String>[
        'General Studies',
        'Hospitality Management',
        'Languages & Communication',
        'Leisure & Tourism Management',
        'Social Development',
      ],
    ),
  ];

  static const List<Faculty> collegeSchools = <Faculty>[
    Faculty(
      name: 'School of Education',
      icon: Icons.school_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Adult & Non-Formal Education',
        'Curriculum & Instruction',
        'Educational Foundations',
        'Educational Management',
        'Educational Psychology',
        'Guidance & Counselling',
        'Special Education',
      ],
    ),
    Faculty(
      name: 'School of Early Childhood Care & Primary Education',
      icon: Icons.child_care_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Early Childhood Care & Education',
        'Primary Education Studies',
      ],
    ),
    Faculty(
      name: 'School of Sciences',
      icon: Icons.science_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Agricultural Science Education',
        'Biology',
        'Chemistry',
        'Computer Science',
        'Health Education',
        'Integrated Science',
        'Mathematics',
        'Physical & Health Education',
        'Physics',
      ],
    ),
    Faculty(
      name: 'School of Languages',
      icon: Icons.translate_rounded,
      colour: Color(0xFF9333EA),
      departments: <String>[
        'Arabic',
        'English Language',
        'French',
        'Hausa',
        'Igbo',
        'Linguistics',
        'Yoruba',
      ],
    ),
    Faculty(
      name: 'School of Arts & Social Sciences',
      icon: Icons.groups_rounded,
      colour: Color(0xFFEA580C),
      departments: <String>[
        'Christian Religious Studies',
        'Economics',
        'Fine & Applied Arts',
        'Geography',
        'History',
        'Islamic Studies',
        'Music',
        'Political Science',
        'Social Studies',
        'Theatre Arts',
      ],
    ),
    Faculty(
      name: 'School of Vocational & Technical Education',
      icon: Icons.handyman_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural Education',
        'Business Education',
        'Computer Education',
        'Electrical / Electronics Technology Education',
        'Home Economics',
        'Metalwork Technology Education',
        'Woodwork & Building Technology Education',
      ],
    ),
  ];

  // ---------------------------------------------------------------- helpers

  static Faculty? facultyByName(InstitutionType type, String name) {
    for (final Faculty f in facultiesFor(type)) {
      if (f.name == name) return f;
    }
    return null;
  }

  static List<String> departmentsFor(InstitutionType type, String facultyName) =>
      facultyByName(type, facultyName)?.departments ?? const <String>[];

  /// Every department across every institution type — used by search.
  static List<String> get allDepartments {
    final Set<String> set = <String>{};
    for (final InstitutionType t in InstitutionType.values) {
      for (final Faculty f in facultiesFor(t)) {
        set.addAll(f.departments);
      }
    }
    final List<String> list = set.toList()..sort();
    return list;
  }

  /// Resolves the faculty a department belongs to, so a returning student's
  /// saved department can be shown with its parent grouping.
  static Faculty? facultyOfDepartment(
    InstitutionType type,
    String department,
  ) {
    for (final Faculty f in facultiesFor(type)) {
      if (f.departments.contains(department)) return f;
    }
    return null;
  }
}
