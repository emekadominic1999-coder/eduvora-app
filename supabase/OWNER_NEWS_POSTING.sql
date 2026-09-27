-- =============================================================================
-- Lets the app owner post and remove Noticeboard items (scholarships,
-- admissions, academic notices, opportunities, competitions) from inside the
-- app itself, instead of asking for it to be done by hand each time.
--
-- The `news` table already exists (see schema.sql) and is readable by
-- everyone. This only adds the write side, and only for the owner's own
-- account -- checked here, in the database, by the signed-in email itself,
-- so nothing on the client can be edited to grant a student that access.
--
-- Run this once in the Supabase SQL editor (Dashboard -> SQL Editor -> New
-- query -> paste -> Run). Safe to re-run.
-- =============================================================================

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

-- If you ever add another owner account, list its email in all three
-- policies above (and in lib/core/services/activity_repository.dart's
-- _ownerEmails, which only controls whether the "Post an update" button is
-- shown -- this file is what actually enforces it).
