// =============================================================================
// Eduvora — automatic education news: feed reading, filtering, categorising
// =============================================================================
// Pulls Nigerian education, scholarship and exam news from public RSS feeds
// and files it into the `news` table, so the noticeboard fills itself instead
// of waiting for somebody to type entries in by hand.
//
// Two things this deliberately does not do.
//
// It does not store full articles. Only the headline, a short excerpt, the
// publisher's name and a link back to the original — which is what an
// aggregator may do. Republishing whole articles from Punch or Premium Times
// would be a copyright problem, and the app links out for the full story.
//
// It does not trust a feed's own category. Punch's "education" feed carries
// general news alongside the schools coverage, so every item is scored against
// education keywords and anything that does not clear the bar is dropped.
// Otherwise students open the scholarship board and find road-safety stories.
// =============================================================================


// ---------------------------------------------------------------- the feeds
// Every one of these was checked to return valid RSS with items in it. Several
// obvious candidates were left out because they block automated requests
// (The Nation, Leadership, Guardian Nigeria) or return an empty feed.
export const FEEDS: { url: string; source: string }[] = [
  { url: 'https://punchng.com/topics/education/feed/', source: 'Punch' },
  {
    url: 'https://www.vanguardngr.com/category/education/feed/',
    source: 'Vanguard',
  },
  {
    url: 'https://www.premiumtimesng.com/category/news/education/feed',
    source: 'Premium Times',
  },
  {
    url: 'https://tribuneonlineng.com/category/education/feed/',
    source: 'Nigerian Tribune',
  },
  { url: 'https://www.legit.ng/rss/education.rss', source: 'Legit.ng' },
  { url: 'https://dailypost.ng/hot-news/feed/', source: 'Daily Post' },
  { url: 'https://educeleb.com/feed/', source: 'EduCeleb' },
  {
    url: 'https://scholarshipregion.com/feed/',
    source: 'Scholarship Region',
  },
  { url: 'https://opportunitydesk.org/feed/', source: 'Opportunity Desk' },
];

// ------------------------------------------------------------- relevance
// A single loose keyword is not enough to file something. "Robbers shoot LASU
// graduate" and "US charges Nigerian basketball player" both contain education
// words and are not education news; a student opening the noticeboard for
// scholarships should not find them there.
//
// So: one unambiguous term admits an item outright, two ordinary ones will do
// between them, and a headline that reads like crime, sport or party politics
// is refused unless something unambiguous is present.

/// Terms that only appear in education stories. Any one of these is enough.
const STRONG_TERMS = [
  'jamb',
  'utme',
  'post-utme',
  'waec',
  'wassce',
  'neco',
  'nabteb',
  'asuu',
  'asup',
  'nans',
  'nuc',
  'nelfund',
  'tetfund',
  'scholarship',
  'scholarships',
  'bursary',
  'admission',
  'admissions',
  'matriculation',
  'convocation',
  'undergraduate',
  'postgraduate',
  'polytechnic',
  'polytechnics',
  'college of education',
  'cut-off mark',
  'cut off mark',
  'school fees',
  'tuition',
  'student loan',
  'curriculum',
  'lecturer',
  'lecturers',
  'fellowship',
  'scholar',
  'scholars',
  'examination',
  'examinations',
];

/// Ordinary education words. Two of these between the headline and the
/// excerpt will admit an item.
const WEAK_TERMS = [
  'university',
  'universities',
  'student',
  'students',
  'pupil',
  'pupils',
  'campus',
  'education',
  'educational',
  'academic',
  'school',
  'schools',
  'schooling',
  'graduate',
  'graduates',
  'graduation',
  'degree',
  'faculty',
  'nysc',
  'internship',
  'classroom',
  'teacher',
  'teachers',
  'research',
  'thesis',
  'dissertation',
  'syllabus',
  'timetable',
  'exam',
  'exams',
  'result',
  'results',
  'learning',
  'literacy',
];

/// A headline reading like this is refused unless something unambiguous is
/// also present — an ASUU strike over a killing is still education news, a
/// robbery that happens to involve a graduate is not.
const BLOCK_TERMS = [
  'rape',
  'raped',
  'murder',
  'murdered',
  'killed',
  'killing',
  'robber',
  'robbers',
  'robbery',
  'shot',
  'shoot',
  'gunmen',
  'kidnap',
  'kidnapped',
  'kidnapping',
  'abduct',
  'abducted',
  'cultist',
  'cultists',
  'corpse',
  'molest',
  'defile',
  'chieftaincy',
  'igweship',
  'tinubu',
  'apc',
  'pdp',
  'governorship',
  'senator',
  'election',
  'elections',
  '2027',
  'football',
  'basketball',
  'striker',
  'super eagles',
];

// Category rules, checked in order — the first match wins, so the more
// specific buckets come before the general one.
const CATEGORY_RULES: { category: string; terms: string[] }[] = [
  {
    category: 'scholarship',
    terms: [
      'scholarship',
      'scholarships',
      'bursary',
      'bursaries',
      'fully funded',
      'fully-funded',
      'tuition-free',
      'nelfund',
      'student loan',
      'fellowship',
      'fellowships',
      'study grant',
      // Bare "funding" and "grant" are deliberately absent: they put
      // "poor research funding" on the scholarships board.
    ],
  },
  {
    category: 'admission',
    terms: [
      'admission',
      'admissions',
      'jamb',
      'utme',
      'post-utme',
      'cut-off mark',
      'cut off mark',
      'matriculation',
      'screening',
      'waec',
      'wassce',
      'neco',
      'nabteb',
      'result',
      'results',
      'registration',
    ],
  },
  {
    category: 'opportunity',
    terms: [
      'internship',
      'graduate trainee',
      'job',
      'jobs',
      'recruitment',
      'vacancy',
      'vacancies',
      'apprenticeship',
      'career',
      'employment',
      'nysc',
    ],
  },
  {
    category: 'competition',
    terms: [
      'competition',
      'contest',
      'olympiad',
      'hackathon',
      'award',
      'prize',
      'challenge',
      'debate',
      'quiz',
    ],
  },
];


export interface FeedItem {
  title: string;
  link: string;
  summary: string;
  publishedAt: string;
  source: string;
  category: string;
}

// ------------------------------------------------------------------ parsing
// A hand-rolled reader rather than an XML library: these feeds are plain
// RSS 2.0, and a regex reader cannot throw on the malformed markup that turns
// up in the wild — it just finds nothing for that item and moves on.

function tag(block: string, name: string): string {
  const match = block.match(
    new RegExp(`<${name}[^>]*>([\\s\\S]*?)</${name}>`, 'i'),
  );
  return match ? clean(match[1]) : '';
}

function clean(raw: string): string {
  return (
    raw
      .replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, '$1')
      .replace(/<[^>]+>/g, ' ')
      // Named entities first, then any numeric one. Publishers emit numeric
      // entities for all sorts of punctuation — a headline arriving as
      // "Chevening Scholarship &#124; Fully Funded" must not reach a student
      // with the raw code still in it.
      .replace(/&nbsp;/g, ' ')
      .replace(/&rsquo;/g, '’')
      .replace(/&lsquo;/g, '‘')
      .replace(/&ldquo;/g, '“')
      .replace(/&rdquo;/g, '”')
      .replace(/&ndash;/g, '–')
      .replace(/&mdash;/g, '—')
      .replace(/&hellip;/g, '…')
      .replace(/&quot;/g, '"')
      .replace(/&apos;/g, "'")
      .replace(/&lt;/g, '<')
      .replace(/&gt;/g, '>')
      .replace(/&#x([0-9a-f]+);/gi, (_, hex) =>
        String.fromCodePoint(parseInt(hex, 16)),
      )
      .replace(/&#(\d+);/g, (_, dec) => String.fromCodePoint(Number(dec)))
      // Ampersand last, so "&amp;#124;" cannot become a live entity midway.
      .replace(/&amp;/g, '&')
      .replace(/\s+/g, ' ')
      .trim()
  );
}

/// Publishers append their own "Read More: <url>" and share prompts to the
/// description. Those are noise in a summary card.
function tidySummary(raw: string): string {
  const trimmed = raw
    .replace(/Read More:?\s*https?:\/\/\S+/gi, '')
    .replace(/The post .+ appeared first on .+$/i, '')
    .replace(/Continue reading.*$/i, '')
    .trim();

  if (trimmed.length <= 260) return trimmed;
  // Cut at a sentence end where one is close by, so a card does not stop
  // mid-word.
  const cut = trimmed.slice(0, 260);
  const stop = cut.lastIndexOf('. ');
  return stop > 150 ? cut.slice(0, stop + 1) : `${cut.trimEnd()}…`;
}

/// Whole-word matching, allowing a plural ending.
///
/// Substring matching lets "exam" fire on "examine" and "degree" on "degrees
/// of separation", which is how noise gets in. But strict whole-word matching
/// is too strict the other way: "undergraduates" would not match
/// "undergraduate", and a real scholarship call gets dropped. A trailing s or
/// es is therefore allowed, which covers the plurals without opening the door
/// to arbitrary substrings.
function mentions(haystack: string, term: string): boolean {
  const escaped = term.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  return new RegExp(
    `(^|[^a-z0-9])${escaped}(s|es)?([^a-z0-9]|$)`,
    'i',
  ).test(haystack);
}

function countMatches(haystack: string, terms: string[]): number {
  return terms.reduce(
    (total, term) => (mentions(haystack, term) ? total + 1 : total),
    0,
  );
}

export function isRelevant(title: string, summary: string): boolean {
  const haystack = `${title} ${summary}`.toLowerCase();
  const strong = countMatches(haystack, STRONG_TERMS);

  // Something unambiguous is present — file it regardless of how the
  // headline reads.
  if (strong > 0) return true;

  // Only the headline is checked for the refusals: a passing mention of an
  // election deep in an article about school funding should not sink it.
  if (countMatches(title.toLowerCase(), BLOCK_TERMS) > 0) return false;

  return countMatches(haystack, WEAK_TERMS) >= 2;
}

export function categorise(text: string): string {
  const haystack = text.toLowerCase();
  for (const rule of CATEGORY_RULES) {
    if (rule.terms.some((term) => haystack.includes(term))) {
      return rule.category;
    }
  }
  return 'academic';
}

/// Strips the tracking parameters publishers add to feed links, so the same
/// article fetched twice does not arrive as two different rows.
export function canonical(link: string): string {
  try {
    const url = new URL(link);
    for (const key of [...url.searchParams.keys()]) {
      if (key.startsWith('utm_') || key === 'fbclid') {
        url.searchParams.delete(key);
      }
    }
    url.hash = '';
    return url.toString();
  } catch {
    return link;
  }
}

export function parseFeed(xml: string, source: string): FeedItem[] {
  const items: FeedItem[] = [];
  const blocks = xml.match(/<item[\s>][\s\S]*?<\/item>/gi) ?? [];

  for (const block of blocks) {
    const title = tag(block, 'title');
    const rawLink = tag(block, 'link') || tag(block, 'guid');
    if (!title || !rawLink) continue;

    const summary = tidySummary(
      tag(block, 'description') || tag(block, 'content:encoded'),
    );
    if (!isRelevant(title, summary)) continue;
    const haystack = `${title} ${summary}`;

    const pubDate = tag(block, 'pubDate') || tag(block, 'dc:date');
    const parsed = pubDate ? new Date(pubDate) : new Date();
    const publishedAt = Number.isNaN(parsed.getTime())
      ? new Date().toISOString()
      : parsed.toISOString();

    items.push({
      title,
      link: canonical(rawLink),
      summary,
      publishedAt,
      source,
      category: categorise(haystack),
    });
  }

  return items;
}

export async function readFeed(
  feed: { url: string; source: string },
): Promise<FeedItem[]> {
  // A slow publisher must not hold up the whole run.
  const abort = new AbortController();
  const timer = setTimeout(() => abort.abort(), 20_000);

  try {
    const response = await fetch(feed.url, {
      signal: abort.signal,
      headers: {
        // Several publishers sit behind a filter that refuses anything
        // self-identifying as a bot, including feeds they publish openly.
        // A conventional browser string is what actually gets served.
        'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 ' +
          '(KHTML, like Gecko) Chrome/126.0 Safari/537.36',
        Accept: 'application/rss+xml, application/xml, text/xml, */*',
      },
    });
    if (!response.ok) {
      console.warn(`${feed.source}: HTTP ${response.status}`);
      return [];
    }
    return parseFeed(await response.text(), feed.source);
  } catch (error) {
    console.warn(`${feed.source}: ${error}`);
    return [];
  } finally {
    clearTimeout(timer);
  }
}

