-- =============================================================================
-- Device lock: one phone for the app AND one browser for the website
-- =============================================================================
-- Problem: the app and the website each make their own random device id, so a
-- student who pays on the website and then opens the app on the SAME phone was
-- told "already in use on another device".
--
-- Fix: every paid/unlocked paper can now be bound to ONE app install and ONE
-- website browser (two separate slots). It is still blocked on any second phone
-- or second browser.
--
-- Run this once in the Supabase SQL Editor. Safe to run more than once.
-- =============================================================================

alter table public.cbt_entitlements add column if not exists bound_web_device_id text;

-- The guard now allows a student to fill EITHER empty slot once, and changes
-- nothing else (not the plan, paper, expiry, or an already-filled slot).
create or replace function public.cbt_entitlements_guard_device_bind()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.role() is distinct from 'authenticated' then
    return new;
  end if;

  if new.user_id <> old.user_id
     or new.subject_id <> old.subject_id
     or new.plan <> old.plan
     or new.expires_at <> old.expires_at
     or new.payment_id is distinct from old.payment_id
     -- an already-filled slot may not change
     or (old.bound_device_id is not null and new.bound_device_id is distinct from old.bound_device_id)
     or (old.bound_web_device_id is not null and new.bound_web_device_id is distinct from old.bound_web_device_id)
     -- a slot may only be set to a real value
     or (new.bound_device_id is not null and length(trim(new.bound_device_id)) = 0)
     or (new.bound_web_device_id is not null and length(trim(new.bound_web_device_id)) = 0)
     -- and something must actually be getting bound
     or (new.bound_device_id is not distinct from old.bound_device_id
         and new.bound_web_device_id is not distinct from old.bound_web_device_id)
  then
    raise exception 'Only binding an unset device id on your own entitlement is permitted.';
  end if;

  return new;
end;
$$;

-- Start everyone fresh: earlier rows may have been tied to the browser by
-- mistake. (Only a handful of test accounts exist at this stage.)
update public.cbt_entitlements set bound_device_id = null, bound_web_device_id = null;

-- ------------------------------------------------------------------ redeem
drop function if exists public.redeem_access_code(text, text);

create or replace function public.redeem_access_code(
  p_code text,
  p_device_id text default null,
  p_platform text default 'app'
)
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
  v_web     boolean := lower(coalesce(p_platform, 'app')) = 'web';
begin
  if v_user is null then
    raise exception 'Sign in first.';
  end if;

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
    delete from public.cbt_entitlements
     where user_id = v_user and plan = 'course_pack' and subject_id = v_subject;

    insert into public.cbt_entitlements
      (user_id, subject_id, plan, expires_at, bound_device_id, bound_web_device_id)
    values
      (v_user, v_subject, 'course_pack', v_expires,
       case when v_web then null else v_device end,
       case when v_web then v_device else null end);
    v_count := v_count + 1;
  end loop;

  update public.access_codes
     set redeemed_by = v_user, redeemed_at = now()
   where code = v_code.code;

  return jsonb_build_object('papers', v_count, 'days', v_code.access_days);
end;
$$;

revoke all on function public.redeem_access_code(text, text, text) from public;
grant execute on function public.redeem_access_code(text, text, text) to authenticated;
