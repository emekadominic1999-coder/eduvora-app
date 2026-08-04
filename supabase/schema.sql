-- =============================================================================
-- Eduvora — Supabase schema
-- =============================================================================
-- Run this once in the Supabase SQL editor for a new project.
--
-- It creates the tables described in the Eduvora technical documentation,
-- enables Row Level Security on every one of them, and adds the storage
-- buckets used for materials and lecture videos.
--
-- Eduvora runs perfectly well without this (Campus Mode keeps everything
-- on-device). Apply it when you want accounts and content shared between
-- devices and students.
-- =============================================================================

-- ---------------------------------------------------------------- extensions
create extension if not exists "pgcrypto";

-- ------------------------------------------------------------------ profiles
-- One row per student, keyed to auth.users. Holds the academic identity that
-- every feed in the app filters against.
create table if not exists public.profiles (
  id                       uuid primary key references auth.users (id) on delete cascade,
  full_name                text not null default '',
  email                    text not null default '',
  avatar_url               text,
  institution_name         text not null default '',
  institution_abbreviation text not null default '',
  institution_state        text not null default '',
  institution_type         text not null default 'university'
                             check (institution_type in
                               ('university', 'polytechnic', 'collegeOfEducation')),
  faculty                  text not null default '',
  department               text not null default '',
  level                    text not null default '',
  matric_number            text not null default '',
  bio                      text not null default '',
  joined_at                timestamptz not null default now(),
  updated_at               timestamptz not null default now()
);

create index if not exists profiles_department_idx on public.profiles (department);
create index if not exists profiles_institution_idx on public.profiles (institution_name);

alter table public.profiles enable row level security;

drop policy if exists "profiles are readable by authenticated users" on public.profiles;
create policy "profiles are readable by authenticated users"
  on public.profiles for select
  to authenticated
  using (true);

drop policy if exists "students manage their own profile" on public.profiles;
create policy "students manage their own profile"
  on public.profiles for all
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Create a profile row automatically whenever a user signs up, including via
-- Google OAuth, so the app never has to handle a missing row.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles (id, full_name, email, avatar_url)
  values (
    new.id,
    coalesce(new.raw_user_meta_data ->> 'full_name',
             new.raw_user_meta_data ->> 'name',
             split_part(coalesce(new.email, ''), '@', 1)),
    coalesce(new.email, ''),
    new.raw_user_meta_data ->> 'avatar_url'
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- ----------------------------------------------------------------- materials
-- Lecture notes, past questions, handouts, slides and project work.
create table if not exists public.materials (
  id            uuid primary key default gen_random_uuid(),
  title         text not null,
  course_code   text not null default '',
  department    text not null default '',
  faculty       text not null default '',
  institution   text not null default '',
  level         text not null default '',
  file_url      text not null default '',
  file_name     text not null default '',
  file_size     bigint not null default 0,
  description   text not null default '',
  kind          text not null default 'lectureNote',
  downloads     integer not null default 0,
  uploaded_by   uuid references auth.users (id) on delete set null,
  uploader_name text not null default '',
  created_at    timestamptz not null default now()
);

create index if not exists materials_department_idx on public.materials (department);
create index if not exists materials_level_idx on public.materials (level);
create index if not exists materials_created_idx on public.materials (created_at desc);

alter table public.materials enable row level security;

drop policy if exists "materials are readable by authenticated users" on public.materials;
create policy "materials are readable by authenticated users"
  on public.materials for select
  to authenticated
  using (true);

drop policy if exists "students insert their own materials" on public.materials;
create policy "students insert their own materials"
  on public.materials for insert
  to authenticated
  with check (auth.uid() = uploaded_by);

drop policy if exists "students edit their own materials" on public.materials;
create policy "students edit their own materials"
  on public.materials for update
  to authenticated
  using (auth.uid() = uploaded_by)
  with check (auth.uid() = uploaded_by);

drop policy if exists "students delete their own materials" on public.materials;
create policy "students delete their own materials"
  on public.materials for delete
  to authenticated
  using (auth.uid() = uploaded_by);

-- ----------------------------------------------------------- academic_videos
create table if not exists public.academic_videos (
  id          uuid primary key default gen_random_uuid(),
  title       text not null,
  department  text not null default '',
  faculty     text not null default '',
  course_code text not null default '',
  level       text not null default '',
  video_url   text not null,
  thumbnail   text not null default '',
  lecturer    text not null default '',
  description text not null default '',
  duration    text not null default '',
  views       integer not null default 0,
  uploaded_by uuid references auth.users (id) on delete set null,
  created_at  timestamptz not null default now()
);

create index if not exists videos_department_idx on public.academic_videos (department);
create index if not exists videos_created_idx on public.academic_videos (created_at desc);

alter table public.academic_videos enable row level security;

drop policy if exists "videos are readable by authenticated users" on public.academic_videos;
create policy "videos are readable by authenticated users"
  on public.academic_videos for select
  to authenticated
  using (true);

drop policy if exists "students contribute videos" on public.academic_videos;
create policy "students contribute videos"
  on public.academic_videos for insert
  to authenticated
  with check (auth.uid() = uploaded_by);

-- View counts are cosmetic, so any signed-in student may bump them.
drop policy if exists "authenticated users update view counts" on public.academic_videos;
create policy "authenticated users update view counts"
  on public.academic_videos for update
  to authenticated
  using (true)
  with check (true);

-- ----------------------------------------------------------------- community
create table if not exists public.community_posts (
  id              uuid primary key default gen_random_uuid(),
  author_id       uuid references auth.users (id) on delete cascade,
  author_name     text not null default '',
  author_headline text not null default '',
  body            text not null,
  topic           text not null default 'general',
  institution     text not null default '',
  department      text not null default '',
  likes           integer not null default 0,
  comment_count   integer not null default 0,
  created_at      timestamptz not null default now()
);

create index if not exists posts_topic_idx on public.community_posts (topic);
create index if not exists posts_created_idx on public.community_posts (created_at desc);

alter table public.community_posts enable row level security;

drop policy if exists "posts are readable by authenticated users" on public.community_posts;
create policy "posts are readable by authenticated users"
  on public.community_posts for select
  to authenticated
  using (true);

drop policy if exists "students write their own posts" on public.community_posts;
create policy "students write their own posts"
  on public.community_posts for insert
  to authenticated
  with check (auth.uid() = author_id);

drop policy if exists "students edit their own posts" on public.community_posts;
create policy "students edit their own posts"
  on public.community_posts for update
  to authenticated
  using (auth.uid() = author_id)
  with check (auth.uid() = author_id);

drop policy if exists "students remove their own posts" on public.community_posts;
create policy "students remove their own posts"
  on public.community_posts for delete
  to authenticated
  using (auth.uid() = author_id);

create table if not exists public.community_comments (
  id          uuid primary key default gen_random_uuid(),
  post_id     uuid not null references public.community_posts (id) on delete cascade,
  author_id   uuid references auth.users (id) on delete cascade,
  author_name text not null default '',
  body        text not null,
  created_at  timestamptz not null default now()
);

create index if not exists comments_post_idx on public.community_comments (post_id, created_at);

alter table public.community_comments enable row level security;

drop policy if exists "comments are readable by authenticated users" on public.community_comments;
create policy "comments are readable by authenticated users"
  on public.community_comments for select
  to authenticated
  using (true);

drop policy if exists "students write their own comments" on public.community_comments;
create policy "students write their own comments"
  on public.community_comments for insert
  to authenticated
  with check (auth.uid() = author_id);

drop policy if exists "students remove their own comments" on public.community_comments;
create policy "students remove their own comments"
  on public.community_comments for delete
  to authenticated
  using (auth.uid() = author_id);

-- Keep the denormalised comment counter honest.
create or replace function public.sync_comment_count()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  if (tg_op = 'INSERT') then
    update public.community_posts
       set comment_count = comment_count + 1
     where id = new.post_id;
    return new;
  elsif (tg_op = 'DELETE') then
    update public.community_posts
       set comment_count = greatest(comment_count - 1, 0)
     where id = old.post_id;
    return old;
  end if;
  return null;
end;
$$;

drop trigger if exists community_comment_count on public.community_comments;
create trigger community_comment_count
  after insert or delete on public.community_comments
  for each row execute function public.sync_comment_count();

-- ---------------------------------------------------------- study records
create table if not exists public.gpa_semesters (
  id       uuid primary key default gen_random_uuid(),
  user_id  uuid not null references auth.users (id) on delete cascade,
  label    text not null default '',
  courses  jsonb not null default '[]'::jsonb,
  gpa      numeric(4, 2) not null default 0,
  saved_at timestamptz not null default now()
);

create index if not exists gpa_user_idx on public.gpa_semesters (user_id, saved_at);

alter table public.gpa_semesters enable row level security;

drop policy if exists "students own their semester records" on public.gpa_semesters;
create policy "students own their semester records"
  on public.gpa_semesters for all
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create table if not exists public.cbt_attempts (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null references auth.users (id) on delete cascade,
  subject_id       text not null,
  subject_name     text not null default '',
  total_questions  integer not null default 0,
  score            integer not null default 0,
  answers          jsonb not null default '{}'::jsonb,
  duration_seconds integer not null default 0,
  taken_at         timestamptz not null default now()
);

create index if not exists attempts_user_idx on public.cbt_attempts (user_id, taken_at desc);

alter table public.cbt_attempts enable row level security;

drop policy if exists "students own their attempts" on public.cbt_attempts;
create policy "students own their attempts"
  on public.cbt_attempts for all
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- ------------------------------------------------------------- cbt_questions
-- Real past-question banks, one row per question. The app groups rows by
-- subject_id into a paper (a CbtSubject) and filters by faculty, exactly the
-- way the bundled starter bank does — the difference is these rows can be
-- added at any time from the Supabase Table Editor or SQL Editor, with no
-- app rebuild required.
create table if not exists public.cbt_questions (
  id              uuid primary key default gen_random_uuid(),
  subject_id      text not null,
  subject_name    text not null,
  institution     text not null default '',
  faculty         text not null default '',
  department      text not null default '',
  level           text not null default '',
  question        text not null,
  options         jsonb not null,
  correct_index   integer not null,
  explanation     text not null default '',
  topic           text not null default '',
  is_general      boolean not null default false,
  created_by      uuid references auth.users (id) on delete set null,
  created_at      timestamptz not null default now()
);

create index if not exists cbt_questions_subject_idx on public.cbt_questions (subject_id);
create index if not exists cbt_questions_faculty_idx on public.cbt_questions (faculty);

alter table public.cbt_questions enable row level security;

drop policy if exists "cbt questions are readable by authenticated users" on public.cbt_questions;
create policy "cbt questions are readable by authenticated users"
  on public.cbt_questions for select
  to authenticated
  using (true);

drop policy if exists "authenticated users contribute cbt questions" on public.cbt_questions;
create policy "authenticated users contribute cbt questions"
  on public.cbt_questions for insert
  to authenticated
  with check (true);

-- ------------------------------------------------------------ course_outlines
-- Course lists and syllabi, keyed to a specific institution as well as a
-- department and level.
--
-- The institution column is not optional padding: the same nominal subject
-- genuinely differs between schools — course codes, credit loading and topics
-- all vary — so an outline is only trustworthy when attributed to the school
-- it came from. The app filters on institution first for exactly this reason.
create table if not exists public.course_outlines (
  id               uuid primary key default gen_random_uuid(),
  course_code      text not null,
  course_title     text not null,
  institution      text not null,
  faculty          text not null default '',
  department       text not null,
  level            text not null,
  semester         text not null default 'first'
                     check (semester in ('first', 'second')),
  credit_units     integer not null default 0,
  description      text not null default '',
  topics           jsonb not null default '[]'::jsonb,
  lecturer         text not null default '',
  is_elective      boolean not null default false,
  contributed_by   uuid references auth.users (id) on delete set null,
  contributor_name text not null default '',
  created_at       timestamptz not null default now()
);

create index if not exists outlines_lookup_idx
  on public.course_outlines (institution, department, level);
create index if not exists outlines_department_idx
  on public.course_outlines (department, level);

alter table public.course_outlines enable row level security;

drop policy if exists "outlines are readable by authenticated users" on public.course_outlines;
create policy "outlines are readable by authenticated users"
  on public.course_outlines for select
  to authenticated
  using (true);

drop policy if exists "students contribute outlines" on public.course_outlines;
create policy "students contribute outlines"
  on public.course_outlines for insert
  to authenticated
  with check (auth.uid() = contributed_by);

drop policy if exists "students edit their own outlines" on public.course_outlines;
create policy "students edit their own outlines"
  on public.course_outlines for update
  to authenticated
  using (auth.uid() = contributed_by)
  with check (auth.uid() = contributed_by);

drop policy if exists "students remove their own outlines" on public.course_outlines;
create policy "students remove their own outlines"
  on public.course_outlines for delete
  to authenticated
  using (auth.uid() = contributed_by);

-- ---------------------------------------------------------------------- news
create table if not exists public.news (
  id           uuid primary key default gen_random_uuid(),
  title        text not null,
  summary      text not null default '',
  body         text not null default '',
  category     text not null default 'academic',
  source       text not null default '',
  link         text not null default '',
  deadline     timestamptz,
  is_featured  boolean not null default false,
  published_at timestamptz not null default now()
);

create index if not exists news_published_idx on public.news (published_at desc);

alter table public.news enable row level security;

-- The noticeboard is public: prospective students should be able to read it
-- before they have an account.
drop policy if exists "news is readable by everyone" on public.news;
create policy "news is readable by everyone"
  on public.news for select
  to anon, authenticated
  using (true);

-- ------------------------------------------------------------------ storage
insert into storage.buckets (id, name, public)
values ('materials', 'materials', true)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public)
values ('academic-videos', 'academic-videos', true)
on conflict (id) do nothing;

drop policy if exists "material files are publicly readable" on storage.objects;
create policy "material files are publicly readable"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id in ('materials', 'academic-videos'));

-- Uploads land in a folder named after the student's user id, which is what
-- the app writes and what this policy enforces.
drop policy if exists "students upload to their own folder" on storage.objects;
create policy "students upload to their own folder"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id in ('materials', 'academic-videos')
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "students manage their own uploads" on storage.objects;
create policy "students manage their own uploads"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id in ('materials', 'academic-videos')
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- =============================================================================
-- Google sign-in
-- =============================================================================
-- 1. Authentication → Providers → Google: enable it and paste the OAuth client
--    id and secret from the Google Cloud console.
-- 2. Authentication → URL Configuration → Redirect URLs: add
--       com.dominicemeka.eduvora://login-callback
--    for Android and iOS, plus your web origin for the web build.
-- 3. Rebuild the app with the credentials supplied as dart-defines:
--       flutter run \
--         --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
--         --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...
-- =============================================================================
