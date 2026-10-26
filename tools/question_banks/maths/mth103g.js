// MTH 103 (Calculus) - batch G: worked calculation questions, topic by topic, in the style of the course text
// "Calculus Made Easy". Every explanation is written as numbered steps with none skipped, and each topic also shows the
// shortcut a student can use in the exam (marked "Shortcut"). Every answer is checked numerically when the file loads.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const M = (s) => '$' + s + '$';
const St = (...lines) => lines.join('\n');
const T = {
  lim: 'Limits of Algebraic Functions', limT: 'Limits of Trigonometric Functions', limInf: 'Limits at Infinity', lh: "L'Hopital's Rule",
  con: 'Continuity with an Unknown Constant', pw: 'Rules of Differentiation', prod: 'Product and Quotient Rules', ch: 'The Chain Rule',
  tr: 'Differentiation of Trigonometric, Exponential and Logarithmic Functions', ld: 'Logarithmic Differentiation', hd: 'Higher Order Derivatives',
  imp: 'Implicit Differentiation', par: 'Derivatives of Functions Expressed Parametrically', tn: 'Tangents and Normals', tp: 'Maxima and Minima',
  inf: 'Concavity and Points of Inflection', opt: 'Optimisation Problems', rr: 'Related Rates', va: 'Velocity and Acceleration',
  an: 'Antiderivatives of Some Elementary Functions', sub: 'Method of Substitution', ip: 'Integration by Parts', pf: 'Method of Partial Fractions',
  di: 'Definite Integrals', ar: 'Areas of Plane Regions', vol: 'The Disc Method', ic: 'Antiderivatives with Initial Conditions',
};
const chk = (a, b, tol = 1e-6) => { if (Math.abs(a - b) > tol) throw new Error('check failed ' + a + ' vs ' + b); };
const nd = (f, x) => (f(x + 1e-5) - f(x - 1e-5)) / 2e-5;
const checkD = (f, g, xs = [0.3, 0.7, 1.4]) => { for (const x of xs) chk(nd(f, x), g(x), 1e-4 * Math.max(1, Math.abs(g(x)))); };
const checkLim = (f, a, v) => chk((f(a + 1e-5) + f(a - 1e-5)) / 2, v, 2e-3);
const checkInf = (f, v) => chk(f(1e6), v, 2e-3);
const simpson = (f, a, b, n = 4000) => { const h = (b - a) / n; let s = f(a) + f(b); for (let i = 1; i < n; i++) s += f(a + i * h) * (i % 2 ? 4 : 2); return s * h / 3; };
// the antiderivative F is verified by differentiating it numerically against the integrand f
const checkInt = (F, f, xs = [0.4, 0.9, 1.6]) => checkD(F, f, xs);

// =========================================================== LIMITS OF ALGEBRAIC FUNCTIONS
add(R`Evaluate ${M(R`\lim_{x\to3}\dfrac{x^2-9}{x-3}`)}.`, '6', ['0', '3', '9'], St(
  R`Step 1: Substitute $x=3$ directly: the top is $9-9=0$ and the bottom is $3-3=0$. We get $\frac00$, which is not an answer, so we must simplify first.`,
  R`Step 2: Factorise the top using the difference of two squares: $x^2-9=(x-3)(x+3)$.`,
  R`Step 3: Cancel the common factor $(x-3)$ (allowed because $x\to3$ but $x\ne3$): the expression becomes $x+3$.`,
  R`Step 4: Now substitute $x=3$: $3+3=6$.`,
  R`Shortcut: for $\frac{x^2-a^2}{x-a}$ the limit is always $2a$; here $a=3$ gives $6$.`), T.lim);
checkLim((x) => (x * x - 9) / (x - 3), 3, 6);
add(R`Evaluate ${M(R`\lim_{x\to2}\dfrac{x^2-5x+6}{x^2-4}`)}.`, M(R`-\frac14`), [M(R`\frac14`), '0', M(R`-1`)], St(
  R`Step 1: Putting $x=2$ gives $\frac{4-10+6}{4-4}=\frac00$, so factorise.`,
  R`Step 2: Top: $x^2-5x+6=(x-2)(x-3)$ because $-2\times-3=6$ and $-2-3=-5$.`,
  R`Step 3: Bottom: $x^2-4=(x-2)(x+2)$.`,
  R`Step 4: Cancel $(x-2)$ to leave $\frac{x-3}{x+2}$.`,
  R`Step 5: Substitute $x=2$: $\frac{2-3}{2+2}=-\frac14$.`), T.lim);
checkLim((x) => (x * x - 5 * x + 6) / (x * x - 4), 2, -0.25);
add(R`Evaluate ${M(R`\lim_{x\to1}\dfrac{x^3-1}{x-1}`)}.`, '3', ['1', '0', '2'], St(
  R`Step 1: Direct substitution gives $\frac{1-1}{1-1}=\frac00$.`,
  R`Step 2: Use $x^3-1=(x-1)(x^2+x+1)$.`,
  R`Step 3: Cancel $(x-1)$: we are left with $x^2+x+1$.`,
  R`Step 4: Substitute $x=1$: $1+1+1=3$.`,
  R`Shortcut: $\lim_{x\to a}\frac{x^n-a^n}{x-a}=na^{n-1}$. With $n=3$, $a=1$: $3\times1^2=3$.`), T.lim);
checkLim((x) => (x ** 3 - 1) / (x - 1), 1, 3);
add(R`Evaluate ${M(R`\lim_{x\to2}\dfrac{x^4-16}{x-2}`)}.`, '32', ['16', '8', '4'], St(
  R`Step 1: Substituting $x=2$ gives $\frac00$.`,
  R`Step 2: Write $16=2^4$, so the limit has the form $\frac{x^n-a^n}{x-a}$ with $n=4$, $a=2$.`,
  R`Step 3: Use the shortcut $na^{n-1}=4\times2^3=4\times8=32$.`,
  R`Check by factorising: $x^4-16=(x-2)(x^3+2x^2+4x+8)$; putting $x=2$ in the second bracket gives $8+8+8+8=32$.`), T.lim);
checkLim((x) => (x ** 4 - 16) / (x - 2), 2, 32);
add(R`Evaluate ${M(R`\lim_{x\to4}\dfrac{\sqrt{x}-2}{x-4}`)}.`, M(R`\frac14`), [M(R`\frac12`), '0', '4'], St(
  R`Step 1: Substituting $x=4$ gives $\frac{2-2}{0}=\frac00$.`,
  R`Step 2: A square root on top is removed by multiplying top and bottom by the conjugate $\sqrt x+2$.`,
  R`Step 3: The top becomes $(\sqrt x-2)(\sqrt x+2)=x-4$.`,
  R`Step 4: So the fraction is $\frac{x-4}{(x-4)(\sqrt x+2)}=\frac1{\sqrt x+2}$.`,
  R`Step 5: Substitute $x=4$: $\frac1{2+2}=\frac14$.`), T.lim);
checkLim((x) => (Math.sqrt(x) - 2) / (x - 4), 4, 0.25);
add(R`Evaluate ${M(R`\lim_{x\to0}\dfrac{\sqrt{x+9}-3}{x}`)}.`, M(R`\frac16`), [M(R`\frac13`), '0', M(R`\frac12`)], St(
  R`Step 1: At $x=0$ we get $\frac{3-3}{0}=\frac00$.`,
  R`Step 2: Multiply top and bottom by the conjugate $\sqrt{x+9}+3$.`,
  R`Step 3: The top becomes $(x+9)-9=x$.`,
  R`Step 4: The fraction is $\frac{x}{x(\sqrt{x+9}+3)}=\frac1{\sqrt{x+9}+3}$.`,
  R`Step 5: Substitute $x=0$: $\frac1{3+3}=\frac16$.`,
  R`Shortcut: this limit is the derivative of $\sqrt x$ at $x=9$, which is $\frac1{2\sqrt9}=\frac16$.`), T.lim);
checkLim((x) => (Math.sqrt(x + 9) - 3) / x, 0, 1 / 6);
add(R`Evaluate ${M(R`\lim_{x\to2}\dfrac{x^3-8}{x^2-4}`)}.`, '3', ['2', '12', '4'], St(
  R`Step 1: Direct substitution gives $\frac{8-8}{4-4}=\frac00$.`,
  R`Step 2: Factorise the top as a difference of cubes: $x^3-8=(x-2)(x^2+2x+4)$.`,
  R`Step 3: Factorise the bottom: $x^2-4=(x-2)(x+2)$.`,
  R`Step 4: Cancel $(x-2)$: $\frac{x^2+2x+4}{x+2}$.`,
  R`Step 5: Substitute $x=2$: $\frac{4+4+4}{4}=\frac{12}{4}=3$.`), T.lim);
checkLim((x) => (x ** 3 - 8) / (x * x - 4), 2, 3);
add(R`Evaluate ${M(R`\lim_{x\to3}\dfrac{x^2-x-6}{x-3}`)}.`, '5', ['0', '3', '6'], St(
  R`Step 1: At $x=3$: $\frac{9-3-6}{0}=\frac00$.`,
  R`Step 2: Factorise the top: look for two numbers with product $-6$ and sum $-1$; they are $-3$ and $+2$. So $x^2-x-6=(x-3)(x+2)$.`,
  R`Step 3: Cancel $(x-3)$ to leave $x+2$.`,
  R`Step 4: Substitute $x=3$: $3+2=5$.`), T.lim);
checkLim((x) => (x * x - x - 6) / (x - 3), 3, 5);
add(R`Evaluate ${M(R`\lim_{x\to0}\dfrac{(2+x)^2-4}{x}`)}.`, '4', ['0', '2', '8'], St(
  R`Step 1: At $x=0$ we get $\frac{4-4}{0}=\frac00$.`,
  R`Step 2: Expand the bracket: $(2+x)^2=4+4x+x^2$.`,
  R`Step 3: Subtract 4: the top is $4x+x^2=x(4+x)$.`,
  R`Step 4: Cancel $x$: $4+x$.`,
  R`Step 5: Put $x=0$: the limit is $4$.`,
  R`Shortcut: this is the derivative of $x^2$ at $x=2$, namely $2\times2=4$.`), T.lim);
checkLim((x) => ((2 + x) ** 2 - 4) / x, 0, 4);
add(R`Evaluate ${M(R`\lim_{x\to-1}\dfrac{x^2+3x+2}{x^2-1}`)}.`, M(R`-\frac12`), [M(R`\frac12`), '0', '1'], St(
  R`Step 1: At $x=-1$: top $=1-3+2=0$ and bottom $=1-1=0$, so $\frac00$.`,
  R`Step 2: Top: $x^2+3x+2=(x+1)(x+2)$. Bottom: $x^2-1=(x-1)(x+1)$.`,
  R`Step 3: Cancel $(x+1)$ to get $\frac{x+2}{x-1}$.`,
  R`Step 4: Substitute $x=-1$: $\frac{-1+2}{-1-1}=\frac{1}{-2}=-\frac12$.`), T.lim);
checkLim((x) => (x * x + 3 * x + 2) / (x * x - 1), -1, -0.5);

// =========================================================== LIMITS OF TRIGONOMETRIC FUNCTIONS
add(R`Evaluate ${M(R`\lim_{x\to0}\dfrac{\sin5x}{x}`)}.`, '5', ['1', '0', M(R`\frac15`)], St(
  R`Step 1: We know the standard limit $\lim_{u\to0}\frac{\sin u}{u}=1$. We need the bottom to match the angle, which is $5x$.`,
  R`Step 2: Multiply and divide by 5: $\frac{\sin5x}{x}=5\times\frac{\sin5x}{5x}$.`,
  R`Step 3: As $x\to0$, $5x\to0$, so $\frac{\sin5x}{5x}\to1$.`,
  R`Step 4: The limit is $5\times1=5$.`,
  R`Shortcut: $\lim_{x\to0}\frac{\sin ax}{x}=a$.`), T.limT);
checkLim((x) => Math.sin(5 * x) / x, 0, 5);
add(R`Evaluate ${M(R`\lim_{x\to0}\dfrac{\sin3x}{\sin7x}`)}.`, M(R`\frac37`), [M(R`\frac73`), '1', '0'], St(
  R`Step 1: Both top and bottom go to $0$, so the form is $\frac00$.`,
  R`Step 2: Divide top and bottom by $x$: $\frac{\sin3x/x}{\sin7x/x}$.`,
  R`Step 3: Using $\frac{\sin ax}{x}\to a$, the top tends to $3$ and the bottom tends to $7$.`,
  R`Step 4: The limit is $\frac37$.`,
  R`Shortcut: $\lim_{x\to0}\frac{\sin ax}{\sin bx}=\frac ab$.`), T.limT);
checkLim((x) => Math.sin(3 * x) / Math.sin(7 * x), 0, 3 / 7);
add(R`Evaluate ${M(R`\lim_{x\to0}\dfrac{\tan4x}{x}`)}.`, '4', ['1', '0', M(R`\frac14`)], St(
  R`Step 1: Write $\tan4x=\frac{\sin4x}{\cos4x}$, so $\frac{\tan4x}{x}=\frac{\sin4x}{x}\times\frac1{\cos4x}$.`,
  R`Step 2: $\frac{\sin4x}{x}\to4$ and $\cos(4\times0)=\cos0=1$, so $\frac1{\cos4x}\to1$.`,
  R`Step 3: The limit is $4\times1=4$.`,
  R`Shortcut: $\lim_{x\to0}\frac{\tan ax}{x}=a$.`), T.limT);
checkLim((x) => Math.tan(4 * x) / x, 0, 4);
add(R`Evaluate ${M(R`\lim_{x\to0}\dfrac{1-\cos x}{x^2}`)}.`, M(R`\frac12`), ['1', '0', '2'], St(
  R`Step 1: At $x=0$ the form is $\frac00$.`,
  R`Step 2: Use the half-angle identity $1-\cos x=2\sin^2\frac x2$.`,
  R`Step 3: The fraction becomes $\frac{2\sin^2(x/2)}{x^2}=2\left(\frac{\sin(x/2)}{x}\right)^2$.`,
  R`Step 4: $\frac{\sin(x/2)}{x}\to\frac12$ (shortcut $\frac{\sin ax}{x}\to a$ with $a=\frac12$).`,
  R`Step 5: The limit is $2\times\left(\frac12\right)^2=2\times\frac14=\frac12$.`), T.limT);
checkLim((x) => (1 - Math.cos(x)) / (x * x), 0, 0.5);
add(R`Evaluate ${M(R`\lim_{x\to0}\dfrac{x\cos x-\sin x}{x^3}`)}.`, M(R`-\frac13`), [M(R`\frac13`), '0', M(R`-\frac12`)], St(
  R`Step 1: At $x=0$ the form is $\frac00$, so apply L'Hopital's rule (differentiate top and bottom).`,
  R`Step 2: Derivative of the top: $\cos x-x\sin x-\cos x=-x\sin x$. Derivative of the bottom: $3x^2$.`,
  R`Step 3: The new fraction is $\frac{-x\sin x}{3x^2}=-\frac{\sin x}{3x}$.`,
  R`Step 4: Since $\frac{\sin x}{x}\to1$, the limit is $-\frac13$.`), T.lh);
checkLim((x) => (x * Math.cos(x) - Math.sin(x)) / x ** 3, 0.0, -1 / 3) ;

// =========================================================== LIMITS AT INFINITY
add(R`Evaluate ${M(R`\lim_{x\to\infty}\dfrac{3x^2+2x-1}{5x^2-x+4}`)}.`, M(R`\frac35`), ['0', M(R`\frac32`), M(R`\infty`)], St(
  R`Step 1: Both top and bottom grow without bound, so the form is $\frac\infty\infty$.`,
  R`Step 2: Divide every term by the highest power of $x$ in the bottom, which is $x^2$: $\frac{3+\frac2x-\frac1{x^2}}{5-\frac1x+\frac4{x^2}}$.`,
  R`Step 3: As $x\to\infty$, every term with $x$ in its denominator tends to $0$.`,
  R`Step 4: We are left with $\frac{3+0-0}{5-0+0}=\frac35$.`,
  R`Shortcut: when the top and bottom have the same degree, the limit is the ratio of the leading coefficients, $\frac35$.`), T.limInf);
checkInf((x) => (3 * x * x + 2 * x - 1) / (5 * x * x - x + 4), 0.6);
add(R`Evaluate ${M(R`\lim_{x\to\infty}\dfrac{4x^3-x}{2x^3+7x^2}`)}.`, '2', ['0', '4', M(R`\infty`)], St(
  R`Step 1: Divide top and bottom by $x^3$: $\frac{4-\frac1{x^2}}{2+\frac7x}$.`,
  R`Step 2: As $x\to\infty$, $\frac1{x^2}\to0$ and $\frac7x\to0$.`,
  R`Step 3: The limit is $\frac42=2$.`,
  R`Shortcut: same degree on top and bottom, so take the ratio of leading coefficients: $\frac42=2$.`), T.limInf);
checkInf((x) => (4 * x ** 3 - x) / (2 * x ** 3 + 7 * x * x), 2);
add(R`Evaluate ${M(R`\lim_{x\to\infty}\dfrac{2x+1}{x^2+3}`)}.`, '0', ['2', '1', M(R`\infty`)], St(
  R`Step 1: Divide top and bottom by $x^2$ (the highest power): $\frac{\frac2x+\frac1{x^2}}{1+\frac3{x^2}}$.`,
  R`Step 2: As $x\to\infty$ the top tends to $0+0=0$ and the bottom tends to $1+0=1$.`,
  R`Step 3: The limit is $\frac01=0$.`,
  R`Shortcut: if the degree of the top is smaller than the degree of the bottom, the limit is $0$.`), T.limInf);
checkInf((x) => (2 * x + 1) / (x * x + 3), 0);
add(R`Evaluate ${M(R`\lim_{x\to\infty}\left(\sqrt{x^2+x}-x\right)`)}.`, M(R`\frac12`), ['0', '1', M(R`\infty`)], St(
  R`Step 1: Direct substitution gives $\infty-\infty$, which is not defined, so rewrite the expression.`,
  R`Step 2: Multiply and divide by the conjugate $\sqrt{x^2+x}+x$: the top becomes $(x^2+x)-x^2=x$.`,
  R`Step 3: The expression is $\frac{x}{\sqrt{x^2+x}+x}$.`,
  R`Step 4: Divide top and bottom by $x$ (using $\sqrt{x^2}=x$ for large positive $x$): $\frac{1}{\sqrt{1+\frac1x}+1}$.`,
  R`Step 5: As $x\to\infty$, $\frac1x\to0$, so the limit is $\frac1{1+1}=\frac12$.`), T.limInf);
checkInf((x) => Math.sqrt(x * x + x) - x, 0.5);
add(R`Evaluate ${M(R`\lim_{x\to\infty}\left(1+\dfrac2x\right)^{x}`)}.`, M(R`e^2`), ['e', '1', M(R`e^{1/2}`)], St(
  R`Step 1: Recall the standard limit $\lim_{n\to\infty}\left(1+\frac1n\right)^n=e$.`,
  R`Step 2: Put $x=2n$, so $\frac2x=\frac1n$ and $x\to\infty$ means $n\to\infty$.`,
  R`Step 3: $\left(1+\frac1n\right)^{2n}=\left[\left(1+\frac1n\right)^n\right]^2\to e^2$.`,
  R`Shortcut: $\lim_{x\to\infty}\left(1+\frac ax\right)^x=e^a$, so $a=2$ gives $e^2$.`), T.limInf);
checkInf((x) => (1 + 2 / x) ** x, Math.E ** 2 * 1) ;

// =========================================================== L'HOPITAL'S RULE
add(R`Evaluate ${M(R`\lim_{x\to0}\dfrac{e^{2x}-1-2x}{x^2}`)}.`, '2', ['0', '1', '4'], St(
  R`Step 1: At $x=0$: top $=1-1-0=0$ and bottom $=0$, so $\frac00$ and L'Hopital's rule applies.`,
  R`Step 2: Differentiate top and bottom once: $\frac{2e^{2x}-2}{2x}$. At $x=0$ this is again $\frac{2-2}{0}=\frac00$.`,
  R`Step 3: Differentiate once more: the top gives $4e^{2x}$ and the bottom gives $2$.`,
  R`Step 4: Substitute $x=0$: $\frac{4\times1}{2}=2$.`), T.lh);
checkLim((x) => (Math.exp(2 * x) - 1 - 2 * x) / (x * x), 0.0, 2) ;
add(R`Evaluate ${M(R`\lim_{x\to0}\dfrac{x-\sin x}{x^3}`)}.`, M(R`\frac16`), [M(R`\frac13`), '0', M(R`\frac12`)], St(
  R`Step 1: At $x=0$ the form is $\frac00$; apply L'Hopital's rule.`,
  R`Step 2: First derivatives: $\frac{1-\cos x}{3x^2}$, still $\frac00$.`,
  R`Step 3: Second derivatives: $\frac{\sin x}{6x}$, still $\frac00$.`,
  R`Step 4: Third derivatives: $\frac{\cos x}{6}$.`,
  R`Step 5: Substitute $x=0$: $\frac16$.`), T.lh);
checkLim((x) => (x - Math.sin(x)) / x ** 3, 0.01, 1 / 6);
add(R`Evaluate ${M(R`\lim_{x\to1}\dfrac{\ln x}{x-1}`)}.`, '1', ['0', 'e', M(R`\infty`)], St(
  R`Step 1: At $x=1$: $\frac{\ln1}{0}=\frac00$.`,
  R`Step 2: Differentiate top and bottom: $\frac{1/x}{1}=\frac1x$.`,
  R`Step 3: Substitute $x=1$: $1$.`), T.lh);
checkLim((x) => Math.log(x) / (x - 1), 1.0, 1) ;
add(R`Evaluate ${M(R`\lim_{x\to0}\dfrac{e^{3x}-1}{\sin2x}`)}.`, M(R`\frac32`), [M(R`\frac23`), '0', '1'], St(
  R`Step 1: At $x=0$ the form is $\frac00$.`,
  R`Step 2: Differentiate top: $3e^{3x}$. Differentiate bottom: $2\cos2x$.`,
  R`Step 3: Substitute $x=0$: $\frac{3\times1}{2\times1}=\frac32$.`), T.lh);
checkLim((x) => (Math.exp(3 * x) - 1) / Math.sin(2 * x), 0, 1.5);
add(R`Evaluate ${M(R`\lim_{x\to\infty}\dfrac{\ln x}{x}`)}.`, '0', ['1', M(R`\infty`), 'e'], St(
  R`Step 1: Both $\ln x$ and $x$ tend to $\infty$, so the form is $\frac\infty\infty$ and L'Hopital's rule applies.`,
  R`Step 2: Differentiate top and bottom: $\frac{1/x}{1}=\frac1x$.`,
  R`Step 3: As $x\to\infty$, $\frac1x\to0$.`,
  R`Shortcut: $x$ grows faster than $\ln x$, so the limit is $0$.`), T.lh);
checkInf((x) => Math.log(x) / x, 0);

// =========================================================== CONTINUITY WITH AN UNKNOWN CONSTANT
add(R`The function $f(x)=\dfrac{x^2-4}{x-2}$ for $x\ne2$ and $f(2)=k$ is continuous at $x=2$. Find $k$.`, '4', ['2', '0', '-4'], St(
  R`Step 1: A function is continuous at $x=2$ when $\lim_{x\to2}f(x)=f(2)$.`,
  R`Step 2: Find the limit: $\frac{x^2-4}{x-2}=\frac{(x-2)(x+2)}{x-2}=x+2$ for $x\ne2$.`,
  R`Step 3: As $x\to2$, $x+2\to4$.`,
  R`Step 4: Set the limit equal to the value: $k=4$.`), T.con);
add(R`The function $f(x)=2x+k$ for $x\le1$ and $f(x)=x^2+3$ for $x>1$ is continuous at $x=1$. Find $k$.`, '2', ['4', '1', '0'], St(
  R`Step 1: Continuity at $x=1$ needs the left-hand limit, the right-hand limit and $f(1)$ to be equal.`,
  R`Step 2: Left side (use $2x+k$): $2(1)+k=2+k$. This is also $f(1)$.`,
  R`Step 3: Right side (use $x^2+3$): $1+3=4$.`,
  R`Step 4: Equate: $2+k=4$, so $k=2$.`), T.con);
add(R`The function $f(x)=3$ for $x\le1$, $f(x)=ax+b$ for $1<x<3$ and $f(x)=7$ for $x\ge3$ is continuous everywhere. Find $a$ and $b$.`, M(R`a=2,\ b=1`), [M(R`a=1,\ b=2`), M(R`a=2,\ b=-1`), M(R`a=3,\ b=0`)], St(
  R`Step 1: Two joins need checking, at $x=1$ and at $x=3$.`,
  R`Step 2: At $x=1$: the left value is $3$ and the middle piece gives $a+b$. So $a+b=3$ ...(1).`,
  R`Step 3: At $x=3$: the middle piece gives $3a+b$ and the right value is $7$. So $3a+b=7$ ...(2).`,
  R`Step 4: Subtract (1) from (2): $2a=4$, so $a=2$.`,
  R`Step 5: Put $a=2$ in (1): $2+b=3$, so $b=1$.`), T.con);
add(R`The function $f(x)=\dfrac{\sin3x}{x}$ for $x\ne0$ and $f(0)=k$ is continuous at $0$. The value of $k$ is:`, '3', ['0', '1', M(R`\frac13`)], St(
  R`Step 1: Continuity at $0$ requires $k=\lim_{x\to0}\frac{\sin3x}{x}$.`,
  R`Step 2: Multiply and divide by 3: $\frac{\sin3x}{x}=3\cdot\frac{\sin3x}{3x}$.`,
  R`Step 3: Since $\frac{\sin3x}{3x}\to1$, the limit is $3$, so $k=3$.`), T.con);
add(R`The function $f(x)=\dfrac{1}{x^2-5x+6}$ is not continuous at which values of $x$?`, M(R`x=2\text{ and }x=3`), [M(R`x=-2\text{ and }x=-3`), M(R`x=1\text{ and }x=6`), M(R`x=5`)], St(
  R`Step 1: A fraction is undefined (so discontinuous) where its denominator is $0$.`,
  R`Step 2: Solve $x^2-5x+6=0$.`,
  R`Step 3: Factorise: $(x-2)(x-3)=0$ since $-2\times-3=6$ and $-2-3=-5$.`,
  R`Step 4: So $x=2$ or $x=3$.`), T.con);

// =========================================================== RULES OF DIFFERENTIATION
add(R`Find the value of $\dfrac{dy}{dx}$ at $x=2$ for $y=5x^4-3x^2+7x-2$.`, '155', ['160', '151', '148'], St(
  R`Step 1: Differentiate term by term using $\frac{d}{dx}(ax^n)=anx^{n-1}$.`,
  R`Step 2: $5x^4\to20x^3$; $-3x^2\to-6x$; $7x\to7$; the constant $-2\to0$.`,
  R`Step 3: So $\frac{dy}{dx}=20x^3-6x+7$.`,
  R`Step 4: Put $x=2$: $20(8)-6(2)+7=160-12+7=155$.`), T.pw);
checkD((x) => 5 * x ** 4 - 3 * x * x + 7 * x - 2, (x) => 20 * x ** 3 - 6 * x + 7);
chk(20 * 8 - 12 + 7, 155);
add(R`Find $\dfrac{dy}{dx}$ at $x=4$ for $y=\sqrt x+\dfrac1{x^2}$.`, M(R`\frac{7}{32}`), [M(R`\frac14`), M(R`\frac{9}{32}`), M(R`\frac{1}{32}`)], St(
  R`Step 1: Rewrite with powers: $y=x^{1/2}+x^{-2}$.`,
  R`Step 2: Differentiate: $\frac{dy}{dx}=\frac12x^{-1/2}-2x^{-3}=\frac1{2\sqrt x}-\frac2{x^3}$.`,
  R`Step 3: Put $x=4$: $\sqrt4=2$ and $4^3=64$.`,
  R`Step 4: $\frac1{2\times2}-\frac2{64}=\frac14-\frac1{32}$.`,
  R`Step 5: Common denominator $32$: $\frac8{32}-\frac1{32}=\frac7{32}$.`), T.pw);
checkD((x) => Math.sqrt(x) + 1 / (x * x), (x) => 1 / (2 * Math.sqrt(x)) - 2 / x ** 3);
add(R`Differentiate $y=\dfrac{x^3-4x+1}{x}$ with respect to $x$.`, M(R`2x+\dfrac{4}{x^2}-\dots`).replace(/.*/, M(R`2x-\frac1{x^2}`)), [M(R`2x+\frac1{x^2}`), M(R`3x^2-4`), M(R`2x-\frac{1}{x}`)], St(
  R`Step 1: Do not use the quotient rule: divide each term of the top by $x$ first.`,
  R`Step 2: $y=\frac{x^3}{x}-\frac{4x}{x}+\frac1x=x^2-4+x^{-1}$.`,
  R`Step 3: Differentiate: $\frac{dy}{dx}=2x-0-x^{-2}$.`,
  R`Step 4: $\frac{dy}{dx}=2x-\frac1{x^2}$.`,
  R`Shortcut: whenever the bottom is a single term, split the fraction and use the power rule.`), T.pw);
checkD((x) => (x ** 3 - 4 * x + 1) / x, (x) => 2 * x - 1 / (x * x));

// =========================================================== PRODUCT AND QUOTIENT RULES
add(R`Differentiate $y=(x^2+1)(x^3-x)$.`, M(R`5x^4-1`), [M(R`2x(3x^2-1)`), M(R`5x^4+1`), M(R`6x^3`)], St(
  R`Step 1: Product rule: if $y=uv$ then $y'=u'v+uv'$. Let $u=x^2+1$ and $v=x^3-x$.`,
  R`Step 2: $u'=2x$ and $v'=3x^2-1$.`,
  R`Step 3: $y'=2x(x^3-x)+(x^2+1)(3x^2-1)$.`,
  R`Step 4: Expand the first part: $2x^4-2x^2$. Expand the second: $3x^4-x^2+3x^2-1=3x^4+2x^2-1$.`,
  R`Step 5: Add: $2x^4-2x^2+3x^4+2x^2-1=5x^4-1$.`,
  R`Check: expanding first gives $y=x^5-x^3+x^3-x\cdot1=x^5-x$... so $y'=5x^4-1$.`), T.prod);
checkD((x) => (x * x + 1) * (x ** 3 - x), (x) => 5 * x ** 4 - 1);
add(R`Differentiate $y=\dfrac{x^2}{x+1}$.`, M(R`\dfrac{x^2+2x}{(x+1)^2}`), [M(R`\dfrac{2x}{1}`), M(R`\dfrac{x^2-2x}{(x+1)^2}`), M(R`\dfrac{2x^2+2x}{(x+1)^2}`)], St(
  R`Step 1: Quotient rule: if $y=\frac uv$ then $y'=\frac{u'v-uv'}{v^2}$. Here $u=x^2$ and $v=x+1$.`,
  R`Step 2: $u'=2x$ and $v'=1$.`,
  R`Step 3: $y'=\frac{2x(x+1)-x^2(1)}{(x+1)^2}$.`,
  R`Step 4: Expand the top: $2x^2+2x-x^2=x^2+2x$.`,
  R`Step 5: $y'=\frac{x^2+2x}{(x+1)^2}$.`), T.prod);
checkD((x) => x * x / (x + 1), (x) => (x * x + 2 * x) / (x + 1) ** 2);
add(R`Differentiate $y=x^2e^{x}$.`, M(R`e^x(x^2+2x)`), [M(R`2xe^x`), M(R`x^2e^x`), M(R`e^x(2x-x^2)`)], St(
  R`Step 1: Product rule with $u=x^2$, $v=e^x$.`,
  R`Step 2: $u'=2x$ and $v'=e^x$ (the exponential does not change when differentiated).`,
  R`Step 3: $y'=2x\,e^x+x^2e^x$.`,
  R`Step 4: Factor out $e^x$: $y'=e^x(x^2+2x)$.`), T.prod);
checkD((x) => x * x * Math.exp(x), (x) => Math.exp(x) * (x * x + 2 * x));
add(R`Find $\dfrac{dy}{dx}$ at $x=\dfrac\pi2$ for $y=x\sin x$.`, '1', [M(R`\frac\pi2`), '0', M(R`\frac\pi2+1`)], St(
  R`Step 1: Product rule with $u=x$ and $v=\sin x$, so $u'=1$ and $v'=\cos x$.`,
  R`Step 2: $y'=\sin x+x\cos x$.`,
  R`Step 3: At $x=\frac\pi2$: $\sin\frac\pi2=1$ and $\cos\frac\pi2=0$.`,
  R`Step 4: $y'=1+\frac\pi2(0)=1$.`), T.prod);
checkD((x) => x * Math.sin(x), (x) => Math.sin(x) + x * Math.cos(x));
add(R`Differentiate $y=\dfrac{e^x}{x}$.`, M(R`\dfrac{e^x(x-1)}{x^2}`), [M(R`\dfrac{e^x(x+1)}{x^2}`), M(R`\dfrac{e^x}{x^2}`), M(R`\dfrac{e^x(1-x)}{x^2}`)], St(
  R`Step 1: Quotient rule with $u=e^x$ and $v=x$, so $u'=e^x$ and $v'=1$.`,
  R`Step 2: $y'=\frac{e^x\cdot x-e^x\cdot1}{x^2}$.`,
  R`Step 3: Factor $e^x$ from the top: $\frac{e^x(x-1)}{x^2}$.`), T.prod);
checkD((x) => Math.exp(x) / x, (x) => Math.exp(x) * (x - 1) / (x * x));
add(R`Differentiate $y=\tan x$ using $\tan x=\dfrac{\sin x}{\cos x}$.`, M(R`\sec^2x`), [M(R`\cot x`), M(R`-\csc^2x`), M(R`\sec x\tan x`)], St(
  R`Step 1: Quotient rule with $u=\sin x$, $v=\cos x$: $u'=\cos x$ and $v'=-\sin x$.`,
  R`Step 2: $y'=\frac{\cos x\cdot\cos x-\sin x\cdot(-\sin x)}{\cos^2x}$.`,
  R`Step 3: The top is $\cos^2x+\sin^2x=1$.`,
  R`Step 4: $y'=\frac1{\cos^2x}=\sec^2x$.`), T.prod);
checkD(Math.tan, (x) => 1 / Math.cos(x) ** 2);

// =========================================================== THE CHAIN RULE
add(R`Differentiate $y=(3x^2+1)^5$.`, M(R`30x(3x^2+1)^4`), [M(R`5(3x^2+1)^4`), M(R`6x(3x^2+1)^4`), M(R`30x(3x^2+1)^5`)], St(
  R`Step 1: Identify the layers: outer power $u^5$ and inner function $u=3x^2+1$.`,
  R`Step 2: Differentiate the outer layer: $5u^4=5(3x^2+1)^4$.`,
  R`Step 3: Differentiate the inner layer: $\frac{du}{dx}=6x$.`,
  R`Step 4: Multiply: $y'=5(3x^2+1)^4\times6x=30x(3x^2+1)^4$.`), T.ch);
checkD((x) => (3 * x * x + 1) ** 5, (x) => 30 * x * (3 * x * x + 1) ** 4);
add(R`Differentiate $y=(2x+5)^6$.`, M(R`12(2x+5)^5`), [M(R`6(2x+5)^5`), M(R`2(2x+5)^6`), M(R`12(2x+5)^6`)], St(
  R`Step 1: Outer layer $u^6$ gives $6u^5$; inner layer $u=2x+5$ gives $2$.`,
  R`Step 2: Multiply: $6(2x+5)^5\times2=12(2x+5)^5$.`,
  R`Shortcut: $\frac{d}{dx}(ax+b)^n=na(ax+b)^{n-1}$, so here $6\times2=12$ in front and the power drops by one.`), T.ch);
checkD((x) => (2 * x + 5) ** 6, (x) => 12 * (2 * x + 5) ** 5);
add(R`Differentiate $y=\sin(x^2)$.`, M(R`2x\cos(x^2)`), [M(R`\cos(x^2)`), M(R`2x\sin(x^2)`), M(R`-2x\cos(x^2)`)], St(
  R`Step 1: Outer function: $\sin u$ with derivative $\cos u$. Inner function: $u=x^2$ with derivative $2x$.`,
  R`Step 2: Multiply: $y'=\cos(x^2)\times2x$.`,
  R`Step 3: Write neatly: $2x\cos(x^2)$.`), T.ch);
checkD((x) => Math.sin(x * x), (x) => 2 * x * Math.cos(x * x));
add(R`Differentiate $y=e^{3x^2}$.`, M(R`6xe^{3x^2}`), [M(R`3x^2e^{3x^2}`), M(R`e^{6x}`), M(R`6x^2e^{3x^2}`)], St(
  R`Step 1: Outer function: $e^u$, whose derivative is $e^u$. Inner function: $u=3x^2$, whose derivative is $6x$.`,
  R`Step 2: Multiply: $y'=e^{3x^2}\times6x$.`,
  R`Shortcut: $\frac{d}{dx}e^{f(x)}=f'(x)e^{f(x)}$.`), T.ch);
checkD((x) => Math.exp(3 * x * x), (x) => 6 * x * Math.exp(3 * x * x));
add(R`Differentiate $y=\ln(x^2+1)$.`, M(R`\dfrac{2x}{x^2+1}`), [M(R`\dfrac{1}{x^2+1}`), M(R`\dfrac{2x}{x^2}`), M(R`2x\ln(x^2+1)`)], St(
  R`Step 1: Outer function: $\ln u$ with derivative $\frac1u$. Inner function: $u=x^2+1$ with derivative $2x$.`,
  R`Step 2: Multiply: $y'=\frac1{x^2+1}\times2x$.`,
  R`Shortcut: $\frac{d}{dx}\ln f(x)=\frac{f'(x)}{f(x)}$.`), T.ch);
checkD((x) => Math.log(x * x + 1), (x) => 2 * x / (x * x + 1));
add(R`Differentiate $y=\ln(\sin x)$.`, M(R`\cot x`), [M(R`\tan x`), M(R`\dfrac1{\sin x}`), M(R`-\cot x`)], St(
  R`Step 1: Use $\frac{d}{dx}\ln f(x)=\frac{f'(x)}{f(x)}$ with $f(x)=\sin x$.`,
  R`Step 2: $f'(x)=\cos x$.`,
  R`Step 3: $y'=\frac{\cos x}{\sin x}=\cot x$.`), T.ch);
checkD((x) => Math.log(Math.sin(x)), (x) => Math.cos(x) / Math.sin(x), [0.5, 1, 1.4]);
add(R`Differentiate $y=\sin^2x$.`, M(R`2\sin x\cos x`), [M(R`2\sin x`), M(R`\cos^2x`), M(R`-2\sin x\cos x`)], St(
  R`Step 1: Write $y=(\sin x)^2$. The outer layer is $u^2$ and the inner layer is $u=\sin x$.`,
  R`Step 2: Outer derivative: $2u=2\sin x$. Inner derivative: $\cos x$.`,
  R`Step 3: $y'=2\sin x\cos x$ (which also equals $\sin2x$).`), T.ch);
checkD((x) => Math.sin(x) ** 2, (x) => 2 * Math.sin(x) * Math.cos(x));
add(R`Find $\dfrac{dy}{dx}$ at $x=1$ for $y=\dfrac1{1+x^2}$.`, M(R`-\frac12`), [M(R`\frac12`), M(R`-1`), M(R`-\frac14`)], St(
  R`Step 1: Write $y=(1+x^2)^{-1}$.`,
  R`Step 2: Outer layer: $u^{-1}\to-u^{-2}$. Inner layer: $u=1+x^2\to2x$.`,
  R`Step 3: $y'=-(1+x^2)^{-2}\times2x=-\frac{2x}{(1+x^2)^2}$.`,
  R`Step 4: Put $x=1$: $-\frac{2}{(2)^2}=-\frac24=-\frac12$.`), T.ch);
checkD((x) => 1 / (1 + x * x), (x) => -2 * x / (1 + x * x) ** 2);

// =========================================================== LOGARITHMIC DIFFERENTIATION
add(R`Find $\dfrac{dy}{dx}$ at $x=1$ for $y=x^x$.`, '1', ['0', 'e', '2'], St(
  R`Step 1: A variable in both base and power cannot use the power rule, so take natural logs: $\ln y=x\ln x$.`,
  R`Step 2: Differentiate both sides with respect to $x$. Left: $\frac1y\frac{dy}{dx}$. Right (product rule): $1\cdot\ln x+x\cdot\frac1x=\ln x+1$.`,
  R`Step 3: So $\frac{dy}{dx}=y(\ln x+1)=x^x(\ln x+1)$.`,
  R`Step 4: At $x=1$: $1^1(\ln1+1)=1\times(0+1)=1$.`), T.ld);
checkD((x) => x ** x, (x) => x ** x * (Math.log(x) + 1));
add(R`Differentiate $y=\dfrac{x^2\sqrt{x+1}}{(x-2)^3}$ using logarithmic differentiation, and give $\dfrac1y\dfrac{dy}{dx}$.`, M(R`\dfrac2x+\dfrac1{2(x+1)}-\dfrac3{x-2}`), [M(R`\dfrac2x+\dfrac{1}{x+1}-\dfrac3{x-2}`), M(R`\dfrac2x+\dfrac1{2(x+1)}+\dfrac3{x-2}`), M(R`2x+\dfrac12(x+1)-3(x-2)`)], St(
  R`Step 1: Take logs: $\ln y=2\ln x+\frac12\ln(x+1)-3\ln(x-2)$. This turns products, roots and powers into sums.`,
  R`Step 2: Differentiate each term: $\frac2x$, then $\frac12\cdot\frac1{x+1}$, then $-3\cdot\frac1{x-2}$.`,
  R`Step 3: So $\frac1y\frac{dy}{dx}=\frac2x+\frac1{2(x+1)}-\frac3{x-2}$.`,
  R`Step 4: Multiply by $y$ to get $\frac{dy}{dx}$ if needed.`), T.ld);
checkD((x) => Math.log(x * x * Math.sqrt(x + 1) / (x - 2) ** 3), (x) => 2 / x + 1 / (2 * (x + 1)) - 3 / (x - 2), [3, 4, 5]);

// =========================================================== HIGHER ORDER DERIVATIVES
add(R`Find $\dfrac{d^2y}{dx^2}$ at $x=1$ for $y=x^4-3x^3$.`, '-6', ['6', '-9', '12'], St(
  R`Step 1: First derivative: $y'=4x^3-9x^2$.`,
  R`Step 2: Second derivative (differentiate again): $y''=12x^2-18x$.`,
  R`Step 3: Put $x=1$: $12-18=-6$.`), T.hd);
checkD((x) => 4 * x ** 3 - 9 * x * x, (x) => 12 * x * x - 18 * x);
add(R`Find $\dfrac{d^2y}{dx^2}$ for $y=e^{2x}\sin x$ at $x=0$.`, '4', ['0', '2', '1'], St(
  R`Step 1: First derivative (product rule): $y'=2e^{2x}\sin x+e^{2x}\cos x=e^{2x}(2\sin x+\cos x)$.`,
  R`Step 2: Second derivative (product rule again): $y''=2e^{2x}(2\sin x+\cos x)+e^{2x}(2\cos x-\sin x)$.`,
  R`Step 3: Put $x=0$: $\sin0=0$, $\cos0=1$, $e^0=1$.`,
  R`Step 4: $y''(0)=2(1)(0+1)+1(2-0)=2+2=4$.`), T.hd);
checkD((x) => Math.exp(2 * x) * (2 * Math.sin(x) + Math.cos(x)), (x) => 2 * Math.exp(2 * x) * (2 * Math.sin(x) + Math.cos(x)) + Math.exp(2 * x) * (2 * Math.cos(x) - Math.sin(x)));

// =========================================================== IMPLICIT DIFFERENTIATION
add(R`For $x^2+y^2=25$, find $\dfrac{dy}{dx}$ at the point $(3,4)$.`, M(R`-\frac34`), [M(R`\frac34`), M(R`-\frac43`), M(R`\frac43`)], St(
  R`Step 1: Differentiate every term with respect to $x$, remembering $y$ depends on $x$.`,
  R`Step 2: $\frac{d}{dx}(x^2)=2x$; $\frac{d}{dx}(y^2)=2y\frac{dy}{dx}$; $\frac{d}{dx}(25)=0$.`,
  R`Step 3: $2x+2y\frac{dy}{dx}=0$, so $\frac{dy}{dx}=-\frac xy$.`,
  R`Step 4: At $(3,4)$: $-\frac34$.`), T.imp);
add(R`For $x^2+xy+y^2=7$, find $\dfrac{dy}{dx}$ at $(1,2)$.`, M(R`-\frac45`), [M(R`\frac45`), M(R`-\frac54`), M(R`-\frac35`)], St(
  R`Step 1: Check the point: $1+2+4=7$, so $(1,2)$ is on the curve.`,
  R`Step 2: Differentiate term by term: $2x$ for $x^2$; $y+x\frac{dy}{dx}$ for $xy$ (product rule); $2y\frac{dy}{dx}$ for $y^2$.`,
  R`Step 3: $2x+y+x\frac{dy}{dx}+2y\frac{dy}{dx}=0$.`,
  R`Step 4: Collect the $\frac{dy}{dx}$ terms: $\frac{dy}{dx}(x+2y)=-(2x+y)$.`,
  R`Step 5: $\frac{dy}{dx}=-\frac{2x+y}{x+2y}$. At $(1,2)$: $-\frac{2+2}{1+4}=-\frac45$.`), T.imp);
add(R`For $xy=6$, find $\dfrac{dy}{dx}$ at $(2,3)$.`, M(R`-\frac32`), [M(R`\frac32`), M(R`-\frac23`), M(R`-6`)], St(
  R`Step 1: Differentiate with the product rule: $y+x\frac{dy}{dx}=0$.`,
  R`Step 2: $\frac{dy}{dx}=-\frac yx$.`,
  R`Step 3: At $(2,3)$: $-\frac32$.`,
  R`Check: $y=\frac6x$ gives $y'=-\frac6{x^2}=-\frac64=-\frac32$.`), T.imp);

// =========================================================== PARAMETRIC DIFFERENTIATION
add(R`If $x=t^2$ and $y=t^3$, find $\dfrac{dy}{dx}$ when $t=2$.`, '3', ['6', '12', M(R`\frac32`)], St(
  R`Step 1: Differentiate each with respect to $t$: $\frac{dx}{dt}=2t$ and $\frac{dy}{dt}=3t^2$.`,
  R`Step 2: Use $\frac{dy}{dx}=\frac{dy/dt}{dx/dt}=\frac{3t^2}{2t}=\frac{3t}{2}$.`,
  R`Step 3: At $t=2$: $\frac{3\times2}{2}=3$.`), T.par);
add(R`If $x=2\cos\theta$ and $y=3\sin\theta$, find $\dfrac{dy}{dx}$ at $\theta=\dfrac\pi4$.`, M(R`-\frac32`), [M(R`\frac32`), M(R`-\frac23`), '-1'], St(
  R`Step 1: $\frac{dx}{d\theta}=-2\sin\theta$ and $\frac{dy}{d\theta}=3\cos\theta$.`,
  R`Step 2: $\frac{dy}{dx}=\frac{3\cos\theta}{-2\sin\theta}=-\frac32\cot\theta$.`,
  R`Step 3: At $\theta=\frac\pi4$, $\cot\frac\pi4=1$, so $\frac{dy}{dx}=-\frac32$.`), T.par);
add(R`If $x=t^2$ and $y=t^3$, find $\dfrac{d^2y}{dx^2}$ when $t=2$.`, M(R`\frac38`), [M(R`\frac34`), M(R`\frac32`), '3'], St(
  R`Step 1: First derivative: $\frac{dy}{dx}=\frac{3t}{2}$.`,
  R`Step 2: For the second derivative, differentiate $\frac{dy}{dx}$ with respect to $t$ and then divide by $\frac{dx}{dt}$.`,
  R`Step 3: $\frac{d}{dt}\left(\frac{3t}{2}\right)=\frac32$ and $\frac{dx}{dt}=2t$.`,
  R`Step 4: $\frac{d^2y}{dx^2}=\frac{3/2}{2t}=\frac3{4t}$.`,
  R`Step 5: At $t=2$: $\frac38$.`), T.par);

// =========================================================== TANGENTS AND NORMALS
add(R`Find the equation of the tangent to $y=x^2-3x+2$ at the point where $x=2$.`, M(R`y=x-2`), [M(R`y=-x+2`), M(R`y=x+2`), M(R`y=2x-4`)], St(
  R`Step 1: Find the point: $y=4-6+2=0$, so the point is $(2,0)$.`,
  R`Step 2: Find the gradient: $\frac{dy}{dx}=2x-3$. At $x=2$: $m=1$.`,
  R`Step 3: Use $y-y_1=m(x-x_1)$: $y-0=1(x-2)$.`,
  R`Step 4: $y=x-2$.`), T.tn);
add(R`Find the equation of the normal to $y=x^2-3x+2$ at $x=2$.`, M(R`y=-x+2`), [M(R`y=x-2`), M(R`y=-x-2`), M(R`y=2-2x`)], St(
  R`Step 1: Point: $(2,0)$. Tangent gradient: $\frac{dy}{dx}=2x-3=1$ at $x=2$.`,
  R`Step 2: The normal is perpendicular to the tangent, so its gradient is the negative reciprocal: $-\frac1m=-1$.`,
  R`Step 3: $y-0=-1(x-2)$.`,
  R`Step 4: $y=-x+2$.`), T.tn);
add(R`Find the tangent to $y=x^3$ at $x=1$.`, M(R`y=3x-2`), [M(R`y=3x+2`), M(R`y=x`), M(R`y=3x-3`)], St(
  R`Step 1: Point: $y=1^3=1$, so $(1,1)$.`,
  R`Step 2: Gradient: $\frac{dy}{dx}=3x^2=3$ at $x=1$.`,
  R`Step 3: $y-1=3(x-1)$, so $y=3x-3+1$.`,
  R`Step 4: $y=3x-2$.`), T.tn);
add(R`Find the equation of the tangent to $y=x^2+1$ that is parallel to the line $y=4x$.`, M(R`y=4x-3`), [M(R`y=4x+5`), M(R`y=4x+1`), M(R`y=4x-5`)], St(
  R`Step 1: Parallel lines have equal gradients, so we need $\frac{dy}{dx}=4$.`,
  R`Step 2: $\frac{dy}{dx}=2x$, so $2x=4$ and $x=2$.`,
  R`Step 3: The point: $y=4+1=5$, so $(2,5)$.`,
  R`Step 4: $y-5=4(x-2)$, so $y=4x-8+5=4x-3$.`), T.tn);
add(R`At what points is the tangent to $y=x^3-3x$ horizontal?`, M(R`(1,-2)\text{ and }(-1,2)`), [M(R`(1,2)\text{ and }(-1,-2)`), M(R`(0,0)\text{ only}`), M(R`(3,18)\text{ and }(-3,-18)`)], St(
  R`Step 1: A horizontal tangent has gradient $0$, so solve $\frac{dy}{dx}=0$.`,
  R`Step 2: $\frac{dy}{dx}=3x^2-3=3(x-1)(x+1)=0$, so $x=1$ or $x=-1$.`,
  R`Step 3: Find $y$: at $x=1$, $y=1-3=-2$. At $x=-1$, $y=-1+3=2$.`,
  R`Step 4: The points are $(1,-2)$ and $(-1,2)$.`), T.tn);

// =========================================================== MAXIMA AND MINIMA
add(R`Find the minimum value of $y=x^2-6x+5$.`, '-4', ['3', '5', '-3'], St(
  R`Step 1: Differentiate: $y'=2x-6$.`,
  R`Step 2: Set $y'=0$: $2x=6$, so $x=3$.`,
  R`Step 3: Second derivative test: $y''=2>0$, so it is a minimum.`,
  R`Step 4: Value: $y=9-18+5=-4$.`,
  R`Shortcut: for $ax^2+bx+c$ the turning point is at $x=-\frac b{2a}=\frac6{2}=3$.`), T.tp);
add(R`Find the local maximum value of $y=x^3-3x^2-9x+5$.`, '10', ['-22', '5', '3'], St(
  R`Step 1: $y'=3x^2-6x-9=3(x^2-2x-3)=3(x-3)(x+1)$.`,
  R`Step 2: Set $y'=0$: $x=3$ or $x=-1$.`,
  R`Step 3: $y''=6x-6$. At $x=-1$: $y''=-12<0$ (maximum). At $x=3$: $y''=12>0$ (minimum).`,
  R`Step 4: The maximum is at $x=-1$: $y=-1-3+9+5=10$.`,
  R`Step 5: (The minimum value is $y(3)=27-27-27+5=-22$.)`), T.tp);
add(R`Find the maximum value of $y=-2x^2+8x+1$.`, '9', ['2', '1', '8'], St(
  R`Step 1: $y'=-4x+8=0$ gives $x=2$.`,
  R`Step 2: $y''=-4<0$, so it is a maximum.`,
  R`Step 3: $y=-2(4)+16+1=-8+16+1=9$.`,
  R`Shortcut: for a quadratic, the turning point is at $x=-\frac b{2a}=-\frac8{-4}=2$.`), T.tp);
add(R`The point of inflection of $y=x^3-6x^2+9x$ occurs at $x=$`, '2', ['1', '3', '0'], St(
  R`Step 1: A point of inflection is where $y''=0$ and the sign of $y''$ changes.`,
  R`Step 2: $y'=3x^2-12x+9$ and $y''=6x-12$.`,
  R`Step 3: $6x-12=0$ gives $x=2$.`,
  R`Step 4: $y''<0$ for $x<2$ and $y''>0$ for $x>2$, so the curve really changes from concave down to concave up there.`), T.inf);

// =========================================================== OPTIMISATION
add(R`A rectangle has perimeter $40$ m. What is the largest possible area?`, '100', ['400', '200', '80'], St(
  R`Step 1: Let the sides be $x$ and $y$. Perimeter: $2x+2y=40$, so $y=20-x$.`,
  R`Step 2: Area: $A=xy=x(20-x)=20x-x^2$.`,
  R`Step 3: $\frac{dA}{dx}=20-2x=0$ gives $x=10$, so $y=10$.`,
  R`Step 4: $\frac{d^2A}{dx^2}=-2<0$, so this is a maximum.`,
  R`Step 5: $A=10\times10=100$. (The best rectangle is a square.)`), T.opt);
add(R`An open box is made from a $12$ cm by $12$ cm square sheet by cutting a square of side $x$ from each corner and folding up the sides. What value of $x$ gives the largest volume, and what is that volume?`, M(R`x=2\text{ cm},\ V=128\text{ cm}^3`), [M(R`x=3\text{ cm},\ V=108\text{ cm}^3`), M(R`x=6\text{ cm},\ V=0`), M(R`x=1\text{ cm},\ V=100\text{ cm}^3`)], St(
  R`Step 1: The base is $(12-2x)$ by $(12-2x)$ and the height is $x$, so $V=x(12-2x)^2$.`,
  R`Step 2: Differentiate with the product rule: $V'=(12-2x)^2+x\cdot2(12-2x)(-2)=(12-2x)^2-4x(12-2x)$.`,
  R`Step 3: Factor: $V'=(12-2x)[(12-2x)-4x]=(12-2x)(12-6x)$.`,
  R`Step 4: $V'=0$ gives $x=6$ (no box is left) or $x=2$. So $x=2$.`,
  R`Step 5: $V=2(12-4)^2=2\times64=128$ cm$^3$.`), T.opt);
add(R`A farmer has $100$ m of fencing to enclose a rectangular field against a straight river, so only three sides need fencing. The largest area is:`, M(R`1250\text{ m}^2`), [M(R`2500\text{ m}^2`), M(R`625\text{ m}^2`), M(R`1000\text{ m}^2`)], St(
  R`Step 1: Let the two sides at right angles to the river be $x$ and the side parallel to it be $y$. Fence: $2x+y=100$, so $y=100-2x$.`,
  R`Step 2: Area: $A=xy=x(100-2x)=100x-2x^2$.`,
  R`Step 3: $\frac{dA}{dx}=100-4x=0$ gives $x=25$, so $y=50$.`,
  R`Step 4: $A''=-4<0$, a maximum.`,
  R`Step 5: $A=25\times50=1250$ m$^2$.`), T.opt);
add(R`For positive $x$, the smallest value of $x+\dfrac{36}{x}$ is:`, '12', ['6', '36', '18'], St(
  R`Step 1: Let $f(x)=x+36x^{-1}$. Then $f'(x)=1-\frac{36}{x^2}$.`,
  R`Step 2: $f'(x)=0$ gives $x^2=36$, so $x=6$ (positive).`,
  R`Step 3: $f''(x)=\frac{72}{x^3}>0$ for $x>0$, so it is a minimum.`,
  R`Step 4: $f(6)=6+6=12$.`,
  R`Shortcut: the sum of a number and its partner with a fixed product is smallest when they are equal: $6\times6=36$, so the sum is $6+6=12$.`), T.opt);

// =========================================================== RELATED RATES AND MOTION
add(R`The radius of a sphere increases at $2$ cm/s. How fast is the volume increasing when the radius is $3$ cm?`, M(R`72\pi\text{ cm}^3/\text{s}`), [M(R`36\pi\text{ cm}^3/\text{s}`), M(R`24\pi\text{ cm}^3/\text{s}`), M(R`18\pi\text{ cm}^3/\text{s}`)], St(
  R`Step 1: Volume of a sphere: $V=\frac43\pi r^3$.`,
  R`Step 2: Differentiate with respect to time $t$: $\frac{dV}{dt}=4\pi r^2\frac{dr}{dt}$.`,
  R`Step 3: Substitute $r=3$ and $\frac{dr}{dt}=2$: $4\pi(9)(2)=72\pi$.`), T.rr);
add(R`The radius of a circle grows at $0.2$ cm/s. How fast is its area growing when $r=5$ cm?`, M(R`2\pi\text{ cm}^2/\text{s}`), [M(R`\pi\text{ cm}^2/\text{s}`), M(R`5\pi\text{ cm}^2/\text{s}`), M(R`0.2\pi\text{ cm}^2/\text{s}`)], St(
  R`Step 1: $A=\pi r^2$.`,
  R`Step 2: $\frac{dA}{dt}=2\pi r\frac{dr}{dt}$.`,
  R`Step 3: $2\pi(5)(0.2)=2\pi$.`), T.rr);
add(R`A $5$ m ladder leans against a wall. Its foot slides away from the wall at $0.3$ m/s. How fast is the top sliding down when the foot is $3$ m from the wall?`, M(R`0.225\text{ m/s}`), [M(R`0.4\text{ m/s}`), M(R`0.3\text{ m/s}`), M(R`0.5\text{ m/s}`)], St(
  R`Step 1: Let $x$ be the foot distance and $y$ the height. Pythagoras: $x^2+y^2=25$.`,
  R`Step 2: When $x=3$: $y^2=25-9=16$, so $y=4$.`,
  R`Step 3: Differentiate with respect to $t$: $2x\frac{dx}{dt}+2y\frac{dy}{dt}=0$.`,
  R`Step 4: $\frac{dy}{dt}=-\frac xy\frac{dx}{dt}=-\frac34\times0.3=-0.225$.`,
  R`Step 5: The negative sign means the top is moving down at $0.225$ m/s.`), T.rr);
add(R`A particle moves so that its displacement is $s=t^3-6t^2+9t$ metres. Find its velocity at $t=2$ s.`, '-3 m/s', ['3 m/s', '0 m/s', '-12 m/s'], St(
  R`Step 1: Velocity is the derivative of displacement: $v=\frac{ds}{dt}=3t^2-12t+9$.`,
  R`Step 2: Put $t=2$: $3(4)-12(2)+9=12-24+9=-3$.`,
  R`Step 3: The negative sign means it is moving in the negative direction.`), T.va);
add(R`For $s=t^3-6t^2+9t$, at what times is the particle momentarily at rest?`, M(R`t=1\text{ s and }t=3\text{ s}`), [M(R`t=0\text{ s and }t=3\text{ s}`), M(R`t=2\text{ s only}`), M(R`t=1\text{ s and }t=9\text{ s}`)], St(
  R`Step 1: At rest means $v=0$.`,
  R`Step 2: $v=3t^2-12t+9=3(t^2-4t+3)=3(t-1)(t-3)$.`,
  R`Step 3: $v=0$ when $t=1$ or $t=3$.`), T.va);
add(R`For $s=t^3-6t^2+9t$, the acceleration at $t=3$ s is:`, '6 m/s^2', ['0 m/s^2', '9 m/s^2', '-6 m/s^2'], St(
  R`Step 1: Acceleration is the derivative of velocity: $a=\frac{dv}{dt}$.`,
  R`Step 2: $v=3t^2-12t+9$, so $a=6t-12$.`,
  R`Step 3: At $t=3$: $a=18-12=6$ m/s$^2$.`), T.va);

// =========================================================== ANTIDERIVATIVES
add(R`Evaluate ${M(R`\int(6x^2-4x+5)\,dx`)}.`, M(R`2x^3-2x^2+5x+c`), [M(R`12x-4+c`), M(R`6x^3-4x^2+5x+c`), M(R`2x^3-2x^2+c`)], St(
  R`Step 1: Integrate term by term using $\int ax^n\,dx=\frac{ax^{n+1}}{n+1}$.`,
  R`Step 2: $6x^2\to\frac{6x^3}3=2x^3$.`,
  R`Step 3: $-4x\to-\frac{4x^2}2=-2x^2$.`,
  R`Step 4: $5\to5x$.`,
  R`Step 5: Add the constant: $2x^3-2x^2+5x+c$. Differentiating gives back $6x^2-4x+5$.`), T.an);
checkInt((x) => 2 * x ** 3 - 2 * x * x + 5 * x, (x) => 6 * x * x - 4 * x + 5);
add(R`Evaluate ${M(R`\int\dfrac{dx}{\sqrt x}`)}.`, M(R`2\sqrt x+c`), [M(R`\frac{1}{2\sqrt x}+c`), M(R`\frac{2}{3}x^{3/2}+c`), M(R`\ln\sqrt x+c`)], St(
  R`Step 1: Rewrite with a power: $\frac1{\sqrt x}=x^{-1/2}$.`,
  R`Step 2: Add 1 to the power: $-\frac12+1=\frac12$.`,
  R`Step 3: Divide by the new power: $\frac{x^{1/2}}{1/2}=2x^{1/2}$.`,
  R`Step 4: $2\sqrt x+c$.`), T.an);
checkInt((x) => 2 * Math.sqrt(x), (x) => 1 / Math.sqrt(x));
add(R`Evaluate ${M(R`\int(x^2+1)^2\,dx`)}.`, M(R`\frac{x^5}5+\frac{2x^3}3+x+c`), [M(R`\frac{(x^2+1)^3}{3}+c`), M(R`\frac{x^5}5+\frac{x^3}3+x+c`), M(R`\frac{(x^2+1)^3}{6x}+c`)], St(
  R`Step 1: Do not integrate the bracket as it stands. Expand first: $(x^2+1)^2=x^4+2x^2+1$.`,
  R`Step 2: Integrate each term: $\frac{x^5}5+\frac{2x^3}3+x$.`,
  R`Step 3: Add $c$.`), T.an);
checkInt((x) => x ** 5 / 5 + 2 * x ** 3 / 3 + x, (x) => (x * x + 1) ** 2);
add(R`Evaluate ${M(R`\int(3x+2)^4\,dx`)}.`, M(R`\frac{(3x+2)^5}{15}+c`), [M(R`\frac{(3x+2)^5}{5}+c`), M(R`(3x+2)^5+c`), M(R`\frac{(3x+2)^5}{3}+c`)], St(
  R`Step 1: Let $u=3x+2$. Then $\frac{du}{dx}=3$, so $dx=\frac{du}3$.`,
  R`Step 2: The integral becomes $\int u^4\frac{du}3=\frac13\cdot\frac{u^5}5$.`,
  R`Step 3: Replace $u$: $\frac{(3x+2)^5}{15}+c$.`,
  R`Shortcut: $\int(ax+b)^n\,dx=\frac{(ax+b)^{n+1}}{a(n+1)}$. Here $a(n+1)=3\times5=15$.`), T.sub);
checkInt((x) => (3 * x + 2) ** 5 / 15, (x) => (3 * x + 2) ** 4);
add(R`Evaluate ${M(R`\int xe^{x^2}\,dx`)}.`, M(R`\frac12e^{x^2}+c`), [M(R`e^{x^2}+c`), M(R`2e^{x^2}+c`), M(R`\frac{x^2}{2}e^{x^2}+c`)], St(
  R`Step 1: Let $u=x^2$. Then $\frac{du}{dx}=2x$, so $x\,dx=\frac{du}2$.`,
  R`Step 2: The integral becomes $\int e^u\frac{du}2=\frac12e^u$.`,
  R`Step 3: Replace $u$: $\frac12e^{x^2}+c$.`), T.sub);
checkInt((x) => 0.5 * Math.exp(x * x), (x) => x * Math.exp(x * x));
add(R`Evaluate ${M(R`\int\dfrac{2x}{x^2+1}\,dx`)}.`, M(R`\ln(x^2+1)+c`), [M(R`\frac{1}{x^2+1}+c`), M(R`2\ln(x^2+1)+c`), M(R`\frac{x^2}{x^2+1}+c`)], St(
  R`Step 1: Notice the top $2x$ is exactly the derivative of the bottom $x^2+1$.`,
  R`Step 2: Let $u=x^2+1$, $du=2x\,dx$.`,
  R`Step 3: $\int\frac{du}u=\ln|u|$.`,
  R`Step 4: $\ln(x^2+1)+c$ (no modulus needed since $x^2+1>0$).`,
  R`Shortcut: $\int\frac{f'(x)}{f(x)}dx=\ln|f(x)|+c$.`), T.sub);
checkInt((x) => Math.log(x * x + 1), (x) => 2 * x / (x * x + 1));
add(R`Evaluate ${M(R`\int\sin x\cos x\,dx`)}.`, M(R`\frac12\sin^2x+c`), [M(R`\frac12\cos^2x+c`), M(R`\sin^2x+c`), M(R`-\frac12\sin^2x+c`)], St(
  R`Step 1: Let $u=\sin x$, so $du=\cos x\,dx$.`,
  R`Step 2: The integral becomes $\int u\,du=\frac{u^2}2$.`,
  R`Step 3: Replace $u$: $\frac12\sin^2x+c$.`,
  R`Note: $-\frac14\cos2x+c$ is the same family of answers because $\frac12\sin^2x=\frac14-\frac14\cos2x$.`), T.sub);
checkInt((x) => 0.5 * Math.sin(x) ** 2, (x) => Math.sin(x) * Math.cos(x));
add(R`Evaluate ${M(R`\int x\sqrt{x^2+4}\,dx`)}.`, M(R`\frac13(x^2+4)^{3/2}+c`), [M(R`\frac23(x^2+4)^{3/2}+c`), M(R`\frac12(x^2+4)^{3/2}+c`), M(R`\frac13(x^2+4)^{1/2}+c`)], St(
  R`Step 1: Let $u=x^2+4$. Then $du=2x\,dx$, so $x\,dx=\frac{du}2$.`,
  R`Step 2: The integral becomes $\int\sqrt u\frac{du}2=\frac12\int u^{1/2}du$.`,
  R`Step 3: $\frac12\cdot\frac{u^{3/2}}{3/2}=\frac12\cdot\frac23u^{3/2}=\frac13u^{3/2}$.`,
  R`Step 4: Replace $u$: $\frac13(x^2+4)^{3/2}+c$.`), T.sub);
checkInt((x) => (x * x + 4) ** 1.5 / 3, (x) => x * Math.sqrt(x * x + 4));

// =========================================================== INTEGRATION BY PARTS
add(R`Evaluate ${M(R`\int xe^x\,dx`)}.`, M(R`e^x(x-1)+c`), [M(R`e^x(x+1)+c`), M(R`xe^x+c`), M(R`\frac{x^2}{2}e^x+c`)], St(
  R`Step 1: The formula is $\int u\,dv=uv-\int v\,du$.`,
  R`Step 2: Choose $u$ using LIATE (Logs, Inverse trig, Algebraic, Trig, Exponential): $x$ is algebraic and $e^x$ is exponential, so $u=x$ and $dv=e^xdx$.`,
  R`Step 3: Then $du=dx$ and $v=e^x$.`,
  R`Step 4: $\int xe^xdx=xe^x-\int e^xdx=xe^x-e^x$.`,
  R`Step 5: Factor: $e^x(x-1)+c$.`), T.ip);
checkInt((x) => Math.exp(x) * (x - 1), (x) => x * Math.exp(x));
add(R`Evaluate ${M(R`\int x\cos x\,dx`)}.`, M(R`x\sin x+\cos x+c`), [M(R`x\sin x-\cos x+c`), M(R`-x\sin x+\cos x+c`), M(R`\sin x+x\cos x+c`)], St(
  R`Step 1: By LIATE choose $u=x$ and $dv=\cos x\,dx$.`,
  R`Step 2: $du=dx$ and $v=\sin x$.`,
  R`Step 3: $\int x\cos x\,dx=x\sin x-\int\sin x\,dx$.`,
  R`Step 4: $\int\sin x\,dx=-\cos x$, so the result is $x\sin x-(-\cos x)=x\sin x+\cos x$.`), T.ip);
checkInt((x) => x * Math.sin(x) + Math.cos(x), (x) => x * Math.cos(x));
add(R`Evaluate ${M(R`\int x\ln x\,dx`)}.`, M(R`\frac{x^2}2\ln x-\frac{x^2}4+c`), [M(R`\frac{x^2}2\ln x-\frac{x^2}2+c`), M(R`\frac{x^2}2\ln x+\frac{x^2}4+c`), M(R`x\ln x-x+c`)], St(
  R`Step 1: LIATE: logarithm comes first, so $u=\ln x$ and $dv=x\,dx$.`,
  R`Step 2: $du=\frac1x\,dx$ and $v=\frac{x^2}2$.`,
  R`Step 3: $\int x\ln x\,dx=\frac{x^2}2\ln x-\int\frac{x^2}2\cdot\frac1x\,dx$.`,
  R`Step 4: The last integral is $\int\frac x2\,dx=\frac{x^2}4$.`,
  R`Step 5: Result: $\frac{x^2}2\ln x-\frac{x^2}4+c$.`), T.ip);
checkInt((x) => x * x / 2 * Math.log(x) - x * x / 4, (x) => x * Math.log(x));
add(R`Evaluate ${M(R`\int\ln x\,dx`)}.`, M(R`x\ln x-x+c`), [M(R`\frac1x+c`), M(R`x\ln x+x+c`), M(R`\frac{(\ln x)^2}{2}+c`)], St(
  R`Step 1: Write $\ln x=1\cdot\ln x$ so that integration by parts can be used.`,
  R`Step 2: $u=\ln x$ and $dv=dx$, so $du=\frac1x\,dx$ and $v=x$.`,
  R`Step 3: $\int\ln x\,dx=x\ln x-\int x\cdot\frac1x\,dx=x\ln x-\int1\,dx$.`,
  R`Step 4: $x\ln x-x+c$.`), T.ip);
checkInt((x) => x * Math.log(x) - x, (x) => Math.log(x));
add(R`Evaluate ${M(R`\int x^2e^x\,dx`)}.`, M(R`e^x(x^2-2x+2)+c`), [M(R`e^x(x^2+2x+2)+c`), M(R`e^x(x^2-2x)+c`), M(R`\frac{x^3}{3}e^x+c`)], St(
  R`Step 1: Integrate by parts twice. First: $u=x^2$, $dv=e^xdx$, so $du=2x\,dx$ and $v=e^x$: $\int x^2e^xdx=x^2e^x-2\int xe^xdx$.`,
  R`Step 2: Second: $\int xe^xdx=e^x(x-1)$ (from the previous worked example).`,
  R`Step 3: So the result is $x^2e^x-2e^x(x-1)=e^x(x^2-2x+2)$.`,
  R`Shortcut (tabular method): differentiate $x^2$ repeatedly: $x^2,\,2x,\,2,\,0$ and integrate $e^x$ repeatedly: $e^x,\,e^x,\,e^x$. Multiply along the diagonals with alternating signs $+,-,+$: $x^2e^x-2xe^x+2e^x$.`), T.ip);
checkInt((x) => Math.exp(x) * (x * x - 2 * x + 2), (x) => x * x * Math.exp(x));

// =========================================================== PARTIAL FRACTIONS
add(R`Evaluate ${M(R`\int\dfrac{dx}{(x-1)(x+2)}`)}.`, M(R`\frac13\ln\left|\frac{x-1}{x+2}\right|+c`), [M(R`\frac13\ln\left|\frac{x+2}{x-1}\right|+c`), M(R`\ln|(x-1)(x+2)|+c`), M(R`\ln\left|\frac{x-1}{x+2}\right|+c`)], St(
  R`Step 1: Write $\frac1{(x-1)(x+2)}=\frac A{x-1}+\frac B{x+2}$.`,
  R`Step 2: Multiply through by $(x-1)(x+2)$: $1=A(x+2)+B(x-1)$.`,
  R`Step 3: Put $x=1$: $1=3A$, so $A=\frac13$. Put $x=-2$: $1=-3B$, so $B=-\frac13$.`,
  R`Step 4: $\int\left(\frac{1/3}{x-1}-\frac{1/3}{x+2}\right)dx=\frac13\ln|x-1|-\frac13\ln|x+2|$.`,
  R`Step 5: Combine the logs: $\frac13\ln\left|\frac{x-1}{x+2}\right|+c$.`,
  R`Shortcut (cover-up): to find $A$, cover $(x-1)$ and put $x=1$ in what is left: $\frac1{1+2}=\frac13$. To find $B$, cover $(x+2)$ and put $x=-2$: $\frac1{-2-1}=-\frac13$.`), T.pf);
checkInt((x) => Math.log(Math.abs((x - 1) / (x + 2))) / 3, (x) => 1 / ((x - 1) * (x + 2)), [2, 3, 4]);
add(R`Evaluate ${M(R`\int\dfrac{3x+5}{(x+1)(x+2)}\,dx`)}.`, M(R`2\ln|x+1|+\ln|x+2|+c`), [M(R`\ln|x+1|+2\ln|x+2|+c`), M(R`2\ln|x+1|-\ln|x+2|+c`), M(R`3\ln|(x+1)(x+2)|+c`)], St(
  R`Step 1: $\frac{3x+5}{(x+1)(x+2)}=\frac A{x+1}+\frac B{x+2}$, so $3x+5=A(x+2)+B(x+1)$.`,
  R`Step 2: Put $x=-1$: $-3+5=A(1)$, so $A=2$.`,
  R`Step 3: Put $x=-2$: $-6+5=B(-1)$, so $-1=-B$ and $B=1$.`,
  R`Step 4: $\int\left(\frac2{x+1}+\frac1{x+2}\right)dx=2\ln|x+1|+\ln|x+2|+c$.`,
  R`Shortcut (cover-up): $A=\frac{3(-1)+5}{(-1+2)}=2$ and $B=\frac{3(-2)+5}{(-2+1)}=\frac{-1}{-1}=1$.`), T.pf);
checkInt((x) => 2 * Math.log(Math.abs(x + 1)) + Math.log(Math.abs(x + 2)), (x) => (3 * x + 5) / ((x + 1) * (x + 2)), [0.5, 1, 2]);
add(R`Evaluate ${M(R`\int\dfrac{dx}{x^2-1}`)}.`, M(R`\frac12\ln\left|\frac{x-1}{x+1}\right|+c`), [M(R`\frac12\ln\left|\frac{x+1}{x-1}\right|+c`), M(R`\ln|x^2-1|+c`), M(R`\ln|x-1|+\ln|x+1|+c`)], St(
  R`Step 1: Factorise the bottom: $x^2-1=(x-1)(x+1)$.`,
  R`Step 2: $\frac1{(x-1)(x+1)}=\frac A{x-1}+\frac B{x+1}$.`,
  R`Step 3: Cover-up: at $x=1$, $A=\frac1{1+1}=\frac12$. At $x=-1$, $B=\frac1{-1-1}=-\frac12$.`,
  R`Step 4: $\int\left(\frac{1/2}{x-1}-\frac{1/2}{x+1}\right)dx=\frac12\ln|x-1|-\frac12\ln|x+1|$.`,
  R`Step 5: $\frac12\ln\left|\frac{x-1}{x+1}\right|+c$.`), T.pf);
checkInt((x) => 0.5 * Math.log(Math.abs((x - 1) / (x + 1))), (x) => 1 / (x * x - 1), [2, 3, 4]);

// =========================================================== DEFINITE INTEGRALS AND SHORTCUTS
add(R`Evaluate ${M(R`\int_0^2(3x^2+1)\,dx`)}.`, '10', ['8', '14', '12'], St(
  R`Step 1: Antiderivative: $x^3+x$.`,
  R`Step 2: Upper limit ($x=2$): $8+2=10$.`,
  R`Step 3: Lower limit ($x=0$): $0$.`,
  R`Step 4: Subtract: $10-0=10$.`), T.di);
chk(simpson((x) => 3 * x * x + 1, 0, 2), 10, 1e-6);
add(R`Evaluate ${M(R`\int_0^1 2x(x^2+1)^3\,dx`)}.`, M(R`\frac{15}4`), [M(R`\frac{15}8`), M(R`\frac{1}{4}`), M(R`\frac{16}{4}`)], St(
  R`Step 1: Let $u=x^2+1$, so $du=2x\,dx$.`,
  R`Step 2: Change the limits too: $x=0\Rightarrow u=1$ and $x=1\Rightarrow u=2$.`,
  R`Step 3: $\int_1^2u^3\,du=\left[\frac{u^4}4\right]_1^2=\frac{16}4-\frac14=\frac{15}4$.`,
  R`Shortcut: changing the limits means there is no need to go back to $x$.`), T.di);
chk(simpson((x) => 2 * x * (x * x + 1) ** 3, 0, 1), 15 / 4, 1e-6);
add(R`Evaluate ${M(R`\int_{-2}^{2}x^3\,dx`)}.`, '0', ['8', '16', '4'], St(
  R`Step 1: Notice $f(x)=x^3$ is an odd function: $f(-x)=-f(x)$, and the limits are symmetric.`,
  R`Step 2: The area on the left of the $y$-axis cancels the area on the right.`,
  R`Step 3: So the answer is $0$.`,
  R`Check: $\left[\frac{x^4}4\right]_{-2}^{2}=\frac{16}4-\frac{16}4=0$.`,
  R`Shortcut: an odd function over $[-a,a]$ always integrates to $0$.`), T.di);
chk(simpson((x) => x ** 3, -2, 2), 0, 1e-9);
add(R`Evaluate ${M(R`\int_{-1}^{1}(x^2+x)\,dx`)}.`, M(R`\frac23`), ['0', M(R`\frac43`), M(R`\frac13`)], St(
  R`Step 1: Split the integrand: $x^2$ is even and $x$ is odd.`,
  R`Step 2: The odd part $\int_{-1}^1x\,dx=0$.`,
  R`Step 3: The even part is double the half-range: $2\int_0^1x^2dx=2\left[\frac{x^3}3\right]_0^1=\frac23$.`,
  R`Step 4: Total $=\frac23+0=\frac23$.`,
  R`Shortcut: for symmetric limits, odd terms vanish and even terms double.`), T.di);
chk(simpson((x) => x * x + x, -1, 1), 2 / 3, 1e-6);
add(R`Evaluate ${M(R`\int_0^{\pi}\sin^2x\,dx`)}.`, M(R`\frac\pi2`), ['0', M(R`\pi`), M(R`\frac\pi4`)], St(
  R`Step 1: Use the identity $\sin^2x=\frac{1-\cos2x}2$ (it comes from $\cos2x=1-2\sin^2x$).`,
  R`Step 2: $\int_0^\pi\frac{1-\cos2x}2dx=\frac12\left[x-\frac{\sin2x}2\right]_0^\pi$.`,
  R`Step 3: At $\pi$: $\pi-\frac{\sin2\pi}2=\pi-0=\pi$. At $0$: $0$.`,
  R`Step 4: $\frac12\times\pi=\frac\pi2$.`), T.di);
chk(simpson((x) => Math.sin(x) ** 2, 0, Math.PI), Math.PI / 2, 1e-6);
add(R`Evaluate ${M(R`\int_1^e\dfrac1x\,dx`)}.`, '1', ['e', '0', M(R`e-1`)], St(
  R`Step 1: $\int\frac1x\,dx=\ln x$.`,
  R`Step 2: $\ln e-\ln1=1-0=1$.`), T.di);
chk(simpson((x) => 1 / x, 1, Math.E), 1, 1e-6);

// =========================================================== AREAS AND VOLUMES
add(R`Find the area bounded by $y=x^2$, the $x$-axis and the lines $x=0$ and $x=3$.`, '9', ['27', M(R`\frac92`), '3'], St(
  R`Step 1: Area under a curve above the $x$-axis is $\int_0^3x^2\,dx$.`,
  R`Step 2: Antiderivative: $\frac{x^3}3$.`,
  R`Step 3: $\frac{27}3-0=9$.`), T.ar);
chk(simpson((x) => x * x, 0, 3), 9, 1e-6);
add(R`Find the area enclosed between $y=x$ and $y=x^2$.`, M(R`\frac16`), [M(R`\frac13`), M(R`\frac12`), M(R`\frac56`)], St(
  R`Step 1: Find where they meet: $x=x^2\Rightarrow x(1-x)=0\Rightarrow x=0$ or $x=1$.`,
  R`Step 2: On $[0,1]$ the line $y=x$ is above the parabola (e.g. at $x=0.5$: $0.5>0.25$).`,
  R`Step 3: Area $=\int_0^1(x-x^2)\,dx=\left[\frac{x^2}2-\frac{x^3}3\right]_0^1$.`,
  R`Step 4: $\frac12-\frac13=\frac16$.`), T.ar);
chk(simpson((x) => x - x * x, 0, 1), 1 / 6, 1e-6);
add(R`Find the area enclosed between $y=x^2$ and $y=2x$.`, M(R`\frac43`), [M(R`\frac83`), M(R`4`), M(R`\frac23`)], St(
  R`Step 1: Intersections: $x^2=2x\Rightarrow x(x-2)=0\Rightarrow x=0$ or $x=2$.`,
  R`Step 2: At $x=1$: line gives $2$ and parabola gives $1$, so the line is the upper curve.`,
  R`Step 3: Area $=\int_0^2(2x-x^2)\,dx=\left[x^2-\frac{x^3}3\right]_0^2$.`,
  R`Step 4: $4-\frac83=\frac43$.`), T.ar);
chk(simpson((x) => 2 * x - x * x, 0, 2), 4 / 3, 1e-6);
add(R`The region under $y=\sqrt x$ from $x=0$ to $x=4$ is rotated about the $x$-axis. Its volume is:`, M(R`8\pi`), [M(R`16\pi`), M(R`4\pi`), M(R`\frac{16\pi}{3}`)], St(
  R`Step 1: Disc method: $V=\pi\int_a^by^2\,dx$.`,
  R`Step 2: $y^2=(\sqrt x)^2=x$.`,
  R`Step 3: $V=\pi\int_0^4x\,dx=\pi\left[\frac{x^2}2\right]_0^4=\pi\times8$.`,
  R`Step 4: $V=8\pi$.`), T.vol);
chk(Math.PI * simpson((x) => x, 0, 4), 8 * Math.PI, 1e-6);

// =========================================================== INITIAL CONDITIONS
add(R`If $\dfrac{dy}{dx}=6x-2$ and $y=5$ when $x=1$, then $y=$`, M(R`3x^2-2x+4`), [M(R`3x^2-2x+5`), M(R`6x^2-2x+1`), M(R`3x^2-2x+3`)], St(
  R`Step 1: Integrate: $y=3x^2-2x+c$.`,
  R`Step 2: Use the condition $y=5$ at $x=1$: $3-2+c=5$.`,
  R`Step 3: $1+c=5$, so $c=4$.`,
  R`Step 4: $y=3x^2-2x+4$.`), T.ic);
add(R`A curve has gradient $\dfrac{dy}{dx}=4x^3-3$ and passes through $(1,2)$. Its equation is:`, M(R`y=x^4-3x+4`), [M(R`y=x^4-3x+2`), M(R`y=x^4-3x-4`), M(R`y=12x^2+2`)], St(
  R`Step 1: Integrate: $y=x^4-3x+c$.`,
  R`Step 2: Substitute the point $(1,2)$: $2=1-3+c$.`,
  R`Step 3: $2=-2+c$, so $c=4$.`,
  R`Step 4: $y=x^4-3x+4$.`), T.ic);

module.exports = out;
