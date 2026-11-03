-- MTH 103 (old MTH 121): questions from the MTH 103 CA workbook (Chapters 2 and 3)
-- =============================================================================
-- 35 questions. Every answer was re-solved and the calculus results were checked
-- numerically (finite differences and numerical integration). The circled answers and
-- the handwritten solutions in the scan were NOT trusted. Corrections to the scan:
--   * the range of y = 8 + 1/(3x) is every real number except 8 (the scan gave 8/3);
--   * the antiderivative of (3x^2 + 2x - 4)/(7x^2 - 9x + 2) is
--     3x/7 + (156/245) ln|7x - 2| + (1/5) ln|x - 1| + C (the scan's coefficients
--     were wrong);
--   * the normal to 9x^2 - 4y^2 = 108 at (4, 3) is x + 3y - 13 = 0.
-- Items whose printed text was unreadable or inconsistent (the continuity question with
-- two different points, several blurred practice questions) were dropped.
-- ADDS ONLY to the existing MTH 103 paper; repeats are skipped.
-- =============================================================================
with src (question, options, correct_index, explanation, topic) as (
values
  ('The normals to the curve $y = x + \dfrac{1}{x}$ at the points where $x = \dfrac{1}{2}$ and $x = 1$ meet at:', '["$\\left(1, \\dfrac{8}{3}\\right)$","$\\left(1, \\dfrac{5}{2}\\right)$","$\\left(\\dfrac{1}{2}, \\dfrac{8}{3}\\right)$","$\\left(\\dfrac{8}{3}, 1\\right)$"]'::jsonb, 0, '$\dfrac{dy}{dx} = 1 - \dfrac{1}{x^{2}}$. At $x = 1$ the gradient is 0, so the normal there is the vertical line $x = 1$. At $x = \tfrac{1}{2}$ the point is $\left(\tfrac{1}{2}, \tfrac{5}{2}\right)$ with gradient $-3$, so the normal has gradient $\tfrac{1}{3}$: $y - \tfrac{5}{2} = \tfrac{1}{3}\left(x - \tfrac{1}{2}\right)$. At $x = 1$, $y = \tfrac{5}{2} + \tfrac{1}{6} = \tfrac{8}{3}$.', 'Tangents and Normals'),
  ('The area enclosed between the curves $y = x^{2}$ and $y = 8 - x^{2}$ is:', '["$\\dfrac{32}{3}$","$\\dfrac{64}{3}$","$64$","$\\dfrac{128}{3}$"]'::jsonb, 1, 'The curves meet where $x^{2} = 8 - x^{2}$, i.e. $x = \pm2$. Area $= \int_{-2}^{2}(8 - 2x^{2})\,dx = \left[8x - \dfrac{2x^{3}}{3}\right]_{-2}^{2} = 2\left(16 - \dfrac{16}{3}\right) = \dfrac{64}{3}$. (The line $y = 4x + 12$ touches $y = 8 - x^{2}$ at $(-2, 4)$ and does not change this region.)', 'Area Under a Curve'),
  ('The domain of $y = \sqrt{\dfrac{x - 2}{x + 1}}$ is:', '["$(-1, 2]$","$(-\\infty, -1] \\cup [2, \\infty)$","$(-\\infty, -1) \\cup [2, \\infty)$","$[2, \\infty)$"]'::jsonb, 2, 'We need $\dfrac{x - 2}{x + 1} \geq 0$ with $x \neq -1$. The sign is positive for $x < -1$ and $x \geq 2$ (zero at $x = 2$).', 'Domain and Range'),
  ('The function $f(x) = \dfrac{x^{2} - 6x + 5}{x^{2} - 4x + 3}$ has at $x = 1$:', '["an infinite discontinuity","a jump discontinuity","no discontinuity","a removable discontinuity"]'::jsonb, 3, '$f(x) = \dfrac{(x - 1)(x - 5)}{(x - 1)(x - 3)}$. The factor $(x - 1)$ cancels, so $\lim_{x\to1} f(x) = \dfrac{-4}{-2} = 2$ exists while $f(1)$ is undefined: a removable discontinuity.', 'Continuity'),
  ('The function $f(x) = \dfrac{x^{2} - 6x + 5}{x^{2} - 4x + 3}$ has at $x = 3$:', '["an infinite discontinuity","a removable discontinuity","a jump discontinuity","no discontinuity"]'::jsonb, 0, 'At $x = 3$ the denominator is zero while the numerator $(3 - 1)(3 - 5) = -4$ is not, so the function becomes unbounded (a vertical asymptote).', 'Continuity'),
  ('If $y = (1 + x^{3})^{4}\sec(5x + 2)$, then $\dfrac{dy}{dx} =$', '["$12x^{2}(1 + x^{3})^{3}\\sec(5x + 2) + (1 + x^{3})^{4}\\sec(5x + 2)\\tan(5x + 2)$","$12x^{2}(1 + x^{3})^{3}\\sec(5x + 2) + 5(1 + x^{3})^{4}\\sec(5x + 2)\\tan(5x + 2)$","$4(1 + x^{3})^{3}\\sec(5x + 2) + 5(1 + x^{3})^{4}\\tan(5x + 2)$","$12x^{2}(1 + x^{3})^{3}\\cdot5\\sec(5x + 2)\\tan(5x + 2)$"]'::jsonb, 1, 'Product rule with $u = (1 + x^{3})^{4}$ (so $u^{\prime} = 12x^{2}(1 + x^{3})^{3}$) and $v = \sec(5x + 2)$ (so $v^{\prime} = 5\sec(5x + 2)\tan(5x + 2)$): $u^{\prime}v + uv^{\prime}$.', 'Product Rule'),
  ('If $x = t^{2} + 1$ and $y = t^{3} + t$, then $\dfrac{dy}{dx} =$', '["$\\dfrac{2t}{3t^{2} + 1}$","$\\dfrac{3t^{2} + 1}{t^{2}}$","$\\dfrac{3t^{2} + 1}{2t}$","$6t^{2} + 2t$"]'::jsonb, 2, '$\dfrac{dy}{dx} = \dfrac{dy/dt}{dx/dt} = \dfrac{3t^{2} + 1}{2t}$.', 'Parametric Differentiation'),
  ('For $f(x) = x^{3} - 6x^{2} + 12x - 8$, the function is:', '["decreasing for all $x$ and concave up everywhere","increasing for $x > 2$ only and concave down everywhere","increasing for $x < 2$ and decreasing for $x > 2$","increasing for all $x$, concave down for $x < 2$ and concave up for $x > 2$"]'::jsonb, 3, '$f(x) = (x - 2)^{3}$, so $f^{\prime}(x) = 3(x - 2)^{2} \geq 0$ (increasing everywhere) and $f^{\prime\prime}(x) = 6(x - 2)$, which is negative for $x < 2$ and positive for $x > 2$.', 'Concavity and Inflexion'),
  ('The point of inflexion of $f(x) = x^{3} - 6x^{2} + 12x - 8$ is:', '["$(2, 0)$","$(2, 8)$","$(0, -8)$","$(1, -1)$"]'::jsonb, 0, '$f^{\prime\prime}(x) = 6(x - 2) = 0$ at $x = 2$ with a sign change, and $f(2) = 0$.', 'Concavity and Inflexion'),
  ('The antiderivative of $\dfrac{3x^{2} + 2x - 4}{7x^{2} - 9x + 2}$ is:', '["$\\dfrac{3x}{7} + \\dfrac{1}{5}\\ln|7x - 2| + \\dfrac{156}{245}\\ln|x - 1| + C$","$\\dfrac{3x}{7} + \\dfrac{156}{245}\\ln|7x - 2| + \\dfrac{1}{5}\\ln|x - 1| + C$","$\\dfrac{3x}{7} + \\dfrac{156}{245}\\ln|7x - 2| - \\dfrac{1}{5}\\ln|x - 1| + C$","$\\dfrac{3x}{7} + \\ln|7x^{2} - 9x + 2| + C$"]'::jsonb, 1, 'Divide first: $\dfrac{3x^{2} + 2x - 4}{7x^{2} - 9x + 2} = \dfrac{3}{7} + \dfrac{\tfrac{41}{7}x - \tfrac{34}{7}}{(7x - 2)(x - 1)}$. Partial fractions: $\dfrac{\tfrac{41}{7}x - \tfrac{34}{7}}{(7x - 2)(x - 1)} = \dfrac{156/35}{7x - 2} + \dfrac{1/5}{x - 1}$. Integrating gives the result shown. (Differentiating it returns the original function.)', 'Integration by Partial Fractions'),
  ('Evaluate $\displaystyle\int \sin^{5}x\cos^{4}x\,dx$.', '["$\\dfrac{\\cos^{5}x}{5} - \\dfrac{2\\cos^{7}x}{7} + \\dfrac{\\cos^{9}x}{9} + C$","$-\\dfrac{\\cos^{5}x}{5} - \\dfrac{2\\cos^{7}x}{7} - \\dfrac{\\cos^{9}x}{9} + C$","$-\\dfrac{\\cos^{5}x}{5} + \\dfrac{2\\cos^{7}x}{7} - \\dfrac{\\cos^{9}x}{9} + C$","$\\dfrac{\\sin^{6}x}{6}\\cdot\\dfrac{\\cos^{5}x}{5} + C$"]'::jsonb, 2, 'Write $\sin^{5}x = (1 - \cos^{2}x)^{2}\sin x$ and put $u = \cos x$, $du = -\sin x\,dx$: $-\int(1 - u^{2})^{2}u^{4}\,du = -\left(\dfrac{u^{5}}{5} - \dfrac{2u^{7}}{7} + \dfrac{u^{9}}{9}\right)$.', 'Integration by Substitution'),
  ('If $f(x) = \dfrac{2x + 1}{x - 3}$, then $f^{-1}(3) =$', '["$7$","$\\dfrac{7}{0}$","$-10$","$10$"]'::jsonb, 3, 'Solve $y = \dfrac{2x + 1}{x - 3}$ for $x$: $xy - 3y = 2x + 1$, so $x = \dfrac{3y + 1}{y - 2}$. Then $f^{-1}(3) = \dfrac{10}{1} = 10$.', 'Inverse Functions'),
  ('The range of $y = 8 + \dfrac{1}{3x}$ is:', '["$(-\\infty, 8) \\cup (8, \\infty)$","$\\left(-\\infty, \\dfrac{8}{3}\\right) \\cup \\left(\\dfrac{8}{3}, \\infty\\right)$","$(-\\infty, \\infty)$","$(8, \\infty)$"]'::jsonb, 0, '$\dfrac{1}{3x}$ takes every non-zero real value (it is never 0), so $y = 8 + \dfrac{1}{3x}$ takes every real value except 8. (Solving for $x$: $x = \dfrac{1}{3(y - 8)}$, which needs $y \neq 8$.)', 'Domain and Range'),
  ('Evaluate $\displaystyle\int_{0}^{1}\sqrt{4 - x^{2}}\,dx$.', '["$\\dfrac{\\sqrt{3}}{2} + \\dfrac{\\pi}{6}$","$\\dfrac{\\sqrt{3}}{2} + \\dfrac{\\pi}{3}$","$\\sqrt{3} + \\dfrac{\\pi}{3}$","$\\dfrac{\\pi}{3}$"]'::jsonb, 1, 'Use $\int\sqrt{a^{2} - x^{2}}\,dx = \dfrac{x}{2}\sqrt{a^{2} - x^{2}} + \dfrac{a^{2}}{2}\sin^{-1}\dfrac{x}{a}$ with $a = 2$. At $x = 1$: $\dfrac{\sqrt{3}}{2} + 2\cdot\dfrac{\pi}{6}$; at $x = 0$ it is 0.', 'Definite Integrals'),
  ('If $y = (x^{2} + 1)^{6}$, then $\dfrac{dy}{dx} =$', '["$6(x^{2} + 1)^{5}$","$12(x^{2} + 1)^{5}$","$12x(x^{2} + 1)^{5}$","$6x(x^{2} + 1)^{5}$"]'::jsonb, 2, 'Chain rule: $6(x^{2} + 1)^{5}\cdot2x$.', 'Chain Rule'),
  ('The derivative of $\ln\sqrt{x^{2} + 3}$ is:', '["$\\dfrac{2x}{x^{2} + 3}$","$\\dfrac{1}{2(x^{2} + 3)}$","$\\dfrac{x}{\\sqrt{x^{2} + 3}}$","$\\dfrac{x}{x^{2} + 3}$"]'::jsonb, 3, '$\ln\sqrt{x^{2} + 3} = \tfrac{1}{2}\ln(x^{2} + 3)$, so the derivative is $\tfrac{1}{2}\cdot\dfrac{2x}{x^{2} + 3} = \dfrac{x}{x^{2} + 3}$.', 'Differentiation of Logarithmic Functions'),
  ('Evaluate $\displaystyle\int \cos^{2}x\,dx$.', '["$\\dfrac{1}{2}\\left(x + \\dfrac{1}{2}\\sin 2x\\right) + C$","$\\dfrac{1}{2}\\left(x - \\dfrac{1}{2}\\sin 2x\\right) + C$","$\\dfrac{1}{3}\\cos^{3}x + C$","$\\dfrac{1}{2}\\left(x + \\sin 2x\\right) + C$"]'::jsonb, 0, 'Use $\cos^{2}x = \dfrac{1 + \cos 2x}{2}$: $\dfrac{1}{2}\left(x + \dfrac{\sin 2x}{2}\right) + C$.', 'Indefinite Integrals'),
  ('The area bounded by the curve $y = 5x - 2x^{2}$ and the line $y = x$ is:', '["$\\dfrac{16}{3}$","$\\dfrac{8}{3}$","$\\dfrac{14}{3}$","$\\dfrac{40}{3}$"]'::jsonb, 1, 'Setting $5x - 2x^{2} = x$ gives $x = 0$ and $x = 2$. Area $= \int_{0}^{2}(4x - 2x^{2})\,dx = \left[2x^{2} - \dfrac{2x^{3}}{3}\right]_{0}^{2} = 8 - \dfrac{16}{3} = \dfrac{8}{3}$.', 'Area Under a Curve'),
  ('The area bounded by the curves $y = x^{2}$ and $y = x$ is:', '["$\\dfrac{1}{3}$","$\\dfrac{1}{2}$","$\\dfrac{1}{6}$","$\\dfrac{1}{4}$"]'::jsonb, 2, '$\int_{0}^{1}(x - x^{2})\,dx = \dfrac{1}{2} - \dfrac{1}{3} = \dfrac{1}{6}$.', 'Area Under a Curve'),
  ('If $f(x) = 2 + \ln x$, then $f^{-1}(x) =$', '["$e^{x} - 2$","$e^{x + 2}$","$e^{2x}$","$e^{x - 2}$"]'::jsonb, 3, 'Let $y = 2 + \ln x$. Then $\ln x = y - 2$ and $x = e^{y - 2}$.', 'Inverse Functions'),
  ('The point of inflexion of $f(x) = 2x^{3} - 3x^{2} + 2$ is:', '["$\\left(\\dfrac{1}{2}, \\dfrac{3}{2}\\right)$","$\\left(\\dfrac{1}{2}, \\dfrac{1}{2}\\right)$","$\\left(-\\dfrac{1}{2}, \\dfrac{3}{2}\\right)$","$(1, 1)$"]'::jsonb, 0, '$f^{\prime\prime}(x) = 12x - 6 = 0$ gives $x = \tfrac{1}{2}$, and $f\left(\tfrac{1}{2}\right) = \tfrac{1}{4} - \tfrac{3}{4} + 2 = \tfrac{3}{2}$.', 'Concavity and Inflexion'),
  ('The relative minimum point of $f(x) = \dfrac{x^{3}}{3} + \dfrac{5x^{2}}{2} + 4x + 3$ is:', '["$\\left(-4, \\dfrac{7}{6}\\right)$","$\\left(-1, \\dfrac{7}{6}\\right)$","$\\left(-1, -\\dfrac{7}{6}\\right)$","$\\left(1, \\dfrac{47}{6}\\right)$"]'::jsonb, 1, '$f^{\prime}(x) = x^{2} + 5x + 4 = (x + 1)(x + 4)$. With $f^{\prime\prime}(x) = 2x + 5$, which is positive at $x = -1$, the minimum is at $x = -1$ and $f(-1) = -\tfrac{1}{3} + \tfrac{5}{2} - 4 + 3 = \tfrac{7}{6}$.', 'Maxima and Minima'),
  ('The equation of the tangent to the circle $x^{2} + y^{2} = 1$ at the point $(0, 1)$ is:', '["$x = 1$","$y = -1$","$y = 1$","$x = 0$"]'::jsonb, 2, 'The tangent is perpendicular to the radius to $(0, 1)$, which is vertical, so the tangent is horizontal: $y = 1$.', 'Tangents and Normals'),
  ('If $s(t) = 2t^{3} + 2t^{2} + 5t - 20$ metres is the position of a moving object, its acceleration at $t = 2$ s is:', '["$12t + 4\\ \\text{m/s}^{2}$","$5\\ \\text{m/s}^{2}$","$6t^{2} + 4t + 5\\ \\text{m/s}^{2}$","$28\\ \\text{m/s}^{2}$"]'::jsonb, 3, '$s^{\prime}(t) = 6t^{2} + 4t + 5$ and $s^{\prime\prime}(t) = 12t + 4$. At $t = 2$: $12(2) + 4 = 28$.', 'Differentiation'),
  ('The equation of the normal to the curve $y^{2} - 2x^{2} - 2 = 0$ at the point $(1, 2)$ is:', '["$x + y - 3 = 0$","$x - y + 1 = 0$","$2x + y - 4 = 0$","$x + 2y - 5 = 0$"]'::jsonb, 0, 'Differentiating implicitly: $2y\dfrac{dy}{dx} = 4x$, so $\dfrac{dy}{dx} = \dfrac{2x}{y} = 1$ at $(1, 2)$. The normal has gradient $-1$: $y - 2 = -(x - 1)$, i.e. $x + y - 3 = 0$.', 'Tangents and Normals'),
  ('The equation of the normal to the curve $9x^{2} - 4y^{2} = 108$ at the point $(4, 3)$ is:', '["$x - 3y + 5 = 0$","$x + 3y - 13 = 0$","$3x + y - 15 = 0$","$3x - y - 9 = 0$"]'::jsonb, 1, '$18x - 8y\dfrac{dy}{dx} = 0$ gives $\dfrac{dy}{dx} = \dfrac{9x}{4y} = 3$ at $(4, 3)$. The normal has gradient $-\tfrac{1}{3}$: $y - 3 = -\tfrac{1}{3}(x - 4)$, i.e. $x + 3y - 13 = 0$.', 'Tangents and Normals'),
  ('The absolute maximum value of $f(x) = x^{2} + 4x + 1$ on the interval $[0, 2]$ is:', '["$1$","$-3$","$13$","$5$"]'::jsonb, 2, '$f^{\prime}(x) = 2x + 4 > 0$ on the interval, so $f$ is increasing and the maximum is $f(2) = 4 + 8 + 1 = 13$ (the minimum is $f(0) = 1$).', 'Maxima and Minima'),
  ('For $f(x) = x^{2}$, the limit $\displaystyle\lim_{x\to c}\dfrac{f(x) - f(c)}{x - c}$ equals:', '["$c$","$c^{2}$","$2$","$2c$"]'::jsonb, 3, '$\dfrac{x^{2} - c^{2}}{x - c} = x + c \to 2c$. This is the derivative of $x^{2}$ at $x = c$.', 'Limits'),
  ('Evaluate $\displaystyle\int \dfrac{x + 4}{(x^{2} + 8x)^{6}}\,dx$.', '["$-\\dfrac{1}{10(x^{2} + 8x)^{5}} + C$","$\\dfrac{1}{10(x^{2} + 8x)^{5}} + C$","$-\\dfrac{1}{5(x^{2} + 8x)^{5}} + C$","$-\\dfrac{1}{10(x^{2} + 8x)^{7}} + C$"]'::jsonb, 0, 'Let $u = x^{2} + 8x$, so $du = 2(x + 4)\,dx$. Then $\dfrac{1}{2}\int u^{-6}\,du = \dfrac{1}{2}\cdot\dfrac{u^{-5}}{-5} = -\dfrac{1}{10u^{5}}$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\int \dfrac{e^{x} - e^{-x}}{e^{x} + e^{-x}}\,dx$.', '["$\\ln\\left(e^{x} - e^{-x}\\right) + C$","$\\ln\\left(e^{x} + e^{-x}\\right) + C$","$e^{x} + e^{-x} + C$","$\\dfrac{1}{2}\\ln\\left(e^{2x} + e^{-2x}\\right) + C$"]'::jsonb, 1, 'The numerator is the derivative of the denominator, so the integral is $\ln|\text{denominator}| + C$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\int \cos^{3}6x\sin 6x\,dx$.', '["$\\dfrac{\\cos^{4}6x}{24} + C$","$-\\dfrac{\\cos^{4}6x}{4} + C$","$-\\dfrac{\\cos^{4}6x}{24} + C$","$\\dfrac{\\sin^{4}6x}{24} + C$"]'::jsonb, 2, 'Let $u = \cos 6x$, so $du = -6\sin 6x\,dx$. Then $-\dfrac{1}{6}\int u^{3}\,du = -\dfrac{u^{4}}{24}$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\int \dfrac{x + 2}{x^{2} + 4x + 5}\,dx$.', '["$\\ln(x^{2} + 4x + 5) + C$","$\\dfrac{1}{x^{2} + 4x + 5} + C$","$2\\ln(x^{2} + 4x + 5) + C$","$\\dfrac{1}{2}\\ln(x^{2} + 4x + 5) + C$"]'::jsonb, 3, 'The derivative of the denominator is $2x + 4 = 2(x + 2)$, so the integral is $\dfrac{1}{2}\ln(x^{2} + 4x + 5) + C$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\int 6x\sin(3x^{2} + 7)\,dx$.', '["$-\\cos(3x^{2} + 7) + C$","$\\cos(3x^{2} + 7) + C$","$-\\dfrac{1}{6}\\cos(3x^{2} + 7) + C$","$\\sin(3x^{2} + 7) + C$"]'::jsonb, 0, 'Let $u = 3x^{2} + 7$, so $du = 6x\,dx$ and the integral is $\int\sin u\,du = -\cos u$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\lim_{x\to 0}\dfrac{1 - \cos x}{x\sin x}$.', '["$1$","$\\dfrac{1}{2}$","$0$","$2$"]'::jsonb, 1, 'Near 0, $1 - \cos x \approx \tfrac{x^{2}}{2}$ and $x\sin x \approx x^{2}$, so the limit is $\tfrac{1}{2}$.', 'Standard Limits'),
  ('Differentiate $y = x^{x}$ and the derivative at $x = 1$ equals:', '["$0$","$e$","$1$","$2$"]'::jsonb, 2, '$y^{\prime} = x^{x}(1 + \ln x)$, which at $x = 1$ is $1\cdot(1 + 0) = 1$.', 'Logarithmic Differentiation')
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
