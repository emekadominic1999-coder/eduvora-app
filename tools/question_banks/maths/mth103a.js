// MTH 103 (Calculus) - hand-set questions, part A: differentiation, limits, applications.
// Every differentiation answer is checked numerically at load time.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = {
  rules: 'Rules of Differentiation', chain: 'The Chain Rule', impl: 'Implicit Differentiation', hi: 'Higher Order Derivatives', par: 'Derivatives of Functions Expressed Parametrically',
  lim: 'Limits of Polynomial and Rational Functions', lhop: 'Indeterminate Forms and L\'Hopital\'s Rule', limInf: 'Limit at Infinity', ext: 'Extrema of a Function', con: 'Concavity and Points of Inflection',
  rel: 'Related Rates', opt: 'Maxima and Minima', lin: 'Linear Approximation and Differentials', mvt: 'Rolle\'s Theorem and the Mean Value Theorem', vel: 'Velocity and Acceleration', asy: 'Asymptotes of a Curve',
  tang: 'Tangents and Normals', riem: 'Areas and Riemann Sums',
};
const num = (f, x) => (f(x + 1e-5) - f(x - 1e-5)) / 2e-5;
const near = (a, b, tol = 1e-4) => Math.abs(a - b) <= tol * Math.max(1, Math.abs(b));
function D(topic, fnTex, f, g, correct, wrongs, expl, stem) {
  for (const x of [0.6, 1.1, 1.7, 2.3]) if (!near(num(f, x), g(x))) throw new Error('derivative check failed for ' + fnTex);
  add(stem || R`Differentiate $y = ${fnTex}$ with respect to $x$.`, '$' + correct + '$', wrongs.map((w) => '$' + w + '$'), expl, topic);
}

// ------------------------------------------------------------- products, quotients, chains
D(T.rules, R`x^3e^{2x}`, (x) => x ** 3 * Math.exp(2 * x), (x) => Math.exp(2 * x) * (2 * x ** 3 + 3 * x ** 2),
  R`x^2e^{2x}(2x+3)`, [R`x^2e^{2x}(x+3)`, R`x^2e^{2x}(2x-3)`, R`6x^2e^{2x}`],
  R`By the product rule $y' = 3x^2e^{2x} + x^3\cdot 2e^{2x} = x^2e^{2x}(2x+3)$.`);
D(T.rules, R`x^2\ln(3x)`, (x) => x * x * Math.log(3 * x), (x) => 2 * x * Math.log(3 * x) + x,
  R`2x\ln(3x)+x`, [R`2x\ln(3x)`, R`2x\ln(3x)+\dfrac{1}{3}`, R`\dfrac{x^2}{3x}`],
  R`Product rule: $y' = 2x\ln(3x) + x^2\cdot\dfrac{1}{x} = 2x\ln(3x)+x$.`);
D(T.rules, R`\dfrac{x^2+1}{x^2-1}`, (x) => (x * x + 1) / (x * x - 1), (x) => -4 * x / (x * x - 1) ** 2,
  R`-\dfrac{4x}{(x^2-1)^2}`, [R`\dfrac{4x}{(x^2-1)^2}`, R`\dfrac{2x}{x^2-1}`, R`-\dfrac{2x}{(x^2-1)^2}`],
  R`Quotient rule: $y' = \dfrac{2x(x^2-1) - 2x(x^2+1)}{(x^2-1)^2} = -\dfrac{4x}{(x^2-1)^2}$.`);
D(T.rules, R`\dfrac{e^x}{x^2+1}`, (x) => Math.exp(x) / (x * x + 1), (x) => Math.exp(x) * (x - 1) ** 2 / (x * x + 1) ** 2,
  R`\dfrac{e^x(x-1)^2}{(x^2+1)^2}`, [R`\dfrac{e^x(x+1)^2}{(x^2+1)^2}`, R`\dfrac{e^x}{2x}`, R`\dfrac{e^x(x^2+1+2x)}{(x^2+1)^2}`],
  R`$y' = \dfrac{e^x(x^2+1) - 2xe^x}{(x^2+1)^2} = \dfrac{e^x(x-1)^2}{(x^2+1)^2}$.`);
D(T.chain, R`\sin^3(2x)`, (x) => Math.sin(2 * x) ** 3, (x) => 6 * Math.sin(2 * x) ** 2 * Math.cos(2 * x),
  R`6\sin^2(2x)\cos(2x)`, [R`3\sin^2(2x)\cos(2x)`, R`6\sin^2(2x)`, R`3\sin^2(2x)`],
  R`Chain rule twice: $y' = 3\sin^2(2x)\cdot\cos(2x)\cdot 2$.`);
D(T.chain, R`e^x\cos 3x`, (x) => Math.exp(x) * Math.cos(3 * x), (x) => Math.exp(x) * (Math.cos(3 * x) - 3 * Math.sin(3 * x)),
  R`e^x(\cos 3x-3\sin 3x)`, [R`e^x(\cos 3x+3\sin 3x)`, R`e^x(\cos 3x-\sin 3x)`, R`-3e^x\sin 3x`],
  R`$y' = e^x\cos 3x + e^x(-3\sin 3x)$.`);
D(T.chain, R`\tan^{-1}(x^2)`, (x) => Math.atan(x * x), (x) => 2 * x / (1 + x ** 4),
  R`\dfrac{2x}{1+x^4}`, [R`\dfrac{1}{1+x^4}`, R`\dfrac{2x}{1+x^2}`, R`\dfrac{2x}{\sqrt{1-x^4}}`],
  R`$\dfrac{d}{dx}\tan^{-1}u = \dfrac{u'}{1+u^2}$ with $u = x^2$.`);
D(T.chain, R`\ln(\sin x)`, (x) => Math.log(Math.sin(x)), (x) => Math.cos(x) / Math.sin(x),
  R`\cot x`, [R`\tan x`, R`\dfrac{1}{\sin x}`, R`-\cot x`], R`$y' = \dfrac{\cos x}{\sin x} = \cot x$.`);
D(T.chain, R`e^{\sqrt{x}}`, (x) => Math.exp(Math.sqrt(x)), (x) => Math.exp(Math.sqrt(x)) / (2 * Math.sqrt(x)),
  R`\dfrac{e^{\sqrt{x}}}{2\sqrt{x}}`, [R`e^{\sqrt{x}}`, R`\dfrac{e^{\sqrt{x}}}{\sqrt{x}}`, R`\dfrac{\sqrt{x}\,e^{\sqrt{x}}}{2}`],
  R`$y' = e^{\sqrt{x}}\cdot\dfrac{1}{2\sqrt{x}}$.`);
D(T.chain, R`\sin^{-1}(3x)`, (x) => Math.asin(3 * x / 10), (x) => (3 / 10) / Math.sqrt(1 - 9 * x * x / 100),
  R`\dfrac{3}{\sqrt{1-9x^2}}`, [R`\dfrac{1}{\sqrt{1-9x^2}}`, R`\dfrac{3}{1-9x^2}`, R`\dfrac{3}{\sqrt{1+9x^2}}`],
  R`$\dfrac{d}{dx}\sin^{-1}u = \dfrac{u'}{\sqrt{1-u^2}}$ with $u = 3x$.`, null) || 0;
D(T.chain, R`\ln\left(x+\sqrt{x^2+1}\right)`, (x) => Math.log(x + Math.sqrt(x * x + 1)), (x) => 1 / Math.sqrt(x * x + 1),
  R`\dfrac{1}{\sqrt{x^2+1}}`, [R`\dfrac{1}{x+\sqrt{x^2+1}}`, R`\dfrac{x}{\sqrt{x^2+1}}`, R`\dfrac{2x}{x^2+1}`],
  R`The derivative simplifies: $\dfrac{1+x/\sqrt{x^2+1}}{x+\sqrt{x^2+1}} = \dfrac{1}{\sqrt{x^2+1}}$.`);
D(T.chain, R`\dfrac{x}{\sqrt{1+x^2}}`, (x) => x / Math.sqrt(1 + x * x), (x) => (1 + x * x) ** -1.5,
  R`\dfrac{1}{(1+x^2)^{3/2}}`, [R`\dfrac{1}{\sqrt{1+x^2}}`, R`\dfrac{1-x^2}{(1+x^2)^{3/2}}`, R`\dfrac{2x}{(1+x^2)^{3/2}}`],
  R`Quotient rule: $y' = \dfrac{\sqrt{1+x^2} - x^2/\sqrt{1+x^2}}{1+x^2} = (1+x^2)^{-3/2}$.`);
D(T.chain, R`(3x+1)^5(x-2)^3`, (x) => (3 * x + 1) ** 5 * (x - 2) ** 3, (x) => 3 * (3 * x + 1) ** 4 * (x - 2) ** 2 * (8 * x - 9),
  R`3(3x+1)^4(x-2)^2(8x-9)`, [R`15(3x+1)^4\cdot 3(x-2)^2`, R`3(3x+1)^4(x-2)^2(8x+9)`, R`(3x+1)^4(x-2)^2(24x-27)+1`],
  R`$y' = 15(3x+1)^4(x-2)^3 + 3(3x+1)^5(x-2)^2 = 3(3x+1)^4(x-2)^2[5(x-2)+(3x+1)] = 3(3x+1)^4(x-2)^2(8x-9)$.`);
D(T.chain, R`\sqrt{\sin x}`, (x) => Math.sqrt(Math.sin(x)), (x) => Math.cos(x) / (2 * Math.sqrt(Math.sin(x))),
  R`\dfrac{\cos x}{2\sqrt{\sin x}}`, [R`\dfrac{1}{2\sqrt{\sin x}}`, R`\dfrac{\cos x}{\sqrt{\sin x}}`, R`-\dfrac{\cos x}{2\sqrt{\sin x}}`],
  R`$y' = \dfrac{1}{2\sqrt{\sin x}}\cdot\cos x$.`);
D(T.chain, R`\sec(3x)`, (x) => 1 / Math.cos(3 * x), (x) => 3 * Math.tan(3 * x) / Math.cos(3 * x),
  R`3\sec(3x)\tan(3x)`, [R`\sec(3x)\tan(3x)`, R`3\sec^2(3x)`, R`-3\sec(3x)\tan(3x)`],
  R`$\dfrac{d}{dx}\sec u = u'\sec u\tan u$, with $u = 3x$.`);
D(T.rules, R`(\ln x)^2`, (x) => Math.log(x) ** 2, (x) => 2 * Math.log(x) / x,
  R`\dfrac{2\ln x}{x}`, [R`\dfrac{2}{x}`, R`2\ln x`, R`\dfrac{\ln x}{x}`], R`Chain rule: $y' = 2\ln x\cdot\dfrac{1}{x}$.`);
D(T.rules, R`x\,2^x`, (x) => x * 2 ** x, (x) => 2 ** x * (1 + x * Math.LN2),
  R`2^x(1+x\ln 2)`, [R`2^x(1+x)`, R`x\,2^{x-1}`, R`2^x\ln 2`], R`Product rule with $\dfrac{d}{dx}2^x = 2^x\ln 2$: $y' = 2^x + x2^x\ln 2$.`);
D(T.rules, R`x^x`, (x) => x ** x, (x) => x ** x * (1 + Math.log(x)),
  R`x^x(1+\ln x)`, [R`x\cdot x^{x-1}`, R`x^x\ln x`, R`x^{x}(x+\ln x)`],
  R`Take logarithms: $\ln y = x\ln x$, so $\dfrac{y'}{y} = \ln x + 1$.`);
D(T.rules, R`\dfrac{x}{e^x}`, (x) => x * Math.exp(-x), (x) => (1 - x) * Math.exp(-x),
  R`(1-x)e^{-x}`, [R`(1+x)e^{-x}`, R`e^{-x}`, R`-xe^{-x}`], R`$y = xe^{-x}$, so $y' = e^{-x} - xe^{-x} = (1-x)e^{-x}$.`);
D(T.rules, R`\cosh(x^2)`, (x) => Math.cosh(x * x), (x) => 2 * x * Math.sinh(x * x),
  R`2x\sinh(x^2)`, [R`\sinh(x^2)`, R`2x\cosh(x^2)`, R`-2x\sinh(x^2)`], R`$\dfrac{d}{dx}\cosh u = u'\sinh u$.`);
D(T.rules, R`\tan x\sec x`, (x) => Math.tan(x) / Math.cos(x), (x) => (1 / Math.cos(x)) ** 3 + Math.tan(x) ** 2 / Math.cos(x),
  R`\sec^3x+\sec x\tan^2x`, [R`\sec^2x\tan x`, R`\sec^3x-\sec x\tan^2x`, R`\sec^2x+\sec x\tan x`],
  R`Product rule: $y' = \sec^2x\cdot\sec x + \tan x\cdot\sec x\tan x$.`);
D(T.rules, R`\dfrac{\ln x}{x^2}`, (x) => Math.log(x) / (x * x), (x) => (1 - 2 * Math.log(x)) / x ** 3,
  R`\dfrac{1-2\ln x}{x^3}`, [R`\dfrac{1-\ln x}{x^3}`, R`\dfrac{2\ln x-1}{x^3}`, R`\dfrac{1}{x^3}`],
  R`$y' = \dfrac{\frac{1}{x}\cdot x^2 - 2x\ln x}{x^4} = \dfrac{x - 2x\ln x}{x^4} = \dfrac{1-2\ln x}{x^3}$.`);

// ------------------------------------------------------------- higher order and parametric
add(R`If $y = e^{2x}\sin x$, then $\dfrac{d^2y}{dx^2}$ is:`, R`$e^{2x}(3\sin x+4\cos x)$`, [R`$e^{2x}(3\sin x-4\cos x)$`, R`$e^{2x}(4\sin x+\cos x)$`, R`$-e^{2x}\sin x$`], R`$y' = e^{2x}(2\sin x+\cos x)$ and $y'' = e^{2x}(4\sin x+2\cos x+2\cos x-\sin x) = e^{2x}(3\sin x+4\cos x)$.`, T.hi);
add(R`If $y = \ln(1+x^2)$, then $\dfrac{d^2y}{dx^2}$ at $x = 1$ is:`, R`$0$`, [R`$1$`, R`$-1$`, R`$\dfrac{1}{2}$`], R`$y' = \dfrac{2x}{1+x^2}$ and $y'' = \dfrac{2(1-x^2)}{(1+x^2)^2}$, which is $0$ at $x = 1$.`, T.hi);
add(R`The $n$th derivative of $y = e^{3x}$ is:`, R`$3^ne^{3x}$`, [R`$3ne^{3x}$`, R`$e^{3x}$`, R`$n!\,e^{3x}$`], R`Each differentiation multiplies by 3, so $y^{(n)} = 3^ne^{3x}$.`, T.hi);
add(R`If $x = t^2$ and $y = t^3$, then $\dfrac{dy}{dx}$ at $t = 2$ is:`, R`$3$`, [R`$12$`, R`$\dfrac{3}{2}$`, R`$6$`], R`$\dfrac{dy}{dx} = \dfrac{3t^2}{2t} = \dfrac{3t}{2}$, which equals $3$ at $t = 2$.`, T.par);
add(R`If $x = t^2$ and $y = t^3$, then $\dfrac{d^2y}{dx^2}$ at $t = 2$ is:`, R`$\dfrac{3}{8}$`, [R`$\dfrac{3}{2}$`, R`$\dfrac{3}{4}$`, R`$\dfrac{3}{16}$`], R`$\dfrac{d}{dt}\left(\dfrac{3t}{2}\right) = \dfrac{3}{2}$, divided by $\dfrac{dx}{dt} = 2t = 4$ gives $\dfrac{3}{8}$.`, T.par);
add(R`A curve is given by $x = a\cos^3\theta$ and $y = a\sin^3\theta$. Then $\dfrac{dy}{dx}$ is:`, R`$-\tan\theta$`, [R`$\tan\theta$`, R`$-\cot\theta$`, R`$-\tan^2\theta$`], R`$\dfrac{dy}{dx} = \dfrac{3a\sin^2\theta\cos\theta}{-3a\cos^2\theta\sin\theta} = -\tan\theta$.`, T.par);

// ------------------------------------------------------------- implicit differentiation and tangents
add(R`For the circle $x^2+y^2=25$, the gradient of the tangent at $(3, 4)$ is:`, R`$-\dfrac{3}{4}$`, [R`$\dfrac{3}{4}$`, R`$-\dfrac{4}{3}$`, R`$\dfrac{4}{3}$`], R`Differentiating, $2x+2yy' = 0$, so $y' = -\dfrac{x}{y} = -\dfrac{3}{4}$.`, T.impl);
add(R`For the curve $x^3+y^3=6xy$, the value of $\dfrac{dy}{dx}$ at the point $\left(\dfrac{3}{2},\dfrac{3}{2}\right)$ is:`, R`$-1$`, [R`$1$`, R`$0$`, R`$-\dfrac{1}{2}$`], R`Differentiating, $3x^2+3y^2y' = 6y+6xy'$, so $y' = \dfrac{2y-x^2}{y^2-2x}$. At $\left(\frac32,\frac32\right)$: $\dfrac{3-\frac94}{\frac94-3} = -1$.`, T.impl);
add(R`For the curve $xy+\ln y = 1$, the gradient at the point $(1, 1)$ is:`, R`$-\dfrac{1}{2}$`, [R`$-1$`, R`$\dfrac{1}{2}$`, R`$-2$`], R`Differentiating, $y+xy'+\dfrac{y'}{y} = 0$. At $(1,1)$: $1+y'+y' = 0$, so $y' = -\dfrac{1}{2}$.`, T.impl);
add(R`The tangent to the ellipse $\dfrac{x^2}{9}+\dfrac{y^2}{4}=1$ at the point $\left(\dfrac{3}{\sqrt2},\sqrt2\right)$ has gradient:`, R`$-\dfrac{2}{3}$`, [R`$\dfrac{2}{3}$`, R`$-\dfrac{3}{2}$`, R`$-\dfrac{4}{9}$`], R`$\dfrac{2x}{9}+\dfrac{yy'}{2} = 0$ gives $y' = -\dfrac{4x}{9y} = -\dfrac{4\cdot 3/\sqrt2}{9\sqrt2} = -\dfrac{2}{3}$.`, T.impl);
add(R`The equation of the tangent to $y = x^3-3x+1$ at the point where $x = 2$ is:`, R`$y = 9x-15$`, [R`$y = 9x+3$`, R`$y = 3x-3$`, R`$y = 9x-17$`], R`At $x=2$, $y = 3$ and $y' = 3x^2-3 = 9$. Tangent: $y-3 = 9(x-2)$, i.e. $y = 9x-15$.`, T.tang);
add(R`The normal to the curve $y = \ln x$ at the point $(1, 0)$ has equation:`, R`$y = 1-x$`, [R`$y = x-1$`, R`$y = -x$`, R`$y = 1+x$`], R`$y' = \dfrac1x = 1$ at $x=1$, so the normal has gradient $-1$: $y-0 = -(x-1)$, i.e. $y = 1-x$.`, T.tang);
add(R`At what point on the curve $y = x^2-4x+7$ is the tangent parallel to the line $y = 2x+1$?`, R`$(3, 4)$`, [R`$(2, 3)$`, R`$(3, 7)$`, R`$(1, 4)$`], R`$y' = 2x-4 = 2$ gives $x = 3$, and $y = 9-12+7 = 4$.`, T.tang);

// ------------------------------------------------------------- limits
add(R`Evaluate $\displaystyle\lim_{x\to0}\dfrac{e^x-1-x}{x^2}$.`, R`$\dfrac{1}{2}$`, [R`$0$`, R`$1$`, R`$2$`], R`Apply L'Hôpital's rule twice: $\dfrac{e^x-1}{2x}\to\dfrac{e^x}{2} = \dfrac{1}{2}$.`, T.lhop);
add(R`Evaluate $\displaystyle\lim_{x\to0}\dfrac{x-\sin x}{x^3}$.`, R`$\dfrac{1}{6}$`, [R`$\dfrac{1}{3}$`, R`$0$`, R`$\dfrac{1}{2}$`], R`Three applications of L'Hôpital's rule: $\dfrac{1-\cos x}{3x^2}\to\dfrac{\sin x}{6x}\to\dfrac{\cos x}{6} = \dfrac{1}{6}$.`, T.lhop);
add(R`Evaluate $\displaystyle\lim_{x\to0}\dfrac{\tan x-x}{x^3}$.`, R`$\dfrac{1}{3}$`, [R`$\dfrac{1}{6}$`, R`$0$`, R`$1$`], R`$\dfrac{\sec^2x-1}{3x^2} = \dfrac{\tan^2x}{3x^2}\to\dfrac{1}{3}$.`, T.lhop);
add(R`Evaluate $\displaystyle\lim_{x\to0^+}x\ln x$.`, R`$0$`, [R`$-\infty$`, R`$1$`, R`$-1$`], R`Write it as $\dfrac{\ln x}{1/x}$ and apply L'Hôpital's rule: $\dfrac{1/x}{-1/x^2} = -x\to0$.`, T.lhop);
add(R`Evaluate $\displaystyle\lim_{x\to\infty}\left(1+\dfrac{3}{x}\right)^x$.`, R`$e^3$`, [R`$e$`, R`$3$`, R`$1$`], R`$\ln L = \lim x\ln\left(1+\frac3x\right) = 3$, so $L = e^3$.`, T.lhop);
add(R`Evaluate $\displaystyle\lim_{x\to\infty}x\left(\sqrt{x^2+1}-x\right)$.`, R`$\dfrac{1}{2}$`, [R`$0$`, R`$1$`, R`$\infty$`], R`Multiply by the conjugate: $\dfrac{x}{\sqrt{x^2+1}+x}\to\dfrac{1}{2}$.`, T.limInf);
add(R`Evaluate $\displaystyle\lim_{x\to1}\dfrac{x^3-1}{x^2-1}$.`, R`$\dfrac{3}{2}$`, [R`$1$`, R`$\dfrac{2}{3}$`, R`$3$`], R`Factorise: $\dfrac{(x-1)(x^2+x+1)}{(x-1)(x+1)}\to\dfrac{3}{2}$.`, T.lim);
add(R`Evaluate $\displaystyle\lim_{x\to\infty}\dfrac{3x^2-5x+1}{2x^2+7}$.`, R`$\dfrac{3}{2}$`, [R`$0$`, R`$\infty$`, R`$-5$`], R`Divide by $x^2$: the limit is the ratio of the leading coefficients, $\dfrac{3}{2}$.`, T.limInf);
add(R`Evaluate $\displaystyle\lim_{x\to0}\dfrac{\sin 5x}{\tan 3x}$.`, R`$\dfrac{5}{3}$`, [R`$\dfrac{3}{5}$`, R`$1$`, R`$15$`], R`Using $\dfrac{\sin ax}{x}\to a$ and $\dfrac{\tan bx}{x}\to b$, the limit is $\dfrac{5}{3}$.`, T.lim);
add(R`Evaluate $\displaystyle\lim_{x\to0}\dfrac{\sqrt{1+x}-1}{x}$.`, R`$\dfrac{1}{2}$`, [R`$1$`, R`$0$`, R`$2$`], R`This is the derivative of $\sqrt{x}$ at $x = 1$, equal to $\dfrac{1}{2}$.`, T.lim);
add(R`Evaluate $\displaystyle\lim_{x\to\infty}\left(\sqrt{x^2+4x}-x\right)$.`, R`$2$`, [R`$4$`, R`$0$`, R`$\infty$`], R`Multiply by the conjugate: $\dfrac{4x}{\sqrt{x^2+4x}+x}\to\dfrac{4}{2} = 2$.`, T.limInf);

// ------------------------------------------------------------- curve sketching and extrema
add(R`The function $f(x) = x^3-6x^2+9x+1$ has a local maximum value of:`, R`$5$`, [R`$1$`, R`$3$`, R`$9$`], R`$f'(x) = 3(x-1)(x-3)$. Since $f''(1) = -6 < 0$, the maximum is at $x = 1$ and $f(1) = 5$.`, T.ext);
add(R`The function $f(x) = x^3-6x^2+9x+1$ has a local minimum at:`, R`$x = 3$`, [R`$x = 1$`, R`$x = 2$`, R`$x = 0$`], R`$f'(x) = 3(x-1)(x-3)$ and $f''(3) = 6 > 0$, so there is a minimum at $x = 3$.`, T.ext);
add(R`The point of inflection of the curve $y = x^3-3x^2+2$ occurs at:`, R`$x = 1$`, [R`$x = 0$`, R`$x = 2$`, R`$x = 3$`], R`$y'' = 6x-6$ changes sign at $x = 1$.`, T.con);
add(R`On which intervals is $f(x) = x^3-3x$ increasing?`, R`$(-\infty,-1)$ and $(1,\infty)$`, [R`$(-1, 1)$`, R`$(-\infty, 1)$`, R`$(0,\infty)$`], R`$f'(x) = 3(x^2-1) > 0$ when $x < -1$ or $x > 1$.`, T.ext);
add(R`The absolute maximum value of $f(x) = x^3-3x$ on the interval $[0, 2]$ is:`, R`$2$`, [R`$0$`, R`$-2$`, R`$1$`], R`Critical point $x = 1$ gives $f = -2$; endpoints give $f(0) = 0$ and $f(2) = 2$. The largest value is $2$.`, T.ext);
add(R`The curve $y = \dfrac{2x^2+1}{x-1}$ has an oblique asymptote:`, R`$y = 2x+2$`, [R`$y = 2x$`, R`$y = 2x-2$`, R`$y = x+2$`], R`Dividing: $\dfrac{2x^2+1}{x-1} = 2x+2+\dfrac{3}{x-1}$, so the oblique asymptote is $y = 2x+2$.`, T.asy);
add(R`The function $f(x) = \dfrac{x}{x^2+1}$ has a maximum value of:`, R`$\dfrac{1}{2}$`, [R`$1$`, R`$\dfrac{1}{4}$`, R`$2$`], R`$f'(x) = \dfrac{1-x^2}{(x^2+1)^2} = 0$ at $x = 1$, and $f(1) = \dfrac{1}{2}$.`, T.ext);
add(R`The Mean Value Theorem applied to $f(x) = x^3$ on $[0, 2]$ gives the value of $c$ as:`, R`$\dfrac{2}{\sqrt3}$`, [R`$1$`, R`$\dfrac{4}{3}$`, R`$\sqrt{3}$`], R`$f'(c) = 3c^2 = \dfrac{f(2)-f(0)}{2} = 4$, so $c = \dfrac{2}{\sqrt3}$.`, T.mvt);
add(R`Rolle's theorem applied to $f(x) = x^2-4x+3$ on $[1, 3]$ gives $c$ equal to:`, R`$2$`, [R`$1$`, R`$3$`, R`$\dfrac{3}{2}$`], R`$f(1) = f(3) = 0$ and $f'(c) = 2c-4 = 0$ gives $c = 2$.`, T.mvt);

// ------------------------------------------------------------- applications
add(R`The radius of a spherical balloon increases at $2$ cm/s. How fast is the volume increasing when the radius is $5$ cm?`, R`$200\pi$ cm³/s`, [R`$100\pi$ cm³/s`, R`$40\pi$ cm³/s`, R`$\dfrac{500\pi}{3}$ cm³/s`], R`$V = \dfrac43\pi r^3$, so $\dfrac{dV}{dt} = 4\pi r^2\dfrac{dr}{dt} = 4\pi(25)(2) = 200\pi$.`, T.rel);
add(R`A $5$ m ladder leans against a vertical wall. Its foot slides away from the wall at $0.5$ m/s. When the foot is $3$ m from the wall, the top is sliding down at a rate of:`, R`$0.375$ m/s`, [R`$0.667$ m/s`, R`$0.5$ m/s`, R`$0.25$ m/s`], R`$x^2+y^2 = 25$ gives $\dfrac{dy}{dt} = -\dfrac{x}{y}\dfrac{dx}{dt} = -\dfrac34(0.5) = -0.375$ m/s.`, T.rel);
add(R`A square sheet of metal expands so that its side increases at $0.2$ cm/s. When the side is $10$ cm, the area is increasing at:`, R`$4$ cm²/s`, [R`$2$ cm²/s`, R`$40$ cm²/s`, R`$0.4$ cm²/s`], R`$A = s^2$, so $\dfrac{dA}{dt} = 2s\dfrac{ds}{dt} = 2(10)(0.2) = 4$.`, T.rel);
add(R`Squares of side $x$ cm are cut from the corners of a $12$ cm by $12$ cm sheet and the sides folded up to make an open box. The largest possible volume, in cm³, is:`, R`$128$`, [R`$144$`, R`$108$`, R`$96$`], R`$V = x(12-2x)^2$, $V' = 12(x-2)(x-6)$. The maximum is at $x = 2$: $V = 2(8)^2 = 128$.`, T.opt);
add(R`A farmer has $200$ m of fencing to enclose a rectangular field on three sides, the fourth side being a river. The maximum area is:`, R`$5000$ m²`, [R`$2500$ m²`, R`$10000$ m²`, R`$4000$ m²`], R`With width $x$, length $200-2x$: $A = x(200-2x)$ is largest at $x = 50$, giving $50 \times 100 = 5000$.`, T.opt);
add(R`The point on the curve $y = \sqrt{x}$ closest to the point $(4, 0)$ has $x$-coordinate:`, R`$\dfrac{7}{2}$`, [R`$4$`, R`$3$`, R`$\dfrac{9}{2}$`], R`Minimise $d^2 = (x-4)^2+x$: $2(x-4)+1 = 0$ gives $x = \dfrac72$.`, T.opt);
add(R`Two positive numbers have sum $20$. The largest possible value of their product is:`, R`$100$`, [R`$99$`, R`$96$`, R`$120$`], R`$P = x(20-x)$ is greatest at $x = 10$: $P = 100$.`, T.opt);
add(R`Using a linear approximation, $\sqrt{4.1}$ is approximately:`, R`$2.025$`, [R`$2.05$`, R`$2.1$`, R`$2.0125$`], R`With $f(x) = \sqrt{x}$ at $a = 4$: $f(4.1)\approx 2+\dfrac{1}{4}(0.1) = 2.025$.`, T.lin);
add(R`Using differentials, the approximate value of $(1.02)^5$ is:`, R`$1.10$`, [R`$1.02$`, R`$1.05$`, R`$1.20$`], R`$f(x) = x^5$, $f'(1) = 5$, so $(1.02)^5\approx 1+5(0.02) = 1.10$.`, T.lin);
add(R`The radius of a circle is measured as $10$ cm with a possible error of $0.1$ cm. The approximate error in the area is:`, R`$2\pi$ cm²`, [R`$\pi$ cm²`, R`$0.2\pi$ cm²`, R`$20\pi$ cm²`], R`$dA = 2\pi r\,dr = 2\pi(10)(0.1) = 2\pi$.`, T.lin);
add(R`The position of a particle is $s = t^3-6t^2+9t$ metres at time $t$ seconds. The particle is momentarily at rest when $t$ equals:`, R`$1$ s and $3$ s`, [R`$0$ s and $3$ s`, R`$2$ s only`, R`$1$ s and $2$ s`], R`$v = 3t^2-12t+9 = 3(t-1)(t-3) = 0$ at $t = 1$ and $t = 3$.`, T.vel);
add(R`The position of a particle is $s = t^3-6t^2+9t$ metres. Its acceleration at $t = 1$ s is:`, R`$-6$ m/s²`, [R`$6$ m/s²`, R`$0$ m/s²`, R`$-3$ m/s²`], R`$a = \dfrac{d^2s}{dt^2} = 6t-12 = -6$ at $t = 1$.`, T.vel);
add(R`The left Riemann sum with $4$ equal sub-intervals for $\displaystyle\int_0^2x^2\,dx$ is:`, R`$1.75$`, [R`$3.75$`, R`$2.75$`, R`$2.00$`], R`With width $0.5$: $0.5[f(0)+f(0.5)+f(1)+f(1.5)] = 0.5(0+0.25+1+2.25) = 1.75$.`, T.riem);
add(R`The right Riemann sum with $4$ equal sub-intervals for $\displaystyle\int_0^2x^2\,dx$ is:`, R`$3.75$`, [R`$1.75$`, R`$2.75$`, R`$4.00$`], R`$0.5[f(0.5)+f(1)+f(1.5)+f(2)] = 0.5(0.25+1+2.25+4) = 3.75$.`, T.riem);

module.exports = out;
