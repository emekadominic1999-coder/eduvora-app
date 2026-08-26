-- =============================================================================
-- Remove off-syllabus "Exponential Growth and Decay" application questions
-- from MTH103.
-- =============================================================================
-- User flagged a radioactive-decay half-life question as not part of the
-- course. Checked MTH103's real course_outlines description:
--   "Functions of a real variable, graphs, limits and continuity. The
--   derivative as limit of rate of change. Techniques of differentiation.
--   Curve sketching, integration as an inverse of differentiation. Methods
--   of integration, definite integrals. Application of integration to
--   areas and volumes."
-- No mention of exponential growth/decay word-problems (population growth,
-- radioactive half-life, bacterial culture growth) anywhere -- that's
-- differential-equations/applied-calculus territory, not this course.
--
-- Removed all 5 questions tagged "Exponential Growth and Decay", not just
-- the radioactive one, since the whole topic is off-syllabus:
--   - Radioactive half-life (two variants)
--   - Population doubling
--   - Bacterial culture growth (two variants)
--
-- MTH103: 966 -> 961 questions.
-- =============================================================================

delete from public.cbt_questions
 where subject_id = 'mth-103-calculus'
   and topic = 'Exponential Growth and Decay';
