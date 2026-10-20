-- Eduvora -- emails sent to students (welcome, payment receipt, access code,
-- expiry reminder, and messages the owner writes in the app).
--
-- Run this once in the Supabase SQL editor.
--
-- email_log: one row per email. (kind, ref) is UNIQUE so the same email can
--   never be sent twice, even if a webhook or the app calls the function again.
-- email_optouts: addresses that clicked "unsubscribe" on a message from the
--   owner. Receipts and access codes are not blocked by this -- people always
--   get proof of their own payment.
--
-- Both tables are readable only by the service role (the edge functions).

create table if not exists public.email_log (
  id         uuid primary key default gen_random_uuid(),
  kind       text not null,
  ref        text not null,
  to_email   text not null,
  user_id    uuid,
  subject    text not null default '',
  status     text not null default 'pending',   -- pending | sent | failed | skipped
  error      text not null default '',
  created_at timestamptz not null default now(),
  unique (kind, ref)
);
create index if not exists email_log_user_idx on public.email_log (user_id, created_at desc);
alter table public.email_log enable row level security;

create table if not exists public.email_optouts (
  email      text primary key,
  created_at timestamptz not null default now()
);
alter table public.email_optouts enable row level security;
