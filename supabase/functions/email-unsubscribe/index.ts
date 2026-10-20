import { createClient } from 'jsr:@supabase/supabase-js@2';

import { escapeHtml, SITE_URL, unsubscribeTokenValid } from '../_shared/email.ts';

// The link at the bottom of messages the owner sends. Opening it adds the
// address to email_optouts. The token is a signature of the address, so one
// person cannot unsubscribe somebody else by guessing.

Deno.serve(async (request: Request) => {
  const url = new URL(request.url);
  const email = (url.searchParams.get('e') ?? '').trim().toLowerCase();
  const token = url.searchParams.get('t') ?? '';

  const supabaseUrl = Deno.env.get('SUPABASE_URL');
  const serviceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
  if (!supabaseUrl || !serviceKey) return page('Something went wrong', 'Please try again later.', 500);

  if (!email || !(await unsubscribeTokenValid(email, token))) {
    return page('This link is not valid', 'Please use the link from the most recent email.', 400);
  }
  const client = createClient(supabaseUrl, serviceKey);
  const { error } = await client.from('email_optouts').upsert({ email });
  if (error) return page('Something went wrong', 'Please try again later.', 500);
  return page('You are unsubscribed', `${escapeHtml(email)} will no longer get messages from Eduvora. You will still get receipts for your own payments.`, 200);
});

function page(title: string, text: string, status: number): Response {
  const html = `<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>${title}</title></head>
<body style="margin:0;font-family:Segoe UI,Roboto,Arial,sans-serif;background:#f1f5f9;display:flex;min-height:100vh;align-items:center;justify-content:center;padding:16px">
<div style="background:#fff;border-radius:16px;padding:32px;max-width:420px;text-align:center;color:#1e293b">
<h1 style="font-size:22px;margin:0 0 12px">${title}</h1><p style="line-height:1.6;margin:0 0 20px">${text}</p>
<a href="${SITE_URL}" style="color:#2563eb;font-weight:700">Go to Eduvora</a></div></body></html>`;
  return new Response(html, { status, headers: { 'Content-Type': 'text/html; charset=utf-8' } });
}
