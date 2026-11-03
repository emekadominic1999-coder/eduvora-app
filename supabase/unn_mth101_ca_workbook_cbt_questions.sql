-- MTH 101: questions from the MTH 101 CA workbook (Chapter 2)
-- =============================================================================
-- 20 questions built from the CA exercises (induction, quadratics, progressions,
-- binomial theorem, polynomials, inequalities, counting, radical equations,
-- trigonometry, complex numbers). Every question was re-solved; the handwritten
-- solutions in the scan were NOT trusted. Corrections: tan(A + B) with B obtuse is
-- -33/56 (the scan used a positive cosine); 2x^2 - 3x - 2 < 0 is -1/2 < x < 2;
-- the GP sum was recomputed exactly. The 3-set question (whose data give a non-
-- whole-number answer, 5/3) and the garbled logarithm/exponential items were dropped.
-- ADDS ONLY to the existing MTH 101 paper; repeats are skipped.
-- =============================================================================
with src (question, options, correct_index, explanation, topic) as (
values
  ('If $\alpha$ and $\beta$ are the roots of $2x^{2} - 5x - 3 = 0$, the equation with integer coefficients whose roots are $\dfrac{1}{\alpha}$ and $\dfrac{1}{\beta}$ is:', '["$3x^{2} + 5x - 2 = 0$","$3x^{2} - 5x - 2 = 0$","$2x^{2} + 5x - 3 = 0$","$3x^{2} + 5x + 2 = 0$"]'::jsonb, 0, 'Replacing $x$ by $1/x$ in $2x^{2} - 5x - 3 = 0$ and clearing fractions gives $2 - 5x - 3x^{2} = 0$, i.e. $3x^{2} + 5x - 2 = 0$. (Check: $\tfrac{1}{\alpha} + \tfrac{1}{\beta} = \tfrac{\alpha + \beta}{\alpha\beta} = \tfrac{5/2}{-3/2} = -\tfrac{5}{3}$.)', 'Theory of Quadratic Equations'),
  ('If $\alpha$ and $\beta$ are the roots of $2x^{2} - 5x - 3 = 0$, the equation with integer coefficients whose roots are $\alpha + 1$ and $\beta + 1$ is:', '["$2x^{2} + 9x + 4 = 0$","$2x^{2} - 9x + 4 = 0$","$2x^{2} - 5x + 4 = 0$","$x^{2} - 9x + 4 = 0$"]'::jsonb, 1, '$\alpha + \beta = \tfrac{5}{2}$ and $\alpha\beta = -\tfrac{3}{2}$. New sum $= \tfrac{5}{2} + 2 = \tfrac{9}{2}$; new product $= \alpha\beta + (\alpha + \beta) + 1 = 2$. Equation: $x^{2} - \tfrac{9}{2}x + 2 = 0$, i.e. $2x^{2} - 9x + 4 = 0$.', 'Theory of Quadratic Equations'),
  ('The numbers $x$, $2x - 1$ and $5x + 1$ are three consecutive terms of an arithmetic progression. The value of $x$ is:', '["$\\dfrac{3}{2}$","$-2$","$-\\dfrac{3}{2}$","$2$"]'::jsonb, 2, 'Equal differences: $(2x - 1) - x = (5x + 1) - (2x - 1)$ gives $x - 1 = 3x + 2$, so $x = -\tfrac{3}{2}$.', 'Arithmetic Progression'),
  ('For the progression with consecutive terms $x$, $2x - 1$, $5x + 1$ (where $x = -\tfrac{3}{2}$), the 23rd term is:', '["-55","-58","-59.5","-56.5"]'::jsonb, 3, 'The first term is $-1.5$ and the common difference is $-2.5$. $T_{23} = a + 22d = -1.5 + 22(-2.5) = -56.5$.', 'Arithmetic Progression'),
  ('The sum to infinity of the geometric series $6 + 3 + \tfrac{3}{2} + \tfrac{3}{4} + \dots$ is:', '["12","9","6","18"]'::jsonb, 0, '$a = 6$, $r = \tfrac{1}{2}$, so $S_{\infty} = \dfrac{6}{1 - 1/2} = 12$.', 'Geometric Progression'),
  ('The 6th term of a geometric progression with positive terms is 72 and the 8th term is 288. The common ratio is:', '["4","2","3","$\\sqrt{2}$"]'::jsonb, 1, '$\dfrac{T_{8}}{T_{6}} = r^{2} = 4$, so $r = 2$.', 'Geometric Progression'),
  ('For that progression ($T_{6} = 72$, $r = 2$), the sum of the first 5 terms is:', '["72","62","69.75","93"]'::jsonb, 2, '$a = \dfrac{72}{2^{5}} = 2.25$. $S_{5} = a\,\dfrac{2^{5} - 1}{2 - 1} = 2.25 \times 31 = 69.75$.', 'Geometric Progression'),
  ('The coefficient of $(xy)^{5}$ in the expansion of $\left(x + \dfrac{y}{4}\right)^{10}$ is:', '["$\\dfrac{63}{1024}$","$\\dfrac{252}{4}$","$\\dfrac{63}{128}$","$\\dfrac{63}{256}$"]'::jsonb, 3, 'The term is $\binom{10}{5}x^{5}\left(\dfrac{y}{4}\right)^{5} = \dfrac{252}{1024}x^{5}y^{5} = \dfrac{63}{256}(xy)^{5}$.', 'Binomial Theorem'),
  ('When the polynomial $f(x) = x^{3} + 3x^{2} + ax - 2$ is divided by $x - 3$ the remainder is 100. The value of $a$ is:', '["16","12","18","14"]'::jsonb, 0, '$f(3) = 27 + 27 + 3a - 2 = 52 + 3a = 100$, so $a = 16$.', 'Remainder Theorem'),
  ('The binomial expansion of $(1 + x)^{n}$, with $n$ not a positive integer, is valid for:', '["$|x| > 1$","$|x| < 1$","all real values of $x$","$x > 0$ only"]'::jsonb, 1, 'The infinite series converges only when $-1 < x < 1$. For a positive integer $n$ the expansion is finite and holds for every $x$.', 'Binomial Theorem'),
  ('The solution of the inequality $2x^{2} - 3x - 2 < 0$ is:', '["$x < -\\dfrac{1}{2}$ or $x > 2$","$x < 2$","$-\\dfrac{1}{2} < x < 2$","$-2 < x < \\dfrac{1}{2}$"]'::jsonb, 2, '$2x^{2} - 3x - 2 = (2x + 1)(x - 2)$, which is negative between the roots $-\tfrac{1}{2}$ and $2$.', 'Quadratic Inequalities'),
  ('In how many ways can a committee of 2 men and 2 women be formed from 3 men and 5 women?', '["60","15","45","30"]'::jsonb, 3, '${}^{3}C_{2} \times {}^{5}C_{2} = 3 \times 10 = 30$.', 'Combinations'),
  ('Solve $\sqrt{2x + 3} - \sqrt{x - 2} = 2$.', '["$x = 3$ or $x = 11$","$x = 3$ only","$x = 11$ only","$x = 2$ or $x = 14$"]'::jsonb, 0, 'Write $\sqrt{2x + 3} = 2 + \sqrt{x - 2}$ and square: $x + 1 = 4\sqrt{x - 2}$. Squaring again: $x^{2} - 14x + 33 = 0$, so $x = 3$ or $x = 11$. Both satisfy the original equation (3: $3 - 1 = 2$; 11: $5 - 3 = 2$).', 'Radical Equations'),
  ('Simplify $(\sin\theta + \cos\theta)^{2} + (\sin\theta - \cos\theta)^{2}$.', '["1","2","$2\\sin\\theta\\cos\\theta$","0"]'::jsonb, 1, 'Expanding: $2\sin^{2}\theta + 2\cos^{2}\theta = 2$.', 'Trigonometric Identities'),
  ('Solve $\cos 2\theta + 1 = \cos\theta$ for $0 \leq \theta < 2\pi$.', '["$\\theta = 0,\\ \\dfrac{\\pi}{3},\\ \\dfrac{5\\pi}{3}$","$\\theta = \\dfrac{\\pi}{2},\\ \\dfrac{3\\pi}{2}$ only","$\\theta = \\dfrac{\\pi}{3},\\ \\dfrac{\\pi}{2},\\ \\dfrac{3\\pi}{2},\\ \\dfrac{5\\pi}{3}$","$\\theta = \\dfrac{\\pi}{6},\\ \\dfrac{5\\pi}{6},\\ \\dfrac{7\\pi}{6},\\ \\dfrac{11\\pi}{6}$"]'::jsonb, 2, '$\cos 2\theta + 1 = 2\cos^{2}\theta$, so $2\cos^{2}\theta = \cos\theta$ and $\cos\theta(2\cos\theta - 1) = 0$. Hence $\cos\theta = 0$ or $\tfrac{1}{2}$: $\theta = \tfrac{\pi}{2}, \tfrac{3\pi}{2}, \tfrac{\pi}{3}, \tfrac{5\pi}{3}$.', 'Trigonometric Equations'),
  ('If $\cos A = \dfrac{4}{5}$ and $\sin B = \dfrac{12}{13}$, with $A$ acute and $B$ obtuse, then $\tan(A + B)$ equals:', '["$\\dfrac{33}{56}$","$\\dfrac{63}{16}$","$-\\dfrac{16}{63}$","$-\\dfrac{33}{56}$"]'::jsonb, 3, '$\tan A = \tfrac{3}{4}$. For obtuse $B$, $\cos B = -\tfrac{5}{13}$, so $\tan B = -\tfrac{12}{5}$. Then $\tan(A + B) = \dfrac{\tfrac{3}{4} - \tfrac{12}{5}}{1 + \tfrac{3}{4}\cdot\tfrac{12}{5}} = \dfrac{-33/20}{14/5} = -\dfrac{33}{56}$.', 'Compound Angles'),
  ('If $z = \dfrac{1}{1 + i}$, then $z$ in the form $x + iy$ is:', '["$\\dfrac{1}{2} - \\dfrac{1}{2}i$","$\\dfrac{1}{2} + \\dfrac{1}{2}i$","$1 - i$","$-\\dfrac{1}{2} - \\dfrac{1}{2}i$"]'::jsonb, 0, 'Multiply by the conjugate: $\dfrac{1 - i}{(1 + i)(1 - i)} = \dfrac{1 - i}{2}$.', 'Complex Numbers'),
  ('The principal argument of $z = \dfrac{1}{25i}$ is:', '["$\\dfrac{\\pi}{2}$","$-\\dfrac{\\pi}{2}$","$\\pi$","$0$"]'::jsonb, 1, '$\dfrac{1}{25i} = -\dfrac{i}{25}$, which lies on the negative imaginary axis, so $\operatorname{Arg} z = -\tfrac{\pi}{2}$ (and $\arg z = -\tfrac{\pi}{2} + 2k\pi$).', 'Complex Numbers'),
  ('The principal argument of $z = \dfrac{1}{1 - 3i}$ is:', '["$-\\tan^{-1}3$","$\\tan^{-1}\\dfrac{1}{3}$","$\\tan^{-1}3$","$\\dfrac{\\pi}{2}$"]'::jsonb, 2, '$z = \dfrac{1 + 3i}{10}$ lies in the first quadrant, so $\operatorname{Arg} z = \tan^{-1}\dfrac{3/10}{1/10} = \tan^{-1}3 \approx 1.249$ rad.', 'Complex Numbers'),
  ('The value of $\left(1 + \dfrac{1}{i}\right)^{8}$ is:', '["-16","$16i$","256","16"]'::jsonb, 3, '$1 + \tfrac{1}{i} = 1 - i = \sqrt{2}\,(\cos\tfrac{\pi}{4} - i\sin\tfrac{\pi}{4})$. By De Moivre, the 8th power has modulus $(\sqrt{2})^{8} = 16$ and argument $-2\pi$, so the value is $16$.', 'De Moivre''s Theorem')
),
tgt as (
  select subject_id, subject_name, faculty, department, level, semester, units
    from public.cbt_questions
   where subject_name ilike 'MTH 101%' and subject_id not like '%coming-soon'
   limit 1
)
insert into public.cbt_questions
  (subject_id, subject_name, institution, faculty, department, level,
   question, options, correct_index, explanation, topic, is_general, semester, units)
select coalesce(t.subject_id, 'mth-101-elementary-mathematics-1'),
       coalesce(t.subject_name, 'MTH 101: Elementary Mathematics I'),
       'University of Nigeria, Nsukka',
       coalesce(t.faculty, 'Faculty of Physical Sciences, Faculty of Engineering, Faculty of Biological Sciences, Faculty of Social Sciences, Faculty of Education'),
       coalesce(t.department, 'Mathematics'),
       coalesce(t.level, '100 Level'),
       s.question, s.options, s.correct_index, s.explanation, s.topic, false,
       coalesce(t.semester, 'first'),
       coalesce(t.units, 2)
  from src s
  left join tgt t on true
 where not exists (
   select 1 from public.cbt_questions c
    where c.subject_id = coalesce(t.subject_id, 'mth-101-elementary-mathematics-1') and c.question = s.question);

select subject_id, subject_name, count(*) as questions
  from public.cbt_questions
 where subject_name ilike 'MTH 101%' and subject_id not like '%coming-soon'
 group by 1, 2;
