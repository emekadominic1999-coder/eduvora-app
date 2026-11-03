-- EDUVORA: ALL NEW MATHS (MTH 103 calculus) IN ONE FILE
-- Paste this whole file into the Supabase SQL editor and click Run ONCE.
-- It only ADDS questions to the existing MTH 103 paper. Nothing is deleted or renamed. Repeats are skipped.

-- ============ PART 1: unn_mth103_additional_cbt_questions.sql ============
-- MTH 103: Elementary Mathematics II (calculus; old code MTH 121) -- additional questions
-- =============================================================================
-- 154 original questions with computed answers on limits (including L'Hopital),
-- continuity, differentiation (chain, product, quotient, implicit, parametric,
-- logarithmic), applications (tangents, stationary points, inflexion, asymptotes,
-- optimisation, related rates, mean value theorem, Newton-Raphson), integration
-- (substitution, parts, partial fractions, areas, volumes, numerical methods),
-- and functions. The numeric items were checked in code against finite differences
-- and numerical integration. They cover topics the existing MTH 103 / MTH 121 banks
-- hold few or none of (limits, integration techniques, related rates, implicit and
-- parametric differentiation, continuity). The textbooks, the "PUN LN" chapter notes,
-- the student fillers and the Obasi notes were used only to confirm the topic list.
-- ADDS ONLY to the existing MTH 103 paper; repeats are skipped.
-- =============================================================================
with src (question, options, correct_index, explanation, topic) as (
values
  ('Evaluate $\displaystyle\lim_{x\to 2}\dfrac{x^{2} - 4}{x - 2}$.', '["$4$","$2$","$0$","$5$"]'::jsonb, 0, 'Factorise the numerator: $\dfrac{(x - 2)(x + 2)}{x - 2} = x + 2$, so the limit is $2 + 2 = 4$.', 'Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 3}\dfrac{x^{2} - 9}{x - 3}$.', '["$3$","$6$","$9$","$0$"]'::jsonb, 1, 'Factorise the numerator: $\dfrac{(x - 3)(x + 3)}{x - 3} = x + 3$, so the limit is $3 + 3 = 6$.', 'Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 1}\dfrac{x^{2} - 1}{x - 1}$.', '["$1$","$0$","$2$","$3$"]'::jsonb, 2, 'Factorise the numerator: $\dfrac{(x - 1)(x + 1)}{x - 1} = x + 1$, so the limit is $1 + 1 = 2$.', 'Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 5}\dfrac{x^{2} - 25}{x - 5}$.', '["$5$","$25$","$0$","$10$"]'::jsonb, 3, 'Factorise the numerator: $\dfrac{(x - 5)(x + 5)}{x - 5} = x + 5$, so the limit is $5 + 5 = 10$.', 'Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 1}\dfrac{x^{3} - 1}{x - 1}$.', '["$3$","$1$","$6$","$4$"]'::jsonb, 0, 'The numerator factorises as $(x - 1)(x^{2} + 1x + 1)$, so the limit equals $3a^{2} = 3$.', 'Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 2}\dfrac{x^{3} - 8}{x - 2}$.', '["$8$","$12$","$6$","$15$"]'::jsonb, 1, 'The numerator factorises as $(x - 2)(x^{2} + 2x + 4)$, so the limit equals $3a^{2} = 12$.', 'Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 3}\dfrac{x^{3} - 27}{x - 3}$.', '["$9$","$30$","$27$","$28$"]'::jsonb, 2, 'The numerator factorises as $(x - 3)(x^{2} + 3x + 9)$, so the limit equals $3a^{2} = 27$.', 'Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 4}\dfrac{x^{3} - 64}{x - 4}$.', '["$64$","$12$","$51$","$48$"]'::jsonb, 3, 'The numerator factorises as $(x - 4)(x^{2} + 4x + 16)$, so the limit equals $3a^{2} = 48$.', 'Limits'),
  ('Evaluate $\displaystyle\lim_{x\to\infty}\dfrac{3x^{2} + 5x}{2x^{2} - 2x + 1}$.', '["$\\dfrac{3}{2}$","$\\dfrac{2}{3}$","$0$","$\\infty$"]'::jsonb, 0, 'Divide numerator and denominator by $x^{2}$. As $x\to\infty$ the lower-order terms vanish, so the limit is $\dfrac{3}{2} = \dfrac{3}{2}$.', 'Limits at Infinity'),
  ('Evaluate $\displaystyle\lim_{x\to\infty}\dfrac{4x^{2} + 3x}{2x^{2} - 7x + 1}$.', '["$\\dfrac{1}{2}$","$2$","$0$","$\\infty$"]'::jsonb, 1, 'Divide numerator and denominator by $x^{2}$. As $x\to\infty$ the lower-order terms vanish, so the limit is $\dfrac{4}{2} = 2$.', 'Limits at Infinity'),
  ('Evaluate $\displaystyle\lim_{x\to\infty}\dfrac{5x^{2} + 2x}{3x^{2} - 4x + 1}$.', '["$\\dfrac{3}{5}$","$0$","$\\dfrac{5}{3}$","$\\infty$"]'::jsonb, 2, 'Divide numerator and denominator by $x^{2}$. As $x\to\infty$ the lower-order terms vanish, so the limit is $\dfrac{5}{3} = \dfrac{5}{3}$.', 'Limits at Infinity'),
  ('Evaluate $\displaystyle\lim_{x\to 0}\dfrac{\sin 3x}{x}$.', '["$\\dfrac{1}{3}$","$0$","$4$","$3$"]'::jsonb, 3, 'Use $\lim_{x\to0}\dfrac{\sin kx}{x} = k$: the limit is $\dfrac{3}{1} = 3$.', 'Standard Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 0}\dfrac{\sin 5x}{2x}$.', '["$\\dfrac{5}{2}$","$\\dfrac{2}{5}$","$0$","$10$"]'::jsonb, 0, 'Use $\lim_{x\to0}\dfrac{\sin kx}{x} = k$: the limit is $\dfrac{5}{2} = \dfrac{5}{2}$.', 'Standard Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 0}\dfrac{\sin 7x}{3x}$.', '["$\\dfrac{3}{7}$","$\\dfrac{7}{3}$","$0$","$21$"]'::jsonb, 1, 'Use $\lim_{x\to0}\dfrac{\sin kx}{x} = k$: the limit is $\dfrac{7}{3} = \dfrac{7}{3}$.', 'Standard Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 0}\dfrac{\sin 2x}{x}$.', '["$\\dfrac{1}{2}$","$0$","$2$","$3$"]'::jsonb, 2, 'Use $\lim_{x\to0}\dfrac{\sin kx}{x} = k$: the limit is $\dfrac{2}{1} = 2$.', 'Standard Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 0}\dfrac{1 - \cos x}{x^{2}}$.', '["$1$","$0$","$2$","$\\dfrac{1}{2}$"]'::jsonb, 3, 'Using $1 - \cos x = 2\sin^{2}\tfrac{x}{2}$: the limit is $2\cdot\tfrac{1}{4} = \tfrac{1}{2}$.', 'Standard Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 0}\dfrac{\tan x}{x}$.', '["$1$","$0$","$\\infty$","$-1$"]'::jsonb, 0, '$\tan x = \sin x/\cos x$, and $\sin x/x \to 1$ while $\cos x \to 1$.', 'Standard Limits'),
  ('Evaluate $\displaystyle\lim_{x\to\infty}\left(1 + \dfrac{1}{x}\right)^{x}$.', '["$1$","$e$","$\\infty$","$0$"]'::jsonb, 1, 'This is the standard definition of $e$.', 'Standard Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 0}\dfrac{e^{x} - 1}{x}$.', '["$0$","$e$","$1$","$\\infty$"]'::jsonb, 2, 'This is the derivative of $e^{x}$ at $x = 0$, which equals 1.', 'Standard Limits'),
  ('Evaluate $\displaystyle\lim_{x\to 0^{+}}\ln x$.', '["$0$","$\\infty$","$1$","$-\\infty$"]'::jsonb, 3, '$\ln x$ decreases without bound as $x\to0^{+}$.', 'Limits'),
  ('Evaluate $\displaystyle\lim_{x\to\infty}\left(\sqrt{4x^{2} + 1} - 2x\right)$.', '["$0$","$1$","$\\infty$","$\\dfrac{1}{4}$"]'::jsonb, 0, 'Multiply by the conjugate: $\dfrac{1}{\sqrt{4x^{2}+1} + 2x} \to 0$.', 'Limits at Infinity'),
  ('Evaluate $\displaystyle\lim_{x\to 2}\dfrac{x^{2} - 4}{x^{2} + x - 6}$.', '["$\\dfrac{5}{4}$","$\\dfrac{4}{5}$","$0$","$1$"]'::jsonb, 1, 'Factorise: $\dfrac{(x-2)(x+2)}{(x-2)(x+3)} = \dfrac{x+2}{x+3} \to \dfrac{4}{5}$.', 'Limits'),
  ('Using L''Hôpital''s rule, $\displaystyle\lim_{x\to 0}\dfrac{e^{x} - 1 - x}{x^{2}}$ equals:', '["$1$","$0$","$\\dfrac{1}{2}$","$2$"]'::jsonb, 2, 'The form is $0/0$. Differentiating twice: $\dfrac{e^{x} - 1}{2x} \to \dfrac{e^{x}}{2} \to \dfrac{1}{2}$.', 'L''Hôpital''s Rule'),
  ('Using L''Hôpital''s rule, $\displaystyle\lim_{x\to\infty}\dfrac{\ln x}{x}$ equals:', '["$1$","$\\infty$","$e$","$0$"]'::jsonb, 3, 'The form is $\infty/\infty$. Differentiating gives $\dfrac{1/x}{1} = \dfrac{1}{x} \to 0$.', 'L''Hôpital''s Rule'),
  ('The limit $\displaystyle\lim_{x\to\infty}\dfrac{x^{2}}{e^{x}}$ equals:', '["$0$","$1$","$\\infty$","$2$"]'::jsonb, 0, 'The exponential grows faster than any polynomial; two applications of L''Hôpital give $\dfrac{2}{e^{x}} \to 0$.', 'L''Hôpital''s Rule'),
  ('Which of the following is an indeterminate form?', '["$\\dfrac{1}{0}$","$\\dfrac{0}{0}$","$0 + 5$","$\\dfrac{0}{3}$"]'::jsonb, 1, '$0/0$ (like $\infty/\infty$, $0\cdot\infty$, $\infty - \infty$) is indeterminate. $0/3 = 0$ and $1/0$ is unbounded rather than indeterminate.', 'L''Hôpital''s Rule'),
  ('The function $f(x) = \begin{cases} ax + 1, & x < 2\\ x^{2} - 1, & x \geq 2\end{cases}$ is continuous at $x = 2$ when $a$ equals:', '["$2$","$-1$","$1$","$3$"]'::jsonb, 2, 'Continuity at $x = 2$ needs $2a + 1 = 2^{2} - 1 = 3$, so $a = 1$.', 'Continuity'),
  ('The function $f(x) = \begin{cases} kx^{2}, & x \leq 1\\ 3x - 1, & x > 1\end{cases}$ is continuous at $x = 1$ when $k$ equals:', '["$3$","$1$","$-2$","$2$"]'::jsonb, 3, 'Equate the one-sided values at $x = 1$: $k(1) = 3(1) - 1 = 2$.', 'Continuity'),
  ('Let $f(x) = \dfrac{x^{2} - 9}{x - 3}$ for $x \neq 3$. The value at $x = 3$ that makes $f$ continuous is:', '["$6$","$0$","$3$","$9$"]'::jsonb, 0, '$\dfrac{(x-3)(x+3)}{x - 3} = x + 3 \to 6$.', 'Continuity'),
  ('A function $f$ is continuous at $x = a$ if:', '["$f(a)\\text{ is undefined}$","$\\displaystyle\\lim_{x\\to a} f(x) = f(a)$","$\\displaystyle\\lim_{x\\to a^{-}} f(x) \\neq \\lim_{x\\to a^{+}} f(x)$","$f^{\\prime}(a) = 0$"]'::jsonb, 1, 'Three conditions: $f(a)$ exists, the limit exists, and they are equal.', 'Continuity'),
  ('The function $f(x) = \dfrac{x^{2} - 4}{x - 2}$ at $x = 2$ has:', '["an infinite discontinuity","a jump discontinuity","a removable discontinuity","no discontinuity"]'::jsonb, 2, 'The function is undefined at 2 but the limit exists and equals 4, so the discontinuity can be removed.', 'Continuity'),
  ('The function $f(x) = \dfrac{1}{x - 3}$ has at $x = 3$:', '["a removable discontinuity","a jump discontinuity","a continuous point","an infinite discontinuity"]'::jsonb, 3, 'The values grow without bound on either side of $x = 3$ (a vertical asymptote).', 'Continuity'),
  ('The Intermediate Value Theorem guarantees a root of $f(x) = x^{3} + x - 1$ in the interval:', '["$(0, 1)$","$(1, 2)$","$(-2, -1)$","$(2, 3)$"]'::jsonb, 0, '$f$ is continuous, $f(0) = -1 < 0$ and $f(1) = 1 > 0$, so $f$ has a zero between 0 and 1.', 'Continuity'),
  ('If $f(x) = 3x^{2}+2x+1$, find $f^{\prime}(1)$.', '["$9$","$8$","$7$","$-8$"]'::jsonb, 1, '$f^{\prime}(x) = 6x+2$, so $f^{\prime}(1) = 8$.', 'Differentiation'),
  ('If $f(x) = x^{3}+x^{2}-4$, find $f^{\prime}(2)$.', '["$17$","$15$","$16$","$-16$"]'::jsonb, 2, '$f^{\prime}(x) = 3x^{2}+2x$, so $f^{\prime}(2) = 16$.', 'Differentiation'),
  ('If $f(x) = x^{3}-3x+2$, find $f^{\prime}(-1)$.', '["$1$","$-1$","$2$","$0$"]'::jsonb, 3, '$f^{\prime}(x) = 3x^{2}-3$, so $f^{\prime}(-1) = 0$.', 'Differentiation'),
  ('If $f(x) = x^{4}-2x^{2}+x+5$, find $f^{\prime}(3)$.', '["$97$","$98$","$96$","$-97$"]'::jsonb, 0, '$f^{\prime}(x) = 4x^{3}-4x+1$, so $f^{\prime}(3) = 97$.', 'Differentiation'),
  ('If $f(x) = -x^{3}+3x^{2}+4x$, find $f^{\prime}(2)$.', '["$5$","$4$","$3$","$-4$"]'::jsonb, 1, '$f^{\prime}(x) = -3x^{2}+6x+4$, so $f^{\prime}(2) = 4$.', 'Differentiation'),
  ('If $f(x) = 2x^{3}+7$, find $f^{\prime}(1)$.', '["$7$","$5$","$6$","$-6$"]'::jsonb, 2, '$f^{\prime}(x) = 6x^{2}$, so $f^{\prime}(1) = 6$.', 'Differentiation'),
  ('Differentiate $y = (x^{2} + 2)^{3}$ and evaluate $\dfrac{dy}{dx}$ at $x = 1$.', '["$27$","$108$","$81$","$54$"]'::jsonb, 3, 'By the chain rule, $\dfrac{dy}{dx} = 3(x^{2} + 2)^{2}\cdot 2x$. At $x = 1$ this is $3(3)^{2}(2) = 54$.', 'Chain Rule'),
  ('Differentiate $y = (x^{2} + 3)^{2}$ and evaluate $\dfrac{dy}{dx}$ at $x = 1$.', '["$16$","$8$","$32$","$17$"]'::jsonb, 0, 'By the chain rule, $\dfrac{dy}{dx} = 2(x^{2} + 3)^{1}\cdot 2x$. At $x = 1$ this is $2(4)^{1}(2) = 16$.', 'Chain Rule'),
  ('Differentiate $y = (x^{2} + 1)^{4}$ and evaluate $\dfrac{dy}{dx}$ at $x = 1$.', '["$32$","$64$","$128$","$65$"]'::jsonb, 1, 'By the chain rule, $\dfrac{dy}{dx} = 4(x^{2} + 1)^{3}\cdot 2x$. At $x = 1$ this is $4(2)^{3}(2) = 64$.', 'Chain Rule'),
  ('Differentiate $y = (x^{2} + 2)^{5}$ and evaluate $\dfrac{dy}{dx}$ at $x = 1$.', '["$405$","$1620$","$810$","$1215$"]'::jsonb, 2, 'By the chain rule, $\dfrac{dy}{dx} = 5(x^{2} + 2)^{4}\cdot 2x$. At $x = 1$ this is $5(3)^{4}(2) = 810$.', 'Chain Rule'),
  ('Find $\dfrac{dy}{dx}$ at $x = 2$ for $y = x^{2}(x + 1)$.', '["$4$","$12$","$18$","$16$"]'::jsonb, 3, 'Product rule: $\dfrac{dy}{dx} = 2x^{1}(x + 1) + x^{2}(1)$. At $x = 2$ this equals 4\times3 + 4 = 16$.', 'Product Rule'),
  ('Find $\dfrac{dy}{dx}$ at $x = 3$ for $y = x^{2}(x + 1)$.', '["$33$","$6$","$36$","$35$"]'::jsonb, 0, 'Product rule: $\dfrac{dy}{dx} = 2x^{1}(x + 1) + x^{2}(1)$. At $x = 3$ this equals 6\times4 + 9 = 33$.', 'Product Rule'),
  ('Find $\dfrac{dy}{dx}$ at $x = 1$ for $y = x^{3}(x + 1)$.', '["$3$","$7$","$2$","$10$"]'::jsonb, 1, 'Product rule: $\dfrac{dy}{dx} = 3x^{2}(x + 1) + x^{3}(1)$. At $x = 1$ this equals 3\times2 + 1 = 7$.', 'Product Rule'),
  ('Find $\dfrac{dy}{dx}$ at $x = 2$ for $y = x^{3}(x + 1)$.', '["$12$","$24$","$44$","$47$"]'::jsonb, 2, 'Product rule: $\dfrac{dy}{dx} = 3x^{2}(x + 1) + x^{3}(1)$. At $x = 2$ this equals 12\times3 + 8 = 44$.', 'Product Rule'),
  ('Find $\dfrac{dy}{dx}$ at $x = 3$ for $y = \dfrac{2x + 1}{x + 1}$.', '["$\\dfrac{3}{16}$","$\\dfrac{1}{4}$","$-\\dfrac{1}{16}$","$\\dfrac{1}{16}$"]'::jsonb, 3, 'Quotient rule: $\dfrac{dy}{dx} = \dfrac{2(x + 1) - (2x + 1)}{(x + 1)^{2}} = \dfrac{1}{(x + 1)^{2}}$. At $x = 3$ this is \dfrac{1}{16}.', 'Quotient Rule'),
  ('Find $\dfrac{dy}{dx}$ at $x = 1$ for $y = \dfrac{3x + 2}{x + 1}$.', '["$\\dfrac{1}{4}$","$\\dfrac{5}{4}$","$\\dfrac{1}{2}$","$-\\dfrac{1}{4}$"]'::jsonb, 0, 'Quotient rule: $\dfrac{dy}{dx} = \dfrac{3(x + 1) - (3x + 2)}{(x + 1)^{2}} = \dfrac{1}{(x + 1)^{2}}$. At $x = 1$ this is \dfrac{1}{4}.', 'Quotient Rule'),
  ('Find $\dfrac{dy}{dx}$ at $x = 2$ for $y = \dfrac{4x + 1}{x + 1}$.', '["$\\dfrac{5}{9}$","$\\dfrac{1}{3}$","$1$","$-\\dfrac{1}{3}$"]'::jsonb, 1, 'Quotient rule: $\dfrac{dy}{dx} = \dfrac{4(x + 1) - (4x + 1)}{(x + 1)^{2}} = \dfrac{3}{(x + 1)^{2}}$. At $x = 2$ this is \dfrac{1}{3}.', 'Quotient Rule'),
  ('Differentiate $y = \sin 3x$.', '["$\\cos 3x$","$-3\\cos 3x$","$3\\cos 3x$","$3\\sin 3x$"]'::jsonb, 2, 'Chain rule: $\dfrac{d}{dx}\sin u = \cos u\cdot u^{\prime}$ with $u = 3x$.', 'Differentiation of Trigonometric Functions'),
  ('Differentiate $y = e^{2x}$.', '["$e^{2x}$","$2xe^{2x}$","$e^{2}$","$2e^{2x}$"]'::jsonb, 3, 'Chain rule: $\dfrac{d}{dx}e^{u} = e^{u}u^{\prime}$.', 'Differentiation of Exponential Functions'),
  ('Differentiate $y = \ln(x^{2} + 1)$.', '["$\\dfrac{2x}{x^{2} + 1}$","$\\dfrac{1}{x^{2} + 1}$","$\\dfrac{2x}{x^{2}}$","$2x\\ln(x^{2} + 1)$"]'::jsonb, 0, '$\dfrac{d}{dx}\ln u = \dfrac{u^{\prime}}{u}$.', 'Differentiation of Logarithmic Functions'),
  ('Differentiate $y = x\ln x$.', '["$\\ln x$","$\\ln x + 1$","$\\dfrac{1}{x}$","$x + \\ln x$"]'::jsonb, 1, 'Product rule: $\ln x + x\cdot\dfrac{1}{x} = \ln x + 1$.', 'Differentiation of Logarithmic Functions'),
  ('Differentiate $y = \tan x$.', '["$\\sec x\\tan x$","$-\\csc^{2}x$","$\\sec^{2}x$","$\\cot x$"]'::jsonb, 2, 'Quotient rule on $\sin x/\cos x$ gives $1/\cos^{2}x = \sec^{2}x$.', 'Differentiation of Trigonometric Functions'),
  ('Differentiate $y = \cos(x^{2})$.', '["$-\\sin(x^{2})$","$2x\\sin(x^{2})$","$-2x\\cos(x^{2})$","$-2x\\sin(x^{2})$"]'::jsonb, 3, 'Chain rule: $-\sin(x^{2})\cdot2x$.', 'Chain Rule'),
  ('Differentiate $y = x^{x}$ using logarithmic differentiation.', '["$x^{x}(1 + \\ln x)$","$x\\cdot x^{x-1}$","$x^{x}\\ln x$","$x^{x}(1 - \\ln x)$"]'::jsonb, 0, 'Take logs: $\ln y = x\ln x$, so $\dfrac{y^{\prime}}{y} = \ln x + 1$.', 'Logarithmic Differentiation'),
  ('Differentiate $y = \sin^{-1}x$.', '["$\\dfrac{1}{1 + x^{2}}$","$\\dfrac{1}{\\sqrt{1 - x^{2}}}$","$-\\dfrac{1}{\\sqrt{1 - x^{2}}}$","$\\dfrac{1}{\\sqrt{1 + x^{2}}}$"]'::jsonb, 1, 'This is a standard derivative.', 'Differentiation of Inverse Functions'),
  ('Differentiate $y = \tan^{-1}x$.', '["$\\dfrac{1}{\\sqrt{1 - x^{2}}}$","$-\\dfrac{1}{1 + x^{2}}$","$\\dfrac{1}{1 + x^{2}}$","$\\sec^{2}x$"]'::jsonb, 2, 'This is a standard derivative.', 'Differentiation of Inverse Functions'),
  ('Differentiate $y = \sinh x$.', '["$-\\cosh x$","$\\sinh x$","$-\\sinh x$","$\\cosh x$"]'::jsonb, 3, '$\dfrac{d}{dx}\sinh x = \cosh x$ and $\dfrac{d}{dx}\cosh x = \sinh x$.', 'Hyperbolic Functions'),
  ('Find $\dfrac{dy}{dx}$ at $(3, 4)$ on the circle $x^{2} + y^{2} = 25$.', '["$-\\dfrac{3}{4}$","$\\dfrac{3}{4}$","$-\\dfrac{4}{3}$","$\\dfrac{4}{3}$"]'::jsonb, 0, 'Differentiate implicitly: $2x + 2y\dfrac{dy}{dx} = 0$, so $\dfrac{dy}{dx} = -\dfrac{x}{y} = -\dfrac{3}{4}$.', 'Implicit Differentiation'),
  ('For the curve $x^{2} + xy + y^{2} = 7$, the gradient at $(1, 2)$ is:', '["$\\dfrac{4}{5}$","$-\\dfrac{4}{5}$","$-\\dfrac{5}{4}$","$-\\dfrac{2}{3}$"]'::jsonb, 1, '$2x + y + x\dfrac{dy}{dx} + 2y\dfrac{dy}{dx} = 0$, so $\dfrac{dy}{dx} = -\dfrac{2x + y}{x + 2y} = -\dfrac{4}{5}$ at $(1, 2)$.', 'Implicit Differentiation'),
  ('For $x^{3} + y^{3} = 9$, find $\dfrac{dy}{dx}$ at $(1, 2)$.', '["$\\dfrac{1}{4}$","$-4$","$-\\dfrac{1}{4}$","$-\\dfrac{3}{4}$"]'::jsonb, 2, '$3x^{2} + 3y^{2}y^{\prime} = 0$ gives $y^{\prime} = -\dfrac{x^{2}}{y^{2}} = -\dfrac{1}{4}$.', 'Implicit Differentiation'),
  ('If $xy = 12$, then $\dfrac{dy}{dx}$ at $(3, 4)$ is:', '["$\\dfrac{4}{3}$","$-\\dfrac{3}{4}$","$-12$","$-\\dfrac{4}{3}$"]'::jsonb, 3, '$y + x\dfrac{dy}{dx} = 0$, so $\dfrac{dy}{dx} = -\dfrac{y}{x} = -\dfrac{4}{3}$.', 'Implicit Differentiation'),
  ('If $x = t^{2}$ and $y = t^{3}$, then $\dfrac{dy}{dx}$ at $t = 2$ is:', '["$3$","$6$","$\\dfrac{3}{2}$","$12$"]'::jsonb, 0, '$\dfrac{dy}{dx} = \dfrac{3t^{2}}{2t} = \dfrac{3t}{2} = 3$ at $t = 2$.', 'Parametric Differentiation'),
  ('If $x = 2t + 1$ and $y = t^{2}$, then $\dfrac{dy}{dx}$ equals:', '["$2t$","$t$","$\\dfrac{1}{t}$","$t^{2}$"]'::jsonb, 1, '$\dfrac{dy/dt}{dx/dt} = \dfrac{2t}{2} = t$.', 'Parametric Differentiation'),
  ('For $x = 3\cos t$ and $y = 3\sin t$, $\dfrac{dy}{dx}$ equals:', '["$\\cot t$","$-\\tan t$","$-\\cot t$","$\\tan t$"]'::jsonb, 2, '$\dfrac{3\cos t}{-3\sin t} = -\cot t$.', 'Parametric Differentiation'),
  ('For $x = e^{t}$ and $y = e^{-t}$, $\dfrac{dy}{dx}$ equals:', '["$e^{-2t}$","$-e^{2t}$","$-1$","$-e^{-2t}$"]'::jsonb, 3, '$\dfrac{-e^{-t}}{e^{t}} = -e^{-2t}$.', 'Parametric Differentiation'),
  ('If $y = x^{4} - 3x^{2}$, then $\dfrac{d^{2}y}{dx^{2}}$ at $x = 1$ is:', '["$6$","$-2$","$4$","$12$"]'::jsonb, 0, '$y^{\prime\prime} = 12x^{2} - 6$, which equals 6 at $x = 1$.', 'Higher Derivatives'),
  ('If $y = \sin 2x$, then $\dfrac{d^{2}y}{dx^{2}}$ equals:', '["$-2\\sin 2x$","$-4\\sin 2x$","$4\\sin 2x$","$-4\\cos 2x$"]'::jsonb, 1, '$y^{\prime} = 2\cos 2x$ and $y^{\prime\prime} = -4\sin 2x$.', 'Higher Derivatives'),
  ('The function $f(x) = x^{3}-6x^{2}+9x$ has a local maximum at $x =$', '["$3$","$-1$","$1$","$4$"]'::jsonb, 2, '$f^{\prime}(x) = 3x^{2} - 12x + 9 = 3(x - 1)(x - 3)$. The sign of $f^{\prime}$ changes from + to − at $x = 1$, so it is a local maximum there.', 'Maxima and Minima'),
  ('The local minimum value of $f(x) = x^{3}-6x^{2}+9x$ is:', '["$4$","$2$","$1$","$0$"]'::jsonb, 3, 'The minimum occurs at $x = 3$ where $f(3) = 0$ (the maximum $f(1) = 4$).', 'Maxima and Minima'),
  ('The function $f(x) = x^{3}-3x^{2}-9x$ has a local maximum at $x =$', '["$-1$","$3$","$1$","$2$"]'::jsonb, 0, '$f^{\prime}(x) = 3x^{2} - 6x - 9 = 3(x - (-1))(x - 3)$. The sign of $f^{\prime}$ changes from + to − at $x = -1$, so it is a local maximum there.', 'Maxima and Minima'),
  ('The local minimum value of $f(x) = x^{3}-3x^{2}-9x$ is:', '["$5$","$-27$","$-25$","$27$"]'::jsonb, 1, 'The minimum occurs at $x = 3$ where $f(3) = -27$ (the maximum $f(-1) = 5$).', 'Maxima and Minima'),
  ('The function $f(x) = x^{3}-6x^{2}$ has a local maximum at $x =$', '["$4$","$1$","$0$","$-1$"]'::jsonb, 2, '$f^{\prime}(x) = 3x^{2} - 12x + 0 = 3(x - 0)(x - 4)$. The sign of $f^{\prime}$ changes from + to − at $x = 0$, so it is a local maximum there.', 'Maxima and Minima'),
  ('The local minimum value of $f(x) = x^{3}-6x^{2}$ is:', '["$0$","$-30$","$32$","$-32$"]'::jsonb, 3, 'The minimum occurs at $x = 4$ where $f(4) = -32$ (the maximum $f(0) = 0$).', 'Maxima and Minima'),
  ('The function $f(x) = x^{3}-9x^{2}+15x$ has a local maximum at $x =$', '["$1$","$5$","$-1$","$6$"]'::jsonb, 0, '$f^{\prime}(x) = 3x^{2} - 18x + 15 = 3(x - 1)(x - 5)$. The sign of $f^{\prime}$ changes from + to − at $x = 1$, so it is a local maximum there.', 'Maxima and Minima'),
  ('The local minimum value of $f(x) = x^{3}-9x^{2}+15x$ is:', '["$7$","$-25$","$-23$","$25$"]'::jsonb, 1, 'The minimum occurs at $x = 5$ where $f(5) = -25$ (the maximum $f(1) = 7$).', 'Maxima and Minima'),
  ('The function $f(x) = x^{3}-12x$ has a local maximum at $x =$', '["$2$","$0$","$-2$","$-1$"]'::jsonb, 2, '$f^{\prime}(x) = 3x^{2} + 0x - 12 = 3(x - (-2))(x - 2)$. The sign of $f^{\prime}$ changes from + to − at $x = -2$, so it is a local maximum there.', 'Maxima and Minima'),
  ('The local minimum value of $f(x) = x^{3}-12x$ is:', '["$16$","$-14$","$-15$","$-16$"]'::jsonb, 3, 'The minimum occurs at $x = 2$ where $f(2) = -16$ (the maximum $f(-2) = 16$).', 'Maxima and Minima'),
  ('The function $f(x) = x^{3} - 6x^{2} + 9x + 1$ has a point of inflexion at $x =$', '["$2$","$1$","$3$","$0$"]'::jsonb, 0, '$f^{\prime\prime}(x) = 6x - 12$, which is zero and changes sign at $x = 2$.', 'Concavity and Inflexion'),
  ('The function $f(x) = x^{3} - 3x$ is increasing on:', '["$(-1, 1)$","$(-\\infty, -1)\\text{ and }(1, \\infty)$","$(-\\infty, 0)$","$(0, \\infty)$"]'::jsonb, 1, '$f^{\prime}(x) = 3x^{2} - 3 = 3(x - 1)(x + 1) > 0$ for $x < -1$ and $x > 1$.', 'Monotonicity'),
  ('The function $f(x) = x^{2} - 4x + 3$ is decreasing on:', '["$(2, \\infty)$","$(-\\infty, 1)$","$(-\\infty, 2)$","$(1, 3)$"]'::jsonb, 2, '$f^{\prime}(x) = 2x - 4 < 0$ for $x < 2$.', 'Monotonicity'),
  ('The function $f(x) = x^{4}$ is concave up on:', '["$(0, \\infty)$","$(-\\infty, 0)$","$\\text{nowhere}$","$(-\\infty, \\infty)$"]'::jsonb, 3, '$f^{\prime\prime}(x) = 12x^{2} \geq 0$ for every $x$.', 'Concavity and Inflexion'),
  ('The tangent to $y = x^{2} - 3x + 2$ at $x = 3$ is:', '["$y = 3x - 7$","$y = 3x - 11$","$y = 2x - 4$","$y = -3x + 11$"]'::jsonb, 0, '$y(3) = 2$ and $\dfrac{dy}{dx} = 2x - 3 = 3$ at $x = 3$. So $y - 2 = 3(x - 3)$, i.e. $y = 3x - 7$.', 'Tangents and Normals'),
  ('The normal to $y = x^{2} - 3x + 2$ at $x = 3$ is:', '["$y = 3x - 7$","$y = -\\dfrac{1}{3}x + 3$","$y = \\dfrac{1}{3}x + 1$","$y = -3x + 11$"]'::jsonb, 1, 'The tangent gradient is 3, so the normal gradient is $-\tfrac{1}{3}$: $y - 2 = -\tfrac{1}{3}(x - 3)$, i.e. $y = -\tfrac{1}{3}x + 3$.', 'Tangents and Normals'),
  ('The gradient of the curve $y = \sqrt{x}$ at $x = 4$ is:', '["$\\dfrac{1}{2}$","$2$","$\\dfrac{1}{4}$","$4$"]'::jsonb, 2, '$\dfrac{dy}{dx} = \dfrac{1}{2\sqrt{x}} = \dfrac{1}{4}$.', 'Tangents and Normals'),
  ('The tangent to $y = x^{3}$ at the point $(1, 1)$ meets the $x$-axis at:', '["$\\left(\\dfrac{1}{3}, 0\\right)$","$(1, 0)$","$\\left(-\\dfrac{2}{3}, 0\\right)$","$\\left(\\dfrac{2}{3}, 0\\right)$"]'::jsonb, 3, 'The gradient is $3$, so $y - 1 = 3(x - 1)$. Setting $y = 0$ gives $x = \tfrac{2}{3}$.', 'Tangents and Normals'),
  ('The vertical asymptote of $f(x) = \dfrac{2x + 1}{x - 3}$ is:', '["$x = 3$","$x = 2$","$y = 3$","$x = -3$"]'::jsonb, 0, 'The denominator is zero at $x = 3$ while the numerator is not.', 'Asymptotes'),
  ('The horizontal asymptote of $f(x) = \dfrac{2x + 1}{x - 3}$ is:', '["$y = 3$","$y = 2$","$y = 1$","$y = -3$"]'::jsonb, 1, 'As $x\to\infty$, $f(x) \to \dfrac{2}{1} = 2$.', 'Asymptotes'),
  ('The function $f(x) = \dfrac{x^{2} + 1}{x}$ has an oblique asymptote:', '["$y = 1$","$y = 2x$","$y = x$","$y = x + 1$"]'::jsonb, 2, '$f(x) = x + \dfrac{1}{x}$, and $\dfrac{1}{x} \to 0$ as $x\to\pm\infty$.', 'Asymptotes'),
  ('The maximum height reached by a ball thrown upward with $h(t) = -5t^{2} + 20t$ (metres, seconds) is:', '["$15$","$40$","$10$","$20$"]'::jsonb, 3, '$h^{\prime}(t) = -10t + 20 = 0$ at $t = 2$, and $h(2) = -20 + 40 = 20$ m.', 'Optimisation'),
  ('Two positive numbers have sum 20. The largest possible value of their product is:', '["$100$","$96$","$75$","$200$"]'::jsonb, 0, 'With the numbers $x$ and $20 - x$, the product $x(20 - x)$ is greatest at $x = 10$, giving 100.', 'Optimisation'),
  ('A rectangle has perimeter 40 m. Its largest possible area is:', '["$96\\ \\text{m}^{2}$","$100\\ \\text{m}^{2}$","$200\\ \\text{m}^{2}$","$80\\ \\text{m}^{2}$"]'::jsonb, 1, 'With sides $x$ and $20 - x$ the area $x(20 - x)$ is greatest when $x = 10$ (a square), giving 100.', 'Optimisation'),
  ('The radius of a circle increases at $2$ cm/s. The rate at which the area increases when $r = 5$ cm is:', '["$10\\pi\\ \\text{cm}^{2}/\\text{s}$","$50\\pi\\ \\text{cm}^{2}/\\text{s}$","$20\\pi\\ \\text{cm}^{2}/\\text{s}$","$5\\pi\\ \\text{cm}^{2}/\\text{s}$"]'::jsonb, 2, '$A = \pi r^{2}$, so $\dfrac{dA}{dt} = 2\pi r\dfrac{dr}{dt} = 2\pi(5)(2) = 20\pi$.', 'Related Rates'),
  ('The radius of a sphere grows at $0.5$ cm/s. When $r = 4$ cm, the volume grows at:', '["$16\\pi\\ \\text{cm}^{3}/\\text{s}$","$64\\pi\\ \\text{cm}^{3}/\\text{s}$","$8\\pi\\ \\text{cm}^{3}/\\text{s}$","$32\\pi\\ \\text{cm}^{3}/\\text{s}$"]'::jsonb, 3, '$V = \tfrac{4}{3}\pi r^{3}$, so $\dfrac{dV}{dt} = 4\pi r^{2}\dfrac{dr}{dt} = 4\pi(16)(0.5) = 32\pi$.', 'Related Rates'),
  ('The side of a cube increases at $3$ cm/s. When the side is $2$ cm, the volume increases at:', '["$36\\ \\text{cm}^{3}/\\text{s}$","$12\\ \\text{cm}^{3}/\\text{s}$","$24\\ \\text{cm}^{3}/\\text{s}$","$18\\ \\text{cm}^{3}/\\text{s}$"]'::jsonb, 0, '$V = s^{3}$, so $\dfrac{dV}{dt} = 3s^{2}\dfrac{ds}{dt} = 3(4)(3) = 36$.', 'Related Rates'),
  ('A 5 m ladder slides down a wall. When the foot is 3 m from the wall it moves away at $1$ m/s. How fast is the top moving down?', '["$\\dfrac{4}{3}\\ \\text{m/s}$","$\\dfrac{3}{4}\\ \\text{m/s}$","$1\\ \\text{m/s}$","$\\dfrac{3}{5}\\ \\text{m/s}$"]'::jsonb, 1, '$x^{2} + y^{2} = 25$ gives $x\dot{x} + y\dot{y} = 0$. With $x = 3$, $y = 4$, $\dot{x} = 1$: $\dot{y} = -\dfrac{3}{4}$, so the top moves down at $\tfrac{3}{4}$ m/s.', 'Related Rates'),
  ('For $f(x) = x^{2}$ on $[1, 3]$, the value of $c$ in the Mean Value Theorem is:', '["$1$","$3$","$2$","$\\dfrac{3}{2}$"]'::jsonb, 2, '$f^{\prime}(c) = \dfrac{f(3) - f(1)}{3 - 1} = \dfrac{8}{2} = 4$, so $2c = 4$ and $c = 2$.', 'Mean Value Theorem'),
  ('Rolle''s theorem applied to $f(x) = x^{2} - 4x$ on $[0, 4]$ gives $c =$', '["$0$","$4$","$1$","$2$"]'::jsonb, 3, '$f(0) = f(4) = 0$, and $f^{\prime}(c) = 2c - 4 = 0$ gives $c = 2$.', 'Mean Value Theorem'),
  ('Rolle''s theorem cannot be applied to $f(x) = |x|$ on $[-1, 1]$ because:', '["f is not differentiable at $x = 0$","f is not continuous on $[-1, 1]$","$f(-1) \\neq f(1)$","f is not defined at $x = 0$"]'::jsonb, 0, '$|x|$ is continuous and $f(-1) = f(1)$, but it has a corner at 0, so it is not differentiable on $(-1, 1)$.', 'Mean Value Theorem'),
  ('One step of the Newton-Raphson method for $f(x) = x^{2} - 2$ starting at $x_{0} = 1$ gives $x_{1} =$', '["$1.4$","$1.5$","$2$","$1.25$"]'::jsonb, 1, '$x_{1} = x_{0} - \dfrac{f(x_{0})}{f^{\prime}(x_{0})} = 1 - \dfrac{-1}{2} = 1.5$.', 'Newton-Raphson Method'),
  ('Using $x_{n+1} = x_{n} - \dfrac{x_{n}^{3} - 2}{3x_{n}^{2}}$ with $x_{0} = 1$, the value of $x_{1}$ is:', '["$\\dfrac{5}{4}$","$\\dfrac{3}{2}$","$\\dfrac{4}{3}$","$2$"]'::jsonb, 2, '$x_{1} = 1 - \dfrac{1 - 2}{3} = 1 + \dfrac{1}{3} = \dfrac{4}{3}$.', 'Newton-Raphson Method'),
  ('Evaluate $\displaystyle\int_{1}^{2} (3x^{2})\,dx$.', '["$8$","$6$","$-7$","$7$"]'::jsonb, 3, 'An antiderivative is $x^{3}$. Evaluating from 1 to 2 gives 7.', 'Definite Integrals'),
  ('Evaluate $\displaystyle\int_{0}^{1} (3x^{2}+2x)\,dx$.', '["$2$","$3$","$1$","$-2$"]'::jsonb, 0, 'An antiderivative is $x^{3}+x^{2}$. Evaluating from 0 to 1 gives 2.', 'Definite Integrals'),
  ('Evaluate $\displaystyle\int_{0}^{2} (4x^{3}+1)\,dx$.', '["$19$","$18$","$17$","$-18$"]'::jsonb, 1, 'An antiderivative is $x^{4}+x$. Evaluating from 0 to 2 gives 18.', 'Definite Integrals'),
  ('Evaluate $\displaystyle\int_{1}^{3} (x^{3}+x)\,dx$.', '["$25$","$23$","$24$","$-24$"]'::jsonb, 2, 'An antiderivative is $\tfrac{1}{4}x^{4}+\tfrac{1}{2}x^{2}$. Evaluating from 1 to 3 gives 24.', 'Definite Integrals'),
  ('Evaluate $\displaystyle\int_{0}^{2} (x^{4}-x+2)\,dx$.', '["$\\dfrac{47}{5}$","$\\dfrac{37}{5}$","$-\\dfrac{42}{5}$","$\\dfrac{42}{5}$"]'::jsonb, 3, 'An antiderivative is $\tfrac{1}{5}x^{5}-\tfrac{1}{2}x^{2}+2x$. Evaluating from 0 to 2 gives \dfrac{42}{5}.', 'Definite Integrals'),
  ('Evaluate $\displaystyle\int 3x^{2}\,dx$.', '["$x^{3} + C$","$3x^{3} + C$","$6x + C$","$\\dfrac{x^{3}}{3} + C$"]'::jsonb, 0, 'Increase the power by one and divide by the new power: $3\cdot\dfrac{x^{3}}{3} = x^{3}$.', 'Indefinite Integrals'),
  ('Evaluate $\displaystyle\int \dfrac{1}{x}\,dx$ for $x > 0$.', '["$-\\dfrac{1}{x^{2}} + C$","$\\ln x + C$","$x\\ln x + C$","$\\dfrac{1}{x^{2}} + C$"]'::jsonb, 1, 'This is the standard integral of the reciprocal.', 'Indefinite Integrals'),
  ('Evaluate $\displaystyle\int e^{3x}\,dx$.', '["$3e^{3x} + C$","$e^{3x} + C$","$\\dfrac{1}{3}e^{3x} + C$","$\\dfrac{1}{3}e^{x} + C$"]'::jsonb, 2, 'Reverse of the chain rule: divide by the coefficient 3.', 'Indefinite Integrals'),
  ('Evaluate $\displaystyle\int \cos 2x\,dx$.', '["$2\\sin 2x + C$","$-\\dfrac{1}{2}\\sin 2x + C$","$\\sin 2x + C$","$\\dfrac{1}{2}\\sin 2x + C$"]'::jsonb, 3, '$\int\cos kx\,dx = \dfrac{1}{k}\sin kx + C$.', 'Indefinite Integrals'),
  ('Evaluate $\displaystyle\int \sin x\,dx$.', '["$-\\cos x + C$","$\\cos x + C$","$\\sin x + C$","$-\\sin x + C$"]'::jsonb, 0, 'The derivative of $-\cos x$ is $\sin x$.', 'Indefinite Integrals'),
  ('Evaluate $\displaystyle\int \sec^{2}x\,dx$.', '["$\\sec x + C$","$\\tan x + C$","$-\\cot x + C$","$\\sec x\\tan x + C$"]'::jsonb, 1, 'The derivative of $\tan x$ is $\sec^{2}x$.', 'Indefinite Integrals'),
  ('Evaluate $\displaystyle\int 2x(x^{2} + 1)^{3}\,dx$ using the substitution $u = x^{2} + 1$.', '["$\\dfrac{1}{2}(x^{2} + 1)^{4} + C$","$1(x^{2} + 1)^{3} + C$","$\\dfrac{1}{4}(x^{2} + 1)^{4} + C$","$2(x^{2} + 1)^{4} + C$"]'::jsonb, 2, 'With $u = x^{2} + 1$, $du = 2x\,dx$. The integral becomes $\dfrac{2}{2}\int u^{3}\,du = \dfrac{2}{2}\cdot\dfrac{u^{4}}{4} + C$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\int x(x^{2} + 1)^{4}\,dx$ using the substitution $u = x^{2} + 1$.', '["$\\dfrac{1}{5}(x^{2} + 1)^{5} + C$","$\\dfrac{1}{2}(x^{2} + 1)^{4} + C$","$1(x^{2} + 1)^{5} + C$","$\\dfrac{1}{10}(x^{2} + 1)^{5} + C$"]'::jsonb, 3, 'With $u = x^{2} + 1$, $du = 2x\,dx$. The integral becomes $\dfrac{1}{2}\int u^{4}\,du = \dfrac{1}{2}\cdot\dfrac{u^{5}}{5} + C$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\int 3x(x^{2} + 1)^{2}\,dx$ using the substitution $u = x^{2} + 1$.', '["$\\dfrac{1}{2}(x^{2} + 1)^{3} + C$","$1(x^{2} + 1)^{3} + C$","$\\dfrac{3}{2}(x^{2} + 1)^{2} + C$","$3(x^{2} + 1)^{3} + C$"]'::jsonb, 0, 'With $u = x^{2} + 1$, $du = 2x\,dx$. The integral becomes $\dfrac{3}{2}\int u^{2}\,du = \dfrac{3}{2}\cdot\dfrac{u^{3}}{3} + C$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\int_{0}^{1} 2x e^{x^{2}}\,dx$.', '["$e$","$e - 1$","$1$","$2e - 2$"]'::jsonb, 1, 'With $u = x^{2}$: $\int_{0}^{1} e^{u}\,du = e - 1$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\int \dfrac{2x}{x^{2} + 1}\,dx$.', '["$\\dfrac{1}{x^{2} + 1} + C$","$2\\ln(x^{2} + 1) + C$","$\\ln(x^{2} + 1) + C$","$\\tan^{-1}x + C$"]'::jsonb, 2, 'The numerator is the derivative of the denominator, so the integral is $\ln|\text{denominator}| + C$.', 'Integration by Substitution'),
  ('Evaluate $\displaystyle\int x e^{x}\,dx$.', '["$(x + 1)e^{x} + C$","$xe^{x} + C$","$\\dfrac{x^{2}}{2}e^{x} + C$","$(x - 1)e^{x} + C$"]'::jsonb, 3, 'By parts with $u = x$, $dv = e^{x}dx$: $xe^{x} - \int e^{x}dx = xe^{x} - e^{x} + C$.', 'Integration by Parts'),
  ('Evaluate $\displaystyle\int_{0}^{1} x e^{x}\,dx$.', '["$1$","$e$","$e - 1$","$0$"]'::jsonb, 0, 'From $(x - 1)e^{x}$: $[0] - [(-1)(1)] = 0 - (-1) = 1$.', 'Integration by Parts'),
  ('Evaluate $\displaystyle\int x\sin x\,dx$.', '["$x\\cos x - \\sin x + C$","$\\sin x - x\\cos x + C$","$-x\\cos x - \\sin x + C$","$\\sin x + x\\cos x + C$"]'::jsonb, 1, 'By parts with $u = x$, $dv = \sin x\,dx$: $-x\cos x + \int\cos x\,dx = -x\cos x + \sin x + C$.', 'Integration by Parts'),
  ('Evaluate $\displaystyle\int \ln x\,dx$.', '["$\\dfrac{1}{x} + C$","$x\\ln x + x + C$","$x\\ln x - x + C$","$\\ln x - x + C$"]'::jsonb, 2, 'By parts with $u = \ln x$, $dv = dx$: $x\ln x - \int dx$.', 'Integration by Parts'),
  ('Evaluate $\displaystyle\int_{1}^{e} \dfrac{1}{x}\,dx$.', '["$e$","$0$","$e - 1$","$1$"]'::jsonb, 3, '$[\ln x]_{1}^{e} = 1 - 0 = 1$.', 'Definite Integrals'),
  ('Evaluate $\displaystyle\int_{0}^{\pi} \sin x\,dx$.', '["$2$","$0$","$1$","$-2$"]'::jsonb, 0, '$[-\cos x]_{0}^{\pi} = 1 + 1 = 2$.', 'Definite Integrals'),
  ('Evaluate $\displaystyle\int_{0}^{\pi/2} \cos x\,dx$.', '["$0$","$1$","$2$","$-1$"]'::jsonb, 1, '$[\sin x]_{0}^{\pi/2} = 1$.', 'Definite Integrals'),
  ('Resolve into partial fractions and integrate: $\displaystyle\int \dfrac{1}{(x - 1)(x + 1)}\,dx$.', '["$\\dfrac{1}{2}\\ln\\left|\\dfrac{x + 1}{x - 1}\\right| + C$","$\\ln|x^{2} - 1| + C$","$\\dfrac{1}{2}\\ln\\left|\\dfrac{x - 1}{x + 1}\\right| + C$","$\\dfrac{1}{x^{2} - 1} + C$"]'::jsonb, 2, '$\dfrac{1}{(x-1)(x+1)} = \dfrac{1}{2}\left(\dfrac{1}{x - 1} - \dfrac{1}{x + 1}\right)$.', 'Integration by Partial Fractions'),
  ('The area enclosed by $y = x^{2}$ and the line $y = 2x$ is:', '["$\\dfrac{8}{3}$","$2$","$4$","$\\dfrac{4}{3}$"]'::jsonb, 3, 'The curves meet at $x = 0$ and $x = 2$. Area $= \int_{0}^{2}(2x - x^{2})\,dx = \dfrac{2\cdot4}{2} - \dfrac{8}{3} = \dfrac{4}{3}$.', 'Area Under a Curve'),
  ('The area enclosed by $y = x^{2}$ and the line $y = 3x$ is:', '["$\\dfrac{9}{2}$","$9$","$\\dfrac{27}{2}$","$\\dfrac{10}{2}$"]'::jsonb, 0, 'The curves meet at $x = 0$ and $x = 3$. Area $= \int_{0}^{3}(3x - x^{2})\,dx = \dfrac{3\cdot9}{2} - \dfrac{27}{3} = \dfrac{9}{2}$.', 'Area Under a Curve'),
  ('The area enclosed by $y = x^{2}$ and the line $y = 4x$ is:', '["$\\dfrac{64}{3}$","$\\dfrac{32}{3}$","$8$","$32$"]'::jsonb, 1, 'The curves meet at $x = 0$ and $x = 4$. Area $= \int_{0}^{4}(4x - x^{2})\,dx = \dfrac{4\cdot16}{2} - \dfrac{64}{3} = \dfrac{32}{3}$.', 'Area Under a Curve'),
  ('The area under the curve $y = x^{2}$ between $x = 1$ and $x = 3$ is:', '["$\\dfrac{29}{3}$","$\\dfrac{23}{3}$","$\\dfrac{26}{3}$","$-\\dfrac{26}{3}$"]'::jsonb, 2, '$\int_{1}^{3} x^{2}\,dx = \dfrac{27 - 1}{3} = \dfrac{26}{3}$.', 'Area Under a Curve'),
  ('The area under the curve $y = x^{2}$ between $x = 0$ and $x = 2$ is:', '["$\\dfrac{11}{3}$","$\\dfrac{5}{3}$","$-\\dfrac{8}{3}$","$\\dfrac{8}{3}$"]'::jsonb, 3, '$\int_{0}^{2} x^{2}\,dx = \dfrac{8 - 0}{3} = \dfrac{8}{3}$.', 'Area Under a Curve'),
  ('The area under the curve $y = x^{2}$ between $x = 2$ and $x = 3$ is:', '["$\\dfrac{19}{3}$","$\\dfrac{22}{3}$","$\\dfrac{16}{3}$","$-\\dfrac{19}{3}$"]'::jsonb, 0, '$\int_{2}^{3} x^{2}\,dx = \dfrac{27 - 8}{3} = \dfrac{19}{3}$.', 'Area Under a Curve'),
  ('The volume formed when $y = \sqrt{x}$ from $x = 0$ to $x = 4$ is rotated about the $x$-axis is:', '["$16\\pi$","$8\\pi$","$4\\pi$","$2\\pi$"]'::jsonb, 1, '$V = \pi\int_{0}^{4} x\,dx = \pi\cdot\dfrac{16}{2} = 8\pi$.', 'Volume of Revolution'),
  ('The volume formed when $y = x^{2}$ from $x = 0$ to $x = 1$ is rotated about the $x$-axis is:', '["$\\dfrac{\\pi}{3}$","$\\dfrac{2\\pi}{5}$","$\\dfrac{\\pi}{5}$","$\\pi$"]'::jsonb, 2, '$V = \pi\int_{0}^{1} x^{4}\,dx = \dfrac{\pi}{5}$.', 'Volume of Revolution'),
  ('The volume formed when $y = 2x$ from $x = 0$ to $x = 3$ is rotated about the $x$-axis is:', '["$18\\pi$","$12\\pi$","$108\\pi$","$36\\pi$"]'::jsonb, 3, '$V = \pi\int_{0}^{3} 4x^{2}\,dx = \pi\cdot\dfrac{4\cdot27}{3} = 36\pi$.', 'Volume of Revolution'),
  ('The average value of $f(x) = x^{2}$ on $[0, 3]$ is:', '["$3$","$9$","$\\dfrac{9}{2}$","$1$"]'::jsonb, 0, '$\dfrac{1}{3 - 0}\int_{0}^{3} x^{2}\,dx = \dfrac{1}{3}\cdot9 = 3$.', 'Applications of Integration'),
  ('Using the trapezium rule with 4 strips, the estimate of $\displaystyle\int_{0}^{2} x^{2}\,dx$ is:', '["$2.667$","$2.75$","$3$","$2.5$"]'::jsonb, 1, 'With $h = 0.5$ and $y$ values $0, 0.25, 1, 2.25, 4$: $\dfrac{0.5}{2}\left[0 + 4 + 2(0.25 + 1 + 2.25)\right] = 0.25(11) = 2.75$.', 'Numerical Integration'),
  ('Using Simpson''s rule with 2 strips, the estimate of $\displaystyle\int_{0}^{2} x^{2}\,dx$ is:', '["$2.75$","$3$","$\\dfrac{8}{3}$","$\\dfrac{7}{3}$"]'::jsonb, 2, 'With $h = 1$: $\dfrac{1}{3}[0 + 4(1) + 4] = \dfrac{8}{3}$, which is exact for a quadratic.', 'Numerical Integration'),
  ('If $\dfrac{dy}{dx} = 2x$ and $y = 3$ when $x = 1$, then $y =$', '["$x^{2} + 3$","$2x + 1$","$x^{2}$","$x^{2} + 2$"]'::jsonb, 3, '$y = x^{2} + C$ and $3 = 1 + C$, so $C = 2$.', 'Differential Equations'),
  ('If $\dfrac{dy}{dx} = y$ and $y(0) = 2$, then $y =$', '["$2e^{x}$","$e^{2x}$","$2 + e^{x}$","$2x$"]'::jsonb, 0, 'Separate variables: $\ln y = x + C$, so $y = Ae^{x}$ with $A = 2$.', 'Differential Equations'),
  ('The domain of $f(x) = \sqrt{2x - 6}$ is:', '["$x > 3$","$x \\geq 3$","$x \\leq 3$","$x \\geq -3$"]'::jsonb, 1, 'The expression under the root must be non-negative: $2x - 6 \geq 0$.', 'Domain and Range'),
  ('The domain of $f(x) = \ln(x^{2} - 4)$ is:', '["$-2 < x < 2$","$x > 2$","$x < -2\\text{ or }x > 2$","$x \\geq 2$"]'::jsonb, 2, 'The argument of the logarithm must be positive: $x^{2} > 4$.', 'Domain and Range'),
  ('The range of $f(x) = \dfrac{3}{x^{2} + 1}$ is:', '["$(0, 3)$","$[0, 3]$","$(-\\infty, 3]$","$(0, 3]$"]'::jsonb, 3, 'The denominator is at least 1, so $0 < f(x) \leq 3$ with the maximum at $x = 0$.', 'Domain and Range'),
  ('If $f(x) = 2x + 1$ and $g(x) = x^{2} - 3$, then $(f\circ g)(x) =$', '["$2x^{2} - 5$","$4x^{2} + 4x - 2$","$2x^{2} - 3$","$x^{2} + 2x - 2$"]'::jsonb, 0, '$f(g(x)) = 2(x^{2} - 3) + 1 = 2x^{2} - 5$.', 'Composite Functions'),
  ('If $f(x) = 2x + 1$ and $g(x) = x^{2} - 3$, then $(g\circ f)(x) =$', '["$2x^{2} - 5$","$4x^{2} + 4x - 2$","$4x^{2} - 3$","$2x^{2} + 4x - 2$"]'::jsonb, 1, '$g(f(x)) = (2x + 1)^{2} - 3 = 4x^{2} + 4x - 2$.', 'Composite Functions'),
  ('The inverse of $f(x) = \dfrac{3x - 2}{x + 5}$ is:', '["$f^{-1}(x) = \\dfrac{5x + 2}{x - 3}$","$f^{-1}(x) = \\dfrac{x + 5}{3x - 2}$","$f^{-1}(x) = \\dfrac{-5x - 2}{x - 3}$","$f^{-1}(x) = \\dfrac{-5x + 2}{x + 3}$"]'::jsonb, 2, 'Let $y = \dfrac{3x - 2}{x + 5}$. Then $xy + 5y = 3x - 2$, so $x(y - 3) = -5y - 2$ and $x = \dfrac{-5y - 2}{y - 3}$.', 'Inverse Functions'),
  ('The inverse of $f(x) = 3x - 7$ is:', '["$f^{-1}(x) = \\dfrac{x - 7}{3}$","$f^{-1}(x) = 3x + 7$","$f^{-1}(x) = \\dfrac{1}{3x - 7}$","$f^{-1}(x) = \\dfrac{x + 7}{3}$"]'::jsonb, 3, 'Solve $y = 3x - 7$ for $x$: $x = \dfrac{y + 7}{3}$.', 'Inverse Functions'),
  ('The function $f(x) = x^{3} - 5x$ is:', '["odd","even","neither odd nor even","both odd and even"]'::jsonb, 0, '$f(-x) = -x^{3} + 5x = -f(x)$.', 'Properties of Functions'),
  ('The function $f(x) = x^{4} + 2x^{2}$ is:', '["odd","even","neither odd nor even","periodic"]'::jsonb, 1, '$f(-x) = f(x)$.', 'Properties of Functions'),
  ('Simplify $\dfrac{x^{4} - 16}{x^{2} - 4}$ for $x \neq \pm2$.', '["$x^{2} - 4$","$x + 4$","$x^{2} + 4$","$x^{2} + 2$"]'::jsonb, 2, '$x^{4} - 16 = (x^{2} - 4)(x^{2} + 4)$.', 'Properties of Functions'),
  ('The zeros of $P(x) = x^{3} - x^{2} - 6x$ are:', '["$0,\\ 2,\\ -3$","$1,\\ 3,\\ -2$","$0,\\ -3,\\ -2$","$0,\\ 3,\\ -2$"]'::jsonb, 3, '$x(x^{2} - x - 6) = x(x - 3)(x + 2)$.', 'Properties of Functions'),
  ('Solve $|2x - 5| = 7$.', '["$x = 6\\text{ or }x = -1$","$x = 6\\text{ only}$","$x = -6\\text{ or }x = 1$","$x = 1\\text{ or }x = 6$"]'::jsonb, 0, '$2x - 5 = 7$ gives $x = 6$; $2x - 5 = -7$ gives $x = -1$.', 'Properties of Functions'),
  ('The function $f(x) = e^{x} - e^{-x}$ is one-to-one because:', '["$f(0) = 0$","$f^{\\prime}(x) = e^{x} + e^{-x} > 0\\text{ for all }x$","$f\\text{ is even}$","$f^{\\prime}(x) = 0\\text{ for all }x$"]'::jsonb, 1, 'The derivative is always positive, so $f$ is strictly increasing and therefore one-to-one.', 'Properties of Functions')
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


-- ============ PART 2: unn_mth103_ca_workbook_cbt_questions.sql ============
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


-- ============ PART 3: unn_mth103_mth121_workbook_cbt_questions.sql ============
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

