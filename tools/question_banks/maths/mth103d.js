// MTH 103 - batch D: limits, continuity, curve sketching, optimisation, related rates, kinematics, approximation.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { lim: 'Limits of Polynomial and Rational Functions', lhop: 'Indeterminate Forms and L\'Hopital\'s Rule', inf: 'Limit at Infinity', trig: 'Limits of Trigonometric Functions', cont: 'Continuous Functions', ext: 'Extrema of a Function', con: 'Concavity and Points of Inflection', mono: 'Monotonicity of a Function', opt: 'Maxima and Minima', rel: 'Related Rates', vel: 'Velocity and Acceleration', lin: 'Linear Approximation and Differentials', mvt: 'Rolle\'s Theorem and the Mean Value Theorem', asy: 'Asymptotes of a Curve', tang: 'Tangents and Normals', ft: 'Real-valued Functions of a Real Variable', inv: 'The Inverse of a Function' };
const chk = (a, b, tol = 1e-6) => { if (Math.abs(a - b) > tol * Math.max(1, Math.abs(b))) throw new Error('check failed: ' + a + ' vs ' + b); };
const argmax = (f, a, b, n = 200000) => { let bx = a, bv = -Infinity; for (let i = 0; i <= n; i++) { const x = a + (b - a) * i / n, v = f(x); if (v > bv) { bv = v; bx = x; } } return [bx, bv]; };
const argmin = (f, a, b) => { const [x, v] = argmax((t) => -f(t), a, b); return [x, -v]; };
const limAt = (f, a) => (f(a + 1e-5) + f(a - 1e-5)) / 2;

// ---------------- limits (numerically verified)
chk(limAt((x) => (Math.exp(2 * x) - 1) / x, 0), 2, 1e-3);
add(R`Evaluate $\displaystyle\lim_{x\to0}\dfrac{e^{2x}-1}{x}$.`, R`$2$`, [R`$1$`, R`$0$`, R`$\dfrac12$`], R`Apply L'Hôpital's rule: $\dfrac{2e^{2x}}{1}\to2$.`, T.lhop);
chk(limAt((x) => (1 - Math.cos(x)) / (x * x), 0), 0.5, 1e-3);
add(R`Evaluate $\displaystyle\lim_{x\to0}\dfrac{1-\cos x}{x^2}$.`, R`$\dfrac12$`, [R`$1$`, R`$0$`, R`$2$`], R`Use $1-\cos x = 2\sin^2\dfrac x2$, or apply L'Hôpital's rule twice: $\dfrac{\sin x}{2x}\to\dfrac12$.`, T.trig);
chk(limAt((x) => Math.log(x) / (x - 1), 1), 1, 1e-3);
add(R`Evaluate $\displaystyle\lim_{x\to1}\dfrac{\ln x}{x-1}$.`, R`$1$`, [R`$0$`, R`$e$`, R`$\infty$`], R`This is the derivative of $\ln x$ at $x = 1$, which is $\dfrac11 = 1$.`, T.lhop);
add(R`Evaluate $\displaystyle\lim_{x\to\infty}\dfrac{\ln x}{\sqrt{x}}$.`, R`$0$`, [R`$1$`, R`$\infty$`, R`$\dfrac12$`], R`By L'Hôpital's rule: $\dfrac{1/x}{1/(2\sqrt x)} = \dfrac{2}{\sqrt x}\to0$. Powers grow faster than logarithms.`, T.lhop);
add(R`Evaluate $\displaystyle\lim_{x\to\infty}x^2e^{-x}$.`, R`$0$`, [R`$\infty$`, R`$1$`, R`$2$`], R`Write it as $\dfrac{x^2}{e^x}$ and apply L'Hôpital's rule twice: $\dfrac{2}{e^x}\to0$.`, T.lhop);
add(R`Evaluate $\displaystyle\lim_{x\to0}\dfrac{\sin x-x\cos x}{x^3}$.`, R`$\dfrac13$`, [R`$\dfrac16$`, R`$0$`, R`$\dfrac12$`], R`L'Hôpital's rule: $\dfrac{x\sin x}{3x^2}=\dfrac{\sin x}{3x}\to\dfrac13$.`, T.lhop);
chk(limAt((x) => (Math.sin(x) - x * Math.cos(x)) / (x * x * x), 0), 1 / 3, 1e-3);
add(R`Evaluate $\displaystyle\lim_{x\to\infty}\left(\dfrac{x+1}{x-1}\right)^x$.`, R`$e^2$`, [R`$e$`, R`$1$`, R`$e^{1/2}$`], R`$\ln L = \lim x\ln\dfrac{x+1}{x-1} = \lim\dfrac{2x}{x}\cdot\dfrac{\ln(1+2/(x-1))}{2/(x-1)}\cdot\dfrac{1}{1}\to2$, so $L = e^2$.`, T.inf);
chk(Math.pow((1e6 + 1) / (1e6 - 1), 1e6), Math.exp(2), 1e-3);
add(R`Evaluate $\displaystyle\lim_{x\to0}(1+2x)^{1/x}$.`, R`$e^2$`, [R`$e$`, R`$2$`, R`$1$`], R`$\ln L = \lim\dfrac{\ln(1+2x)}{x} = 2$, so $L = e^2$.`, T.lhop);
add(R`Evaluate $\displaystyle\lim_{x\to0^+}x^x$.`, R`$1$`, [R`$0$`, R`$e$`, R`$\infty$`], R`$\ln(x^x) = x\ln x\to0$, so the limit is $e^0 = 1$.`, T.lhop);
chk(Math.pow(1e-9, 1e-9), 1, 1e-6);
add(R`Evaluate $\displaystyle\lim_{x\to2}\dfrac{x^2-4}{x^2-5x+6}$.`, R`$-4$`, [R`$4$`, R`$0$`, R`$\text{does not exist}$`], R`Factorise: $\dfrac{(x-2)(x+2)}{(x-2)(x-3)}\to\dfrac{4}{-1} = -4$.`, T.lim);
add(R`Evaluate $\displaystyle\lim_{x\to\infty}\dfrac{\sqrt{x^2+1}}{3x+2}$.`, R`$\dfrac13$`, [R`$0$`, R`$\infty$`, R`$1$`], R`Divide by $x$: $\dfrac{\sqrt{1+1/x^2}}{3+2/x}\to\dfrac13$.`, T.inf);
add(R`Evaluate $\displaystyle\lim_{x\to0}\dfrac{\tan3x}{\sin5x}$.`, R`$\dfrac35$`, [R`$\dfrac53$`, R`$15$`, R`$1$`], R`$\dfrac{\tan3x}{3x}\cdot\dfrac{5x}{\sin5x}\cdot\dfrac{3}{5}\to\dfrac35$.`, T.trig);
add(R`The function $f(x) = \begin{cases}x^2+k, & x<1\\ 3x-1, & x\ge1\end{cases}$ is continuous at $x = 1$ when $k$ equals:`, R`$1$`, [R`$2$`, R`$0$`, R`$-1$`], R`Equate the left limit $1+k$ with $f(1) = 2$: $k = 1$.`, T.cont);
add(R`The function $f(x) = \dfrac{x^2-9}{x-3}$ for $x\ne3$ is made continuous at $x = 3$ by defining $f(3)$ to be:`, R`$6$`, [R`$0$`, R`$3$`, R`$9$`], R`For $x\ne3$, $f(x) = x+3$, whose limit as $x\to3$ is $6$.`, T.cont);
add(R`The discontinuity of $f(x) = \dfrac{1}{x-2}$ at $x = 2$ is:`, R`An infinite discontinuity`, [R`A removable discontinuity`, R`A jump discontinuity`, R`No discontinuity`], R`The function becomes unbounded near $x = 2$, giving a vertical asymptote.`, T.cont);
add(R`The function $f(x) = \dfrac{|x|}{x}$ has at $x = 0$:`, R`A jump discontinuity`, [R`A removable discontinuity`, R`An infinite discontinuity`, R`A continuous point`], R`$f(x) = 1$ for $x>0$ and $-1$ for $x<0$, so the one-sided limits differ.`, T.cont);

// ---------------- curve sketching
add(R`The function $f(x) = x^4-4x^3$ has a point of inflection at $x =$:`, R`$0$ and $2$`, [R`$0$ and $3$`, R`$2$ only`, R`$3$ only`], R`$f'' = 12x^2-24x = 12x(x-2)$ changes sign at $x = 0$ and $x = 2$.`, T.con);
add(R`The function $f(x) = 2x^3-9x^2+12x$ is decreasing on the interval:`, R`$(1, 2)$`, [R`$(2,\infty)$`, R`$(-\infty, 1)$`, R`$(0, 1)$`], R`$f'(x) = 6(x-1)(x-2)<0$ for $1<x<2$.`, T.mono);
add(R`The function $f(x) = x^3-3x^2$ is concave upward for:`, R`$x>1$`, [R`$x<1$`, R`$x>2$`, R`$x<0$`], R`$f'' = 6x-6>0$ when $x>1$.`, T.con);
add(R`The local minimum value of $f(x) = x+\dfrac{4}{x}$ for $x>0$ is:`, R`$4$`, [R`$2$`, R`$5$`, R`$8$`], R`$f' = 1-\dfrac{4}{x^2} = 0$ gives $x = 2$, and $f(2) = 2+2 = 4$.`, T.ext);
add(R`The function $f(x) = x^2e^{-x}$ has a local maximum at:`, R`$x = 2$`, [R`$x = 0$`, R`$x = 1$`, R`$x = e$`], R`$f' = e^{-x}(2x-x^2) = 0$ gives $x = 0$ or $2$; $f''(2)<0$ so $x = 2$ is a maximum.`, T.ext);
add(R`The absolute minimum value of $f(x) = x^2-4x+7$ on $[0, 5]$ is:`, R`$3$`, [R`$7$`, R`$12$`, R`$0$`], R`The vertex is at $x = 2$, with $f(2) = 3$.`, T.ext);
add(R`The vertical and horizontal asymptotes of $y = \dfrac{2x+1}{x-3}$ are respectively:`, R`$x = 3$ and $y = 2$`, [R`$x = 2$ and $y = 3$`, R`$x = -3$ and $y = 2$`, R`$x = 3$ and $y = 1$`], R`The denominator vanishes at $x = 3$; as $x\to\pm\infty$, $y\to2$.`, T.asy);
add(R`The curve $y = \dfrac{x^2}{x^2-4}$ has vertical asymptotes at:`, R`$x = 2$ and $x = -2$`, [R`$x = 4$ only`, R`$x = 0$`, R`$y = 1$`], R`The denominator is zero at $x = \pm2$ where the numerator is non-zero.`, T.asy);
add(R`The function $f(x) = x^3-12x$ has local extreme values at $x =$:`, R`$-2$ and $2$`, [R`$0$ and $2$`, R`$-4$ and $4$`, R`$2$ only`], R`$f'(x) = 3x^2-12 = 0$ gives $x = \pm2$.`, T.ext);
add(R`The critical points of $f(x) = x^{2/3}$ occur at:`, R`$x = 0$`, [R`$x = 1$`, R`$x = \dfrac23$`, R`No critical point`], R`$f'(x) = \dfrac{2}{3}x^{-1/3}$ is undefined at $x = 0$, so $x = 0$ is a critical point (a cusp, where the function has a minimum).`, T.ext);

// ---------------- optimisation, verified numerically
{ const [x, v] = argmax((s) => s * (100 - 2 * s), 0, 50); chk(v, 1250, 1e-6); }
add(R`A rectangular pen is to be built with $100$ m of fencing. The largest possible area is:`, R`$625$ m²`, [R`$1250$ m²`, R`$500$ m²`, R`$2500$ m²`], R`With sides $x$ and $50-x$ the area $x(50-x)$ is greatest at $x = 25$, giving $625$.`, T.opt);
{ const [x, v] = argmin((r) => 2 * Math.PI * r * r + 2000 / r, 0.5, 20); chk(x, Math.cbrt(500 / Math.PI), 1e-3); }
add(R`A closed cylindrical can is to hold $1000$ cm³. The radius that minimises the surface area is:`, R`$\sqrt[3]{\dfrac{500}{\pi}}$ cm`, [R`$\sqrt[3]{\dfrac{1000}{\pi}}$ cm`, R`$\sqrt{\dfrac{500}{\pi}}$ cm`, R`$\sqrt[3]{\dfrac{250}{\pi}}$ cm`], R`$S = 2\pi r^2+\dfrac{2000}{r}$; $S' = 4\pi r-\dfrac{2000}{r^2} = 0$ gives $r^3 = \dfrac{500}{\pi}$.`, T.opt);
{ const [x, v] = argmax((x) => x * (1 - x * x), 0, 1); chk(v, 2 / (3 * Math.sqrt(3)), 1e-6); }
add(R`The maximum value of $f(x) = x(1-x^2)$ on $[0, 1]$ is:`, R`$\dfrac{2}{3\sqrt3}$`, [R`$\dfrac{1}{3}$`, R`$\dfrac{2}{3}$`, R`$\dfrac{1}{\sqrt3}$`], R`$f' = 1-3x^2 = 0$ at $x = \dfrac{1}{\sqrt3}$, and $f = \dfrac{1}{\sqrt3}\cdot\dfrac23 = \dfrac{2}{3\sqrt3}$.`, T.opt);
{ const [x, v] = argmax((x) => (6 - x) * x * 1, 0, 6); chk(x, 3, 1e-3); }
add(R`The sum of two positive numbers is $12$. The minimum value of the sum of their squares is:`, R`$72$`, [R`$144$`, R`$36$`, R`$100$`], R`$x^2+(12-x)^2$ has derivative $4x-24 = 0$ at $x = 6$, giving $72$.`, T.opt);
{ const [x, v] = argmin((x) => Math.hypot(x, 3) + Math.hypot(10 - x, 4), 0, 10); chk(x, 30 / 7, 1e-3); }
add(R`Two points $A$ and $B$ lie on the same side of a straight road, at distances $3$ km and $4$ km from it, and their feet on the road are $10$ km apart. A path from $A$ to $B$ must touch the road. The shortest such path touches the road at a distance from the foot of $A$ of:`, R`$\dfrac{30}{7}$ km`, [R`$5$ km`, R`$\dfrac{10}{3}$ km`, R`$6$ km`], R`By reflection, the point of contact divides the base in the ratio $3:4$, so the distance is $\dfrac37\times10 = \dfrac{30}{7}$.`, T.opt);
add(R`The area of the largest rectangle that can be inscribed in a semicircle of radius $r$, with one side on the diameter, is:`, R`$r^2$`, [R`$\dfrac{r^2}{2}$`, R`$2r^2$`, R`$\pi r^2$`], R`With half-width $x$: $A = 2x\sqrt{r^2-x^2}$, maximised at $x = \dfrac{r}{\sqrt2}$, giving $A = r^2$.`, T.opt);

// ---------------- related rates and kinematics
add(R`Sand falls onto a conical pile whose height is always equal to its base radius. When the height is $4$ m the height is increasing at $0.5$ m/min. The volume is increasing at:`, R`$8\pi$ m³/min`, [R`$16\pi$ m³/min`, R`$4\pi$ m³/min`, R`$\dfrac{8\pi}{3}$ m³/min`], R`$V = \dfrac13\pi h^3$ (since $r = h$), so $\dfrac{dV}{dt} = \pi h^2\dfrac{dh}{dt} = \pi(16)(0.5) = 8\pi$.`, T.rel);
add(R`A $6$ ft man walks away from a $15$ ft lamp post at $4$ ft/s. The tip of his shadow moves at:`, R`$\dfrac{20}{3}$ ft/s`, [R`$4$ ft/s`, R`$\dfrac{8}{3}$ ft/s`, R`$10$ ft/s`], R`If the shadow tip is $s$ from the post and the man $x$ from it, $\dfrac{s}{15} = \dfrac{s-x}{6}$ gives $s = \dfrac53x$, so $\dfrac{ds}{dt} = \dfrac53(4) = \dfrac{20}{3}$.`, T.rel);
add(R`A circular oil slick spreads so that its radius increases at $1$ m/min. When the radius is $50$ m the area is increasing at:`, R`$100\pi$ m²/min`, [R`$50\pi$ m²/min`, R`$2500\pi$ m²/min`, R`$200\pi$ m²/min`], R`$\dfrac{dA}{dt} = 2\pi r\dfrac{dr}{dt} = 2\pi(50)(1) = 100\pi$.`, T.rel);
add(R`Two cars leave a junction, one travelling north at $60$ km/h and the other east at $80$ km/h. After $1$ hour the distance between them is increasing at:`, R`$100$ km/h`, [R`$140$ km/h`, R`$70$ km/h`, R`$20$ km/h`], R`$D^2 = x^2+y^2$ gives $\dfrac{dD}{dt} = \dfrac{x\dot x+y\dot y}{D} = \dfrac{80(80)+60(60)}{100} = 100$.`, T.rel);
add(R`A particle moves along a line so that $s = 2t^3-9t^2+12t$ (metres). Its velocity is zero at:`, R`$t = 1$ and $t = 2$`, [R`$t = 0$ and $t = 3$`, R`$t = 2$ only`, R`$t = 1$ and $t = 3$`], R`$v = 6t^2-18t+12 = 6(t-1)(t-2)$.`, T.vel);
add(R`A particle moves with $s = 2t^3-9t^2+12t$. The total distance travelled in the first $3$ seconds is:`, R`$11$ m`, [R`$9$ m`, R`$5$ m`, R`$14$ m`], R`$s(0)=0$, $s(1)=5$, $s(2)=4$, $s(3)=9$. The particle goes $0\to5$, back to $4$, then to $9$: $5+1+5 = 11$.`, T.vel);
add(R`The velocity of a particle is $v = 3t^2-12t$ and $s = 5$ when $t = 0$. The position at $t = 2$ is:`, R`$-11$`, [R`$-3$`, R`$5$`, R`$-19$`], R`Integrating, $s = t^3-6t^2+C$ and $s(0) = 5$ gives $C = 5$. So $s(2) = 8-24+5 = -11$.`, T.vel);
add(R`A stone is thrown upward and its height is $h = 20t-5t^2$ metres. The maximum height reached is:`, R`$20$ m`, [R`$40$ m`, R`$15$ m`, R`$10$ m`], R`$v = 20-10t = 0$ at $t = 2$ and $h(2) = 40-20 = 20$.`, T.vel);

// ---------------- approximation, MVT, tangents
add(R`Using differentials, an approximate value of $\sqrt[3]{27.3}$ is:`, R`$3.0111$`, [R`$3.1$`, R`$3.0333$`, R`$3.3$`], R`$f(x) = x^{1/3}$, $f'(27) = \dfrac{1}{27}$, so $\sqrt[3]{27.3}\approx3+\dfrac{0.3}{27} = 3.0111$.`, T.lin);
add(R`Using a linear approximation at $x = 0$, $\sin(0.1)$ is approximately:`, R`$0.1$`, [R`$0.01$`, R`$1$`, R`$0.0998\ (\text{exactly})$`], R`$f(x)\approx f(0)+f'(0)x = 0+\cos0\cdot x = x$, giving $0.1$.`, T.lin);
add(R`The side of a cube is measured as $5$ cm with an error of at most $0.02$ cm. The approximate maximum error in its volume is:`, R`$1.5$ cm³`, [R`$0.5$ cm³`, R`$0.06$ cm³`, R`$3$ cm³`], R`$dV = 3x^2dx = 3(25)(0.02) = 1.5$.`, T.lin);
add(R`The Mean Value Theorem for $f(x) = \sqrt{x}$ on $[1, 9]$ gives $c$ equal to:`, R`$4$`, [R`$5$`, R`$3$`, R`$2$`], R`$f'(c) = \dfrac{1}{2\sqrt c} = \dfrac{3-1}{9-1} = \dfrac14$, so $\sqrt c = 2$ and $c = 4$.`, T.mvt);
add(R`Which of the following functions satisfies the conditions of Rolle's theorem on $[-1, 1]$?`, R`$f(x) = 1-x^2$`, [R`$f(x) = |x|$`, R`$f(x) = x$`, R`$f(x) = \dfrac{1}{x}$`], R`$1-x^2$ is continuous and differentiable on $[-1,1]$ and $f(-1) = f(1) = 0$.`, T.mvt);
add(R`The tangent to the curve $y = e^x$ at the point where $x = 0$ is:`, R`$y = x+1$`, [R`$y = x$`, R`$y = e^x$`, R`$y = 2x+1$`], R`$y(0) = 1$ and $y' = e^x = 1$, so the tangent is $y = 1+x$.`, T.tang);
add(R`The normal to the curve $y = x^2$ at the point $(1, 1)$ meets the $x$-axis at:`, R`$(3, 0)$`, [R`$\left(\dfrac32, 0\right)$`, R`$(2, 0)$`, R`$(-1, 0)$`], R`The normal has gradient $-\dfrac12$: $y-1 = -\dfrac12(x-1)$. Setting $y = 0$ gives $x-1 = 2$, so $x = 3$.`, T.tang);
add(R`The curves $y = x^2$ and $y = \dfrac{1}{x}$ intersect at $(1, 1)$. The angle $\theta$ between their tangents there satisfies $\tan\theta =$:`, R`$3$`, [R`$1$`, R`$\dfrac13$`, R`$\dfrac12$`], R`The gradients at $x = 1$ are $2$ and $-1$. $\tan\theta = \left|\dfrac{2-(-1)}{1+2(-1)}\right| = \left|\dfrac{3}{-1}\right| = 3$.`, T.tang);

// ---------------- functions
add(R`If $f(x) = 2x+3$ and $g(x) = x^2$, then $(g\circ f)(x)$ is:`, R`$4x^2+12x+9$`, [R`$2x^2+3$`, R`$4x^2+9$`, R`$2x^2+6x+3$`], R`$g(f(x)) = (2x+3)^2$.`, T.ft);
add(R`The range of the function $f(x) = \dfrac{1}{1+x^2}$ is:`, R`$(0, 1]$`, [R`$[0, 1]$`, R`$(0,\infty)$`, R`$(-1, 1)$`], R`The maximum is $f(0) = 1$ and the values approach $0$ but never reach it.`, T.ft);
add(R`The inverse of the function $f(x) = e^{2x}$ is:`, R`$f^{-1}(x) = \dfrac12\ln x$`, [R`$f^{-1}(x) = 2\ln x$`, R`$f^{-1}(x) = e^{x/2}$`, R`$f^{-1}(x) = \ln(2x)$`], R`Put $y = e^{2x}$: $2x = \ln y$, so $x = \dfrac12\ln y$.`, T.inv);
add(R`The function $f(x) = x^2-4x+5$ is one-to-one on the interval:`, R`$[2,\infty)$`, [R`$(-\infty,\infty)$`, R`$[-2, 3]$`, R`$[0, 4]$`], R`The vertex is at $x = 2$, so the function is monotonic on $[2,\infty)$ and hence one-to-one there.`, T.inv);
add(R`If $f(x) = \dfrac{x}{x+1}$, then $f(f(x))$ is:`, R`$\dfrac{x}{2x+1}$`, [R`$\dfrac{x}{x+2}$`, R`$\dfrac{x^2}{(x+1)^2}$`, R`$\dfrac{2x}{x+1}$`], R`$f(f(x)) = \dfrac{\frac{x}{x+1}}{\frac{x}{x+1}+1} = \dfrac{x}{x+(x+1)} = \dfrac{x}{2x+1}$.`, T.ft);
add(R`The domain of $f(x) = \ln(x^2-4)$ is:`, R`$x<-2$ or $x>2$`, [R`$x>2$`, R`$-2<x<2$`, R`$x\ne\pm2$`], R`The argument must be positive: $x^2>4$.`, T.ft);

module.exports = out;
