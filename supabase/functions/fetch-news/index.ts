import { createClient } from 'jsr:@supabase/supabase-js@2';

import { FEEDS, readFeed, type FeedItem } from './feed.ts';

Deno.serve(async (request: Request) => {
  const url = Deno.env.get('SUPABASE_URL');
  const key = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  if (!url || !key) {
    return json({ error: 'Function is missing its Supabase credentials.' }, 500);
  }

  const client = createClient(url, key);

  // Every feed is read at once; one failing publisher costs nothing.
  const harvested = (await Promise.all(FEEDS.map(readFeed))).flat();

  // Two publishers often carry the same story. Keep the earliest copy.
  const unique = new Map<string, FeedItem>();
  for (const item of harvested) {
    const existing = unique.get(item.link);
    if (!existing || item.publishedAt < existing.publishedAt) {
      unique.set(item.link, item);
    }
  }

  // Anything older than a term is not news to a student.
  const cutoff = Date.now() - 90 * 24 * 60 * 60 * 1000;
  const fresh = [...unique.values()].filter(
    (item) => new Date(item.publishedAt).getTime() >= cutoff,
  );

  if (fresh.length === 0) {
    return json({ fetched: harvested.length, stored: 0, note: 'nothing new' });
  }

  // `link` is unique, so re-running only refreshes what is already there
  // rather than piling up duplicates.
  const { error } = await client.from('news').upsert(
    fresh.map((item) => ({
      title: item.title,
      summary: item.summary,
      category: item.category,
      source: item.source,
      link: item.link,
      published_at: item.publishedAt,
    })),
    { onConflict: 'link', ignoreDuplicates: false },
  );

  if (error) {
    console.error('upsert failed', error);
    return json({ error: error.message }, 500);
  }

  // Keep the table from growing without limit.
  await client
    .from('news')
    .delete()
    .lt(
      'published_at',
      new Date(Date.now() - 180 * 24 * 60 * 60 * 1000).toISOString(),
    )
    .neq('is_featured', true);

  const byCategory: Record<string, number> = {};
  for (const item of fresh) {
    byCategory[item.category] = (byCategory[item.category] ?? 0) + 1;
  }

  return json({
    feeds: FEEDS.length,
    fetched: harvested.length,
    stored: fresh.length,
    byCategory,
    ranAt: new Date().toISOString(),
    method: request.method,
  });
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body, null, 2), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}
