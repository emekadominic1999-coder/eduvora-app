# Hand-set CBT question banks (Oct 2026)

Source files for the questions written for the CBT papers: statistics (STA 111, 112, 131, 132, 172), mathematics
(MTH 101, 102, 103), physics (mechanics, waves/heat/optics, electricity and atomic physics) and biology
(BIO 101, 102). Each file is a list of `add(stem, correct, [3 wrong], explanation, topic)` calls from `sta/lib.js`.

- Calculus and integration answers are checked numerically when a file is loaded; other numeric answers are
  recomputed in the file. Loading a file with `node -e "require('./maths/mth103a.js')"` runs those checks.
- The questions are already in the live database. The upload script is not stored here because it needs the
  Supabase service key; it shuffles the correct answer's position, skips stems that already exist and inserts the
  rows into `cbt_questions`.
- LaTeX is written with `String.raw`. Do not generate these files from shell heredocs or normal Python strings:
  `\t`, `\r`, `\f` and `\b` inside LaTeX turn into control characters.
