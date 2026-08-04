import '../models/cbt.dart';

/// The bundled CBT bank.
///
/// Papers are tagged with the faculties they serve so a Law student is offered
/// the Nigerian Legal System paper while an Engineering student is offered
/// Engineering Mathematics. General studies papers are offered to everyone,
/// which mirrors how GST/GNS courses actually work on Nigerian campuses.
class CbtQuestionBank {
  const CbtQuestionBank._();

  static const List<CbtSubject> subjects = <CbtSubject>[
    // ------------------------------------------------------ General studies
    CbtSubject(
      id: 'gst-use-of-english',
      name: 'Use of English',
      description:
          'Grammar, vocabulary, comprehension and register — the GST paper '
          'every fresher must pass.',
      isGeneralStudies: true,
      minutesPerAttempt: 12,
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'eng-1',
          topic: 'Vocabulary',
          question: 'Choose the option nearest in meaning to **ubiquitous**.',
          options: <String>['Rare', 'Omnipresent', 'Ancient', 'Doubtful'],
          correctIndex: 1,
          explanation:
              'Ubiquitous means present everywhere at once, so omnipresent is '
              'the closest synonym.',
        ),
        CbtQuestion(
          id: 'eng-2',
          topic: 'Concord',
          question:
              'Neither the lecturer nor the students ______ arrived on time.',
          options: <String>['has', 'have', 'is', 'was'],
          correctIndex: 1,
          explanation:
              'With "neither … nor", the verb agrees with the nearer subject. '
              '"Students" is plural, so "have" is correct.',
        ),
        CbtQuestion(
          id: 'eng-3',
          topic: 'Plurals',
          question: 'The plural form of **criterion** is:',
          options: <String>['criterias', 'criterion', 'criteria', 'criterions'],
          correctIndex: 2,
          explanation:
              'Criterion is a Greek-derived singular; its plural is criteria.',
        ),
        CbtQuestion(
          id: 'eng-4',
          topic: 'Vocabulary',
          question: 'Choose the antonym of **meticulous**.',
          options: <String>['Careful', 'Slapdash', 'Thorough', 'Precise'],
          correctIndex: 1,
          explanation:
              'Meticulous means extremely careful about detail; slapdash means '
              'careless and hurried.',
        ),
        CbtQuestion(
          id: 'eng-5',
          topic: 'Prepositions',
          question: 'He was accused ______ stealing the departmental handout.',
          options: <String>['for', 'with', 'of', 'on'],
          correctIndex: 2,
          explanation: 'The fixed collocation is "accused of".',
        ),
        CbtQuestion(
          id: 'eng-6',
          topic: 'Figures of speech',
          question:
              'Identify the figure of speech: "The lecture hall was a zoo."',
          options: <String>[
            'Simile',
            'Metaphor',
            'Hyperbole',
            'Personification',
          ],
          correctIndex: 1,
          explanation:
              'The hall is called a zoo directly, without "like" or "as", so it '
              'is a metaphor.',
        ),
        CbtQuestion(
          id: 'eng-7',
          topic: 'Subjunctive',
          question: 'If I ______ you, I would begin revision much earlier.',
          options: <String>['am', 'was', 'were', 'will be'],
          correctIndex: 2,
          explanation:
              'The second conditional uses the subjunctive "were" for all '
              'persons.',
        ),
        CbtQuestion(
          id: 'eng-8',
          topic: 'Spelling',
          question: 'Choose the correctly spelt word.',
          options: <String>[
            'acommodation',
            'accomodation',
            'accommodation',
            'acomodation',
          ],
          correctIndex: 2,
          explanation: 'Accommodation carries a double "c" and a double "m".',
        ),
        CbtQuestion(
          id: 'eng-9',
          topic: 'Stress',
          question:
              'In the word **photograph**, the primary stress falls on the:',
          options: <String>[
            'first syllable',
            'second syllable',
            'third syllable',
            'fourth syllable',
          ],
          correctIndex: 0,
          explanation:
              'PHO-to-graph carries primary stress on the first syllable, '
              'unlike pho-TO-gra-phy.',
        ),
        CbtQuestion(
          id: 'eng-10',
          topic: 'Register',
          question:
              'The expression "the defendant was remanded in custody" belongs '
              'to the register of:',
          options: <String>['Medicine', 'Law', 'Banking', 'Agriculture'],
          correctIndex: 1,
          explanation:
              '"Defendant", "remanded" and "custody" are courtroom vocabulary.',
        ),
      ],
    ),
    CbtSubject(
      id: 'gst-nigerian-peoples',
      name: 'Nigerian Peoples & Culture',
      description:
          'History, geography, ethnicity and civic life — the compulsory GST '
          'paper across Nigerian institutions.',
      isGeneralStudies: true,
      minutesPerAttempt: 12,
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'npc-1',
          topic: 'Political structure',
          question:
              'How many states make up the Federal Republic of Nigeria?',
          options: <String>['30', '35', '36', '37'],
          correctIndex: 2,
          explanation:
              'Nigeria has 36 states plus the Federal Capital Territory, Abuja.',
        ),
        CbtQuestion(
          id: 'npc-2',
          topic: 'History',
          question: 'Nigeria attained independence from Britain in:',
          options: <String>['1957', '1960', '1963', '1966'],
          correctIndex: 1,
          explanation: 'Independence was granted on 1 October 1960.',
        ),
        CbtQuestion(
          id: 'npc-3',
          topic: 'History',
          question: 'Nigeria became a republic in:',
          options: <String>['1960', '1963', '1979', '1999'],
          correctIndex: 1,
          explanation:
              'The First Republic was proclaimed on 1 October 1963, with Nnamdi '
              'Azikiwe as President.',
        ),
        CbtQuestion(
          id: 'npc-4',
          topic: 'Ethnography',
          question: 'The three largest ethnic groups in Nigeria are:',
          options: <String>[
            'Hausa, Igbo and Yoruba',
            'Ijaw, Tiv and Efik',
            'Kanuri, Nupe and Idoma',
            'Urhobo, Itsekiri and Edo',
          ],
          correctIndex: 0,
          explanation:
              'Hausa-Fulani, Igbo and Yoruba together account for the majority '
              'of the population.',
        ),
        CbtQuestion(
          id: 'npc-5',
          topic: 'National symbols',
          question: 'The national motto of Nigeria is:',
          options: <String>[
            'Unity and Faith, Peace and Progress',
            'One Nation, One Destiny',
            'Peace and Unity',
            'Progress and Prosperity',
          ],
          correctIndex: 0,
          explanation:
              'It appears on the Coat of Arms adopted in 1960 and revised in '
              '1978.',
        ),
        CbtQuestion(
          id: 'npc-6',
          topic: 'Geography',
          question: 'Which two rivers dominate Nigerian geography?',
          options: <String>[
            'Nile and Congo',
            'Niger and Benue',
            'Volta and Gambia',
            'Zambezi and Limpopo',
          ],
          correctIndex: 1,
          explanation:
              'The Niger and Benue meet at Lokoja to form the Y-shaped confluence.',
        ),
        CbtQuestion(
          id: 'npc-7',
          topic: 'Archaeology',
          question: 'The Nok culture is best known for its:',
          options: <String>[
            'Bronze casting',
            'Terracotta sculpture',
            'Weaving',
            'Rock painting',
          ],
          correctIndex: 1,
          explanation:
              'Nok terracotta figurines, found in Kaduna State, date from about '
              '500 BC.',
        ),
        CbtQuestion(
          id: 'npc-8',
          topic: 'Civic institutions',
          question:
              'The National Youth Service Corps scheme was established in:',
          options: <String>['1970', '1973', '1980', '1985'],
          correctIndex: 1,
          explanation:
              'NYSC was created by decree in 1973 to promote national unity '
              'after the civil war.',
        ),
        CbtQuestion(
          id: 'npc-9',
          topic: 'Culture',
          question: 'Which of the following is a Nigerian cultural festival?',
          options: <String>['Diwali', 'Osun-Osogbo', 'Thanksgiving', 'Hanami'],
          correctIndex: 1,
          explanation:
              'The Osun-Osogbo festival in Osun State is a UNESCO World '
              'Heritage listed cultural event.',
        ),
        CbtQuestion(
          id: 'npc-10',
          topic: 'Governance',
          question:
              'The seat of the Federal Government formally moved to Abuja in:',
          options: <String>['1976', '1985', '1991', '1999'],
          correctIndex: 2,
          explanation:
              'The FCT was created in 1976, but the formal relocation from '
              'Lagos took place in December 1991.',
        ),
      ],
    ),
    CbtSubject(
      id: 'gst-entrepreneurship',
      name: 'Entrepreneurship Studies',
      description:
          'Venture creation, business planning and the Nigerian enterprise '
          'environment.',
      isGeneralStudies: true,
      minutesPerAttempt: 12,
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'ent-1',
          topic: 'Concepts',
          question: 'An entrepreneur is best described as a person who:',
          options: <String>[
            'Works strictly for a salary',
            'Identifies opportunities and bears risk to create value',
            'Audits company accounts',
            'Regulates market prices',
          ],
          correctIndex: 1,
          explanation:
              'Opportunity recognition plus risk-bearing is the defining pair '
              'of entrepreneurial traits.',
        ),
        CbtQuestion(
          id: 'ent-2',
          topic: 'Planning',
          question: 'The primary purpose of a business plan is to:',
          options: <String>[
            'Decorate the office',
            'Guide operations and attract funding',
            'Replace bookkeeping',
            'Settle tax liabilities',
          ],
          correctIndex: 1,
          explanation:
              'It is both an internal roadmap and an external document for '
              'investors and lenders.',
        ),
        CbtQuestion(
          id: 'ent-3',
          topic: 'Analysis',
          question: 'In strategic analysis, SWOT stands for:',
          options: <String>[
            'Strengths, Weaknesses, Opportunities, Threats',
            'Sales, Work, Operations, Trade',
            'Systems, Workflow, Output, Time',
            'Skills, Wages, Orders, Targets',
          ],
          correctIndex: 0,
          explanation:
              'Strengths and weaknesses are internal; opportunities and threats '
              'are external.',
        ),
        CbtQuestion(
          id: 'ent-4',
          topic: 'Regulation',
          question:
              'In Nigeria, businesses and companies are registered with the:',
          options: <String>[
            'Central Bank of Nigeria',
            'Corporate Affairs Commission',
            'Federal Inland Revenue Service',
            'Standards Organisation of Nigeria',
          ],
          correctIndex: 1,
          explanation:
              'The CAC administers the Companies and Allied Matters Act.',
        ),
        CbtQuestion(
          id: 'ent-5',
          topic: 'Finance',
          question: 'Seed capital refers to:',
          options: <String>[
            'Profit declared at year end',
            'The initial funding used to start a venture',
            'A bank overdraft',
            'Retained earnings',
          ],
          correctIndex: 1,
          explanation:
              'Seed capital covers the earliest stage, before revenue is '
              'established.',
        ),
        CbtQuestion(
          id: 'ent-6',
          topic: 'Marketing',
          question: 'A unique selling proposition is:',
          options: <String>[
            'Always having the lowest price',
            'What makes an offering distinctly valuable to customers',
            'A legal registration document',
            'A tax rebate',
          ],
          correctIndex: 1,
          explanation:
              'A USP is the specific benefit that competitors cannot easily '
              'claim.',
        ),
        CbtQuestion(
          id: 'ent-7',
          topic: 'Finance',
          question: 'Which of the following is a source of equity finance?',
          options: <String>[
            'Bank loan',
            'Angel investment',
            'Trade credit',
            'Debenture',
          ],
          correctIndex: 1,
          explanation:
              'Angel investors buy an ownership stake; the others create debt '
              'obligations.',
        ),
        CbtQuestion(
          id: 'ent-8',
          topic: 'Costing',
          question: 'The break-even point is reached when:',
          options: <String>[
            'Profit is at a maximum',
            'Total revenue equals total cost',
            'Costs fall to zero',
            'Sales reach their peak',
          ],
          correctIndex: 1,
          explanation:
              'At break-even, contribution exactly covers fixed costs and profit '
              'is nil.',
        ),
        CbtQuestion(
          id: 'ent-9',
          topic: 'Feasibility',
          question: 'A feasibility study is properly carried out:',
          options: <String>[
            'After the business has failed',
            'Before committing resources to a venture',
            'Only by government agencies',
            'During liquidation',
          ],
          correctIndex: 1,
          explanation:
              'It tests technical, financial and market viability before spend '
              'is committed.',
        ),
        CbtQuestion(
          id: 'ent-10',
          topic: 'Policy',
          question: 'In Nigerian enterprise policy, MSME stands for:',
          options: <String>[
            'Micro, Small and Medium Enterprises',
            'Modern Sales and Marketing Enterprise',
            'Ministry of Small and Medium Exports',
            'Managed Services for Medium Enterprises',
          ],
          correctIndex: 0,
          explanation:
              'SMEDAN classifies enterprises by employee count and asset base '
              'under this heading.',
        ),
      ],
    ),
    CbtSubject(
      id: 'gen-mathematics',
      name: 'General Mathematics',
      description:
          'Algebra, indices, statistics, calculus basics and number bases.',
      isGeneralStudies: true,
      minutesPerAttempt: 15,
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'mth-1',
          topic: 'Indices',
          question: 'Simplify 2³ × 2⁵.',
          options: <String>['2⁸', '2¹⁵', '4⁸', '2²'],
          correctIndex: 0,
          explanation: 'When multiplying like bases, add the indices: 3 + 5 = 8.',
        ),
        CbtQuestion(
          id: 'mth-2',
          topic: 'Linear equations',
          question: 'If 3x − 7 = 14, find x.',
          options: <String>['5', '7', '21', '3'],
          correctIndex: 1,
          explanation: '3x = 21, therefore x = 7.',
        ),
        CbtQuestion(
          id: 'mth-3',
          topic: 'Statistics',
          question: 'Find the mean of 4, 8, 10 and 14.',
          options: <String>['8', '9', '10', '12'],
          correctIndex: 1,
          explanation: 'The sum is 36 and there are 4 values, so the mean is 9.',
        ),
        CbtQuestion(
          id: 'mth-4',
          topic: 'Coordinate geometry',
          question:
              'What is the gradient of the line through (1, 2) and (3, 8)?',
          options: <String>['2', '3', '4', '6'],
          correctIndex: 1,
          explanation: 'Gradient = (8 − 2) ⁄ (3 − 1) = 6 ⁄ 2 = 3.',
        ),
        CbtQuestion(
          id: 'mth-5',
          topic: 'Logarithms',
          question: 'Evaluate log₁₀ 1000.',
          options: <String>['2', '3', '10', '100'],
          correctIndex: 1,
          explanation: '10³ = 1000, so the logarithm is 3.',
        ),
        CbtQuestion(
          id: 'mth-6',
          topic: 'Mensuration',
          question:
              'Find the area of a circle of radius 7 cm, taking π as 22⁄7.',
          options: <String>['44 cm²', '154 cm²', '22 cm²', '308 cm²'],
          correctIndex: 1,
          explanation: 'Area = πr² = 22⁄7 × 49 = 154 cm².',
        ),
        CbtQuestion(
          id: 'mth-7',
          topic: 'Probability',
          question:
              'What is the probability of obtaining an even number when a fair '
              'die is rolled once?',
          options: <String>['1⁄6', '1⁄3', '1⁄2', '2⁄3'],
          correctIndex: 2,
          explanation:
              'Three of the six faces (2, 4, 6) are even, giving 3⁄6 = 1⁄2.',
        ),
        CbtQuestion(
          id: 'mth-8',
          topic: 'Calculus',
          question: 'If y = 3x², find dy⁄dx.',
          options: <String>['3x', '6x', 'x³', '6x²'],
          correctIndex: 1,
          explanation: 'Differentiating, dy⁄dx = 2 × 3x²⁻¹ = 6x.',
        ),
        CbtQuestion(
          id: 'mth-9',
          topic: 'Algebra',
          question: 'Simplify (x² − 9) ⁄ (x − 3), where x ≠ 3.',
          options: <String>['x + 3', 'x − 3', 'x² + 3', '3'],
          correctIndex: 0,
          explanation:
              'x² − 9 is a difference of two squares: (x − 3)(x + 3). Cancelling '
              'leaves x + 3.',
        ),
        CbtQuestion(
          id: 'mth-10',
          topic: 'Number bases',
          question: 'Convert 101₂ to base ten.',
          options: <String>['3', '5', '7', '101'],
          correctIndex: 1,
          explanation: '(1 × 4) + (0 × 2) + (1 × 1) = 5.',
        ),
      ],
    ),

    // ---------------------------------------------------- Science & medicine
    CbtSubject(
      id: 'sci-physics',
      name: 'General Physics',
      description: 'Mechanics, electricity, waves and thermodynamics.',
      minutesPerAttempt: 15,
      faculties: <String>[
        'Faculty of Science',
        'Faculty of Engineering & Technology',
        'Faculty of Computing & Information Technology',
        'School of Engineering Technology',
        'School of Applied Sciences',
        'School of Sciences',
      ],
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'phy-1',
          topic: 'Units',
          question: 'The SI unit of force is the:',
          options: <String>['Joule', 'Newton', 'Watt', 'Pascal'],
          correctIndex: 1,
          explanation: 'One newton accelerates one kilogram at one metre per '
              'second squared.',
        ),
        CbtQuestion(
          id: 'phy-2',
          topic: 'Gravitation',
          question:
              'The acceleration due to gravity at the earth’s surface is '
              'approximately:',
          options: <String>[
            '9.8 m/s²',
            '8.9 m/s²',
            '10.8 m/s²',
            '6.7 m/s²',
          ],
          correctIndex: 0,
          explanation: 'The standard value is 9.81 m/s², usually rounded to 9.8.',
        ),
        CbtQuestion(
          id: 'phy-3',
          topic: 'Newton’s laws',
          question:
              'A body of mass 5 kg accelerates at 2 m/s². The resultant force is:',
          options: <String>['2.5 N', '7 N', '10 N', '3 N'],
          correctIndex: 2,
          explanation: 'F = ma = 5 × 2 = 10 N.',
        ),
        CbtQuestion(
          id: 'phy-4',
          topic: 'Vectors',
          question: 'Which of the following is a vector quantity?',
          options: <String>['Speed', 'Mass', 'Velocity', 'Energy'],
          correctIndex: 2,
          explanation: 'Velocity has both magnitude and direction; speed has '
              'magnitude only.',
        ),
        CbtQuestion(
          id: 'phy-5',
          topic: 'Electricity',
          question: 'Ohm’s law is correctly expressed as:',
          options: <String>['V = I⁄R', 'V = IR', 'V = R⁄I', 'V = I²R'],
          correctIndex: 1,
          explanation:
              'Potential difference equals current multiplied by resistance.',
        ),
        CbtQuestion(
          id: 'phy-6',
          topic: 'Electricity',
          question: 'The unit of electrical resistance is the:',
          options: <String>['Volt', 'Ampere', 'Ohm', 'Coulomb'],
          correctIndex: 2,
          explanation: 'One ohm is one volt per ampere.',
        ),
        CbtQuestion(
          id: 'phy-7',
          topic: 'Waves',
          question: 'Sound waves cannot travel through:',
          options: <String>['Solids', 'Liquids', 'Gases', 'A vacuum'],
          correctIndex: 3,
          explanation:
              'Sound is a mechanical wave and requires a material medium.',
        ),
        CbtQuestion(
          id: 'phy-8',
          topic: 'Work and energy',
          question: 'Work done is defined as:',
          options: <String>[
            'Force × distance moved in the direction of the force',
            'Force ⁄ distance',
            'Mass × acceleration',
            'Power × force',
          ],
          correctIndex: 0,
          explanation: 'Work is the scalar product of force and displacement.',
        ),
        CbtQuestion(
          id: 'phy-9',
          topic: 'Optics',
          question:
              'Which lens is used to correct short-sightedness (myopia)?',
          options: <String>['Convex', 'Concave', 'Cylindrical', 'Plane'],
          correctIndex: 1,
          explanation:
              'A diverging (concave) lens moves the focal point back onto the '
              'retina.',
        ),
        CbtQuestion(
          id: 'phy-10',
          topic: 'Thermodynamics',
          question:
              'The first law of thermodynamics is a statement of the '
              'conservation of:',
          options: <String>['Momentum', 'Charge', 'Energy', 'Mass'],
          correctIndex: 2,
          explanation:
              'Energy supplied as heat equals the change in internal energy plus '
              'work done.',
        ),
      ],
    ),
    CbtSubject(
      id: 'sci-chemistry',
      name: 'General Chemistry',
      description: 'Atomic structure, bonding, acids and bases, organic basics.',
      minutesPerAttempt: 15,
      faculties: <String>[
        'Faculty of Science',
        'Faculty of Engineering & Technology',
        'Faculty of Pharmaceutical Sciences',
        'Faculty of Basic Medical Sciences',
        'Faculty of Agriculture',
        'School of Applied Sciences',
        'School of Sciences',
      ],
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'chm-1',
          topic: 'Atomic structure',
          question: 'The atomic number of carbon is:',
          options: <String>['6', '12', '14', '8'],
          correctIndex: 0,
          explanation: 'Carbon has six protons; 12 is its common mass number.',
        ),
        CbtQuestion(
          id: 'chm-2',
          topic: 'Formulae',
          question: 'The chemical formula of common table salt is:',
          options: <String>['KCl', 'NaCl', 'CaCO₃', 'NaOH'],
          correctIndex: 1,
          explanation: 'Sodium chloride, an ionic compound of Na⁺ and Cl⁻.',
        ),
        CbtQuestion(
          id: 'chm-3',
          topic: 'Acids and bases',
          question: 'At 25 °C, a neutral aqueous solution has a pH of:',
          options: <String>['0', '7', '14', '1'],
          correctIndex: 1,
          explanation:
              'Pure water at 25 °C has equal H⁺ and OH⁻ concentrations, giving '
              'pH 7.',
        ),
        CbtQuestion(
          id: 'chm-4',
          topic: 'Periodic table',
          question: 'Which of the following is a noble gas?',
          options: <String>['Chlorine', 'Argon', 'Nitrogen', 'Oxygen'],
          correctIndex: 1,
          explanation: 'Argon sits in Group 0 with a complete octet.',
        ),
        CbtQuestion(
          id: 'chm-5',
          topic: 'The mole',
          question: 'Avogadro’s constant is approximately:',
          options: <String>[
            '6.02 × 10²³ mol⁻¹',
            '3.14 × 10⁸ mol⁻¹',
            '9.8 × 10³ mol⁻¹',
            '1.6 × 10⁻¹⁹ mol⁻¹',
          ],
          correctIndex: 0,
          explanation: 'It is the number of particles in one mole of substance.',
        ),
        CbtQuestion(
          id: 'chm-6',
          topic: 'Periodic table',
          question: 'Which element is an alkali metal?',
          options: <String>['Calcium', 'Sodium', 'Aluminium', 'Iron'],
          correctIndex: 1,
          explanation: 'Sodium is in Group 1; calcium is an alkaline earth metal.',
        ),
        CbtQuestion(
          id: 'chm-7',
          topic: 'Redox',
          question: 'Oxidation is best defined as the:',
          options: <String>[
            'Gain of electrons',
            'Loss of electrons',
            'Gain of protons',
            'Loss of neutrons',
          ],
          correctIndex: 1,
          explanation: 'Remember OIL RIG — Oxidation Is Loss of electrons.',
        ),
        CbtQuestion(
          id: 'chm-8',
          topic: 'Bonding',
          question: 'The bonding in a sodium chloride crystal is:',
          options: <String>['Covalent', 'Ionic', 'Metallic', 'Hydrogen'],
          correctIndex: 1,
          explanation:
              'Electrons transfer from sodium to chlorine, forming an ionic '
              'lattice.',
        ),
        CbtQuestion(
          id: 'chm-9',
          topic: 'Gas tests',
          question: 'Which gas turns limewater milky?',
          options: <String>[
            'Oxygen',
            'Hydrogen',
            'Carbon dioxide',
            'Nitrogen',
          ],
          correctIndex: 2,
          explanation:
              'CO₂ forms insoluble calcium carbonate with calcium hydroxide '
              'solution.',
        ),
        CbtQuestion(
          id: 'chm-10',
          topic: 'Organic chemistry',
          question: 'The general formula of the alkanes is:',
          options: <String>['CnH2n', 'CnH2n+2', 'CnH2n−2', 'CnHn'],
          correctIndex: 1,
          explanation:
              'Alkanes are saturated; alkenes are CnH2n and alkynes CnH2n−2.',
        ),
      ],
    ),
    CbtSubject(
      id: 'sci-biology',
      name: 'General Biology',
      description: 'Cell biology, plant and animal physiology, genetics.',
      minutesPerAttempt: 15,
      faculties: <String>[
        'Faculty of Science',
        'Faculty of Basic Medical Sciences',
        'Faculty of Allied Health Sciences',
        'Faculty of Agriculture',
        'Faculty of Veterinary Medicine',
        'Faculty of Pharmaceutical Sciences',
        'School of Applied Sciences',
        'School of Sciences',
        'School of Agricultural Technology',
      ],
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'bio-1',
          topic: 'Cell biology',
          question: 'The basic structural and functional unit of life is the:',
          options: <String>['Tissue', 'Cell', 'Organ', 'Organism'],
          correctIndex: 1,
          explanation: 'All living organisms are made of one or more cells.',
        ),
        CbtQuestion(
          id: 'bio-2',
          topic: 'Cell biology',
          question: 'Which organelle is described as the powerhouse of the cell?',
          options: <String>[
            'Nucleus',
            'Ribosome',
            'Mitochondrion',
            'Lysosome',
          ],
          correctIndex: 2,
          explanation: 'Aerobic respiration and ATP synthesis occur there.',
        ),
        CbtQuestion(
          id: 'bio-3',
          topic: 'Plant physiology',
          question: 'Photosynthesis takes place mainly in the:',
          options: <String>['Root', 'Stem', 'Leaf', 'Flower'],
          correctIndex: 2,
          explanation:
              'Leaf mesophyll cells contain the greatest density of chloroplasts.',
        ),
        CbtQuestion(
          id: 'bio-4',
          topic: 'Genetics',
          question: 'A normal human somatic cell contains how many pairs of '
              'chromosomes?',
          options: <String>['21', '22', '23', '46'],
          correctIndex: 2,
          explanation: '23 pairs, that is 46 chromosomes in total.',
        ),
        CbtQuestion(
          id: 'bio-5',
          topic: 'Haematology',
          question: 'Which blood group is regarded as the universal donor?',
          options: <String>['A positive', 'B positive', 'AB positive', 'O negative'],
          correctIndex: 3,
          explanation:
              'O negative red cells carry neither A, B nor Rh D antigens.',
        ),
        CbtQuestion(
          id: 'bio-6',
          topic: 'Endocrinology',
          question: 'Insulin is secreted by the:',
          options: <String>['Liver', 'Pancreas', 'Kidney', 'Spleen'],
          correctIndex: 1,
          explanation: 'Specifically by the beta cells of the islets of '
              'Langerhans.',
        ),
        CbtQuestion(
          id: 'bio-7',
          topic: 'Plant physiology',
          question: 'The loss of water vapour from the aerial parts of a plant '
              'is called:',
          options: <String>[
            'Respiration',
            'Transpiration',
            'Translocation',
            'Condensation',
          ],
          correctIndex: 1,
          explanation: 'It occurs mainly through the stomata.',
        ),
        CbtQuestion(
          id: 'bio-8',
          topic: 'Genetics',
          question: 'DNA stands for:',
          options: <String>[
            'Deoxyribonucleic acid',
            'Dinucleic acid',
            'Deoxyribose nitrate acid',
            'Dual nucleic acid',
          ],
          correctIndex: 0,
          explanation: 'It carries the hereditary information of the cell.',
        ),
        CbtQuestion(
          id: 'bio-9',
          topic: 'Excretion',
          question: 'Which of the following is NOT a function of the kidney?',
          options: <String>[
            'Filtering blood',
            'Osmoregulation',
            'Producing bile',
            'Excreting urea',
          ],
          correctIndex: 2,
          explanation: 'Bile is produced by the liver, not the kidney.',
        ),
        CbtQuestion(
          id: 'bio-10',
          topic: 'Parasitology',
          question: 'Malaria in humans is caused by a:',
          options: <String>['Virus', 'Bacterium', 'Protozoan', 'Fungus'],
          correctIndex: 2,
          explanation:
              'Plasmodium species, transmitted by the female Anopheles mosquito.',
        ),
      ],
    ),
    CbtSubject(
      id: 'med-anatomy-physiology',
      name: 'Human Anatomy & Physiology',
      description:
          'Systems of the human body — essential for medical, nursing and '
          'allied health students.',
      minutesPerAttempt: 15,
      faculties: <String>[
        'Faculty of Basic Medical Sciences',
        'Faculty of Clinical Sciences',
        'Faculty of Allied Health Sciences',
        'Faculty of Pharmaceutical Sciences',
        'Faculty of Veterinary Medicine',
        'School of Applied Sciences',
      ],
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'ana-1',
          topic: 'Skeletal system',
          question: 'How many bones are there in the adult human skeleton?',
          options: <String>['106', '206', '306', '406'],
          correctIndex: 1,
          explanation:
              'Infants are born with about 270 bones, many of which fuse to give '
              '206 in adulthood.',
        ),
        CbtQuestion(
          id: 'ana-2',
          topic: 'Integumentary system',
          question: 'The largest organ of the human body is the:',
          options: <String>['Liver', 'Skin', 'Lungs', 'Brain'],
          correctIndex: 1,
          explanation: 'The skin covers roughly 1.5–2 m² in an adult.',
        ),
        CbtQuestion(
          id: 'ana-3',
          topic: 'Cardiovascular system',
          question: 'The normal resting heart rate for a healthy adult is:',
          options: <String>[
            '20–40 beats per minute',
            '60–100 beats per minute',
            '120–150 beats per minute',
            '150–200 beats per minute',
          ],
          correctIndex: 1,
          explanation: 'Below 60 is bradycardia; above 100 is tachycardia.',
        ),
        CbtQuestion(
          id: 'ana-4',
          topic: 'Cardiovascular system',
          question: 'Which chamber of the heart pumps blood into the aorta?',
          options: <String>[
            'Right atrium',
            'Left atrium',
            'Right ventricle',
            'Left ventricle',
          ],
          correctIndex: 3,
          explanation:
              'The left ventricle drives systemic circulation and has the '
              'thickest wall.',
        ),
        CbtQuestion(
          id: 'ana-5',
          topic: 'Renal system',
          question: 'The functional unit of the kidney is the:',
          options: <String>['Alveolus', 'Neuron', 'Nephron', 'Villus'],
          correctIndex: 2,
          explanation: 'Each kidney contains around one million nephrons.',
        ),
        CbtQuestion(
          id: 'ana-6',
          topic: 'Respiratory system',
          question: 'Gaseous exchange in the lungs takes place in the:',
          options: <String>['Bronchi', 'Trachea', 'Alveoli', 'Pleura'],
          correctIndex: 2,
          explanation:
              'Alveolar walls are one cell thick and richly supplied with '
              'capillaries.',
        ),
        CbtQuestion(
          id: 'ana-7',
          topic: 'Nervous system',
          question:
              'Which part of the brain is chiefly responsible for balance and '
              'coordination?',
          options: <String>[
            'Cerebrum',
            'Cerebellum',
            'Medulla oblongata',
            'Hypothalamus',
          ],
          correctIndex: 1,
          explanation:
              'The cerebellum fine-tunes motor activity and maintains posture.',
        ),
        CbtQuestion(
          id: 'ana-8',
          topic: 'Endocrine system',
          question: 'Which hormone lowers blood glucose concentration?',
          options: <String>['Glucagon', 'Insulin', 'Cortisol', 'Adrenaline'],
          correctIndex: 1,
          explanation:
              'Insulin promotes cellular uptake of glucose and glycogen storage.',
        ),
        CbtQuestion(
          id: 'ana-9',
          topic: 'Haematology',
          question: 'In adults, red blood cells are produced mainly in the:',
          options: <String>['Liver', 'Spleen', 'Red bone marrow', 'Kidney'],
          correctIndex: 2,
          explanation:
              'Erythropoiesis occurs in red marrow, chiefly of flat bones.',
        ),
        CbtQuestion(
          id: 'ana-10',
          topic: 'Skeletal system',
          question: 'The longest bone in the human body is the:',
          options: <String>['Tibia', 'Humerus', 'Femur', 'Fibula'],
          correctIndex: 2,
          explanation:
              'The femur, or thigh bone, is also the strongest bone in the body.',
        ),
      ],
    ),

    // -------------------------------------------------- Engineering & computing
    CbtSubject(
      id: 'eng-mathematics',
      name: 'Engineering Mathematics',
      description:
          'Calculus, matrices, complex numbers, differential equations and '
          'transforms.',
      minutesPerAttempt: 18,
      faculties: <String>[
        'Faculty of Engineering & Technology',
        'Faculty of Computing & Information Technology',
        'Faculty of Science',
        'School of Engineering Technology',
        'School of Information & Communication Technology',
      ],
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'emt-1',
          topic: 'Differentiation',
          question: 'The derivative of sin x with respect to x is:',
          options: <String>['cos x', '−cos x', '−sin x', 'tan x'],
          correctIndex: 0,
          explanation: 'd(sin x)⁄dx = cos x.',
        ),
        CbtQuestion(
          id: 'emt-2',
          topic: 'Integration',
          question: 'Evaluate ∫ x dx.',
          options: <String>['x²⁄2 + C', 'x² + C', '1 + C', '2x + C'],
          correctIndex: 0,
          explanation:
              'Using the power rule, ∫xⁿ dx = xⁿ⁺¹⁄(n + 1) + C with n = 1.',
        ),
        CbtQuestion(
          id: 'emt-3',
          topic: 'Matrices',
          question:
              'The determinant of the 2 × 2 matrix [[a, b], [c, d]] is:',
          options: <String>['ad + bc', 'ad − bc', 'ab − cd', 'ac − bd'],
          correctIndex: 1,
          explanation:
              'Multiply the leading diagonal and subtract the other diagonal.',
        ),
        CbtQuestion(
          id: 'emt-4',
          topic: 'Transforms',
          question: 'The Laplace transform of the constant 1 is:',
          options: <String>['1⁄s', 's', '1⁄s²', 'eˢ'],
          correctIndex: 0,
          explanation: 'L{1} = ∫₀^∞ e⁻ˢᵗ dt = 1⁄s for s > 0.',
        ),
        CbtQuestion(
          id: 'emt-5',
          topic: 'Complex numbers',
          question: 'The value of i² is:',
          options: <String>['1', '−1', 'i', '0'],
          correctIndex: 1,
          explanation: 'By definition i = √−1, so i² = −1.',
        ),
        CbtQuestion(
          id: 'emt-6',
          topic: 'Differential equations',
          question: 'The general solution of dy⁄dx = ky is:',
          options: <String>[
            'y = kx + c',
            'y = Ae^{kx}',
            'y = k⁄x',
            'y = ln(kx)',
          ],
          correctIndex: 1,
          explanation:
              'Separating variables gives ln y = kx + c, hence y = Ae^{kx}.',
        ),
        CbtQuestion(
          id: 'emt-7',
          topic: 'Complex numbers',
          question: 'For z = x + iy, the modulus |z| equals:',
          options: <String>['x + y', '√(x² + y²)', 'x² + y²', 'x⁄y'],
          correctIndex: 1,
          explanation:
              'The modulus is the distance from the origin in the Argand plane.',
        ),
        CbtQuestion(
          id: 'emt-8',
          topic: 'Series',
          question: 'The Maclaurin series for eˣ begins:',
          options: <String>[
            '1 + x + x²⁄2! + …',
            'x − x³⁄3! + …',
            '1 − x²⁄2! + …',
            'x + x²⁄2 + …',
          ],
          correctIndex: 0,
          explanation: 'Every derivative of eˣ is eˣ, which equals 1 at x = 0.',
        ),
        CbtQuestion(
          id: 'emt-9',
          topic: 'Matrices',
          question: 'A square matrix is singular when its determinant is:',
          options: <String>['1', '0', 'Negative', 'Positive'],
          correctIndex: 1,
          explanation: 'A singular matrix has no inverse.',
        ),
        CbtQuestion(
          id: 'emt-10',
          topic: 'Vectors',
          question:
              'The scalar product of two mutually perpendicular vectors is:',
          options: <String>[
            '1',
            '0',
            'The product of their magnitudes',
            'Undefined',
          ],
          correctIndex: 1,
          explanation: 'a · b = |a||b| cos 90° = 0.',
        ),
      ],
    ),
    CbtSubject(
      id: 'cs-introduction',
      name: 'Introduction to Computer Science',
      description:
          'Hardware, software, data representation, algorithms and databases.',
      minutesPerAttempt: 15,
      faculties: <String>[
        'Faculty of Computing & Information Technology',
        'Faculty of Engineering & Technology',
        'Faculty of Science',
        'Faculty of Management Sciences',
        'School of Information & Communication Technology',
        'School of Business & Management Studies',
        'School of Sciences',
      ],
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'csc-1',
          topic: 'Hardware',
          question: 'CPU stands for:',
          options: <String>[
            'Central Processing Unit',
            'Computer Personal Unit',
            'Central Program Unit',
            'Control Processing Unit',
          ],
          correctIndex: 0,
          explanation:
              'The CPU fetches, decodes and executes instructions.',
        ),
        CbtQuestion(
          id: 'csc-2',
          topic: 'Software',
          question: 'Which of the following is system software?',
          options: <String>[
            'Microsoft Word',
            'An operating system',
            'Microsoft Excel',
            'Adobe Photoshop',
          ],
          correctIndex: 1,
          explanation:
              'System software manages hardware; the rest are application '
              'software.',
        ),
        CbtQuestion(
          id: 'csc-3',
          topic: 'Data representation',
          question: 'One kilobyte is conventionally equal to:',
          options: <String>['1000 bits', '1024 bytes', '1024 bits', '100 bytes'],
          correctIndex: 1,
          explanation: '2¹⁰ = 1024, the binary convention used in computing.',
        ),
        CbtQuestion(
          id: 'csc-4',
          topic: 'Number systems',
          question: 'The binary number system uses which digits?',
          options: <String>['0 to 9', '0 and 1', '0 to 7', '0 to F'],
          correctIndex: 1,
          explanation: 'Base two has exactly two symbols.',
        ),
        CbtQuestion(
          id: 'csc-5',
          topic: 'Memory',
          question: 'RAM is best described as:',
          options: <String>[
            'Permanent storage',
            'Volatile working memory',
            'An input device',
            'An output device',
          ],
          correctIndex: 1,
          explanation: 'Its contents are lost when power is removed.',
        ),
        CbtQuestion(
          id: 'csc-6',
          topic: 'Peripherals',
          question: 'Which of the following is an input device?',
          options: <String>['Monitor', 'Printer', 'Keyboard', 'Speaker'],
          correctIndex: 2,
          explanation: 'The other three present output to the user.',
        ),
        CbtQuestion(
          id: 'csc-7',
          topic: 'Web technology',
          question: 'HTML is used primarily to:',
          options: <String>[
            'Style web pages',
            'Structure the content of web pages',
            'Query databases',
            'Compile source code',
          ],
          correctIndex: 1,
          explanation: 'Styling is the job of CSS; HTML supplies structure.',
        ),
        CbtQuestion(
          id: 'csc-8',
          topic: 'Algorithms',
          question: 'An algorithm is:',
          options: <String>[
            'A programming language',
            'A finite step-by-step procedure for solving a problem',
            'A hardware component',
            'A type of file',
          ],
          correctIndex: 1,
          explanation:
              'It must be finite, unambiguous and produce a result.',
        ),
        CbtQuestion(
          id: 'csc-9',
          topic: 'Data structures',
          question: 'Which data structure operates on a Last-In-First-Out basis?',
          options: <String>['Queue', 'Stack', 'Array', 'Tree'],
          correctIndex: 1,
          explanation:
              'A stack pushes and pops from the same end; a queue is FIFO.',
        ),
        CbtQuestion(
          id: 'csc-10',
          topic: 'Databases',
          question: 'SQL is used mainly for:',
          options: <String>[
            'Page styling',
            'Managing and querying relational databases',
            'Animation',
            'Network cabling',
          ],
          correctIndex: 1,
          explanation: 'SQL stands for Structured Query Language.',
        ),
      ],
    ),

    // -------------------------------------------- Management & social sciences
    CbtSubject(
      id: 'mgt-accounting',
      name: 'Principles of Accounting',
      description:
          'Double entry, final accounts, concepts and conventions.',
      minutesPerAttempt: 15,
      faculties: <String>[
        'Faculty of Management Sciences',
        'Faculty of Social Sciences',
        'School of Business & Management Studies',
        'School of Vocational & Technical Education',
      ],
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'acc-1',
          topic: 'Fundamentals',
          question: 'The accounting equation is correctly stated as:',
          options: <String>[
            'Assets = Liabilities + Capital',
            'Assets = Liabilities − Capital',
            'Capital = Assets + Liabilities',
            'Liabilities = Assets + Capital',
          ],
          correctIndex: 0,
          explanation:
              'What the business owns equals what it owes plus the owner’s stake.',
        ),
        CbtQuestion(
          id: 'acc-2',
          topic: 'Double entry',
          question: 'Under double entry, every transaction affects:',
          options: <String>[
            'One account',
            'At least two accounts',
            'Exactly three accounts',
            'The cash book only',
          ],
          correctIndex: 1,
          explanation: 'Every debit has a corresponding credit of equal value.',
        ),
        CbtQuestion(
          id: 'acc-3',
          topic: 'Double entry',
          question: 'A debit entry increases:',
          options: <String>['Liabilities', 'Capital', 'Assets', 'Revenue'],
          correctIndex: 2,
          explanation:
              'Assets and expenses increase on the debit side; liabilities, '
              'capital and income increase on the credit side.',
        ),
        CbtQuestion(
          id: 'acc-4',
          topic: 'Classification',
          question: 'Which of the following is a current asset?',
          options: <String>[
            'Motor vehicle',
            'Inventory',
            'Building',
            'Goodwill',
          ],
          correctIndex: 1,
          explanation:
              'Inventory is expected to be converted to cash within one year.',
        ),
        CbtQuestion(
          id: 'acc-5',
          topic: 'Trial balance',
          question: 'A trial balance is prepared principally to:',
          options: <String>[
            'Show the profit for the year',
            'Test the arithmetical accuracy of the ledger',
            'List assets only',
            'Compute tax payable',
          ],
          correctIndex: 1,
          explanation:
              'It will not, however, reveal errors of principle or compensating '
              'errors.',
        ),
        CbtQuestion(
          id: 'acc-6',
          topic: 'Non-current assets',
          question: 'Depreciation is best described as:',
          options: <String>[
            'An increase in the value of an asset',
            'The systematic allocation of an asset’s cost over its useful life',
            'A current liability',
            'A cash payment to suppliers',
          ],
          correctIndex: 1,
          explanation:
              'It is an application of the matching concept, not a cash flow.',
        ),
        CbtQuestion(
          id: 'acc-7',
          topic: 'Final accounts',
          question: 'Gross profit is calculated as:',
          options: <String>[
            'Sales − Cost of sales',
            'Sales − All expenses',
            'Net profit + Tax',
            'Sales + Purchases',
          ],
          correctIndex: 0,
          explanation:
              'Operating expenses are then deducted from gross profit to give '
              'net profit.',
        ),
        CbtQuestion(
          id: 'acc-8',
          topic: 'Books of original entry',
          question: 'Credit sales are first recorded in the:',
          options: <String>[
            'Cash book',
            'Sales day book',
            'Purchases day book',
            'Journal proper',
          ],
          correctIndex: 1,
          explanation:
              'The sales day book lists invoices issued before posting to the '
              'ledger.',
        ),
        CbtQuestion(
          id: 'acc-9',
          topic: 'Concepts',
          question: 'The prudence concept requires that:',
          options: <String>[
            'Profits are anticipated in advance',
            'Losses are ignored until realised',
            'Losses are provided for as soon as they are foreseen',
            'Assets are deliberately overstated',
          ],
          correctIndex: 2,
          explanation:
              'Prudence guards against overstating profit or asset values.',
        ),
        CbtQuestion(
          id: 'acc-10',
          topic: 'Financial statements',
          question: 'A statement of financial position shows the position:',
          options: <String>[
            'Over a period of time',
            'At a single point in time',
            'For the coming year',
            'Of cash movements only',
          ],
          correctIndex: 1,
          explanation:
              'It is a snapshot at the reporting date; the income statement '
              'covers a period.',
        ),
      ],
    ),
    CbtSubject(
      id: 'soc-economics',
      name: 'Principles of Economics',
      description:
          'Scarcity, demand and supply, macroeconomic aggregates and the '
          'Nigerian policy setting.',
      minutesPerAttempt: 15,
      faculties: <String>[
        'Faculty of Social Sciences',
        'Faculty of Management Sciences',
        'Faculty of Education',
        'School of Business & Management Studies',
        'School of Arts & Social Sciences',
      ],
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'eco-1',
          topic: 'Definitions',
          question: 'Economics is best defined as the study of:',
          options: <String>[
            'Money and banking',
            'The allocation of scarce resources among competing wants',
            'Government budgeting',
            'International trade only',
          ],
          correctIndex: 1,
          explanation: 'Scarcity and choice sit at the centre of the discipline.',
        ),
        CbtQuestion(
          id: 'eco-2',
          topic: 'Opportunity cost',
          question: 'Opportunity cost is:',
          options: <String>[
            'The money actually spent',
            'The value of the next best alternative forgone',
            'Total cost of production',
            'Fixed cost only',
          ],
          correctIndex: 1,
          explanation:
              'It measures the real sacrifice made when a choice is taken.',
        ),
        CbtQuestion(
          id: 'eco-3',
          topic: 'Demand',
          question:
              'The law of demand states that, other things being equal, as '
              'price rises:',
          options: <String>[
            'Quantity demanded rises',
            'Quantity demanded falls',
            'Supply falls',
            'Demand remains unchanged',
          ],
          correctIndex: 1,
          explanation: 'The demand curve therefore slopes downwards.',
        ),
        CbtQuestion(
          id: 'eco-4',
          topic: 'Elasticity',
          question: 'A normal good has an income elasticity of demand that is:',
          options: <String>['Negative', 'Zero', 'Positive', 'Infinite'],
          correctIndex: 2,
          explanation:
              'Demand for a normal good rises as consumer income rises.',
        ),
        CbtQuestion(
          id: 'eco-5',
          topic: 'Measurement',
          question: 'Which index measures changes in the general price level?',
          options: <String>[
            'Gross Domestic Product',
            'The Consumer Price Index',
            'The balance of trade',
            'The exchange rate',
          ],
          correctIndex: 1,
          explanation:
              'The CPI tracks a representative basket of household goods.',
        ),
        CbtQuestion(
          id: 'eco-6',
          topic: 'Macroeconomics',
          question: 'Inflation refers to:',
          options: <String>[
            'A once-off fall in prices',
            'A persistent rise in the general price level',
            'An increase in unemployment',
            'Rising national output',
          ],
          correctIndex: 1,
          explanation:
              'Persistence is what distinguishes inflation from a single price '
              'change.',
        ),
        CbtQuestion(
          id: 'eco-7',
          topic: 'Nigerian policy',
          question: 'Monetary policy in Nigeria is conducted by the:',
          options: <String>[
            'Nigeria Deposit Insurance Corporation',
            'Central Bank of Nigeria',
            'Federal Ministry of Finance',
            'Nigerian Exchange Group',
          ],
          correctIndex: 1,
          explanation:
              'The CBN sets the Monetary Policy Rate through its MPC.',
        ),
        CbtQuestion(
          id: 'eco-8',
          topic: 'Market structures',
          question: 'A market served by a single seller is a:',
          options: <String>[
            'Perfectly competitive market',
            'Oligopoly',
            'Monopoly',
            'Duopoly',
          ],
          correctIndex: 2,
          explanation:
              'A monopolist is a price maker facing the whole market demand '
              'curve.',
        ),
        CbtQuestion(
          id: 'eco-9',
          topic: 'National income',
          question: 'Gross Domestic Product measures the:',
          options: <String>[
            'Total value of final goods and services produced within a country '
                'in a period',
            'Total value of exports',
            'Total government expenditure',
            'National savings',
          ],
          correctIndex: 0,
          explanation:
              'Only final output is counted, to avoid double counting.',
        ),
        CbtQuestion(
          id: 'eco-10',
          topic: 'Market equilibrium',
          question:
              'Where quantity demanded exceeds quantity supplied, price tends '
              'to:',
          options: <String>['Fall', 'Rise', 'Remain constant', 'Become zero'],
          correctIndex: 1,
          explanation:
              'Excess demand bids the price up towards equilibrium.',
        ),
      ],
    ),
    CbtSubject(
      id: 'law-nigerian-legal-system',
      name: 'Nigerian Legal System',
      description:
          'Sources of law, court hierarchy, precedent and constitutional '
          'fundamentals.',
      minutesPerAttempt: 15,
      faculties: <String>[
        'Faculty of Law',
        'Faculty of Social Sciences',
        'Faculty of Management Sciences',
        'School of Business & Management Studies',
        'School of Arts & Social Sciences',
      ],
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'law-1',
          topic: 'Constitution',
          question: 'The Constitution currently in force in Nigeria is that of:',
          options: <String>['1979', '1989', '1999 (as amended)', '1963'],
          correctIndex: 2,
          explanation:
              'The 1999 Constitution has been altered several times, most '
              'notably from 2010 onwards.',
        ),
        CbtQuestion(
          id: 'law-2',
          topic: 'Court hierarchy',
          question: 'The highest court in Nigeria is the:',
          options: <String>[
            'Court of Appeal',
            'Federal High Court',
            'Supreme Court',
            'National Industrial Court',
          ],
          correctIndex: 2,
          explanation:
              'Its decisions bind every other court in the federation.',
        ),
        CbtQuestion(
          id: 'law-3',
          topic: 'Precedent',
          question: 'The doctrine of judicial precedent is also known as:',
          options: <String>[
            'Ratio legis',
            'Stare decisis',
            'Obiter dictum',
            'Res judicata',
          ],
          correctIndex: 1,
          explanation:
              '"Stare decisis et non quieta movere" — stand by decided matters.',
        ),
        CbtQuestion(
          id: 'law-4',
          topic: 'Sources of law',
          question: 'Which of the following is NOT a source of Nigerian law?',
          options: <String>[
            'Received English law',
            'Customary law',
            'Islamic law',
            'Foreign newspaper reports',
          ],
          correctIndex: 3,
          explanation:
              'The recognised sources are the Constitution, legislation, English '
              'law, customary law, Islamic law and judicial precedent.',
        ),
        CbtQuestion(
          id: 'law-5',
          topic: 'Separation of powers',
          question: 'The federal legislative arm in Nigeria is the:',
          options: <String>[
            'National Assembly',
            'Federal Executive Council',
            'Council of State',
            'National Judicial Council',
          ],
          correctIndex: 0,
          explanation:
              'It comprises the Senate and the House of Representatives.',
        ),
        CbtQuestion(
          id: 'law-6',
          topic: 'Precedent',
          question: 'An obiter dictum is:',
          options: <String>[
            'The binding reason for a decision',
            'A statement made in passing that is persuasive but not binding',
            'A dissenting judgment',
            'An order of the court',
          ],
          correctIndex: 1,
          explanation:
              'Only the ratio decidendi binds later courts.',
        ),
        CbtQuestion(
          id: 'law-7',
          topic: 'Legal traditions',
          question: 'Nigeria primarily operates within which legal tradition?',
          options: <String>[
            'Civil law',
            'Common law',
            'Socialist law',
            'Canon law',
          ],
          correctIndex: 1,
          explanation: 'This follows from the colonial reception of English law.',
        ),
        CbtQuestion(
          id: 'law-8',
          topic: 'Fundamental rights',
          question:
              'Fundamental human rights are guaranteed in which chapter of the '
              '1999 Constitution?',
          options: <String>[
            'Chapter II',
            'Chapter IV',
            'Chapter VI',
            'Chapter VIII',
          ],
          correctIndex: 1,
          explanation:
              'Chapter II contains the non-justiciable Fundamental Objectives; '
              'Chapter IV contains enforceable rights.',
        ),
        CbtQuestion(
          id: 'law-9',
          topic: 'Civil procedure',
          question:
              'Under most modern Nigerian civil procedure rules, a plaintiff is '
              'now referred to as the:',
          options: <String>['Accused', 'Claimant', 'Respondent', 'Appellant'],
          correctIndex: 1,
          explanation:
              'Reformed High Court rules adopted "claimant" and "defendant".',
        ),
        CbtQuestion(
          id: 'law-10',
          topic: 'Legal profession',
          question:
              'Which body is responsible for the call to the Nigerian Bar?',
          options: <String>[
            'Nigerian Bar Association',
            'Body of Benchers',
            'National Judicial Council',
            'Council of Legal Education',
          ],
          correctIndex: 1,
          explanation:
              'The Council of Legal Education runs the Law School; the Body of '
              'Benchers performs the call.',
        ),
      ],
    ),
    CbtSubject(
      id: 'edu-psychology',
      name: 'Educational Psychology',
      description:
          'Learning theories, developmental stages, motivation and assessment.',
      minutesPerAttempt: 15,
      faculties: <String>[
        'Faculty of Education',
        'Faculty of Social Sciences',
        'School of Education',
        'School of Early Childhood Care & Primary Education',
        'School of Vocational & Technical Education',
        'School of Arts & Social Sciences',
      ],
      questions: <CbtQuestion>[
        CbtQuestion(
          id: 'psy-1',
          topic: 'Cognitive development',
          question: 'Jean Piaget is best known for his theory of:',
          options: <String>[
            'Operant conditioning',
            'Cognitive development',
            'Psychosocial development',
            'Social learning',
          ],
          correctIndex: 1,
          explanation:
              'Piaget described four stages through which children’s thinking '
              'matures.',
        ),
        CbtQuestion(
          id: 'psy-2',
          topic: 'Cognitive development',
          question:
              'In Piaget’s theory, the stage covering roughly ages 7 to 11 is '
              'the:',
          options: <String>[
            'Sensorimotor stage',
            'Preoperational stage',
            'Concrete operational stage',
            'Formal operational stage',
          ],
          correctIndex: 2,
          explanation:
              'Children can reason logically about concrete objects but not yet '
              'abstractly.',
        ),
        CbtQuestion(
          id: 'psy-3',
          topic: 'Behaviourism',
          question: 'Operant conditioning is chiefly associated with:',
          options: <String>[
            'Ivan Pavlov',
            'B. F. Skinner',
            'Sigmund Freud',
            'Albert Bandura',
          ],
          correctIndex: 1,
          explanation:
              'Skinner showed that consequences shape the frequency of behaviour.',
        ),
        CbtQuestion(
          id: 'psy-4',
          topic: 'Behaviourism',
          question: 'Classical conditioning was first demonstrated by:',
          options: <String>[
            'B. F. Skinner',
            'Ivan Pavlov',
            'Edward Thorndike',
            'Abraham Maslow',
          ],
          correctIndex: 1,
          explanation:
              'Pavlov paired a bell with food and produced salivation to the '
              'bell alone.',
        ),
        CbtQuestion(
          id: 'psy-5',
          topic: 'Motivation',
          question: 'The highest need in Maslow’s hierarchy is:',
          options: <String>[
            'Safety',
            'Esteem',
            'Self-actualisation',
            'Love and belonging',
          ],
          correctIndex: 2,
          explanation:
              'Self-actualisation is the realisation of one’s full potential.',
        ),
        CbtQuestion(
          id: 'psy-6',
          topic: 'Social learning',
          question: 'Bandura’s social learning theory emphasises learning by:',
          options: <String>[
            'Reinforcement alone',
            'Observation and modelling',
            'Biological maturation',
            'Punishment alone',
          ],
          correctIndex: 1,
          explanation:
              'The Bobo doll studies showed children imitating observed '
              'behaviour.',
        ),
        CbtQuestion(
          id: 'psy-7',
          topic: 'Psychosocial development',
          question:
              'In Erikson’s theory, the central conflict of adolescence is:',
          options: <String>[
            'Trust versus mistrust',
            'Identity versus role confusion',
            'Intimacy versus isolation',
            'Autonomy versus shame and doubt',
          ],
          correctIndex: 1,
          explanation:
              'Adolescents work to form a coherent sense of self.',
        ),
        CbtQuestion(
          id: 'psy-8',
          topic: 'Assessment',
          question: 'Formative assessment is used mainly to:',
          options: <String>[
            'Award final grades',
            'Monitor learning and give feedback during instruction',
            'Rank schools nationally',
            'Certify graduating students',
          ],
          correctIndex: 1,
          explanation:
              'Summative assessment, by contrast, judges attainment at the end.',
        ),
        CbtQuestion(
          id: 'psy-9',
          topic: 'Measurement',
          question:
              'The intelligence quotient was originally computed using the '
              'formula:',
          options: <String>[
            'Mental age ⁄ Chronological age × 100',
            'Chronological age ⁄ Mental age × 100',
            'Mental age + Chronological age',
            'Mental age × Chronological age',
          ],
          correctIndex: 0,
          explanation:
              'This is the ratio IQ introduced by Stern and used by Terman.',
        ),
        CbtQuestion(
          id: 'psy-10',
          topic: 'Motivation',
          question: 'Motivation arising from within the learner is described as:',
          options: <String>['Extrinsic', 'Intrinsic', 'Negative', 'Social'],
          correctIndex: 1,
          explanation:
              'Intrinsic motivation comes from interest and satisfaction in the '
              'task itself.',
        ),
      ],
    ),
  ];

  /// Papers relevant to a student's faculty, general studies first.
  static List<CbtSubject> forFaculty(String faculty) {
    final List<CbtSubject> relevant = subjects
        .where((CbtSubject s) => s.isRelevantTo(faculty))
        .toList();
    relevant.sort((CbtSubject a, CbtSubject b) {
      if (a.isGeneralStudies != b.isGeneralStudies) {
        return a.isGeneralStudies ? -1 : 1;
      }
      return a.name.compareTo(b.name);
    });
    return relevant;
  }

  static CbtSubject? byId(String id) {
    for (final CbtSubject s in subjects) {
      if (s.id == id) return s;
    }
    return null;
  }

  static int get totalQuestions =>
      subjects.fold(0, (int sum, CbtSubject s) => sum + s.questions.length);
}
