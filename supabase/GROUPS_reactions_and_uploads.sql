-- =============================================================================
-- Eduvora — emoji reactions and photo/document sharing in study groups
-- =============================================================================
-- Run this AFTER GROUPS_and_class_lists.sql (it uses is_group_member(), which
-- that file defines). Safe to run more than once.
--
-- Adds:
--   - a photo or document attached to a group message
--   - one emoji reaction per student per message
-- =============================================================================

-- ------------------------------------------------------ 1. message attachments
alter table public.chat_group_messages
  add column if not exists attachment_url  text not null default '',
  add column if not exists attachment_name text not null default '',
  add column if not exists attachment_type text,
  add column if not exists attachment_size bigint not null default 0;

-- ------------------------------------------------- 2. chat_group_message_reactions
create table if not exists public.chat_group_message_reactions (
  id         uuid primary key default gen_random_uuid(),
  message_id uuid not null references public.chat_group_messages (id) on delete cascade,
  user_id    uuid not null references auth.users (id) on delete cascade,
  user_name  text not null default '',
  emoji      text not null,
  created_at timestamptz not null default now(),
  -- One reaction per student per message — picking a new emoji replaces the
  -- old one rather than adding a second, the way a raised hand is one hand.
  unique (message_id, user_id)
);

create index if not exists reactions_message_idx
  on public.chat_group_message_reactions (message_id);

-- By default Postgres only puts a deleted row's primary key into a realtime
-- delete event, not its other columns — so an unreact would arrive with no
-- message_id to say which message it belonged to. Full replica identity
-- carries every column, which is what the app needs to update the right
-- message the moment somebody removes a reaction.
alter table public.chat_group_message_reactions replica identity full;

alter table public.chat_group_message_reactions enable row level security;

drop policy if exists "members read reactions" on public.chat_group_message_reactions;
create policy "members read reactions"
  on public.chat_group_message_reactions for select to authenticated
  using (
    exists (
      select 1 from public.chat_group_messages m
       where m.id = chat_group_message_reactions.message_id
         and public.is_group_member(m.group_id)
    )
  );

drop policy if exists "members add their own reaction" on public.chat_group_message_reactions;
create policy "members add their own reaction"
  on public.chat_group_message_reactions for insert to authenticated
  with check (
    auth.uid() = user_id
    and exists (
      select 1 from public.chat_group_messages m
       where m.id = chat_group_message_reactions.message_id
         and public.is_group_member(m.group_id)
    )
  );

drop policy if exists "members change their own reaction" on public.chat_group_message_reactions;
create policy "members change their own reaction"
  on public.chat_group_message_reactions for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

drop policy if exists "members remove their own reaction" on public.chat_group_message_reactions;
create policy "members remove their own reaction"
  on public.chat_group_message_reactions for delete to authenticated
  using (auth.uid() = user_id);

-- --------------------------------------------------------- 3. storage bucket
-- A student uploads to <group_id>/<their_own_user_id>/<file>, so a policy can
-- check both "is this their own folder" and "are they actually in that group"
-- without trusting anything the client claims.

insert into storage.buckets (id, name, public)
values ('group-attachments', 'group-attachments', true)
on conflict (id) do nothing;

-- Public read, the same trade-off already made for lecture materials: a file
-- is reachable by anyone holding its exact link — a long, unguessable,
-- per-message path — but the link is never listable, and what stays private
-- is the message thread itself. Only a member can see that the link exists.
drop policy if exists "group attachments are publicly readable" on storage.objects;
create policy "group attachments are publicly readable"
  on storage.objects for select
  to anon, authenticated
  using (bucket_id = 'group-attachments');

drop policy if exists "members upload to their own folder in their group" on storage.objects;
create policy "members upload to their own folder in their group"
  on storage.objects for insert
  to authenticated
  with check (
    bucket_id = 'group-attachments'
    and (storage.foldername(name))[2] = auth.uid()::text
    and public.is_group_member((storage.foldername(name))[1]::uuid)
  );

drop policy if exists "members delete their own group uploads" on storage.objects;
create policy "members delete their own group uploads"
  on storage.objects for delete
  to authenticated
  using (
    bucket_id = 'group-attachments'
    and (storage.foldername(name))[2] = auth.uid()::text
  );

-- ------------------------------------------------------------- 4. realtime
-- So a reaction appears on everyone's screen the moment it is tapped, the
-- same way messages already do.

do $$
begin
  if not exists (
    select 1 from pg_publication_tables
     where pubname = 'supabase_realtime'
       and schemaname = 'public'
       and tablename = 'chat_group_message_reactions'
  ) then
    alter publication supabase_realtime
      add table public.chat_group_message_reactions;
  end if;
exception
  when others then
    raise notice 'Realtime not enabled for reactions (%). Reactions still work; they will appear on refresh.', sqlerrm;
end $$;

-- =============================================================================
-- 5. CHECK IT WORKED
-- =============================================================================

select table_name
  from information_schema.tables
 where table_schema = 'public'
   and table_name = 'chat_group_message_reactions';

select column_name
  from information_schema.columns
 where table_schema = 'public'
   and table_name = 'chat_group_messages'
   and column_name like 'attachment_%'
 order by column_name;

select id, public from storage.buckets where id = 'group-attachments';
