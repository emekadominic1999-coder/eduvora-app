import { createClient } from 'jsr:@supabase/supabase-js@2';

// "Snap a question": a signed-in student sends a photo of a question and gets
// a step-by-step solution from Google Gemini. The Gemini key lives only in
// this function's secrets (GEMINI_API_KEY), never in the app.
const DAILY_LIMIT = Number(Deno.env.get('SOLVE_DAILY_LIMIT') ?? '8');
const MODEL = Deno.env.get('GEMINI_MODEL') ?? 'gemini-2.5-flash';
const MAX_BASE64_CHARS = 6_000_000;

const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

const PROMPT = `You are Eduvora's study helper for Nigerian university students.
The image contains an exam or assignment question (it may include equations).
1. Read the question carefully and restate it in one line.
2. Solve it step by step in clear, simple English. Show every working line.
3. Finish with the final answer on its own line starting with "Answer:".
Write maths in plain text such as x^2, sqrt(x), a/b. If the image is unclear or is
not a study question, say so politely and ask for a clearer photo.
End with one short line reminding the student to check the working.`;

Deno.serve(async (request: Request) => {
  if (request.method === 'OPTIONS') return new Response('ok', { headers: CORS_HEADERS });
  if (request.method !== 'POST') return json({ error: 'POST only.' }, 405);

  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  const geminiKey = Deno.env.get('GEMINI_API_KEY');
  if (!supabaseUrl || !serviceKey || !geminiKey) {
    return json({ error: 'The solver is not set up yet.' }, 500);
  }

  const token = (request.headers.get('Authorization') ?? '').replace('Bearer ', '');
  if (!token) return json({ error: 'Sign in first.' }, 401);
  const client = createClient(supabaseUrl, serviceKey);
  const { data: userData, error: userError } = await client.auth.getUser(token);
  if (userError || !userData.user) return json({ error: 'Sign in first.' }, 401);
  const userId = userData.user.id;

  let body: { image?: string; mimeType?: string };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }
  const image = (body.image ?? '').trim();
  const mimeType = (body.mimeType ?? 'image/jpeg').trim();
  if (!image) return json({ error: 'Send a photo of the question.' }, 400);
  if (image.length > MAX_BASE64_CHARS) return json({ error: 'That photo is too large.' }, 413);
  if (!['image/jpeg', 'image/png', 'image/webp'].includes(mimeType)) {
    return json({ error: 'Use a JPG or PNG photo.' }, 400);
  }

  // Daily allowance per student, so the bill stays under control.
  const day = new Date().toISOString().slice(0, 10);
  const { data: usage } = await client
    .from('ai_solve_usage')
    .select('uses')
    .eq('user_id', userId)
    .eq('day', day)
    .maybeSingle();
  const used = usage?.uses ?? 0;
  if (used >= DAILY_LIMIT) {
    return json(
      { error: `You have used your ${DAILY_LIMIT} free solutions for today. Come back tomorrow.` },
      429,
    );
  }

  const reply = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'x-goog-api-key': geminiKey },
      body: JSON.stringify({
        contents: [
          { role: 'user', parts: [{ text: PROMPT }, { inlineData: { mimeType, data: image } }] },
        ],
        generationConfig: { temperature: 0.2, maxOutputTokens: 2048 },
      }),
    },
  );
  if (!reply.ok) {
    console.error('gemini failed', reply.status, (await reply.text()).slice(0, 300));
    return json({ error: 'The solver is busy. Please try again in a minute.' }, 502);
  }
  const result = await reply.json();
  const text: string = (result?.candidates?.[0]?.content?.parts ?? [])
    .map((p: { text?: string }) => p.text ?? '')
    .join('')
    .trim();
  if (!text) return json({ error: 'No answer came back. Try a clearer photo.' }, 502);

  await client
    .from('ai_solve_usage')
    .upsert({ user_id: userId, day, uses: used + 1 }, { onConflict: 'user_id,day' });

  return json({ solution: text, remaining: Math.max(DAILY_LIMIT - used - 1, 0) });
});

function json(payload: unknown, status = 200): Response {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { ...CORS_HEADERS, 'Content-Type': 'application/json' },
  });
}
