-- Live / active users (owner-only view)
--
-- Run this ONCE in Supabase -> SQL Editor -> New query -> paste -> Run.
--
-- What it adds:
--   * profiles.last_seen_at  - the last time a student had the app open
--                              (the app updates it every ~3 minutes while open)
--   * touch_last_seen()      - lets a signed-in student update ONLY their own
--                              last_seen_at
--   * owner_active_users()   - returns COUNTS ONLY (no names/emails) and only
--                              works for the owner's Google/email account(s);
--                              anyone else calling it gets "not allowed"
--
-- To add or change which accounts can see the numbers, edit the email list in
-- owner_active_users() below and run the block again.

alter table public.profiles
  add column if not exists last_seen_at timestamptz;

create or replace function public.touch_last_seen()
returns void
language sql
security definer
set search_path = public
as $$
  update public.profiles set last_seen_at = now() where id = auth.uid();
$$;

revoke all on function public.touch_last_seen() from public, anon;
grant execute on function public.touch_last_seen() to authenticated;

create or replace function public.owner_active_users()
returns table (
  online_now   integer,
  active_today integer,
  active_7d    integer,
  active_30d   integer,
  total_users  integer
)
language plpgsql
security definer
set search_path = public
as $$
begin
  if lower(coalesce(auth.jwt() ->> 'email', '')) not in (
    'emekadominic1999@gmail.com',
    'eduvora264@gmail.com'
  ) then
    raise exception 'not allowed';
  end if;

  return query
  select
    (count(*) filter (where last_seen_at > now() - interval '6 minutes'))::integer,
    (count(*) filter (where last_seen_at > now() - interval '24 hours'))::integer,
    (count(*) filter (where last_seen_at > now() - interval '7 days'))::integer,
    (count(*) filter (where last_seen_at > now() - interval '30 days'))::integer,
    (count(*))::integer
  from public.profiles;
end;
$$;

revoke all on function public.owner_active_users() from public, anon;
grant execute on function public.owner_active_users() to authenticated;
