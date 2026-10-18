import { createClient } from 'jsr:@supabase/supabase-js@2';

// Public list of the papers a visitor can buy, for the website's buy page.
// Only names, unit counts and question counts are returned -- never questions.
const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
};

Deno.serve(async (request: Request) => {
  if (request.method === 'OPTIONS') return new Response('ok', { headers: CORS_HEADERS });

  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  if (!supabaseUrl || !serviceKey) return json({ error: 'Not configured.' }, 500);

  const client = createClient(supabaseUrl, serviceKey);
  const { data, error } = await client
    .from('cbt_subject_summaries')
    .select('subject_id, subject_name, units, question_count')
    .eq('only_placeholder', false)
    .gt('question_count', 5);
  if (error) {
    console.error('catalog failed', error);
    return json({ error: 'Could not load the course list.' }, 500);
  }

  const subjects = (data ?? [])
    .map((r: { subject_id: string; subject_name: string; units: number | null; question_count: number }) => ({
      id: r.subject_id,
      name: r.subject_name,
      units: r.units ?? 0,
      questions: r.question_count,
    }))
    .sort((a: { name: string }, b: { name: string }) => a.name.localeCompare(b.name));

  return json({ subjects });
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', 'Cache-Control': 'public, max-age=300', ...CORS_HEADERS },
  });
}
