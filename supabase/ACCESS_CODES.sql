-- =============================================================================
-- Eduvora — access codes (pay on your own channel, enter a code in the app)
-- =============================================================================
-- A code is created by the owner (see the make_codes script), sold by any
-- means (WhatsApp, transfer, website), and typed into the app by the student.
-- Redeeming it writes ordinary cbt_entitlements rows -- one per paper the code
-- covers -- so everything downstream (paywall checks, device binding, expiry)
-- works exactly as it does for a Paystack purchase.
--
-- Students can neither read the codes table nor insert entitlements directly;
-- the ONLY way in is redeem_access_code(), which checks the code atomically so
-- one code can never be redeemed twice.
-- =============================================================================

create table if not exists public.access_codes (
  code         text primary key,
  subject_ids  jsonb not null default '[]'::jsonb,
  access_days  integer not null default 120 check (access_days > 0),
  note         text not null default '',
  created_at   timestamptz not null default now(),
  redeemed_by  uuid references auth.users (id) on delete set null,
  redeemed_at  timestamptz
);

alter table public.access_codes enable row level security;
-- Deliberately no policies: no signed-in student can select/insert/update.

create or replace function public.redeem_access_code(p_code text)
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
    insert into public.cbt_entitlements (user_id, subject_id, plan, expires_at)
    values (v_user, v_subject, 'course_pack', v_expires)
    on conflict (user_id, plan, subject_id)
    do update set expires_at = greatest(public.cbt_entitlements.expires_at, excluded.expires_at);
    v_count := v_count + 1;
  end loop;

  update public.access_codes
     set redeemed_by = v_user, redeemed_at = now()
   where code = v_code.code;

  return jsonb_build_object('papers', v_count, 'days', v_code.access_days);
end;
$$;

revoke all on function public.redeem_access_code(text) from public;
grant execute on function public.redeem_access_code(text) to authenticated;
