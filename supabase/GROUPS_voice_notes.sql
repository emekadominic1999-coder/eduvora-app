-- =============================================================================
-- Eduvora — voice notes in study groups
-- =============================================================================
-- Run this AFTER GROUPS_and_class_lists.sql and GROUPS_reactions_and_uploads.sql
-- (it only adds a column to a table those files create). Safe to run more than
-- once.
--
-- A voice note is stored exactly like a photo or document already is — as a
-- row in chat_group_messages with attachment_url/attachment_name/
-- attachment_type/attachment_size, uploaded to the existing group-attachments
-- bucket under attachment_type = 'voice'. The only thing a voice note needs
-- that a photo or document does not is its playback length, so the bubble can
-- show "0:12" without having to download the whole file first.
-- =============================================================================

alter table public.chat_group_messages
  add column if not exists attachment_duration_ms integer not null default 0;

-- =============================================================================
-- CHECK IT WORKED
-- =============================================================================

select column_name
  from information_schema.columns
 where table_schema = 'public'
   and table_name = 'chat_group_messages'
   and column_name like 'attachment_%'
 order by column_name;
