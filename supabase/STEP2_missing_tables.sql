-- =============================================================================
-- Eduvora — STEP 2: create the seven missing tables
-- =============================================================================
-- Run this in the Supabase SQL Editor AFTER the step 1 repair script.
--
-- It creates only the tables that are missing from the project, so it cannot
-- trip over the profiles / materials / academic_videos tables that already
-- exist. Safe to run more than once.
-- =============================================================================

create extension if not exists "pgcrypto";

-- ----------------------------------------------------------- community_posts
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
  on public.community_posts for select to authenticated using (true);

drop policy if exists "students write their own posts" on public.community_posts;
create policy "students write their own posts"
  on public.community_posts for insert to authenticated
  with check (auth.uid() = author_id);

drop policy if exists "students edit their own posts" on public.community_posts;
create policy "students edit their own posts"
  on public.community_posts for update to authenticated
  using (auth.uid() = author_id) with check (auth.uid() = author_id);

drop policy if exists "students remove their own posts" on public.community_posts;
create policy "students remove their own posts"
  on public.community_posts for delete to authenticated
  using (auth.uid() = author_id);

-- -------------------------------------------------------- community_comments
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
  on public.community_comments for select to authenticated using (true);

drop policy if exists "students write their own comments" on public.community_comments;
create policy "students write their own comments"
  on public.community_comments for insert to authenticated
  with check (auth.uid() = author_id);

drop policy if exists "students remove their own comments" on public.community_comments;
create policy "students remove their own comments"
  on public.community_comments for delete to authenticated
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

-- ------------------------------------------------------------- gpa_semesters
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
  on public.gpa_semesters for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- -------------------------------------------------------------- cbt_attempts
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
  on public.cbt_attempts for all to authenticated
  using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ------------------------------------------------------------- cbt_questions
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
  on public.cbt_questions for select to authenticated using (true);

drop policy if exists "authenticated users contribute cbt questions" on public.cbt_questions;
create policy "authenticated users contribute cbt questions"
  on public.cbt_questions for insert to authenticated with check (true);

-- ----------------------------------------------------------- course_outlines
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
  on public.course_outlines for select to authenticated using (true);

drop policy if exists "students contribute outlines" on public.course_outlines;
create policy "students contribute outlines"
  on public.course_outlines for insert to authenticated
  with check (auth.uid() = contributed_by);

drop policy if exists "students edit their own outlines" on public.course_outlines;
create policy "students edit their own outlines"
  on public.course_outlines for update to authenticated
  using (auth.uid() = contributed_by) with check (auth.uid() = contributed_by);

drop policy if exists "students remove their own outlines" on public.course_outlines;
create policy "students remove their own outlines"
  on public.course_outlines for delete to authenticated
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

drop policy if exists "news is readable by everyone" on public.news;
create policy "news is readable by everyone"
  on public.news for select to anon, authenticated using (true);

-- --------------------------------------------------------- profile auto-create
-- Creates a profile row whenever a user signs up, including via Google, so
-- the app never has to cope with a missing row.
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

-- ------------------------------------------------------------------ storage
insert into storage.buckets (id, name, public)
values ('materials', 'materials', true)
on conflict (id) do nothing;

insert into storage.buckets (id, name, public)
values ('academic-videos', 'academic-videos', true)
on conflict (id) do nothing;

drop policy if exists "material files are publicly readable" on storage.objects;
create policy "material files are publicly readable"
  on storage.objects for select to anon, authenticated
  using (bucket_id in ('materials', 'academic-videos'));

drop policy if exists "students upload to their own folder" on storage.objects;
create policy "students upload to their own folder"
  on storage.objects for insert to authenticated
  with check (
    bucket_id in ('materials', 'academic-videos')
    and (storage.foldername(name))[1] = auth.uid()::text
  );

drop policy if exists "students manage their own uploads" on storage.objects;
create policy "students manage their own uploads"
  on storage.objects for delete to authenticated
  using (
    bucket_id in ('materials', 'academic-videos')
    and (storage.foldername(name))[1] = auth.uid()::text
  );
