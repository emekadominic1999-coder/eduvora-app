-- =============================================================================
-- Eduvora — close anonymous read access to student data
-- =============================================================================
-- An earlier version of this project left behind policies granting the
-- Postgres `public` role (which includes `anon`) access to profiles and other
-- tables. Because the publishable API key ships inside the public web bundle,
-- anyone could read student names, emails and matriculation numbers with it.
--
-- Row Level Security was already enabled; the problem was these extra
-- permissive policies sitting alongside the intended ones.
--
-- This script drops every public/anon policy on the three affected tables and
-- reinstates the intended authenticated-only ones. The news table is left
-- alone: its anonymous read access is deliberate, so the noticeboard can be
-- seen before signing up.
--
-- Safe to run more than once.
-- =============================================================================

-- ------------------------------------------------- drop the leftover policies
do $$
declare
  r record;
begin
  for r in
    select tablename, policyname
      from pg_policies
     where schemaname = 'public'
       and tablename in ('profiles', 'materials', 'academic_videos')
       and roles::text[] && array['public', 'anon']
  loop
    execute format('drop policy %I on public.%I', r.policyname, r.tablename);
    raise notice 'Dropped permissive policy "%" on %', r.policyname, r.tablename;
  end loop;
end $$;

-- --------------------------------------------- reinstate the intended policies
-- profiles: any signed-in student may look up a coursemate; only the owner
-- may change their own row.
drop policy if exists "profiles are readable by authenticated users" on public.profiles;
create policy "profiles are readable by authenticated users"
  on public.profiles for select to authenticated using (true);

drop policy if exists "students manage their own profile" on public.profiles;
create policy "students manage their own profile"
  on public.profiles for all to authenticated
  using (auth.uid() = id) with check (auth.uid() = id);

-- materials
drop policy if exists "materials are readable by authenticated users" on public.materials;
create policy "materials are readable by authenticated users"
  on public.materials for select to authenticated using (true);

drop policy if exists "students insert their own materials" on public.materials;
create policy "students insert their own materials"
  on public.materials for insert to authenticated
  with check (auth.uid() = uploaded_by);

drop policy if exists "students edit their own materials" on public.materials;
create policy "students edit their own materials"
  on public.materials for update to authenticated
  using (auth.uid() = uploaded_by) with check (auth.uid() = uploaded_by);

drop policy if exists "students delete their own materials" on public.materials;
create policy "students delete their own materials"
  on public.materials for delete to authenticated
  using (auth.uid() = uploaded_by);

-- academic_videos
drop policy if exists "videos are readable by authenticated users" on public.academic_videos;
create policy "videos are readable by authenticated users"
  on public.academic_videos for select to authenticated using (true);

drop policy if exists "students contribute videos" on public.academic_videos;
create policy "students contribute videos"
  on public.academic_videos for insert to authenticated
  with check (auth.uid() = uploaded_by);

drop policy if exists "authenticated users update view counts" on public.academic_videos;
create policy "authenticated users update view counts"
  on public.academic_videos for update to authenticated
  using (true) with check (true);

-- ------------------------------------------------------------------- verify
-- Anything still listed here is readable without signing in.
select 'STILL PUBLIC | ' || tablename || ' | ' || policyname || ' | ' || cmd
       as remaining_public_access
  from pg_policies
 where schemaname = 'public'
   and tablename in ('profiles', 'materials', 'academic_videos')
   and roles::text[] && array['public', 'anon']
union all
select 'COURSES LOADED | ' || department || ' | ' || level || ' | ' || count(*)::text
  from public.course_outlines
 group by department, level
 order by 1;
