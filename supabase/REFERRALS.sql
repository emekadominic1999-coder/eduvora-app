-- =============================================================================
-- Eduvora -- student referral programme (10% commission on every purchase)
-- =============================================================================
-- A student shares their personal referral code. Anyone who signs up and
-- applies it becomes that student's "referral". From then on, EVERY verified
-- CBT payment that referral makes credits the referrer 10% of the amount
-- paid. Commission is only ever created from a real, Paystack-verified
-- payment, so it is always paid out of money already received -- never out of
-- the owner's pocket.
--
-- Security model (deliberately different from `profiles`, which students may
-- edit freely -- referral data must NOT live there):
--   * every table below has RLS on and NO insert/update/delete policy for
--     `authenticated`, so a student's client can never fabricate a referral,
--     an earning, or a payout status;
--   * the only writes come from SECURITY DEFINER functions below (called by
--     the app) and from a trigger on cbt_payments (fires when the
--     paystack-verify edge function marks a payment 'success').
--
-- Payouts are manual: a withdrawal request lands in referral_withdrawals as
-- 'pending'; the owner pays it by bank transfer and then sets status = 'paid'
-- (see the admin queries at the bottom of this file).
-- =============================================================================

-- ---------------------------------------------------------- programme settings
-- One place for the two numbers, so the app, trigger and functions agree.
create or replace function public.referral_commission_percent()
returns integer language sql immutable as $$ select 10 $$;

create or replace function public.referral_min_withdrawal_kobo()
returns integer language sql immutable as $$ select 100000 $$; -- NGN 1,000

-- -------------------------------------------------------------- referral_codes
create table if not exists public.referral_codes (
  user_id    uuid primary key references auth.users (id) on delete cascade,
  code       text not null unique,
  created_at timestamptz not null default now()
);

-- ------------------------------------------------------------------- referrals
-- One row per referred student; a student can only ever have one referrer.
create table if not exists public.referrals (
  referred_id uuid primary key references auth.users (id) on delete cascade,
  referrer_id uuid not null references auth.users (id) on delete cascade,
  created_at  timestamptz not null default now(),
  check (referrer_id <> referred_id)
);
create index if not exists referrals_referrer_idx on public.referrals (referrer_id);

-- ------------------------------------------------------------ referral_earnings
-- One row per commission-earning payment. payment_id is UNIQUE so a payment
-- can never be credited twice (the webhook and the app's own verify call can
-- both mark the same payment successful).
create table if not exists public.referral_earnings (
  id                  uuid primary key default gen_random_uuid(),
  referrer_id         uuid not null references auth.users (id) on delete cascade,
  referred_id         uuid not null references auth.users (id) on delete cascade,
  payment_id          uuid not null unique references public.cbt_payments (id) on delete cascade,
  payment_amount_kobo integer not null,
  commission_kobo     integer not null,
  created_at          timestamptz not null default now()
);
create index if not exists referral_earnings_referrer_idx
  on public.referral_earnings (referrer_id, created_at desc);

-- --------------------------------------------------------- referral_withdrawals
create table if not exists public.referral_withdrawals (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references auth.users (id) on delete cascade,
  amount_kobo    integer not null check (amount_kobo >= 100000),
  bank_name      text not null,
  account_number text not null,
  account_name   text not null,
  status         text not null default 'pending'
                   check (status in ('pending', 'paid', 'rejected')),
  note           text not null default '',
  created_at     timestamptz not null default now(),
  paid_at        timestamptz
);
create index if not exists referral_withdrawals_user_idx
  on public.referral_withdrawals (user_id, created_at desc);

-- ------------------------------------------------------------------------ RLS
alter table public.referral_codes enable row level security;
alter table public.referrals enable row level security;
alter table public.referral_earnings enable row level security;
alter table public.referral_withdrawals enable row level security;

drop policy if exists "read own referral code" on public.referral_codes;
create policy "read own referral code"
  on public.referral_codes for select to authenticated
  using (auth.uid() = user_id);

drop policy if exists "read own referral links" on public.referrals;
create policy "read own referral links"
  on public.referrals for select to authenticated
  using (auth.uid() = referrer_id or auth.uid() = referred_id);

drop policy if exists "read own referral earnings" on public.referral_earnings;
create policy "read own referral earnings"
  on public.referral_earnings for select to authenticated
  using (auth.uid() = referrer_id);

drop policy if exists "read own referral withdrawals" on public.referral_withdrawals;
create policy "read own referral withdrawals"
  on public.referral_withdrawals for select to authenticated
  using (auth.uid() = user_id);

-- No insert/update/delete policy for `authenticated` on any of the four.

-- -------------------------------------------------------------- code generator
-- 6 characters, no 0/O/1/I/L so a code read out over a phone call or copied
-- from a screenshot is hard to get wrong.
create or replace function public._new_referral_code()
returns text
language plpgsql
volatile
as $$
declare
  alphabet constant text := 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  v_code text;
  i integer;
begin
  loop
    v_code := '';
    for i in 1..6 loop
      v_code := v_code || substr(alphabet, 1 + floor(random() * length(alphabet))::integer, 1);
    end loop;
    exit when not exists (select 1 from public.referral_codes where code = v_code);
  end loop;
  return v_code;
end;
$$;

-- ------------------------------------------------- commission on verified pay
create or replace function public.credit_referral_commission()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  v_referrer uuid;
begin
  if new.status <> 'success' then
    return new;
  end if;
  if tg_op = 'UPDATE' and old.status = 'success' then
    return new;
  end if;

  select referrer_id into v_referrer
    from public.referrals
   where referred_id = new.user_id;
  if v_referrer is null then
    return new;
  end if;

  insert into public.referral_earnings
    (referrer_id, referred_id, payment_id, payment_amount_kobo, commission_kobo)
  values
    (v_referrer, new.user_id, new.id, new.amount_kobo,
     (new.amount_kobo * public.referral_commission_percent()) / 100)
  on conflict (payment_id) do nothing;

  return new;
end;
$$;

drop trigger if exists cbt_payment_referral_commission on public.cbt_payments;
create trigger cbt_payment_referral_commission
  after insert or update of status on public.cbt_payments
  for each row execute function public.credit_referral_commission();

-- ------------------------------------------------------ get_referral_summary()
-- Everything the referral screen needs, in one call. Creates the caller's
-- code on first use.
create or replace function public.get_referral_summary()
returns jsonb
language plpgsql
security definer set search_path = public
as $$
declare
  v_uid       uuid := auth.uid();
  v_code      text;
  v_earned    bigint;
  v_used      bigint;
  v_referred  bigint;
  v_has_ref   boolean;
  v_activity  jsonb;
  v_withdraws jsonb;
begin
  if v_uid is null then
    raise exception 'Sign in first.';
  end if;

  select code into v_code from public.referral_codes where user_id = v_uid;
  if v_code is null then
    insert into public.referral_codes (user_id, code)
    values (v_uid, public._new_referral_code())
    on conflict (user_id) do nothing;
    select code into v_code from public.referral_codes where user_id = v_uid;
  end if;

  select coalesce(sum(commission_kobo), 0) into v_earned
    from public.referral_earnings where referrer_id = v_uid;
  select coalesce(sum(amount_kobo), 0) into v_used
    from public.referral_withdrawals
   where user_id = v_uid and status in ('pending', 'paid');
  select count(*) into v_referred from public.referrals where referrer_id = v_uid;
  select exists (select 1 from public.referrals where referred_id = v_uid) into v_has_ref;

  select coalesce(jsonb_agg(row_to_json(t)), '[]'::jsonb) into v_activity
    from (
      select e.created_at,
             e.commission_kobo,
             e.payment_amount_kobo,
             split_part(coalesce(nullif(trim(p.full_name), ''), 'A student'), ' ', 1) as first_name
        from public.referral_earnings e
        left join public.profiles p on p.id = e.referred_id
       where e.referrer_id = v_uid
       order by e.created_at desc
       limit 50
    ) t;

  select coalesce(jsonb_agg(row_to_json(w)), '[]'::jsonb) into v_withdraws
    from (
      select id, amount_kobo, bank_name, account_number, account_name,
             status, note, created_at, paid_at
        from public.referral_withdrawals
       where user_id = v_uid
       order by created_at desc
       limit 50
    ) w;

  return jsonb_build_object(
    'code', v_code,
    'commission_percent', public.referral_commission_percent(),
    'min_withdrawal_kobo', public.referral_min_withdrawal_kobo(),
    'referred_count', v_referred,
    'total_earned_kobo', v_earned,
    'withdrawn_kobo', v_used,
    'available_kobo', greatest(v_earned - v_used, 0),
    'has_referrer', v_has_ref,
    'activity', v_activity,
    'withdrawals', v_withdraws
  );
end;
$$;

-- ----------------------------------------------------- apply_referral_code(x)
create or replace function public.apply_referral_code(p_code text)
returns jsonb
language plpgsql
security definer set search_path = public
as $$
declare
  v_uid      uuid := auth.uid();
  v_code     text := upper(trim(coalesce(p_code, '')));
  v_referrer uuid;
begin
  if v_uid is null then
    return jsonb_build_object('ok', false, 'error', 'Sign in first.');
  end if;
  if v_code = '' then
    return jsonb_build_object('ok', false, 'error', 'Enter a referral code.');
  end if;

  select user_id into v_referrer from public.referral_codes where code = v_code;
  if v_referrer is null then
    return jsonb_build_object('ok', false, 'error', 'That referral code was not found.');
  end if;
  if v_referrer = v_uid then
    return jsonb_build_object('ok', false, 'error', 'You cannot use your own referral code.');
  end if;
  if exists (select 1 from public.referrals where referred_id = v_uid) then
    return jsonb_build_object('ok', false, 'error', 'You have already used a referral code.');
  end if;
  if exists (select 1 from public.referrals
              where referrer_id = v_uid and referred_id = v_referrer) then
    return jsonb_build_object('ok', false, 'error', 'That student was referred by you, so their code cannot be used.');
  end if;
  if exists (select 1 from public.cbt_payments
              where user_id = v_uid and status = 'success') then
    return jsonb_build_object('ok', false, 'error', 'A referral code has to be added before your first purchase.');
  end if;

  insert into public.referrals (referred_id, referrer_id) values (v_uid, v_referrer);
  return jsonb_build_object('ok', true);
end;
$$;

-- ------------------------------------------- request_referral_withdrawal(...)
create or replace function public.request_referral_withdrawal(
  p_amount_kobo    integer,
  p_bank_name      text,
  p_account_number text,
  p_account_name   text
)
returns jsonb
language plpgsql
security definer set search_path = public
as $$
declare
  v_uid       uuid := auth.uid();
  v_earned    bigint;
  v_used      bigint;
  v_available bigint;
  v_bank      text := trim(coalesce(p_bank_name, ''));
  v_number    text := regexp_replace(coalesce(p_account_number, ''), '\s', '', 'g');
  v_name      text := trim(coalesce(p_account_name, ''));
  v_id        uuid;
begin
  if v_uid is null then
    return jsonb_build_object('ok', false, 'error', 'Sign in first.');
  end if;

  -- Serialise this student's requests so two taps can't both pass the
  -- balance check.
  perform pg_advisory_xact_lock(hashtext('referral-withdrawal:' || v_uid::text));

  if p_amount_kobo is null or p_amount_kobo < public.referral_min_withdrawal_kobo() then
    return jsonb_build_object('ok', false, 'error',
      'The minimum withdrawal is NGN ' || (public.referral_min_withdrawal_kobo() / 100)::text || '.');
  end if;
  if v_bank = '' or v_name = '' then
    return jsonb_build_object('ok', false, 'error', 'Enter your bank name and the name on the account.');
  end if;
  if v_number !~ '^[0-9]{10}$' then
    return jsonb_build_object('ok', false, 'error', 'Account number must be 10 digits.');
  end if;

  select coalesce(sum(commission_kobo), 0) into v_earned
    from public.referral_earnings where referrer_id = v_uid;
  select coalesce(sum(amount_kobo), 0) into v_used
    from public.referral_withdrawals
   where user_id = v_uid and status in ('pending', 'paid');
  v_available := v_earned - v_used;

  if p_amount_kobo > v_available then
    return jsonb_build_object('ok', false, 'error', 'That is more than your available balance.');
  end if;

  insert into public.referral_withdrawals
    (user_id, amount_kobo, bank_name, account_number, account_name)
  values (v_uid, p_amount_kobo, v_bank, v_number, v_name)
  returning id into v_id;

  return jsonb_build_object('ok', true, 'id', v_id);
end;
$$;

-- ---------------------------------------------------------------------- grants
revoke all on function public._new_referral_code() from public, anon, authenticated;
revoke all on function public.credit_referral_commission() from public, anon, authenticated;
revoke all on function public.get_referral_summary() from public, anon;
revoke all on function public.apply_referral_code(text) from public, anon;
revoke all on function public.request_referral_withdrawal(integer, text, text, text) from public, anon;
grant execute on function public.get_referral_summary() to authenticated;
grant execute on function public.apply_referral_code(text) to authenticated;
grant execute on function public.request_referral_withdrawal(integer, text, text, text) to authenticated;

-- =============================================================================
-- OWNER / ADMIN QUERIES (run in the Supabase SQL editor -- not part of the app)
-- =============================================================================
-- Withdrawal requests waiting for you to pay:
--   select w.id, p.full_name, w.amount_kobo / 100 as naira,
--          w.bank_name, w.account_number, w.account_name, w.created_at
--     from referral_withdrawals w join profiles p on p.id = w.user_id
--    where w.status = 'pending' order by w.created_at;
--
-- After you have sent the money by bank transfer:
--   update referral_withdrawals set status = 'paid', paid_at = now()
--    where id = '<withdrawal id>';
--
-- To refuse a request (the amount returns to the student's balance):
--   update referral_withdrawals set status = 'rejected', note = 'reason here'
--    where id = '<withdrawal id>';
--
-- Who referred whom, and what each referrer has earned:
--   select r.full_name as referrer, count(distinct rf.referred_id) as referred,
--          coalesce(sum(e.commission_kobo), 0) / 100 as earned_naira
--     from referrals rf
--     join profiles r on r.id = rf.referrer_id
--     left join referral_earnings e on e.referrer_id = rf.referrer_id
--    group by r.full_name order by earned_naira desc;
-- =============================================================================
