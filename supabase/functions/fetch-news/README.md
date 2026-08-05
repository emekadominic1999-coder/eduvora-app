# Automatic education news

Fills the Eduvora noticeboard from public RSS feeds — JAMB, WAEC, scholarships,
admissions, university notices — so nobody has to type entries in by hand.

## What it does

Every six hours it reads nine Nigerian education and scholarship feeds, throws
away anything that is not education news, sorts what is left into the app's
five categories, and writes it to the `news` table.

It stores the **headline, a short excerpt, the publisher's name and a link back
to the original** — never the full article. Republishing whole stories from
Punch or Premium Times would be a copyright problem. Tapping a card opens the
publisher's own page, which is how an aggregator should behave.

## The feeds

| Source | What it brings |
|---|---|
| Punch | General education coverage |
| Vanguard | Education desk |
| Premium Times | Education desk |
| Nigerian Tribune | Education desk |
| Legit.ng | JAMB/WAEC how-to guides |
| Daily Post | Breaking education news |
| EduCeleb | Education-only publisher |
| Scholarship Region | Scholarships |
| Opportunity Desk | Scholarships, fellowships, competitions |

Each one was checked to return valid RSS. Several obvious candidates are
missing on purpose — The Nation, Leadership and Guardian Nigeria block
automated requests, and Scholars4Dev publishes an empty feed.

## Why the filtering is strict

A feed's own category cannot be trusted. Punch files general news under
"education", so an early version of this put *"Robbers shoot LASU graduate"*
and *"US charges Nigerian basketball player with rape"* on a student's
scholarship board, because both contain education words.

So an item is kept only if:

- it mentions something **unambiguous** (JAMB, WAEC, ASUU, scholarship,
  admission, tuition, matriculation…), **or**
- it mentions **two ordinary** education words (university, student, campus,
  exam, research…) **and** the headline does not read like crime, sport or
  party politics.

An unambiguous term always wins, so *"ASUU condemns killing of lecturer"* is
still kept — a crime word must not sink a real education story.

`filter_test.mts` covers these rules with real headlines, including every one
that slipped through the looser version.

## Setting it up

### 1. Deploy the function

Needs the Supabase CLI. In a terminal, from the project root:

```bash
npx supabase login
```

```bash
npx supabase link --project-ref wdsvzhxhqzblpekdmsqs
```

```bash
npx supabase functions deploy fetch-news
```

### 2. Prepare the table

Run `supabase/NEWS_auto_feed.sql` in the Supabase SQL Editor. It adds the
unique index the upsert needs and schedules the job.

### 3. Fill it once, now

In the Supabase dashboard: **Edge Functions → fetch-news → Invoke**.

It replies with what it found:

```json
{
  "feeds": 9,
  "fetched": 105,
  "stored": 73,
  "byCategory": {
    "admission": 30,
    "scholarship": 20,
    "academic": 19,
    "competition": 3,
    "opportunity": 1
  }
}
```

Reload the app and the noticeboard is full.

### 4. Keep it running

Either use the schedule in `NEWS_auto_feed.sql`, or — simpler — the dashboard:
**Integrations → Cron → Create job**, point it at `fetch-news`, schedule
`0 */6 * * *`.

## Running the tests

```bash
node supabase/functions/fetch-news/filter_test.mts
```

## Adding a feed

Add it to `FEEDS` in `feed.ts`. Check it serves real RSS first:

```bash
curl -sL -A "Mozilla/5.0" "https://example.com/feed/" | grep -c "<item"
```

A count of zero means the site blocks automated requests or publishes nothing
— leave it out rather than paying for a request that always fails.
