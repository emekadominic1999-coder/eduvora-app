// MTH 103 (Calculus) - hand-set questions, part B: integration and its applications.
// Antiderivatives are checked by differentiating; definite integrals are checked by Simpson's rule.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { anti: 'Antiderivatives of Some Elementary Functions', sub: 'Method of Substitution', parts: 'Integration by Parts', pf: 'Method of Partial Fractions', ftc: 'Fundamental Theorem of Integral Calculus', area: 'Areas of Plane Regions', disc: 'The Disc Method', shell: 'The Shell Method', len: 'Lengths of Curves', avg: 'Areas and Riemann Sums' };
const num = (f, x) => (f(x + 1e-5) - f(x - 1e-5)) / 2e-5;
const near = (a, b, tol = 1e-4) => Math.abs(a - b) <= tol * Math.max(1, Math.abs(b));
const simpson = (f, a, b, n = 4000) => { const h = (b - a) / n; let s = f(a) + f(b); for (let i = 1; i < n; i++) s += f(a + i * h) * (i % 2 ? 4 : 2); return s * h / 3; };
function A(topic, integrandTex, f, F, correct, wrongs, expl, stem) {
  for (const x of [0.6, 1.1, 1.7, 2.3]) if (!near(num(F, x), f(x))) throw new Error('antiderivative check failed for ' + integrandTex);
  add(stem || R`Evaluate $\displaystyle\int ${integrandTex}\,dx$.`, '$' + correct + '+C$', wrongs.map((w) => '$' + w + '+C$'), expl, topic);
}
function I(topic, tex, f, a, b, value, correct, wrongs, expl, stem) {
  if (!near(simpson(f, a, b), value, 1e-6)) throw new Error('definite integral check failed for ' + tex + ': ' + simpson(f, a, b) + ' vs ' + value);
  add(stem || R`Evaluate $\displaystyle\int_{${a}}^{${b}} ${tex}\,dx$.`, '$' + correct + '$', wrongs.map((w) => '$' + w + '$'), expl, topic);
}

// ------------------------------------------------------------- indefinite integrals
A(T.sub, R`xe^{x^2}`, (x) => x * Math.exp(x * x), (x) => 0.5 * Math.exp(x * x), R`\dfrac{1}{2}e^{x^2}`, [R`e^{x^2}`, R`2e^{x^2}`, R`\dfrac{x^2}{2}e^{x^2}`], R`Let $u = x^2$; then $x\,dx = \dfrac{du}{2}$ and the integral is $\dfrac12\int e^u\,du$.`);
A(T.sub, R`\sin^3x`, (x) => Math.sin(x) ** 3, (x) => -Math.cos(x) + Math.cos(x) ** 3 / 3, R`-\cos x+\dfrac{\cos^3x}{3}`, [R`\dfrac{\sin^4x}{4}`, R`-\cos x-\dfrac{\cos^3x}{3}`, R`\cos x-\dfrac{\cos^3x}{3}`], R`Write $\sin^3x = \sin x(1-\cos^2x)$ and let $u = \cos x$.`);
A(T.sub, R`\dfrac{x}{\sqrt{x^2+1}}`, (x) => x / Math.sqrt(x * x + 1), (x) => Math.sqrt(x * x + 1), R`\sqrt{x^2+1}`, [R`\dfrac{1}{2}\sqrt{x^2+1}`, R`2\sqrt{x^2+1}`, R`\ln(x^2+1)`], R`Let $u = x^2+1$, so $x\,dx = \dfrac{du}{2}$: $\dfrac12\int u^{-1/2}du = \sqrt{u}$.`);
A(T.sub, R`\dfrac{2x+3}{x^2+3x+5}`, (x) => (2 * x + 3) / (x * x + 3 * x + 5), (x) => Math.log(x * x + 3 * x + 5), R`\ln(x^2+3x+5)`, [R`\dfrac{1}{x^2+3x+5}`, R`\ln|2x+3|`, R`2\ln(x^2+3x+5)`], R`The numerator is the derivative of the denominator, so the integral is $\ln|x^2+3x+5|$.`);
A(T.sub, R`\sec^2x\tan x`, (x) => Math.tan(x) / Math.cos(x) ** 2, (x) => 0.5 * Math.tan(x) ** 2, R`\dfrac{1}{2}\tan^2x`, [R`\dfrac{1}{2}\sec^2x`, R`\tan^2x`, R`\dfrac{1}{3}\tan^3x`], R`Let $u = \tan x$, $du = \sec^2x\,dx$: $\int u\,du = \dfrac{u^2}{2}$.`);
A(T.sub, R`\dfrac{1}{x^2+4}`, (x) => 1 / (x * x + 4), (x) => 0.5 * Math.atan(x / 2), R`\dfrac{1}{2}\tan^{-1}\left(\dfrac{x}{2}\right)`, [R`\tan^{-1}\left(\dfrac{x}{2}\right)`, R`\dfrac{1}{4}\tan^{-1}x`, R`\dfrac{1}{2}\ln(x^2+4)`], R`$\int\dfrac{dx}{x^2+a^2} = \dfrac1a\tan^{-1}\dfrac xa$ with $a = 2$.`);
A(T.sub, R`\dfrac{1}{\sqrt{9-x^2}}`, (x) => 1 / Math.sqrt(9 - x * x), (x) => Math.asin(x / 3), R`\sin^{-1}\left(\dfrac{x}{3}\right)`, [R`\dfrac{1}{3}\sin^{-1}\left(\dfrac{x}{3}\right)`, R`\sin^{-1}x`, R`\cos^{-1}\left(\dfrac{x}{3}\right)`], R`$\int\dfrac{dx}{\sqrt{a^2-x^2}} = \sin^{-1}\dfrac xa$ with $a = 3$.`);
A(T.sub, R`\cos^2x`, (x) => Math.cos(x) ** 2, (x) => x / 2 + Math.sin(2 * x) / 4, R`\dfrac{x}{2}+\dfrac{\sin 2x}{4}`, [R`\dfrac{\cos^3x}{3}`, R`\dfrac{x}{2}-\dfrac{\sin 2x}{4}`, R`\dfrac{\sin 2x}{2}`], R`Use $\cos^2x = \dfrac{1+\cos 2x}{2}$.`);
A(T.sub, R`\dfrac{e^x}{1+e^x}`, (x) => Math.exp(x) / (1 + Math.exp(x)), (x) => Math.log(1 + Math.exp(x)), R`\ln(1+e^x)`, [R`\dfrac{1}{1+e^x}`, R`\ln e^x`, R`\tan^{-1}(e^x)`], R`Let $u = 1+e^x$; then $du = e^x\,dx$.`);
A(T.sub, R`\dfrac{\ln x}{x}`, (x) => Math.log(x) / x, (x) => 0.5 * Math.log(x) ** 2, R`\dfrac{1}{2}(\ln x)^2`, [R`\ln(\ln x)`, R`(\ln x)^2`, R`\dfrac{1}{x^2}`], R`Let $u = \ln x$, $du = \dfrac{dx}{x}$.`);
A(T.parts, R`x\sin x`, (x) => x * Math.sin(x), (x) => Math.sin(x) - x * Math.cos(x), R`\sin x-x\cos x`, [R`x\cos x-\sin x`, R`\sin x+x\cos x`, R`-x\cos x`], R`By parts with $u = x$, $dv = \sin x\,dx$: $-x\cos x+\int\cos x\,dx$.`);
A(T.parts, R`x\ln x`, (x) => x * Math.log(x), (x) => x * x / 2 * Math.log(x) - x * x / 4, R`\dfrac{x^2}{2}\ln x-\dfrac{x^2}{4}`, [R`\dfrac{x^2}{2}\ln x-\dfrac{x^2}{2}`, R`x\ln x-x`, R`\dfrac{x^2}{2}\ln x+\dfrac{x^2}{4}`], R`By parts with $u = \ln x$, $dv = x\,dx$: $\dfrac{x^2}{2}\ln x-\int\dfrac{x}{2}dx$.`);
A(T.parts, R`x^2e^x`, (x) => x * x * Math.exp(x), (x) => Math.exp(x) * (x * x - 2 * x + 2), R`e^x(x^2-2x+2)`, [R`e^x(x^2+2x+2)`, R`e^x(x^2-2x)`, R`\dfrac{x^3}{3}e^x`], R`Integrate by parts twice: $x^2e^x-2\int xe^x\,dx = x^2e^x-2xe^x+2e^x$.`);
A(T.parts, R`\ln x`, (x) => Math.log(x), (x) => x * Math.log(x) - x, R`x\ln x-x`, [R`x\ln x+x`, R`\dfrac{1}{x}`, R`x\ln x`], R`By parts with $u = \ln x$, $dv = dx$: $x\ln x-\int dx$.`);
A(T.parts, R`e^x\sin x`, (x) => Math.exp(x) * Math.sin(x), (x) => Math.exp(x) * (Math.sin(x) - Math.cos(x)) / 2, R`\dfrac{e^x(\sin x-\cos x)}{2}`, [R`\dfrac{e^x(\sin x+\cos x)}{2}`, R`e^x(\sin x-\cos x)`, R`-e^x\cos x`], R`Integrating by parts twice returns the original integral: $2I = e^x(\sin x-\cos x)$.`);
A(T.parts, R`\tan^{-1}x`, (x) => Math.atan(x), (x) => x * Math.atan(x) - 0.5 * Math.log(1 + x * x), R`x\tan^{-1}x-\dfrac{1}{2}\ln(1+x^2)`, [R`x\tan^{-1}x+\dfrac{1}{2}\ln(1+x^2)`, R`\dfrac{1}{1+x^2}`, R`x\tan^{-1}x-\ln(1+x^2)`], R`By parts with $u = \tan^{-1}x$, $dv = dx$: $x\tan^{-1}x-\int\dfrac{x}{1+x^2}dx$.`);
A(T.pf, R`\dfrac{1}{x^2-1}`, (x) => 1 / (x * x - 1), (x) => 0.5 * Math.log(Math.abs((x - 1) / (x + 1))), R`\dfrac{1}{2}\ln\left|\dfrac{x-1}{x+1}\right|`, [R`\dfrac{1}{2}\ln\left|\dfrac{x+1}{x-1}\right|`, R`\ln|x^2-1|`, R`\dfrac{1}{2}\ln|x^2-1|`], R`$\dfrac{1}{x^2-1} = \dfrac12\left(\dfrac{1}{x-1}-\dfrac{1}{x+1}\right)$.`);
A(T.pf, R`\dfrac{1}{x(x+1)}`, (x) => 1 / (x * (x + 1)), (x) => Math.log(x / (x + 1)), R`\ln\left|\dfrac{x}{x+1}\right|`, [R`\ln|x(x+1)|`, R`\ln\left|\dfrac{x+1}{x}\right|`, R`\dfrac{1}{2}\ln|x(x+1)|`], R`$\dfrac{1}{x(x+1)} = \dfrac1x-\dfrac1{x+1}$.`);
A(T.pf, R`\dfrac{3x+5}{(x+1)(x+3)}`, (x) => (3 * x + 5) / ((x + 1) * (x + 3)), (x) => Math.log(x + 1) + 2 * Math.log(x + 3), R`\ln|x+1|+2\ln|x+3|`, [R`2\ln|x+1|+\ln|x+3|`, R`\ln|(x+1)(x+3)|`, R`\ln|x+1|-2\ln|x+3|`], R`$\dfrac{3x+5}{(x+1)(x+3)} = \dfrac{1}{x+1}+\dfrac{2}{x+3}$.`);

// ------------------------------------------------------------- definite integrals
I(T.ftc, R`xe^x`, (x) => x * Math.exp(x), 0, 1, 1, R`1`, [R`e-1`, R`\dfrac{e}{2}`, R`e`], R`$[xe^x-e^x]_0^1 = (e-e)-(0-1) = 1$.`);
I(T.ftc, R`\sin^2x`, (x) => Math.sin(x) ** 2, 0, Math.PI / 2, Math.PI / 4, R`\dfrac{\pi}{4}`, [R`\dfrac{\pi}{2}`, R`1`, R`\dfrac{1}{2}`], R`Using $\sin^2x = \dfrac{1-\cos2x}{2}$: $\left[\dfrac x2-\dfrac{\sin2x}{4}\right]_0^{\pi/2} = \dfrac\pi4$.`, R`Evaluate $\displaystyle\int_0^{\pi/2}\sin^2x\,dx$.`);
I(T.ftc, R`\ln x`, (x) => Math.log(x), 1, Math.E, 1, R`1`, [R`e`, R`e-1`, R`0`], R`$[x\ln x-x]_1^e = (e-e)-(0-1) = 1$.`, R`Evaluate $\displaystyle\int_1^e\ln x\,dx$.`);
I(T.ftc, R`x\sin x`, (x) => x * Math.sin(x), 0, Math.PI, Math.PI, R`\pi`, [R`0`, R`2`, R`\dfrac{\pi}{2}`], R`$[\sin x-x\cos x]_0^\pi = (0+\pi)-0 = \pi$.`, R`Evaluate $\displaystyle\int_0^\pi x\sin x\,dx$.`);
I(T.ftc, R`\dfrac{1}{1+x^2}`, (x) => 1 / (1 + x * x), 0, 1, Math.PI / 4, R`\dfrac{\pi}{4}`, [R`\dfrac{\pi}{2}`, R`1`, R`\ln2`], R`$[\tan^{-1}x]_0^1 = \dfrac\pi4$.`, R`Evaluate $\displaystyle\int_0^1\dfrac{dx}{1+x^2}$.`);
I(T.ftc, R`x\sqrt{1+x^2}`, (x) => x * Math.sqrt(1 + x * x), 0, 1, (2 * Math.SQRT2 - 1) / 3, R`\dfrac{2\sqrt2-1}{3}`, [R`\dfrac{2\sqrt2}{3}`, R`\dfrac{\sqrt2-1}{3}`, R`\sqrt2-1`], R`Let $u = 1+x^2$: $\dfrac12\int_1^2u^{1/2}du = \dfrac13\left(2^{3/2}-1\right)$.`, R`Evaluate $\displaystyle\int_0^1x\sqrt{1+x^2}\,dx$.`);
I(T.ftc, R`|x-1|`, (x) => Math.abs(x - 1), 0, 2, 1, R`1`, [R`0`, R`2`, R`\dfrac{1}{2}`], R`Split at $x = 1$: each triangle has area $\dfrac12$, so the total is $1$.`, R`Evaluate $\displaystyle\int_0^2|x-1|\,dx$.`);
I(T.ftc, R`\dfrac{1}{x}`, (x) => 1 / x, 1, 2, Math.LN2, R`\ln 2`, [R`\dfrac{1}{2}`, R`\ln\dfrac{1}{2}`, R`1`], R`$[\ln x]_1^2 = \ln2$.`, R`Evaluate $\displaystyle\int_1^2\dfrac{dx}{x}$.`);
I(T.ftc, R`\dfrac{2x}{x^2+1}`, (x) => 2 * x / (x * x + 1), 0, 1, Math.LN2, R`\ln2`, [R`2\ln2`, R`1`, R`\dfrac{\pi}{4}`], R`$[\ln(x^2+1)]_0^1 = \ln2$.`, R`Evaluate $\displaystyle\int_0^1\dfrac{2x}{x^2+1}\,dx$.`);
I(T.ftc, R`\cos^3x`, (x) => Math.cos(x) ** 3, 0, Math.PI / 2, 2 / 3, R`\dfrac{2}{3}`, [R`\dfrac{1}{3}`, R`1`, R`\dfrac{3}{4}`], R`$\int\cos^3x\,dx = \sin x-\dfrac{\sin^3x}{3}$, which gives $1-\dfrac13 = \dfrac23$ on $[0,\pi/2]$.`, R`Evaluate $\displaystyle\int_0^{\pi/2}\cos^3x\,dx$.`);
add(R`The average value of $f(x) = x^2$ on the interval $[0, 3]$ is:`, R`$3$`, [R`$9$`, R`$\dfrac{9}{2}$`, R`$\dfrac{3}{2}$`], R`Average $= \dfrac{1}{3}\int_0^3x^2dx = \dfrac{1}{3}\cdot9 = 3$.`, T.avg);
add(R`If $F(x) = \displaystyle\int_1^x\ln t\,dt$, then $F'(e)$ is:`, R`$1$`, [R`$e$`, R`$0$`, R`$\dfrac{1}{e}$`], R`By the fundamental theorem of calculus, $F'(x) = \ln x$, so $F'(e) = 1$.`, T.ftc);
add(R`If $\displaystyle\int_0^3f(x)\,dx = 5$ and $\displaystyle\int_0^3g(x)\,dx = 2$, then $\displaystyle\int_0^3[2f(x)-3g(x)]\,dx$ is:`, R`$4$`, [R`$16$`, R`$-1$`, R`$1$`], R`By linearity, $2(5)-3(2) = 4$.`, T.ftc);

// ------------------------------------------------------------- areas, volumes, lengths
add(R`The area enclosed between the curves $y = x^2$ and $y = x$ is:`, R`$\dfrac{1}{6}$`, [R`$\dfrac{1}{3}$`, R`$\dfrac{1}{2}$`, R`$\dfrac{1}{12}$`], R`The curves meet at $x = 0$ and $x = 1$. Area $= \int_0^1(x-x^2)dx = \dfrac12-\dfrac13 = \dfrac16$.`, T.area);
add(R`The area enclosed between the parabola $y = x^2$ and the line $y = 4$ is:`, R`$\dfrac{32}{3}$`, [R`$\dfrac{16}{3}$`, R`$\dfrac{64}{3}$`, R`$8$`], R`Area $= \int_{-2}^{2}(4-x^2)dx = 2\left(8-\dfrac83\right) = \dfrac{32}{3}$.`, T.area);
add(R`The area under the curve $y = \sin x$ from $x = 0$ to $x = \pi$ is:`, R`$2$`, [R`$1$`, R`$\pi$`, R`$0$`], R`$\int_0^\pi\sin x\,dx = [-\cos x]_0^\pi = 1+1 = 2$.`, T.area);
add(R`The area between $y = \cos x$ and $y = \sin x$ from $x = 0$ to $x = \dfrac{\pi}{4}$ is:`, R`$\sqrt2-1$`, [R`$1-\sqrt2$`, R`$\dfrac{\sqrt2}{2}$`, R`$\sqrt2$`], R`$\int_0^{\pi/4}(\cos x-\sin x)dx = [\sin x+\cos x]_0^{\pi/4} = \sqrt2-1$.`, T.area);
add(R`The area enclosed by the curve $y = x^3-x$ and the $x$-axis between $x = -1$ and $x = 1$ is:`, R`$\dfrac{1}{2}$`, [R`$0$`, R`$1$`, R`$\dfrac{1}{4}$`], R`The curve is odd, so the signed integral is $0$; the area is $2\int_0^1(x-x^3)dx = 2\left(\dfrac12-\dfrac14\right) = \dfrac12$.`, T.area);
add(R`The region under $y = \sqrt{x}$ from $x = 0$ to $x = 4$ is revolved about the $x$-axis. The volume generated is:`, R`$8\pi$`, [R`$16\pi$`, R`$\dfrac{16\pi}{3}$`, R`$4\pi$`], R`Disc method: $V = \pi\int_0^4x\,dx = \pi\cdot8 = 8\pi$.`, T.disc);
add(R`The region bounded by $y = x^2$, the $y$-axis and the line $y = 4$ is revolved about the $y$-axis. The volume generated is:`, R`$8\pi$`, [R`$16\pi$`, R`$\dfrac{32\pi}{5}$`, R`$4\pi$`], R`Disc method in $y$: $V = \pi\int_0^4y\,dy = 8\pi$.`, T.disc);
add(R`The region under $y = x^2$ from $x = 0$ to $x = 2$ is revolved about the $x$-axis. The volume generated is:`, R`$\dfrac{32\pi}{5}$`, [R`$\dfrac{8\pi}{3}$`, R`$\dfrac{16\pi}{3}$`, R`$\dfrac{32\pi}{3}$`], R`$V = \pi\int_0^2x^4dx = \pi\cdot\dfrac{32}{5}$.`, T.disc);
add(R`The region under $y = x^2$ from $x = 0$ to $x = 2$ is revolved about the $y$-axis. By the shell method the volume is:`, R`$8\pi$`, [R`$16\pi$`, R`$4\pi$`, R`$\dfrac{32\pi}{5}$`], R`$V = 2\pi\int_0^2x\cdot x^2dx = 2\pi\cdot4 = 8\pi$.`, T.shell);
add(R`The length of the curve $y = \dfrac{2}{3}x^{3/2}$ from $x = 0$ to $x = 3$ is:`, R`$\dfrac{14}{3}$`, [R`$\dfrac{16}{3}$`, R`$6$`, R`$\dfrac{2}{3}\sqrt{27}$`], R`$y' = x^{1/2}$ so $L = \int_0^3\sqrt{1+x}\,dx = \dfrac23\left[(1+x)^{3/2}\right]_0^3 = \dfrac23(8-1) = \dfrac{14}{3}$.`, T.len);

module.exports = out;
