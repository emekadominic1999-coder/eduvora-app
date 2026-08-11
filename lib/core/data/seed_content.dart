import '../models/community.dart';
import '../models/study_material.dart';

/// The starter library shipped with Eduvora.
///
/// Two things happen here:
///
/// 1. **Curated entries** — community threads that read like a live campus
///    feed.
/// 2. **Generated entries** — materials are composed from faculty-specific
///    topic pools so that *every* department in the academic taxonomy has a
///    populated library on first launch, rather than only the handful
///    someone remembered to hand-write.
///
/// Once a Supabase project is attached, `ContentRepository` reads the live
/// tables first and only falls back here when they are empty.
class SeedContent {
  const SeedContent._();

  // ------------------------------------------------------------ topic pools

  /// Lecture topics keyed by faculty/school name. Departments inherit their
  /// faculty's pool and the topic is prefixed with the department name so the
  /// result stays specific.
  static const Map<String, List<String>> _facultyTopics =
      <String, List<String>>{
        'Faculty of Engineering & Technology': <String>[
          'Engineering Statics and Free-Body Diagrams',
          'Thermodynamics: First and Second Laws',
          'Fluid Mechanics — Bernoulli and Continuity',
          'Strength of Materials: Stress, Strain and Elasticity',
          'Engineering Drawing and Orthographic Projection',
          'Circuit Analysis: Kirchhoff’s Laws in Practice',
          'Control Systems and Feedback Fundamentals',
          'Workshop Practice and Safety Procedures',
          'Final Year Project: Choosing and Scoping a Topic',
          'SIWES Preparation and Logbook Standards',
        ],
        'Faculty of Science': <String>[
          'Laboratory Technique and Measurement Error',
          'Scientific Method and Experimental Design',
          'Data Handling, Graphs and Significant Figures',
          'Practical Report Writing for Science Students',
          'Instrumentation and Analytical Methods',
          'Research Seminar: Reading a Scientific Paper',
          'Field Work Methods and Sampling',
          'Statistics for Scientists',
        ],
        'Faculty of Computing & Information Technology': <String>[
          'Problem Solving with Algorithms and Flowcharts',
          'Programming Fundamentals: Variables to Functions',
          'Data Structures — Stacks, Queues and Trees',
          'Database Design and Normalisation',
          'Operating Systems: Processes and Scheduling',
          'Computer Networks and the OSI Model',
          'Software Engineering: Requirements to Deployment',
          'Cyber Security Essentials for Students',
          'Version Control with Git for Coursework',
          'Building Your First Portfolio Project',
        ],
        'Faculty of Basic Medical Sciences': <String>[
          'Cell Structure and Membrane Transport',
          'Histology: Reading Tissue Slides',
          'Metabolic Pathways Made Simple',
          'Neurophysiology: Action Potentials',
          'Cardiovascular Physiology Revision',
          'Practical Anatomy: Dissection Room Conduct',
        ],
        'Faculty of Clinical Sciences': <String>[
          'Clinical History Taking and Examination',
          'Interpreting Basic Investigations',
          'Ethics and Professionalism in Clinical Practice',
          'Common Presentations in the Nigerian Setting',
          'Ward Round Etiquette and Case Presentation',
        ],
        'Faculty of Allied Health Sciences': <String>[
          'Patient Communication and Consent',
          'Infection Prevention and Control',
          'Clinical Documentation Standards',
          'Community Health Practice in Nigeria',
          'Laboratory Quality Assurance',
        ],
        'Faculty of Pharmaceutical Sciences': <String>[
          'Pharmacokinetics: ADME Explained',
          'Dosage Forms and Formulation Basics',
          'Drug Interactions and Counselling Points',
          'Pharmacognosy: Nigerian Medicinal Plants',
          'Good Dispensing Practice',
        ],
        'Faculty of Agriculture': <String>[
          'Soil Fertility and Nutrient Management',
          'Crop Production Systems in Nigeria',
          'Animal Nutrition and Feed Formulation',
          'Farm Records and Agribusiness Planning',
          'Post-Harvest Handling and Storage',
          'Agricultural Extension Methods',
        ],
        'Faculty of Veterinary Medicine': <String>[
          'Comparative Animal Anatomy',
          'Livestock Disease Recognition',
          'Veterinary Public Health and Zoonoses',
          'Clinical Handling and Restraint',
        ],
        'Faculty of Environmental Sciences': <String>[
          'Design Studio: Concept to Presentation',
          'Building Materials and Construction Methods',
          'Measurement and Bills of Quantities',
          'Site Surveying and Levelling Practice',
          'Land Use Planning and Development Control',
          'Property Valuation Principles',
        ],
        'Faculty of Management Sciences': <String>[
          'Financial Accounting: Ledger to Final Accounts',
          'Cost and Management Accounting Basics',
          'Business Statistics and Decision Making',
          'Principles of Management and Organisation',
          'Marketing Fundamentals and the Nigerian Consumer',
          'Corporate Finance: Time Value of Money',
          'Business Communication and Report Writing',
        ],
        'Faculty of Social Sciences': <String>[
          'Research Methods in the Social Sciences',
          'Nigerian Government and Politics',
          'Introduction to Social Theory',
          'Quantitative Methods and SPSS Basics',
          'Development Studies in an African Context',
          'Writing a Sound Undergraduate Thesis',
        ],
        'Faculty of Communication & Media Studies': <String>[
          'News Writing and Reporting Skills',
          'Media Law and Ethics in Nigeria',
          'Broadcast Production Fundamentals',
          'Public Relations Campaign Planning',
          'Digital Media and Audience Analytics',
        ],
        'Faculty of Arts & Humanities': <String>[
          'Literary Criticism and Close Reading',
          'Essay Writing and Argument Construction',
          'Historiography and Source Analysis',
          'Introduction to Philosophy of Mind',
          'Language, Culture and Identity',
          'Research and Referencing in the Humanities',
        ],
        'Faculty of Law': <String>[
          'Nigerian Legal System and Court Hierarchy',
          'Law of Contract: Offer and Acceptance',
          'Constitutional Law: Fundamental Rights',
          'Criminal Law: Elements of an Offence',
          'Legal Research and Case Note Writing',
          'Moot Court Preparation',
        ],
        'Faculty of Education': <String>[
          'Lesson Planning and Instructional Objectives',
          'Classroom Management Strategies',
          'Test Construction and Item Analysis',
          'Educational Technology in the Classroom',
          'Teaching Practice: What Supervisors Look For',
          'Child Development for Teachers',
        ],
        'School of Engineering Technology': <String>[
          'Technical Drawing and Detailing',
          'Applied Mechanics for Technologists',
          'Electrical Installation Practice',
          'Machine Shop Operations',
          'ND Project Work: Scope and Standards',
          'Industrial Attachment Readiness',
        ],
        'School of Environmental Studies': <String>[
          'Construction Technology Practicals',
          'Taking Off Quantities from Drawings',
          'Survey Field Practice with Total Station',
          'Estate Records and Property Management',
        ],
        'School of Business & Management Studies': <String>[
          'Bookkeeping to Trial Balance',
          'Office Practice and Records Management',
          'Introduction to Entrepreneurship',
          'Business Law for Technologists',
          'Purchasing, Stores and Supply Practice',
        ],
        'School of Applied Sciences': <String>[
          'Laboratory Safety and Glassware Handling',
          'Volumetric and Gravimetric Analysis',
          'Food Analysis and Quality Control',
          'Public Health Inspection Practice',
        ],
        'School of Information & Communication Technology': <String>[
          'Computer Appreciation and Packages',
          'Web Design Fundamentals',
          'Networking Practicals: Cabling to Configuration',
          'Introduction to Programming in Python',
          'Database Practicals with SQL',
        ],
        'School of Art, Design & Printing Technology': <String>[
          'Drawing from Observation',
          'Colour Theory and Composition',
          'Studio Practice and Portfolio Building',
          'Printing Processes and Finishing',
        ],
        'School of Agricultural Technology': <String>[
          'Farm Practical: Nursery and Transplanting',
          'Livestock Housing and Management',
          'Fish Pond Construction and Management',
          'Agricultural Machinery Operation',
        ],
        'School of Liberal & General Studies': <String>[
          'Use of English and Communication Skills',
          'Citizenship Education',
          'Nigerian Peoples and Culture',
          'Hospitality Service Standards',
        ],
        'School of Education': <String>[
          'Principles and Practice of Education',
          'Micro-Teaching Preparation',
          'Guidance and Counselling in Schools',
          'Continuous Assessment Practice',
        ],
        'School of Early Childhood Care & Primary Education': <String>[
          'Play-Based Learning Methods',
          'Early Literacy and Numeracy',
          'Child Health, Safety and Nutrition',
          'Managing the Early Years Classroom',
        ],
        'School of Sciences': <String>[
          'Integrated Science Teaching Methods',
          'Practical Biology for NCE Students',
          'Mathematics Method and Problem Solving',
          'School Laboratory Organisation',
        ],
        'School of Languages': <String>[
          'Phonetics and Spoken English',
          'Grammar and Usage for Teachers',
          'Translation Practice',
          'Oral Literature and Performance',
        ],
        'School of Arts & Social Sciences': <String>[
          'Social Studies Method',
          'Map Reading and Fieldwork',
          'Religious Studies Method',
          'History Teaching Techniques',
        ],
        'School of Vocational & Technical Education': <String>[
          'Workshop Organisation and Safety',
          'Home Economics Practicals',
          'Business Education Method',
          'Technical Drawing for Teachers',
        ],
      };

  static const List<String> _fallbackTopics = <String>[
    'Course Introduction and Scheme of Work',
    'Core Concepts: A Guided Walkthrough',
    'Tutorial Class: Worked Examples',
    'Revision Session Before Examinations',
    'Continuous Assessment Briefing',
    'Past Question Walkthrough',
  ];

  static List<String> _topicsFor(String faculty) =>
      _facultyTopics[faculty] ?? _fallbackTopics;

  /// Deterministic pseudo-random index so a department always yields the same
  /// library between launches.
  static int _seedOf(String value) {
    int hash = 7;
    for (int i = 0; i < value.length; i++) {
      hash = (hash * 31 + value.codeUnitAt(i)) & 0x7FFFFFFF;
    }
    return hash;
  }

  static String _courseCode(String department, int index) {
    final String letters = department
        .replaceAll(RegExp(r'[^A-Za-z ]'), '')
        .split(RegExp(r'\s+'))
        .where((String w) => w.isNotEmpty)
        .map((String w) => w[0])
        .join()
        .toUpperCase();
    final String prefix = (letters.length >= 3
        ? letters.substring(0, 3)
        : letters.padRight(3, 'X'));
    final int number = 101 + (index * 12) % 400;
    return '$prefix $number';
  }

  // ------------------------------------------------------------ materials

  static const List<MaterialKind> _materialKinds = <MaterialKind>[
    MaterialKind.lectureNote,
    MaterialKind.pastQuestion,
    MaterialKind.handout,
    MaterialKind.slide,
    MaterialKind.textbook,
    MaterialKind.projectWork,
  ];

  static const List<String> _uploaders = <String>[
    'Chinedu O.',
    'Aisha B.',
    'Tobi A.',
    'Ngozi E.',
    'Musa I.',
    'Blessing U.',
    'Emeka D.',
    'Fatima S.',
  ];

  static List<StudyMaterial> materialsFor({
    required String faculty,
    required String department,
    required String level,
    required String institution,
  }) {
    final List<String> topics = _topicsFor(faculty);
    final int seed = _seedOf('$department|$faculty|mat');
    final DateTime now = DateTime.now();

    return List<StudyMaterial>.generate(topics.length, (int i) {
      final int roll = (seed + i * 53) & 0x7FFFFFFF;
      final MaterialKind kind = _materialKinds[roll % _materialKinds.length];
      final String code = _courseCode(department, i);
      return StudyMaterial(
        id: 'seed-mat-${_seedOf(department)}-$i',
        title: '$code — ${topics[i]} (${kind.label})',
        courseCode: code,
        department: department,
        faculty: faculty,
        institution: institution,
        level: level,
        fileUrl: '',
        fileName: '${code.replaceAll(' ', '_')}_${kind.name}.pdf',
        fileSizeBytes: 240000 + (roll % 3400000),
        uploadedBy: 'seed',
        uploaderName: _uploaders[roll % _uploaders.length],
        kind: kind,
        description:
            'Compiled for $department, $level. Covers ${topics[i].toLowerCase()} '
            'with worked examples and revision pointers.',
        downloads: 12 + (roll % 900),
        createdAt: now.subtract(Duration(days: 1 + (roll % 120))),
      );
    });
  }

  // ----------------------------------------------------------- community

  static List<CommunityPost> communityPosts() {
    final DateTime now = DateTime.now();
    return <CommunityPost>[
      CommunityPost(
        id: 'post-1',
        authorId: 'seed-1',
        authorName: 'Adaeze Nwankwo',
        authorHeadline: '400 Level · Mechanical Engineering · UNN',
        body:
            'Sharing what finally worked for me in Thermodynamics: stop reading '
            'the textbook cover to cover. Take one past question, work it '
            'slowly, and only read the section that the question touches. I '
            'went from a C to an A doing this for six weeks. Ask me anything.',
        topic: CommunityTopic.academics,
        createdAt: now.subtract(const Duration(hours: 3)),
        likes: 128,
        commentCount: 24,
        institution: 'University of Nigeria, Nsukka',
        department: 'Mechanical Engineering',
      ),
      CommunityPost(
        id: 'post-2',
        authorId: 'seed-2',
        authorName: 'Ibrahim Suleiman',
        authorHeadline: 'HND 1 · Computer Science · KADPOLY',
        body:
            'Has anyone here applied for the Agbami scholarship this cycle? I '
            'have my CGPA and documents ready but I am not sure whether HND '
            'students are eligible. Please share your experience if you have '
            'gone through it before.',
        topic: CommunityTopic.scholarships,
        createdAt: now.subtract(const Duration(hours: 7)),
        likes: 41,
        commentCount: 16,
        institution: 'Kaduna Polytechnic',
        department: 'Computer Science',
      ),
      CommunityPost(
        id: 'post-3',
        authorId: 'seed-3',
        authorName: 'Grace Effiong',
        authorHeadline: '200 Level · Nursing Science · UNICAL',
        body:
            'Anatomy revision group forming for the coming exams. We meet '
            'twice a week and cover one system per session. Everyone is '
            'welcome, whatever your current grades — we all started somewhere. '
            'Drop a comment and I will add you.',
        topic: CommunityTopic.examPrep,
        createdAt: now.subtract(const Duration(hours: 11)),
        likes: 89,
        commentCount: 31,
        institution: 'University of Calabar',
        department: 'Nursing Science',
      ),
      CommunityPost(
        id: 'post-4',
        authorId: 'seed-4',
        authorName: 'Tunde Bakare',
        authorHeadline: '500 Level · Architecture · FUTA',
        body:
            'For anyone doing design studio: back up your work in two places. '
            'I lost a full semester project to a corrupted drive in 300 level '
            'and had to rebuild it in eleven days. Learn from my mistake, '
            'please.',
        topic: CommunityTopic.campusLife,
        createdAt: now.subtract(const Duration(days: 1, hours: 2)),
        likes: 212,
        commentCount: 44,
        institution: 'Federal University of Technology, Akure',
        department: 'Architecture',
      ),
      CommunityPost(
        id: 'post-5',
        authorId: 'seed-5',
        authorName: 'Halima Yusuf',
        authorHeadline: 'NCE 2 · Integrated Science · FCE Zaria',
        body:
            'Teaching practice starts next month and I am genuinely nervous. '
            'Any advice from those who have already done theirs? Especially on '
            'lesson notes and managing a large class.',
        topic: CommunityTopic.academics,
        createdAt: now.subtract(const Duration(days: 1, hours: 6)),
        likes: 57,
        commentCount: 22,
        institution: 'Federal College of Education, Zaria',
        department: 'Integrated Science',
      ),
      CommunityPost(
        id: 'post-6',
        authorId: 'seed-6',
        authorName: 'Chukwuemeka Obi',
        authorHeadline: '300 Level · Accounting · UNILAG',
        body:
            'Landed a six-month internship at an audit firm through a cold '
            'email. Attached my CV, a short note on why that firm, and one '
            'thing I had learned about them. Three replies out of nine emails. '
            'It works — try it.',
        topic: CommunityTopic.careers,
        createdAt: now.subtract(const Duration(days: 2)),
        likes: 174,
        commentCount: 38,
        institution: 'University of Lagos',
        department: 'Accounting',
      ),
      CommunityPost(
        id: 'post-7',
        authorId: 'seed-7',
        authorName: 'Anonymous Student',
        authorHeadline: 'Wellbeing channel',
        body:
            'Carried over two courses this semester and I have been avoiding '
            'everyone. Just wanted to say it out loud somewhere. If you are in '
            'the same place, you are not alone and it is not the end of your '
            'story.',
        topic: CommunityTopic.wellbeing,
        createdAt: now.subtract(const Duration(days: 2, hours: 5)),
        likes: 396,
        commentCount: 87,
        institution: '',
        department: '',
      ),
      CommunityPost(
        id: 'post-8',
        authorId: 'seed-8',
        authorName: 'Ruth Danjuma',
        authorHeadline: 'ND 2 · Quantity Surveying · MAPOLY',
        body:
            'Uploaded my full taking-off notes to the materials library. It '
            'covers substructure through to finishes with worked examples. '
            'Search for QUS in your department library. Good luck, everyone.',
        topic: CommunityTopic.general,
        createdAt: now.subtract(const Duration(days: 3)),
        likes: 143,
        commentCount: 19,
        institution: 'Moshood Abiola Polytechnic, Abeokuta',
        department: 'Quantity Surveying',
      ),
    ];
  }

  static List<CommunityComment> commentsFor(String postId) {
    final DateTime now = DateTime.now();
    final Map<String, List<List<String>>> byPost = <String, List<List<String>>>{
      'post-1': <List<String>>[
        <String>['Kelechi A.', 'This is the exact advice I needed. Thank you.'],
        <String>[
          'Musa T.',
          'Which past questions did you use? Departmental or general?',
        ],
        <String>[
          'Adaeze Nwankwo',
          'Departmental ones first, then anything from a similar syllabus.',
        ],
      ],
      'post-2': <List<String>>[
        <String>[
          'Bola O.',
          'HND students were eligible in my year. Check the portal wording carefully.',
        ],
        <String>['Ibrahim Suleiman', 'Thank you, that helps a great deal.'],
      ],
      'post-3': <List<String>>[
        <String>['Peace I.', 'Please add me. I am in 200 level too.'],
        <String>['Samuel E.', 'Count me in. Which days do you meet?'],
        <String>[
          'Grace Effiong',
          'Tuesdays and Fridays, 6pm at the study hall.',
        ],
      ],
    };

    final List<List<String>> raw = byPost[postId] ?? <List<String>>[];
    return List<CommunityComment>.generate(raw.length, (int i) {
      return CommunityComment(
        id: '$postId-c$i',
        postId: postId,
        authorId: 'seed-c$i',
        authorName: raw[i][0],
        body: raw[i][1],
        createdAt: now.subtract(Duration(hours: raw.length - i)),
      );
    });
  }
}
