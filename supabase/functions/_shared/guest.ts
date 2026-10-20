import { codeEmail, sendEmail } from './email.ts';

// Shared helpers for guest checkout: a visitor pays through Paystack without
// an account and is handed a one-time access code. Prices and limits live here
// so the checkout and the verification can never disagree.

export const SINGLE_PAPER_KOBO = 35000; // NGN 350
export const COURSE_PACK_KOBO = 230000; // NGN 2,300 flat
export const SINGLE_PAPER_ACCESS_DAYS = 200;
export const COURSE_PACK_ACCESS_DAYS = 130;
export const MAX_COURSE_PACK_UNITS = 23;

// No 0/O/1/I/L so a code read off a screen or a chat message is hard to mistype.
const CODE_ALPHABET = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';

/// A random code in groups of four, e.g. "K7M2-9QXP-4DTR" (stored without dashes).
export function newAccessCode(): string {
  const bytes = new Uint8Array(12);
  crypto.getRandomValues(bytes);
  let out = '';
  for (const b of bytes) out += CODE_ALPHABET[b % CODE_ALPHABET.length];
  return out;
}

export function formatCode(code: string): string {
  return code.match(/.{1,4}/g)?.join('-') ?? code;
}

/// Confirms a guest order with Paystack and, the first time it is seen as paid,
/// creates the access code. Safe to call repeatedly (webhook + the visitor's own
/// page both call it): the code is only ever created once.
export async function settleGuestOrder(
  // deno-lint-ignore no-explicit-any
  client: any,
  paystackSecret: string,
  reference: string,
): Promise<{ found: boolean; paid: boolean; code?: string }> {
  const { data: order } = await client
    .from('guest_orders')
    .select('*')
    .eq('reference', reference)
    .maybeSingle();
  if (!order) return { found: false, paid: false };

  if (order.status === 'success' && order.code) {
    return { found: true, paid: true, code: order.code };
  }

  const verifyResponse = await fetch(
    `https://api.paystack.co/transaction/verify/${encodeURIComponent(reference)}`,
    { headers: { Authorization: `Bearer ${paystackSecret}` } },
  );
  const verifyData = await verifyResponse.json();

  const paidOk = verifyResponse.ok &&
    verifyData.status &&
    verifyData.data?.status === 'success' &&
    verifyData.data?.amount === order.amount_kobo &&
    verifyData.data?.currency === 'NGN';

  if (!paidOk) {
    if (verifyData.data?.status === 'failed') {
      await client.from('guest_orders').update({ status: 'failed' }).eq('reference', reference);
    }
    return { found: true, paid: false };
  }

  // Claim the right to create the code: only the caller whose update matches a
  // row that still has no code goes on to create one.
  const code = newAccessCode();
  const { data: claimed } = await client
    .from('guest_orders')
    .update({ status: 'success', code, paid_at: new Date().toISOString() })
    .eq('reference', reference)
    .is('code', null)
    .select('code');

  if (!claimed || claimed.length === 0) {
    // Someone else (the webhook) got there first: return their code.
    const { data: again } = await client
      .from('guest_orders')
      .select('code')
      .eq('reference', reference)
      .maybeSingle();
    return { found: true, paid: true, code: again?.code ?? undefined };
  }

  const { error: codeError } = await client.from('access_codes').insert({
    code,
    subject_ids: order.subject_ids,
    access_days: order.access_days,
    note: `Paystack ${reference}`,
    buyer_email: order.email,
    payment_reference: reference,
    source: 'paystack',
  });
  if (codeError) {
    console.error('access code insert failed', codeError);
    // Roll back so the next call can try again rather than hand out a dead code.
    await client.from('guest_orders').update({ status: 'pending', code: null }).eq('reference', reference);
    return { found: true, paid: false };
  }

  // Email the code too, so a buyer who closes the page never loses it.
  try {
    if (order.email) {
      const mail = codeEmail({
        code: formatCode(code),
        amountKobo: order.amount_kobo,
        reference,
        accessDays: order.access_days,
      });
      await sendEmail(client, { to: order.email, kind: 'code', ref: reference, ...mail });
    }
  } catch (error) {
    console.error('code email failed', error);
  }

  return { found: true, paid: true, code };
}
