import 'dart:math';

import '../models/student_profile.dart';

/// A reply from Ada, the Eduvora assistant.
class AiReply {
  const AiReply({
    required this.message,
    this.suggestions = const <String>[],
    this.route,
    this.routeLabel,
  });

  final String message;

  /// Follow-up prompts offered as tappable chips.
  final List<String> suggestions;

  /// A named route the student can jump to straight from the reply.
  final String? route;
  final String? routeLabel;
}

class _Intent {
  const _Intent({required this.keywords, required this.build, this.weight = 1});

  /// Any of these appearing in the message counts as a hit.
  final List<String> keywords;
  final AiReply Function(StudentProfile? profile) build;
  final int weight;

  int score(String text) {
    int hits = 0;
    for (final String k in keywords) {
      if (text.contains(k)) hits += weight;
    }
    return hits;
  }
}

/// **Ada** — the Eduvora in-app guide.
///
/// Ada runs entirely on the device. She answers questions about finding your
/// way around Eduvora, and she responds kindly when a student is struggling,
/// because a study app that only ever talks about features is not much use at
/// two in the morning before a carry-over paper.
///
/// Everything Ada says is written in British English, in a warm and unhurried
/// register. She never diagnoses, never lectures, and always points to a real
/// next step inside the app.
class EduvoraAi {
  const EduvoraAi._();

  static const String assistantName = 'Ada';

  static const String greeting =
      'Hello, I am Ada — your Eduvora companion. 💙\n\nI can show you around the '
      'app, help you find materials for your department, explain how the CBT '
      'papers and GP calculator work, or simply keep you company while you '
      'revise. What would you like to do first?';

  static const List<String> starterPrompts = <String>[
    'How do I find materials for my department?',
    'How does the GP calculator work?',
    'Show me the CBT practice papers',
    'Where can I see scholarship news?',
    'I am feeling overwhelmed',
  ];

  static final Random _rng = Random();

  /// Produces Ada's reply to [rawMessage].
  static AiReply respond(String rawMessage, StudentProfile? profile) {
    final String text = rawMessage.toLowerCase().trim();
    if (text.isEmpty) {
      return const AiReply(
        message:
            'I am here whenever you are ready. Ask me anything about Eduvora, '
            'or just tell me how your day is going.',
        suggestions: starterPrompts,
      );
    }

    _Intent? best;
    int bestScore = 0;
    for (final _Intent intent in _intents) {
      final int s = intent.score(text);
      if (s > bestScore) {
        bestScore = s;
        best = intent;
      }
    }

    if (best == null || bestScore == 0) return _fallback(profile);
    return best.build(profile);
  }

  static String _name(StudentProfile? p) =>
      (p?.firstName.isNotEmpty ?? false) ? p!.firstName : 'friend';

  static AiReply _fallback(StudentProfile? profile) {
    final List<String> openings = <String>[
      'I want to be genuinely useful here, so let me check I have understood '
          'you.',
      'I may have missed your meaning — do bear with me.',
      'I am not certain I followed that one.',
    ];
    return AiReply(
      message:
          '${openings[_rng.nextInt(openings.length)]} I know Eduvora very well: '
          'academic videos, the materials library, CBT practice papers, the GP '
          'calculator, the community, chats and the noticeboard. I am also '
          'happy just to listen if the term is being hard on you, '
          '${_name(profile)}.\n\nCould you tell me a little more, or pick one '
          'of these?',
      suggestions: starterPrompts,
    );
  }

  // ------------------------------------------------------------- intents

  static final List<_Intent> _intents = <_Intent>[
    // ---------------------------------------------------------- greetings
    _Intent(
      keywords: <String>[
        'hello',
        'hi ',
        'hey',
        'good morning',
        'good afternoon',
        'good evening',
        'how are you',
        'good day',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Hello, ${_name(p)} — it is lovely to see you. 💙\n\nI am well, '
            'thank you for asking. More importantly, how are *you* doing '
            'today? And is there anything in Eduvora I can help you find?',
        suggestions: <String>[
          'Show me my department materials',
          'I want to practise a CBT paper',
          'Calculate my GPA',
        ],
      ),
    ),

    // ------------------------------------------------------------ comfort
    _Intent(
      weight: 2,
      keywords: <String>[
        'overwhelmed',
        'stressed',
        'stress',
        'anxious',
        'anxiety',
        'tired',
        'exhausted',
        'burnt out',
        'burnout',
        'depressed',
        'sad',
        'crying',
        'giving up',
        'give up',
        'cannot cope',
        "can't cope",
        'too much',
        'i am struggling',
        'struggling',
        'frustrated',
        'lonely',
        'afraid',
        'scared',
        'hopeless',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Thank you for telling me, ${_name(p)}. That took something, and I '
            'am glad you did. 💙\n\nWhat you are carrying is real, and feeling '
            'this way does not mean you are failing at being a student — it '
            'usually means you have been holding a great deal on your own for '
            'rather too long.\n\nMay I suggest something small? Not the whole '
            'semester. Just the next twenty minutes. Pick one topic, open one '
            'video or one set of notes, and let that be enough for now. I will '
            'be right here.\n\nAnd if the weight is heavier than study alone, '
            'please do speak to someone you trust — your student counselling '
            'unit is free, confidential, and used by far more of your '
            'coursemates than anyone admits. The Wellbeing channel in the '
            'community is a kind place too.',
        route: '/community',
        routeLabel: 'Open the Wellbeing channel',
        suggestions: <String>[
          'Help me plan a small study session',
          'Show me something light to revise',
          'I just needed to say it',
        ],
      ),
    ),
    _Intent(
      weight: 2,
      keywords: <String>[
        'failed',
        'failing',
        'carry over',
        'carryover',
        'carry-over',
        'spill',
        'probation',
        'withdrawn',
        'bad grade',
        'poor result',
        'low cgpa',
        'low gpa',
        'repeat',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'I am sorry, ${_name(p)}. A result like that stings, and it is '
            'perfectly reasonable to feel low about it for a while. 💙\n\nBut '
            'please hear this clearly: a carry-over is a course you have not '
            'passed *yet*. It is not a verdict on your intelligence, and it is '
            'very far from the end of your degree. A great many people who '
            'graduate well have one somewhere in their transcript.\n\nHere is '
            'what tends to help. Open the GP calculator and enter your actual '
            'figures — the unknown is almost always heavier than the number. '
            'Then find the past questions for that one course in the materials '
            'library and work through three of them slowly. One course, three '
            'questions. That is the whole plan for today.',
        route: '/gpa',
        routeLabel: 'Open the GP calculator',
        suggestions: <String>[
          'How does the GP calculator work?',
          'Find past questions for my department',
          'How do I improve my CGPA?',
        ],
      ),
    ),

    // ------------------------------------------------- groups & class lists
    _Intent(
      weight: 2,
      keywords: <String>[
        'class list',
        'classlist',
        'class register',
        'register of students',
        'attendance list',
        'download the list',
        'export the list',
        'course rep',
        'course representative',
        'class rep',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Class lists live on your home dashboard, ${_name(p)} — the orange '
            'tick icon labelled "Class lists".\n\nYou create one for your '
            'class, then add each student: full name, matric number, email, '
            'phone, and a short note if you need one. Eduvora numbers them as '
            'you go, so the order never gets muddled.\n\nTwo things make it '
            'worth doing once. First, leave "Create the group chat too" '
            'switched on and Eduvora sets up the group for that class straight '
            'away, with a join code you can paste into your class WhatsApp. '
            'Second, the list exports as a spreadsheet file whenever the '
            'department asks for one — no retyping at the end of the semester.',
        route: '/class-lists',
        routeLabel: 'Open Class lists',
        suggestions: <String>[
          'How do my classmates join the group?',
          'How do I export the class list?',
        ],
      ),
    ),
    _Intent(
      weight: 2,
      keywords: <String>[
        'group chat',
        'study group',
        'study groups',
        'join code',
        'group code',
        'create a group',
        'join a group',
        'classmates',
        'class group',
        'ask a question in the group',
        'discussion group',
        'admin',
        'group admin',
        'make someone admin',
        'change admin',
        'remove a member',
        'delete a message',
        'reply to a message',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Study groups are on your home dashboard, and also at the top of '
            'the Chats tab.\n\nTap "Study groups", then "New group" — give it a '
            'name like '
            '"${p?.department.isNotEmpty == true ? p!.department : 'Geology'} '
            '${p?.level.isNotEmpty == true ? p!.level : '300 Level'}" and '
            'Eduvora generates a six-character join code. Share that code and '
            'your classmates tap "Join with a code" to come in. No phone '
            'numbers change hands.\n\nInside the group, the thing I would use '
            'most is the question filter. When you are asking rather than '
            'chatting, tap "Mark as question" before you send. Anyone can then '
            'switch the group to questions only and read straight through what '
            'the class is stuck on — which, close to an exam, is worth a great '
            'deal.\n\nWhoever creates a group is its admin from the start. Tap '
            'the group name at the top to open Group info, where you can see '
            'every member, make somebody else an admin, or remove a member. '
            'Handing over matters when a course rep graduates and the group '
            'has to carry on without them. The person who created the group '
            'always keeps their rights, so a group cannot be taken from '
            'them.\n\nLong-press any message to reply to it, copy it, or '
            'delete it — admins can delete anybody\'s.',
        route: '/groups',
        routeLabel: 'Open Study groups',
        suggestions: <String>[
          'How do I create a class list?',
          'How do I make somebody an admin?',
        ],
      ),
    ),

    // ------------------------------------------------------------- videos
    _Intent(
      keywords: <String>[
        'video',
        'videos',
        'lecture',
        'lectures',
        'watch',
        'recording',
        'tutorial video',
        'play',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Academic Videos is on your home dashboard — the first card in the '
            'quick-access grid, or the play icon in the top row.\n\nThe feed is '
            'already filtered to '
            '${p?.department.isNotEmpty == true ? p!.department : 'your department'}'
            ', so what you see is what your course actually needs. You can '
            'narrow it further by course code using the search field at the '
            'top, and tapping any card opens the in-app player with speed '
            'controls.\n\nA gentle tip: watch a lecture once at normal speed, '
            'then attempt the tutorial questions before rewatching. Retrieval '
            'beats rewatching almost every time.',
        route: '/videos',
        routeLabel: 'Open Academic Videos',
        suggestions: <String>[
          'How do I find materials for my department?',
          'Show me the CBT practice papers',
        ],
      ),
    ),

    // ---------------------------------------------------------- materials
    _Intent(
      keywords: <String>[
        'material',
        'materials',
        'note',
        'notes',
        'handout',
        'past question',
        'past questions',
        'pq',
        'textbook',
        'pdf',
        'download',
        'library',
        'resource',
        'resources',
        'slide',
        'slides',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'The Materials library lives in the bottom navigation bar — the '
            'second tab, marked with the book icon.\n\nEverything there is '
            'filtered to '
            '${p?.department.isNotEmpty == true ? p!.department : 'your department'}'
            ' and your level. Use the chips along the top to switch between '
            'lecture notes, past questions, handouts, slides, textbooks and '
            'project work, and the search field to jump straight to a course '
            'code such as MEE 301.\n\nIf you have notes of your own, the orange '
            'button opens the upload sheet. Sharing them genuinely helps the '
            'person coming behind you.',
        route: '/materials',
        routeLabel: 'Open the Materials library',
        suggestions: <String>[
          'How do I upload my own notes?',
          'Show me academic videos',
        ],
      ),
    ),
    _Intent(
      keywords: <String>[
        'upload',
        'share my note',
        'share notes',
        'contribute',
        'post material',
        'add material',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Uploading takes about a minute, ${_name(p)}.\n\nGo to the '
            'Materials tab and tap the orange **Share a resource** button. You '
            'will be asked for a title, the course code, the type of resource '
            'and a short description, and then you can attach a file from your '
            'device.\n\nYour department and level are filled in from your '
            'profile automatically, so your coursemates will find it in exactly '
            'the right place. If the network is poor you can still publish the '
            'entry and attach the file later — nothing is lost.',
        route: '/upload',
        routeLabel: 'Share a resource',
        suggestions: <String>[
          'Where do my uploads appear?',
          'Show me the materials library',
        ],
      ),
    ),

    // ------------------------------------------------------ course outline
    _Intent(
      keywords: <String>[
        'course outline',
        'outline',
        'syllabus',
        'curriculum',
        'course list',
        'what courses',
        'courses i will',
        'course code',
        'credit unit',
        'registration',
        'what am i studying',
        'my courses',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Course Outline is on your home dashboard.\n\nIt shows the courses '
            'for '
            '${p?.department.isNotEmpty == true ? p!.department : 'your department'}'
            ' at '
            '${p?.institutionAbbreviation.isNotEmpty == true ? p!.institutionAbbreviation : 'your own institution'}'
            ', split into first and second semester, with credit units and '
            'the topics each course covers.\n\nOne thing worth knowing: it is '
            'filtered to **your school specifically**, because course codes '
            'and syllabi genuinely differ between institutions — UNILAG’s '
            'CSC 101 is not UNN’s CSC 101. There is a separate, clearly '
            'labelled section if you want to compare with other schools, but '
            'do revise from your own.\n\nIf a course is missing, please add '
            'it. The outline grows because students like you fill it in.',
        route: '/courses',
        routeLabel: 'Open Course Outline',
        suggestions: <String>[
          'How do I add a course?',
          'Find materials for my department',
        ],
      ),
    ),

    // ---------------------------------------------------------------- CBT
    _Intent(
      keywords: <String>[
        'cbt',
        'exam',
        'exams',
        'test',
        'quiz',
        'practice',
        'mock',
        'multiple choice',
        'mcq',
        'objective',
        'past paper',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'CBT Practice is on the home dashboard, and it works just like the '
            'real computer-based test.\n\nChoose a paper, and you will get a '
            'timed set of multiple-choice questions with a live countdown, a '
            'question grid so you can jump about freely, and a flag for items '
            'you want to revisit. Nothing is submitted until you press submit, '
            'and you may pause between papers as often as you like.\n\nAfter '
            'submission you get your score, your grade band and a full review '
            'showing the correct answer and an explanation for every question '
            '— that review is where most of the learning actually happens, so '
            'do read it.\n\nThe papers offered to you match '
            '${p?.faculty.isNotEmpty == true ? p!.faculty : 'your faculty'}, '
            'plus the general studies papers everybody sits.',
        route: '/cbt',
        routeLabel: 'Open CBT Practice',
        suggestions: <String>[
          'How is my CBT score calculated?',
          'Show me materials for revision',
        ],
      ),
    ),

    // ---------------------------------------------------------------- GPA
    _Intent(
      keywords: <String>[
        'gpa',
        'cgpa',
        'gp calculator',
        'gp',
        'grade point',
        'class of degree',
        'first class',
        'second class',
        'calculate my result',
        'classification',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'The GP calculator is on your home dashboard.\n\nAdd each course '
            'with its credit units and the grade you earned, and Eduvora '
            'applies the standard 5-point scale — A is 5, B is 4, C is 3, D is '
            '2, E is 1 and F is 0.\n\nYour GPA is the total of (credit units × '
            'grade value) divided by the total credit units. Save a semester '
            'and it joins your running CGPA, with your degree classification '
            'and a small trend chart so you can see the direction of travel.\n\n'
            'You can also use it to plan ahead: enter the grades you are '
            'aiming for next semester and see what they would do to your '
            'cumulative figure before you sit a single paper.',
        route: '/gpa',
        routeLabel: 'Open the GP calculator',
        suggestions: <String>[
          'What CGPA is a Second Class Upper?',
          'How do I improve my CGPA?',
        ],
      ),
    ),
    _Intent(
      keywords: <String>[
        'second class upper',
        '2:1',
        'what class',
        'degree class',
        'what cgpa do i need',
        'improve my cgpa',
        'improve my gpa',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'On the common Nigerian 5-point scale the bands are: First Class '
            'from 4.50, Second Class Upper from 3.50, Second Class Lower from '
            '2.40, Third Class from 1.50, and Pass below that.\n\nTo lift a '
            'cumulative figure, the arithmetic is quietly encouraging: heavy '
            'credit-unit courses move it most. Put your best effort into the '
            'three- and four-unit courses, and clear any outstanding '
            'carry-overs early, because a zero sits in the denominator '
            'indefinitely.\n\nOpen the GP calculator and try entering your '
            'target grades for next semester — seeing the projected number '
            'tends to make the plan feel possible.',
        route: '/gpa',
        routeLabel: 'Plan with the GP calculator',
        suggestions: <String>[
          'How does the GP calculator work?',
          'Find past questions for my courses',
        ],
      ),
    ),

    // --------------------------------------------------------- community
    _Intent(
      keywords: <String>[
        'community',
        'forum',
        'post',
        'discussion',
        'peers',
        'other students',
        'study group',
        'group',
        'ask a question',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'The Community tab is the third icon in the bottom bar.\n\nIt is '
            'organised into channels — General, Academics, Exam prep, '
            'Scholarships, Careers, Campus life and Wellbeing. Tap a channel '
            'chip to filter, tap a post to read the replies, and use the '
            'compose button to start your own thread.\n\nDo ask your question '
            'plainly, even if it feels basic. On a campus of thousands, at '
            'least a dozen people are wondering the same thing and are simply '
            'too shy to type it.',
        route: '/community',
        routeLabel: 'Open the Community',
        suggestions: <String>[
          'How do I message someone directly?',
          'Where are scholarship posts?',
        ],
      ),
    ),

    // -------------------------------------------------------------- chats
    _Intent(
      keywords: <String>[
        'chat',
        'chats',
        'message',
        'messages',
        'dm',
        'direct message',
        'talk to someone',
        'inbox',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Chats is the fourth tab in the bottom bar.\n\nYou will find your '
            'course study groups and one-to-one threads there — and me, pinned '
            'at the very top, whenever you want to talk something through.\n\n'
            'Open a thread, type at the bottom, and send. Study groups are '
            'created around your department and level, so the people in them '
            'are sitting the same papers you are.',
        route: '/chats',
        routeLabel: 'Open Chats',
        suggestions: <String>[
          'Show me the community',
          'How do I find my study group?',
        ],
      ),
    ),

    // --------------------------------------------------------------- news
    _Intent(
      keywords: <String>[
        'news',
        'scholarship',
        'scholarships',
        'bursary',
        'grant',
        'opportunity',
        'opportunities',
        'internship',
        'job',
        'noticeboard',
        'admission',
        'siwes',
        'nysc',
        'competition',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'The Noticeboard carries scholarships, admissions notices, '
            'internships, competitions and academic announcements. You will '
            'find it on the home dashboard, and the latest items also appear '
            'in the strip just under your greeting.\n\nUse the category chips '
            'to show scholarships only. Each entry shows how many days remain '
            'before it closes, and you can bookmark anything you intend to '
            'come back to.\n\nOne piece of practical advice, ${_name(p)}: scan '
            'your documents — result printout, admission letter, student '
            'identity card, passport photograph — into one folder now, before '
            'you need them. Most students miss deadlines on paperwork rather '
            'than merit.',
        route: '/news',
        routeLabel: 'Open the Noticeboard',
        suggestions: <String>[
          'Show me scholarships closing soon',
          'How do I bookmark an opportunity?',
        ],
      ),
    ),

    // ------------------------------------------------------------ profile
    _Intent(
      keywords: <String>[
        'profile',
        'my account',
        'change my department',
        'change department',
        'change level',
        'change my level',
        'wrong university',
        'edit profile',
        'change university',
        'change school',
        'settings',
        'faculty is wrong',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'That is easily fixed. Open the Profile tab — the last icon in the '
            'bottom bar — and tap **Edit academic details**.\n\nYou can change '
            'your institution, faculty, department and level there at any '
            'time. Every feed in Eduvora re-filters immediately afterwards, so '
            'your videos, materials and CBT papers will follow you across.\n\n'
            'This is worth doing the moment you move up a level, so your '
            'library stays relevant.',
        route: '/profile',
        routeLabel: 'Open my profile',
        suggestions: <String>[
          'How do I sign out?',
          'Where do my uploads appear?',
        ],
      ),
    ),
    _Intent(
      keywords: <String>[
        'sign out',
        'log out',
        'logout',
        'signout',
        'delete my account',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Signing out is at the bottom of the Profile tab. Your saved '
            'semesters, CBT history and bookmarks stay safely on this device, '
            'so signing back in picks up exactly where you left off.\n\nDo come '
            'back soon, ${_name(p)}. 💙',
        route: '/profile',
        routeLabel: 'Open my profile',
      ),
    ),

    // ------------------------------------------------------------- how-to
    _Intent(
      keywords: <String>[
        'how do i use',
        'how does this work',
        'what can you do',
        'help',
        'navigate',
        'get started',
        'guide',
        'tour',
        'what is eduvora',
        'features',
        'lost',
        'confused',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Of course, ${_name(p)} — here is the whole app in one breath.\n\n'
            '**Home** gathers everything: Academic Videos, CBT Practice, the '
            'GP Calculator, the Materials library, the Community, Chats and '
            'the Noticeboard.\n\n**The bottom bar** has five tabs — Home, '
            'Materials, Community, Chats and Profile.\n\n**Everything is '
            'filtered to you.** Your institution, faculty, department and level '
            'decide which videos, materials and CBT papers you are shown, so '
            'you are not wading through content meant for another course.\n\n'
            '**And I am always here.** Ask me where something lives, or how a '
            'feature works, or simply tell me how you are getting on.',
        suggestions: starterPrompts,
      ),
    ),
    _Intent(
      keywords: <String>[
        'offline',
        'no network',
        'no internet',
        'data',
        'campus mode',
        'without internet',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Eduvora is built for a Nigerian campus network, not a perfect '
            'one.\n\nYour profile, saved semesters, CBT attempts, bookmarks '
            'and anything you upload are all written to this device first, and '
            'synchronised when the connection returns. If you see **Campus '
            'Mode** on your profile, it simply means the app is running '
            'entirely on-device at present — every feature still works, and '
            'nothing you do will be lost.',
        suggestions: <String>[
          'How do I upload my own notes?',
          'Show me my department materials',
        ],
      ),
    ),

    // ------------------------------------------------------------- study
    _Intent(
      keywords: <String>[
        'study plan',
        'how to study',
        'revision',
        'revise',
        'read',
        'timetable',
        'schedule',
        'concentrate',
        'focus',
        'memorise',
        'cramming',
        'cram',
        'tips',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'Happily. Here is what actually works, stripped of the '
            'nonsense.\n\n**Test yourself before you feel ready.** Attempting '
            'questions you cannot yet answer feels awful and works far better '
            'than rereading notes that feel comfortable. That is exactly what '
            'the CBT papers are for.\n\n**Spread it out.** Four thirty-minute '
            'sittings across four days beat one desperate night, every '
            'time.\n\n**One course per sitting.** Switching topics mid-session '
            'costs you more than you think.\n\n**Explain it aloud.** If you '
            'cannot say it plainly, you have not got it yet — and your study '
            'group in Chats is the perfect audience.\n\nShall we start with a '
            'short CBT paper to find out where you actually stand?',
        route: '/cbt',
        routeLabel: 'Try a practice paper',
        suggestions: <String>[
          'Show me the CBT practice papers',
          'Find materials for my department',
        ],
      ),
    ),

    // -------------------------------------------------------------- about
    _Intent(
      keywords: <String>[
        'who made',
        'who built',
        'who created',
        'developer',
        'about the app',
        'who are you',
        'your name',
        'are you human',
        'are you real',
        'ai',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'I am Ada, the assistant built into Eduvora. I am not a person — I '
            'am a small guide living inside this app — but I do genuinely want '
            'things to go well for you.\n\nEduvora itself was built for '
            'students in Nigerian universities, polytechnics and colleges of '
            'education: one place for lectures, materials, CBT practice, your '
            'GPA, your coursemates and the opportunities worth chasing.\n\nWhat '
            'shall we look at together?',
        suggestions: starterPrompts,
      ),
    ),
    _Intent(
      keywords: <String>[
        'thank you',
        'thanks',
        'thank u',
        'appreciate',
        'well done',
        'nice one',
        'you are helpful',
      ],
      build: (StudentProfile? p) => AiReply(
        message:
            'You are very welcome, ${_name(p)}. 💙 It is genuinely my pleasure.'
            '\n\nGo steadily today — you are doing better than you think. I am '
            'here whenever you need me.',
        suggestions: starterPrompts,
      ),
    ),
    _Intent(
      keywords: <String>['bye', 'goodbye', 'see you', 'later', 'good night'],
      build: (StudentProfile? p) => AiReply(
        message:
            'Goodbye for now, ${_name(p)}. Rest properly when you can — it is '
            'part of the work, not a break from it. 💙\n\nI will be right here '
            'when you return.',
      ),
    ),
  ];
}
