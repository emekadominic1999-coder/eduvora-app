-- =============================================================================
-- Eduvora — automatic access codes (run AFTER ACCESS_CODES.sql)
-- =============================================================================
-- 1. Guest checkout: a visitor pays through Paystack on the website without an
--    account, and the system creates a one-time access code for them.
-- 2. Redeeming a code now locks the unlocked papers to the phone that typed it.
-- Safe to run more than once.
-- =============================================================================

-- ---------------------------------------------------------------- access_codes
alter table public.access_codes add column if not exists buyer_email text not null default '';
alter table public.access_codes add column if not exists payment_reference text;
alter table public.access_codes add column if not exists source text not null default 'manual';

-- ---------------------------------------------------------------- guest_orders
-- One row per guest checkout attempt, keyed by the Paystack reference. Written
-- only by the edge functions (service role); nobody signed in can read it.
create table if not exists public.guest_orders (
  reference    text primary key,
  email        text not null,
  plan         text not null check (plan in ('single_paper', 'course_pack')),
  subject_ids  jsonb not null default '[]'::jsonb,
  amount_kobo  integer not null,
  access_days  integer not null,
  status       text not null default 'pending' check (status in ('pending', 'success', 'failed')),
  code         text,
  created_at   timestamptz not null default now(),
  paid_at      timestamptz
);

alter table public.guest_orders enable row level security;
-- Deliberately no policies.

-- ----------------------------------------------------- redeem (device-locked)
-- Replaces the one-argument version. A signed-in student redeems a code; the
-- entitlements it creates are bound to the device id supplied by the app, so
-- the papers cannot be opened from any other phone.
drop function if exists public.redeem_access_code(text);

create or replace function public.redeem_access_code(p_code text, p_device_id text default null)
returns jsonb
language plpgsql
security definer
set search_path = public
as $$
declare
  v_user    uuid := auth.uid();
  v_code    public.access_codes%rowtype;
  v_subject text;
  v_expires timestamptz;
  v_count   integer := 0;
  v_device  text := nullif(trim(coalesce(p_device_id, '')), '');
begin
  if v_user is null then
    raise exception 'Sign in first.';
  end if;

  -- Lock the row so two simultaneous redemptions cannot both succeed.
  select * into v_code
    from public.access_codes
   where code = upper(regexp_replace(coalesce(p_code, ''), '[^A-Za-z0-9]', '', 'g'))
   for update;

  if not found then
    raise exception 'That code is not valid. Check it and try again.';
  end if;
  if v_code.redeemed_by is not null then
    raise exception 'That code has already been used.';
  end if;

  v_expires := now() + make_interval(days => v_code.access_days);

  for v_subject in select jsonb_array_elements_text(v_code.subject_ids) loop
    -- Replace any earlier code-based row for this paper (extends the expiry and
    -- re-binds it to this phone). Paid rows are a different plan and stay as is.
    delete from public.cbt_entitlements
     where user_id = v_user and plan = 'course_pack' and subject_id = v_subject;

    insert into public.cbt_entitlements (user_id, subject_id, plan, expires_at, bound_device_id)
    values (v_user, v_subject, 'course_pack', v_expires, v_device);
    v_count := v_count + 1;
  end loop;

  update public.access_codes
     set redeemed_by = v_user, redeemed_at = now()
   where code = v_code.code;

  return jsonb_build_object('papers', v_count, 'days', v_code.access_days);
end;
$$;

revoke all on function public.redeem_access_code(text, text) from public;
grant execute on function public.redeem_access_code(text, text) to authenticated;
