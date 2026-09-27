-- =============================================================================
-- Lets the app owner post and remove Noticeboard items (scholarships,
-- admissions, academic notices, opportunities, competitions) from inside the
-- app itself, instead of asking for it to be done by hand each time. Also
-- lets the same post carry a picture, and be pinned to the top of Community
-- as an announcement.
--
-- The `news` and `community_posts` tables already exist (see schema.sql).
-- This adds the write side for news (only for the owner's own account,
-- checked here by the signed-in email itself), an `image_url` column on
-- both tables, and an `is_announcement` flag on community_posts that only
-- the owner's account may ever set to true.
--
-- Run this once in the Supabase SQL editor (Dashboard -> SQL Editor -> New
-- query -> paste -> Run). Safe to re-run.
-- =============================================================================

alter table public.news add column if not exists image_url text not null default '';
alter table public.community_posts add column if not exists image_url text not null default '';
alter table public.community_posts add column if not exists is_announcement boolean not null default false;

create index if not exists posts_announcement_idx
  on public.community_posts (is_announcement, created_at desc);

drop policy if exists "the owner can post news" on public.news;
create policy "the owner can post news"
  on public.news for insert
  to authenticated
  with check (
    lower(coalesce(auth.jwt() ->> 'email', '')) in (
      'emekadominic1999@gmail.com',
      'eduvora264@gmail.com'
    )
  );

drop policy if exists "the owner can edit news" on public.news;
create policy "the owner can edit news"
  on public.news for update
  to authenticated
  using (
    lower(coalesce(auth.jwt() ->> 'email', '')) in (
      'emekadominic1999@gmail.com',
      'eduvora264@gmail.com'
    )
  )
  with check (
    lower(coalesce(auth.jwt() ->> 'email', '')) in (
      'emekadominic1999@gmail.com',
      'eduvora264@gmail.com'
    )
  );

drop policy if exists "the owner can delete news" on public.news;
create policy "the owner can delete news"
  on public.news for delete
  to authenticated
  using (
    lower(coalesce(auth.jwt() ->> 'email', '')) in (
      'emekadominic1999@gmail.com',
      'eduvora264@gmail.com'
    )
  );

-- ------------------------------------------------------- community pinning
-- Replaces the plain "students write/edit their own posts" policies from
-- schema.sql with versions that additionally require is_announcement = true
-- to come from the owner's own account. A student can still post and edit
-- their own posts exactly as before; they just can never pin one to the top.

drop policy if exists "students write their own posts" on public.community_posts;
create policy "students write their own posts"
  on public.community_posts for insert
  to authenticated
  with check (
    auth.uid() = author_id
    and (
      is_announcement = false
      or lower(coalesce(auth.jwt() ->> 'email', '')) in (
        'emekadominic1999@gmail.com',
        'eduvora264@gmail.com'
      )
    )
  );

drop policy if exists "students edit their own posts" on public.community_posts;
create policy "students edit their own posts"
  on public.community_posts for update
  to authenticated
  using (auth.uid() = author_id)
  with check (
    auth.uid() = author_id
    and (
      is_announcement = false
      or lower(coalesce(auth.jwt() ->> 'email', '')) in (
        'emekadominic1999@gmail.com',
        'eduvora264@gmail.com'
      )
    )
  );

-- If you ever add another owner account, list its email in every policy
-- above (and in lib/core/services/activity_repository.dart's _ownerEmails,
-- which only controls whether the "Post an update" button is shown -- this
-- file is what actually enforces it).
