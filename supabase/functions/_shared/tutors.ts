// Shared rules for the tutor marketplace. Kept in one place so the
// commission rate and the verification bar can never drift between the
// functions that enforce them.

/// Eduvora's cut of every session, as a fraction of what the student pays.
export const PLATFORM_COMMISSION = 0.15;

/// The CBT score a tutor must have on a paper before they may list it.
/// Verified against cbt_attempts server-side, never taken from the client.
export const TUTOR_MIN_SCORE = 75;

/// Sanity bounds on an hourly rate, in kobo (₦500 – ₦10,000 an hour).
export const MIN_HOURLY_RATE_KOBO = 50000;
export const MAX_HOURLY_RATE_KOBO = 1000000;

/// The smallest balance a tutor may withdraw, in kobo (₦1,000) — keeps the
/// manual transfer workload proportionate to the amount being moved.
export const MIN_PAYOUT_KOBO = 100000;

export interface SessionPricing {
  amountKobo: number;
  platformFeeKobo: number;
  tutorEarningsKobo: number;
}

/// Splits a session's price between Eduvora and the tutor. The fee is
/// rounded and the tutor takes the remainder, so the two always sum back to
/// exactly what the student was charged — no lost or invented kobo.
export function priceSession(
  hourlyRateKobo: number,
  durationMinutes: number,
): SessionPricing {
  const amountKobo = Math.round((hourlyRateKobo * durationMinutes) / 60);
  const platformFeeKobo = Math.round(amountKobo * PLATFORM_COMMISSION);
  return {
    amountKobo,
    platformFeeKobo,
    tutorEarningsKobo: amountKobo - platformFeeKobo,
  };
}

export const CORS_HEADERS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers':
    'authorization, x-client-info, apikey, content-type, x-paystack-signature',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
};

export function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS_HEADERS },
  });
}

/// The best percentage this student has ever scored on a given paper.
/// Returns 0 when they have never sat it.
export async function bestCbtScore(
  // deno-lint-ignore no-explicit-any
  client: any,
  userId: string,
  subjectId: string,
): Promise<number> {
  const { data, error } = await client
    .from('cbt_attempts')
    .select('score, total_questions')
    .eq('user_id', userId)
    .eq('subject_id', subjectId);
  if (error || !data || data.length === 0) return 0;

  let best = 0;
  for (const attempt of data) {
    const total = attempt.total_questions ?? 0;
    if (total <= 0) continue;
    const percentage = ((attempt.score ?? 0) / total) * 100;
    if (percentage > best) best = percentage;
  }
  return Math.round(best);
}
