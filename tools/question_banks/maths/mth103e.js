// MTH 103 - batch E: integration (antiderivatives verified by differentiation, definite integrals by Simpson's rule).
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { anti: 'Antiderivatives of Some Elementary Functions', sub: 'Method of Substitution', parts: 'Integration by Parts', pf: 'Method of Partial Fractions', ftc: 'Fundamental Theorem of Integral Calculus', area: 'Areas of Plane Regions', disc: 'The Disc Method', shell: 'The Shell Method', len: 'Lengths of Curves', avg: 'Areas and Riemann Sums' };
const num = (f, x) => (f(x + 1e-6) - f(x - 1e-6)) / 2e-6;
const near = (a, b, tol = 1e-4) => Math.abs(a - b) <= tol * Math.max(1, Math.abs(b));
const simpson = (f, a, b, n = 20000) => { const h = (b - a) / n; let s = f(a) + f(b); for (let i = 1; i < n; i++) s += f(a + i * h) * (i % 2 ? 4 : 2); return s * h / 3; };
const STEMS = [
  (t) => R`Evaluate $\displaystyle\int ${t}\,dx$.`,
  (t) => R`Find $\displaystyle\int ${t}\,dx$.`,
  (t) => R`The integral $\displaystyle\int ${t}\,dx$ equals:`,
  (t) => R`Determine $\displaystyle\int ${t}\,dx$.`,
];
let k = 0;
function A(topic, tex, f, F, correct, wrongs, expl, pts = [0.6, 1.1, 1.7, 2.3]) {
  for (const x of pts) if (!near(num(F, x), f(x))) throw new Error('antiderivative check failed: ' + tex + ' at ' + x);
  add(STEMS[k++ % STEMS.length](tex), '$' + correct + '+C$', wrongs.map((w) => '$' + w + '+C$'), expl, topic);
}
function I(topic, stem, f, a, b, value, correct, wrongs, expl) {
  const v = simpson(f, a, b);
  if (!near(v, value, 1e-6)) throw new Error('definite integral check failed: ' + stem + ' ' + v + ' vs ' + value);
  add(stem, '$' + correct + '$', wrongs.map((w) => '$' + w + '$'), expl, topic);
}

// ---------------- indefinite integrals
A(T.sub, R`x^2\sqrt{x^3+1}`, (x) => x * x * Math.sqrt(x ** 3 + 1), (x) => (2 / 9) * (x ** 3 + 1) ** 1.5, R`\dfrac{2}{9}(x^3+1)^{3/2}`, [R`\dfrac{2}{3}(x^3+1)^{3/2}`, R`\dfrac{1}{3}(x^3+1)^{3/2}`, R`\dfrac{2}{9}(x^3+1)^{1/2}`], R`Let $u = x^3+1$, $du = 3x^2dx$: $\dfrac13\int u^{1/2}du = \dfrac13\cdot\dfrac23u^{3/2}$.`);
A(T.parts, R`e^{3x}\cos x`, (x) => Math.exp(3 * x) * Math.cos(x), (x) => Math.exp(3 * x) * (3 * Math.cos(x) + Math.sin(x)) / 10, R`\dfrac{e^{3x}(3\cos x+\sin x)}{10}`, [R`\dfrac{e^{3x}(3\cos x-\sin x)}{10}`, R`\dfrac{e^{3x}(\cos x+3\sin x)}{10}`, R`\dfrac{e^{3x}(3\cos x+\sin x)}{3}`], R`Integrate by parts twice and solve for the integral: $10I = e^{3x}(3\cos x+\sin x)$.`);
A(T.parts, R`x\sec^2x`, (x) => x / Math.cos(x) ** 2, (x) => x * Math.tan(x) + Math.log(Math.cos(x)), R`x\tan x+\ln|\cos x|`, [R`x\tan x-\ln|\cos x|`, R`\tan x+x\sec^2x`, R`x\tan x+\ln|\sin x|`], R`By parts with $u = x$, $dv = \sec^2x\,dx$: $x\tan x-\int\tan x\,dx$.`, [0.3, 0.6, 0.9, 1.2]);
A(T.sub, R`\sin x\cos x`, (x) => Math.sin(x) * Math.cos(x), (x) => 0.5 * Math.sin(x) ** 2, R`\dfrac{1}{2}\sin^2x`, [R`\dfrac{1}{2}\cos^2x`, R`\sin^2x`, R`-\dfrac{1}{2}\sin^2x`], R`Let $u = \sin x$: $\int u\,du = \dfrac{u^2}{2}$.`);
A(T.sub, R`\dfrac{1}{x\ln x}`, (x) => 1 / (x * Math.log(x)), (x) => Math.log(Math.log(x)), R`\ln|\ln x|`, [R`\dfrac{1}{\ln x}`, R`(\ln x)^2`, R`\ln|x\ln x|`], R`Let $u = \ln x$, $du = \dfrac{dx}{x}$, giving $\int\dfrac{du}{u}$.`, [1.5, 2.1, 2.9, 3.7]);
A(T.sub, R`\dfrac{x+1}{x^2+2x+3}`, (x) => (x + 1) / (x * x + 2 * x + 3), (x) => 0.5 * Math.log(x * x + 2 * x + 3), R`\dfrac{1}{2}\ln(x^2+2x+3)`, [R`\ln(x^2+2x+3)`, R`\dfrac{1}{x^2+2x+3}`, R`2\ln(x^2+2x+3)`], R`The derivative of the denominator is $2(x+1)$, so the integral is $\dfrac12\ln(x^2+2x+3)$.`);
A(T.sub, R`\dfrac{1}{\sqrt{x^2+4}}`, (x) => 1 / Math.sqrt(x * x + 4), (x) => Math.log(x + Math.sqrt(x * x + 4)), R`\ln\left(x+\sqrt{x^2+4}\right)`, [R`\sin^{-1}\dfrac{x}{2}`, R`\dfrac{1}{2}\tan^{-1}\dfrac{x}{2}`, R`\sqrt{x^2+4}`], R`$\int\dfrac{dx}{\sqrt{x^2+a^2}} = \ln\left(x+\sqrt{x^2+a^2}\right)$.`);
A(T.parts, R`x^3e^{x^2}`, (x) => x ** 3 * Math.exp(x * x), (x) => 0.5 * Math.exp(x * x) * (x * x - 1), R`\dfrac{1}{2}e^{x^2}(x^2-1)`, [R`\dfrac{1}{2}e^{x^2}(x^2+1)`, R`\dfrac{x^4}{4}e^{x^2}`, R`e^{x^2}(x^2-1)`], R`Let $u = x^2$: $\dfrac12\int ue^u\,du = \dfrac12e^u(u-1)$.`);
A(T.sub, R`\tan^2x`, (x) => Math.tan(x) ** 2, (x) => Math.tan(x) - x, R`\tan x-x`, [R`\dfrac{\tan^3x}{3}`, R`\tan x+x`, R`\sec x-x`], R`Use $\tan^2x = \sec^2x-1$.`, [0.3, 0.6, 0.9, 1.2]);
A(T.sub, R`\sin2x\cos3x`, (x) => Math.sin(2 * x) * Math.cos(3 * x), (x) => -Math.cos(5 * x) / 10 + Math.cos(x) / 2, R`-\dfrac{\cos5x}{10}+\dfrac{\cos x}{2}`, [R`\dfrac{\cos5x}{10}-\dfrac{\cos x}{2}`, R`-\dfrac{\cos5x}{5}+\cos x`, R`-\dfrac{\cos 6x}{6}`], R`$\sin2x\cos3x = \dfrac12(\sin5x-\sin x)$.`);
A(T.sub, R`\dfrac{1}{x^2+2x+5}`, (x) => 1 / (x * x + 2 * x + 5), (x) => 0.5 * Math.atan((x + 1) / 2), R`\dfrac{1}{2}\tan^{-1}\dfrac{x+1}{2}`, [R`\tan^{-1}\dfrac{x+1}{2}`, R`\dfrac{1}{2}\ln(x^2+2x+5)`, R`\dfrac{1}{4}\tan^{-1}(x+1)`], R`Complete the square: $x^2+2x+5 = (x+1)^2+4$.`);
A(T.sub, R`\sec x`, (x) => 1 / Math.cos(x), (x) => Math.log(1 / Math.cos(x) + Math.tan(x)), R`\ln|\sec x+\tan x|`, [R`\sec x\tan x`, R`\ln|\cos x|`, R`\tan x`], R`Multiply by $\dfrac{\sec x+\tan x}{\sec x+\tan x}$ and let $u = \sec x+\tan x$.`, [0.3, 0.6, 0.9, 1.2]);
A(T.pf, R`\dfrac{x}{(x+1)^2}`, (x) => x / (x + 1) ** 2, (x) => Math.log(x + 1) + 1 / (x + 1), R`\ln|x+1|+\dfrac{1}{x+1}`, [R`\ln|x+1|-\dfrac{1}{x+1}`, R`\dfrac{x^2}{2(x+1)^2}`, R`\ln|x+1|+\dfrac{1}{(x+1)^2}`], R`Write $\dfrac{x}{(x+1)^2} = \dfrac{1}{x+1}-\dfrac{1}{(x+1)^2}$.`);
A(T.sub, R`\dfrac{x^2}{x^2+1}`, (x) => x * x / (x * x + 1), (x) => x - Math.atan(x), R`x-\tan^{-1}x`, [R`x+\tan^{-1}x`, R`\dfrac{x^3}{3}\tan^{-1}x`, R`\ln(x^2+1)`], R`$\dfrac{x^2}{x^2+1} = 1-\dfrac{1}{x^2+1}$.`);
A(T.sub, R`x\sqrt{x+1}`, (x) => x * Math.sqrt(x + 1), (x) => (2 / 5) * (x + 1) ** 2.5 - (2 / 3) * (x + 1) ** 1.5, R`\dfrac{2}{5}(x+1)^{5/2}-\dfrac{2}{3}(x+1)^{3/2}`, [R`\dfrac{2}{5}(x+1)^{5/2}+\dfrac{2}{3}(x+1)^{3/2}`, R`\dfrac{x^2}{2}\cdot\dfrac{2}{3}(x+1)^{3/2}`, R`\dfrac{2}{3}x(x+1)^{3/2}`], R`Let $u = x+1$: $\int(u-1)u^{1/2}du = \dfrac25u^{5/2}-\dfrac23u^{3/2}$.`);
A(T.parts, R`x^2\ln x`, (x) => x * x * Math.log(x), (x) => x ** 3 / 3 * Math.log(x) - x ** 3 / 9, R`\dfrac{x^3}{3}\ln x-\dfrac{x^3}{9}`, [R`\dfrac{x^3}{3}\ln x-\dfrac{x^3}{3}`, R`\dfrac{x^3}{3}\ln x+\dfrac{x^3}{9}`, R`x^2\ln x-x`], R`By parts with $u = \ln x$, $dv = x^2dx$: $\dfrac{x^3}{3}\ln x-\int\dfrac{x^2}{3}dx$.`);
A(T.sub, R`\dfrac{\sin(\ln x)}{x}`, (x) => Math.sin(Math.log(x)) / x, (x) => -Math.cos(Math.log(x)), R`-\cos(\ln x)`, [R`\cos(\ln x)`, R`-\sin(\ln x)`, R`\dfrac{\cos(\ln x)}{x}`], R`Let $u = \ln x$: $\int\sin u\,du = -\cos u$.`);
A(T.parts, R`e^{\sqrt{x}}`, (x) => Math.exp(Math.sqrt(x)), (x) => 2 * Math.exp(Math.sqrt(x)) * (Math.sqrt(x) - 1), R`2e^{\sqrt{x}}(\sqrt{x}-1)`, [R`2e^{\sqrt{x}}(\sqrt{x}+1)`, R`e^{\sqrt{x}}`, R`\dfrac{e^{\sqrt{x}}}{2\sqrt{x}}`], R`Let $x = t^2$: $\int2te^tdt = 2e^t(t-1)$.`);
A(T.pf, R`\dfrac{2x+1}{(x-1)(x+2)}`, (x) => (2 * x + 1) / ((x - 1) * (x + 2)), (x) => Math.log((x - 1) * (x + 2)), R`\ln|(x-1)(x+2)|`, [R`\ln\left|\dfrac{x-1}{x+2}\right|`, R`2\ln|x-1|+\ln|x+2|`, R`\ln|x-1|-\ln|x+2|`], R`Partial fractions: $\dfrac{2x+1}{(x-1)(x+2)} = \dfrac{1}{x-1}+\dfrac{1}{x+2}$.`, [1.5, 2.1, 2.9, 3.7]);
A(T.pf, R`\dfrac{1}{x^2-4x+3}`, (x) => 1 / (x * x - 4 * x + 3), (x) => 0.5 * Math.log(Math.abs((x - 3) / (x - 1))), R`\dfrac{1}{2}\ln\left|\dfrac{x-3}{x-1}\right|`, [R`\dfrac{1}{2}\ln\left|\dfrac{x-1}{x-3}\right|`, R`\ln|x^2-4x+3|`, R`\dfrac{1}{2}\ln|x^2-4x+3|`], R`$\dfrac{1}{(x-1)(x-3)} = \dfrac12\left(\dfrac{1}{x-3}-\dfrac{1}{x-1}\right)$.`, [0.4, 1.6, 2.4, 3.6]);
A(T.sub, R`\cos^3x\sin x`, (x) => Math.cos(x) ** 3 * Math.sin(x), (x) => -(Math.cos(x) ** 4) / 4, R`-\dfrac{\cos^4x}{4}`, [R`\dfrac{\cos^4x}{4}`, R`-\dfrac{\sin^4x}{4}`, R`\dfrac{\sin^2x\cos^2x}{2}`], R`Let $u = \cos x$, $du = -\sin x\,dx$.`);
A(T.parts, R`xe^{-x}`, (x) => x * Math.exp(-x), (x) => -(x + 1) * Math.exp(-x), R`-(x+1)e^{-x}`, [R`(x+1)e^{-x}`, R`-xe^{-x}`, R`\dfrac{x^2}{2}e^{-x}`], R`By parts with $u = x$, $dv = e^{-x}dx$: $-xe^{-x}+\int e^{-x}dx = -xe^{-x}-e^{-x}$.`);
A(T.parts, R`\sin^{-1}x`, (x) => Math.asin(x), (x) => x * Math.asin(x) + Math.sqrt(1 - x * x), R`x\sin^{-1}x+\sqrt{1-x^2}`, [R`x\sin^{-1}x-\sqrt{1-x^2}`, R`\dfrac{1}{\sqrt{1-x^2}}`, R`x\sin^{-1}x+\dfrac{x}{\sqrt{1-x^2}}`], R`By parts with $u = \sin^{-1}x$, $dv = dx$: $x\sin^{-1}x-\int\dfrac{x}{\sqrt{1-x^2}}dx$.`, [0.1, 0.3, 0.5, 0.8]);
A(T.sub, R`\dfrac{\cos x}{1+\sin^2x}`, (x) => Math.cos(x) / (1 + Math.sin(x) ** 2), (x) => Math.atan(Math.sin(x)), R`\tan^{-1}(\sin x)`, [R`\ln(1+\sin^2x)`, R`\dfrac{1}{1+\sin^2x}`, R`\sin^{-1}(\sin x)`], R`Let $u = \sin x$: $\int\dfrac{du}{1+u^2}$.`);
A(T.sub, R`\dfrac{e^{2x}}{1+e^{2x}}`, (x) => Math.exp(2 * x) / (1 + Math.exp(2 * x)), (x) => 0.5 * Math.log(1 + Math.exp(2 * x)), R`\dfrac{1}{2}\ln(1+e^{2x})`, [R`\ln(1+e^{2x})`, R`\dfrac{1}{1+e^{2x}}`, R`\dfrac{e^{2x}}{2}`], R`Let $u = 1+e^{2x}$, $du = 2e^{2x}dx$.`);

// ---------------- definite integrals
I(T.ftc, R`Evaluate $\displaystyle\int_0^{\pi/4}\tan x\,dx$.`, (x) => Math.tan(x), 0, Math.PI / 4, Math.log(2) / 2, R`\dfrac{1}{2}\ln2`, [R`\ln2`, R`1`, R`\dfrac{\pi}{4}`], R`$[-\ln|\cos x|]_0^{\pi/4} = -\ln\dfrac{1}{\sqrt2} = \dfrac12\ln2$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_0^1x^2e^x\,dx$.`, (x) => x * x * Math.exp(x), 0, 1, Math.E - 2, R`e-2`, [R`e-1`, R`2-e`, R`\dfrac{e}{3}`], R`$[e^x(x^2-2x+2)]_0^1 = e-2$.`);
I(T.ftc, R`Find $\displaystyle\int_1^4\dfrac{dx}{\sqrt{x}}$.`, (x) => 1 / Math.sqrt(x), 1, 4, 2, R`2`, [R`1`, R`\dfrac{3}{2}`, R`4`], R`$[2\sqrt{x}]_1^4 = 4-2 = 2$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_0^1\dfrac{x}{(1+x^2)^2}\,dx$.`, (x) => x / (1 + x * x) ** 2, 0, 1, 0.25, R`\dfrac{1}{4}`, [R`\dfrac{1}{2}`, R`\dfrac{1}{8}`, R`\dfrac{3}{4}`], R`$\left[-\dfrac{1}{2(1+x^2)}\right]_0^1 = -\dfrac14+\dfrac12 = \dfrac14$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_{-2}^{2}(x^3+x^2)\,dx$.`, (x) => x ** 3 + x * x, -2, 2, 16 / 3, R`\dfrac{16}{3}`, [R`0`, R`\dfrac{8}{3}`, R`\dfrac{32}{3}`], R`The odd term $x^3$ integrates to $0$; $\int_{-2}^2x^2dx = \dfrac{16}{3}$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_0^{\pi/2}x\cos x\,dx$.`, (x) => x * Math.cos(x), 0, Math.PI / 2, Math.PI / 2 - 1, R`\dfrac{\pi}{2}-1`, [R`\dfrac{\pi}{2}+1`, R`1`, R`\dfrac{\pi}{2}`], R`$[x\sin x+\cos x]_0^{\pi/2} = \dfrac\pi2-1$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_0^2xe^{x^2}\,dx$.`, (x) => x * Math.exp(x * x), 0, 2, (Math.exp(4) - 1) / 2, R`\dfrac{e^4-1}{2}`, [R`e^4-1`, R`\dfrac{e^4}{2}`, R`2e^4`], R`$\left[\dfrac12e^{x^2}\right]_0^2 = \dfrac{e^4-1}{2}$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_1^e(\ln x)^2\,dx$.`, (x) => Math.log(x) ** 2, 1, Math.E, Math.E - 2, R`e-2`, [R`1`, R`e-1`, R`\dfrac{e}{2}`], R`By parts twice: $[x(\ln x)^2-2x\ln x+2x]_1^e = e-2$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_0^1\sqrt{1-x^2}\,dx$.`, (x) => Math.sqrt(1 - x * x), 0, 1, Math.PI / 4, R`\dfrac{\pi}{4}`, [R`\dfrac{\pi}{2}`, R`\dfrac{1}{2}`, R`\dfrac{2}{3}`], R`This is the area of a quarter of the unit circle, $\dfrac{\pi}{4}$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_0^{\pi/3}\sec^2x\,dx$.`, (x) => 1 / Math.cos(x) ** 2, 0, Math.PI / 3, Math.sqrt(3), R`\sqrt3`, [R`\dfrac{1}{\sqrt3}`, R`2`, R`\dfrac{\pi}{3}`], R`$[\tan x]_0^{\pi/3} = \sqrt3$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_1^2\left(x+\dfrac1x\right)^2dx$.`, (x) => (x + 1 / x) ** 2, 1, 2, 29 / 6, R`\dfrac{29}{6}`, [R`\dfrac{25}{6}`, R`5`, R`\dfrac{7}{2}`], R`$\left(x+\frac1x\right)^2 = x^2+2+\dfrac{1}{x^2}$, with antiderivative $\dfrac{x^3}{3}+2x-\dfrac1x$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_0^{\ln2}e^x\,dx$.`, (x) => Math.exp(x), 0, Math.log(2), 1, R`1`, [R`2`, R`\ln2`, R`e`], R`$[e^x]_0^{\ln2} = 2-1 = 1$.`);
I(T.ftc, R`Evaluate the improper integral $\displaystyle\int_1^\infty\dfrac{dx}{x^2}$.`, (x) => 1 / (x * x), 1, 400, 1 - 1 / 400, R`1`, [R`\infty`, R`0`, R`\dfrac{1}{2}`], R`$\lim_{b\to\infty}\left[-\dfrac1x\right]_1^b = 1$.`);
I(T.ftc, R`Evaluate the improper integral $\displaystyle\int_0^\infty e^{-2x}\,dx$.`, (x) => Math.exp(-2 * x), 0, 20, 0.5, R`\dfrac{1}{2}`, [R`2`, R`1`, R`\infty`], R`$\lim_{b\to\infty}\left[-\dfrac12e^{-2x}\right]_0^b = \dfrac12$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_0^{\pi}\sin^3x\,dx$.`, (x) => Math.sin(x) ** 3, 0, Math.PI, 4 / 3, R`\dfrac{4}{3}`, [R`\dfrac{2}{3}`, R`2`, R`\dfrac{8}{3}`], R`$\int\sin^3x\,dx = -\cos x+\dfrac{\cos^3x}{3}$; between $0$ and $\pi$ this gives $\left(1-\dfrac13\right)-\left(-1+\dfrac13\right) = \dfrac43$.`);
I(T.ftc, R`Evaluate $\displaystyle\int_0^1\dfrac{x}{x^2+1}\,dx$.`, (x) => x / (x * x + 1), 0, 1, Math.log(2) / 2, R`\dfrac{1}{2}\ln2`, [R`\ln2`, R`\dfrac{\pi}{4}`, R`\dfrac{1}{2}`], R`$\left[\dfrac12\ln(x^2+1)\right]_0^1 = \dfrac12\ln2$.`);

// ---------------- areas, volumes and lengths (integrands checked)
I(T.area, R`The area enclosed between the curves $y = x^3$ and $y = x$ is:`, (x) => Math.abs(x - x ** 3), -1, 1, 0.5, R`\dfrac{1}{2}`, [R`\dfrac{1}{4}`, R`1`, R`\dfrac{1}{3}`], R`The curves meet at $x = -1, 0, 1$. Area $= 2\int_0^1(x-x^3)dx = 2\left(\dfrac12-\dfrac14\right) = \dfrac12$.`);
I(T.area, R`The area enclosed by the parabola $y^2 = 4x$ and the line $y = x$ is:`, (x) => 2 * Math.sqrt(x) - x, 0, 4, 8 / 3, R`\dfrac{8}{3}`, [R`\dfrac{16}{3}`, R`\dfrac{4}{3}`, R`8`], R`The curves meet at $x = 0$ and $x = 4$. Area $= \int_0^4(2\sqrt{x}-x)dx = \dfrac{32}{3}-8 = \dfrac83$.`);
I(T.area, R`The area bounded by the curve $y = \dfrac{1}{x}$, the $x$-axis and the lines $x = 1$ and $x = e$ is:`, (x) => 1 / x, 1, Math.E, 1, R`1`, [R`e`, R`e-1`, R`\dfrac{1}{e}`], R`Area $= \int_1^e\dfrac{dx}{x} = [\ln x]_1^e = 1$.`);
I(T.disc, R`The region under $y = \dfrac{x}{2}$ from $x = 0$ to $x = 6$ is revolved about the $x$-axis. The volume of the cone generated is:`, (x) => Math.PI * (x / 2) ** 2, 0, 6, 18 * Math.PI, R`18\pi`, [R`9\pi`, R`36\pi`, R`6\pi`], R`$V = \pi\int_0^6\dfrac{x^2}{4}dx = \pi\left[\dfrac{x^3}{12}\right]_0^6 = 18\pi$.`);
I(T.disc, R`The region under $y = \sin x$ from $x = 0$ to $x = \pi$ is revolved about the $x$-axis. The volume generated is:`, (x) => Math.PI * Math.sin(x) ** 2, 0, Math.PI, Math.PI ** 2 / 2, R`\dfrac{\pi^2}{2}`, [R`\pi^2`, R`\dfrac{\pi}{2}`, R`2\pi`], R`$V = \pi\int_0^\pi\sin^2x\,dx = \pi\cdot\dfrac\pi2$.`);
I(T.disc, R`The region under $y = e^x$ from $x = 0$ to $x = 1$ is revolved about the $x$-axis. The volume generated is:`, (x) => Math.PI * Math.exp(2 * x), 0, 1, Math.PI * (Math.exp(2) - 1) / 2, R`\dfrac{\pi(e^2-1)}{2}`, [R`\pi(e-1)`, R`\dfrac{\pi e^2}{2}`, R`\pi(e^2-1)`], R`$V = \pi\int_0^1e^{2x}dx = \dfrac{\pi}{2}(e^2-1)$.`);
I(T.shell, R`The region between $y = x(2-x)$ and the $x$-axis is revolved about the $y$-axis. By the shell method the volume is:`, (x) => 2 * Math.PI * x * x * (2 - x), 0, 2, 8 * Math.PI / 3, R`\dfrac{8\pi}{3}`, [R`\dfrac{16\pi}{3}`, R`\dfrac{4\pi}{3}`, R`8\pi`], R`$V = 2\pi\int_0^2x\cdot x(2-x)dx = 2\pi\left(\dfrac{16}{3}-4\right) = \dfrac{8\pi}{3}$.`);
I(T.len, R`The length of the curve $y = \dfrac{x^2}{4}-\dfrac{1}{2}\ln x$ from $x = 1$ to $x = 2$ is:`, (x) => x / 2 + 1 / (2 * x), 1, 2, 0.75 + Math.log(2) / 2, R`\dfrac{3}{4}+\dfrac{1}{2}\ln2`, [R`\dfrac{3}{4}-\dfrac{1}{2}\ln2`, R`\dfrac{3}{2}+\ln2`, R`\dfrac{5}{4}`], R`$1+y'^2 = \left(\dfrac x2+\dfrac{1}{2x}\right)^2$, so $L = \int_1^2\left(\dfrac x2+\dfrac{1}{2x}\right)dx = \dfrac34+\dfrac12\ln2$.`);
I(T.len, R`The length of the curve $y = \dfrac{x^3}{3}+\dfrac{1}{4x}$ from $x = 1$ to $x = 2$ is:`, (x) => x * x + 1 / (4 * x * x), 1, 2, 59 / 24, R`\dfrac{59}{24}`, [R`\dfrac{7}{3}`, R`\dfrac{61}{24}`, R`\dfrac{5}{2}`], R`$y' = x^2-\dfrac{1}{4x^2}$ and $1+y'^2 = \left(x^2+\dfrac{1}{4x^2}\right)^2$, so $L = \left[\dfrac{x^3}{3}-\dfrac{1}{4x}\right]_1^2 = \dfrac{59}{24}$.`);
I(T.avg, R`The average value of $f(x) = \sin x$ on $[0, \pi]$ is:`, (x) => Math.sin(x) / Math.PI, 0, Math.PI, 2 / Math.PI, R`\dfrac{2}{\pi}`, [R`\dfrac{1}{\pi}`, R`2`, R`\dfrac{\pi}{2}`], R`Average $= \dfrac{1}{\pi}\int_0^\pi\sin x\,dx = \dfrac{2}{\pi}$.`);

module.exports = out;
