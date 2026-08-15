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
        'University of Uyo': uniuyoFaculties,
        'University of Ilorin': unilorinFaculties,
        'University of Calabar': unicalFaculties,
        'Bayero University, Kano': bukFaculties,
        'University of Abuja': uniabujaFaculties,
        'Lagos State University': lasuFaculties,
        'Federal University of Technology, Minna': futminnaFaculties,
        'Federal University of Technology, Owerri': futoFaculties,
        'Ahmadu Bello University, Zaria': abuFaculties,
        'Bowen University, Iwo': bowenFaculties,
        'Covenant University, Ota': covenantFaculties,
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
        'Biomedical Engineering',
        'Civil Engineering',
        'Electrical Engineering',
        'Electronic Engineering',
        'Mechanical Engineering',
        'Mechatronic Engineering',
        'Metallurgical and Materials Engineering',
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
        'Commercial and Corporate Law',
        'Customary and Indigenous Law',
        'International and Comparative Law',
        'Jurisprudence and Legal Theory',
        'Private Law',
        'Property Law',
        'Public Law',
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

  // -------------------------------------------------------------- UNIUYO
  //
  // Source: the University of Uyo's own site navigation, where every
  // department sits at /faculty-of-x/department — read on 6 August 2026.
  //
  // The menu abbreviates, and abbreviations are expanded here so a student
  // searching the ordinary word finds their department: "Agric" becomes
  // "Agricultural", "Edu." becomes "Educational", "Mgt." becomes
  // "Management". Two plain misspellings on the source are also corrected —
  // "Padiatrics" and a lower-cased "traumatology".

  static const List<Faculty> uniuyoFaculties = <Faculty>[
    Faculty(
      name: 'Faculty of Agriculture',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agricultural Economics and Extension',
        'Animal Science',
        'Crop Science',
        'Fisheries and Aquaculture',
        'Food Science and Technology',
        'Forestry and Environmental Management',
        'Soil Science and Land Management',
      ],
    ),
    Faculty(
      name: 'Faculty of Arts',
      icon: Icons.menu_book_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Communication Arts',
        'English',
        'Foreign Languages – French',
        'History and International Studies',
        'Linguistics & Nigerian Languages',
        'Music',
        'Philosophy',
        'Religious & Cultural Studies',
        'Theatre Arts',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>['Anatomy', 'Biochemistry', 'Physiology'],
    ),
    Faculty(
      name: 'Faculty of Biological Sciences',
      icon: Icons.eco_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Animal and Environmental Biology',
        'Biochemistry',
        'Botany and Ecological Studies',
        'Microbiology',
      ],
    ),
    Faculty(
      name: 'Faculty of Clinical Sciences',
      icon: Icons.local_hospital_rounded,
      colour: AppColours.danger,
      departments: <String>[
        'Community Health',
        'Haematology',
        'Medical Microbiology and Parasitology',
        'Obstetrics & Gynaecology',
        'Orthopaedics/Traumatology',
        'Paediatrics',
      ],
    ),
    Faculty(
      name: 'Faculty of Computing',
      icon: Icons.computer_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Computer Science',
        'Cyber Security',
        'Data Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Curriculum Studies, Educational Management and Planning',
        'Early Childhood and Special Education',
        'Educational Foundations, Guidance and Counselling',
        'Educational Technology and Library Science',
        'Physical & Health Education',
        'Science Education',
        'Vocational Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Engineering',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural Engineering',
        'Chemical Engineering',
        'Civil Engineering',
        'Computer Engineering',
        'Electrical & Electronics Engineering',
        'Food Engineering',
        'Mechanical Engineering',
        'Petroleum Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Environmental Studies',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture',
        'Building',
        'Estate Management',
        'Fine & Industrial Arts',
        'Geoinformatics & Land Surveying',
        'Quantity Surveying',
        'Urban and Regional Planning',
      ],
    ),
    Faculty(
      name: 'Faculty of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'International Law and Jurisprudence',
        'Private Law',
        'Public Law',
      ],
    ),
    Faculty(
      name: 'Faculty of Management Sciences',
      icon: Icons.business_center_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Accounting',
        'Banking and Finance',
        'Business Management',
        'Insurance',
        'Marketing',
      ],
    ),
    Faculty(
      name: 'Faculty of Pharmacy',
      icon: Icons.medication_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Clinical and Biopharmacy',
        'Pharmaceutical and Medical Chemistry',
        'Pharmaceutics and Pharmaceutical Technology',
        'Pharmacognosy and Natural Medicine',
        'Pharmacology and Toxicology',
      ],
    ),
    Faculty(
      name: 'Faculty of Physical Sciences',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Chemistry',
        'Geology',
        'Geophysics',
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
        'Economics',
        'Geography',
        'Political Science and Public Administration',
        'Psychology',
        'Sociology and Anthropology',
      ],
    ),
  ];

  // ------------------------------------------------------------- UNILORIN
  //
  // Source: unilorin.edu.ng/faculties for the thirteen main faculties, plus
  // the three College of Health Sciences faculties, which sit on their own
  // subdomains and are absent from that index — bms, basicclinical and
  // clinicalsciences. Read on 6 August 2026.
  //
  // Leaving the health faculties out would have been the easy read of the
  // site and the wrong one: a UNILORIN medical student would have opened the
  // app and found no faculty to pick.
  //
  // "Heamatology" is corrected to "Haematology"; the source spells it the
  // first way.

  static const List<Faculty> unilorinFaculties = <Faculty>[
    Faculty(
      name: 'Faculty of Agriculture',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agricultural Economics and Farm Management',
        'Agricultural Extension & Rural Development',
        'Agronomy',
        'Animal Production',
        'Aquaculture & Fisheries',
        'Crop Protection',
        'Forest Resources Management',
        'Home Economics & Food Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Arts',
      icon: Icons.menu_book_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Arabic',
        'English',
        'French',
        'History & International Studies',
        'Linguistics & Nigerian Languages',
        'Performing Arts',
        'Religions',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Clinical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Chemical Pathology and Immunology',
        'Haematology & Blood Transfusion',
        'Medical Laboratory Science',
        'Medical Microbiology and Parasitology',
        'Medical Radiography',
        'Pathology',
        'Pharmacology & Therapeutics',
        'Physiotherapy',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>['Anatomy', 'Medical Biochemistry', 'Physiology'],
    ),
    Faculty(
      name: 'Faculty of Clinical Sciences',
      icon: Icons.local_hospital_rounded,
      colour: AppColours.danger,
      departments: <String>[
        'Anaesthesia',
        'Behavioural Science',
        'Dentistry',
        'Epidemiology and Community Health',
        'Family Medicine',
        'Medicine',
        'Nursing Science',
        'Obstetrics and Gynaecology',
        'Ophthalmology',
        'Otorhinolaryngology',
        'Paediatrics and Child Health',
        'Radiology',
        'Surgery',
      ],
    ),
    Faculty(
      name: 'Faculty of Communication and Information Sciences',
      icon: Icons.computer_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Computer Science',
        'Information Technology',
        'Library & Information Science',
        'Mass Communication',
        'Telecommunication Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Adult & Primary Education',
        'Arts Education',
        'Educational Guidance and Counselling',
        'Educational Management',
        'Educational Technology',
        'Health Promotion & Environmental Health Education',
        'Human Kinetics & Health Education',
        'Science Education',
        'Social Sciences Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Engineering and Technology',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural & Biosystems Engineering',
        'Biomedical Engineering',
        'Chemical Engineering',
        'Civil Engineering',
        'Computer Engineering',
        'Electrical & Electronics Engineering',
        'Food & Bioprocess Engineering',
        'Materials & Metallurgical Engineering',
        'Mechanical Engineering',
        'Water Resources & Environmental Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Environmental Sciences',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture',
        'Estate Management',
        'Quantity Surveying',
        'Surveying & Geo-Informatics',
        'Urban & Regional Planning',
      ],
    ),
    Faculty(
      name: 'Faculty of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Business Law',
        'Islamic Law',
        'Jurisprudence & International Law',
        'Private & Property Law',
        'Public Law',
      ],
    ),
    Faculty(
      name: 'Faculty of Life Sciences',
      icon: Icons.eco_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Biochemistry',
        'Microbiology',
        'Optometry & Vision Science',
        'Plant Biology',
        'Zoology',
      ],
    ),
    Faculty(
      name: 'Faculty of Management Sciences',
      icon: Icons.business_center_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Accounting',
        'Business Administration',
        'Finance',
        'Industrial Relations & Personnel Management',
        'Marketing',
        'Public Administration',
      ],
    ),
    Faculty(
      name: 'Faculty of Pharmaceutical Sciences',
      icon: Icons.medication_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Clinical Pharmacy & Pharmacy Practice',
        'Pharmaceutical & Medicinal Chemistry',
        'Pharmaceutical Microbiology & Biotechnology',
        'Pharmaceutics & Industrial Pharmacy',
        'Pharmacognosy & Drug Development',
        'Pharmacology & Toxicology',
      ],
    ),
    Faculty(
      name: 'Faculty of Physical Sciences',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Chemistry',
        'Geology & Mineral Science',
        'Geophysics',
        'Industrial Chemistry',
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
        'Criminology & Security Studies',
        'Economics',
        'Geography & Environmental Management',
        'Political Science',
        'Psychology',
        'Social Work',
        'Sociology',
      ],
    ),
    Faculty(
      name: 'Faculty of Veterinary Medicine',
      icon: Icons.pets_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Theriogenology & Production',
        'Veterinary Anatomy',
        'Veterinary Medicine',
        'Veterinary Microbiology',
        'Veterinary Parasitology & Entomology',
        'Veterinary Pathology',
        'Veterinary Pharmacology & Toxicology',
        'Veterinary Physiology & Biochemistry',
        'Veterinary Public Health & Preventive Medicine',
        'Veterinary Surgery & Radiology',
      ],
    ),
  ];

  // --------------------------------------------------------------- UNICAL
  //
  // Source: unical.edu.ng/faculties.php and its twenty-eight
  // faculty_details pages — read on 6 August 2026.
  //
  // Five of those pages are not faculties a student belongs to — the
  // library, a "non-academic" entry and three research institutes — and are
  // left out, giving twenty-three.
  //
  // UNICAL shouts some department names and title-cases others on the same
  // site; everything is normalised to title case here so the picker does not
  // look broken. UNICAL also splits education across four faculties and is
  // the only mapped school with a Faculty of Oceanography.

  static const List<Faculty> unicalFaculties = <Faculty>[
    Faculty(
      name: 'Faculty of Agriculture, Forestry and Wildlife Resource Management',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agricultural Economics',
        'Agricultural Extension and Rural Sociology',
        'Animal Science',
        'Crop Science',
        'Fisheries and Aquaculture',
        'Food Science and Technology',
        'Forestry and Wildlife Resource Management',
        'Soil Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Allied Medical Sciences',
      icon: Icons.health_and_safety_rounded,
      colour: Color(0xFF0D9488),
      departments: <String>[
        'Nursing Science',
        'Physiotherapy',
        'Public Health Science',
        'Radiography and Radiological Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Arts',
      icon: Icons.menu_book_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'English and Literary Studies',
        'History and International Studies',
        'Linguistics and Nigerian Languages',
        'Mass Communication',
        'Modern Languages and Translation Studies',
        'Music',
        'Philosophy',
        'Religious and Cultural Studies',
        'Theatre and Media Studies',
      ],
    ),
    Faculty(
      name: 'Faculty of Arts and Social Science Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Arts Education',
        'Creative Arts Education',
        'Economics and Political Science Education',
        'Geography Education',
        'Humanities Education',
        'Language Arts Education',
        'Social Science Education',
        'Social Studies and Civic Education',
        'Sustainable Development Studies',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Clinical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Chemical Pathology',
        'Haematology',
        'Medical Microbiology and Parasitology',
        'Microbiology & Parasitology',
        'Pathology',
        'Pharmacology & Therapeutics',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Biochemistry',
        'Human Anatomy',
        'Human Nutrition and Dietetics',
        'Pharmacology',
        'Physiology',
      ],
    ),
    Faculty(
      name: 'Faculty of Biological Sciences',
      icon: Icons.eco_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Botany',
        'Genetics and Biotechnology',
        'Microbiology',
        'Science Laboratory Technology',
        'Zoology and Environmental Biology',
      ],
    ),
    Faculty(
      name: 'Faculty of Clinical Sciences',
      icon: Icons.local_hospital_rounded,
      colour: AppColours.danger,
      departments: <String>[
        'Anaesthesiology',
        'Community Medicine',
        'Family Medicine',
        'Internal Medicine',
        'Obstetrics and Gynaecology',
        'Ophthalmology',
        'Orthopaedics & Traumatology',
        'Otorhinolaryngology',
        'Paediatrics',
        'Psychiatry',
        'Radiology',
        'Surgery',
        'Urology',
      ],
    ),
    Faculty(
      name: 'Faculty of Computing',
      icon: Icons.computer_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Computer Science',
        'Cyber Security',
        'Information Systems',
        'Information Technology',
        'Software Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Dentistry',
      icon: Icons.medical_services_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Child Dental Health',
        'Dentistry and Dental Surgery',
        'Oral & Maxillofacial',
        'Oral Diagnosis/Medicine/Pathology',
        'Preventive Dentistry',
        'Restorative Dentistry',
      ],
    ),
    Faculty(
      name: 'Faculty of Educational Foundation Studies',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Curriculum and Teaching',
        'Educational Foundation',
        'Educational Management',
        'Educational Psychology',
        'Elementary Education',
        'Guidance and Counselling',
        'Special Needs Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Engineering',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural Engineering',
        'Chemical Engineering',
        'Civil and Environmental Engineering',
        'Computer Engineering',
        'Electrical and Electronics Engineering',
        'Mechanical Engineering',
        'Petroleum Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Environmental Sciences',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture',
        'Environmental Resource Management',
        'Estate Management',
        'Fine and Applied Arts',
        'Geography and Environmental Science',
        'Surveying Science and Geoinformatics',
        'Urban and Regional Planning',
      ],
    ),
    Faculty(
      name: 'Faculty of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>['Law'],
    ),
    Faculty(
      name: 'Faculty of Management Sciences',
      icon: Icons.business_center_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Accounting',
        'Banking and Finance',
        'Business Management',
        'Marketing',
        'Policy and Administrative Studies',
        'Public Administration',
      ],
    ),
    Faculty(
      name: 'Faculty of Medical and Laboratory Science',
      icon: Icons.science_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Clinical Chemistry and Immunology',
        'Haematology and Blood Transfusion Science',
        'Histopathology and Cytology',
        'Medical Bacteriology, Virology & Mycology',
        'Medical Parasitology and Entomology',
      ],
    ),
    Faculty(
      name: 'Faculty of Oceanography',
      icon: Icons.waves_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Biological Oceanography',
        'Mariculture',
        'Marine Oceanography',
        'Physical Oceanography',
      ],
    ),
    Faculty(
      name: 'Faculty of Pharmacy',
      icon: Icons.medication_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Clinical Pharmacy and Public Health',
        'Pharmaceutical Microbiology and Biotechnology',
        'Pharmaceutical and Medicinal Chemistry',
        'Pharmacology & Toxicology',
        'Pharmacology and Natural Medicines',
      ],
    ),
    Faculty(
      name: 'Faculty of Physical Sciences',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Electronics and Computer Technology',
        'Geology',
        'Mathematics',
        'Physics',
        'Pure and Applied Chemistry',
        'Statistics',
      ],
    ),
    Faculty(
      name: 'Faculty of Science Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Biology Education',
        'Environmental Education',
        'Health Education',
        'Human Kinetics',
        'Mathematics and Computer Science Education',
        'Physical Science Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Social Sciences',
      icon: Icons.groups_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Criminology and Security Studies',
        'Economics',
        'Library and Information Science',
        'Peace and Conflict Studies',
        'Political Science',
        'Social Work',
        'Sociology',
        'Tourism Studies',
      ],
    ),
    Faculty(
      name: 'Faculty of Vocational and Entrepreneurial Education',
      icon: Icons.handyman_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Adult and Continuing Education',
        'Agricultural Education',
        'Business Education',
        'Educational Technology',
        'Home Economics Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Vocational and Science Education',
      icon: Icons.handyman_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Human Kinetics and Health Education',
        'Science Education',
        'Vocational Education',
      ],
    ),
  ];

  // ----------------------------------------------------------------- BUK
  //
  // Source: Bayero University's eighteen faculty subdomains — each one's
  // "Departments" menu, or, where that menu pointed at a staff list instead
  // of a submenu (Economics & Management Sciences, Social Sciences), the
  // page it led to. Read on 6 August 2026.
  //
  // A few plain misspellings on the source are corrected: "Enviromental",
  // "Extention", "Maxilofacial". Engineering's departments are published as
  // bare adjectives ("Civil", "Mechanical") with "Engineering" implied by the
  // page they sit on; the full name is used here so it reads correctly once
  // it is on its own, away from that context.

  static const List<Faculty> bukFaculties = <Faculty>[
    Faculty(
      name: 'Faculty of Agriculture',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agricultural Economics and Extension',
        'Agronomy',
        'Animal Science',
        'Crop Protection',
        'Fisheries and Aquaculture',
        'Food Science and Technology',
        'Forestry and Wildlife Management',
        'Soil Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Allied Health Sciences',
      icon: Icons.health_and_safety_rounded,
      colour: Color(0xFF0D9488),
      departments: <String>[
        'Environmental Health Science',
        'Medical Laboratory Science',
        'Medical Radiography',
        'Nursing',
        'Optometry',
        'Physiotherapy',
      ],
    ),
    Faculty(
      name: 'Faculty of Arts and Islamic Studies',
      icon: Icons.menu_book_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Arabic',
        'English and Literary Studies',
        'History',
        "Islamic Studies and Shari'ah",
        'Linguistics and Foreign Languages',
        'Nigerian Languages',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>['Anatomy', 'Biochemistry', 'Human Physiology'],
    ),
    Faculty(
      name: 'Faculty of Clinical Sciences',
      icon: Icons.local_hospital_rounded,
      colour: AppColours.danger,
      departments: <String>[
        'Anaesthesiology',
        'Chemical Pathology',
        'Community Medicine',
        'Haematology & Blood Transfusion',
        'Medical Microbiology and Parasitology',
        'Medicine',
        'Obstetrics & Gynaecology',
        'Ophthalmology',
        'Otorhinolaryngology',
        'Paediatrics',
        'Pathology',
        'Psychiatry',
        'Surgery',
      ],
    ),
    Faculty(
      name: 'Faculty of Communication',
      icon: Icons.campaign_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Information and Media Studies',
        'Mass Communication',
        'Theatre and Performing Arts',
      ],
    ),
    Faculty(
      name: 'Faculty of Computing',
      icon: Icons.computer_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Computer Science',
        'Information Technology',
        'Software Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Dentistry',
      icon: Icons.medical_services_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Child Dental Health',
        'Oral Diagnostic Science',
        'Oral and Maxillofacial Surgery',
        'Preventive Dentistry',
        'Restorative Dentistry',
      ],
    ),
    Faculty(
      name: 'Faculty of Earth and Environmental Sciences',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture',
        'Environmental Management',
        'Estate Management',
        'Geography',
        'Geology',
        'Quantity Surveying',
        'Urban and Regional Planning',
      ],
    ),
    Faculty(
      name: 'Faculty of Economics & Management Sciences',
      icon: Icons.business_center_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Accounting',
        'Business Administration',
        'Economics',
        'Finance',
        'Public Administration',
      ],
    ),
    Faculty(
      name: 'Faculty of Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Adult Education and Community Development Services',
        'Education',
        'Library and Information Science',
        'Physical and Health Education',
        'Science and Technology Education',
        'Special Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Engineering',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural and Environmental Engineering',
        'Chemical and Petroleum Engineering',
        'Civil Engineering',
        'Electrical Engineering',
        'Mechanical Engineering',
        'Mechatronics Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'International Law & Jurisprudence',
        'Islamic Law',
        'Private and Commercial Law',
        'Public Law',
      ],
    ),
    Faculty(
      name: 'Faculty of Life Science',
      icon: Icons.eco_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Biological Sciences',
        'Microbiology',
        'Plant Biology',
      ],
    ),
    Faculty(
      name: 'Faculty of Pharmaceutical Sciences',
      icon: Icons.medication_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Clinical Pharmacy & Pharmacy Practice',
        'Pharmaceutical Microbiology and Biotechnology',
        'Pharmaceutical and Medicinal Chemistry',
        'Pharmaceutics and Pharmaceutical Technology',
        'Pharmacognosy and Herbal Medicine',
        'Pharmacology and Therapeutics',
      ],
    ),
    Faculty(
      name: 'Faculty of Physical Sciences',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>['Chemistry', 'Mathematical Sciences', 'Physics'],
    ),
    Faculty(
      name: 'Faculty of Social Sciences',
      icon: Icons.groups_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Economics',
        'Political Science',
        'Social Science and Administration',
        'Sociology',
      ],
    ),
    Faculty(
      name: 'Faculty of Veterinary Medicine',
      icon: Icons.pets_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Veterinary Anatomy',
        'Veterinary Microbiology',
        'Veterinary Parasitology and Entomology',
        'Veterinary Physiology and Biochemistry',
      ],
    ),
  ];

  // ------------------------------------------------------------- UNIABUJA
  //
  // Source: uniabuja.edu.ng's fourteen faculty pages, read on 6 August 2026.
  // The department list on each page is rendered by client-side JavaScript,
  // invisible to a plain HTTP fetch — read through a real browser instead so
  // nothing here was guessed from a static page that never showed its data.
  //
  // Two faculties, Clinical Science and Veterinary Medicine, are two of very
  // few genuinely blank pages on UNIABUJA's own site — no departments
  // published at all, not even a count. Rather than leave a UNIABUJA medical
  // or veterinary student with an empty faculty, their departments below
  // follow the standard Nigerian structure for those disciplines, the same
  // approach taken for UNN's Medicine and Basic Medical Sciences. Unverified,
  // flagged, worth a check by somebody on the ground.
  //
  // Education's page mixes department names with specific degree options
  // ("B. Sc. (Ed) Chemistry", "History Education") under the same list; only
  // the seven the faculty's own summary counts as departments are kept.

  static const List<Faculty> uniabujaFaculties = <Faculty>[
    Faculty(
      name: 'Faculty of Agriculture',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agricultural Economics',
        'Agricultural Economics and Extension',
        'Agricultural Extension and Rural Sociology',
        'Agronomy',
        'Animal Science',
        'Crop Protection',
        'Crop Science',
        'Dairy Science',
        'Fisheries, Aquaculture and Wildlife',
        'Food Science and Technology',
        'Forestry and Bioresources',
        'Horticulture and Landscaping',
        'Soil Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Art',
      icon: Icons.menu_book_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Arabic',
        'Christian Religious Studies',
        'English',
        'History and Diplomatic Studies',
        'Islamic Studies',
        'Linguistics and African Language',
        'Philosophy',
        'Theatre Arts',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Medical Science',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Anatomical Science',
        'Human Physiology',
        'Medical Biochemistry',
        'Medicine and Surgery',
      ],
    ),
    // Unverified — see the note above.
    Faculty(
      name: 'Faculty of Clinical Science',
      icon: Icons.local_hospital_rounded,
      colour: AppColours.danger,
      departments: <String>[
        'Anaesthesia',
        'Community Medicine',
        'Medicine',
        'Obstetrics and Gynaecology',
        'Paediatrics',
        'Psychiatry',
        'Radiology',
        'Surgery',
      ],
    ),
    Faculty(
      name: 'Faculty of Communication and Media Studies',
      icon: Icons.campaign_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Advertising and Public Relations',
        'Broadcasting, Film and Multimedia Studies',
        'Development and Strategic Communication',
        'Information, Journalism and Media Studies',
      ],
    ),
    Faculty(
      name: 'Faculty of Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Arts Education',
        'Educational Administration and Planning',
        'Educational Foundations',
        'Guidance and Counselling',
        'Library and Information Science',
        'Science and Environmental Education',
        'Social Science Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Engineering',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Aeronautic and Astronautical Engineering',
        'Agricultural Engineering',
        'Chemical Engineering',
        'Civil Engineering',
        'Electrical/Electronics Engineering',
        'Mechanical Engineering',
        'Nuclear Engineering',
        'Railway Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Environmental Science',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture and Industrial Design',
        'Building and Quantity Surveying',
        'Estate Management and Urban and Regional Planning',
        'Surveying and Geoinformatics',
      ],
    ),
    // Unverified — the site publishes no department list for Law either;
    // a single-department Law faculty is the common shape in Nigeria and
    // matches how UNICAL's own site presents its Law faculty.
    Faculty(
      name: 'Faculty of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>['Law'],
    ),
    Faculty(
      name: 'Faculty of Management Science',
      icon: Icons.business_center_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Accounting',
        'Banking and Finance',
        'Business Administration',
        'Entrepreneurship Studies',
        'Public Administration',
        'Tourism and Hospitality Management',
      ],
    ),
    Faculty(
      name: 'Faculty of Nursing and Allied Health Sciences',
      icon: Icons.health_and_safety_rounded,
      colour: Color(0xFF0D9488),
      departments: <String>['Medical Laboratory Science', 'Nursing Science'],
    ),
    Faculty(
      name: 'Faculty of Science',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Biochemistry',
        'Biology',
        'Botany',
        'Chemistry',
        'Computer Science',
        'Geology and Mining',
        'Mathematics',
        'Microbiology',
        'Physics',
        'Statistics',
        'Zoology',
      ],
    ),
    Faculty(
      name: 'Faculty of Social Science',
      icon: Icons.groups_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Economics',
        'Geography and Environmental Management',
        'Political Science',
        'Sociology',
      ],
    ),
    // Unverified — see the note above.
    Faculty(
      name: 'Faculty of Veterinary Medicine',
      icon: Icons.pets_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Veterinary Anatomy',
        'Veterinary Medicine',
        'Veterinary Pathology and Microbiology',
        'Veterinary Physiology and Pharmacology',
        'Veterinary Public Health and Preventive Medicine',
        'Veterinary Surgery and Radiology',
      ],
    ),
  ];

  // ---------------------------------------------------------------- LASU
  //
  // Source: lasu.edu.ng's per-faculty pages, read on 6 August 2026. Each
  // department's real name sits in a tooltip attribute the page also uses —
  // the visible label is truncated with an ellipsis for anything long, so
  // the tooltip is what was read, not the truncated text.
  //
  // Left out entirely: the School of Postgraduate Studies (not a faculty an
  // undergraduate belongs to) and CESSED, which turns out to be a research
  // centre — the Centre for Environmental Studies and Sustainable
  // Development — filed alongside the faculties on LASU's own site but not
  // one. The duplicate "School of Creativity, Culture and Tourism Studies"
  // page is merged into one entry.
  //
  // Faculty of Environmental Sciences publishes no departments on LASU's
  // site at all — unverified, its departments below follow the standard
  // shape that faculty takes elsewhere. "Anasthesia" and "Hematology" are
  // corrected to the British spelling the rest of the app uses.

  static const List<Faculty> lasuFaculties = <Faculty>[
    Faculty(
      name: 'College of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Anatomy',
        'Chemical Pathology',
        'Haematology and Blood Transfusion',
        'Medical Biochemistry',
        'Medical Microbiology and Parasitology',
        'Pathology and Forensic Medicine',
        'Pharmacology',
        'Physiology',
      ],
    ),
    Faculty(
      name: 'College of Dentistry',
      icon: Icons.medical_services_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Child Dental Health',
        'Oral Pathology / Oral Medicine',
        'Oral and Maxillofacial Surgery',
        'Preventive Dentistry',
        'Restorative Dentistry',
      ],
    ),
    Faculty(
      name: 'Faculty of Allied Health Sciences',
      icon: Icons.health_and_safety_rounded,
      colour: Color(0xFF0D9488),
      departments: <String>[
        'Medical Laboratory Sciences',
        'Physiotherapy',
        'Radiography',
      ],
    ),
    Faculty(
      name: 'Faculty of Arts',
      icon: Icons.menu_book_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'English Language',
        'Foreign Languages',
        'History and International Relations',
        'Linguistics, African Languages and Communication Arts',
        'Music',
        'Philosophy',
        'Religions',
        'Theatre Arts',
      ],
    ),
    Faculty(
      name: 'Faculty of Clinical Sciences',
      icon: Icons.local_hospital_rounded,
      colour: AppColours.danger,
      departments: <String>[
        'Anaesthesia',
        'Behavioural Medicine',
        'Community Health and Primary Care',
        'Medicine',
        'Nursing',
        'Obstetrics and Gynaecology',
        'Paediatrics and Child Health',
        'Radiology',
        'Surgery',
      ],
    ),
    Faculty(
      name: 'Faculty of Computing and Information Technology',
      icon: Icons.computer_rounded,
      colour: AppColours.primary,
      departments: <String>['Computer Science'],
    ),
    Faculty(
      name: 'Faculty of Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Educational Foundations and Counselling Psychology',
        'Educational Management',
        'Human Kinetics and Health Education',
        'Language, Arts and Science Education',
        'Science and Technology Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Engineering',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Aeronautics and Astronautics Engineering',
        'Aerospace Engineering',
        'Chemical Engineering',
        'Electronics and Computer Engineering',
        'Mechanical Engineering',
      ],
    ),
    // Unverified — see the note above.
    Faculty(
      name: 'Faculty of Environmental Sciences',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture',
        'Building',
        'Estate Management',
        'Surveying and Geoinformatics',
        'Urban and Regional Planning',
      ],
    ),
    Faculty(
      name: 'Faculty of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Business Law',
        'International and Islamic Law',
        'Jurisprudence and International Law',
        'Public and Private Law',
      ],
    ),
    Faculty(
      name: 'Faculty of Management Sciences',
      icon: Icons.business_center_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Accounting',
        'Banking and Finance',
        'Business Administration',
        'Industrial Relations and Personnel Management',
        'Insurance',
        'Local Government Administration and Development Studies',
        'Management Technology',
        'Marketing',
        'Public Administration',
      ],
    ),
    Faculty(
      name: 'Faculty of Science',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Biochemistry',
        'Botany',
        'Chemistry',
        'Fisheries',
        'Mathematics',
        'Microbiology',
        'Physics',
        'Science Laboratory Technology',
        'Zoology and Environmental Biology',
      ],
    ),
    Faculty(
      name: 'Faculty of Social Sciences',
      icon: Icons.groups_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Economics',
        'Geography and Planning',
        'Political Science',
        'Psychology',
        'Sociology',
      ],
    ),
    Faculty(
      name: 'School of Agriculture',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>['Agricultural Economics', 'Agriculture'],
    ),
    Faculty(
      name: 'School of Communications',
      icon: Icons.campaign_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Broadcasting',
        'Journalism',
        'Public Relations and Advertising',
      ],
    ),
    Faculty(
      name: 'School of Creativity, Culture and Tourism Studies',
      icon: Icons.theater_comedy_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>['Tourism and Hospitality Management'],
    ),
    Faculty(
      name: 'School of Library, Archival and Information Science',
      icon: Icons.local_library_rounded,
      colour: AppColours.info,
      departments: <String>['Library and Information Science'],
    ),
    Faculty(
      name: 'School of Transport',
      icon: Icons.local_shipping_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Transport Management and Operations',
        'Transport Planning and Policy',
        'Transport Technology and Infrastructure',
      ],
    ),
  ];

  // ------------------------------------------------------------ FUTMINNA
  //
  // Source: futminna.edu.ng's individual school pages, read on 6 August
  // 2026. As a university of technology, FUTMinna calls its faculties
  // "Schools" rather than "Faculty of X" — kept as their own name here
  // rather than translated, the way LASU's "School of Agriculture" and
  // "College of Basic Medical Sciences" were kept rather than renamed.
  //
  // Four schools in the site's own navigation are left out. Architectural
  // Technology (SAT) is a dead link, its subject now folded into
  // Environmental Technology below. The College of Medical Sciences and
  // Health Technology (CMSHT) is an umbrella over three of the schools
  // already listed separately, not a faculty with departments of its own.
  // Agronomy and Forestry Technology (SAFT) and Agricultural Management and
  // Extension Technology (SAMET) both showed the identical four departments
  // when read — a caching fault on the site, not two schools that happen to
  // teach the same thing — so School of Agriculture and Agricultural
  // Technology is kept instead, its eight departments read from the
  // school's own prose history rather than a sidebar that cannot be
  // trusted for these two.

  static const List<Faculty> futminnaFaculties = <Faculty>[
    Faculty(
      name: 'School of Agriculture and Agricultural Technology',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agricultural Economics and Farm Management',
        'Agricultural Extension and Rural Development',
        'Animal Production',
        'Crop Production',
        'Food Science and Technology',
        'Horticulture',
        'Soil Science and Land Management',
        'Water Resources, Aquaculture and Fisheries Technology',
      ],
    ),
    Faculty(
      name: 'School of Allied Health Sciences',
      icon: Icons.health_and_safety_rounded,
      colour: Color(0xFF0D9488),
      departments: <String>['Medical Laboratory Science', 'Nursing Science'],
    ),
    Faculty(
      name: 'School of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Human Anatomy',
        'Human Physiology',
        'Medicine and Surgery',
      ],
    ),
    Faculty(
      name: 'School of Electrical Engineering and Technology',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Computer Engineering',
        'Electrical and Electronics Engineering',
        'Mechatronics Engineering',
        'Telecommunication Engineering',
      ],
    ),
    Faculty(
      name: 'School of Environmental Technology',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture',
        'Building',
        'Estate Management and Valuation',
        'Quantity Surveying',
        'Surveying and Geoinformatics',
        'Urban and Regional Planning',
      ],
    ),
    Faculty(
      name: 'School of Information and Communications Technology',
      icon: Icons.computer_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Computer Science',
        'Cyber Security',
        'Data Science',
        'Information & Media Technology',
        'Information Technology',
        'Library & Information Technology',
        'Software Engineering',
      ],
    ),
    Faculty(
      name: 'School of Infrastructure, Process Engineering and Technology',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural and Bio Resources Engineering',
        'Chemical Engineering',
        'Civil Engineering',
        'Food Engineering',
        'Materials and Metallurgical Engineering',
        'Mechanical Engineering',
        'Petroleum and Gas Engineering',
      ],
    ),
    Faculty(
      name: 'School of Innovative Technology',
      icon: Icons.lightbulb_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Entrepreneurship and Business Studies',
        'Project Management Technology',
        'Transport Management Technology',
      ],
    ),
    Faculty(
      name: 'School of Life Sciences',
      icon: Icons.eco_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Animal Biology',
        'Biochemistry',
        'Microbiology',
        'Plant Biology',
      ],
    ),
    Faculty(
      name: 'School of Pharmaceutical Sciences',
      icon: Icons.medication_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>['Doctor of Pharmacy (Pharm D)'],
    ),
    Faculty(
      name: 'School of Physical Sciences',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Chemistry',
        'Geography',
        'Geology',
        'Mathematics',
        'Physics',
        'Statistics',
      ],
    ),
    Faculty(
      name: 'School of Science and Technology Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Educational Technology',
        'Industrial and Technology Education',
        'Library and Information Science',
        'Science Education',
      ],
    ),
  ];

  // ------------------------------------------------------------- FUTO
  //
  // Source: futo.edu.ng's "Schools and Departments" page, read on 6 August
  // 2026 — the fullest single page found for any school so far, giving
  // every department for every faculty in one place with no gaps to guess
  // at. Like FUTMinna, FUTO calls its faculties "Schools", kept as its own
  // name here.
  //
  // Left out: the Directorate of General Studies and the School of
  // Postgraduate Studies, neither of which is a faculty an undergraduate
  // belongs to.
  //
  // Estate Management appears twice on FUTO's own page — once in
  // Environmental Sciences as "Estate Management and Evaluation" and again
  // in Logistics and Innovation Technology as "Estate Management and
  // Valuation" — kept as published rather than merged, since the source did
  // not treat them as the same entry.

  static const List<Faculty> futoFaculties = <Faculty>[
    Faculty(
      name: 'School of Agriculture and Agricultural Technology',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agribusiness',
        'Agricultural Economics',
        'Agricultural Extension',
        'Animal Science Technology',
        'Crop Science and Technology',
        'Fisheries and Aquaculture Technology',
        'Forestry and Wildlife Technology',
        'Soil Science and Technology',
      ],
    ),
    Faculty(
      name: 'School of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>['Human Anatomy', 'Human Physiology'],
    ),
    Faculty(
      name: 'School of Biological Science',
      icon: Icons.eco_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Biochemistry',
        'Biology',
        'Biotechnology',
        'Forensic Science',
        'Microbiology',
      ],
    ),
    Faculty(
      name: 'School of Electrical Systems and Engineering Technology',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Computer Engineering',
        'Electrical (Power Systems) Engineering',
        'Electronics Engineering',
        'Mechatronics Engineering',
        'Telecommunications Engineering',
      ],
    ),
    Faculty(
      name: 'School of Engineering and Engineering Technology',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural and Bioresources Engineering',
        'Biomedical Engineering',
        'Chemical Engineering',
        'Civil Engineering',
        'Food Science and Technology',
        'Material and Metallurgical Engineering',
        'Mechanical Engineering',
        'Petroleum Engineering',
        'Polymer and Textile Engineering',
      ],
    ),
    Faculty(
      name: 'School of Environmental Sciences',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture',
        'Building Technology',
        'Environmental Management',
        'Estate Management and Evaluation',
        'Quantity Surveying',
        'Surveying and Geoinformatics',
        'Urban and Regional Planning',
      ],
    ),
    Faculty(
      name: 'School of Health Technology',
      icon: Icons.health_and_safety_rounded,
      colour: Color(0xFF0D9488),
      departments: <String>[
        'Dental Technology',
        'Environmental Health Science',
        'Optometry',
        'Prosthetics and Orthotics',
        'Public Health Technology',
        'Radiography',
      ],
    ),
    Faculty(
      name: 'School of Information and Communication Technology',
      icon: Icons.computer_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Computer Science',
        'Cyber Security',
        'Information Technology',
        'Software Engineering',
      ],
    ),
    Faculty(
      name: 'School of Logistics and Innovation Technology',
      icon: Icons.local_shipping_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Entrepreneurship and Innovation',
        'Estate Management and Valuation',
        'Logistics and Supply Chain Management',
        'Logistics and Transport Technology',
        'Maritime Technology and Logistics',
        'Project Management Technology',
      ],
    ),
    Faculty(
      name: 'School of Physical Science',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Chemistry',
        'Mathematics',
        'Physics',
        'Science Laboratory Technology',
        'Statistics',
      ],
    ),
  ];

  // ---------------------------------------------------------------- ABU
  //
  // Source: Ahmadu Bello University's faculty subdomains, read on 6 August
  // 2026. Each faculty's real department names sit as link text on cards
  // that link to /department/ or /departments/ pages — a URL slug alone
  // ("agriceng", "dcs") would not have made a readable department name, so
  // the visible text is what was read, department by department.
  //
  // ABU's College of Medical Sciences splits medicine across five
  // faculties. Two of those — Basic Medical Sciences and Basic Clinical
  // Sciences — were read directly; the university's own site returned a
  // broken error page for the other three (Allied Health Sciences,
  // Clinical Sciences, Dental Surgery) on every attempt, so those are left
  // out rather than guessed at. Faculty of Pharmaceutical Sciences and
  // Faculty of Management Sciences were unreachable outright and are
  // likewise left out — a UNILORIN-style situation without a working
  // alternative source to fall back on this time.

  static const List<Faculty> abuFaculties = <Faculty>[
    Faculty(
      name: 'Faculty of Agriculture',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agricultural Economics',
        'Agricultural Extension & Rural Development',
        'Agronomy',
        'Animal Science',
        'Crop Protection',
        'Plant Science',
        'Soil Science',
      ],
    ),
    Faculty(
      name: 'Faculty of Arts',
      icon: Icons.menu_book_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'African Languages and Cultures',
        'Arabic',
        'Archaeology and Heritage Studies',
        'English and Literary Studies',
        'French',
        'History',
        'Philosophy',
        'Theatre and Performing Arts',
      ],
    ),
    // Verified via the college's own site plus its published faculty
    // history; the site itself did not serve a full department listing.
    Faculty(
      name: 'Faculty of Basic Clinical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>[
        'Chemical Pathology',
        'Clinical Pharmacology & Therapeutics',
        'Haematology & Blood Transfusion',
        'Medical Microbiology',
        'Pathology (Morbid Anatomy)',
      ],
    ),
    Faculty(
      name: 'Faculty of Basic Medical Sciences',
      icon: Icons.biotech_rounded,
      colour: Color(0xFF0891B2),
      departments: <String>['Anatomy', 'Medical Biochemistry', 'Physiology'],
    ),
    Faculty(
      name: 'Faculty of Education',
      icon: Icons.school_rounded,
      colour: AppColours.info,
      departments: <String>[
        'Art & Social Science Education',
        'Educational Foundations & Curriculum',
        'Educational Psychology & Counselling',
        'Library & Information Science',
        'Physical & Health Education',
        'Science Education',
        'Vocational & Technical Education',
      ],
    ),
    Faculty(
      name: 'Faculty of Engineering',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Agricultural and Bio-Resources Engineering',
        'Chemical Engineering',
        'Civil Engineering',
        'Computer Engineering',
        'Electrical Engineering',
        'Electronics and Telecommunication Engineering',
        'Mechanical Engineering',
        'Metallurgical and Materials Engineering',
        'Polymer and Textile Engineering',
        'Water Resources and Environmental Engineering',
      ],
    ),
    Faculty(
      name: 'Faculty of Environmental Design',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>[
        'Architecture',
        'Building',
        'Fine Arts',
        'Geomatics',
        'Glass and Silicate Technology',
        'Industrial Design',
      ],
    ),
    Faculty(
      name: 'Faculty of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>[
        'Commercial Law',
        'Islamic Law',
        'Private Law',
        'Public Law',
      ],
    ),
    Faculty(
      name: 'Faculty of Life Sciences',
      icon: Icons.eco_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Biochemistry',
        'Biology',
        'Botany',
        'Microbiology',
        'Zoology',
      ],
    ),
    Faculty(
      name: 'Faculty of Physical Sciences',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Chemistry',
        'Computer Science',
        'Geography',
        'Geology',
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
        'Economics',
        'Mass Communication',
        'Political Science and International Studies',
        'Sociology',
      ],
    ),
    Faculty(
      name: 'Faculty of Veterinary Medicine',
      icon: Icons.pets_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Anatomy',
        'Medicine',
        'Microbiology',
        'Parasitology',
        'Pathology',
        'Pharmacology',
        'Physiology',
        'Public Health and Preventive Medicine',
        'Surgery and Radiology',
        'Theriogenology',
      ],
    ),
  ];

  // -------------------------------------------------------------- BOWEN
  //
  // Source: Bowen University's own programme directory at
  // bowen.edu.ng/degree-programme/, read on 6 August 2026 — a single page
  // tagging every programme with the college that teaches it, the most
  // exhaustive single source found across every school mapped so far.
  //
  // Bowen is private and organises itself into Colleges rather than
  // Faculties, kept as its own name here, the way LASU's Colleges were.
  // Environmental Management is filed under the College of Agriculture,
  // Engineering and Science on Bowen's own page rather than under
  // Environmental Sciences — kept where the source put it rather than
  // moved to where it might be expected.

  static const List<Faculty> bowenFaculties = <Faculty>[
    Faculty(
      name: 'College of Agriculture, Engineering and Science',
      icon: Icons.agriculture_rounded,
      colour: AppColours.success,
      departments: <String>[
        'Agricultural Economics',
        'Agricultural Extension and Rural Development',
        'Animal Science',
        'Biochemistry',
        'Biotechnology',
        'Chemistry',
        'Crop Protection',
        'Electrical/Electronics Engineering',
        'Environmental Management',
        'Food Science and Technology',
        'Industrial Chemistry',
        'Mathematics',
        'Mechatronics Engineering',
        'Microbiology',
        'Physics',
        'Plant Biology',
        'Pure and Applied Biology',
        'Statistics',
        'Zoology',
      ],
    ),
    Faculty(
      name: 'College of Computing Studies',
      icon: Icons.computer_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Computer Science',
        'Cyber Security',
        'Information Technology',
        'Software Engineering',
      ],
    ),
    Faculty(
      name: 'College of Environmental Sciences',
      icon: Icons.apartment_rounded,
      colour: Color(0xFFCA8A04),
      departments: <String>['Architecture', 'Surveying and Geoinformatics'],
    ),
    Faculty(
      name: 'College of Health Sciences',
      icon: Icons.health_and_safety_rounded,
      colour: Color(0xFF0D9488),
      departments: <String>[
        'Anatomy',
        'Medical Laboratory Science',
        'Medicine and Surgery',
        'Nursing Science',
        'Nutrition and Dietetics',
        'Physiology',
        'Physiotherapy',
        'Public Health',
      ],
    ),
    Faculty(
      name: 'College of Law',
      icon: Icons.gavel_rounded,
      colour: Color(0xFF7C3AED),
      departments: <String>['Law'],
    ),
    Faculty(
      name: 'College of Liberal Studies',
      icon: Icons.menu_book_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Communication Arts',
        'English',
        'History and Diplomatic Studies',
        'Music',
        'Religious Studies',
        'Theatre Arts',
      ],
    ),
    Faculty(
      name: 'College of Management and Social Sciences',
      icon: Icons.business_center_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Accounting',
        'Banking and Finance',
        'Business Administration',
        'Economics',
        'Industrial Relations and Personnel Management',
        'International Relations',
        'Mass Communication',
        'Political Science',
        'Sociology',
      ],
    ),
  ];

  // ----------------------------------------------------------- COVENANT
  //
  // Source: Covenant University's four college pages, read on 6 August
  // 2026. The site's own pages timed out under direct fetching on the day
  // this was read; each college's department list was confirmed against
  // its own page regardless, rather than assembled from search snippets
  // alone.
  //
  // Private, and organised into Colleges rather than Faculties, kept as
  // its own name here. "Electrical and Information Engineering" is one
  // department covering Computer, Electrical/Electronics and
  // Information/Communication Engineering as specialisations rather than
  // three separate departments — kept as the college itself structures it.

  static const List<Faculty> covenantFaculties = <Faculty>[
    Faculty(
      name: 'College of Engineering',
      icon: Icons.engineering_rounded,
      colour: AppColours.accent,
      departments: <String>[
        'Chemical Engineering',
        'Civil Engineering',
        'Electrical and Information Engineering',
        'Mechanical Engineering',
        'Petroleum Engineering',
      ],
    ),
    Faculty(
      name: 'College of Leadership and Development Studies',
      icon: Icons.groups_rounded,
      colour: Color(0xFFDB2777),
      departments: <String>[
        'Languages and General Studies',
        'Leadership Studies',
        'Political Science and International Relations',
        'Psychology',
      ],
    ),
    Faculty(
      name: 'College of Management and Social Sciences',
      icon: Icons.business_center_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Accounting',
        'Banking and Finance',
        'Business Management',
        'Economics',
        'Mass Communication',
        'Sociology',
      ],
    ),
    Faculty(
      name: 'College of Science and Technology',
      icon: Icons.science_rounded,
      colour: AppColours.primary,
      departments: <String>[
        'Architecture',
        'Biochemistry',
        'Biological Sciences',
        'Building Technology',
        'Chemistry',
        'Computer and Information Sciences',
        'Estate Management',
        'Mathematics',
        'Physics',
      ],
    ),
  ];
}
