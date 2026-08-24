-- =============================================================================
-- Device-binding for paid CBT entitlements.
-- =============================================================================
-- Problem: a student pays for a paper, then logs their own account into a
-- friend's phone so the friend can sit it too, without paying. Login alone
-- doesn't stop this since it's the same real account either way.
--
-- Fix: the first time a paid entitlement is used, the app records a random
-- per-install device id on that row (bound_device_id). Every later use of
-- that same entitlement checks the current device's id against it; a
-- mismatch (different phone/browser) blocks access with a message telling
-- them to contact support if they've genuinely switched devices.
--
-- Not airtight -- clearing app storage/reinstalling resets what "this
-- device" means, so a determined student can still get around it. It's a
-- real deterrent against casual login-sharing, not perfect security.
-- =============================================================================

alter table public.cbt_entitlements
  add column if not exists bound_device_id text;

-- Lets a signed-in student set bound_device_id exactly once (null -> a
-- value) on their own row, and touch nothing else about it -- not the
-- plan, subject, expiry, or an already-bound device id. Edge functions
-- (service role) and direct admin/database-owner connections are
-- unrestricted, since auth.role() is only 'authenticated' for real
-- end-user API calls.
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
     or old.bound_device_id is not null
     or new.bound_device_id is null
     or length(trim(new.bound_device_id)) = 0
  then
    raise exception 'Only binding an unset device id on your own entitlement is permitted.';
  end if;

  return new;
end;
$$;

drop trigger if exists cbt_entitlements_guard_device_bind_trg on public.cbt_entitlements;
create trigger cbt_entitlements_guard_device_bind_trg
  before update on public.cbt_entitlements
  for each row execute function public.cbt_entitlements_guard_device_bind();

drop policy if exists "students bind their own device once" on public.cbt_entitlements;
create policy "students bind their own device once"
  on public.cbt_entitlements for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
