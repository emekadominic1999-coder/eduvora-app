import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'academic_structure.dart';

/// Faculties and departments for institutions whose real structure Eduvora
/// knows, replacing the generic per-type taxonomy for those schools.
///
/// The generic list in [AcademicStructure] is a superset built to cover every
/// Nigerian institution at once. It is the right default for a school nobody
/// has mapped yet, and the wrong answer for one that has been: a UNN student
/// should not be offered Marine Biology or Quantity Surveying, because UNN
/// does not teach them, and should be offered Pure and Industrial Chemistry
/// under its real faculty rather than a generic "Faculty of Science".
///
/// Anything listed here is taken from the institution's own published
/// structure, not inferred. Where a faculty's departments could not be read
/// from the source, that is recorded in a comment above it rather than filled
/// in with a plausible guess.
class InstitutionFaculties {
  const InstitutionFaculties._();

  /// Institutions with a verified, school-specific structure.
  static const Map<String, List<Faculty>> _byInstitution =
      <String, List<Faculty>>{
        'University of Nigeria, Nsukka': unnFaculties,
        'Nnamdi Azikiwe University, Awka': unizikFaculties,
      };

  /// True when this institution has been mapped properly.
  static bool hasStructureFor(String institutionName) =>
      _byInstitution.containsKey(institutionName);

  /// The institution's own faculties, or null to fall back to the generic
  /// taxonomy for its type.
  static List<Faculty>? forInstitution(String institutionName) =>
      _byInstitution[institutionName];

  /// Names of every institution mapped so far.
  static List<String> get mappedInstitutions =>
      _byInstitution.keys.toList()..sort();

  /// Every mapped school's faculties, so counts and search can include
  /// departments the generic taxonomy does not carry.
  static Iterable<List<Faculty>> get allMappedFaculties =>
      _byInstitution.values;

  // ---------------------------------------------------------------- UNN
  //
  // Source: the University of Nigeria's own site — unn.edu.ng/academics
  // /faculties and the individual faculty subdomains — read on 6 August 2026.
  // Seventeen faculties across the Nsukka, Enugu, Ituku-Ozalla and Aba
  // campuses.
  //
  // Two faculties publish no department list of their own: Basic Medical
  // Sciences and Medicine. Their departments below follow the standard
  // Nigerian medical-school structure and are the only entries here not read
  // from UNN's own pages — worth a check by somebody on the ground.

  static const List<Faculty> unnFaculties = <Faculty>[
    Faculty(
      name: 'Faculty of Agriculture',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agricultural Economics',
        'Agricultural Extension',
        'Animal Science',
        'Crop Science',
        'Food Science and Technology',
        'Nutrition and Dietetics',
        'Soil Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Arts',
      icon: Icons.menu_book_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Archaeology and Tourism',
        'English and Literary Studies',
        'Fine and Applied Arts',
        'Foreign Languages and Literary Studies',
        'History and International Studies',
        'Linguistics, Igbo and Other Nigerian Languages',
        'Mass Communication',
        'Music',
        'Theatre and Film Studies',
      ],
    ),
    // Departments not published on the faculty site — standard structure.
    Faculty(
      name: 'Faculty of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Anatomy',
        'Medical Biochemistry',
        'Physiology',
      ],
    ),
    Faculty(
      name: 'Faculty of Biological Sciences',
      icon: Icons.eco_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Biochemistry',
        'Microbiology',
        'Plant Science and Biotechnology',
        'Zoology and Environmental Biology',
      ],
    ),
    Faculty(
      name: 'Faculty of Business Administration',
      icon: Icons.business_center_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Accountancy',
        'Banking and Finance',
        'Management',
        'Marketing',
      ],
    ),
    Faculty(
      name: 'Faculty of Dentistry',
      icon: Icons.medical_services_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Child Dental Health',
        'Oral and Maxillofacial Surgery',
        'Preventive Dentistry',
        'Restorative Dentistry',
      ],
    ),
    Faculty(
      name: 'Faculty of Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Adult Education and Extra-Mural Studies',
        'Arts Education',
        'Educational Foundations',
        'Health and Physical Education',
        'Home Economics and Hospitality Management Education',
        'Library and Information Science',
        'Science Education',
        'Social Science Education',
        'Vocational Teacher Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Engineering',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural and Bioresources Engineering',
        'Civil Engineering',
        'Electrical Engineering',
        'Electronic Engineering',
        'Materials and Metallurgical Engineering',
        'Mechanical Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Environmental Studies',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture',
        'Estate Management',
        'Geoinformatics and Surveying',
        'Urban and Regional Planning',
      ],
    ),
    Faculty(
      name: 'Faculty of Health Sciences and Technology',
      icon: Icons.health_and_safety_rounded,
      colour: Color(0xFF0D9488),
      departments: <String>[
        'Medical Laboratory Sciences',
        'Medical Rehabilitation',
        'Nursing Sciences',
        'Radiography and Radiological Sciences',
      ],
    ),
    Faculty(
      name: 'Faculty of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'International Law and Jurisprudence',
        'Private and Property Law',
        'Public and Private Law',
      ],
    ),
    // Departments not published on the faculty site — standard structure.
    Faculty(
      name: 'Faculty of Medicine',
      icon: Icons.local_hospital_rounded,
      colour: AppColours.danger,
      departments: <String>[
        'Community Medicine',
        'Medical Microbiology',
        'Medicine',
        'Obstetrics and Gynaecology',
        'Ophthalmology',
        'Otorhinolaryngology',
        'Paediatrics',
        'Pathology',
        'Pharmacology and Therapeutics',
        'Psychological Medicine',
        'Radiation Medicine',
        'Surgery',
      ],
    ),
    Faculty(
      name: 'Faculty of Pharmaceutical Sciences',
      icon: Icons.medication_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Clinical Pharmacy and Pharmacy Management',
        'Pharmaceutical Technology and Industrial Pharmacy',
        'Pharmaceutical and Medicinal Chemistry',
        'Pharmaceutics',
        'Pharmacognosy and Environmental Medicine',
        'Pharmacology and Toxicology',
      ],
    ),
    Faculty(
      name: 'Faculty of Physical Sciences',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Computer Science',
        'Geology',
        'Mathematics',
        'Physics and Astronomy',
        'Pure and Industrial Chemistry',
        'Statistics',
      ],
    ),
    Faculty(
      name: 'Faculty of Social Sciences',
      icon: Icons.groups_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Economics',
        'Geography',
        'Philosophy',
        'Political Science',
        'Psychology',
        'Public Administration and Local Government',
        'Religion and Cultural Studies',
        'Social Work',
        'Sociology and Anthropology',
      ],
    ),
    Faculty(
      name: 'Faculty of Veterinary Medicine',
      icon: Icons.pets_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Animal Health and Production',
        'Veterinary Anatomy',
        'Veterinary Obstetrics and Reproductive Diseases',
        'Veterinary Parasitology and Entomology',
        'Veterinary Pathology and Microbiology',
        'Veterinary Physiology and Pharmacology',
        'Veterinary Public Health and Preventive Medicine',
        'Veterinary Surgery',
      ],
    ),
    Faculty(
      name: 'Faculty of Vocational Technical Education',
      icon: Icons.handyman_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural Education',
        'Business Education',
        'Computer and Robotics Education',
        'Home Economics Education',
        'Industrial Technical Education',
      ],
    ),
  ];

  // -------------------------------------------------------------- UNIZIK
  //
  // Source: Nnamdi Azikiwe University's own faculty sites — the seventeen
  // subdomains linked from unizik.edu.ng/academics — read on 6 August 2026.
  //
  // Two names are corrected from the source: "Geography and Meterology" is
  // spelled "Meteorology" here so a student searching the ordinary spelling
  // finds it, and a stray "Department of Philosophy" is trimmed to match how
  // every other entry is written.
  //
  // Some faculties list overlapping entries on their own pages — Medicine
  // carries both "Medicine" and "Medicine and Surgery", Agriculture carries
  // "Agricultural Economics", "Agricultural Extension" and the combined
  // "Agricultural Economics and Extension". Those are kept as published
  // rather than merged, because a student's own department name is whichever
  // one their faculty actually used.

  static const List<Faculty> unizikFaculties = <Faculty>[
    Faculty(
      name: 'Faculty of Agriculture',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agricultural Economics',
        'Agricultural Economics and Extension',
        'Agricultural Extension',
        'Animal Science and Production',
        'Crop Science and Horticulture',
        'Fisheries and Aquaculture',
        'Food Science and Technology',
        'Forestry and Wildlife',
        'Soil Science and Management',
      ],
    ),
    Faculty(
      name: 'Faculty of Arts',
      icon: Icons.menu_book_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'English & Literary Studies',
        'History & International Studies',
        'Igbo Language & Linguistics',
        'Mass Communication',
        'Philosophy',
        'Religion & Human Relations',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Clinical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Anatomic Pathology/Forensic Medicine',
        'Chemical Pathology',
        'Haematology',
        'Immunology',
        'Medical Microbiology and Parasitology',
        'Pharmacology',
        'Pharmacology and Therapeutics',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Anatomy',
        'Human Biochemistry',
        'Human Physiology',
      ],
    ),
    Faculty(
      name: 'Faculty of Bio-Sciences',
      icon: Icons.eco_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Applied Biochemistry',
        'Applied Microbiology and Brewing',
        'Botany',
        'Parasitology and Entomology',
        'Zoology',
      ],
    ),
    Faculty(
      name: 'Faculty of Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Adult Education',
        'Early Childhood and Primary Education',
        'Education and Biology',
        'Education and Chemistry',
        'Education and Computer Science',
        'Education and Economics',
        'Education and English Language',
        'Education and French',
        'Education and History',
        'Education and Igbo',
        'Education and Integrated Science',
        'Education and Mathematics',
        'Education and Physics',
        'Education and Political Science',
        'Education and Religious Studies',
        'Educational Foundations',
        'Educational Management and Policy',
        'Environmental Education',
        'Geography Education',
        'Guidance and Counselling',
        'Health Education',
        'Health Promotion and Public Health Education',
        'Human Kinetics and Sports Science',
        'Language Art and Communication Education',
        'Library and Information Sciences',
        'Physical Education',
        'Physical and Health Education',
        'Science Education',
        'Social and Civic Education',
        'Special Needs Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Engineering',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Chemical Engineering',
        'Civil Engineering',
        'Computer Engineering',
        'Electrical & Electronic Engineering',
        'Mechanical Engineering',
        'Metallurgical & Materials Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Environmental Sciences',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture',
        'Building',
        'Environmental Management',
        'Estate Management',
        'Fine and Applied Arts',
        'Geography and Meteorology',
        'Interior Architecture and Design',
        'Landscape Architecture',
        'Quantity Surveying',
        'Surveying and Geoinformatics',
        'Urban and Regional Planning',
      ],
    ),
    Faculty(
      name: 'College of Health Sciences & Technology',
      icon: Icons.health_and_safety_rounded,
      colour: Color(0xFF0D9488),
      departments: <String>[
        'Dentistry',
        'Medical Laboratory Science',
        'Medicine & Surgery',
        'Nursing Science',
        'Pharmacy',
        'Physiotherapy',
      ],
    ),
    Faculty(
      name: 'Faculty of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Commercial & Industrial Law',
        'Jurisprudence & Legal Theory',
        'Private & Property Law',
        'Public & International Law',
      ],
    ),
    Faculty(
      name: 'Faculty of Management Sciences',
      icon: Icons.business_center_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Accounting',
        'Banking & Finance',
        'Business Administration',
        'Marketing',
        'Public Administration',
      ],
    ),
    Faculty(
      name: 'Faculty of Medical Laboratory Science',
      icon: Icons.science_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Clinical Chemistry',
        'Haematology and Blood Transfusion Science',
        'Histopathology',
        'Immuno Chemistry and Immunology',
        'Medical Laboratory Science',
        'Medical Microbiology',
      ],
    ),
    Faculty(
      name: 'Faculty of Medicine',
      icon: Icons.local_hospital_rounded,
      colour: AppColours.danger,
      departments: <String>[
        'Anaesthesiology',
        'Community Medicine',
        'Dental Surgery',
        'Family Medicine',
        'Internal Medicine',
        'Medicine',
        'Medicine and Surgery',
        'Mental Health',
        'Obstetrics and Gynaecology',
        'Ophthalmology',
        'Orthopedic',
        'Otorhinolaryngology',
        'Paediatrics',
        'Primary Health Care',
        'Radiology',
        'Surgery',
      ],
    ),
    Faculty(
      name: 'Faculty of Pharmaceutical Sciences',
      icon: Icons.medication_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Clinical Pharmacy and Pharmacy Management',
        'Forensic Science',
        'Pharmaceutical Microbiology and Biotechnology',
        'Pharmaceutical and Medicinal Chemistry',
        'Pharmaceutics and Pharmaceutical Technology',
        'Pharmacognosy and Traditional Medicine',
        'Pharmacology and Toxicology',
        'Pharmacy/Pharm D',
      ],
    ),
    Faculty(
      name: 'Faculty of Physical Sciences',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Computer Science',
        'Industrial Physics',
        'Information Technology',
        'Mathematics',
        'Physics',
        'Statistics',
      ],
    ),
    Faculty(
      name: 'Faculty of Social Sciences',
      icon: Icons.groups_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Advertising',
        'Broadcasting',
        'Development and Communication Studies',
        'Economics',
        'Journalism and Media Studies',
        'Mass Communication',
        'Political Science',
        'Psychology',
        'Sociology and Anthropology',
      ],
    ),
    Faculty(
      name: 'Faculty of Technology and Vocational Education',
      icon: Icons.handyman_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural Science and Education',
        'Auto and Mechanical Technology Education',
        'Building and Woodwork Technology Education',
        'Business Education',
        'Electrical/Electronics Education',
        'Home Economics Education',
        'Industrial Technology Education',
        'Technical Education',
      ],
    ),
  ];
}
