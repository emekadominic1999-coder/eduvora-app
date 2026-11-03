-- MTH 103 (old MTH 121): questions from the MTH 121 CA workbook (practice set 1 and Chapter 3)
-- =============================================================================
-- 25 questions. Same department workbook series as the MTH 103 workbook, with a
-- different continuous-assessment chapter. Every answer was re-solved and the results were
-- checked numerically. Corrections to the scan:
--   * the area under 3x^2 + 2x - 3 from -5 to 2 is about 100.37 (the scan's 100.58 used
--     rounded roots; integrating without splitting gives the signed value 91);
--   * the local minimum of 2x^3 - 3x^2 - 36x + 34 is (3, -47);
--   * the range of y = 4 + 1/(2x) is every real number except 4 (the scan said 2);
--   * the velocity at t = 4 is -103 and the acceleration is -38.25.
-- Dropped: "normal to y = 13x - 7 at (1, 4)" and "tangent ... at (4, 10)" because the
-- stated point is not on the curve. Questions identical to ones already in the MTH 103
-- paper are skipped automatically.
-- ADDS ONLY to the existing MTH 103 paper; repeats are skipped.
-- =============================================================================
with src (question, options, correct_index, explanation, topic) as (
values
  ('Find the area bounded by $y = 3x^{2} + 2x - 3$, the $x$-axis and the lines $x = -5$ and $x = 2$.', '["$100.37$","$91$","$100.58$","$85$"]'::jsonb, 0, 'The curve crosses the $x$-axis at $x = \dfrac{-1 \pm \sqrt{10}}{3} \approx -1.387$ and $0.721$, so the area must be split. With $F(x) = x^{3} + x^{2} - 3x$: $|F(r_{1}) - F(-5)| + |F(r_{2}) - F(r_{1})| + |F(2) - F(r_{2})| \approx 100.37$. (Integrating straight from $-5$ to $2$ gives $F(2) - F(-5) = 91$, which is the signed area, not the area.)', 'Area Under a Curve'),
  ('The domain of $y = \dfrac{5x + 2}{x^{2} + 2x - 8}$ is:', '["$\\mathbb{R}\\setminus\\{4, -2\\}$","$\\mathbb{R}\\setminus\\{-4, 2\\}$","$\\mathbb{R}\\setminus\\{2\\}$","$(-4, 2)$"]'::jsonb, 1, '$x^{2} + 2x - 8 = (x + 4)(x - 2)$ is zero at $x = -4$ and $x = 2$, which must be excluded.', 'Domain and Range'),
  ('Evaluate $\displaystyle\lim_{x\to\infty}\dfrac{13 + x + 3x^{2}}{3x^{5} - 12}$.', '["$1$","$\\infty$","$0$","$\\dfrac{13}{-12}$"]'::jsonb, 2, 'The degree of the denominator (5) is higher than that of the numerator (2), so the fraction tends to 0.', 'Limits at Infinity'),
  ('If $y = e^{2x}\cos 4x$, then $\dfrac{dy}{dx} =$', '["$e^{2x}(2\\cos 4x + 4\\sin 4x)$","$-4e^{2x}\\sin 4x$","$2e^{2x}\\cos 4x$","$e^{2x}(2\\cos 4x - 4\\sin 4x)$"]'::jsonb, 3, 'Product rule: $2e^{2x}\cos 4x + e^{2x}(-4\sin 4x)$.', 'Product Rule'),
  ('The tangent to $y = 5x^{3} + 4x^{2} - 10x + 16$ at $x = 4$ meets the $y$-axis at:', '["$(0, -688)$","$(0, -1038)$","$(0, 360)$","$(0, 262)$"]'::jsonb, 0, '$y(4) = 320 + 64 - 40 + 16 = 360$ and $\dfrac{dy}{dx} = 15x^{2} + 8x - 10 = 262$ at $x = 4$. The tangent is $y - 360 = 262(x - 4)$, which gives $y = 360 - 1048 = -688$ at $x = 0$.', 'Tangents and Normals'),
  ('The local maximum point of $f(x) = 2x^{3} - 3x^{2} - 36x + 34$ is:', '["$(3, -47)$","$(-2, 78)$","$(-2, 34)$","$(2, -78)$"]'::jsonb, 1, '$f^{\prime}(x) = 6x^{2} - 6x - 36 = 6(x - 3)(x + 2)$. With $f^{\prime\prime}(x) = 12x - 6$: at $x = -2$ it is negative (maximum) and $f(-2) = -16 - 12 + 72 + 34 = 78$.', 'Maxima and Minima'),
  ('The local minimum point of $f(x) = 2x^{3} - 3x^{2} - 36x + 34$ is:', '["$(3, -42)$","$(-2, 78)$","$(3, -47)$","$(2, -47)$"]'::jsonb, 2, 'At $x = 3$, $f^{\prime\prime}(3) = 30 > 0$ (minimum) and $f(3) = 54 - 27 - 108 + 34 = -47$.', 'Maxima and Minima'),
  ('The function $f(x) = \begin{cases} 6x, & x \leq 1\\ 2k - 6x, & x > 1\end{cases}$ is continuous at $x = 1$ when $k$ equals:', '["$3$","$12$","$-6$","$6$"]'::jsonb, 3, 'Equate the two pieces at $x = 1$: $6 = 2k - 6$, so $2k = 12$ and $k = 6$.', 'Continuity'),
  ('If the position of a moving object is $s(t) = -16t^{2} + 50\ln t^{2} + 400$, its velocity at $t = 4$ is:', '["$-103$","$-128$","$-38.25$","$-135$"]'::jsonb, 0, '$s(t) = -16t^{2} + 100\ln t + 400$, so $v = s^{\prime}(t) = -32t + \dfrac{100}{t}$. At $t = 4$: $-128 + 25 = -103$ (units per second).', 'Differentiation'),
  ('For the same motion $s(t) = -16t^{2} + 50\ln t^{2} + 400$, the acceleration at $t = 4$ is:', '["$-103$","$-38.25$","$-31.4$","$-25.75$"]'::jsonb, 1, '$a = s^{\prime\prime}(t) = -32 - \dfrac{100}{t^{2}}$. At $t = 4$: $-32 - 6.25 = -38.25$.', 'Differentiation'),
  ('The area bounded by $y(x + 2) = x^{4}$, the $x$-axis, $x = 0$ and $x = 3$ is:', '["$16\\ln\\dfrac{5}{2} + \\dfrac{15}{4}$","$16\\ln 5 - \\dfrac{15}{4}$","$16\\ln\\dfrac{5}{2} - \\dfrac{15}{4}$","$\\dfrac{81}{4} - 16\\ln\\dfrac{5}{2}$"]'::jsonb, 2, 'By division, $\dfrac{x^{4}}{x + 2} = x^{3} - 2x^{2} + 4x - 8 + \dfrac{16}{x + 2}$. Integrating from 0 to 3: $\left[\dfrac{x^{4}}{4} - \dfrac{2x^{3}}{3} + 2x^{2} - 8x + 16\ln(x + 2)\right]_{0}^{3} = \dfrac{81}{4} - 24 + 16\ln 5 - 16\ln 2 = 16\ln\dfrac{5}{2} - \dfrac{15}{4} \approx 10.91$.', 'Area Under a Curve'),
  ('The range of $y = 4 + \dfrac{1}{2x}$ is:', '["$(-\\infty, 2) \\cup (2, \\infty)$","$(-\\infty, \\infty)$","$(4, \\infty)$","$(-\\infty, 4) \\cup (4, \\infty)$"]'::jsonb, 3, '$\dfrac{1}{2x}$ is never zero, so $y$ takes every real value except 4. (Solving for $x$: $x = \dfrac{1}{2(y - 4)}$, which needs $y \neq 4$.)', 'Domain and Range'),
  ('Evaluate $\displaystyle\lim_{x\to 0}\dfrac{\sin 7x - \sin 4x}{3x}$.', '["$1$","$3$","$-1$","$\\dfrac{11}{3}$"]'::jsonb, 0, '$\dfrac{\sin 7x}{3x} \to \dfrac{7}{3}$ and $\dfrac{\sin 4x}{3x} \to \dfrac{4}{3}$, so the limit is $\dfrac{7}{3} - \dfrac{4}{3} = 1$.', 'Standard Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 9}\dfrac{x - 9}{\sqrt{x} - 3}$.', '["$3$","$6$","$9$","$0$"]'::jsonb, 1, 'Factorise: $x - 9 = (\sqrt{x} - 3)(\sqrt{x} + 3)$, so the limit is $\sqrt{9} + 3 = 6$.', 'Limits'),
  ('Evaluate $\displaystyle\lim_{x\to\infty}\dfrac{2x - 1}{\sqrt{x^{2} - 1}}$.', '["$1$","$0$","$2$","$\\infty$"]'::jsonb, 2, 'Divide by $x$: $\dfrac{2 - 1/x}{\sqrt{1 - 1/x^{2}}} \to 2$.', 'Limits at Infinity'),
  ('Evaluate $\displaystyle\lim_{x\to 0}\dfrac{x\cos x - \sin x}{4x^{3}}$.', '["$\\dfrac{1}{12}$","$0$","$-\\dfrac{1}{4}$","$-\\dfrac{1}{12}$"]'::jsonb, 3, 'Using $\cos x \approx 1 - \dfrac{x^{2}}{2}$ and $\sin x \approx x - \dfrac{x^{3}}{6}$: the numerator is $-\dfrac{x^{3}}{2} + \dfrac{x^{3}}{6} = -\dfrac{x^{3}}{3}$, so the limit is $-\dfrac{1}{12}$.', 'L''Hôpital''s Rule'),
  ('If $x = e^{t} + \sin t$ and $y = e^{t} - \cos t$, then $\dfrac{dy}{dx} =$', '["$\\dfrac{e^{t} + \\sin t}{e^{t} + \\cos t}$","$\\dfrac{e^{t} - \\sin t}{e^{t} + \\cos t}$","$\\dfrac{e^{t} + \\cos t}{e^{t} + \\sin t}$","$\\dfrac{e^{t} + \\sin t}{e^{t} - \\cos t}$"]'::jsonb, 0, '$\dfrac{dx}{dt} = e^{t} + \cos t$ and $\dfrac{dy}{dt} = e^{t} + \sin t$, so $\dfrac{dy}{dx} = \dfrac{e^{t} + \sin t}{e^{t} + \cos t}$.', 'Parametric Differentiation'),
  ('If $y = e^{7x}\sin 3x$, then $\dfrac{dy}{dx}$ at $x = 0$ is:', '["$7$","$3$","$10$","$0$"]'::jsonb, 1, '$y^{\prime} = e^{7x}(7\sin 3x + 3\cos 3x)$, which equals $3$ at $x = 0$.', 'Product Rule'),
  ('If $y = \sin(\ln x^{5})$, then $\dfrac{dy}{dx} =$', '["$\\dfrac{1}{x}\\cos(\\ln x^{5})$","$5\\cos(\\ln x^{5})$","$\\dfrac{5}{x}\\cos(\\ln x^{5})$","$-\\dfrac{5}{x}\\sin(\\ln x^{5})$"]'::jsonb, 2, 'Chain rule: $\cos(\ln x^{5})\cdot\dfrac{d}{dx}(5\ln x) = \cos(\ln x^{5})\cdot\dfrac{5}{x}$.', 'Chain Rule'),
  ('If $y = 4\sin 2t$ and $x = 8e^{t}$, then $\dfrac{dy}{dx}$ at $t = 0$ is:', '["$0$","$2$","$-2$","$1$"]'::jsonb, 3, '$\dfrac{dy}{dx} = \dfrac{8\cos 2t}{8e^{t}} = \dfrac{\cos 2t}{e^{t}}$, which equals 1 at $t = 0$.', 'Parametric Differentiation'),
  ('The equation of the tangent to the circle $x^{2} + y^{2} = 1$ at the point $(0, -1)$ is:', '["$y = -1$","$y = 1$","$x = -1$","$x = 0$"]'::jsonb, 0, 'The radius to $(0, -1)$ is vertical, so the tangent is horizontal: $y = -1$.', 'Tangents and Normals'),
  ('Evaluate $\displaystyle\int \dfrac{3}{9 + x^{2}}\,dx$.', '["$\\dfrac{1}{3}\\tan^{-1}\\left(\\dfrac{x}{3}\\right) + C$","$\\tan^{-1}\\left(\\dfrac{x}{3}\\right) + C$","$\\sin^{-1}\\left(\\dfrac{x}{3}\\right) + C$","$3\\tan^{-1}\\left(\\dfrac{x}{3}\\right) + C$"]'::jsonb, 1, '$\int\dfrac{dx}{a^{2} + x^{2}} = \dfrac{1}{a}\tan^{-1}\dfrac{x}{a}$ with $a = 3$, and the factor 3 cancels the $\dfrac{1}{3}$.', 'Indefinite Integrals'),
  ('Evaluate $\displaystyle\int \dfrac{5x}{3x^{2} + 7}\,dx$.', '["$\\dfrac{5}{3}\\ln(3x^{2} + 7) + C$","$\\dfrac{3}{10}\\ln(5x^{2} + 7) + C$","$\\dfrac{5}{6}\\ln(3x^{2} + 7) + C$","$5\\ln(3x^{2} + 7) + C$"]'::jsonb, 2, 'The derivative of the denominator is $6x$, so $\dfrac{5}{6}\int\dfrac{6x}{3x^{2} + 7}\,dx = \dfrac{5}{6}\ln(3x^{2} + 7)$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\int_{0}^{3}\dfrac{dx}{6x + 1}$.', '["$\\dfrac{1}{4}\\ln 13$","$\\dfrac{1}{5}\\ln 16$","$\\dfrac{1}{3}\\ln 10$","$\\dfrac{1}{6}\\ln 19$"]'::jsonb, 3, '$\dfrac{1}{6}\left[\ln(6x + 1)\right]_{0}^{3} = \dfrac{1}{6}(\ln 19 - \ln 1) = \dfrac{1}{6}\ln 19$.', 'Definite Integrals'),
  ('The volume generated by revolving the area bounded by $y = x^{2}$ and $y = 4x$ about the $x$-axis is:', '["$\\dfrac{2048\\pi}{15}$","$\\dfrac{64\\pi}{15}$","$\\dfrac{162\\pi}{5}$","$\\dfrac{2\\pi}{15}$"]'::jsonb, 0, 'The curves meet at $x = 0$ and $x = 4$, with $y = 4x$ above. $V = \pi\int_{0}^{4}\left[(4x)^{2} - (x^{2})^{2}\right]dx = \pi\left[\dfrac{16x^{3}}{3} - \dfrac{x^{5}}{5}\right]_{0}^{4} = \pi\left(\dfrac{1024}{3} - \dfrac{1024}{5}\right) = \dfrac{2048\pi}{15}$.', 'Volume of Revolution')
),
tgt as (
  select subject_id, subject_name, faculty, department, level, semester, units
    from public.cbt_questions
   where subject_name ilike 'MTH 103%' and subject_id not like '%coming-soon'
   limit 1
)
insert into public.cbt_questions
  (subject_id, subject_name, institution, faculty, department, level,
   question, options, correct_index, explanation, topic, is_general, semester, units)
select coalesce(t.subject_id, 'mth-103-calculus'),
       coalesce(t.subject_name, 'MTH 103: Functions, Limits, Differentiation & Integration'),
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
    where c.subject_id = coalesce(t.subject_id, 'mth-103-calculus') and c.question = s.question);

select subject_id, subject_name, count(*) as questions
  from public.cbt_questions
 where subject_name ilike 'MTH 103%' and subject_id not like '%coming-soon'
 group by 1, 2;
