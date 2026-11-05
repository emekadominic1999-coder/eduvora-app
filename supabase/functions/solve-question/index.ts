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

  let body: {
    mode?: string;
    image?: string;
    mimeType?: string;
    courseCode?: string;
    courseTitle?: string;
    topics?: string[];
    count?: number;
    images?: string[];
  };
  try {
    body = await request.json();
  } catch {
    return json({ error: 'Bad request body.' }, 400);
  }
  if (body.mode === 'generate') {
    return await generateTheory(client, geminiKey, userId, body);
  }
  if (body.mode === 'notes') {
    return await questionsFromNotes(client, geminiKey, userId, body);
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

const GEN_DAILY_LIMIT = Number(Deno.env.get('GENERATE_DAILY_LIMIT') ?? '6');

// "Generate theory": the student picks a course, topics and how many questions
// they want, and gets a fresh set of exam-style written questions with answers.
async function generateTheory(
  client: ReturnType<typeof createClient>,
  geminiKey: string,
  userId: string,
  body: { courseCode?: string; courseTitle?: string; topics?: string[]; count?: number },
): Promise<Response> {
  const code = (body.courseCode ?? '').trim().slice(0, 20);
  const title = (body.courseTitle ?? '').trim().slice(0, 120);
  if (!code && !title) return json({ error: 'Choose a course first.' }, 400);
  const topics = (body.topics ?? []).map((t) => String(t).trim().slice(0, 100)).filter(Boolean).slice(0, 12);
  const count = Math.min(Math.max(Math.round(Number(body.count ?? 5)), 5), 15);

  const day = new Date().toISOString().slice(0, 10);
  const { data: usage } = await client
    .from('ai_solve_usage')
    .select('uses, gen_uses')
    .eq('user_id', userId)
    .eq('day', day)
    .maybeSingle();
  const genUsed = usage?.gen_uses ?? 0;
  if (genUsed >= GEN_DAILY_LIMIT) {
    return json(
      { error: `You have used your ${GEN_DAILY_LIMIT} free question sets for today. Come back tomorrow.` },
      429,
    );
  }

  const prompt = `You are an experienced Nigerian university lecturer setting a written (theory) exam.
Course: ${code} ${title}
Topics: ${topics.length ? topics.join(', ') : 'the main topics of this course'}
Write exactly ${count} different theory questions in the style of a university exam paper.
Mix definitions, explanations, derivations or calculations where the course needs them.
For each question give: the question, the marks (3 to 10), a clear complete model answer a student can
learn from, and 3 to 6 short key points. Use plain text for maths such as x^2, sqrt(x), a/b.
Only include facts you are sure are correct. Return JSON only.`;

  const schema = {
    type: 'OBJECT',
    properties: {
      questions: {
        type: 'ARRAY',
        items: {
          type: 'OBJECT',
          properties: {
            question: { type: 'STRING' },
            marks: { type: 'INTEGER' },
            answer: { type: 'STRING' },
            keyPoints: { type: 'ARRAY', items: { type: 'STRING' } },
            topic: { type: 'STRING' },
          },
          required: ['question', 'marks', 'answer', 'keyPoints'],
        },
      },
    },
    required: ['questions'],
  };

  const reply = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'x-goog-api-key': geminiKey },
      body: JSON.stringify({
        contents: [{ role: 'user', parts: [{ text: prompt }] }],
        generationConfig: {
          temperature: 0.7,
          maxOutputTokens: 8192,
          responseMimeType: 'application/json',
          responseSchema: schema,
        },
      }),
    },
  );
  if (!reply.ok) {
    console.error('gemini generate failed', reply.status, (await reply.text()).slice(0, 300));
    return json({ error: 'The question maker is busy. Please try again in a minute.' }, 502);
  }
  const result = await reply.json();
  const text: string = (result?.candidates?.[0]?.content?.parts ?? [])
    .map((p: { text?: string }) => p.text ?? '')
    .join('')
    .trim();
  let questions: unknown[] = [];
  try {
    questions = JSON.parse(text)?.questions ?? [];
  } catch {
    questions = [];
  }
  if (!Array.isArray(questions) || questions.length === 0) {
    return json({ error: 'No questions came back. Please try again.' }, 502);
  }

  await client
    .from('ai_solve_usage')
    .upsert(
      { user_id: userId, day, uses: usage?.uses ?? 0, gen_uses: genUsed + 1 },
      { onConflict: 'user_id,day' },
    );

  return json({ questions, remaining: Math.max(GEN_DAILY_LIMIT - genUsed - 1, 0) });
}

// "Study from my notes": the student sends photos of the pages they are
// studying and gets exam-style questions and model answers taken only from
// those pages.
async function questionsFromNotes(
  client: ReturnType<typeof createClient>,
  geminiKey: string,
  userId: string,
  body: { images?: string[]; count?: number; topics?: string[] },
): Promise<Response> {
  const images = (body.images ?? []).filter((i) => typeof i === 'string' && i.length > 100).slice(0, 6);
  if (images.length === 0) return json({ error: 'Add photos of your notes first.' }, 400);
  const total = images.reduce((n, i) => n + i.length, 0);
  if (total > 9_000_000) return json({ error: 'Those photos are too large. Use fewer pages.' }, 413);
  const count = Math.min(Math.max(Math.round(Number(body.count ?? 5)), 5), 15);
  const topics = (body.topics ?? []).map((t) => String(t).trim().slice(0, 100)).filter(Boolean).slice(0, 8);

  const day = new Date().toISOString().slice(0, 10);
  const { data: usage } = await client
    .from('ai_solve_usage')
    .select('uses, gen_uses')
    .eq('user_id', userId)
    .eq('day', day)
    .maybeSingle();
  const genUsed = usage?.gen_uses ?? 0;
  if (genUsed >= GEN_DAILY_LIMIT) {
    return json(
      { error: `You have used your ${GEN_DAILY_LIMIT} free question sets for today. Come back tomorrow.` },
      429,
    );
  }

  const prompt = `You are an experienced Nigerian university lecturer.
The images are pages from a student's textbook or lecture notes.
Write exactly ${count} different written (theory) exam questions based ONLY on what these pages teach.
${topics.length ? 'Focus on these topics where the pages cover them: ' + topics.join(', ') + '.' : ''}
For each question give: the question, the marks (3 to 10), a clear complete model answer built from the
content of the pages (use the same terms and definitions as the pages), 3 to 6 short key points, and the
topic. Do not use facts that are not in the pages. If the pages contain too little for ${count} good
questions, write fewer. If the images are unreadable or are not study notes, return an empty list.
Use plain text for maths such as x^2, sqrt(x), a/b. Return JSON only.`;

  const parts: unknown[] = [{ text: prompt }];
  for (const data of images) parts.push({ inlineData: { mimeType: 'image/jpeg', data } });

  const schema = {
    type: 'OBJECT',
    properties: {
      questions: {
        type: 'ARRAY',
        items: {
          type: 'OBJECT',
          properties: {
            question: { type: 'STRING' },
            marks: { type: 'INTEGER' },
            answer: { type: 'STRING' },
            keyPoints: { type: 'ARRAY', items: { type: 'STRING' } },
            topic: { type: 'STRING' },
          },
          required: ['question', 'marks', 'answer', 'keyPoints'],
        },
      },
    },
    required: ['questions'],
  };

  const reply = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${MODEL}:generateContent`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'x-goog-api-key': geminiKey },
      body: JSON.stringify({
        contents: [{ role: 'user', parts }],
        generationConfig: {
          temperature: 0.4,
          maxOutputTokens: 8192,
          responseMimeType: 'application/json',
          responseSchema: schema,
        },
      }),
    },
  );
  if (!reply.ok) {
    console.error('gemini notes failed', reply.status, (await reply.text()).slice(0, 300));
    return json({ error: 'The question maker is busy. Please try again in a minute.' }, 502);
  }
  const result = await reply.json();
  const text: string = (result?.candidates?.[0]?.content?.parts ?? [])
    .map((p: { text?: string }) => p.text ?? '')
    .join('')
    .trim();
  let questions: unknown[] = [];
  try {
    questions = JSON.parse(text)?.questions ?? [];
  } catch {
    questions = [];
  }
  if (!Array.isArray(questions) || questions.length === 0) {
    return json({ error: 'Could not read questions from those pages. Try clearer photos of the text.' }, 422);
  }

  await client
    .from('ai_solve_usage')
    .upsert(
      { user_id: userId, day, uses: usage?.uses ?? 0, gen_uses: genUsed + 1 },
      { onConflict: 'user_id,day' },
    );

  return json({ questions, remaining: Math.max(GEN_DAILY_LIMIT - genUsed - 1, 0) });
}
