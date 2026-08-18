-- =============================================================================
-- University of Nigeria, Nsukka -- renumber STA 111 -> STA 113 and
-- STA 131 -> STA 111.
-- =============================================================================
-- Resolves the collision flagged when STA 131 (Inference I) was first asked
-- to become STA 111: STA 111 already meant "Probability I". The user has now
-- confirmed the actual renumbering moves Probability I out to STA 113 first,
-- freeing STA 111 for Inference I.
--
-- Order matters: STA 111 -> STA 113 MUST run first. If STA 131 -> STA 111 ran
-- first, the STA 111 -> STA 113 update would then also catch the newly
-- renamed Inference I rows (now sitting at 'STA 111') and incorrectly move
-- them to STA 113 too.
--
-- Scope check performed before writing this migration: every 'STA 111' row
-- (2 outline files) is "Probability I", and every 'STA 131' row (3 outline
-- files) is "Inference I" -- both single, consistent courses. 'STA 113' was
-- not already in use anywhere in the app. No CBT bank exists for either
-- code, so course_outlines is the only table affected.
-- =============================================================================

update public.course_outlines
   set course_code = 'STA 113'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'STA 111';

update public.course_outlines
   set course_code = 'STA 111'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'STA 131';
