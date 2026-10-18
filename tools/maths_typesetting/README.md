# Maths typesetting pass (18 Oct 2026)

Brings every maths-type CBT bank in line with the printed-paper style (see the
MTH 111 revision paper): stacked fractions, upright function names, real
`\sqrt` / exponents, maths in running prose wrapped in `$...$`.

Banks covered: MTH 101, 102, 103, 206, 208 (full LaTeX pass); STA 111, 112, 131,
132 and AGR 101 (fractions and powers only); STA 172 (R code) left alone.

1,727 rows were rewritten directly in `cbt_questions` (question, options,
explanation). The originals were saved to a local backup before the update.

- `norm.js` - the rewrite rules (`fixMath`, `fixProse`, `fixProseOption`, `fixPlain`).
- `run.js` - runs the rules over `pulled.json` (rows pulled from `cbt_questions`)
  and writes `changes.json`.
- `apply.js` - PATCHes the changed rows. Needs `SUPABASE_SERVICE_KEY` in the
  environment; the key is deliberately not stored in the repo.
- `overrides.json` - a handful of stems rewritten by hand, keyed by row id.

Every changed `$...$` span was checked with flutter_math_fork's `TexParser`
before applying.
