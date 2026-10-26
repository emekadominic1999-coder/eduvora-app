// FRE 101 (Elementary French I) - hand-set questions on the standard first-semester French syllabus: greetings, the alphabet,
// subject pronouns, être and avoir, articles, gender and number, numbers, days and months, nationalities, regular -er verbs,
// negation, questions, adjectives, possessives, family, time, prepositions, aller and faire.
// Written from the standard course content, not from a particular textbook.
const L = require('../sta/lib');
const { add, out } = L;
const T = {
  gre: 'Greetings and Polite Expressions', alp: 'The French Alphabet and Pronunciation', pro: 'Subject Pronouns', etr: 'The Verb être', avo: 'The Verb avoir',
  art: 'Articles', gen: 'Gender of Nouns', plu: 'Plural of Nouns', num: 'Numbers', dat: 'Days, Months and Seasons', nat: 'Countries and Nationalities',
  erv: 'Regular -er Verbs', neg: 'Negation', que: 'Asking Questions', adj: 'Adjectives', pos: 'Possessive Adjectives', fam: 'The Family', tim: 'Telling the Time',
  pre: 'Prepositions and Contractions', all: 'The Verbs aller and faire', voc: 'Everyday Vocabulary', cul: 'The French-Speaking World', col: 'Colours',
};

// ---------------------------------------------------------------- greetings
add('Which expression means "Good morning" or "Hello" during the day?', 'Bonjour', ['Bonsoir', 'Bonne nuit', 'Au revoir'], 'Bonjour is used from morning until evening to greet someone.', T.gre);
add('Which expression is used to greet someone in the evening?', 'Bonsoir', ['Bonjour', 'Salut', 'À demain'], 'Bonsoir means "good evening".', T.gre);
add('"Au revoir" means:', 'Goodbye', ['Hello', 'Thank you', 'Please'], 'It is the standard way to say goodbye.', T.gre);
add('"Merci beaucoup" means:', 'Thank you very much', ['Excuse me', 'You are welcome', 'See you tomorrow'], '"Beaucoup" means "a lot" or "very much".', T.gre);
add('The correct reply to "Merci" is:', 'De rien', ['S\'il vous plaît', 'Bonsoir', 'Enchanté'], '"De rien" means "you are welcome".', T.gre);
add('"S\'il vous plaît" means:', 'Please', ['Sorry', 'Thank you', 'Good night'], 'It is the polite form used with "vous".', T.gre);
add('How do you say "Excuse me" or "Sorry" in French?', 'Excusez-moi / Pardon', ['Merci / De rien', 'Bonjour / Bonsoir', 'Bienvenue / Salut'], 'Both Pardon and Excusez-moi are used to apologise or to get attention.', T.gre);
add('Which question means "How are you?" (polite form)?', 'Comment allez-vous ?', ['Comment vous appelez-vous ?', 'Où habitez-vous ?', 'Quel âge avez-vous ?'], 'Aller is used for health: comment allez-vous ?', T.gre);
add('"Je m\'appelle Ada" means:', 'My name is Ada', ['I live in Ada', 'I like Ada', 'I am from Ada'], 'The verb s\'appeler means "to be called".', T.gre);
add('The question "Comment vous appelez-vous ?" asks:', 'What is your name?', ['How are you?', 'Where do you live?', 'How old are you?'], 'It is the polite form of "What is your name?".', T.gre);
add('Which phrase means "Nice to meet you"?', 'Enchanté', ['Excusez-moi', 'À bientôt', 'Bon appétit'], 'A woman can write enchantée.', T.gre);
add('"À demain" means:', 'See you tomorrow', ['See you later', 'Good night', 'Welcome'], 'Demain means "tomorrow".', T.gre);
add('"Bonne nuit" is said:', 'Before going to bed', ['When arriving in the morning', 'At lunch time', 'When meeting someone'], 'It means "good night".', T.gre);
add('"Salut" is:', 'An informal word for "hi" or "bye"', ['A formal word meaning "thank you"', 'A word meaning "please"', 'A word meaning "sorry"'], 'Use it with friends, not with a lecturer.', T.gre);
add('"Je vais bien, merci. Et vous ?" means:', 'I am fine, thank you. And you?', ['I am sick, thank you. And you?', 'I am going home. And you?', 'I have a book. And you?'], 'The verb aller is used here for health: "je vais bien".', T.gre);

// ---------------------------------------------------------------- alphabet and pronunciation
add('How many letters are in the French alphabet?', '26', ['24', '28', '30'], 'It uses the same 26 letters as English.', T.alp);
add('The accent in "é" is called:', 'Accent aigu', ['Accent grave', 'Accent circonflexe', 'Tréma'], 'The acute accent slopes up to the right.', T.alp);
add('The accent in "è" is called:', 'Accent grave', ['Accent aigu', 'Accent circonflexe', 'Cédille'], 'The grave accent slopes down to the right.', T.alp);
add('The accent in "ê" is called:', 'Accent circonflexe', ['Accent aigu', 'Accent grave', 'Tréma'], 'It has the shape of a small hat: ^.', T.alp);
add('The mark under the letter "ç" is called:', 'La cédille', ['Le tréma', 'L\'apostrophe', 'Le trait d\'union'], 'It makes the c sound like "s" before a, o and u, as in garçon.', T.alp);
add('The mark in "Noël" over the e is called:', 'Le tréma', ['La cédille', 'L\'accent grave', 'L\'apostrophe'], 'It tells you to pronounce the vowels separately.', T.alp);
add('The final consonant of most French words, such as the "t" in "petit", is usually:', 'Silent', ['Doubled', 'Always stressed', 'Pronounced as "k"'], 'Final consonants are generally not pronounced, apart from c, r, f and l (the word CaReFuL).', T.alp);
add('The letter "h" in French words like "hôtel" is:', 'Silent', ['Pronounced as in English "hat"', 'Pronounced as "sh"', 'Pronounced as "k"'], 'The French h is never pronounced.', T.alp);
add('The word "chat" (cat) begins with the sound:', '"sh"', ['"k"', '"ch" as in "church"', '"s"'], 'The letters ch are usually pronounced like English "sh" in French.', T.alp);
add('The letters "ou" in "vous" are pronounced like:', '"oo" as in "food"', ['"ow" as in "cow"', '"o" as in "go"', '"u" as in "cut"'], 'The sound is the same as in "tout" and "nous".', T.alp);
add('Liaison in French means:', 'Linking a silent final consonant to the vowel of the next word', ['Dropping all vowels', 'Adding a silent letter to the end of every word', 'Doubling the next consonant'], 'For example "vous avez" is pronounced vou-z-avez.', T.alp);
add('Elision is shown in "l\'école" because:', 'Le drops its vowel before a word beginning with a vowel', ['The noun is plural', 'The noun is feminine', 'The noun is a name'], 'Le and la become l\' before a vowel or a silent h.', T.alp);

// ---------------------------------------------------------------- subject pronouns
add('"Nous" means:', 'We', ['You (plural)', 'They', 'I'], 'It is the first person plural.', T.pro);
add('The pronoun for "you" when speaking to a friend or a child is:', 'Tu', ['Vous', 'Il', 'Elle'], 'Tu is informal and singular.', T.pro);
add('The pronoun used to speak politely to one person, or to speak to several people, is:', 'Vous', ['Tu', 'Nous', 'Ils'], 'Vous is both the polite singular and the plural "you".', T.pro);
add('"Ils" is used to replace:', 'A group of boys or a mixed group', ['A group of girls only', 'One boy', 'One girl'], 'A group with at least one male is ils; a group of only females is elles.', T.pro);
add('Which pronoun replaces "Marie et Anne"?', 'Elles', ['Ils', 'Elle', 'Nous'], 'Two females are replaced by elles.', T.pro);
add('Which pronoun replaces "Paul et Marie"?', 'Ils', ['Elles', 'Elle', 'Vous'], 'A mixed group takes the masculine plural.', T.pro);
add('The pronoun "on" is often used in everyday French to mean:', 'We, or people in general', ['They (only females)', 'I', 'You (formal)'], 'On takes the same verb form as il or elle.', T.pro);
add('"Je" becomes "j\'" in:', 'J\'habite à Lagos', ['Je mange du riz', 'Je parle français', 'Je regarde la télé'], 'Je is shortened before a vowel or a silent h: j\'habite.', T.pro);

// ---------------------------------------------------------------- être
add('The correct form of être in "Nous ___ étudiants" is:', 'sommes', ['êtes', 'sont', 'suis'], 'Nous sommes = we are.', T.etr);
add('The correct form of être in "Vous ___ professeur" is:', 'êtes', ['sommes', 'est', 'sont'], 'Vous êtes = you are.', T.etr);
add('The correct form of être in "Je ___ nigérian" is:', 'suis', ['es', 'est', 'sommes'], 'Je suis = I am.', T.etr);
add('The correct form of être in "Ils ___ à la maison" is:', 'sont', ['est', 'êtes', 'sommes'], 'Ils sont = they are.', T.etr);
add('The correct form of être in "Tu ___ fatigué" is:', 'es', ['est', 'suis', 'sont'], 'Tu es = you are.', T.etr);
add('"Elle est médecin" means:', 'She is a doctor', ['She has a doctor', 'She sees a doctor', 'She was a doctor'], 'After être, a profession is used without an article.', T.etr);
add('Which sentence is correct?', 'Il est étudiant', ['Il a étudiant', 'Il suis étudiant', 'Il êtes étudiant'], 'The subject il takes est.', T.etr);
add('The verb être means:', 'To be', ['To have', 'To go', 'To do'], 'It is the most important irregular verb in French.', T.etr);
add('"Nous ne sommes pas à l\'université" means:', 'We are not at the university', ['We are at the university', 'We were not at the university', 'We have no university'], 'Ne … pas surrounds the verb.', T.etr);

// ---------------------------------------------------------------- avoir
add('The correct form of avoir in "J\'___ un livre" is:', 'ai', ['as', 'a', 'ont'], 'J\'ai = I have.', T.avo);
add('The correct form of avoir in "Tu ___ un stylo" is:', 'as', ['ai', 'a', 'avez'], 'Tu as = you have.', T.avo);
add('The correct form of avoir in "Nous ___ deux sœurs" is:', 'avons', ['avez', 'ont', 'a'], 'Nous avons = we have.', T.avo);
add('The correct form of avoir in "Vous ___ une voiture" is:', 'avez', ['avons', 'ont', 'as'], 'Vous avez = you have.', T.avo);
add('The correct form of avoir in "Ils ___ un chien" is:', 'ont', ['a', 'avons', 'as'], 'Ils ont = they have.', T.avo);
add('French uses avoir (not être) to say your age. "J\'ai vingt ans" means:', 'I am twenty years old', ['I have twenty friends', 'I was twenty', 'I will be twenty'], 'Literally "I have twenty years".', T.avo);
add('"Elle a faim" means:', 'She is hungry', ['She is full', 'She is angry', 'She is cold'], 'Avoir faim = to be hungry.', T.avo);
add('"Nous avons froid" means:', 'We are cold', ['We are hot', 'We are afraid', 'We are tired'], 'Avoir froid = to be cold.', T.avo);
add('"Avoir chaud" means:', 'To be hot', ['To be cold', 'To be hungry', 'To be thirsty'], 'The weather and body sensations are expressed with avoir.', T.avo);
add('"Il a soif" means:', 'He is thirsty', ['He is hungry', 'He is sleepy', 'He is late'], 'Avoir soif = to be thirsty.', T.avo);

// ---------------------------------------------------------------- articles
add('The definite article used before a feminine singular noun is:', 'La', ['Le', 'Les', 'Un'], 'La is feminine singular: la table.', T.art);
add('The definite article used before a plural noun is:', 'Les', ['Le', 'La', 'L\''], 'Les is used for both genders: les livres, les tables.', T.art);
add('Which indefinite article is correct for "maison" (house, feminine)?', 'Une', ['Un', 'Des', 'Le'], 'Une maison.', T.art);
add('Which indefinite article is correct for "stylo" (pen, masculine)?', 'Un', ['Une', 'Des', 'La'], 'Un stylo.', T.art);
add('The plural indefinite article ("some") is:', 'Des', ['Un', 'Une', 'Le'], 'Des étudiants = some students.', T.art);
add('The correct article in "___ étudiante" (the student, female) is:', 'L\'', ['Le', 'La', 'Les'], 'Before a vowel, le and la become l\'.', T.art);
add('In "Je mange ___ pain", the partitive article is:', 'du', ['de la', 'des', 'de l\''], 'Du is used with masculine nouns for an unspecified quantity: du pain.', T.art);
add('In "Elle boit ___ eau", the partitive article is:', 'de l\'', ['du', 'de la', 'des'], 'Before a vowel the partitive is de l\': de l\'eau.', T.art);
add('In "Nous mangeons ___ viande", the partitive article is:', 'de la', ['du', 'des', 'de l\''], 'La viande is feminine, so de la viande.', T.art);
add('After a negative, the partitive du, de la and des change to:', 'de (d\')', ['le', 'la', 'les'], 'Je n\'ai pas de pain; il n\'y a pas d\'eau.', T.art);
add('Which sentence is correct?', 'Je n\'ai pas de stylo', ['Je n\'ai pas un stylo', 'Je n\'ai pas du stylo', 'Je n\'ai pas le stylo'], 'Un, une and des become de after a negative.', T.art);
add('"Le" and "la" are:', 'Definite articles', ['Indefinite articles', 'Partitive articles', 'Subject pronouns'], 'They correspond to English "the".', T.art);

// ---------------------------------------------------------------- gender
add('Which noun is masculine?', 'Le livre', ['La table', 'La porte', 'La chaise'], 'Livre (book) is masculine.', T.gen);
add('Which noun is feminine?', 'La fenêtre', ['Le crayon', 'Le cahier', 'Le tableau'], 'Fenêtre (window) is feminine.', T.gen);
add('Most nouns ending in -tion, such as "la nation", are:', 'Feminine', ['Masculine', 'Always plural', 'Neither masculine nor feminine'], 'La nation, la station, la question.', T.gen);
add('Most nouns ending in -ment, such as "le gouvernement", are:', 'Masculine', ['Feminine', 'Plural only', 'Invariable adjectives'], 'Le gouvernement, le logement, le moment.', T.gen);
add('The feminine form of "un étudiant" is:', 'Une étudiante', ['Un étudiante', 'Une étudiant', 'Des étudiantes'], 'Add -e for the feminine.', T.gen);
add('The feminine form of "un acteur" is:', 'Une actrice', ['Une acteure', 'Une acteuse', 'Un actrice'], 'Nouns in -teur often become -trice.', T.gen);
add('The feminine form of "un boulanger" is:', 'Une boulangère', ['Une boulangeure', 'Une boulangeuse', 'Une boulanger'], 'Nouns in -er change to -ère.', T.gen);
add('Which noun keeps the same form for the masculine and the feminine?', 'Un/une élève', ['Un/une boulanger', 'Un/une chanteur', 'Un/une étudiant'], 'Élève (pupil) is the same in both genders.', T.gen);
add('Which word is feminine?', 'La voiture', ['Le train', 'Le bureau', 'Le stylo'], 'La voiture (car) is feminine.', T.gen);

// ---------------------------------------------------------------- plural
add('The plural of "un livre" is:', 'Des livres', ['Des livre', 'Un livres', 'Les livre'], 'Most plurals add -s.', T.plu);
add('The plural of "un cheval" (horse) is:', 'Des chevaux', ['Des chevals', 'Des chevales', 'Des chevaus'], 'Nouns ending in -al change to -aux.', T.plu);
add('The plural of "un journal" (newspaper) is:', 'Des journaux', ['Des journals', 'Des journales', 'Des journeaux'], 'Journal → journaux.', T.plu);
add('The plural of "un bateau" (boat) is:', 'Des bateaux', ['Des bateaus', 'Des bateau', 'Des batteaux'], 'Nouns ending in -eau add -x.', T.plu);
add('The plural of "le nez" (nose) is:', 'Les nez', ['Les nezs', 'Les nezes', 'Les neux'], 'Nouns ending in -s, -x or -z stay the same in the plural.', T.plu);
add('The plural of "un pays" (country) is:', 'Des pays', ['Des payss', 'Des païs', 'Des paies'], 'It ends in -s so it does not change.', T.plu);
add('The plural of "le travail" (work) is:', 'Les travaux', ['Les travails', 'Les travaus', 'Les travales'], 'Nouns ending in -ail often change to -aux in the plural, as in travail → travaux.', T.plu);
add('The plural of "l\'œil" (eye) is:', 'Les yeux', ['Les œils', 'Les œux', 'Les yeus'], 'It is an irregular plural.', T.plu);
add('Which pair is correct?', 'Un monsieur / des messieurs', ['Un monsieur / des monsieurs', 'Un monsieur / des mesieur', 'Un monsieur / des monsieur'], 'Monsieur and madame have irregular plurals: messieurs and mesdames.', T.plu);

// ---------------------------------------------------------------- numbers
add('"Quinze" is the number:', '15', ['5', '50', '14'], 'Quinze = 15.', T.num);
add('"Dix-sept" is the number:', '17', ['7', '70', '10'], 'Dix + sept.', T.num);
add('"Soixante" is the number:', '60', ['16', '6', '66'], 'Soixante = 60.', T.num);
add('"Soixante-dix" means:', '70', ['17', '60', '90'], 'French uses 60 + 10.', T.num);
add('"Quatre-vingts" means:', '80', ['40', '24', '90'], 'It literally means 4 × 20.', T.num);
add('"Quatre-vingt-dix" means:', '90', ['94', '19', '40'], 'It literally means 4 × 20 + 10.', T.num);
add('The French for 21 is:', 'Vingt et un', ['Vingt-un', 'Deux-vingt', 'Un-vingt'], 'Vingt et un uses "et" for 21.', T.num);
add('The French for 100 is:', 'Cent', ['Mille', 'Dix', 'Cinq cents'], 'Cent = 100.', T.num);
add('The French for 1000 is:', 'Mille', ['Cent', 'Million', 'Dix mille'], 'Mille = 1000, and it never takes an -s.', T.num);
add('3 + 4 = 7. Which is the right way to write it in French?', 'Trois plus quatre font sept', ['Trois et quatre font neuf', 'Trois plus quatre font six', 'Trois moins quatre font sept'], 'Plus means "plus" and sept means 7.', T.num);
add('"Douze" is the number:', '12', ['2', '20', '22'], 'Douze = 12.', T.num);
add('"Quarante-deux" is the number:', '42', ['24', '40', '14'], 'Quarante = 40, deux = 2.', T.num);
add('"Premier" and "deuxième" are:', 'Ordinal numbers', ['Cardinal numbers', 'Fractions', 'Days of the week'], 'They show order: first and second.', T.num);

// ---------------------------------------------------------------- days, months, seasons
add('The first day of the French week (as shown on French calendars) is:', 'Lundi', ['Dimanche', 'Mardi', 'Samedi'], 'Calendars start with lundi.', T.dat);
add('"Mercredi" is:', 'Wednesday', ['Tuesday', 'Thursday', 'Friday'], 'Mercredi = Wednesday.', T.dat);
add('"Vendredi" is:', 'Friday', ['Thursday', 'Saturday', 'Monday'], 'Vendredi = Friday.', T.dat);
add('"Dimanche" is:', 'Sunday', ['Saturday', 'Monday', 'Thursday'], 'Dimanche = Sunday.', T.dat);
add('"Janvier" is the month of:', 'January', ['June', 'July', 'August'], 'Janvier = January.', T.dat);
add('"Septembre" is:', 'September', ['October', 'November', 'December'], 'Septembre = September.', T.dat);
add('"Juin" and "juillet" are:', 'June and July', ['July and June', 'March and May', 'August and September'], 'Juin = June; juillet = July.', T.dat);
add('"Mars" is:', 'March', ['May', 'April', 'August'], 'Mars = March.', T.dat);
add('"L\'été" is the season:', 'Summer', ['Spring', 'Autumn', 'Winter'], 'L\'été = summer.', T.dat);
add('"L\'hiver" is the season:', 'Winter', ['Summer', 'Spring', 'Autumn'], 'L\'hiver = winter.', T.dat);
add('"Le printemps" is the season:', 'Spring', ['Autumn', 'Winter', 'Summer'], 'Le printemps = spring.', T.dat);
add('"L\'automne" is the season:', 'Autumn', ['Summer', 'Spring', 'Winter'], 'L\'automne = autumn.', T.dat);
add('In French, the names of the days and months are written:', 'With a small letter', ['With a capital letter', 'With all capitals', 'Never in writing'], 'Lundi, mardi, janvier and février begin with a lower-case letter.', T.dat);
add('How do you ask "What day is it today?"', 'Quel jour sommes-nous aujourd\'hui ?', ['Quelle heure est-il ?', 'Quel âge avez-vous ?', 'Où habitez-vous ?'], 'Aujourd\'hui means "today".', T.dat);

// ---------------------------------------------------------------- countries and nationalities
add('"Je suis nigérian" is said by:', 'A man from Nigeria', ['A woman from Nigeria', 'A man from Niger', 'A woman from Niger'], 'The masculine adjective is nigérian; a woman says nigériane.', T.nat);
add('A woman from France says:', 'Je suis française', ['Je suis français', 'Je suis francaise', 'Je suis françaises'], 'The feminine of français is française.', T.nat);
add('"Elle est américaine" means:', 'She is American', ['She lives in America', 'She likes America', 'She has an American friend'], 'Américain becomes américaine in the feminine.', T.nat);
add('The French for "Nigeria" is:', 'Le Nigéria', ['La Nigéria', 'Le Niger', 'Les Nigéria'], 'Nigeria is masculine in French; the country Niger is also le Niger.', T.nat);
add('"Le Ghana" is:', 'Ghana', ['Gabon', 'Guinea', 'Gambia'], 'Le Ghana = Ghana.', T.nat);
add('"La France" is:', 'France', ['Africa', 'Europe', 'Francophonie'], 'La France is feminine because it ends in -e.', T.nat);
add('"Le Cameroun" is:', 'Cameroon', ['Congo', 'Chad', 'Comoros'], 'Le Cameroun = Cameroon.', T.nat);
add('"L\'Angleterre" is:', 'England', ['Ireland', 'Scotland', 'Wales'], 'L\'Angleterre = England.', T.nat);
add('The nationality adjective for a man from Ghana is:', 'Ghanéen', ['Ghanien', 'Ghanais', 'Ghanaïen'], 'Un Ghanéen / une Ghanéenne.', T.nat);
add('Nationalities in French are written:', 'With a small letter when they are adjectives', ['Always with a capital letter', 'Always in capitals', 'Never in writing'], 'Il est français; but Un Français (a French person, noun) has a capital.', T.nat);
add('The preposition used with feminine countries meaning "in" is:', 'En', ['Au', 'Aux', 'À la'], 'En France; but au Nigéria for masculine countries.', T.nat);
add('"Elle habite au Nigéria" means:', 'She lives in Nigeria', ['She is going to Nigeria', 'She is from Nigeria', 'She likes Nigeria'], 'Habiter = to live.', T.nat);

// ---------------------------------------------------------------- regular -er verbs
add('The infinitive of "je parle" is:', 'Parler', ['Parlir', 'Parle', 'Parlé'], 'Regular -er verbs end in -er in the infinitive.', T.erv);
add('The correct present-tense form of "parler" with "nous" is:', 'Nous parlons', ['Nous parlez', 'Nous parlent', 'Nous parle'], 'Remove -er and add -ons.', T.erv);
add('The correct present-tense form of "manger" with "nous" is:', 'Nous mangeons', ['Nous mangons', 'Nous mangez', 'Nous mangent'], 'The e is kept to preserve the soft "g" sound.', T.erv);
add('The correct present-tense form of "aimer" with "vous" is:', 'Vous aimez', ['Vous aimons', 'Vous aiment', 'Vous aime'], 'Add -ez for vous.', T.erv);
add('The correct present-tense form of "regarder" with "ils" is:', 'Ils regardent', ['Ils regardes', 'Ils regardons', 'Ils regardez'], 'Add -ent for ils and elles (silent).', T.erv);
add('The correct present-tense form of "habiter" with "tu" is:', 'Tu habites', ['Tu habite', 'Tu habitez', 'Tu habitent'], 'Add -es for tu.', T.erv);
add('The correct present-tense form of "étudier" with "je" is:', 'J\'étudie', ['Je étudie', 'J\'étudies', 'Je étudiez'], 'The pronoun je becomes j\' before a vowel.', T.erv);
add('The correct present-tense form of "chanter" with "elle" is:', 'Elle chante', ['Elle chantes', 'Elle chantez', 'Elle chantent'], 'Add -e for il, elle and on.', T.erv);
add('"Nous aimons le football" means:', 'We like football', ['We play football', 'We watch football', 'We hate football'], 'Aimer = to like or to love.', T.erv);
add('"Il travaille à Enugu" means:', 'He works in Enugu', ['He lives in Enugu', 'He studies in Enugu', 'He is from Enugu'], 'Travailler = to work.', T.erv);
add('"Écouter" means:', 'To listen', ['To hear', 'To watch', 'To speak'], 'Écouter la radio = to listen to the radio.', T.erv);
add('"Nous étudions le français" means:', 'We study French', ['We speak French', 'We hear French', 'We write French'], 'Étudier = to study.', T.erv);
add('In "Elles ___ au marché", the correct verb is:', 'achètent', ['achetons', 'achetez', 'acheter'], 'Acheter changes to achète- in the singular and the third person plural.', T.erv);
add('The verb "aimer" is followed by a definite article. Which sentence is correct?', 'J\'aime la musique', ['J\'aime de la musique', 'J\'aime une musique', 'J\'aime des musique'], 'After verbs of liking, use le, la, les.', T.erv);

// ---------------------------------------------------------------- negation
add('The negative of "Je parle français" is:', 'Je ne parle pas français', ['Je parle ne pas français', 'Je ne pas parle français', 'Ne je parle pas français'], 'Ne goes before the verb and pas after it.', T.neg);
add('The negative of "Elle a un frère" is:', 'Elle n\'a pas de frère', ['Elle n\'a pas un frère', 'Elle ne pas a de frère', 'Elle a pas de frère'], 'Ne becomes n\' before a vowel, and un becomes de.', T.neg);
add('"Il n\'est pas ici" means:', 'He is not here', ['He is here', 'He was here', 'He is never here'], 'Ne … pas = not.', T.neg);
add('"Ne … jamais" means:', 'Never', ['Always', 'Often', 'Sometimes'], 'Je ne mange jamais de viande.', T.neg);
add('"Je ne vois personne" means:', 'I see nobody', ['I see everybody', 'I see something', 'I see nothing'], 'Ne … personne = nobody.', T.neg);
add('"Nous n\'avons rien" means:', 'We have nothing', ['We have everything', 'We have nobody', 'We have never'], 'Ne … rien = nothing.', T.neg);
add('The negative of "Tu as faim" is:', 'Tu n\'as pas faim', ['Tu as pas faim', 'Tu ne as pas faim', 'Tu n\'as faim pas'], 'Ne contracts to n\' before the vowel a.', T.neg);
add('"Ne … plus" means:', 'No longer', ['Never', 'More', 'Still'], 'Il n\'habite plus ici = he no longer lives here.', T.neg);

// ---------------------------------------------------------------- questions
add('Which of the following turns a statement into a question?', 'Est-ce que', ['Ne … pas', 'Il y a', 'C\'est'], 'Est-ce que vous parlez français ?', T.que);
add('"Où habites-tu ?" asks:', 'Where do you live?', ['Who are you?', 'What is your name?', 'How are you?'], 'Où = where.', T.que);
add('"Qui est-ce ?" asks:', 'Who is it?', ['What is it?', 'Where is it?', 'When is it?'], 'Qui = who.', T.que);
add('"Quand est ton anniversaire ?" asks:', 'When is your birthday?', ['Where is your birthday?', 'Who is your birthday?', 'Why is your birthday?'], 'Quand = when.', T.que);
add('"Pourquoi" means:', 'Why', ['When', 'How', 'Who'], 'Pourquoi étudies-tu le français ?', T.que);
add('The answer to a "pourquoi" question usually begins with:', 'Parce que', ['Quand', 'Où', 'Qui'], 'Parce que means "because".', T.que);
add('"Combien coûte ce livre ?" asks:', 'How much does this book cost?', ['Which book is this?', 'Who bought this book?', 'Where is this book?'], 'Combien = how much or how many.', T.que);
add('"Comment" means:', 'How', ['What', 'Where', 'When'], 'Comment vas-tu ?', T.que);
add('"Que" or "qu\'est-ce que" means:', 'What', ['Who', 'Why', 'Where'], 'Qu\'est-ce que tu fais ? = What are you doing?', T.que);
add('Which is a question using inversion?', 'Parlez-vous français ?', ['Vous parlez français', 'Est-ce que vous parlez français', 'Vous ne parlez pas français'], 'The verb and subject are inverted and joined by a hyphen.', T.que);
add('Which is the formal way to ask "Do you speak English?"', 'Parlez-vous anglais ?', ['Tu parles anglais ?', 'Il parle anglais.', 'Tu ne parles pas anglais.'], 'The vous form with inversion is formal.', T.que);
add('Which question word asks "which" (before a noun)?', 'Quel / Quelle', ['Qui', 'Où', 'Quand'], 'Quel livre ? Quelle table ?', T.que);

// ---------------------------------------------------------------- adjectives
add('Which sentence has the correct agreement?', 'Elle est petite', ['Elle est petit', 'Elle est petits', 'Elle est petites'], 'The feminine singular adds -e.', T.adj);
add('Which sentence has the correct agreement?', 'Les étudiants sont intelligents', ['Les étudiants sont intelligent', 'Les étudiants sont intelligente', 'Les étudiants est intelligents'], 'The adjective agrees in number: plural with -s.', T.adj);
add('The feminine of "heureux" (happy) is:', 'Heureuse', ['Heureuxe', 'Heureure', 'Heureuxs'], 'Adjectives in -eux change to -euse.', T.adj);
add('The feminine of "beau" (beautiful) is:', 'Belle', ['Beaue', 'Beaute', 'Beauté'], 'It is irregular: beau, bel, belle.', T.adj);
add('The feminine of "blanc" (white) is:', 'Blanche', ['Blance', 'Blanque', 'Blancque'], 'It is an irregular feminine.', T.adj);
add('Most French adjectives are placed:', 'After the noun', ['Before the noun', 'At the start of the sentence', 'At the end of the sentence'], 'Une voiture rouge, un livre intéressant.', T.adj);
add('Which of these adjectives is normally placed BEFORE the noun?', 'Grand', ['Rouge', 'Intéressant', 'Français'], 'Beau, bon, grand, petit, jeune, vieux, nouveau and mauvais usually come before the noun (BAGS).', T.adj);
add('"Une grande maison" means:', 'A big house', ['A small house', 'A new house', 'A beautiful house'], 'Grand = big or tall.', T.adj);
add('"Un petit garçon" means:', 'A little boy', ['A tall boy', 'A fat boy', 'An old boy'], 'Petit = small.', T.adj);
add('"Mon père est grand et mince" means:', 'My father is tall and slim', ['My father is short and fat', 'My father is old and thin', 'My father is young and tall'], 'Mince = slim.', T.adj);
add('"Intelligent" ends in a consonant, so the feminine is:', 'Intelligente', ['Intelligent', 'Intelligentes', 'Intelligent-e-s'], 'Add -e for the feminine.', T.adj);
add('Adjectives that already end in -e, like "rouge", in the feminine singular:', 'Do not change', ['Add another -e', 'Change to -ee', 'Add -ne'], 'Une robe rouge; un livre rouge.', T.adj);

// ---------------------------------------------------------------- possessives
add('"Mon" is used before:', 'A masculine singular noun', ['A feminine plural noun', 'A feminine noun beginning with a consonant', 'A plural noun'], 'Mon frère, mon livre.', T.pos);
add('"Ma" is used before:', 'A feminine singular noun beginning with a consonant', ['A masculine singular noun', 'A plural noun', 'A masculine noun beginning with a vowel'], 'Ma sœur, ma maison.', T.pos);
add('"Mes" is used before:', 'A plural noun', ['A feminine noun', 'A masculine noun', 'A name'], 'Mes livres, mes sœurs.', T.pos);
add('The correct possessive in "___ amie" (my friend, female) is:', 'Mon', ['Ma', 'Mes', 'Moi'], 'Before a feminine noun beginning with a vowel, mon is used: mon amie.', T.pos);
add('"Notre" means:', 'Our', ['Your (formal)', 'Their', 'Her'], 'Notre maison, nos amis.', T.pos);
add('"Leur" means:', 'Their', ['Our', 'His', 'Your'], 'Leur voiture, leurs amis.', T.pos);
add('The correct possessive in "Elle aime ___ frère" (her brother) is:', 'son', ['sa', 'ses', 'leur'], 'Son agrees with the thing possessed (frère is masculine), not with the owner.', T.pos);
add('"Votre" is used with:', 'Vous', ['Tu', 'Nous', 'Ils'], 'Votre livre = your book (polite or plural).', T.pos);
add('The correct possessive in "Tu as ___ stylo ?" (your pen) is:', 'ton', ['ta', 'tes', 'votre'], 'Stylo is masculine singular: ton stylo.', T.pos);

// ---------------------------------------------------------------- family
add('"Le père" is:', 'The father', ['The brother', 'The uncle', 'The grandfather'], 'Le père = father.', T.fam);
add('"La sœur" is:', 'The sister', ['The mother', 'The cousin', 'The aunt'], 'La sœur = sister.', T.fam);
add('"Les parents" means:', 'The parents', ['The relatives only', 'The grandparents', 'The children'], 'In French, "parents" means mother and father.', T.fam);
add('"Le grand-père" is:', 'The grandfather', ['The father', 'The great-uncle', 'The uncle'], 'Grand-père = grandfather.', T.fam);
add('"La tante" is:', 'The aunt', ['The cousin', 'The niece', 'The grandmother'], 'La tante = aunt.', T.fam);
add('"Le cousin" is:', 'The cousin (male)', ['The nephew', 'The uncle', 'The brother'], 'La cousine is the female cousin.', T.fam);
add('"Mon oncle" means:', 'My uncle', ['My nephew', 'My aunt', 'My father'], 'Un oncle = an uncle.', T.fam);
add('"Mes enfants" means:', 'My children', ['My parents', 'My friends', 'My brothers'], 'Enfant = child.', T.fam);
add('"Ils ont deux fils et une fille" means:', 'They have two sons and a daughter', ['They have two brothers and a sister', 'They have two fathers and a mother', 'They have two cousins and a niece'], 'Fils = son; fille = daughter or girl.', T.fam);

// ---------------------------------------------------------------- telling the time
add('"Quelle heure est-il ?" asks:', 'What time is it?', ['What day is it?', 'How old are you?', 'Where are you?'], 'Heure = hour or time.', T.tim);
add('"Il est midi" means:', 'It is noon', ['It is midnight', 'It is 1 o\'clock', 'It is 12:30'], 'Midi = noon; minuit = midnight.', T.tim);
add('"Il est minuit" means:', 'It is midnight', ['It is noon', 'It is 6 o\'clock', 'It is 10 o\'clock'], 'Minuit = midnight.', T.tim);
add('"Il est huit heures et demie" means:', 'It is 8:30', ['It is 8:15', 'It is 7:30', 'It is 8:45'], 'Et demie = and a half.', T.tim);
add('"Il est trois heures et quart" means:', 'It is 3:15', ['It is 3:45', 'It is 3:30', 'It is 2:45'], 'Et quart = quarter past.', T.tim);
add('"Il est quatre heures moins le quart" means:', 'It is 3:45', ['It is 4:15', 'It is 4:45', 'It is 3:15'], 'Moins le quart = quarter to.', T.tim);
add('"Il est dix heures dix" means:', 'It is 10:10', ['It is 9:50', 'It is 1:00', 'It is 10:00'], 'Dix heures dix = 10:10.', T.tim);
add('"À quelle heure" asks:', 'At what time', ['On which day', 'In which month', 'In which year'], 'À quelle heure commence le cours ?', T.tim);
add('"Le matin", "l\'après-midi" and "le soir" mean:', 'The morning, the afternoon and the evening', ['The week, the month and the year', 'Today, tomorrow and yesterday', 'Noon, midnight and sunrise'], 'They are the parts of the day.', T.tim);

// ---------------------------------------------------------------- prepositions and contractions
add('"à + le" contracts to:', 'Au', ['Aux', 'À la', 'Du'], 'Je vais au marché.', T.pre);
add('"à + les" contracts to:', 'Aux', ['Au', 'À les', 'Des'], 'Nous parlons aux étudiants.', T.pre);
add('"de + le" contracts to:', 'Du', ['Des', 'De le', 'De la'], 'Le livre du professeur.', T.pre);
add('"de + les" contracts to:', 'Des', ['Du', 'De les', 'Dès'], 'Les livres des étudiants.', T.pre);
add('"À la" and "de la" do NOT contract because:', 'La is feminine singular', ['La is masculine', 'La is plural', 'La follows a vowel'], 'Only le and les contract with à and de.', T.pre);
add('Which sentence is correct?', 'Je vais à l\'université', ['Je vais au l\'université', 'Je vais aux l\'université', 'Je vais de l\'université'], 'Before a vowel, l\' is used with à.', T.pre);
add('"Sur la table" means:', 'On the table', ['Under the table', 'Near the table', 'Behind the table'], 'Sur = on.', T.pre);
add('"Sous la chaise" means:', 'Under the chair', ['On the chair', 'In front of the chair', 'Beside the chair'], 'Sous = under.', T.pre);
add('"Devant" and "derrière" mean:', 'In front of and behind', ['Beside and between', 'Under and over', 'Above and below'], 'Devant la porte = in front of the door.', T.pre);
add('"Dans" means:', 'In or inside', ['On', 'Under', 'Beside'], 'Dans la classe = in the classroom.', T.pre);
add('"Entre" means:', 'Between', ['Beside', 'Behind', 'Under'], 'Entre deux amis = between two friends.', T.pre);
add('"À côté de" means:', 'Beside or next to', ['In front of', 'Far from', 'Between'], 'À côté de la banque = next to the bank.', T.pre);
add('"Chez moi" means:', 'At my place', ['By myself', 'With me', 'For me'], 'Chez means "at the house of".', T.pre);

// ---------------------------------------------------------------- aller and faire
add('The correct form of aller in "Je ___ à l\'école" is:', 'vais', ['vas', 'va', 'allons'], 'Je vais = I go.', T.all);
add('The correct form of aller in "Nous ___ au marché" is:', 'allons', ['allez', 'vont', 'va'], 'Nous allons = we go.', T.all);
add('The correct form of aller in "Ils ___ à Lagos" is:', 'vont', ['va', 'allez', 'allons'], 'Ils vont = they go.', T.all);
add('The correct form of aller in "Tu ___ à l\'université" is:', 'vas', ['vais', 'va', 'vont'], 'Tu vas = you go.', T.all);
add('The correct form of faire in "Nous ___ nos devoirs" is:', 'faisons', ['faites', 'font', 'fait'], 'Nous faisons = we do.', T.all);
add('The correct form of faire in "Vous ___ du sport" is:', 'faites', ['faisons', 'font', 'fais'], 'Vous faites = you do.', T.all);
add('The correct form of faire in "Ils ___ la cuisine" is:', 'font', ['faisons', 'fait', 'faites'], 'Ils font = they do.', T.all);
add('"Aller + infinitive", as in "Je vais manger", expresses:', 'The near future', ['The past', 'The present perfect', 'A command'], 'It means "I am going to eat".', T.all);
add('"Il fait chaud" means:', 'It is hot (weather)', ['He is hot', 'He makes heat', 'He does the cooking'], 'The weather uses the verb faire: il fait beau, il fait froid.', T.all);
add('"Il fait beau" means:', 'The weather is nice', ['He is handsome', 'He does well', 'It is raining'], 'Il fait beau = the weather is fine.', T.all);
add('"Faire la cuisine" means:', 'To cook', ['To clean', 'To wash up', 'To buy food'], 'La cuisine = the kitchen or the cooking.', T.all);

// ---------------------------------------------------------------- everyday vocabulary and colours
add('"Un cahier" is:', 'An exercise book', ['A pencil', 'A ruler', 'A bag'], 'Cahier = notebook.', T.voc);
add('"Un crayon" is:', 'A pencil', ['A pen', 'A chair', 'A book'], 'Crayon = pencil; stylo = pen.', T.voc);
add('"Une salle de classe" is:', 'A classroom', ['A bedroom', 'A kitchen', 'A hall'], 'Salle = room.', T.voc);
add('"Un étudiant" is:', 'A university student', ['A teacher', 'A doctor', 'A driver'], 'Étudiant = student at university.', T.voc);
add('"Un professeur" is:', 'A teacher or lecturer', ['A pupil', 'A doctor', 'A lawyer'], 'Professeur = teacher.', T.voc);
add('"Le pain" is:', 'Bread', ['Meat', 'Rice', 'Water'], 'Le pain = bread.', T.voc);
add('"Le riz" is:', 'Rice', ['Bread', 'Beans', 'Fish'], 'Le riz = rice.', T.voc);
add('"L\'eau" is:', 'Water', ['Milk', 'Wine', 'Juice'], 'L\'eau = water.', T.voc);
add('"Le poisson" is:', 'Fish', ['Chicken', 'Beef', 'Egg'], 'Le poisson = fish.', T.voc);
add('"Rouge" is the colour:', 'Red', ['Blue', 'Green', 'Yellow'], 'Rouge = red.', T.col);
add('"Vert" is the colour:', 'Green', ['Grey', 'Red', 'Black'], 'Vert = green.', T.col);
add('"Jaune" is the colour:', 'Yellow', ['Orange', 'Brown', 'Pink'], 'Jaune = yellow.', T.col);
add('"Noir" is the colour:', 'Black', ['White', 'Grey', 'Brown'], 'Noir = black.', T.col);
add('"Bleu" and "blanc" are:', 'Blue and white', ['Black and brown', 'Grey and green', 'Red and yellow'], 'Bleu = blue; blanc = white.', T.col);
add('The French flag has the colours:', 'Bleu, blanc, rouge', ['Vert, blanc, rouge', 'Rouge, jaune, noir', 'Bleu, jaune, vert'], 'It is known as le drapeau tricolore.', T.cul);

// ---------------------------------------------------------------- the French-speaking world
add('The capital of France is:', 'Paris', ['Lyon', 'Marseille', 'Bordeaux'], 'Paris is on the Seine.', T.cul);
add('Which of these countries has French as an official language?', 'Cameroon', ['Nigeria', 'Ghana', 'Kenya'], 'Cameroon has French and English as official languages.', T.cul);
add('Which of these is a French-speaking neighbour of Nigeria?', 'Benin', ['Ghana', 'Liberia', 'Sierra Leone'], 'Benin, Niger and Chad (and Cameroon) border Nigeria.', T.cul);
add('Which international organisation brings French-speaking countries together?', 'La Francophonie', ['OPEC', 'The African Union only', 'NATO'], 'It promotes the French language and culture.', T.cul);
add('"Francophone" describes someone or a country that:', 'Speaks French', ['Eats French food', 'Lives in Paris', 'Studies mathematics'], 'It comes from franco- (French) and -phone (speaking).', T.cul);
add('The river that flows through Paris is:', 'La Seine', ['La Loire', 'Le Rhône', 'Le Nil'], 'La Seine = the Seine.', T.cul);
add('The national day of France is celebrated on:', 'The 14th of July', ['The 1st of January', 'The 25th of December', 'The 1st of May'], 'Le 14 juillet commemorates the storming of the Bastille in 1789.', T.cul);

module.exports = out;
