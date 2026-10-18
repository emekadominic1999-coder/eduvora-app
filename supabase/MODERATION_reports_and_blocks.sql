-- =============================================================================
-- Eduvora — reporting content and blocking other students
-- =============================================================================
-- Run this ONCE in Supabase -> SQL Editor -> New query -> paste -> Run.
-- Safe to run more than once.
--
-- What it adds:
--   * content_reports  - a report a signed-in student files against a group
--                        message, a community post, or a community comment.
--                        Write-only from the client: a student can file their
--                        own report but can never read any report back
--                        (their own or anyone else's). The app owner reads
--                        them through owner_content_reports() below, which
--                        runs as security definer and checks the signed-in
--                        email itself -- the same pattern as
--                        owner_active_users() in ACTIVE_USERS.sql.
--   * user_blocks      - "I do not want to see this student's content any
--                        more." A student may only add or remove their own
--                        blocks, and may only ever read their own block
--                        list -- never who has blocked them.
--
-- Client side, ModerationRepository (lib/core/services/moderation_repository.dart)
-- is what writes content_reports and user_blocks, and GroupRepository /
-- CommunityRepository filter out a blocked student's messages, posts and
-- comments before they ever reach the screen.
-- =============================================================================

create extension if not exists "pgcrypto";

-- =============================================================================
-- 1. TABLES
-- =============================================================================

-- ---------------------------------------------------------------- content_reports
create table if not exists public.content_reports (
  id           uuid primary key default gen_random_uuid(),
  reporter_id  uuid not null references auth.users (id) on delete cascade,
  -- 'group_message' | 'community_post' | 'community_comment' -- kept as plain
  -- text rather than an enum so a new surface can report into this table
  -- without a migration.
  content_type text not null,
  content_id   text not null,
  reason       text not null,
  note         text not null default '',
  status       text not null default 'open',
  created_at   timestamptz not null default now()
);

create index if not exists content_reports_reporter_idx
  on public.content_reports (reporter_id);
create index if not exists content_reports_content_idx
  on public.content_reports (content_type, content_id);

alter table public.content_reports enable row level security;

-- -------------------------------------------------------------------- user_blocks
create table if not exists public.user_blocks (
  blocker_id uuid not null references auth.users (id) on delete cascade,
  blocked_id uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (blocker_id, blocked_id)
);

create index if not exists user_blocks_blocked_idx on public.user_blocks (blocked_id);

alter table public.user_blocks enable row level security;

-- =============================================================================
-- 2. POLICIES
-- =============================================================================

-- ---------------------------------------------------------------- content_reports
-- Insert only, own reports only. No select/update/delete policy exists at
-- all -- that is what makes a report unreadable from the client, including
-- to the student who filed it.
drop policy if exists "students file their own reports" on public.content_reports;
create policy "students file their own reports"
  on public.content_reports for insert
  to authenticated
  with check (auth.uid() = reporter_id);

-- -------------------------------------------------------------------- user_blocks
drop policy if exists "students read their own blocks" on public.user_blocks;
create policy "students read their own blocks"
  on public.user_blocks for select
  to authenticated
  using (auth.uid() = blocker_id);

drop policy if exists "students add their own blocks" on public.user_blocks;
create policy "students add their own blocks"
  on public.user_blocks for insert
  to authenticated
  with check (auth.uid() = blocker_id);

drop policy if exists "students remove their own blocks" on public.user_blocks;
create policy "students remove their own blocks"
  on public.user_blocks for delete
  to authenticated
  using (auth.uid() = blocker_id);

-- =============================================================================
-- 3. OWNER-ONLY READ ACCESS TO REPORTS
-- =============================================================================
-- To add or change which accounts can read reports, edit the email list
-- below (and keep it matching activity_repository.dart's _ownerEmails and
-- the other owner-only functions in this project) and run this block again.

create or replace function public.owner_content_reports()
returns setof public.content_reports
language plpgsql
security definer
set search_path = public
stable
as $$
begin
  if lower(coalesce(auth.jwt() ->> 'email', '')) not in (
    'emekadominic1999@gmail.com',
    'eduvora264@gmail.com'
  ) then
    raise exception 'not allowed';
  end if;

  return query
  select * from public.content_reports order by created_at desc;
end;
$$;

revoke all on function public.owner_content_reports() from public, anon;
grant execute on function public.owner_content_reports() to authenticated;

-- =============================================================================
-- 4. CHECK IT WORKED
-- =============================================================================
-- Should list both tables.

select table_name
  from information_schema.tables
 where table_schema = 'public'
   and table_name in ('content_reports', 'user_blocks')
 order by table_name;
