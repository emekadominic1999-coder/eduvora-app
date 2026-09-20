-- Relabel: the 1,061-question paper built from gst111.pdf is GST 114 (Use of English II, 100L second semester, per course_outlines).
update cbt_questions set subject_name = 'GST 114: Use of English II', semester = 'second'
where subject_id = 'gst-111-use-of-english-study-skills';
-- subject_id is intentionally unchanged so existing attempts/entitlements keep pointing at it.
