// Checks the rules that decide what reaches a student's noticeboard.
//
//   node supabase/functions/fetch-news/filter_test.mts
//
// Node runs .mts directly by stripping the types. Deno also runs this file.
// The cases below are real headlines taken from the live feeds, including the
// ones that slipped through an earlier, looser filter.

import { parseFeed } from './feed.ts';

let passed = 0;
let failed = 0;

function check(name: string, actual: unknown, expected: unknown): void {
  const ok = JSON.stringify(actual) === JSON.stringify(expected);
  if (ok) {
    passed++;
  } else {
    failed++;
    console.log(`  FAIL  ${name}\n        expected ${JSON.stringify(expected)}, got ${JSON.stringify(actual)}`);
  }
}

/// Wraps a headline and excerpt in the minimum RSS the parser needs.
function feed(title: string, description = ''): string {
  return `<rss><channel><item>
    <title><![CDATA[${title}]]></title>
    <link>https://example.com/${encodeURIComponent(title).slice(0, 40)}</link>
    <pubDate>Wed, 05 Aug 2026 06:00:00 +0000</pubDate>
    <description><![CDATA[${description}]]></description>
  </item></channel></rss>`;
}

const kept = (title: string, description = '') =>
  parseFeed(feed(title, description), 'Test').length === 1;

const categoryOf = (title: string, description = '') =>
  parseFeed(feed(title, description), 'Test')[0]?.category;

// ---------------------------------------------------------------- relevance
console.log('relevance');

check(
  'a JAMB result story is kept',
  kept('21,082 candidates absent as 99% scored below 200 in rescheduled UTME — JAMB'),
  true,
);
check(
  'a Chevening scholarship call is kept',
  kept('UK Government Chevening Scholarship 2027 (NOW OPEN) | Fully Funded'),
  true,
);
check(
  'a WAEC how-to is kept',
  kept('Seven easy steps to check your WAEC 2026 result online'),
  true,
);
check(
  'an ASUU story is kept',
  kept('ASUU threatens fresh strike over withheld salaries'),
  true,
);
check(
  'two ordinary education words are enough',
  kept(
    'FG unveils Almajiri reform, bans street begging',
    'A new National Policy for the Enhancement of Almajiri Education, prohibiting Almajiri learning centres from street begging.',
  ),
  true,
);

// These are the ones that got through when a single loose keyword was enough.
check(
  'a robbery involving a graduate is refused',
  kept(
    'Robbers shoot LASU graduate during attack on PoS operator',
    'A LASU graduate is fighting for his life after being shot by robbers in Igando, Lagos.',
  ),
  false,
);
check(
  'a rape case involving a sportsman is refused',
  kept(
    'US charges Nigerian basketball player with rape',
    'Nigerian basketball player faces first-degree rape charges in Alabama.',
  ),
  false,
);
check(
  'party politics mentioning students is refused',
  kept(
    '2027: Ogun youths mobilise support for Tinubu, Yayi',
    'Ogun youths and students are mobilising support ahead of the 2027 elections.',
  ),
  false,
);
check(
  'a chieftaincy dispute at a university is refused',
  kept(
    'Igweship Tussle: ESUT confirms dismissal of contender, Obiora Ngwu',
    'A chieftaincy dispute in Umuogbo-Agu Autonomous Community has taken a new turn.',
  ),
  false,
);
check(
  'a single ordinary word is not enough on its own',
  kept('Man builds house near school', 'A resident completed the building.'),
  false,
);

// A crime word must not sink a genuine education story.
check(
  'an ASUU story about a killing is still kept',
  kept('ASUU condemns killing of lecturer in Kaduna'),
  true,
);
check(
  'an admissions story mentioning an election is still kept',
  kept('JAMB shifts UTME dates over election logistics'),
  true,
);

// ------------------------------------------------------------- word matching
console.log('word matching');

check(
  'a substring does not count as a mention',
  // "degrees" of separation and "examine" must not fire "degree"/"exam".
  kept(
    'Police examine six degrees of separation in fraud case',
    'Officers examine the network behind the scheme.',
  ),
  false,
);

// -------------------------------------------------------------- categories
console.log('categories');

check(
  'a scholarship call is filed under scholarship',
  categoryOf('Skoll Scholarship 2026-2027 for MBA Studies at Oxford'),
  'scholarship',
);
check(
  'a JAMB story is filed under admission',
  categoryOf('JAMB releases 2026 UTME results'),
  'admission',
);
check(
  'an internship is filed under opportunity',
  categoryOf('Google internship applications open for Nigerian undergraduates'),
  'opportunity',
);
check(
  'an olympiad is filed under competition',
  categoryOf('National Mathematics Olympiad opens for secondary school pupils'),
  'competition',
);
check(
  'general schools coverage falls back to academic',
  categoryOf(
    'Borno students develop indigenous robot teacher',
    'Pupils at a Borno school built a teaching robot for their classroom.',
  ),
  'academic',
);
check(
  'research funding is not mistaken for a scholarship',
  // "funding" alone used to put this on the scholarships board.
  categoryOf(
    'How poor research funding stifles national development',
    'University research and development efforts remain underfunded.',
  ),
  'academic',
);

// ------------------------------------------------------------------ cleaning
console.log('cleaning');

const entity = parseFeed(
  feed('UK Chevening Scholarship 2027 &#124; Fully Funded'),
  'Test',
)[0];
check('a numeric entity is decoded', entity?.title.includes('|'), true);
check('no raw entity survives', entity?.title.includes('&#'), false);

const curly = parseFeed(
  feed('JAMB&#8217;s new policy', 'Students&#8217; results are out.'),
  'Test',
)[0];
check('a curly apostrophe is decoded', curly?.title, 'JAMB’s new policy');

const noise = parseFeed(
  feed(
    'JAMB releases results',
    'Candidates can now check their scores. Read More: https://punchng.com/some-story/',
  ),
  'Test',
)[0];
check(
  'a publisher Read More footer is stripped',
  noise?.summary.includes('Read More'),
  false,
);

const wordpress = parseFeed(
  feed(
    'WAEC timetable out',
    'The timetable has been published. The post WAEC timetable out appeared first on EduCeleb.',
  ),
  'Test',
)[0];
check(
  'a WordPress footer is stripped',
  wordpress?.summary.includes('appeared first on'),
  false,
);

// ------------------------------------------------------------------ links
console.log('links');

const tracked = parseFeed(
  `<rss><channel><item>
     <title>JAMB releases 2026 UTME results</title>
     <link>https://punchng.com/story/?utm_source=rss&amp;utm_medium=web&amp;fbclid=xyz</link>
     <pubDate>Wed, 05 Aug 2026 06:00:00 +0000</pubDate>
     <description>Results are out.</description>
   </item></channel></rss>`,
  'Punch',
)[0];
check(
  'tracking parameters are stripped so a story stores once',
  tracked?.link,
  'https://punchng.com/story/',
);

// ------------------------------------------------------------------ safety
console.log('robustness');

check('empty XML yields nothing', parseFeed('', 'Test').length, 0);
check('HTML served instead of RSS yields nothing', parseFeed('<!DOCTYPE html><html><body>hi</body></html>', 'Test').length, 0);
check(
  'an item with no title is skipped',
  parseFeed('<rss><channel><item><link>https://x.com</link></item></channel></rss>', 'Test').length,
  0,
);
check(
  'an unparseable date does not drop the item',
  parseFeed(
    `<rss><channel><item><title>JAMB releases UTME results</title>
     <link>https://x.com/a</link><pubDate>not a date</pubDate>
     <description>Out now.</description></item></channel></rss>`,
    'Test',
  ).length,
  1,
);

console.log(`\n${passed} passed, ${failed} failed`);
if (failed > 0) process.exit(1);
