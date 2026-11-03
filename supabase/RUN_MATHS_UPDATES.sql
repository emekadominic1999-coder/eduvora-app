-- EDUVORA: MTH 101 EXTRA QUESTIONS
-- Paste this whole file into the Supabase SQL editor and click Run ONCE.
-- It only ADDS questions to the existing MTH 101 paper. Nothing is deleted or renamed.

-- MTH 101: Elementary Mathematics I -- additional questions (old code MTH 111)
-- =============================================================================
-- 68 original questions on relations and sets of numbers, arithmetic and geometric
-- progressions, partial fractions, linear/quadratic/rational/absolute-value
-- inequalities, surds, indices and logarithms, the remainder and factor theorems,
-- quadratics, circular measure and compound angles, complex numbers and the
-- binomial theorem. They fill gaps in the existing MTH 101 bank (which already
-- covers sets, induction, complex numbers and trigonometry). Built from the topics in
-- the supplied MTH 101 / MTH 111 notes, revision questions and the NOUN course
-- text; all stems and numbers are original and every answer is computed. No
-- student compiler's name or wording is used. The textbooks were not copied.
-- ADDS ONLY: joins the existing MTH 101 subject; a question already present is
-- skipped, so running it twice is safe.
-- =============================================================================
with src (question, options, correct_index, explanation, topic) as (
values
  ('Let $K = \{1, 2, 3, 4, 5, 6, 7\}$ and define a relation $P$ on $K$ by $x\,P\,y$ if and only if $y = 3x + 2$. The range of $P$ is:', '["$\\{5\\}$","$\\{1, 2\\}$","$\\{5, 8\\}$","$\\{5, 7\\}$"]'::jsonb, 0, 'Both $x$ and $y$ must lie in $K$. $x = 1$ gives $y = 5$ (in $K$); $x = 2$ gives $y = 8$ (not in $K$). So the only pair is $(1, 5)$ and the range is $\{5\}$.', 'Relations'),
  ('On $L = \{1, 2, 3, 4, 5, 6\}$ a relation $R$ is defined by $x\,R\,y$ if $y = 2x + 1$. The domain of $R$ is:', '["$\\{1, 2, 3\\}$","$\\{1, 2\\}$","$\\{3, 5\\}$","$\\{1, 2, 3, 4, 5, 6\\}$"]'::jsonb, 1, 'Only $x = 1$ ($y = 3$) and $x = 2$ ($y = 5$) give values of $y$ in $L$, so the domain is $\{1, 2\}$.', 'Relations'),
  ('For the relation $R$ above ($y = 2x + 1$ on $L$), the range is:', '["$\\{1, 2\\}$","$\\{1, 3, 5\\}$","$\\{3, 5\\}$","$\\{2, 4, 6\\}$"]'::jsonb, 2, 'The pairs are $(1, 3)$ and $(2, 5)$, so the range (set of second elements) is $\{3, 5\}$.', 'Relations'),
  ('The relation $R$ on the integers defined by $x\,R\,y$ if $x - y$ is divisible by 3 is:', '["reflexive only","symmetric only","transitive only","an equivalence relation"]'::jsonb, 3, 'It is reflexive ($x - x = 0$), symmetric and transitive, so it is an equivalence relation (congruence modulo 3).', 'Relations'),
  ('If $R = \{(1, 2), (2, 3)\}$, the inverse relation $R^{-1}$ is:', '["$\\{(2, 1), (3, 2)\\}$","$\\{(1, 2), (2, 3)\\}$","$\\{(1, 3)\\}$","$\\{(2, 1), (3, 1)\\}$"]'::jsonb, 0, 'The inverse reverses each ordered pair.', 'Relations'),
  ('Which of the following is NOT correct?', '["$\\mathbb{R} - \\mathbb{Q} = \\mathbb{Q}^{\\prime}$","$\\mathbb{Z} \\cup \\mathbb{Q} = \\mathbb{Z}$","$\\mathbb{Z} \\cap \\mathbb{Q} = \\mathbb{Z}$","$\\mathbb{Z} \\cup \\mathbb{Q} = \\mathbb{Q}$"]'::jsonb, 1, 'Every integer is rational, so $\mathbb{Z} \subset \mathbb{Q}$ and $\mathbb{Z} \cup \mathbb{Q} = \mathbb{Q}$, not $\mathbb{Z}$.', 'Sets of Numbers'),
  ('$\mathbb{Q} \cup \mathbb{Q}^{\prime}$ (rationals together with irrationals) is the set of:', '["integers","natural numbers","real numbers","complex numbers"]'::jsonb, 2, 'The union of the rational and irrational numbers is $\mathbb{R}$.', 'Sets of Numbers'),
  ('Which of these numbers is irrational?', '["$\\sqrt{16}$","$0.\\overline{3}$","$\\dfrac{22}{7}$","$\\sqrt{18}$"]'::jsonb, 3, '$\sqrt{18} = 3\sqrt{2}$ cannot be written as a ratio of integers; the others are rational.', 'Sets of Numbers'),
  ('The correct chain of inclusions is:', '["$\\mathbb{N} \\subset \\mathbb{Z} \\subset \\mathbb{Q} \\subset \\mathbb{R}$","$\\mathbb{Q} \\subset \\mathbb{Z} \\subset \\mathbb{N} \\subset \\mathbb{R}$","$\\mathbb{Z} \\subset \\mathbb{N} \\subset \\mathbb{Q} \\subset \\mathbb{R}$","$\\mathbb{R} \\subset \\mathbb{Q} \\subset \\mathbb{Z} \\subset \\mathbb{N}$"]'::jsonb, 0, 'Each set is contained in the next larger number system.', 'Sets of Numbers'),
  ('Three numbers $a, b, c$ are in arithmetic progression. Their sum is 24 and their product is 270. The numbers are:', '["2, 8, 13","2.5, 8, 13.5","2, 4, 8","2.5, 13.5, 8.5"]'::jsonb, 1, 'Let the numbers be $m - d, m, m + d$. The sum gives $m = 8$. The product: $8(64 - d^{2}) = 270$, so $d^{2} = 30.25$ and $d = 5.5$. The numbers are 2.5, 8 and 13.5.', 'Arithmetic Progression'),
  ('Three numbers in arithmetic progression have sum 30 and product 750. The smallest of the three is:', '["4","6","5","3"]'::jsonb, 2, 'The middle term is 10. $10(100 - d^{2}) = 750$ gives $d^{2} = 25$, so $d = 5$. The numbers are 5, 10, 15.', 'Arithmetic Progression'),
  ('The 20th term of the arithmetic progression 7, 11, 15, ... is:', '["87","79","91","83"]'::jsonb, 3, '$T_{n} = a + (n - 1)d = 7 + 19(4) = 83$.', 'Arithmetic Progression'),
  ('The sum of the first 20 terms of the progression 7, 11, 15, ... is:', '["900","830","780","1020"]'::jsonb, 0, '$S_{n} = \tfrac{n}{2}[2a + (n - 1)d] = 10[14 + 76] = 900$.', 'Arithmetic Progression'),
  ('The first term of an arithmetic progression is 7 and the common difference is 4. Which term is the first to exceed 200?', '["the 49th term","the 50th term","the 51st term","the 48th term"]'::jsonb, 1, '$7 + (n - 1)4 > 200$ gives $n - 1 > 48.25$, so $n = 50$ (the 50th term is 203).', 'Arithmetic Progression'),
  ('The 8th term of the geometric progression 3, 6, 12, ... is:', '["192","768","384","256"]'::jsonb, 2, '$T_{n} = ar^{n-1} = 3(2)^{7} = 384$.', 'Geometric Progression'),
  ('The sum of the first 8 terms of the geometric progression 3, 6, 12, ... is:', '["768","381","1530","765"]'::jsonb, 3, '$S_{n} = \dfrac{a(r^{n} - 1)}{r - 1} = 3(255) = 765$.', 'Geometric Progression'),
  ('The sum to infinity of the geometric series $12 + 4 + \tfrac{4}{3} + \dots$ is:', '["18","16","24","12"]'::jsonb, 0, '$r = \tfrac{1}{3}$, so $S_{\infty} = \dfrac{a}{1 - r} = \dfrac{12}{2/3} = 18$.', 'Geometric Progression'),
  ('A sequence is defined by $U_{n} = 7 + 3U_{n-2}$. If $U_{5} = 35 + U_{3}$, the value of $U_{1}$ is:', '["28","7/3","7","7/12"]'::jsonb, 1, '$U_{5} = 7 + 3U_{3}$, so $7 + 3U_{3} = 35 + U_{3}$ gives $U_{3} = 14$. Then $14 = 7 + 3U_{1}$ gives $U_{1} = 7/3$.', 'Sequences'),
  ('For the sequence with general term $T_{n} = \dfrac{3 - 2n}{7}$, the 5th term is:', '["13/7","-15/7","-1","-7"]'::jsonb, 2, '$T_{5} = \dfrac{3 - 10}{7} = -1$.', 'Sequences'),
  ('For the same sequence ($T_{n} = \frac{3 - 2n}{7}$), the 5th partial sum $S_{5}$ is:', '["-1","13/7","-7","-15/7"]'::jsonb, 3, '$S_{5} = \dfrac{(1) + (-1) + (-3) + (-5) + (-7)}{7} = \dfrac{-15}{7}$.', 'Sequences'),
  ('Three numbers are in geometric progression with product 216 and sum 21. The middle number is:', '["6","3","9","12"]'::jsonb, 0, 'Writing the numbers as $a/r$, $a$, $ar$, the product is $a^{3} = 216$, so $a = 6$.', 'Geometric Progression'),
  ('Resolve $\dfrac{x+5}{(x - 1)(x - 2)}$ into partial fractions.', '["$\\dfrac{7}{x - 1} + \\dfrac{-6}{x - 2}$","$\\dfrac{-6}{x - 1} + \\dfrac{7}{x - 2}$","$\\dfrac{6}{x - 1} + \\dfrac{-7}{x - 2}$","$\\dfrac{-5}{x - 1} + \\dfrac{7}{x - 2}$"]'::jsonb, 1, 'Write $\dfrac{1x + 5}{(x - 1)(x - 2)} = \dfrac{A}{x - 1} + \dfrac{B}{x - 2}$. Cover-up: $A = \dfrac{1(1) + 5}{1 - 2} = -6$ and $B = \dfrac{1(2) + 5}{2 - 1} = 7$.', 'Partial Fractions'),
  ('Resolve $\dfrac{3x+1}{(x - 2)(x + 1)}$ into partial fractions.', '["$\\dfrac{(2/3)}{x - 2} + \\dfrac{(7/3)}{x + 1}$","$\\dfrac{(-7/3)}{x - 2} + \\dfrac{(-2/3)}{x + 1}$","$\\dfrac{(7/3)}{x - 2} + \\dfrac{(2/3)}{x + 1}$","$\\dfrac{(10/3)}{x - 2} + \\dfrac{(2/3)}{x + 1}$"]'::jsonb, 2, 'Write $\dfrac{3x + 1}{(x - 2)(x - -1)} = \dfrac{A}{x - 2} + \dfrac{B}{x - -1}$. Cover-up: $A = \dfrac{3(2) + 1}{2 - -1} = 7/3$ and $B = \dfrac{3(-1) + 1}{-1 - 2} = 2/3$.', 'Partial Fractions'),
  ('Resolve $\dfrac{2x-3}{(x - 3)(x - 1)}$ into partial fractions.', '["$\\dfrac{(1/2)}{x - 3} + \\dfrac{(3/2)}{x - 1}$","$\\dfrac{(-3/2)}{x - 3} + \\dfrac{(-1/2)}{x - 1}$","$\\dfrac{(5/2)}{x - 3} + \\dfrac{(1/2)}{x - 1}$","$\\dfrac{(3/2)}{x - 3} + \\dfrac{(1/2)}{x - 1}$"]'::jsonb, 3, 'Write $\dfrac{2x + -3}{(x - 3)(x - 1)} = \dfrac{A}{x - 3} + \dfrac{B}{x - 1}$. Cover-up: $A = \dfrac{2(3) + -3}{3 - 1} = 3/2$ and $B = \dfrac{2(1) + -3}{1 - 3} = 1/2$.', 'Partial Fractions'),
  ('Resolve $\dfrac{5x+7}{(x - 1)(x + 2)}$ into partial fractions.', '["$\\dfrac{4}{x - 1} + \\dfrac{1}{x + 2}$","$\\dfrac{1}{x - 1} + \\dfrac{4}{x + 2}$","$\\dfrac{-4}{x - 1} + \\dfrac{-1}{x + 2}$","$\\dfrac{5}{x - 1} + \\dfrac{1}{x + 2}$"]'::jsonb, 0, 'Write $\dfrac{5x + 7}{(x - 1)(x - -2)} = \dfrac{A}{x - 1} + \dfrac{B}{x - -2}$. Cover-up: $A = \dfrac{5(1) + 7}{1 - -2} = 4$ and $B = \dfrac{5(-2) + 7}{-2 - 1} = 1$.', 'Partial Fractions'),
  ('Resolve $\dfrac{x + 1}{(x - 1)(x^{2} + 1)}$ into partial fractions.', '["$\\dfrac{1}{x - 1} + \\dfrac{x}{x^{2} + 1}$","$\\dfrac{1}{x - 1} - \\dfrac{x}{x^{2} + 1}$","$\\dfrac{-1}{x - 1} + \\dfrac{x}{x^{2} + 1}$","$\\dfrac{-1}{x - 1} - \\dfrac{x}{x^{2} + 1}$"]'::jsonb, 1, 'Set $\dfrac{x+1}{(x-1)(x^{2}+1)} = \dfrac{A}{x-1} + \dfrac{Bx + C}{x^{2}+1}$. At $x = 1$: $A = 2/2 = 1$. Comparing $x^{2}$: $A + B = 0$, so $B = -1$. Constant: $A - C = 1$, so $C = 0$.', 'Partial Fractions'),
  ('Resolve $\dfrac{1}{(x - 1)(x - 2)^{2}}$ into partial fractions.', '["$\\dfrac{1}{x - 1} + \\dfrac{1}{x - 2} + \\dfrac{1}{(x - 2)^{2}}$","$\\dfrac{1}{x - 1} - \\dfrac{1}{x - 2} - \\dfrac{1}{(x - 2)^{2}}$","$\\dfrac{1}{x - 1} - \\dfrac{1}{x - 2} + \\dfrac{1}{(x - 2)^{2}}$","$-\\dfrac{1}{x - 1} + \\dfrac{1}{x - 2} + \\dfrac{1}{(x - 2)^{2}}$"]'::jsonb, 2, 'Write $\dfrac{A}{x-1} + \dfrac{B}{x-2} + \dfrac{C}{(x-2)^{2}}$. At $x = 1$: $A = 1$. At $x = 2$: $C = 1$. Comparing $x^{2}$ coefficients: $A + B = 0$, so $B = -1$.', 'Partial Fractions'),
  ('A rational function $\dfrac{p(x)}{q(x)}$ is called a proper fraction when:', '["the degree of $p$ is greater than that of $q$","$p$ and $q$ have the same factors","$q(x)$ is a constant","the degree of $p$ is less than the degree of $q$"]'::jsonb, 3, 'An improper fraction must first be divided out to give a polynomial plus a proper fraction.', 'Partial Fractions'),
  ('A linear factor $(x - \alpha)$ in the denominator of a proper fraction gives a partial fraction of the form:', '["$\\dfrac{A}{x - \\alpha}$","$\\dfrac{Ax + B}{x - \\alpha}$","$\\dfrac{A}{(x - \\alpha)^{2}}$ only","$A(x - \\alpha)$"]'::jsonb, 0, 'A repeated factor $(x - \alpha)^{2}$ gives two terms; an irreducible quadratic gives $\frac{Ax + B}{x^{2} + \dots}$.', 'Partial Fractions'),
  ('Dividing $x^{2} + 3x + 1$ by $x + 1$ gives a quotient and a remainder of:', '["$x + 2$ and $1$","$x + 2$ and $-1$","$x + 3$ and $-2$","$x - 2$ and $-1$"]'::jsonb, 1, '$x^{2} + 3x + 1 = (x + 1)(x + 2) - 1$.', 'Polynomial Division'),
  ('The solution of $3x + 3 \geq 4x + 12$ is:', '["$[-9, \\infty)$","$(-\\infty, -9)$","$(-\\infty, -9]$","$[9, \\infty)$"]'::jsonb, 2, '$3x - 4x \geq 12 - 3$ gives $-x \geq 9$; dividing by $-1$ reverses the sign: $x \leq -9$.', 'Linear Inequalities'),
  ('The solution set of $2x - 5 < 7$ is:', '["$x > 6$","$x < 1$","$x > 1$","$x < 6$"]'::jsonb, 3, '$2x < 12$, so $x < 6$.', 'Linear Inequalities'),
  ('The solution of $x^{2} - 5x + 6 < 0$ is:', '["$2 < x < 3$","$x < 2$ or $x > 3$","$x < -3$ or $x > -2$","$-3 < x < -2$"]'::jsonb, 0, '$x^{2} - 5x + 6 = (x - 2)(x - 3)$ is negative between its roots.', 'Quadratic Inequalities'),
  ('The solution of $x^{2} - 4 \geq 0$ is:', '["$-2 \\leq x \\leq 2$","$x \\leq -2$ or $x \\geq 2$","$x \\geq 2$ only","$x \\leq -2$ only"]'::jsonb, 1, '$(x - 2)(x + 2) \geq 0$ holds outside the roots.', 'Quadratic Inequalities'),
  ('The solution of $\dfrac{x - 1}{x + 2} > 0$ is:', '["$-2 < x < 1$","$x > 1$ only","$x < -2$ or $x > 1$","$x > -2$"]'::jsonb, 2, 'The sign changes at $x = -2$ and $x = 1$; the quotient is positive when both factors have the same sign.', 'Rational Inequalities'),
  ('The solution of $|2x - 3| < 5$ is:', '["$x < -1$ or $x > 4$","$-4 < x < 1$","$1 < x < 4$","$-1 < x < 4$"]'::jsonb, 3, '$-5 < 2x - 3 < 5$ gives $-2 < 2x < 8$, so $-1 < x < 4$.', 'Absolute Value Inequalities'),
  ('The solution of $|x + 1| \geq 3$ is:', '["$x \\leq -4$ or $x \\geq 2$","$-4 \\leq x \\leq 2$","$x \\geq 2$ only","$x \\leq -4$ only"]'::jsonb, 0, '$x + 1 \geq 3$ or $x + 1 \leq -3$.', 'Absolute Value Inequalities'),
  ('Simplify $\dfrac{2 - \sqrt{3}}{\sqrt{27} - \sqrt{3}}$.', '["$\\dfrac{2 - \\sqrt{3}}{2\\sqrt{3}} \\cdot 2$","$\\dfrac{2\\sqrt{3} - 3}{6}$","$\\dfrac{3 - 2\\sqrt{3}}{6}$","$\\dfrac{2\\sqrt{3} + 3}{6}$"]'::jsonb, 1, '$\sqrt{27} - \sqrt{3} = 3\sqrt{3} - \sqrt{3} = 2\sqrt{3}$. Then $\dfrac{2 - \sqrt{3}}{2\sqrt{3}} \times \dfrac{\sqrt{3}}{\sqrt{3}} = \dfrac{2\sqrt{3} - 3}{6}$.', 'Surds'),
  ('Rationalise the denominator of $\dfrac{1}{2 - \sqrt{3}}$.', '["$2 - \\sqrt{3}$","$\\dfrac{2 + \\sqrt{3}}{7}$","$2 + \\sqrt{3}$","$\\sqrt{3} - 2$"]'::jsonb, 2, 'Multiply by $\dfrac{2 + \sqrt{3}}{2 + \sqrt{3}}$: the denominator becomes $4 - 3 = 1$. (Check: $1/(2 - 1.732) = 3.732$.)', 'Surds'),
  ('Simplify $\sqrt{50} + \sqrt{18} - \sqrt{8}$.', '["$5\\sqrt{2}$","$7\\sqrt{2}$","$4\\sqrt{2}$","$6\\sqrt{2}$"]'::jsonb, 3, '$5\sqrt{2} + 3\sqrt{2} - 2\sqrt{2} = 6\sqrt{2}$.', 'Surds'),
  ('Evaluate $\log_{2} 32$.', '["5","4","6","16"]'::jsonb, 0, '$2^{5} = 32$.', 'Logarithms'),
  ('Evaluate $\log_{10} 5 + \log_{10} 20$.', '["1","2","25","100"]'::jsonb, 1, '$\log_{10}(5 \times 20) = \log_{10} 100 = 2$.', 'Logarithms'),
  ('If $\log_{3} x = 4$, then $x$ equals:', '["12","64","81","7"]'::jsonb, 2, '$x = 3^{4} = 81$.', 'Logarithms'),
  ('Simplify $\dfrac{2^{n+2} - 2^{n}}{2^{n}}$.', '["2","4","$2^{n}$","3"]'::jsonb, 3, '$\dfrac{2^{n}(4 - 1)}{2^{n}} = 3$.', 'Indices'),
  ('If $9^{x} = 27$, then $x$ equals:', '["3/2","2","3","1/3"]'::jsonb, 0, '$3^{2x} = 3^{3}$, so $2x = 3$ and $x = \tfrac{3}{2}$.', 'Indices'),
  ('When $x^{3} - 2x^{2} + x - 5$ is divided by $x - 2$, the remainder is:', '["3","-3","-5","0"]'::jsonb, 1, 'By the remainder theorem, the remainder is $f(2) = 8 - 8 + 2 - 5 = -3$.', 'Remainder Theorem'),
  ('The value of $k$ for which $x - 1$ is a factor of $x^{3} + kx^{2} - 4x + 2$ is:', '["-1","2","1","-2"]'::jsonb, 2, '$f(1) = 1 + k - 4 + 2 = 0$ gives $k = 1$.', 'Factor Theorem'),
  ('The sum of the roots of a quadratic equation is 5 and the sum of their squares is 53. The equation is:', '["$5x^{2} - x - 14 = 0$","$x^{2} - 14x + 5 = 0$","$x^{2} + 5x - 14 = 0$","$x^{2} - 5x - 14 = 0$"]'::jsonb, 3, '$\alpha\beta = \dfrac{(\alpha + \beta)^{2} - (\alpha^{2} + \beta^{2})}{2} = \dfrac{25 - 53}{2} = -14$. The equation is $x^{2} - 5x + (-14) = 0$.', 'Quadratic Equations'),
  ('The roots of $x^{2} + px + q = 0$ are real and equal when:', '["$p = \\pm 2\\sqrt{q}$","$p = \\pm 4q$","$p = \\pm 4\\sqrt{q}$","$p = \\pm 2q$"]'::jsonb, 0, 'Equal roots need $p^{2} - 4q = 0$, so $p^{2} = 4q$ and $p = \pm 2\sqrt{q}$.', 'Quadratic Equations'),
  ('If $n-1\,P_{3} : {}^{n}P_{4} = 1 : 6$, then $n$ equals:', '["3","6","4","5"]'::jsonb, 1, '${}^{n-1}P_{3} = (n-1)(n-2)(n-3)$ and ${}^{n}P_{4} = n(n-1)(n-2)(n-3)$. The ratio is $1/n$, so $n = 6$.', 'Permutations'),
  ('Convert $660^{\circ}$ to radians.', '["$\\dfrac{22\\pi}{3}$","$\\dfrac{11\\pi}{6}$","$\\dfrac{11\\pi}{3}$","$\\dfrac{5\\pi}{3}$"]'::jsonb, 2, '$660 \times \dfrac{\pi}{180} = \dfrac{11\pi}{3}$.', 'Circular Measure'),
  ('Convert $\dfrac{5\pi}{6}$ radians to degrees.', '["$120^{\\circ}$","$135^{\\circ}$","$300^{\\circ}$","$150^{\\circ}$"]'::jsonb, 3, '$\dfrac{5\pi}{6} \times \dfrac{180}{\pi} = 150$.', 'Circular Measure'),
  ('Evaluate $\cos 165^{\circ}$.', '["$-\\dfrac{\\sqrt{6} + \\sqrt{2}}{4}$","$\\dfrac{\\sqrt{6} + \\sqrt{2}}{4}$","$\\dfrac{\\sqrt{6} - \\sqrt{2}}{4}$","$-\\dfrac{\\sqrt{6} - \\sqrt{2}}{4}$"]'::jsonb, 0, '$\cos 165^{\circ} = -\cos 15^{\circ}$ and $\cos 15^{\circ} = \cos(45^{\circ} - 30^{\circ}) = \dfrac{\sqrt{6} + \sqrt{2}}{4}$.', 'Compound Angles'),
  ('The exact value of $\sin 75^{\circ}$ is:', '["$\\dfrac{\\sqrt{6} - \\sqrt{2}}{4}$","$\\dfrac{\\sqrt{6} + \\sqrt{2}}{4}$","$\\dfrac{\\sqrt{3} + 1}{4}$","$\\dfrac{1}{4}$"]'::jsonb, 1, '$\sin(45^{\circ} + 30^{\circ}) = \tfrac{\sqrt{2}}{2}\cdot\tfrac{\sqrt{3}}{2} + \tfrac{\sqrt{2}}{2}\cdot\tfrac{1}{2} = \tfrac{\sqrt{6} + \sqrt{2}}{4} \approx 0.9659$.', 'Compound Angles'),
  ('For an acute angle $\theta$, $\cot\!\left(\dfrac{\pi}{2} + \theta\right)$ equals:', '["$-\\sin\\theta$","$\\cos\\theta$","$-\\tan\\theta$","$-\\cot\\theta$"]'::jsonb, 2, 'In the second quadrant $\cot$ is negative, and $\cot(\tfrac{\pi}{2} + \theta) = -\tan\theta$.', 'Allied Angles'),
  ('A solution of $\sin x - 2\sin x\cos x = 0$ in the interval $0 < x < \pi$ is:', '["$0$","$\\pi$","$\\dfrac{5\\pi}{3}$","$\\dfrac{\\pi}{3}$"]'::jsonb, 3, '$\sin x(1 - 2\cos x) = 0$. In $(0, \pi)$, $\sin x \neq 0$, so $\cos x = \tfrac{1}{2}$ and $x = \tfrac{\pi}{3}$.', 'Trigonometric Equations'),
  ('The identity $1 + \tan^{2}\theta$ equals:', '["$\\sec^{2}\\theta$","$\\csc^{2}\\theta$","$\\cot^{2}\\theta$","$\\sin^{2}\\theta$"]'::jsonb, 0, 'Dividing $\sin^{2}\theta + \cos^{2}\theta = 1$ by $\cos^{2}\theta$ gives $\tan^{2}\theta + 1 = \sec^{2}\theta$.', 'Trigonometric Identities'),
  ('The identity $1 + \cot^{2}\theta$ equals:', '["$\\sec^{2}\\theta$","$\\csc^{2}\\theta$","$\\tan^{2}\\theta$","$\\cos^{2}\\theta$"]'::jsonb, 1, 'Dividing $\sin^{2}\theta + \cos^{2}\theta = 1$ by $\sin^{2}\theta$.', 'Trigonometric Identities'),
  ('$\sin(-\theta)$ equals:', '["$\\sin\\theta$","$\\cos\\theta$","$-\\sin\\theta$","$-\\cos\\theta$"]'::jsonb, 2, 'Sine is an odd function, while cosine is even.', 'Trigonometric Identities'),
  ('$\cos 2\theta$ can be written as:', '["$2\\sin\\theta\\cos\\theta$","$1 + 2\\sin^{2}\\theta$","$\\sin^{2}\\theta - \\cos^{2}\\theta$","$1 - 2\\sin^{2}\\theta$"]'::jsonb, 3, '$\cos 2\theta = \cos^{2}\theta - \sin^{2}\theta = 1 - 2\sin^{2}\theta = 2\cos^{2}\theta - 1$.', 'Double Angle Formulas'),
  ('Solve for $z$: $2z + \bar{z} = 3 - 2i$.', '["$1 - 2i$","$-1 + 2i$","$1 + 2i$","$-1 - 2i$"]'::jsonb, 0, 'Let $z = a + bi$. Then $2z + \bar{z} = 3a + bi = 3 - 2i$, so $a = 1$ and $b = -2$.', 'Complex Numbers'),
  ('Express $(1 + 3i)(1 - 2i)$ in the form $a + bi$.', '["-5 + 5i","7 + 1i","7 - i","1 + i"]'::jsonb, 1, '$(1 + 3i)(1 - 2i) = 1 - 2i + 3i - 6i^{2} = 7 + i$.', 'Complex Numbers'),
  ('The modulus of $(1 + 3i)(1 - 2i) = 7 + i$ is:', '["$\\sqrt{26}$","$\\sqrt{8}$","$\\sqrt{50}$","$7$"]'::jsonb, 2, '$|7 + i| = \sqrt{49 + 1} = \sqrt{50}$.', 'Complex Numbers'),
  ('The principal argument of $i^{2}$ is:', '["$\\dfrac{\\pi}{2}$","$-\\dfrac{\\pi}{2}$","$-\\pi$","$\\pi$"]'::jsonb, 3, '$i^{2} = -1$, which lies on the negative real axis, so $\arg = \pi$ (principal value in $(-\pi, \pi]$).', 'Complex Numbers'),
  ('The principal argument of $z = -\dfrac{8}{25}i$ is:', '["$-\\dfrac{\\pi}{2}$","$\\dfrac{\\pi}{2}$","$\\pi$","$-\\dfrac{3\\pi}{2}$"]'::jsonb, 0, '$z$ lies on the negative imaginary axis, so $\arg z = -\tfrac{\pi}{2}$.', 'Complex Numbers'),
  ('One of the cube roots of $1 + i$ is:', '["$3\\left[\\cos\\dfrac{\\pi}{4} + i\\sin\\dfrac{\\pi}{4}\\right]$","$2^{1/6}\\left[\\cos\\dfrac{\\pi}{12} + i\\sin\\dfrac{\\pi}{12}\\right]$","$\\cos\\dfrac{\\pi}{4} + i\\sin\\dfrac{\\pi}{4}$","$2\\left[\\cos\\dfrac{\\pi}{3} + i\\sin\\dfrac{\\pi}{3}\\right]$"]'::jsonb, 1, '$1 + i = \sqrt{2}\,(\cos\tfrac{\pi}{4} + i\sin\tfrac{\pi}{4})$. By De Moivre, a cube root has modulus $(\sqrt{2})^{1/3} = 2^{1/6}$ and argument $\tfrac{\pi}{12}$.', 'De Moivre''s Theorem'),
  ('The first three terms in the expansion of $(1 - 2y)^{-3}$ in ascending powers of $y$ are:', '["$1 - 6y + 24y^{2}$","$1 + 6y + 12y^{2}$","$1 + 6y + 24y^{2}$","$1 + 3y + 6y^{2}$"]'::jsonb, 2, '$(1 + u)^{-3} = 1 - 3u + 6u^{2} - \dots$ with $u = -2y$ gives $1 + 6y + 24y^{2}$.', 'Binomial Theorem'),
  ('The coefficient of $t^{2}$ in the expansion of $(9 - 6t)^{-3/2}$ is:', '["$\\dfrac{5}{6}$","$\\dfrac{162}{5}$","$-\\dfrac{5}{162}$","$\\dfrac{5}{162}$"]'::jsonb, 3, '$(9 - 6t)^{-3/2} = \dfrac{1}{27}\left(1 - \dfrac{2t}{3}\right)^{-3/2}$. The $t^{2}$ coefficient of the bracket is $\dfrac{(-3/2)(-5/2)}{2}\cdot\dfrac{4}{9} = \dfrac{5}{6}$, so the answer is $\dfrac{5}{6\times27} = \dfrac{5}{162}$ (0.03086).', 'Binomial Theorem')
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
