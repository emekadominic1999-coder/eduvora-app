// MTH 103 (Calculus) - batch F, written after the course text "Calculus Made Easy" (Elementary Mathematics II) for the
// question styles it drills: special functions (sgn, Heaviside, modulus, greatest integer), domain and range, inverse and
// composite functions, limits and L'Hopital's rule, continuity with an unknown constant, the differentiation rules,
// turning points, tangents and normals, rate of change and integration by substitution.
// Every derivative, limit and integral answer is checked numerically when the file is loaded.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const M = (s) => '$' + s + '$';
const T = {
  sp: 'Special Functions', dom: 'Domain and Range of a Function', inv: 'Inverse and Composite Functions', lim: 'Limits and the Indeterminate Form 0/0', limInf: 'Limits at Infinity',
  con: 'Continuity of a Function', dis: 'Points of Discontinuity', dif: 'Techniques of Differentiation', par: 'Derivatives of Parametric and Implicit Functions', tp: 'Turning Points and Points of Inflection',
  tn: 'Equations of Tangent and Normal', rc: 'Rate of Change', int: 'Integration by Substitution', ap: 'Anti-derivatives with Initial Conditions',
};
const chk = (a, b, tol = 1e-6) => { if (Math.abs(a - b) > tol) throw new Error('check failed ' + a + ' vs ' + b); };
const nd = (f, x) => (f(x + 1e-5) - f(x - 1e-5)) / 2e-5;
const checkD = (f, g, xs = [0.3, 0.5]) => { for (const x of xs) chk(nd(f, x), g(x), 1e-4 * Math.max(1, Math.abs(g(x)))); };
const checkLim = (f, a, v) => chk((f(a + 1e-5) + f(a - 1e-5)) / 2, v, 2e-3);
const checkInf = (f, v) => chk(f(1e6), v, 2e-3);
const simpson = (f, a, b, n = 2000) => { const h = (b - a) / n; let s = f(a) + f(b); for (let i = 1; i < n; i++) s += f(a + i * h) * (i % 2 ? 4 : 2); return s * h / 3; };
const sgn = (x) => (x > 0 ? 1 : x < 0 ? -1 : 0);

// ---------------------------------------------------------------- special functions
add(R`The signum function is defined by $\operatorname{sgn}(x)=1$ for $x>0$, $0$ for $x=0$ and $-1$ for $x<0$. Evaluate $\operatorname{sgn}(-4.5)+\operatorname{sgn}(0)+\operatorname{sgn}(7)$.`, '0', ['1', '-1', '2'], R`$-1+0+1=0$.`, T.sp);
chk(sgn(-4.5) + sgn(0) + sgn(7), 0);
add(R`The Heaviside function is $H(x)=1$ for $x>0$ and $H(x)=0$ for $x\le 0$. The value of $H(-2)+H(0.8)+H(0)$ is:`, '1', ['0', '2', '3'], R`$H(-2)=0$, $H(0.8)=1$ and $H(0)=0$, so the sum is $1$.`, T.sp);
add(R`Evaluate $\lfloor -5.3\rfloor+\lfloor 2.6\rfloor+\lfloor 9\rfloor$, where $\lfloor x\rfloor$ is the greatest integer not exceeding $x$.`, '5', ['6', '3', '7'], R`$\lfloor -5.3\rfloor=-6$, $\lfloor 2.6\rfloor=2$, $\lfloor 9\rfloor=9$, and $-6+2+9=5$.`, T.sp);
chk(Math.floor(-5.3) + Math.floor(2.6) + 9, 5);
add(R`The value of $\lfloor 3.7\rfloor+\lfloor -3.7\rfloor$ is:`, '-1', ['0', '1', '-2'], R`$\lfloor 3.7\rfloor=3$ and $\lfloor -3.7\rfloor=-4$, so the sum is $-1$.`, T.sp);
chk(Math.floor(3.7) + Math.floor(-3.7), -1);
add(R`If $f(x)=x-\lfloor x\rfloor$, then $f(-1.9)$ equals:`, '0.1', ['0.9', '-0.1', '-3.9'], R`$\lfloor -1.9\rfloor=-2$, so $f(-1.9)=-1.9-(-2)=0.1$.`, T.sp);
chk(-1.9 - Math.floor(-1.9), 0.1);
add(R`If $f(x)=|x|-x^2$, then $f(-3)$ is:`, '-6', ['6', '12', '-12'], R`$f(-3)=|-3|-(-3)^2=3-9=-6$.`, T.sp);
add(R`The value of $\left|\dfrac{2x-7}{2-x^2}\right|$ at $x=\dfrac12$ is:`, M(R`\frac{24}{7}`), [M('6'), M(R`\frac{24}{5}`), M(R`\frac{12}{7}`)], R`The numerator is $1-7=-6$ and the denominator is $2-\tfrac14=\tfrac74$, so the modulus of $-6\div\tfrac74$ is $\tfrac{24}{7}$.`, T.sp);
chk(Math.abs((2 * 0.5 - 7) / (2 - 0.25)), 24 / 7);
add(R`If $f(x)=\dfrac{|x-1|}{x-1}$, then $f(-2)+f(3)$ equals:`, '0', ['2', '-2', '1'], R`$f(-2)=\tfrac{3}{-3}=-1$ and $f(3)=\tfrac{2}{2}=1$.`, T.sp);
add(R`If $g(x)=x-|x|$, then $g(-4)+g(5)$ equals:`, '-8', ['8', '0', '-9'], R`$g(-4)=-4-4=-8$ and $g(5)=5-5=0$.`, T.sp);
add(R`The range of the signum function $\operatorname{sgn}(x)$ is:`, M(R`\{-1,0,1\}`), [M(R`\{-1,1\}`), M(R`[-1,1]`), M(R`\{0,1\}`)], R`The function takes exactly the three values $-1$, $0$ and $1$.`, T.sp);
add(R`The domain and range of the Heaviside function $H(x)$ are respectively:`, M(R`\mathbb{R}\ \text{and}\ \{0,1\}`), [M(R`[0,\infty)\ \text{and}\ \{0,1\}`), M(R`\mathbb{R}\ \text{and}\ [0,1]`), M(R`\{0,1\}\ \text{and}\ \mathbb{R}`)], R`$H$ is defined for every real $x$ but takes only the values $0$ and $1$.`, T.sp);
add(R`The range of the greatest integer function $f(x)=\lfloor x\rfloor$ is:`, 'The set of all integers', ['The set of all real numbers', 'The set of non-negative integers', 'The set of rational numbers'], R`$\lfloor x\rfloor$ is always an integer and every integer is attained.`, T.sp);
add(R`If $f(x)=x^2-9$, then $\operatorname{sgn}(f(1))+2\operatorname{sgn}(f(4))+\operatorname{sgn}(f(3))$ equals:`, '1', ['0', '2', '3'], R`$f(1)=-8$, $f(4)=7$, $f(3)=0$, so the sum is $-1+2+0=1$.`, T.sp);
add(R`If $f(x)=|x|+x^3$, then $\operatorname{sgn}(f(-2))$ is:`, '-1', ['1', '0', '-6'], R`$f(-2)=2-8=-6<0$, so the signum is $-1$.`, T.sp);

// ---------------------------------------------------------------- domain and range
add(R`The domain of $f(x)=\sqrt{x-4}$ is:`, M(R`[4,\infty)`), [M(R`(4,\infty)`), M(R`(-\infty,4]`), M(R`\mathbb{R}`)], R`The expression under the root must satisfy $x-4\ge 0$.`, T.dom);
add(R`The domain and range of $y=\sqrt{3-x}$ are respectively:`, M(R`x\le 3,\ y\ge 0`), [M(R`x\ge 3,\ y\ge 0`), M(R`x\le 3,\ y\le 0`), M(R`x<3,\ y>0`)], R`We need $3-x\ge 0$, so $x\le 3$; a square root is never negative, so $y\ge 0$.`, T.dom);
add(R`The domain of $f(x)=\dfrac{1}{x^2-x-2}$ is:`, M(R`\mathbb{R}\setminus\{-1,2\}`), [M(R`\mathbb{R}\setminus\{1,-2\}`), M(R`\mathbb{R}\setminus\{-1\}`), M(R`\mathbb{R}\setminus\{2\}`)], R`$x^2-x-2=(x-2)(x+1)$ is zero at $x=2$ and $x=-1$.`, T.dom);
add(R`The domain of $f(x)=\dfrac{x}{|x|-1}$ is:`, M(R`\mathbb{R}\setminus\{-1,1\}`), [M(R`\mathbb{R}\setminus\{1\}`), M(R`\mathbb{R}\setminus\{0\}`), M(R`\mathbb{R}\setminus\{0,1\}`)], R`The denominator vanishes when $|x|=1$, that is $x=\pm1$.`, T.dom);
add(R`The domain of $f(x)=\sqrt{1-x^2}$ is:`, M(R`[-1,1]`), [M(R`(-1,1)`), M(R`(-\infty,-1]\cup[1,\infty)`), M(R`\mathbb{R}`)], R`We need $1-x^2\ge 0$, which holds for $|x|\le1$.`, T.dom);
add(R`The range of $y=3+\dfrac{1}{x}$ is:`, M(R`\mathbb{R}\setminus\{3\}`), [M(R`\mathbb{R}\setminus\{0\}`), M(R`\mathbb{R}`), M(R`\mathbb{R}\setminus\{-3\}`)], R`$\tfrac1x$ takes every non-zero real value, so $y$ takes every real value except $3$.`, T.dom);
add(R`The domain of $f(x)=\dfrac{1}{\sqrt{x+2}}$ is:`, M(R`(-2,\infty)`), [M(R`[-2,\infty)`), M(R`(-\infty,-2)`), M(R`\mathbb{R}\setminus\{-2\}`)], R`We need $x+2>0$: zero is excluded because it is in the denominator.`, T.dom);
add(R`The range of $y=\dfrac{x+1}{x-1}$ is:`, M(R`\mathbb{R}\setminus\{1\}`), [M(R`\mathbb{R}\setminus\{-1\}`), M(R`\mathbb{R}\setminus\{0\}`), M(R`\mathbb{R}`)], R`Solving for $x$ gives $x=\tfrac{y+1}{y-1}$, which fails only at $y=1$.`, T.dom);
add(R`The domain of $f(x)=\sqrt{x^2-5x+6}$ is:`, M(R`(-\infty,2]\cup[3,\infty)`), [M(R`[2,3]`), M(R`(2,3)`), M(R`(-\infty,2)\cup(3,\infty)`)], R`$x^2-5x+6=(x-2)(x-3)\ge 0$ outside the roots, including them.`, T.dom);
add(R`The domain of $f(x)=\ln(x-3)$ is:`, M(R`(3,\infty)`), [M(R`[3,\infty)`), M(R`(-\infty,3)`), M(R`\mathbb{R}\setminus\{3\}`)], R`The logarithm is defined only for a positive argument.`, T.dom);

// ---------------------------------------------------------------- inverse and composite functions
add(R`The inverse of $f(x)=2x+8$ is:`, M(R`\frac{x-8}{2}`), [M(R`\frac{x+8}{2}`), M(R`2x-8`), M(R`\frac{x}{2}-8`)], R`Put $y=2x+8$, so $x=\tfrac{y-8}{2}$, and swap the letters.`, T.inv);
add(R`If $f(x)=3x-4$, then $f^{-1}(a)$ is:`, M(R`\frac{a+4}{3}`), [M(R`\frac{a-4}{3}`), M(R`3a+4`), M(R`\frac{a}{3}-4`)], R`$y=3x-4$ gives $x=\tfrac{y+4}{3}$.`, T.inv);
add(R`The inverse of $f(x)=1+\ln x$ is:`, M(R`e^{x-1}`), [M(R`e^{x+1}`), M(R`e^{x}-1`), M(R`\ln(x-1)`)], R`$y=1+\ln x\Rightarrow x=e^{y-1}$.`, T.inv);
add(R`The inverse of $f(x)=e^{x}+1$ is:`, M(R`\ln(x-1)`), [M(R`\ln x-1`), M(R`\ln(x+1)`), M(R`e^{x}-1`)], R`$y=e^x+1\Rightarrow x=\ln(y-1)$.`, T.inv);
add(R`The inverse of $f(x)=\dfrac{x}{2}+3$ is:`, M(R`2x-6`), [M(R`2x+6`), M(R`\frac{x}{2}-3`), M(R`2x-3`)], R`$y=\tfrac{x}{2}+3\Rightarrow x=2(y-3)=2y-6$.`, T.inv);
add(R`The inverse of $f(x)=x^2+2$ for $x\ge 0$ is:`, M(R`\sqrt{x-2}`), [M(R`\sqrt{x+2}`), M(R`\sqrt{x}-2`), M(R`x^2-2`)], R`$y=x^2+2\Rightarrow x=\sqrt{y-2}$ (positive root since $x\ge 0$).`, T.inv);
add(R`If $f(x)=2x+1$ and $g(x)=x^2-5$, then $(f\circ g)(x)$ is:`, M(R`2x^2-9`), [M(R`4x^2+4x-4`), M(R`2x^2-4`), M(R`2x^2-5`)], R`$f(g(x))=2(x^2-5)+1=2x^2-9$.`, T.inv);
add(R`If $f(x)=|x-1|$ and $g(x)=3x-5$, then $(g\circ f)(x)$ is:`, M(R`3|x-1|-5`), [M(R`|3x-6|`), M(R`3|x|-6`), M(R`|x-1|(3x-5)`)], R`$g(f(x))=3f(x)-5=3|x-1|-5$.`, T.inv);
add(R`If $f(x)=\sqrt{x}$ and $g(x)=1+2x$, then $(f\circ g)(4)$ equals:`, '3', ['5', '9', '2'], R`$g(4)=9$ and $f(9)=3$.`, T.inv);
chk(Math.sqrt(1 + 2 * 4), 3);

// ---------------------------------------------------------------- limits
const Lm = (stem, fn, a, val, correct, wrongs, expl, topic = T.lim) => { checkLim(fn, a, val); add(stem, correct, wrongs, expl, topic); };
Lm(R`Evaluate $\displaystyle\lim_{x\to0}\frac{\sin 3x}{2x}$.`, (x) => Math.sin(3 * x) / (2 * x), 0, 1.5, M(R`\frac32`), [M('3'), M(R`\frac23`), M('6')], R`$\tfrac{\sin 3x}{2x}=\tfrac32\cdot\tfrac{\sin 3x}{3x}\to\tfrac32$.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to0}\frac{1-\cos x}{x^2}$.`, (x) => (1 - Math.cos(x)) / (x * x), 0.001, 0.5, M(R`\frac12`), ['0', '1', '2'], R`Apply L'Hôpital's rule twice: $\tfrac{\sin x}{2x}\to\tfrac{\cos x}{2}\to\tfrac12$.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to2}\frac{x^2-4}{x^2-x-2}$.`, (x) => (x * x - 4) / (x * x - x - 2), 2, 4 / 3, M(R`\frac43`), ['1', M(R`\frac34`), '4'], R`Factorising gives $\tfrac{(x-2)(x+2)}{(x-2)(x+1)}=\tfrac{x+2}{x+1}\to\tfrac43$.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to3}\frac{x^2-x-6}{x^2-9}$.`, (x) => (x * x - x - 6) / (x * x - 9), 3, 5 / 6, M(R`\frac56`), [M(R`\frac65`), '1', '0'], R`$\tfrac{(x-3)(x+2)}{(x-3)(x+3)}=\tfrac{x+2}{x+3}\to\tfrac56$.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to4}\frac{\sqrt{x}-2}{x-4}$.`, (x) => (Math.sqrt(x) - 2) / (x - 4), 4, 0.25, M(R`\frac14`), [M(R`\frac12`), '0', '4'], R`L'Hôpital: $\tfrac{1/(2\sqrt x)}{1}=\tfrac{1}{2\cdot2}=\tfrac14$.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to0}\frac{x\cos x-\sin x}{x^3}$.`, (x) => (x * Math.cos(x) - Math.sin(x)) / (x * x * x), 0.01, -1 / 3, M(R`-\frac13`), [M(R`\frac13`), M(R`-\frac16`), '0'], R`Use the series: $x\cos x-\sin x\approx -\tfrac{x^3}{3}$, or apply L'Hôpital's rule three times.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to0}\frac{1-e^{2x}}{1-e^{x}}$.`, (x) => (1 - Math.exp(2 * x)) / (1 - Math.exp(x)), 0.001, 2, '2', ['1', '0', M(R`\frac12`)], R`$\tfrac{1-e^{2x}}{1-e^x}=1+e^x\to2$.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to0}\frac{\sin 5x-\sin 2x}{x}$.`, (x) => (Math.sin(5 * x) - Math.sin(2 * x)) / x, 0.001, 3, '3', ['7', '10', '0'], R`L'Hôpital: $5\cos5x-2\cos2x\to5-2=3$.`);
Lm(R`Evaluate $\displaystyle\lim_{h\to0}\frac{\sqrt{4+h}-2}{h}$.`, (h) => (Math.sqrt(4 + h) - 2) / h, 0.001, 0.25, M(R`\frac14`), ['4', '0', M(R`\frac12`)], R`This is the derivative of $\sqrt{x}$ at $x=4$, which is $\tfrac{1}{2\sqrt4}=\tfrac14$.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to0}\frac{x^2}{1-\cos x}$.`, (x) => (x * x) / (1 - Math.cos(x)), 0.01, 2, '2', [M(R`\frac12`), '0', '1'], R`Using L'Hôpital twice: $\tfrac{2x}{\sin x}\to\tfrac{2}{\cos x}\to2$.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to1}\frac{\sqrt{x}-1}{1-x}$.`, (x) => (Math.sqrt(x) - 1) / (1 - x), 1, -0.5, M(R`-\frac12`), [M(R`\frac12`), '-2', '0'], R`L'Hôpital: $\tfrac{1/(2\sqrt x)}{-1}\to-\tfrac12$.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to0}\frac{\tan 3x}{x}$.`, (x) => Math.tan(3 * x) / x, 0.001, 3, '3', [M(R`\frac13`), '1', '0'], R`$\tfrac{\tan 3x}{x}\to\tfrac{3\sec^23x}{1}=3$.`);
Lm(R`Evaluate $\displaystyle\lim_{x\to\infty}\frac{2x^2-3x+1}{3x^2-5x-1}$.`, (x) => (2 * x * x - 3 * x + 1) / (3 * x * x - 5 * x - 1), 1e6, 2 / 3, M(R`\frac23`), [M(R`\frac32`), '0', M(R`\infty`)], R`Divide by $x^2$: the limit is the ratio of leading coefficients, $\tfrac23$.`, T.limInf);
checkInf((x) => (2 * x * x - 3 * x + 1) / (3 * x * x - 5 * x - 1), 2 / 3);
Lm(R`Evaluate $\displaystyle\lim_{x\to\infty}\frac{2x-4x^2+1}{x^2-3x+2}$.`, (x) => (2 * x - 4 * x * x + 1) / (x * x - 3 * x + 2), 1e6, -4, '-4', ['4', '2', '-2'], R`The highest powers are $-4x^2$ and $x^2$, so the limit is $\tfrac{-4}{1}=-4$.`, T.limInf);
Lm(R`Evaluate $\displaystyle\lim_{x\to\infty}2x\sin\frac1x$.`, (x) => 2 * x * Math.sin(1 / x), 1e6, 2, '2', ['0', M(R`\infty`), '1'], R`Let $t=\tfrac1x\to0$: $\tfrac{2\sin t}{t}\to2$.`, T.limInf);
Lm(R`Evaluate $\displaystyle\lim_{x\to\infty}\frac{x}{\sqrt{x^2-1}}$.`, (x) => x / Math.sqrt(x * x - 1), 1e6, 1, '1', ['0', M(R`\infty`), '-1'], R`For large $x$, $\sqrt{x^2-1}\approx x$, so the ratio tends to $1$.`, T.limInf);

// ---------------------------------------------------------------- continuity
add(R`The value of $k$ for which $f(x)=\begin{cases}\dfrac{x^2-9}{x-3}, & x\ne 3\\ k, & x=3\end{cases}$ is continuous at $x=3$ is:`, '6', ['3', '0', '9'], R`$\lim_{x\to3}\tfrac{(x-3)(x+3)}{x-3}=6$, so $k=6$.`, T.con);
add(R`The value of $c$ for which $f(x)=\begin{cases}x^2-x, & x\le1\\ c-x, & x>1\end{cases}$ is continuous at $x=1$ is:`, '1', ['0', '2', '-1'], R`Left limit $=1-1=0$; right limit $=c-1$. Setting $c-1=0$ gives $c=1$.`, T.con);
add(R`The value of $k$ for which $f(x)=\begin{cases}\dfrac{\sqrt{x}-1}{x-1}, & x\ne1\\ k, & x=1\end{cases}$ is continuous at $x=1$ is:`, M(R`\frac12`), ['1', '0', '2'], R`$\lim_{x\to1}\tfrac{\sqrt x-1}{x-1}=\tfrac{1}{2\sqrt1}=\tfrac12$.`, T.con);
add(R`The value of $c$ for which $f(x)=\begin{cases}2^{x}, & x\le 3\\ c-x, & x>3\end{cases}$ is continuous at $x=3$ is:`, '11', ['5', '8', '6'], R`$2^3=8$ must equal $c-3$, so $c=11$.`, T.con);
add(R`The value of $k$ for which $f(x)=\begin{cases}\dfrac{x^2-4x+3}{x^2-9}, & x\ne3\\ k, & x=3\end{cases}$ is continuous at $x=3$ is:`, M(R`\frac13`), ['3', '0', M(R`\frac16`)], R`$\tfrac{(x-1)(x-3)}{(x-3)(x+3)}=\tfrac{x-1}{x+3}\to\tfrac{2}{6}=\tfrac13$.`, T.con);
add(R`The value of $k$ for which $f(x)=\begin{cases}\dfrac{|x-3|}{x-3}, & x>3\\ 3k, & x\le3\end{cases}$ is continuous at $x=3$ is:`, M(R`\frac13`), ['1', '3', M(R`\frac19`)], R`For $x>3$ the quotient is $1$, so $3k=1$ and $k=\tfrac13$.`, T.con);
add(R`The interval of continuity of $f(x)=\dfrac{1}{\sqrt{x+10}}$ is:`, M(R`(-10,\infty)`), [M(R`[-10,\infty)`), M(R`(-\infty,-10)`), M(R`\mathbb{R}`)], R`The function needs $x+10>0$.`, T.con);
add(R`The function $f(x)=\begin{cases}x-3, & x\ge3\\ x+3, & x<3\end{cases}$ is discontinuous at:`, M('x=3'), [M('x=0'), M('x=-3'), 'It is continuous everywhere'], R`At $x=3$ the left limit is $6$ but $f(3)=0$: there is a jump.`, T.dis);
add(R`The points at which $y=\dfrac{x^2+x-2}{x^2+x-6}$ is not continuous are:`, M(R`x=-3\ \text{and}\ x=2`), [M(R`x=1\ \text{and}\ x=-2`), M(R`x=3\ \text{and}\ x=-2`), M(R`x=2\ \text{only}`)], R`$x^2+x-6=(x+3)(x-2)=0$ at $x=-3$ and $x=2$.`, T.dis);
add(R`The points at which $y=\dfrac{5+x}{2x-x^2}$ is discontinuous are:`, M(R`x=0\ \text{and}\ x=2`), [M(R`x=2\ \text{only}`), M(R`x=0\ \text{only}`), M(R`x=-2\ \text{and}\ x=0`)], R`$2x-x^2=x(2-x)=0$ at $x=0$ and $x=2$.`, T.dis);
add(R`The function $f(x)=\dfrac{x^2-9}{x-3}$ has, at $x=3$, a discontinuity that is:`, 'Removable', ['A jump discontinuity', 'An infinite (non-removable) discontinuity', 'There is no discontinuity at $x=3$'], R`The limit exists and equals $6$; defining $f(3)=6$ removes the hole.`, T.dis);
add(R`The greatest integer function $f(x)=\lfloor x\rfloor$ has:`, 'A jump discontinuity at every integer', ['A removable discontinuity at every integer', 'No discontinuity', 'A discontinuity only at $x=0$'], R`The value jumps by $1$ as $x$ passes each integer.`, T.dis);

// ---------------------------------------------------------------- differentiation
const D = (stem, f, g, correct, wrongs, expl, topic = T.dif, xs) => { checkD(f, g, xs); add(stem, M(correct), wrongs.map(M), expl, topic); };
D(R`Differentiate $y=(x^2-1)\cos 4x$ with respect to $x$.`, (x) => (x * x - 1) * Math.cos(4 * x), (x) => 2 * x * Math.cos(4 * x) - 4 * (x * x - 1) * Math.sin(4 * x),
  R`2x\cos4x-4(x^2-1)\sin4x`, [R`2x\cos4x+4(x^2-1)\sin4x`, R`-2x\sin4x`, R`2x\cos4x-(x^2-1)\sin4x`], R`Product rule: $2x\cos4x+(x^2-1)(-4\sin4x)$.`);
D(R`Differentiate $y=e^{x}\sin x$.`, (x) => Math.exp(x) * Math.sin(x), (x) => Math.exp(x) * (Math.sin(x) + Math.cos(x)),
  R`e^x(\sin x+\cos x)`, [R`e^x(\sin x-\cos x)`, R`e^x\cos x`, R`-e^x\sin x`], R`Product rule: $e^x\sin x+e^x\cos x$.`);
D(R`Differentiate $y=x^2\ln x$.`, (x) => x * x * Math.log(x), (x) => 2 * x * Math.log(x) + x,
  R`2x\ln x+x`, [R`2x\ln x`, R`2\ln x+x`, R`x+\dfrac1x`], R`Product rule: $2x\ln x+x^2\cdot\tfrac1x=2x\ln x+x$.`);
D(R`Differentiate $y=\sin(x^2+3)$.`, (x) => Math.sin(x * x + 3), (x) => 2 * x * Math.cos(x * x + 3),
  R`2x\cos(x^2+3)`, [R`\cos(x^2+3)`, R`-2x\cos(x^2+3)`, R`2x\sin(x^2+3)`], R`Chain rule: $\cos(x^2+3)\cdot2x$.`);
D(R`Differentiate $y=e^{x^2+2}$.`, (x) => Math.exp(x * x + 2), (x) => 2 * x * Math.exp(x * x + 2),
  R`2xe^{x^2+2}`, [R`(x^2+2)e^{x^2+1}`, R`e^{x^2+2}`, R`2e^{x^2+2}`], R`Chain rule: $e^{x^2+2}\cdot 2x$.`);
D(R`Differentiate $y=(x^3+3x)^{17}$.`, (x) => (x ** 3 + 3 * x) ** 17, (x) => 17 * (3 * x * x + 3) * (x ** 3 + 3 * x) ** 16,
  R`17(3x^2+3)(x^3+3x)^{16}`, [R`17(x^3+3x)^{16}`, R`17(3x^2+3)(x^3+3x)^{17}`, R`(3x^2+3)(x^3+3x)^{16}`], R`Chain rule: $17(x^3+3x)^{16}\cdot(3x^2+3)$.`, T.dif, [0.2, 0.3]);
D(R`Differentiate $y=\ln(1-3x^2)$.`, (x) => Math.log(1 - 3 * x * x), (x) => -6 * x / (1 - 3 * x * x),
  R`\dfrac{-6x}{1-3x^2}`, [R`\dfrac{6x}{1-3x^2}`, R`\dfrac{-3x}{1-3x^2}`, R`\dfrac{1}{1-3x^2}`], R`$\tfrac{d}{dx}\ln u=\tfrac{u'}{u}$ with $u'=-6x$.`);
D(R`Differentiate $y=\ln(2\cos3x+1)$.`, (x) => Math.log(2 * Math.cos(3 * x) + 1), (x) => -6 * Math.sin(3 * x) / (2 * Math.cos(3 * x) + 1),
  R`\dfrac{-6\sin3x}{2\cos3x+1}`, [R`\dfrac{6\sin3x}{2\cos3x+1}`, R`\dfrac{-2\sin3x}{2\cos3x+1}`, R`\dfrac{6\cos3x}{2\cos3x+1}`], R`$u'=-6\sin3x$, so $y'=\tfrac{u'}{u}$.`);
D(R`Differentiate $y=3^{x}$.`, (x) => 3 ** x, (x) => 3 ** x * Math.log(3),
  R`3^x\ln3`, [R`x3^{x-1}`, R`3^x`, R`\dfrac{3^x}{\ln3}`], R`Taking logs, $\ln y=x\ln3$, so $\tfrac{y'}{y}=\ln3$.`);
D(R`Differentiate $y=x^{x}$ for $x>0$.`, (x) => x ** x, (x) => x ** x * (1 + Math.log(x)),
  R`x^x(1+\ln x)`, [R`x\cdot x^{x-1}`, R`x^x\ln x`, R`x^x`], R`Logarithmic differentiation: $\tfrac{y'}{y}=\ln x+1$.`, T.dif, [0.7, 1.3]);
D(R`Differentiate $y=\sin^{-1}(4x)$.`, (x) => Math.asin(4 * x), (x) => 4 / Math.sqrt(1 - 16 * x * x),
  R`\dfrac{4}{\sqrt{1-16x^2}}`, [R`\dfrac{1}{\sqrt{1-16x^2}}`, R`\dfrac{4}{\sqrt{1+16x^2}}`, R`\dfrac{4}{1-16x^2}`], R`$\tfrac{d}{dx}\sin^{-1}u=\tfrac{u'}{\sqrt{1-u^2}}$.`, T.dif, [0.1, 0.2]);
D(R`Differentiate $y=\cos^{-1}(5x+2)$.`, (x) => Math.acos(5 * x + 2), (x) => -5 / Math.sqrt(1 - (5 * x + 2) ** 2),
  R`\dfrac{-5}{\sqrt{1-(5x+2)^2}}`, [R`\dfrac{5}{\sqrt{1-(5x+2)^2}}`, R`\dfrac{-1}{\sqrt{1-(5x+2)^2}}`, R`\dfrac{-5}{1-(5x+2)^2}`], R`$\tfrac{d}{dx}\cos^{-1}u=-\tfrac{u'}{\sqrt{1-u^2}}$.`, T.dif, [-0.35, -0.45]);
D(R`Differentiate $y=\tan^{-1}(2x)$.`, (x) => Math.atan(2 * x), (x) => 2 / (1 + 4 * x * x),
  R`\dfrac{2}{1+4x^2}`, [R`\dfrac{1}{1+4x^2}`, R`\dfrac{2}{1-4x^2}`, R`\dfrac{2x}{1+4x^2}`], R`$\tfrac{d}{dx}\tan^{-1}u=\tfrac{u'}{1+u^2}$.`);
D(R`Differentiate $y=\dfrac{x+1}{x-1}$.`, (x) => (x + 1) / (x - 1), (x) => -2 / ((x - 1) ** 2),
  R`\dfrac{-2}{(x-1)^2}`, [R`\dfrac{2}{(x-1)^2}`, R`\dfrac{-2}{(x+1)^2}`, R`\dfrac{2x}{(x-1)^2}`], R`Quotient rule: $\tfrac{(x-1)-(x+1)}{(x-1)^2}$.`);
D(R`Differentiate $y=\dfrac{2-x}{x^2}$.`, (x) => (2 - x) / (x * x), (x) => (x - 4) / (x ** 3),
  R`\dfrac{x-4}{x^3}`, [R`\dfrac{4-x}{x^3}`, R`\dfrac{x+4}{x^3}`, R`\dfrac{-1}{x^2}`], R`Write $y=2x^{-2}-x^{-1}$, so $y'=-4x^{-3}+x^{-2}=\tfrac{x-4}{x^3}$.`);
D(R`Differentiate $y=\tan(x^2)$.`, (x) => Math.tan(x * x), (x) => 2 * x / (Math.cos(x * x) ** 2),
  R`2x\sec^2(x^2)`, [R`\sec^2(x^2)`, R`2\tan x\sec^2x`, R`2x\sec^2x`], R`Chain rule: $\sec^2(x^2)\cdot2x$.`);
D(R`Differentiate $y=e^{-2x}\cos3x$.`, (x) => Math.exp(-2 * x) * Math.cos(3 * x), (x) => Math.exp(-2 * x) * (-2 * Math.cos(3 * x) - 3 * Math.sin(3 * x)),
  R`e^{-2x}(-2\cos3x-3\sin3x)`, [R`e^{-2x}(-2\cos3x+3\sin3x)`, R`e^{-2x}(2\cos3x-3\sin3x)`, R`-2e^{-2x}\cos3x`], R`Product rule: $-2e^{-2x}\cos3x+e^{-2x}(-3\sin3x)$.`);
add(R`If $y=\sin 2x$, then $\dfrac{d^2y}{dx^2}$ is:`, M(R`-4\sin2x`), [M(R`-2\sin2x`), M(R`4\sin2x`), M(R`-4\cos2x`)], R`$y'=2\cos2x$ and $y''=-4\sin2x$.`, 'Higher Order Derivatives');

// parametric and implicit differentiation (points checked by hand-written arithmetic)
add(R`If $x=t^2-1$ and $y=t^2+t$, then $\dfrac{dy}{dx}$ is:`, M(R`1+\frac{1}{2t}`), [M(R`2t+1`), M(R`\frac{2t}{2t+1}`), M(R`1+\frac1t`)], R`$\tfrac{dy}{dt}=2t+1$ and $\tfrac{dx}{dt}=2t$, so $\tfrac{dy}{dx}=\tfrac{2t+1}{2t}$.`, T.par);
add(R`If $x=2\cos t$ and $y=2\sin t$, then $\dfrac{dy}{dx}$ at $t=\dfrac\pi3$ is:`, M(R`-\frac{1}{\sqrt3}`), [M(R`-\sqrt3`), M(R`\frac{1}{\sqrt3}`), M(R`\sqrt3`)], R`$\tfrac{dy}{dx}=\tfrac{2\cos t}{-2\sin t}=-\cot t$, and $\cot\tfrac\pi3=\tfrac1{\sqrt3}$.`, T.par);
chk(-1 / Math.tan(Math.PI / 3), -1 / Math.sqrt(3));
add(R`If $x^2-xy+y^2=7$ defines $y$ as a function of $x$, then $\dfrac{dy}{dx}$ is:`, M(R`\frac{y-2x}{2y-x}`), [M(R`\frac{2x-y}{2y-x}`), M(R`\frac{y-2x}{2y+x}`), M(R`\frac{y+2x}{2y-x}`)], R`Differentiating: $2x-y-x y'+2yy'=0$, so $y'(2y-x)=y-2x$.`, T.par);
add(R`If $x^3+y^3-3xy=0$, then $\dfrac{dy}{dx}$ is:`, M(R`\frac{y-x^2}{y^2-x}`), [M(R`\frac{x^2-y}{y^2-x}`), M(R`\frac{y+x^2}{y^2-x}`), M(R`\frac{y-x^2}{y^2+x}`)], R`$3x^2+3y^2y'-3y-3xy'=0\Rightarrow y'(y^2-x)=y-x^2$.`, T.par);
add(R`If $y^2-3x^2y+6y=0$, then $\dfrac{dy}{dx}$ is:`, M(R`\frac{6xy}{2y-3x^2+6}`), [M(R`\frac{6xy}{2y+3x^2+6}`), M(R`\frac{3x^2}{2y+6}`), M(R`\frac{6xy}{2x-3x^2}`)], R`$2yy'-6xy-3x^2y'+6y'=0\Rightarrow y'(2y-3x^2+6)=6xy$.`, T.par);
add(R`If $x+\sin y+2=0$ defines $y$ as a function of $x$, then $\dfrac{dy}{dx}$ is:`, M(R`-\frac{1}{\cos y}`), [M(R`\frac{1}{\cos y}`), M(R`-\frac{1}{\sin y}`), M(R`\cos y`)], R`$1+\cos y\,y'=0\Rightarrow y'=-\tfrac{1}{\cos y}$.`, T.par);

// ---------------------------------------------------------------- turning points, tangents, normals, rates
add(R`The critical points of $y=2x^3+3x^2-12x+7$ are:`, M(R`x=1\ \text{and}\ x=-2`), [M(R`x=1\ \text{and}\ x=2`), M(R`x=-1\ \text{and}\ x=2`), M(R`x=-1\ \text{and}\ x=-2`)], R`$y'=6x^2+6x-12=6(x-1)(x+2)=0$.`, T.tp);
add(R`The function $y=x^3-2x^2-4x+4$ has a local maximum at:`, M(R`x=-\frac23`), [M('x=2'), M('x=-2'), M(R`x=\frac23`)], R`$y'=(3x+2)(x-2)=0$; $y''=6x-4$ is negative at $x=-\tfrac23$ and positive at $x=2$.`, T.tp);
add(R`The curve $y=4x^3-5x^2+1$ has:`, M(R`\text{a maximum at }x=0\text{ and a minimum at }x=\tfrac56`), [M(R`\text{a minimum at }x=0\text{ and a maximum at }x=\tfrac56`), M(R`\text{a maximum at }x=0\text{ and no other turning point}`), M(R`\text{no turning point}`)], R`$y'=2x(6x-5)$; $y''=24x-10$ is $-10$ at $0$ and $10$ at $\tfrac56$.`, T.tp);
add(R`The relative maximum value of $f(x)=2x^3-3x^2-12x+24$ is:`, '31', ['4', '8', '24'], R`$f'(x)=6(x-2)(x+1)$; $f''(-1)<0$, so the maximum is $f(-1)=-2-3+12+24=31$.`, T.tp);
chk(2 * (-1) ** 3 - 3 * 1 + 12 + 24, 31);
add(R`The absolute minimum of $y=2x-x^2$ on the interval $[0,5]$ is:`, '-15', ['0', '1', '-3'], R`The critical point $x=1$ gives a maximum of $1$; the endpoints give $0$ and $-15$, so the minimum is $-15$.`, T.tp);
chk(2 * 5 - 25, -15);
add(R`The point of inflexion of $y=x^3+6x^2+12x-8$ occurs at:`, M('x=-2'), [M('x=2'), M('x=-1'), M('x=0')], R`$y''=6x+12=0$ at $x=-2$, and $y''$ changes sign there.`, T.tp);
add(R`The sum of two positive numbers is $A$. The maximum value of their product is:`, M(R`\frac{A^2}{4}`), [M(R`\frac{A^2}{2}`), M(R`\frac{A^2}{3}`), M('A^2')], R`With numbers $x$ and $A-x$, $P=x(A-x)$ is largest at $x=\tfrac A2$, giving $\tfrac{A^2}{4}$.`, T.tp);
add(R`The equation of the tangent to the curve $y=x^2-4$ at the point $(3,5)$ is:`, M('y=6x-13'), [M('y=6x+13'), M('y=3x-4'), M('y=2x-1')], R`The slope is $2x=6$, so $y-5=6(x-3)$.`, T.tn);
add(R`The equation of the normal to the curve $x^2+y^2=20$ at $(4,2)$ is:`, M('2y-x=0'), [M('2y+x=8'), M('y-2x=0'), M('x+2y=0')], R`The tangent slope is $-\tfrac xy=-2$, so the normal slope is $\tfrac12$: $y-2=\tfrac12(x-4)$, i.e. $2y=x$.`, T.tn);
add(R`The equation of the tangent to $y=1-x^2$ at $x=2$ is:`, M('y+4x=5'), [M('y-4x=5'), M('y+4x=-5'), M('y+2x=1')], R`The point is $(2,-3)$ and the slope is $-2x=-4$: $y+3=-4(x-2)$.`, T.tn);
add(R`The equation of the tangent to $y=x^2-x+1$ at $x=1$ is:`, M('y=x'), [M('y=2x-1'), M('y=-x+2'), M('y=x+1')], R`The point is $(1,1)$ and the slope is $2x-1=1$.`, T.tn);
add(R`The displacement of a particle is $S(t)=-16t^2+50t+400$. Its velocity at $t=2$ is:`, '-14', ['14', '-78', '50'], R`$v=S'(t)=-32t+50$, so $v(2)=-14$.`, T.rc);
chk(-32 * 2 + 50, -14);
add(R`A particle moves according to $s=t^3-6t^2+9t$. Its acceleration at $t=3$ is:`, '6', ['9', '0', '18'], R`$a=\tfrac{d^2s}{dt^2}=6t-12$, and at $t=3$ it equals $6$.`, T.rc);

// ---------------------------------------------------------------- integration
add(R`$\displaystyle\int\frac{x^2+3}{x}\,dx$ is:`, M(R`\frac{x^2}{2}+3\ln x+c`), [M(R`x^2+3\ln x+c`), M(R`\frac{x^2}{2}-\frac{3}{x^2}+c`), M(R`1-\frac{3}{x^2}+c`)], R`Split: $\int\left(x+\tfrac3x\right)dx$.`, T.ap);
add(R`$\displaystyle\int\frac{x^2+1}{x^2}\,dx$ is:`, M(R`x-\frac1x+c`), [M(R`x+\frac1x+c`), M(R`x+\ln x^2+c`), M(R`x-\frac1{x^2}+c`)], R`Split: $\int(1+x^{-2})dx=x-x^{-1}+c$.`, T.ap);
add(R`The anti-derivative of $3x^2+4$ which has the value $-2$ at $x=1$ is:`, M('x^3+4x-7'), [M('x^3+4x-2'), M('x^3+4x+3'), M('6x-8')], R`$x^3+4x+c$ at $x=1$ gives $5+c=-2$, so $c=-7$.`, T.ap);
add(R`The anti-derivative of $2e^{3x}$ which has the value $1$ at $x=0$ is:`, M(R`\frac13\left(2e^{3x}+1\right)`), [M(R`\frac23e^{3x}+1`), M(R`\frac23e^{3x}-\frac13`), M(R`6e^{3x}-5`)], R`$\tfrac23e^{3x}+c$ at $x=0$: $\tfrac23+c=1$, so $c=\tfrac13$.`, T.ap);
add(R`$\displaystyle\int\frac{3}{\sqrt x}\,dx$ is:`, M(R`6\sqrt x+c`), [M(R`3\sqrt x+c`), M(R`\tfrac32\sqrt x+c`), M(R`\frac{6}{\sqrt x}+c`)], R`$\int3x^{-1/2}dx=3\cdot2x^{1/2}+c$.`, T.ap);
add(R`$\displaystyle\int(4x-7)^3\,dx$ is:`, M(R`\frac{(4x-7)^4}{16}+c`), [M(R`\frac{(4x-7)^4}{4}+c`), M(R`\frac{(4x-7)^4}{12}+c`), M(R`12(4x-7)^2+c`)], R`Put $u=4x-7$: $\tfrac14\int u^3du=\tfrac{u^4}{16}$.`, T.int);
add(R`$\displaystyle\int\cos 3x\,dx$ is:`, M(R`\frac{\sin3x}{3}+c`), [M(R`3\sin3x+c`), M(R`-\frac{\sin3x}{3}+c`), M(R`\sin3x+c`)], R`Put $u=3x$, so $dx=\tfrac{du}{3}$.`, T.int);
{
  const f = (x) => x * Math.sqrt(1 + x * x); chk(simpson(f, 0, 1), (2 * Math.sqrt(2) - 1) / 3, 1e-6);
  add(R`Evaluate $\displaystyle\int_0^1 x\sqrt{1+x^2}\,dx$.`, M(R`\frac{2\sqrt2-1}{3}`), [M(R`\frac{2\sqrt2-1}{6}`), M(R`\frac{2\sqrt2}{3}`), M(R`\frac{\sqrt2-1}{3}`)], R`Put $u=1+x^2$: $\tfrac12\int_1^2\sqrt u\,du=\tfrac13\left(2^{3/2}-1\right)$.`, T.int);
}
add(R`$\displaystyle\int\frac{2x}{x^2+1}\,dx$ is:`, M(R`\ln(x^2+1)+c`), [M(R`\tfrac12\ln(x^2+1)+c`), M(R`2\ln(x^2+1)+c`), M(R`\frac{x^2}{x^2+1}+c`)], R`The numerator is the derivative of the denominator, so the integral is $\ln(x^2+1)$.`, T.int);
{
  chk(simpson((x) => 1 / (x + 5), -4, 2), Math.log(7), 1e-6);
  add(R`Evaluate $\displaystyle\int_{-4}^{2}\frac{1}{x+5}\,dx$.`, M(R`\ln 7`), [M(R`\ln 7-\ln 9`), M(R`\ln 6`), M(R`\frac{50}{49}`)], R`$\left[\ln(x+5)\right]_{-4}^{2}=\ln7-\ln1=\ln7$.`, T.int);
}
add(R`$\displaystyle\int\sin x\cos^3x\,dx$ is:`, M(R`-\frac{\cos^4x}{4}+c`), [M(R`\frac{\cos^4x}{4}+c`), M(R`\frac{\sin^4x}{4}+c`), M(R`-\frac{\sin^4x}{4}+c`)], R`Put $u=\cos x$, $du=-\sin x\,dx$.`, T.int);
add(R`$\displaystyle\int\cos^2x\,dx$ is:`, M(R`\frac x2+\frac{\sin2x}{4}+c`), [M(R`\frac x2-\frac{\sin2x}{4}+c`), M(R`\frac x2+\frac{\sin2x}{2}+c`), M(R`\frac{\cos^3x}{3}+c`)], R`$\cos^2x=\tfrac12(1+\cos2x)$.`, T.int);
add(R`$\displaystyle\int\frac{\sin(\ln x)}{x}\,dx$ is:`, M(R`-\cos(\ln x)+c`), [M(R`\cos(\ln x)+c`), M(R`\sin(\ln x)+c`), M(R`\frac{\cos(\ln x)}{x}+c`)], R`Put $u=\ln x$, $du=\tfrac{dx}{x}$.`, T.int);
add(R`$\displaystyle\int x e^{x}\,dx$ is:`, M(R`(x-1)e^x+c`), [M(R`(x+1)e^x+c`), M(R`\frac{x^2}{2}e^x+c`), M(R`e^x+c`)], R`Integration by parts with $u=x$, $dv=e^xdx$ gives $xe^x-e^x$.`, 'Integration by Parts');
{
  chk(simpson((x) => x * x, 0, 3), 9, 1e-6);
  add(R`The area bounded by $y=x^2$, the $x$-axis and the lines $x=0$ and $x=3$ is:`, '9 square units', ['27 square units', '3 square units', '18 square units'], R`$\int_0^3x^2dx=\tfrac{27}{3}=9$.`, 'Areas of Plane Regions');
  add(R`The volume obtained by rotating the region under $y=x$ from $x=0$ to $x=3$ about the $x$-axis is:`, M(R`9\pi`), [M(R`27\pi`), M(R`3\pi`), M(R`\frac{9\pi}{2}`)], R`$V=\pi\int_0^3x^2dx=\pi\cdot9$.`, 'The Disc Method');
}
add(R`$\displaystyle\int\frac{dx}{(x-1)(x+1)}$ is:`, M(R`\frac12\ln\left|\frac{x-1}{x+1}\right|+c`), [M(R`\frac12\ln\left|\frac{x+1}{x-1}\right|+c`), M(R`\ln|x^2-1|+c`), M(R`\ln|x-1|+\ln|x+1|+c`)], R`$\tfrac{1}{(x-1)(x+1)}=\tfrac12\left(\tfrac1{x-1}-\tfrac1{x+1}\right)$.`, 'Method of Partial Fractions');

module.exports = out;
