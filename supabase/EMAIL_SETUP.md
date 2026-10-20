# Eduvora emails: set up in about 20 minutes

What this adds:

| Email | Sent when | Who triggers it |
|---|---|---|
| Welcome | A student signs in for the first time | The app, once per student |
| Payment receipt | A payment is confirmed | `paystack-verify`, automatically |
| Access code | Someone buys a code on the website | `guest-claim` / webhook, automatically |
| Expiry reminder | Paid access ends in 2 to 4 days | A daily scheduled job |
| Your own messages | You press Send in Profile > Email students | You |

Nothing is sent until step 1 to 4 are done. Until then the app works exactly as before.

## 1. Open a Resend account (free)

1. Go to https://resend.com and sign up. The free plan allows 100 emails a day and 3,000 a month.
2. **Domains > Add domain** and enter `eduvoraapp.com.ng`.
3. Resend shows a few DNS records (TXT and MX). Add them where you manage the domain. Wait until Resend shows **Verified**.
4. **API Keys > Create API key** (Sending access). Copy it.

## 2. Add secrets in Supabase

Supabase > Edge Functions > Secrets. Add:

| Name | Value |
|---|---|
| `RESEND_API_KEY` | the key from Resend |
| `EMAIL_FROM` | `Eduvora <hello@eduvoraapp.com.ng>` (any address on the verified domain) |
| `SUPPORT_EMAIL` | the address students can reply to |
| `EMAIL_SIGNING_KEY` | any long random text, for example 40 random letters and numbers |
| `EMAIL_CRON_SECRET` | another long random text |

## 3. Run the SQL

Supabase > SQL editor > paste the contents of `supabase/EMAIL.sql` > Run.

## 4. Deploy the functions

Supabase > Edge Functions. For each one, create it (or open it) and paste the code from the matching folder:

| Function | File | Verify JWT |
|---|---|---|
| `send-email` | `functions/send-email/index.ts` | On |
| `email-unsubscribe` | `functions/email-unsubscribe/index.ts` | **Off** (people open this link without signing in) |
| `email-expiry-reminders` | `functions/email-expiry-reminders/index.ts` | **Off** (it has its own secret) |
| `paystack-verify` | `functions/paystack-verify/index.ts` | as before (receipts) |
| `guest-claim` and any function that imports `_shared/guest.ts` | as before | as before (access-code emails) |

The `_shared/email.ts` and `_shared/guest.ts` files must be uploaded with them, because the functions import them.

## 5. Daily expiry reminders (optional)

Supabase > SQL editor. Replace `YOUR_CRON_SECRET` with the same value you used for `EMAIL_CRON_SECRET`:

```sql
create extension if not exists pg_cron;
create extension if not exists pg_net;

select cron.schedule(
  'eduvora-expiry-reminders',
  '0 7 * * *',
  $$
  select net.http_post(
    url := 'https://wdsvzhxhqzblpekdmsqs.supabase.co/functions/v1/email-expiry-reminders',
    headers := jsonb_build_object('x-cron-secret', 'YOUR_CRON_SECRET', 'Content-Type', 'application/json'),
    body := '{}'::jsonb
  );
  $$
);
```

## 6. Try it

1. Open the app, sign in with a new test account: the welcome email should arrive within a minute.
2. Profile > **Email students** (only you see this) > keep the audience on **Only me (a test)**, write a subject and message, and send. The email should reach your own inbox. Only then choose a bigger audience.
3. Make a small payment: the receipt should arrive.

## Good to know

- Emails are never sent twice: `email_log` keeps a record of each one. Look at that table if a student says an email did not arrive (`status` is `sent`, `failed` or `skipped`).
- Anyone who clicks the unsubscribe link in one of your messages stops getting your messages, but still gets receipts and access codes.
- One send from Profile is limited to 500 people. The free Resend plan allows 100 emails a day, so for larger lists upgrade the plan first.
