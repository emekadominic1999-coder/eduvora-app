-- =============================================================================
-- Eduvora — study groups and class lists
-- =============================================================================
-- Run in the Supabase SQL Editor. Safe to run more than once.
--
-- Adds real, student-created study groups (joined by a short code) and class
-- lists. Creating a class list also creates its group, so a course rep can set
-- the class up once and have somewhere for everyone to talk immediately.
-- =============================================================================

create extension if not exists "pgcrypto";

-- -------------------------------------------------------------- admin check
-- Asking "is this person an admin of that group?" means reading
-- chat_group_members, and a policy ON chat_group_members that reads
-- chat_group_members recurses forever. security definer breaks the loop: the
-- function runs as its owner and skips RLS, so the policies below can call it.
create or replace function public.is_group_admin(gid uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.chat_group_members m
     where m.group_id = gid
       and m.user_id = auth.uid()
       and m.is_admin
  );
$$;

create or replace function public.is_group_member(gid uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.chat_group_members m
     where m.group_id = gid and m.user_id = auth.uid()
  );
$$;

revoke all on function public.is_group_admin(uuid) from public;
revoke all on function public.is_group_member(uuid) from public;
grant execute on function public.is_group_admin(uuid) to authenticated;
grant execute on function public.is_group_member(uuid) to authenticated;

-- ------------------------------------------------------------- chat_groups
create table if not exists public.chat_groups (
  id           uuid primary key default gen_random_uuid(),
  name         text not null,
  description  text not null default '',
  join_code    text not null unique,
  institution  text not null default '',
  faculty      text not null default '',
  department   text not null default '',
  level        text not null default '',
  course_code  text not null default '',
  created_by   uuid references auth.users (id) on delete set null,
  creator_name text not null default '',
  -- Set when the group was spun up automatically from a class list.
  class_list_id uuid,
  created_at   timestamptz not null default now()
);

create index if not exists groups_code_idx on public.chat_groups (join_code);
create index if not exists groups_dept_idx
  on public.chat_groups (institution, department, level);

alter table public.chat_groups enable row level security;

-- Readable by any signed-in student: that is how a group is found and joined
-- by its code in the first place.
drop policy if exists "groups are readable by authenticated users" on public.chat_groups;
create policy "groups are readable by authenticated users"
  on public.chat_groups for select to authenticated using (true);

drop policy if exists "students create groups" on public.chat_groups;
create policy "students create groups"
  on public.chat_groups for insert to authenticated
  with check (auth.uid() = created_by);

-- Any admin may rename a group or change its description, not just whoever
-- happened to create it — an admin handing over should hand over fully.
drop policy if exists "creators manage their groups" on public.chat_groups;
drop policy if exists "admins manage their groups" on public.chat_groups;
create policy "admins manage their groups"
  on public.chat_groups for update to authenticated
  using (auth.uid() = created_by or public.is_group_admin(id))
  with check (auth.uid() = created_by or public.is_group_admin(id));

drop policy if exists "creators delete their groups" on public.chat_groups;
create policy "creators delete their groups"
  on public.chat_groups for delete to authenticated
  using (auth.uid() = created_by);

-- ------------------------------------------------------ chat_group_members
create table if not exists public.chat_group_members (
  id         uuid primary key default gen_random_uuid(),
  group_id   uuid not null references public.chat_groups (id) on delete cascade,
  user_id    uuid not null references auth.users (id) on delete cascade,
  full_name  text not null default '',
  headline   text not null default '',
  is_admin   boolean not null default false,
  joined_at  timestamptz not null default now(),
  unique (group_id, user_id)
);

create index if not exists members_group_idx on public.chat_group_members (group_id);
create index if not exists members_user_idx on public.chat_group_members (user_id);

alter table public.chat_group_members enable row level security;

drop policy if exists "members are readable by authenticated users" on public.chat_group_members;
create policy "members are readable by authenticated users"
  on public.chat_group_members for select to authenticated using (true);

-- A student may only add or remove themselves; joining is self-service.
drop policy if exists "students join groups themselves" on public.chat_group_members;
create policy "students join groups themselves"
  on public.chat_group_members for insert to authenticated
  with check (auth.uid() = user_id);

-- A student may always leave. An admin may also remove somebody else — but
-- never the person who created the group, so a group cannot be taken from its
-- founder by an admin they themselves appointed.
drop policy if exists "students leave groups themselves" on public.chat_group_members;
drop policy if exists "students leave and admins remove" on public.chat_group_members;
create policy "students leave and admins remove"
  on public.chat_group_members for delete to authenticated
  using (
    auth.uid() = user_id
    or (
      public.is_group_admin(group_id)
      and user_id <> (
        select g.created_by from public.chat_groups g where g.id = group_id
      )
    )
  );

-- Only admins may promote or dismiss another admin. The founder is protected
-- here too: nobody can strip their admin rights.
drop policy if exists "admins change admin rights" on public.chat_group_members;
create policy "admins change admin rights"
  on public.chat_group_members for update to authenticated
  using (
    public.is_group_admin(group_id)
    and user_id <> (
      select g.created_by from public.chat_groups g where g.id = group_id
    )
  )
  with check (public.is_group_admin(group_id));

-- ----------------------------------------------------- chat_group_messages
create table if not exists public.chat_group_messages (
  id          uuid primary key default gen_random_uuid(),
  group_id    uuid not null references public.chat_groups (id) on delete cascade,
  author_id   uuid references auth.users (id) on delete set null,
  author_name text not null default '',
  body        text not null,
  -- Lets a message be flagged as a question so the group can filter to them.
  is_question boolean not null default false,
  -- The message this one replies to. Kept as a plain uuid with the author and
  -- body copied alongside, so a quoted reply still reads correctly after the
  -- original is deleted.
  reply_to_id     uuid,
  reply_to_author text not null default '',
  reply_to_body   text not null default '',
  -- Deleting keeps the row and blanks the body, so the thread does not lose
  -- its shape and a reply above still makes sense.
  deleted_at  timestamptz,
  sent_at     timestamptz not null default now()
);

-- Columns added after the first release of this file.
alter table public.chat_group_messages
  add column if not exists reply_to_id uuid,
  add column if not exists reply_to_author text not null default '',
  add column if not exists reply_to_body text not null default '',
  add column if not exists deleted_at timestamptz;

create index if not exists group_messages_idx
  on public.chat_group_messages (group_id, sent_at);

alter table public.chat_group_messages enable row level security;

-- Only members of a group may read or post in it.
drop policy if exists "members read group messages" on public.chat_group_messages;
create policy "members read group messages"
  on public.chat_group_messages for select to authenticated
  using (
    exists (
      select 1 from public.chat_group_members m
       where m.group_id = chat_group_messages.group_id
         and m.user_id = auth.uid()
    )
  );

drop policy if exists "members post group messages" on public.chat_group_messages;
create policy "members post group messages"
  on public.chat_group_messages for insert to authenticated
  with check (
    auth.uid() = author_id
    and exists (
      select 1 from public.chat_group_members m
       where m.group_id = chat_group_messages.group_id
         and m.user_id = auth.uid()
    )
  );

-- Deleting is a blanking update rather than a row delete, so an admin can
-- clear something inappropriate without the thread above it losing its shape.
drop policy if exists "authors and admins delete messages" on public.chat_group_messages;
create policy "authors and admins delete messages"
  on public.chat_group_messages for update to authenticated
  using (auth.uid() = author_id or public.is_group_admin(group_id))
  with check (auth.uid() = author_id or public.is_group_admin(group_id));

drop policy if exists "authors delete their messages" on public.chat_group_messages;
create policy "authors delete their messages"
  on public.chat_group_messages for delete to authenticated
  using (auth.uid() = author_id or public.is_group_admin(group_id));

-- --------------------------------------------------------------- realtime
-- Without this, a message only appears when the other person pulls to
-- refresh. With it, it lands the moment it is sent — which is the whole
-- difference between a message board and a chat.
do $$
begin
  if not exists (
    select 1 from pg_publication_tables
     where pubname = 'supabase_realtime'
       and schemaname = 'public'
       and tablename = 'chat_group_messages'
  ) then
    alter publication supabase_realtime add table public.chat_group_messages;
  end if;

  if not exists (
    select 1 from pg_publication_tables
     where pubname = 'supabase_realtime'
       and schemaname = 'public'
       and tablename = 'chat_group_members'
  ) then
    alter publication supabase_realtime add table public.chat_group_members;
  end if;
exception
  when undefined_object then
    raise notice 'supabase_realtime publication not found — skipping.';
end $$;

-- ------------------------------------------------------------- class_lists
create table if not exists public.class_lists (
  id           uuid primary key default gen_random_uuid(),
  name         text not null,
  institution  text not null default '',
  faculty      text not null default '',
  department   text not null default '',
  level        text not null default '',
  session      text not null default '',
  owner_id     uuid references auth.users (id) on delete set null,
  owner_name   text not null default '',
  -- The group created alongside this list.
  group_id     uuid references public.chat_groups (id) on delete set null,
  created_at   timestamptz not null default now()
);

create index if not exists class_lists_owner_idx on public.class_lists (owner_id);
create index if not exists class_lists_dept_idx
  on public.class_lists (institution, department, level);

alter table public.class_lists enable row level security;

drop policy if exists "class lists are readable by authenticated users" on public.class_lists;
create policy "class lists are readable by authenticated users"
  on public.class_lists for select to authenticated using (true);

drop policy if exists "students create class lists" on public.class_lists;
create policy "students create class lists"
  on public.class_lists for insert to authenticated
  with check (auth.uid() = owner_id);

drop policy if exists "owners manage class lists" on public.class_lists;
create policy "owners manage class lists"
  on public.class_lists for update to authenticated
  using (auth.uid() = owner_id) with check (auth.uid() = owner_id);

drop policy if exists "owners delete class lists" on public.class_lists;
create policy "owners delete class lists"
  on public.class_lists for delete to authenticated
  using (auth.uid() = owner_id);

-- ----------------------------------------------------- class_list_entries
create table if not exists public.class_list_entries (
  id            uuid primary key default gen_random_uuid(),
  class_list_id uuid not null references public.class_lists (id) on delete cascade,
  full_name     text not null,
  matric_number text not null default '',
  email         text not null default '',
  phone         text not null default '',
  note          text not null default '',
  position      integer not null default 0,
  created_at    timestamptz not null default now()
);

create index if not exists entries_list_idx
  on public.class_list_entries (class_list_id, position);

alter table public.class_list_entries enable row level security;

drop policy if exists "entries are readable by authenticated users" on public.class_list_entries;
create policy "entries are readable by authenticated users"
  on public.class_list_entries for select to authenticated using (true);

-- Only the owner of the parent list may change its entries.
drop policy if exists "owners add entries" on public.class_list_entries;
create policy "owners add entries"
  on public.class_list_entries for insert to authenticated
  with check (
    exists (
      select 1 from public.class_lists l
       where l.id = class_list_entries.class_list_id
         and l.owner_id = auth.uid()
    )
  );

drop policy if exists "owners edit entries" on public.class_list_entries;
create policy "owners edit entries"
  on public.class_list_entries for update to authenticated
  using (
    exists (
      select 1 from public.class_lists l
       where l.id = class_list_entries.class_list_id
         and l.owner_id = auth.uid()
    )
  );

drop policy if exists "owners remove entries" on public.class_list_entries;
create policy "owners remove entries"
  on public.class_list_entries for delete to authenticated
  using (
    exists (
      select 1 from public.class_lists l
       where l.id = class_list_entries.class_list_id
         and l.owner_id = auth.uid()
    )
  );
