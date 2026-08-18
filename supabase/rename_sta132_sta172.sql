-- =============================================================================
-- University of Nigeria, Nsukka -- renumber STA 132 -> STA 122 and
-- STA 172 -> STA 132.
-- =============================================================================
-- STA 131 (Inference I) -> STA 111 was also requested but is SKIPPED: STA 111
-- is already in use for a genuinely different course, "Probability I"
-- (paired with STA 112 "Probability II"), confirmed by the user -- renaming
-- STA 131 would have collided two different courses onto one code.
--
-- Scope check performed before writing this migration: every 'STA 132' row
-- (4 outline files) is "Inference II" with identical description/topics.
-- Every 'STA 172' row (3 outline files) is a wording variant of the same
-- companion lab course ("Statistical Computing", "Statistical Computing I",
-- "Laboratory for Inference II"), confirmed by identical description/topics
-- across all three. Neither 'STA 122' nor a freed-up 'STA 132' collided with
-- an existing different course before this migration. No CBT question bank
-- exists for either code, so course_outlines is the only table affected.
--
-- Order matters: STA 132 -> STA 122 runs first to free up the 'STA 132' code
-- before STA 172 claims it.
-- =============================================================================

update public.course_outlines
   set course_code = 'STA 122'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'STA 132';

update public.course_outlines
   set course_code = 'STA 132'
 where institution = 'University of Nigeria, Nsukka'
   and course_code = 'STA 172';
