// Sending email through Resend (https://resend.com), plus the branded layout
// and every message template, so the look and the wording live in one place.
//
// Secrets (Supabase -> Edge Functions -> Secrets):
//   RESEND_API_KEY      the API key from the Resend dashboard
//   EMAIL_FROM          optional, default "Eduvora <hello@eduvoraapp.com.ng>"
//   EMAIL_SIGNING_KEY   any long random text; signs the unsubscribe links
//
// If RESEND_API_KEY is not set, nothing is sent and nothing breaks: callers get
// { sent: false, reason: 'not configured' } and carry on.

export const SITE_URL = 'https://eduvoraapp.com.ng';
export const SUPPORT_EMAIL = Deno.env.get('SUPPORT_EMAIL') ?? 'hello@eduvora.ng';
export const OWNER_EMAILS = ['emekadominic1999@gmail.com', 'eduvora264@gmail.com'];

const FROM = Deno.env.get('EMAIL_FROM') ?? 'Eduvora <hello@eduvoraapp.com.ng>';

export interface SendOptions {
  to: string;
  subject: string;
  html: string;
  /** What kind of email this is, e.g. 'welcome'. Part of the "send once" key. */
  kind: string;
  /** Anything that makes this email unique, e.g. a payment reference. */
  ref: string;
  userId?: string;
  /** Messages the owner writes. These honour unsubscribes; receipts do not. */
  marketing?: boolean;
}

export async function sendEmail(
  // deno-lint-ignore no-explicit-any
  client: any,
  options: SendOptions,
): Promise<{ sent: boolean; reason?: string }> {
  const apiKey = Deno.env.get('RESEND_API_KEY');
  const to = options.to.trim().toLowerCase();
  if (!apiKey) return { sent: false, reason: 'not configured' };
  if (!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(to)) return { sent: false, reason: 'bad address' };

  if (options.marketing) {
    const { data: out } = await client.from('email_optouts').select('email').eq('email', to).maybeSingle();
    if (out) return { sent: false, reason: 'unsubscribed' };
  }

  // Reserve this (kind, ref) first. If it already exists, this email was sent.
  const { error: reserveError } = await client.from('email_log').insert({
    kind: options.kind,
    ref: options.ref,
    to_email: to,
    user_id: options.userId ?? null,
    subject: options.subject,
    status: 'pending',
  });
  if (reserveError) {
    if (reserveError.code === '23505') return { sent: false, reason: 'already sent' };
    console.error('email_log insert failed', reserveError);
    return { sent: false, reason: 'log error' };
  }

  try {
    const response = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: { Authorization: `Bearer ${apiKey}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({
        from: FROM,
        to: [to],
        reply_to: SUPPORT_EMAIL,
        subject: options.subject,
        html: options.html,
      }),
    });
    if (!response.ok) {
      const text = await response.text();
      console.error('resend failed', response.status, text);
      await client.from('email_log').update({ status: 'failed', error: text.slice(0, 500) })
        .eq('kind', options.kind).eq('ref', options.ref);
      return { sent: false, reason: `provider ${response.status}` };
    }
    await client.from('email_log').update({ status: 'sent' }).eq('kind', options.kind).eq('ref', options.ref);
    return { sent: true };
  } catch (error) {
    await client.from('email_log').update({ status: 'failed', error: String(error).slice(0, 500) })
      .eq('kind', options.kind).eq('ref', options.ref);
    return { sent: false, reason: 'network' };
  }
}

// ------------------------------------------------------------- unsubscribe

async function hmacHex(text: string): Promise<string> {
  const secret = Deno.env.get('EMAIL_SIGNING_KEY') ?? 'eduvora-email';
  const key = await crypto.subtle.importKey(
    'raw',
    new TextEncoder().encode(secret),
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const sig = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(text));
  return [...new Uint8Array(sig)].map((b) => b.toString(16).padStart(2, '0')).join('');
}

export async function unsubscribeUrl(email: string): Promise<string> {
  const base = Deno.env.get('SUPABASE_URL') ?? '';
  const e = email.trim().toLowerCase();
  return `${base}/functions/v1/email-unsubscribe?e=${encodeURIComponent(e)}&t=${await hmacHex(e)}`;
}

export async function unsubscribeTokenValid(email: string, token: string): Promise<boolean> {
  return (await hmacHex(email.trim().toLowerCase())) === token;
}

// ----------------------------------------------------------------- layout

export function escapeHtml(text: string): string {
  return text.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

/// Turns plain text the owner typed into safe HTML: blank lines become new
/// paragraphs and single line breaks stay line breaks. Nothing typed is ever
/// treated as HTML.
export function textToHtml(text: string): string {
  return text
    .split(/\n{2,}/)
    .map((p) => `<p style="margin:0 0 14px;line-height:1.6">${escapeHtml(p).replace(/\n/g, '<br>')}</p>`)
    .join('');
}

function button(label: string, href: string): string {
  return `<p style="margin:22px 0"><a href="${href}" style="background:#2563eb;color:#ffffff;text-decoration:none;font-weight:700;padding:12px 22px;border-radius:10px;display:inline-block">${escapeHtml(label)}</a></p>`;
}

function layout(heading: string, body: string, footer: string): string {
  return `<!doctype html><html><body style="margin:0;background:#f1f5f9;padding:24px 12px;font-family:Segoe UI,Roboto,Arial,sans-serif;color:#1e293b">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0"><tr><td align="center">
<table role="presentation" width="100%" style="max-width:560px;background:#ffffff;border-radius:16px;overflow:hidden" cellpadding="0" cellspacing="0">
<tr><td style="background:#2563eb;padding:20px 28px;color:#ffffff;font-size:20px;font-weight:800">Eduvora</td></tr>
<tr><td style="padding:28px">
<h1 style="margin:0 0 16px;font-size:21px;line-height:1.3">${escapeHtml(heading)}</h1>
${body}
</td></tr>
<tr><td style="padding:16px 28px 24px;font-size:12px;color:#64748b;line-height:1.6;border-top:1px solid #e2e8f0">${footer}</td></tr>
</table></td></tr></table></body></html>`;
}

const STANDARD_FOOTER =
  `You are receiving this because you have an Eduvora account. Questions? Reply to this email or write to ${SUPPORT_EMAIL}.`;

// -------------------------------------------------------------- templates

export function welcomeEmail(name: string): { subject: string; html: string } {
  const first = escapeHtml((name || 'there').trim().split(/\s+/)[0]);
  return {
    subject: 'Welcome to Eduvora',
    html: layout(
      `Welcome, ${first}!`,
      `<p style="margin:0 0 14px;line-height:1.6">Thank you for joining Eduvora. Here is what you can do:</p>
<ul style="margin:0 0 14px;padding-left:20px;line-height:1.8">
<li>Practise CBT exams for your own courses, with explanations for every answer</li>
<li>Read your course outlines and study materials</li>
<li>Work out your GP and CGPA, and keep every semester</li>
</ul>
<p style="margin:0 0 14px;line-height:1.6">Start with a free try on any paper, and tell your classmates about Eduvora when you find it useful.</p>
${button('Open Eduvora', SITE_URL)}`,
      STANDARD_FOOTER,
    ),
  };
}

function naira(kobo: number): string {
  return 'NGN ' + (kobo / 100).toLocaleString('en-NG', { maximumFractionDigits: 0 });
}

export function receiptEmail(opts: {
  planLabel: string;
  amountKobo: number;
  reference: string;
  expiresAt: string;
  papers: string[];
}): { subject: string; html: string } {
  const until = new Date(opts.expiresAt).toLocaleDateString('en-GB', { day: 'numeric', month: 'long', year: 'numeric' });
  const list = opts.papers.length
    ? `<p style="margin:0 0 6px;font-weight:700">Papers unlocked</p><ul style="margin:0 0 14px;padding-left:20px;line-height:1.7">${opts.papers.slice(0, 30).map((p) => `<li>${escapeHtml(p)}</li>`).join('')}</ul>`
    : '';
  return {
    subject: 'Your Eduvora payment was received',
    html: layout(
      'Payment received',
      `<p style="margin:0 0 14px;line-height:1.6">Thank you. Your access is now active.</p>
<table role="presentation" cellpadding="0" cellspacing="0" style="margin:0 0 16px;font-size:14px;line-height:1.9">
<tr><td style="padding-right:18px;color:#64748b">Plan</td><td><b>${escapeHtml(opts.planLabel)}</b></td></tr>
<tr><td style="padding-right:18px;color:#64748b">Amount</td><td><b>${naira(opts.amountKobo)}</b></td></tr>
<tr><td style="padding-right:18px;color:#64748b">Access until</td><td><b>${until}</b></td></tr>
<tr><td style="padding-right:18px;color:#64748b">Reference</td><td>${escapeHtml(opts.reference)}</td></tr>
</table>
${list}
${button('Start practising', SITE_URL)}`,
      `Keep this email as your receipt. If anything looks wrong, reply to this email or write to ${SUPPORT_EMAIL} with the reference above.`,
    ),
  };
}

export function codeEmail(opts: {
  code: string;
  amountKobo: number;
  reference: string;
  accessDays: number;
}): { subject: string; html: string } {
  return {
    subject: 'Your Eduvora access code',
    html: layout(
      'Your access code',
      `<p style="margin:0 0 14px;line-height:1.6">Thank you for your payment of <b>${naira(opts.amountKobo)}</b>. Here is your access code:</p>
<p style="margin:0 0 18px;font-size:26px;font-weight:800;letter-spacing:3px;background:#eff6ff;border-radius:12px;padding:16px;text-align:center">${escapeHtml(opts.code)}</p>
<p style="margin:0 0 14px;line-height:1.6">Open the Eduvora app, go to a locked paper, choose <b>Have a code?</b> and enter it. The code works for <b>${opts.accessDays} days</b> once you use it, and it locks to one phone, so enter it on the phone you will study with.</p>
${button('Open Eduvora', SITE_URL)}`,
      `Keep this email. Payment reference: ${escapeHtml(opts.reference)}. Need help? Write to ${SUPPORT_EMAIL}.`,
    ),
  };
}

export function expiryEmail(opts: { name: string; expiresAt: string; papers: string[] }): { subject: string; html: string } {
  const first = escapeHtml((opts.name || 'there').trim().split(/\s+/)[0]);
  const on = new Date(opts.expiresAt).toLocaleDateString('en-GB', { day: 'numeric', month: 'long' });
  const list = opts.papers.length
    ? `<ul style="margin:0 0 14px;padding-left:20px;line-height:1.7">${opts.papers.slice(0, 12).map((p) => `<li>${escapeHtml(p)}</li>`).join('')}</ul>`
    : '';
  return {
    subject: `Your Eduvora access ends on ${on}`,
    html: layout(
      `${first}, your access is ending soon`,
      `<p style="margin:0 0 14px;line-height:1.6">Your access to these papers ends on <b>${on}</b>:</p>
${list}
<p style="margin:0 0 14px;line-height:1.6">Revise as much as you can before then. If you still need them after that date, you can renew from the app.</p>
${button('Open Eduvora', SITE_URL)}`,
      STANDARD_FOOTER,
    ),
  };
}

export async function broadcastEmail(opts: {
  subject: string;
  message: string;
  to: string;
}): Promise<{ subject: string; html: string }> {
  const unsub = await unsubscribeUrl(opts.to);
  return {
    subject: opts.subject,
    html: layout(
      opts.subject,
      `${textToHtml(opts.message)}${button('Open Eduvora', SITE_URL)}`,
      `${STANDARD_FOOTER}<br><a href="${unsub}" style="color:#64748b">Unsubscribe from messages like this</a>`,
    ),
  };
}
