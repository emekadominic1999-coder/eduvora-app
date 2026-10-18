// MTH 103 - batch C: differentiation (every derivative verified numerically), implicit, parametric, higher order.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { rules: 'Rules of Differentiation', chain: 'The Chain Rule', impl: 'Implicit Differentiation', hi: 'Higher Order Derivatives', par: 'Derivatives of Functions Expressed Parametrically', trig: 'Derivatives of Trigonometric Functions', ex: 'The Exponential Function', ln: 'The Natural Logarithmic Function', inv: 'Inverse Trigonometric Functions', hyp: 'Hyperbolic Functions' };
const num = (f, x) => (f(x + 1e-6) - f(x - 1e-6)) / 2e-6;
const near = (a, b) => Math.abs(a - b) <= 1e-4 * Math.max(1, Math.abs(b));
const STEMS = [
  (t) => R`Differentiate $y = ${t}$ with respect to $x$.`,
  (t) => R`Find $\dfrac{dy}{dx}$ if $y = ${t}$.`,
  (t) => R`If $y = ${t}$, then $\dfrac{dy}{dx}$ is:`,
  (t) => R`Determine the derivative of $y = ${t}$.`,
  (t) => R`The derivative of $f(x) = ${t}$ is:`,
];
let k = 0;
function D(topic, tex, f, g, correct, wrongs, expl, pts = [0.6, 1.1, 1.7, 2.3]) {
  for (const x of pts) if (!near(num(f, x), g(x))) throw new Error('derivative check failed: ' + tex + ' at ' + x);
  add(STEMS[k++ % STEMS.length](tex), '$' + correct + '$', wrongs.map((w) => '$' + w + '$'), expl, topic);
}

D(T.chain, R`(2x+1)^3(x^2-1)^2`, (x) => (2 * x + 1) ** 3 * (x * x - 1) ** 2, (x) => 2 * (2 * x + 1) ** 2 * (x * x - 1) * (7 * x * x + 2 * x - 3),
  R`2(2x+1)^2(x^2-1)(7x^2+2x-3)`, [R`2(2x+1)^2(x^2-1)(7x^2-2x-3)`, R`6(2x+1)^2\cdot4x(x^2-1)`, R`(2x+1)^2(x^2-1)(14x^2+4x-6)+1`],
  R`$y' = 6(2x+1)^2(x^2-1)^2+4x(2x+1)^3(x^2-1)$; taking out the common factor $2(2x+1)^2(x^2-1)$ leaves $3(x^2-1)+2x(2x+1) = 7x^2+2x-3$.`);
D(T.chain, R`\sin(x^2)\cos x`, (x) => Math.sin(x * x) * Math.cos(x), (x) => 2 * x * Math.cos(x * x) * Math.cos(x) - Math.sin(x * x) * Math.sin(x),
  R`2x\cos(x^2)\cos x-\sin(x^2)\sin x`, [R`\cos(x^2)\cos x-\sin(x^2)\sin x`, R`2x\cos(x^2)\cos x+\sin(x^2)\sin x`, R`-2x\sin(x^2)\sin x`],
  R`Product rule, with the chain rule on $\sin(x^2)$: $y' = 2x\cos(x^2)\cos x+\sin(x^2)(-\sin x)$.`);
D(T.ex, R`xe^{-x^2}`, (x) => x * Math.exp(-x * x), (x) => Math.exp(-x * x) * (1 - 2 * x * x),
  R`e^{-x^2}(1-2x^2)`, [R`e^{-x^2}(1+2x^2)`, R`-2x^2e^{-x^2}`, R`e^{-x^2}(1-2x)`],
  R`$y' = e^{-x^2}+x(-2x)e^{-x^2} = e^{-x^2}(1-2x^2)$.`);
D(T.ln, R`\ln\left(\dfrac{x-1}{x+1}\right)`, (x) => Math.log((x - 1) / (x + 1)), (x) => 2 / (x * x - 1),
  R`\dfrac{2}{x^2-1}`, [R`\dfrac{-2}{x^2-1}`, R`\dfrac{1}{x^2-1}`, R`\dfrac{2}{x^2+1}`],
  R`Write $y = \ln(x-1)-\ln(x+1)$, so $y' = \dfrac{1}{x-1}-\dfrac{1}{x+1} = \dfrac{2}{x^2-1}$.`, [1.6, 2.1, 2.9, 3.5]);
D(T.ex, R`\dfrac{e^x}{1+e^x}`, (x) => Math.exp(x) / (1 + Math.exp(x)), (x) => Math.exp(x) / (1 + Math.exp(x)) ** 2,
  R`\dfrac{e^x}{(1+e^x)^2}`, [R`\dfrac{1}{(1+e^x)^2}`, R`\dfrac{e^x}{1+e^x}`, R`\dfrac{e^x(1+e^x)}{(1+e^x)^2}`],
  R`Quotient rule: $\dfrac{e^x(1+e^x)-e^x\cdot e^x}{(1+e^x)^2} = \dfrac{e^x}{(1+e^x)^2}$.`);
D(T.inv, R`\tan^{-1}\left(\dfrac{1}{x}\right)`, (x) => Math.atan(1 / x), (x) => -1 / (1 + x * x),
  R`-\dfrac{1}{1+x^2}`, [R`\dfrac{1}{1+x^2}`, R`-\dfrac{x^2}{1+x^2}`, R`\dfrac{-1}{x^2+x^4}`],
  R`$y' = \dfrac{1}{1+1/x^2}\cdot\left(-\dfrac{1}{x^2}\right) = -\dfrac{1}{x^2+1}$.`);
D(T.chain, R`e^x\sqrt{x^2+1}`, (x) => Math.exp(x) * Math.sqrt(x * x + 1), (x) => Math.exp(x) * (x * x + x + 1) / Math.sqrt(x * x + 1),
  R`\dfrac{e^x(x^2+x+1)}{\sqrt{x^2+1}}`, [R`\dfrac{e^x(x^2+1)}{\sqrt{x^2+1}}`, R`\dfrac{e^x(x^2-x+1)}{\sqrt{x^2+1}}`, R`\dfrac{e^x(2x+1)}{2\sqrt{x^2+1}}`],
  R`$y' = e^x\sqrt{x^2+1}+e^x\dfrac{x}{\sqrt{x^2+1}} = \dfrac{e^x(x^2+1+x)}{\sqrt{x^2+1}}$.`);
D(T.chain, R`\cos(\ln x)`, (x) => Math.cos(Math.log(x)), (x) => -Math.sin(Math.log(x)) / x,
  R`-\dfrac{\sin(\ln x)}{x}`, [R`\dfrac{\sin(\ln x)}{x}`, R`-\sin\left(\dfrac{1}{x}\right)`, R`-\dfrac{\cos(\ln x)}{x}`],
  R`Chain rule: $y' = -\sin(\ln x)\cdot\dfrac1x$.`);
D(T.rules, R`x^{\sin x}`, (x) => x ** Math.sin(x), (x) => x ** Math.sin(x) * (Math.cos(x) * Math.log(x) + Math.sin(x) / x),
  R`x^{\sin x}\left(\cos x\ln x+\dfrac{\sin x}{x}\right)`, [R`\sin x\cdot x^{\sin x-1}`, R`x^{\sin x}\cos x\ln x`, R`x^{\sin x}\left(\cos x+\dfrac{\sin x}{x}\right)`],
  R`Log differentiation: $\ln y = \sin x\ln x$, so $\dfrac{y'}{y} = \cos x\ln x+\dfrac{\sin x}{x}$.`);
D(T.ex, R`3^{x^2}`, (x) => 3 ** (x * x), (x) => 2 * x * Math.log(3) * 3 ** (x * x),
  R`2x\ln3\cdot3^{x^2}`, [R`x^2\cdot3^{x^2-1}`, R`2x\cdot3^{x^2}`, R`\ln3\cdot3^{x^2}`],
  R`$\dfrac{d}{dx}a^{u} = a^u\ln a\cdot u'$ with $u = x^2$.`);
D(T.ln, R`\log_2(3x+1)`, (x) => Math.log(3 * x + 1) / Math.LN2, (x) => 3 / ((3 * x + 1) * Math.LN2),
  R`\dfrac{3}{(3x+1)\ln2}`, [R`\dfrac{3}{3x+1}`, R`\dfrac{1}{(3x+1)\ln2}`, R`\dfrac{3\ln2}{3x+1}`],
  R`$\log_2u = \dfrac{\ln u}{\ln2}$, so $y' = \dfrac{1}{\ln2}\cdot\dfrac{3}{3x+1}$.`);
D(T.inv, R`x\sin^{-1}x+\sqrt{1-x^2}`, (x) => x * Math.asin(x) + Math.sqrt(1 - x * x), (x) => Math.asin(x),
  R`\sin^{-1}x`, [R`\dfrac{x}{\sqrt{1-x^2}}`, R`\sin^{-1}x+\dfrac{2x}{\sqrt{1-x^2}}`, R`\dfrac{1}{\sqrt{1-x^2}}`],
  R`$y' = \sin^{-1}x+\dfrac{x}{\sqrt{1-x^2}}-\dfrac{x}{\sqrt{1-x^2}} = \sin^{-1}x$.`, [0.1, 0.3, 0.5, 0.8]);
D(T.hyp, R`\sinh x\cosh x`, (x) => Math.sinh(x) * Math.cosh(x), (x) => Math.cosh(2 * x),
  R`\cosh2x`, [R`\sinh2x`, R`\cosh^2x-\sinh^2x`, R`2\sinh x\cosh x`],
  R`$y = \tfrac12\sinh2x$, so $y' = \cosh2x$ (equivalently $\cosh^2x+\sinh^2x$).`);
D(T.ex, R`e^{2x}\sin3x`, (x) => Math.exp(2 * x) * Math.sin(3 * x), (x) => Math.exp(2 * x) * (2 * Math.sin(3 * x) + 3 * Math.cos(3 * x)),
  R`e^{2x}(2\sin3x+3\cos3x)`, [R`e^{2x}(2\sin3x-3\cos3x)`, R`3e^{2x}\cos3x`, R`e^{2x}(\sin3x+\cos3x)`],
  R`$y' = 2e^{2x}\sin3x+3e^{2x}\cos3x$.`);
D(T.trig, R`\sec x+\tan x`, (x) => 1 / Math.cos(x) + Math.tan(x), (x) => (1 / Math.cos(x)) * (Math.tan(x) + 1 / Math.cos(x)),
  R`\sec x(\tan x+\sec x)`, [R`\sec x(\tan x-\sec x)`, R`\sec^2x+\sec x`, R`\sec x\tan x`],
  R`$y' = \sec x\tan x+\sec^2x = \sec x(\tan x+\sec x)$.`);
D(T.trig, R`\ln(\sec x+\tan x)`, (x) => Math.log(1 / Math.cos(x) + Math.tan(x)), (x) => 1 / Math.cos(x),
  R`\sec x`, [R`\tan x`, R`\sec x\tan x`, R`\dfrac{1}{\sec x+\tan x}`],
  R`$y' = \dfrac{\sec x\tan x+\sec^2x}{\sec x+\tan x} = \sec x$.`, [0.3, 0.6, 0.9, 1.2]);
D(T.ln, R`x^3\ln x`, (x) => x ** 3 * Math.log(x), (x) => x * x * (3 * Math.log(x) + 1),
  R`x^2(3\ln x+1)`, [R`3x^2\ln x`, R`x^2(3\ln x-1)`, R`3x^2+\dfrac1x`],
  R`$y' = 3x^2\ln x+x^3\cdot\dfrac1x = x^2(3\ln x+1)$.`);
D(T.rules, R`\dfrac{x+1}{x^2+x+1}`, (x) => (x + 1) / (x * x + x + 1), (x) => -x * (x + 2) / (x * x + x + 1) ** 2,
  R`-\dfrac{x(x+2)}{(x^2+x+1)^2}`, [R`\dfrac{x(x+2)}{(x^2+x+1)^2}`, R`-\dfrac{1}{2x+1}`, R`-\dfrac{x^2+2x+2}{(x^2+x+1)^2}`],
  R`Numerator: $(x^2+x+1)-(x+1)(2x+1) = -x^2-2x$.`);
D(T.trig, R`\cot(2x)`, (x) => 1 / Math.tan(2 * x), (x) => -2 / Math.sin(2 * x) ** 2,
  R`-2\csc^2(2x)`, [R`-\csc^2(2x)`, R`2\csc^2(2x)`, R`-2\cot(2x)\csc(2x)`],
  R`$\dfrac{d}{dx}\cot u = -u'\csc^2u$.`);
D(T.ex, R`e^{\tan x}`, (x) => Math.exp(Math.tan(x)), (x) => Math.exp(Math.tan(x)) / Math.cos(x) ** 2,
  R`\sec^2x\,e^{\tan x}`, [R`e^{\tan x}`, R`\tan x\,e^{\tan x-1}`, R`\sec x\,e^{\tan x}`],
  R`$y' = e^{\tan x}\cdot\sec^2x$.`, [0.3, 0.6, 0.9, 1.2]);
D(T.inv, R`\tan^{-1}(\sin x)`, (x) => Math.atan(Math.sin(x)), (x) => Math.cos(x) / (1 + Math.sin(x) ** 2),
  R`\dfrac{\cos x}{1+\sin^2x}`, [R`\dfrac{1}{1+\sin^2x}`, R`\dfrac{\cos x}{1-\sin^2x}`, R`\dfrac{\sin x}{1+\cos^2x}`],
  R`$\dfrac{d}{dx}\tan^{-1}u = \dfrac{u'}{1+u^2}$ with $u = \sin x$.`);
D(T.chain, R`(1+x^2)^{-1/2}`, (x) => (1 + x * x) ** -0.5, (x) => -x * (1 + x * x) ** -1.5,
  R`-x(1+x^2)^{-3/2}`, [R`-\dfrac12(1+x^2)^{-3/2}`, R`x(1+x^2)^{-3/2}`, R`-(1+x^2)^{-3/2}`],
  R`$y' = -\tfrac12(1+x^2)^{-3/2}\cdot2x$.`);
D(T.rules, R`\dfrac{x}{(x^2+1)^2}`, (x) => x / (x * x + 1) ** 2, (x) => (1 - 3 * x * x) / (x * x + 1) ** 3,
  R`\dfrac{1-3x^2}{(x^2+1)^3}`, [R`\dfrac{1+3x^2}{(x^2+1)^3}`, R`\dfrac{1-x^2}{(x^2+1)^3}`, R`\dfrac{1-3x^2}{(x^2+1)^2}`],
  R`$y' = \dfrac{(x^2+1)^2-x\cdot2(x^2+1)\cdot2x}{(x^2+1)^4} = \dfrac{(x^2+1)-4x^2}{(x^2+1)^3}$.`);
D(T.ln, R`\ln\left(x^2e^x\right)`, (x) => Math.log(x * x * Math.exp(x)), (x) => 2 / x + 1,
  R`\dfrac{2}{x}+1`, [R`\dfrac{2}{x}+x`, R`\dfrac{2}{x}+e^x`, R`\dfrac{2x+x^2}{x^2e^x}\cdot x`],
  R`Simplify first: $y = 2\ln x+x$, so $y' = \dfrac2x+1$.`);
D(T.ex, R`e^{-x}\cos x`, (x) => Math.exp(-x) * Math.cos(x), (x) => -Math.exp(-x) * (Math.cos(x) + Math.sin(x)),
  R`-e^{-x}(\cos x+\sin x)`, [R`e^{-x}(\sin x-\cos x)`, R`-e^{-x}\sin x`, R`e^{-x}(\cos x+\sin x)`],
  R`$y' = -e^{-x}\cos x-e^{-x}\sin x$.`);
D(T.inv, R`(\tan^{-1}x)^2`, (x) => Math.atan(x) ** 2, (x) => 2 * Math.atan(x) / (1 + x * x),
  R`\dfrac{2\tan^{-1}x}{1+x^2}`, [R`\dfrac{2}{1+x^2}`, R`2\tan^{-1}x`, R`\dfrac{2x\tan^{-1}x}{1+x^2}`],
  R`Chain rule: $y' = 2\tan^{-1}x\cdot\dfrac{1}{1+x^2}$.`);
D(T.trig, R`\ln|\cos2x|`, (x) => Math.log(Math.abs(Math.cos(2 * x))), (x) => -2 * Math.tan(2 * x),
  R`-2\tan2x`, [R`2\tan2x`, R`-\tan2x`, R`-2\cot2x`],
  R`$y' = \dfrac{-2\sin2x}{\cos2x} = -2\tan2x$.`);
D(T.ex, R`\dfrac{e^{x^2}}{x}`, (x) => Math.exp(x * x) / x, (x) => Math.exp(x * x) * (2 * x * x - 1) / (x * x),
  R`\dfrac{e^{x^2}(2x^2-1)}{x^2}`, [R`\dfrac{e^{x^2}(2x^2+1)}{x^2}`, R`\dfrac{2xe^{x^2}}{x}`, R`\dfrac{e^{x^2}(x-1)}{x^2}`],
  R`Quotient rule: $\dfrac{2x\cdot xe^{x^2}-e^{x^2}}{x^2}$.`);
D(T.trig, R`\sin3x\cos2x`, (x) => Math.sin(3 * x) * Math.cos(2 * x), (x) => 3 * Math.cos(3 * x) * Math.cos(2 * x) - 2 * Math.sin(3 * x) * Math.sin(2 * x),
  R`3\cos3x\cos2x-2\sin3x\sin2x`, [R`3\cos3x\cos2x+2\sin3x\sin2x`, R`\cos3x\cos2x-\sin3x\sin2x`, R`6\cos3x\sin2x`],
  R`Product rule with two chain rules.`);
D(T.rules, R`(2x-3)^{1/3}`, (x) => (2 * x - 3) ** (1 / 3), (x) => (2 / 3) * (2 * x - 3) ** (-2 / 3),
  R`\dfrac{2}{3}(2x-3)^{-2/3}`, [R`\dfrac{1}{3}(2x-3)^{-2/3}`, R`\dfrac{2}{3}(2x-3)^{2/3}`, R`\dfrac{2}{3\sqrt[3]{2x-3}}`],
  R`$y' = \tfrac13(2x-3)^{-2/3}\cdot2$.`, [1.7, 2.1, 2.6, 3.4]);
D(T.chain, R`\sqrt{\dfrac{1-x}{1+x}}`, (x) => Math.sqrt((1 - x) / (1 + x)), (x) => -1 / ((1 + x) * Math.sqrt(1 - x * x)),
  R`-\dfrac{1}{(1+x)\sqrt{1-x^2}}`, [R`\dfrac{1}{(1+x)\sqrt{1-x^2}}`, R`-\dfrac{1}{2\sqrt{1-x^2}}`, R`-\dfrac{1}{(1+x)^2}`],
  R`$y = \dfrac{\sqrt{1-x}}{\sqrt{1+x}}$; differentiating gives $-\dfrac{1}{(1+x)\sqrt{1-x^2}}$.`, [0.1, 0.3, 0.5, 0.7]);
D(T.rules, R`x^2\sqrt{x+1}`, (x) => x * x * Math.sqrt(x + 1), (x) => x * (5 * x + 4) / (2 * Math.sqrt(x + 1)),
  R`\dfrac{x(5x+4)}{2\sqrt{x+1}}`, [R`\dfrac{x(5x+2)}{2\sqrt{x+1}}`, R`\dfrac{2x}{2\sqrt{x+1}}`, R`\dfrac{x(3x+4)}{2\sqrt{x+1}}`],
  R`$y' = 2x\sqrt{x+1}+\dfrac{x^2}{2\sqrt{x+1}} = \dfrac{4x(x+1)+x^2}{2\sqrt{x+1}} = \dfrac{x(5x+4)}{2\sqrt{x+1}}$.`);
D(T.hyp, R`\tanh(3x)`, (x) => Math.tanh(3 * x), (x) => 3 / Math.cosh(3 * x) ** 2,
  R`3\,\text{sech}^2(3x)`, [R`\text{sech}^2(3x)`, R`3\,\text{sech}(3x)\tanh(3x)`, R`-3\,\text{sech}^2(3x)`],
  R`$\dfrac{d}{dx}\tanh u = u'\,\text{sech}^2u$.`);
D(T.rules, R`\dfrac{\sin x}{1+\cos x}`, (x) => Math.sin(x) / (1 + Math.cos(x)), (x) => 1 / (1 + Math.cos(x)),
  R`\dfrac{1}{1+\cos x}`, [R`\dfrac{1}{1-\cos x}`, R`\dfrac{\cos x}{1+\cos x}`, R`\dfrac{2}{1+\cos x}`],
  R`$y' = \dfrac{\cos x(1+\cos x)+\sin^2x}{(1+\cos x)^2} = \dfrac{\cos x+1}{(1+\cos x)^2} = \dfrac{1}{1+\cos x}$.`);

// ------------------------------------------------------------- implicit differentiation
add(R`For the curve $x^2+xy+y^2=7$, the value of $\dfrac{dy}{dx}$ at the point $(1,2)$ is:`, R`$-\dfrac{4}{5}$`, [R`$\dfrac{4}{5}$`, R`$-\dfrac{5}{4}$`, R`$-1$`], R`$2x+y+xy'+2yy' = 0$, so $y' = -\dfrac{2x+y}{x+2y} = -\dfrac{4}{5}$.`, T.impl);
add(R`Given $\sin(xy)=x$, find $\dfrac{dy}{dx}$ in terms of $x$ and $y$.`, R`$\dfrac{1-y\cos(xy)}{x\cos(xy)}$`, [R`$\dfrac{1+y\cos(xy)}{x\cos(xy)}$`, R`$\dfrac{1}{x\cos(xy)}$`, R`$\dfrac{y\cos(xy)-1}{\cos(xy)}$`], R`$\cos(xy)(y+xy') = 1$, so $y' = \dfrac{1-y\cos(xy)}{x\cos(xy)}$.`, T.impl);
add(R`The tangent to the curve $y^2 = x^3$ at the point $(4, 8)$ has gradient:`, R`$3$`, [R`$\dfrac{3}{2}$`, R`$6$`, R`$12$`], R`$2yy' = 3x^2$, so $y' = \dfrac{3x^2}{2y} = \dfrac{48}{16} = 3$.`, T.impl);
add(R`If $e^y+xy=e$, then $\dfrac{dy}{dx}$ at the point $(0,1)$ is:`, R`$-\dfrac{1}{e}$`, [R`$-e$`, R`$\dfrac{1}{e}$`, R`$-1$`], R`$e^yy'+y+xy' = 0$, so $y' = -\dfrac{y}{e^y+x} = -\dfrac{1}{e}$.`, T.impl);
add(R`For the curve $x^4+y^4=17$, the gradient at the point $(1, 2)$ is:`, R`$-\dfrac{1}{8}$`, [R`$\dfrac{1}{8}$`, R`$-8$`, R`$-\dfrac{1}{2}$`], R`$4x^3+4y^3y' = 0$, so $y' = -\dfrac{x^3}{y^3} = -\dfrac18$.`, T.impl);
add(R`The normal to the curve $x^2+y^2=25$ at $(3, 4)$ passes through:`, R`The origin`, [R`The point $(0, 5)$`, R`The point $(5, 0)$`, R`The point $(-3, 4)$`], R`The normal to a circle at any point lies along a radius, so it passes through the centre $(0,0)$.`, T.impl);

// ------------------------------------------------------------- parametric
add(R`A curve has parametric equations $x = 2t+1$ and $y = t^2-3t$. The value of $\dfrac{dy}{dx}$ when $t = 2$ is:`, R`$\dfrac{1}{2}$`, [R`$1$`, R`$2$`, R`$\dfrac{1}{4}$`], R`$\dfrac{dy}{dx} = \dfrac{2t-3}{2}$, which is $\dfrac12$ at $t = 2$.`, T.par);
add(R`For the curve $x = t-\sin t$, $y = 1-\cos t$, the gradient $\dfrac{dy}{dx}$ is:`, R`$\dfrac{\sin t}{1-\cos t}$`, [R`$\dfrac{1-\cos t}{\sin t}$`, R`$\dfrac{\sin t}{1+\cos t}$`, R`$\dfrac{\cos t}{1-\sin t}$`], R`$\dfrac{dy}{dt} = \sin t$ and $\dfrac{dx}{dt} = 1-\cos t$.`, T.par);
add(R`For $x = e^t\cos t$ and $y = e^t\sin t$, the gradient $\dfrac{dy}{dx}$ at $t = 0$ is:`, R`$1$`, [R`$0$`, R`$-1$`, R`$e$`], R`$\dfrac{dy}{dx} = \dfrac{e^t(\sin t+\cos t)}{e^t(\cos t-\sin t)} = 1$ at $t = 0$.`, T.par);
add(R`A curve is given by $x = t^2$, $y = 2t$. The Cartesian equation of the curve is:`, R`$y^2 = 4x$`, [R`$y^2 = 2x$`, R`$x^2 = 4y$`, R`$y = 2x$`], R`Eliminate $t = \dfrac y2$: $x = \dfrac{y^2}{4}$.`, T.par);

// ------------------------------------------------------------- higher-order derivatives
add(R`If $y = x^4-3x^2+2x$, then $\dfrac{d^2y}{dx^2}$ is:`, R`$12x^2-6$`, [R`$4x^3-6x+2$`, R`$12x^2-6x$`, R`$24x$`], R`$y' = 4x^3-6x+2$ and $y'' = 12x^2-6$.`, T.hi);
add(R`If $y = \sin2x$, then $\dfrac{d^3y}{dx^3}$ is:`, R`$-8\cos2x$`, [R`$8\cos2x$`, R`$-4\cos2x$`, R`$-8\sin2x$`], R`$y' = 2\cos2x$, $y'' = -4\sin2x$, $y''' = -8\cos2x$.`, T.hi);
add(R`If $y = x\ln x$, then $\dfrac{d^2y}{dx^2}$ is:`, R`$\dfrac{1}{x}$`, [R`$\ln x+1$`, R`$-\dfrac{1}{x^2}$`, R`$\dfrac{1}{x^2}$`], R`$y' = \ln x+1$ and $y'' = \dfrac1x$.`, T.hi);
add(R`If $y = e^{-x}\cos x$, then $y''+2y'+2y$ equals:`, R`$0$`, [R`$e^{-x}\cos x$`, R`$-2e^{-x}\sin x$`, R`$2$`], R`$y' = -e^{-x}(\cos x+\sin x)$ and $y'' = 2e^{-x}\sin x$. Then $y''+2y'+2y = 2e^{-x}\sin x-2e^{-x}(\cos x+\sin x)+2e^{-x}\cos x = 0$.`, T.hi);
add(R`If $y = \dfrac{1}{1-x}$, the $n$th derivative $y^{(n)}$ is:`, R`$\dfrac{n!}{(1-x)^{n+1}}$`, [R`$\dfrac{n}{(1-x)^{n+1}}$`, R`$\dfrac{n!}{(1-x)^{n}}$`, R`$\dfrac{(-1)^nn!}{(1-x)^{n+1}}$`], R`$y' = (1-x)^{-2}$, $y'' = 2(1-x)^{-3}$, $y''' = 6(1-x)^{-4}$, and so on.`, T.hi);
add(R`If $y = x^3-6x^2+9x$, the value of $x$ for which $\dfrac{d^2y}{dx^2} = 0$ is:`, R`$2$`, [R`$1$`, R`$3$`, R`$0$`], R`$y'' = 6x-12 = 0$ gives $x = 2$.`, T.hi);

module.exports = out;
