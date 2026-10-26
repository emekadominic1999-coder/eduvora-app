// MTH 103 (Calculus) - batch H, after pages 48-62 of the course text "Calculus Made Easy": definite integrals, integration by
// parts, partial fractions, areas between curves, volumes of revolution and the area of a surface of revolution.
// Every explanation is numbered step by step with a "Shortcut" wherever one exists. All answers are checked numerically on load.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const M = (s) => '$' + s + '$';
const St = (...lines) => lines.join('\n');
const T = {
  di: 'Definite Integrals', sub: 'Method of Substitution', ip: 'Integration by Parts', pf: 'Method of Partial Fractions',
  ar: 'Areas of Plane Regions', vol: 'The Disc Method', sur: 'Area of a Surface of Revolution', an: 'Antiderivatives of Some Elementary Functions',
};
const chk = (a, b, tol = 1e-6) => { if (Math.abs(a - b) > tol) throw new Error('check failed ' + a + ' vs ' + b); };
const nd = (f, x) => (f(x + 1e-5) - f(x - 1e-5)) / 2e-5;
const checkInt = (F, f, xs = [0.4, 0.9, 1.6]) => { for (const x of xs) chk(nd(F, x), f(x), 1e-4 * Math.max(1, Math.abs(f(x)))); };
const simpson = (f, a, b, n = 20000) => { const h = (b - a) / n; let s = f(a) + f(b); for (let i = 1; i < n; i++) s += f(a + i * h) * (i % 2 ? 4 : 2); return s * h / 3; };
const PI = Math.PI;

// ============================================================ DEFINITE INTEGRALS
add(R`Evaluate ${M(R`\int_1^2 2x^2\,dx`)}.`, M(R`\frac{14}3`), [M(R`\frac{16}3`), M(R`\frac73`), '4'], St(
  R`Step 1: Integrate: $\int2x^2dx=\frac{2x^3}3$.`,
  R`Step 2: Write the limits: $\left[\frac{2x^3}3\right]_1^2$.`,
  R`Step 3: Upper limit $x=2$: $\frac{2\times8}3=\frac{16}3$.`,
  R`Step 4: Lower limit $x=1$: $\frac{2\times1}3=\frac23$.`,
  R`Step 5: Subtract (upper minus lower): $\frac{16}3-\frac23=\frac{14}3$.`), T.di);
chk(simpson((x) => 2 * x * x, 1, 2), 14 / 3);
add(R`Evaluate ${M(R`\int_0^{\pi/2}\sin2x\,dx`)}.`, '1', ['0', M(R`\frac12`), '2'], St(
  R`Step 1: $\int\sin2x\,dx=-\frac{\cos2x}2$ (divide by the number $2$ in front of $x$).`,
  R`Step 2: Upper limit $x=\frac\pi2$: $-\frac{\cos\pi}2=-\frac{-1}2=\frac12$.`,
  R`Step 3: Lower limit $x=0$: $-\frac{\cos0}2=-\frac12$.`,
  R`Step 4: Subtract: $\frac12-\left(-\frac12\right)=1$.`), T.di);
chk(simpson((x) => Math.sin(2 * x), 0, PI / 2), 1);
add(R`Evaluate ${M(R`\int_1^4\dfrac{7+\sqrt x}{x^2}\,dx`)}.`, M(R`\frac{25}4`), [M(R`\frac{11}4`), M(R`\frac{9}{4}`), M(R`\frac{23}{4}`)], St(
  R`Step 1: Split the fraction and write each part as a power: $\frac{7+\sqrt x}{x^2}=7x^{-2}+x^{1/2-2}=7x^{-2}+x^{-3/2}$.`,
  R`Step 2: Integrate: $\frac{7x^{-1}}{-1}+\frac{x^{-1/2}}{-1/2}=-\frac7x-\frac2{\sqrt x}$.`,
  R`Step 3: Upper limit $x=4$: $-\frac74-\frac22=-\frac74-1=-\frac{11}4$.`,
  R`Step 4: Lower limit $x=1$: $-7-2=-9$.`,
  R`Step 5: Subtract: $-\frac{11}4-(-9)=9-\frac{11}4=\frac{36-11}4=\frac{25}4$.`), T.di);
chk(simpson((x) => (7 + Math.sqrt(x)) / (x * x), 1, 4), 25 / 4, 1e-5);
add(R`Evaluate ${M(R`\int_0^1\dfrac{x+3}{x+2}\,dx`)}.`, M(R`1+\ln\frac32`), [M(R`1-\ln2`), M(R`\frac89`), M(R`\frac12`)], St(
  R`Step 1: The top and bottom have the same degree, so divide first. $x+3=(x+2)+1$.`,
  R`Step 2: $\frac{x+3}{x+2}=\frac{x+2}{x+2}+\frac1{x+2}=1+\frac1{x+2}$.`,
  R`Step 3: Integrate: $x+\ln(x+2)$.`,
  R`Step 4: Upper limit $x=1$: $1+\ln3$. Lower limit $x=0$: $0+\ln2$.`,
  R`Step 5: Subtract: $1+\ln3-\ln2=1+\ln\frac32$.`), T.di);
chk(simpson((x) => (x + 3) / (x + 2), 0, 1), 1 + Math.log(1.5));
add(R`Evaluate ${M(R`\int_0^{\ln2}e^{2x}\,dx`)}.`, M(R`\frac32`), ['0', M(R`\frac12`), '3'], St(
  R`Step 1: $\int e^{2x}dx=\frac{e^{2x}}2$ (divide by the coefficient $2$ of $x$).`,
  R`Step 2: Upper limit $x=\ln2$: $\frac{e^{2\ln2}}2=\frac{e^{\ln4}}2=\frac42=2$, because $e^{2\ln2}=e^{\ln2^2}=4$.`,
  R`Step 3: Lower limit $x=0$: $\frac{e^0}2=\frac12$.`,
  R`Step 4: Subtract: $2-\frac12=\frac32$.`), T.di);
chk(simpson((x) => Math.exp(2 * x), 0, Math.log(2)), 1.5);
add(R`Evaluate ${M(R`\int_{-3}^{1}\sqrt{3+x}\,dx`)}.`, M(R`\frac{16}3`), [M(R`\frac{2}{3}`), M(R`\frac{8}{3}`), M(R`-\frac{16}3`)], St(
  R`Step 1: Let $u=3+x$, so $du=dx$.`,
  R`Step 2: Change the limits: $x=-3\Rightarrow u=0$ and $x=1\Rightarrow u=4$.`,
  R`Step 3: $\int_0^4u^{1/2}du=\left[\frac{u^{3/2}}{3/2}\right]_0^4=\frac23\left[u^{3/2}\right]_0^4$.`,
  R`Step 4: $4^{3/2}=(\sqrt4)^3=8$, so $\frac23\times8=\frac{16}3$.`), T.sub);
chk(simpson((x) => Math.sqrt(3 + x), -3, 1), 16 / 3, 1e-5);
add(R`Evaluate ${M(R`\int_{-8}^{1}\sqrt{8+x}\,dx`)}.`, '18', ['9', '27', '12'], St(
  R`Step 1: Let $u=8+x$, so $du=dx$.`,
  R`Step 2: Limits: $x=-8\Rightarrow u=0$; $x=1\Rightarrow u=9$.`,
  R`Step 3: $\int_0^9u^{1/2}du=\frac23\left[u^{3/2}\right]_0^9=\frac23\times27=18$, since $9^{3/2}=3^3=27$.`,
  R`Shortcut: for $\int(x+a)^{1/2}dx$ the answer is $\frac23(x+a)^{3/2}$, so no substitution needs writing.`), T.sub);
chk(simpson((x) => Math.sqrt(8 + x), -8, 1), 18, 1e-5);
add(R`Evaluate ${M(R`\int_{-1}^{0}x\sqrt{x+1}\,dx`)}.`, M(R`-\frac4{15}`), [M(R`\frac4{15}`), M(R`-\frac2{5}`), M(R`\frac{2}{3}`)], St(
  R`Step 1: Let $u=x+1$. Then $x=u-1$ and $dx=du$.`,
  R`Step 2: Limits: $x=-1\Rightarrow u=0$; $x=0\Rightarrow u=1$.`,
  R`Step 3: The integral becomes $\int_0^1(u-1)\sqrt u\,du=\int_0^1\left(u^{3/2}-u^{1/2}\right)du$.`,
  R`Step 4: Integrate: $\left[\frac{u^{5/2}}{5/2}-\frac{u^{3/2}}{3/2}\right]_0^1=\frac25-\frac23$.`,
  R`Step 5: $\frac{6-10}{15}=-\frac4{15}$.`,
  R`(The text reaches the same value by integration by parts. Substitution is shorter because no second integral appears.)`), T.sub);
chk(simpson((x) => x * Math.sqrt(x + 1), -1, 0), -4 / 15, 1e-5);
add(R`Evaluate ${M(R`\int_0^{\pi/2}x\cos x\,dx`)}.`, M(R`\frac\pi2-1`), [M(R`1-\frac\pi2`), M(R`\frac\pi2+1`), M(R`\frac\pi2`)], St(
  R`Step 1: Use integration by parts, $\int u\,dv=uv-\int v\,du$, with $u=x$ and $dv=\cos x\,dx$.`,
  R`Step 2: $du=dx$ and $v=\sin x$.`,
  R`Step 3: $\int x\cos x\,dx=x\sin x-\int\sin x\,dx=x\sin x+\cos x$.`,
  R`Step 4: Upper limit $x=\frac\pi2$: $\frac\pi2(1)+0=\frac\pi2$.`,
  R`Step 5: Lower limit $x=0$: $0+1=1$.`,
  R`Step 6: Subtract: $\frac\pi2-1$.`), T.ip);
chk(simpson((x) => x * Math.cos(x), 0, PI / 2), PI / 2 - 1);
add(R`Evaluate ${M(R`\int_0^{\pi}x\sin x\,dx`)}.`, M(R`\pi`), ['0', M(R`-\pi`), M(R`\pi-1`)], St(
  R`Step 1: By parts: $u=x$, $dv=\sin x\,dx$, so $du=dx$ and $v=-\cos x$.`,
  R`Step 2: $\int x\sin x\,dx=-x\cos x+\int\cos x\,dx=-x\cos x+\sin x$.`,
  R`Step 3: Upper limit $x=\pi$: $-\pi\cos\pi+\sin\pi=-\pi(-1)+0=\pi$.`,
  R`Step 4: Lower limit $x=0$: $0+0=0$.`,
  R`Step 5: $\pi-0=\pi$.`), T.ip);
chk(simpson((x) => x * Math.sin(x), 0, PI), PI);
add(R`Find the anti-derivative of $2e^{-3x}$ which has the value $1$ at $x=0$.`, M(R`-\frac23e^{-3x}+\frac53`), [M(R`\frac23e^{-3x}+\frac13`), M(R`-6e^{-3x}+7`), M(R`-\frac23e^{-3x}+\frac13`)], St(
  R`Step 1: $\int2e^{-3x}dx=\frac{2e^{-3x}}{-3}+c=-\frac23e^{-3x}+c$.`,
  R`Step 2: Use the condition $y=1$ at $x=0$: $-\frac23e^{0}+c=1$.`,
  R`Step 3: $-\frac23+c=1$, so $c=1+\frac23=\frac53$.`,
  R`Step 4: $y=-\frac23e^{-3x}+\frac53=-\frac13\left(2e^{-3x}-5\right)$.`), T.an);
add(R`Find the anti-derivative of $2x-1$ which has the value $2$ at $x=0$.`, M(R`x^2-x+2`), [M(R`x^2-x`), M(R`x^2-x+1`), '2'], St(
  R`Step 1: $\int(2x-1)dx=x^2-x+c$.`,
  R`Step 2: At $x=0$ the value must be $2$: $0-0+c=2$, so $c=2$.`,
  R`Step 3: $y=x^2-x+2$.`), T.an);
add(R`Evaluate ${M(R`\int_0^{\ln10}\dfrac{e^x}{\sqrt{e^x-1}}\,dx`)}.`, '6', ['3', '2', M(R`\sqrt{10}`)], St(
  R`Step 1: Let $u=e^x-1$. Then $du=e^xdx$, which is exactly the top of the fraction.`,
  R`Step 2: Limits: $x=0\Rightarrow u=1-1=0$; $x=\ln10\Rightarrow u=10-1=9$.`,
  R`Step 3: The integral becomes $\int_0^9u^{-1/2}du=\left[2u^{1/2}\right]_0^9$.`,
  R`Step 4: $2\sqrt9-2\sqrt0=6$.`), T.sub);
add(R`Evaluate ${M(R`\int_{-\pi/2}^{\pi/2}\sin^2x\cos x\,dx`)}.`, M(R`\frac23`), [M(R`\frac13`), '0', M(R`-\frac23`)], St(
  R`Step 1: Let $u=\sin x$. Then $du=\cos x\,dx$.`,
  R`Step 2: Limits: $x=-\frac\pi2\Rightarrow u=-1$ and $x=\frac\pi2\Rightarrow u=1$.`,
  R`Step 3: $\int_{-1}^1u^2du=\left[\frac{u^3}3\right]_{-1}^1=\frac13-\left(-\frac13\right)=\frac23$.`,
  R`Shortcut: $u^2$ is even, so $\int_{-1}^1u^2du=2\int_0^1u^2du=2\times\frac13=\frac23$.`), T.sub);
chk(simpson((x) => Math.sin(x) ** 2 * Math.cos(x), -PI / 2, PI / 2), 2 / 3);
add(R`Evaluate ${M(R`\int_0^{\ln4}\dfrac{e^x}{\sqrt{4-e^x}}\,dx`)}.`, M(R`2\sqrt3`), [M(R`\sqrt3`), M(R`3\sqrt2`), M(R`\sqrt2`)], St(
  R`Step 1: Let $u=4-e^x$. Then $du=-e^xdx$, so $e^xdx=-du$.`,
  R`Step 2: Limits: $x=0\Rightarrow u=4-1=3$; $x=\ln4\Rightarrow u=4-4=0$.`,
  R`Step 3: The integral becomes $-\int_3^0u^{-1/2}du=\int_0^3u^{-1/2}du$ (swapping the limits removes the minus).`,
  R`Step 4: $\left[2u^{1/2}\right]_0^3=2\sqrt3$.`), T.sub);
add(R`Evaluate ${M(R`\int_{-1}^{1}\dfrac{dx}{2x+3}`)}.`, M(R`\frac12\ln5`), [M(R`\ln5`), '0', M(R`\ln\frac52`)], St(
  R`Step 1: The derivative of the bottom $2x+3$ is $2$, so multiply and divide by $2$: $\frac12\int\frac{2}{2x+3}dx$.`,
  R`Step 2: $\frac12\ln(2x+3)$.`,
  R`Step 3: Upper limit $x=1$: $\frac12\ln5$. Lower limit $x=-1$: $\frac12\ln1=0$.`,
  R`Step 4: $\frac12\ln5-0=\frac12\ln5$.`,
  R`Shortcut: $\int\frac{dx}{ax+b}=\frac1a\ln|ax+b|$.`), T.di);
chk(simpson((x) => 1 / (2 * x + 3), -1, 1), 0.5 * Math.log(5));
add(R`Evaluate ${M(R`\int_{-1}^{1}x(2x^2+4)^3\,dx`)}.`, '0', ['5', '9', '-2'], St(
  R`Step 1: Check the symmetry: $f(x)=x(2x^2+4)^3$. Replace $x$ by $-x$: $-x(2x^2+4)^3=-f(x)$, so $f$ is an odd function.`,
  R`Step 2: The limits $-1$ and $1$ are symmetric, so the area below the axis cancels the area above it.`,
  R`Step 3: The integral is $0$.`,
  R`Full working (to confirm): $u=2x^2+4$, $du=4x\,dx$; limits $x=\pm1$ both give $u=6$, and $\int_6^6\dots=0$.`), T.di);
chk(simpson((x) => x * (2 * x * x + 4) ** 3, -1, 1), 0, 1e-6);
add(R`Evaluate ${M(R`\int_0^1x(x^2-1)^3\,dx`)}.`, M(R`-\frac18`), [M(R`\frac18`), M(R`-\frac14`), M(R`\frac14`)], St(
  R`Step 1: Let $u=x^2-1$. Then $du=2x\,dx$, so $x\,dx=\frac{du}2$.`,
  R`Step 2: Limits: $x=0\Rightarrow u=-1$; $x=1\Rightarrow u=0$.`,
  R`Step 3: $\frac12\int_{-1}^0u^3du=\frac12\left[\frac{u^4}4\right]_{-1}^0$.`,
  R`Step 4: $\frac12\left(0-\frac14\right)=-\frac18$.`), T.sub);
chk(simpson((x) => x * (x * x - 1) ** 3, 0, 1), -1 / 8);
add(R`Evaluate ${M(R`\int_1^2\dfrac{x}{x^2+4}\,dx`)}.`, M(R`\frac12\ln\frac85`), [M(R`\ln\frac85`), M(R`\frac12\ln\frac58`), M(R`\frac12\ln2`)], St(
  R`Step 1: The derivative of the bottom $x^2+4$ is $2x$, so write $\frac x{x^2+4}=\frac12\cdot\frac{2x}{x^2+4}$.`,
  R`Step 2: Integral: $\frac12\ln(x^2+4)$.`,
  R`Step 3: Upper limit $x=2$: $\frac12\ln8$. Lower limit $x=1$: $\frac12\ln5$.`,
  R`Step 4: $\frac12(\ln8-\ln5)=\frac12\ln\frac85$.`), T.di);
chk(simpson((x) => x / (x * x + 4), 1, 2), 0.5 * Math.log(8 / 5));

// ============================================================ INDEFINITE INTEGRALS FROM THE TEXT
add(R`The integral of $\dfrac{2}{x(x-1)}$ with respect to $x$ is:`, M(R`\ln\left(\frac{x-1}{x}\right)^2+c`), [M(R`\ln\left(\frac{x}{x-1}\right)^2+c`), M(R`\ln\frac{x-1}{x+1}+c`), M(R`\ln\left(\frac{x-1}{x}\right)+c`)], St(
  R`Step 1: Split into partial fractions: $\frac2{x(x-1)}=\frac Ax+\frac B{x-1}$.`,
  R`Step 2: Cover-up: for $A$ cover $x$ and put $x=0$: $A=\frac{2}{0-1}=-2$. For $B$ cover $(x-1)$ and put $x=1$: $B=\frac21=2$.`,
  R`Step 3: $\int\left(-\frac2x+\frac2{x-1}\right)dx=-2\ln|x|+2\ln|x-1|$.`,
  R`Step 4: Combine: $2\ln\left|\frac{x-1}x\right|=\ln\left(\frac{x-1}x\right)^2$.`), T.pf);
checkInt((x) => 2 * Math.log(Math.abs((x - 1) / x)), (x) => 2 / (x * (x - 1)), [2, 3, 4]);
add(R`The integral of $\dfrac{x}{3x^2+4}$ is:`, M(R`\frac16\ln(3x^2+4)+c`), [M(R`\frac13\ln(3x^2+4)+c`), M(R`\ln(3x^2+4)+c`), M(R`-\frac16(3x^2+4)+c`)], St(
  R`Step 1: The derivative of the bottom is $6x$; the top is only $x$, so multiply and divide by $6$: $\frac16\cdot\frac{6x}{3x^2+4}$.`,
  R`Step 2: Use $\int\frac{f'}f=\ln|f|$.`,
  R`Step 3: $\frac16\ln(3x^2+4)+c$.`), T.sub);
checkInt((x) => Math.log(3 * x * x + 4) / 6, (x) => x / (3 * x * x + 4));
add(R`The integral of $\dfrac{x+2}{x^2+4x+5}$ is:`, M(R`\frac12\ln(x^2+4x+5)+c`), [M(R`\ln(x^2+4x+5)+c`), M(R`2\ln(x^2+4x+5)+c`), M(R`\frac12\ln(x+2)+c`)], St(
  R`Step 1: The derivative of the bottom $x^2+4x+5$ is $2x+4=2(x+2)$.`,
  R`Step 2: So the top $x+2$ is half of the derivative: $\frac12\cdot\frac{2x+4}{x^2+4x+5}$.`,
  R`Step 3: $\frac12\ln(x^2+4x+5)+c$.`), T.sub);
checkInt((x) => Math.log(x * x + 4 * x + 5) / 2, (x) => (x + 2) / (x * x + 4 * x + 5));

// ============================================================ INTEGRATION BY PARTS
add(R`Evaluate ${M(R`\int x\ln(2x)\,dx`)}.`, M(R`\frac{x^2}2\left(\ln2x-\frac12\right)+c`), [M(R`\frac{x^2}2\left(\ln2x+\frac12\right)+c`), M(R`x^2\left(\ln2x-\frac12\right)+c`), M(R`\frac{x^2}2\ln2x+c`)], St(
  R`Step 1: Choose $u=\ln(2x)$ (a logarithm is hard to integrate, so differentiate it) and $dv=x\,dx$.`,
  R`Step 2: $du=\frac{2}{2x}dx=\frac1xdx$ and $v=\frac{x^2}2$.`,
  R`Step 3: $\int x\ln2x\,dx=\frac{x^2}2\ln2x-\int\frac{x^2}2\cdot\frac1x\,dx=\frac{x^2}2\ln2x-\int\frac x2\,dx$.`,
  R`Step 4: $\int\frac x2dx=\frac{x^2}4$.`,
  R`Step 5: $\frac{x^2}2\ln2x-\frac{x^2}4=\frac{x^2}2\left(\ln2x-\frac12\right)+c$.`), T.ip);
checkInt((x) => x * x / 2 * (Math.log(2 * x) - 0.5), (x) => x * Math.log(2 * x));
add(R`Evaluate ${M(R`\int e^x\cos x\,dx`)}.`, M(R`\frac{e^x}2(\sin x+\cos x)+c`), [M(R`\frac{e^x}2(\cos x-\sin x)+c`), M(R`e^x(\sin x+\cos x)+c`), M(R`e^x\sin x+c`)], St(
  R`Step 1: Call the integral $I=\int e^x\cos x\,dx$. Both $e^x$ and $\cos x$ keep coming back after differentiating, so we use by-parts twice and solve for $I$.`,
  R`Step 2: First time: $u=e^x$, $dv=\cos x\,dx$, so $v=\sin x$: $I=e^x\sin x-\int e^x\sin x\,dx$.`,
  R`Step 3: Second time on $\int e^x\sin x\,dx$: $u=e^x$, $dv=\sin x\,dx$, so $v=-\cos x$: $\int e^x\sin x\,dx=-e^x\cos x+\int e^x\cos x\,dx=-e^x\cos x+I$.`,
  R`Step 4: Substitute back: $I=e^x\sin x-(-e^x\cos x+I)=e^x\sin x+e^x\cos x-I$.`,
  R`Step 5: Add $I$ to both sides: $2I=e^x(\sin x+\cos x)$.`,
  R`Step 6: $I=\frac{e^x}2(\sin x+\cos x)+c$.`), T.ip);
checkInt((x) => Math.exp(x) / 2 * (Math.sin(x) + Math.cos(x)), (x) => Math.exp(x) * Math.cos(x));
add(R`Evaluate ${M(R`\int_{-1}^0xe^{-x}\,dx`)}.`, '-1', ['0', '1', '2'], St(
  R`Step 1: By parts: $u=x$, $dv=e^{-x}dx$, so $du=dx$ and $v=-e^{-x}$.`,
  R`Step 2: $\int xe^{-x}dx=-xe^{-x}+\int e^{-x}dx=-xe^{-x}-e^{-x}$.`,
  R`Step 3: Upper limit $x=0$: $0-1=-1$.`,
  R`Step 4: Lower limit $x=-1$: $-(-1)e^{1}-e^{1}=e-e=0$.`,
  R`Step 5: $-1-0=-1$.`), T.ip);
chk(simpson((x) => x * Math.exp(-x), -1, 0), -1);
add(R`Evaluate ${M(R`\int x^2\cos x\,dx`)}.`, M(R`x^2\sin x+2x\cos x-2\sin x+c`), [M(R`x^2\sin x-2x\cos x-2\sin x+c`), M(R`x^2\sin x+2x\cos x+2\sin x+c`), M(R`2x\sin x+c`)], St(
  R`Step 1: By parts: $u=x^2$, $dv=\cos x\,dx$, so $du=2x\,dx$ and $v=\sin x$.`,
  R`Step 2: $\int x^2\cos x\,dx=x^2\sin x-2\int x\sin x\,dx$.`,
  R`Step 3: For $\int x\sin x\,dx$: $u=x$, $dv=\sin x\,dx$, $v=-\cos x$, giving $-x\cos x+\sin x$.`,
  R`Step 4: Substitute: $x^2\sin x-2(-x\cos x+\sin x)=x^2\sin x+2x\cos x-2\sin x$.`,
  R`Shortcut (tabular): derivatives of $x^2$: $x^2,\ 2x,\ 2,\ 0$. Integrals of $\cos x$: $\sin x,\ -\cos x,\ -\sin x$. Multiply diagonally with signs $+,-,+$: $x^2\sin x-2x(-\cos x)+2(-\sin x)$.`), T.ip);
checkInt((x) => x * x * Math.sin(x) + 2 * x * Math.cos(x) - 2 * Math.sin(x), (x) => x * x * Math.cos(x));
add(R`Evaluate ${M(R`\int x^2\sin x\,dx`)}.`, M(R`-x^2\cos x+2x\sin x+2\cos x+c`), [M(R`x^2\cos x-2x\sin x-2\cos x+c`), M(R`-x^2\cos x-2x\sin x+2\cos x+c`), M(R`-x^2\cos x+2x\sin x-2\cos x+c`)], St(
  R`Step 1: By parts: $u=x^2$, $dv=\sin x\,dx$, so $du=2x\,dx$ and $v=-\cos x$.`,
  R`Step 2: $\int x^2\sin x\,dx=-x^2\cos x+2\int x\cos x\,dx$.`,
  R`Step 3: $\int x\cos x\,dx=x\sin x+\cos x$ (by parts again).`,
  R`Step 4: $-x^2\cos x+2(x\sin x+\cos x)=-x^2\cos x+2x\sin x+2\cos x+c$.`,
  R`Shortcut (tabular): $x^2,\,2x,\,2,\,0$ against $\sin x\to-\cos x\to-\sin x\to\cos x$, signs $+,-,+$: $-x^2\cos x-2x(-\sin x)+2\cos x$.`), T.ip);
checkInt((x) => -x * x * Math.cos(x) + 2 * x * Math.sin(x) + 2 * Math.cos(x), (x) => x * x * Math.sin(x));
add(R`Evaluate ${M(R`\int xe^{2x}\,dx`)}.`, M(R`\frac12xe^{2x}-\frac14e^{2x}+c`), [M(R`\frac12xe^{2x}+\frac14e^{2x}+c`), M(R`xe^{2x}-e^{2x}+c`), M(R`\frac{x^2}4e^{2x}+c`)], St(
  R`Step 1: $u=x$, $dv=e^{2x}dx$, so $du=dx$ and $v=\frac{e^{2x}}2$.`,
  R`Step 2: $\int xe^{2x}dx=\frac{xe^{2x}}2-\int\frac{e^{2x}}2dx$.`,
  R`Step 3: $\int\frac{e^{2x}}2dx=\frac{e^{2x}}4$.`,
  R`Step 4: $\frac12xe^{2x}-\frac14e^{2x}+c=\frac14e^{2x}(2x-1)+c$.`), T.ip);
checkInt((x) => x * Math.exp(2 * x) / 2 - Math.exp(2 * x) / 4, (x) => x * Math.exp(2 * x));
add(R`Evaluate ${M(R`\int_0^{\pi/4}x\sec^2x\,dx`)}.`, M(R`\frac\pi4-\frac12\ln2`), [M(R`\frac\pi4+\frac12\ln2`), M(R`\frac\pi4-\ln2`), M(R`\frac\pi4`)], St(
  R`Step 1: By parts: $u=x$, $dv=\sec^2x\,dx$, so $du=dx$ and $v=\tan x$.`,
  R`Step 2: $\int x\sec^2x\,dx=x\tan x-\int\tan x\,dx=x\tan x+\ln|\cos x|$ (because $\int\tan x\,dx=-\ln|\cos x|$).`,
  R`Step 3: Upper limit $x=\frac\pi4$: $\frac\pi4(1)+\ln\frac1{\sqrt2}=\frac\pi4-\frac12\ln2$.`,
  R`Step 4: Lower limit $x=0$: $0+\ln1=0$.`,
  R`Step 5: Result: $\frac\pi4-\frac12\ln2$.`), T.ip);
chk(simpson((x) => x / Math.cos(x) ** 2, 0, PI / 4), PI / 4 - 0.5 * Math.log(2));
add(R`If $\dfrac{dy}{dx}=\ln x$, then $y$ equals:`, M(R`x(\ln x-1)+c`), [M(R`\frac1x+c`), M(R`x(\ln x+1)+c`), M(R`\frac{(\ln x)^2}2+c`)], St(
  R`Step 1: $y=\int\ln x\,dx$. Write $\ln x$ as $1\cdot\ln x$ and use by-parts.`,
  R`Step 2: $u=\ln x$, $dv=dx$, so $du=\frac1xdx$ and $v=x$.`,
  R`Step 3: $y=x\ln x-\int x\cdot\frac1xdx=x\ln x-x$.`,
  R`Step 4: $y=x(\ln x-1)+c$.`), T.ip);
checkInt((x) => x * (Math.log(x) - 1), (x) => Math.log(x));
add(R`Evaluate ${M(R`\int x^2\ln x\,dx`)}.`, M(R`\frac{x^3}3\ln x-\frac{x^3}9+c`), [M(R`\frac{x^3}3\ln x-\frac{x^3}3+c`), M(R`\frac{x^3}3\ln x+\frac{x^3}9+c`), M(R`x^3\ln x-\frac{x^3}{9}+c`)], St(
  R`Step 1: $u=\ln x$ and $dv=x^2dx$, so $du=\frac1xdx$ and $v=\frac{x^3}3$.`,
  R`Step 2: $\int x^2\ln x\,dx=\frac{x^3}3\ln x-\int\frac{x^3}3\cdot\frac1xdx=\frac{x^3}3\ln x-\int\frac{x^2}3dx$.`,
  R`Step 3: $\int\frac{x^2}3dx=\frac{x^3}9$.`,
  R`Step 4: $\frac{x^3}3\ln x-\frac{x^3}9+c$.`,
  R`Shortcut: $\int x^n\ln x\,dx=\frac{x^{n+1}}{n+1}\left(\ln x-\frac1{n+1}\right)+c$. With $n=2$: $\frac{x^3}3\left(\ln x-\frac13\right)$.`), T.ip);
checkInt((x) => x ** 3 / 3 * Math.log(x) - x ** 3 / 9, (x) => x * x * Math.log(x));

// ============================================================ PARTIAL FRACTIONS
add(R`Evaluate ${M(R`\int\dfrac{3}{x^2+x-6}\,dx`)}.`, M(R`\frac35\ln|x-2|-\frac35\ln|x+3|+c`), [M(R`3\ln|x^2+x-6|+c`), M(R`-\frac35\ln|x-2|+\frac35\ln|x+3|+c`), M(R`\frac35\ln|x-2|+\frac35\ln|x+3|+c`)], St(
  R`Step 1: Factorise the bottom: $x^2+x-6=(x-2)(x+3)$, because $-2\times3=-6$ and $-2+3=1$.`,
  R`Step 2: $\frac3{(x-2)(x+3)}=\frac A{x-2}+\frac B{x+3}$.`,
  R`Step 3: Cover-up: $A$: cover $(x-2)$, put $x=2$: $A=\frac3{2+3}=\frac35$. $B$: cover $(x+3)$, put $x=-3$: $B=\frac3{-3-2}=-\frac35$.`,
  R`Step 4: $\int\left(\frac{3/5}{x-2}-\frac{3/5}{x+3}\right)dx=\frac35\ln|x-2|-\frac35\ln|x+3|+c$.`), T.pf);
checkInt((x) => 0.6 * Math.log(Math.abs(x - 2)) - 0.6 * Math.log(Math.abs(x + 3)), (x) => 3 / (x * x + x - 6), [3, 4, 5]);
add(R`Evaluate ${M(R`\int\dfrac{x+2}{x^2+3x+2}\,dx`)}.`, M(R`\ln|x+1|+c`), [M(R`\ln|x+2|+c`), M(R`\ln\left|\frac{x+2}{x+1}\right|+c`), M(R`\ln|x^2+3x+2|+c`)], St(
  R`Step 1: Factorise the bottom: $x^2+3x+2=(x+1)(x+2)$.`,
  R`Step 2: The factor $(x+2)$ appears on the top and on the bottom, so cancel it: $\frac{x+2}{(x+1)(x+2)}=\frac1{x+1}$.`,
  R`Step 3: $\int\frac{dx}{x+1}=\ln|x+1|+c$.`,
  R`Shortcut: always check for a common factor before you start partial fractions.`), T.pf);
checkInt((x) => Math.log(Math.abs(x + 1)), (x) => (x + 2) / (x * x + 3 * x + 2));
add(R`Evaluate ${M(R`\int\dfrac{x-1}{x(x+1)}\,dx`)}.`, M(R`2\ln|x+1|-\ln|x|+c`), [M(R`\ln|x|-2\ln|x+1|+c`), M(R`2\ln|x+1|+\ln|x|+c`), M(R`\ln|x(x+1)|+c`)], St(
  R`Step 1: $\frac{x-1}{x(x+1)}=\frac Ax+\frac B{x+1}$.`,
  R`Step 2: Cover-up: $A$: cover $x$, put $x=0$: $\frac{0-1}{0+1}=-1$. $B$: cover $(x+1)$, put $x=-1$: $\frac{-1-1}{-1}=2$.`,
  R`Step 3: $\int\left(-\frac1x+\frac2{x+1}\right)dx=-\ln|x|+2\ln|x+1|$.`,
  R`Step 4: Written neatly: $2\ln|x+1|-\ln|x|+c$.`), T.pf);
checkInt((x) => 2 * Math.log(Math.abs(x + 1)) - Math.log(Math.abs(x)), (x) => (x - 1) / (x * (x + 1)));
add(R`Evaluate ${M(R`\int\dfrac{dx}{x^2-4}`)}.`, M(R`\frac14\ln\left|\frac{x-2}{x+2}\right|+c`), [M(R`\frac14\ln\left|\frac{x+2}{x-2}\right|+c`), M(R`\frac12\ln\left|\frac{x-2}{x+2}\right|+c`), M(R`\ln|x^2-4|+c`)], St(
  R`Step 1: $x^2-4=(x-2)(x+2)$, so $\frac1{(x-2)(x+2)}=\frac A{x-2}+\frac B{x+2}$.`,
  R`Step 2: Cover-up: $A=\frac1{2+2}=\frac14$ and $B=\frac1{-2-2}=-\frac14$.`,
  R`Step 3: $\int\left(\frac{1/4}{x-2}-\frac{1/4}{x+2}\right)dx=\frac14\ln|x-2|-\frac14\ln|x+2|$.`,
  R`Step 4: $\frac14\ln\left|\frac{x-2}{x+2}\right|+c$.`,
  R`Shortcut: $\int\frac{dx}{x^2-a^2}=\frac1{2a}\ln\left|\frac{x-a}{x+a}\right|+c$; here $a=2$ so $\frac1{2a}=\frac14$.`), T.pf);
checkInt((x) => Math.log(Math.abs((x - 2) / (x + 2))) / 4, (x) => 1 / (x * x - 4), [3, 4, 5]);
add(R`Evaluate ${M(R`\int\dfrac{x^2+3x-10}{x^2-2x-3}\,dx`)}.`, M(R`x+2\ln|x-3|+3\ln|x+1|+c`), [M(R`x+3\ln|x-3|+2\ln|x+1|+c`), M(R`\ln|x^2-2x-3|+c`), M(R`x-2\ln|x-3|-3\ln|x+1|+c`)], St(
  R`Step 1: The top and bottom have the same degree (2), so divide first: $x^2+3x-10=(x^2-2x-3)+(5x-7)$.`,
  R`Step 2: So the fraction is $1+\frac{5x-7}{x^2-2x-3}=1+\frac{5x-7}{(x-3)(x+1)}$.`,
  R`Step 3: Split: $\frac{5x-7}{(x-3)(x+1)}=\frac A{x-3}+\frac B{x+1}$. Cover-up: $A=\frac{5(3)-7}{3+1}=\frac84=2$ and $B=\frac{5(-1)-7}{-1-3}=\frac{-12}{-4}=3$.`,
  R`Step 4: $\int\left(1+\frac2{x-3}+\frac3{x+1}\right)dx=x+2\ln|x-3|+3\ln|x+1|+c$.`), T.pf);
checkInt((x) => x + 2 * Math.log(Math.abs(x - 3)) + 3 * Math.log(Math.abs(x + 1)), (x) => (x * x + 3 * x - 10) / (x * x - 2 * x - 3), [4, 5, 6]);

// ============================================================ AREAS
add(R`Find the area bounded by $y=x^2-7x+6$, the $x$-axis and the lines $x=2$ and $x=6$.`, M(R`\frac{56}3`), [M(R`-\frac{56}3`), M(R`\frac{28}3`), '18'], St(
  R`Step 1: Find where the curve cuts the axis: $x^2-7x+6=(x-1)(x-6)=0$, so $x=1$ and $x=6$. On $[2,6]$ the curve lies below the axis (e.g. at $x=3$: $9-21+6=-6$).`,
  R`Step 2: Integrate: $\int_2^6(x^2-7x+6)dx=\left[\frac{x^3}3-\frac{7x^2}2+6x\right]_2^6$.`,
  R`Step 3: At $x=6$: $72-126+36=-18$. At $x=2$: $\frac83-14+12=\frac23$.`,
  R`Step 4: The integral is $-18-\frac23=-\frac{56}3$, a negative number because the region is below the axis.`,
  R`Step 5: An area is never negative, so the area is $\frac{56}3$ square units.`), T.ar);
chk(Math.abs(simpson((x) => x * x - 7 * x + 6, 2, 6)), 56 / 3);
add(R`Find the area of the region bounded above by $y=e^x$, below by $y=x$, and on the sides by $x=0$ and $x=1$.`, M(R`e-\frac32`), [M(R`e-\frac12`), M(R`e+\frac32`), M(R`e-1`)], St(
  R`Step 1: Area between curves $=\int_a^b(\text{upper}-\text{lower})\,dx=\int_0^1(e^x-x)\,dx$.`,
  R`Step 2: Integrate: $\left[e^x-\frac{x^2}2\right]_0^1$.`,
  R`Step 3: Upper limit: $e-\frac12$. Lower limit: $1-0=1$.`,
  R`Step 4: Subtract: $e-\frac12-1=e-\frac32\approx1.22$ square units.`), T.ar);
chk(simpson((x) => Math.exp(x) - x, 0, 1), Math.E - 1.5);
add(R`Find the area of the region bounded above by $y=x+6$, below by $y=x^2$, and on the sides by $x=0$ and $x=2$.`, M(R`\frac{34}3`), [M(R`\frac{38}3`), M(R`\frac{22}3`), '12'], St(
  R`Step 1: Upper curve $y=x+6$, lower curve $y=x^2$. Area $=\int_0^2(x+6-x^2)dx$.`,
  R`Step 2: Integrate: $\left[\frac{x^2}2+6x-\frac{x^3}3\right]_0^2$.`,
  R`Step 3: At $x=2$: $2+12-\frac83=14-\frac83=\frac{34}3$.`,
  R`Step 4: At $x=0$: $0$.`,
  R`Step 5: Area $=\frac{34}3$ square units.`), T.ar);
chk(simpson((x) => x + 6 - x * x, 0, 2), 34 / 3);
add(R`Find the area of the region enclosed between the curves $y=x^2$ and $y=x+6$.`, M(R`\frac{125}6`), [M(R`\frac{125}{3}`), M(R`\frac{65}{6}`), M(R`\frac{27}{2}`)], St(
  R`Step 1: Find where they meet: $x^2=x+6\Rightarrow x^2-x-6=0\Rightarrow(x+2)(x-3)=0$, so $x=-2$ and $x=3$.`,
  R`Step 2: Between these values the line is above the parabola (test $x=0$: $6>0$).`,
  R`Step 3: Area $=\int_{-2}^3(x+6-x^2)dx=\left[\frac{x^2}2+6x-\frac{x^3}3\right]_{-2}^3$.`,
  R`Step 4: At $x=3$: $\frac92+18-9=\frac{27}2$. At $x=-2$: $2-12+\frac83=-\frac{22}3$.`,
  R`Step 5: $\frac{27}2-\left(-\frac{22}3\right)=\frac{81+44}6=\frac{125}6$.`,
  R`Shortcut: for a parabola and a line meeting at $x_1$ and $x_2$, area $=\frac{|a|(x_2-x_1)^3}6$. Here $a=1$ and $(3-(-2))^3=125$, so $\frac{125}6$.`), T.ar);
chk(simpson((x) => x + 6 - x * x, -2, 3), 125 / 6);
add(R`Find the area bounded by $y=3x-x^2$ and the $x$-axis.`, M(R`\frac92`), [M(R`\frac{9}{4}`), M(R`-\frac92`), '9'], St(
  R`Step 1: The curve meets the axis where $3x-x^2=0$: $x(3-x)=0$, so $x=0$ and $x=3$.`,
  R`Step 2: Between $0$ and $3$ the curve is above the axis (an upside-down parabola).`,
  R`Step 3: Area $=\int_0^3(3x-x^2)dx=\left[\frac{3x^2}2-\frac{x^3}3\right]_0^3$.`,
  R`Step 4: At $x=3$: $\frac{27}2-9=\frac92$. At $x=0$: $0$.`,
  R`Step 5: Area $=\frac92$ square units.`,
  R`Shortcut: for $y=ax^2+bx+c$ with roots $x_1,x_2$, area $=\frac{|a|(x_2-x_1)^3}6=\frac{1\times27}6=\frac92$.`), T.ar);
chk(simpson((x) => 3 * x - x * x, 0, 3), 4.5);
add(R`Find the area bounded by $y=2+x-x^2$ and the $x$-axis.`, M(R`\frac92`), [M(R`\frac{37}6`), M(R`\frac{13}6`), M(R`\frac{29}6`)], St(
  R`Step 1: Set $y=0$: $2+x-x^2=0\Rightarrow x^2-x-2=0\Rightarrow(x+1)(x-2)=0$, so $x=-1$ and $x=2$.`,
  R`Step 2: Area $=\int_{-1}^2(2+x-x^2)dx=\left[2x+\frac{x^2}2-\frac{x^3}3\right]_{-1}^2$.`,
  R`Step 3: At $x=2$: $4+2-\frac83=\frac{10}3$. At $x=-1$: $-2+\frac12+\frac13=-\frac76$.`,
  R`Step 4: $\frac{10}3+\frac76=\frac{20+7}6=\frac{27}6=\frac92$.`,
  R`Shortcut: roots $-1$ and $2$, so $\frac{|a|(2-(-1))^3}6=\frac{27}6=\frac92$.`), T.ar);
chk(simpson((x) => 2 + x - x * x, -1, 2), 4.5);
add(R`Find the area bounded by the curve $y=(2x+1)^2$, the $x$-axis and the lines $x=0$ and $x=1$.`, M(R`\frac{13}3`), [M(R`\frac{26}3`), M(R`\frac{7}{3}`), M(R`9`)], St(
  R`Step 1: Area $=\int_0^1(2x+1)^2dx$.`,
  R`Step 2: Use the linear-bracket shortcut $\int(ax+b)^ndx=\frac{(ax+b)^{n+1}}{a(n+1)}$: $\frac{(2x+1)^3}{6}$.`,
  R`Step 3: At $x=1$: $\frac{27}6$. At $x=0$: $\frac16$.`,
  R`Step 4: $\frac{27-1}6=\frac{26}6=\frac{13}3$.`,
  R`Check by expanding: $\int_0^1(4x^2+4x+1)dx=\frac43+2+1=\frac{13}3$.`), T.ar);
chk(simpson((x) => (2 * x + 1) ** 2, 0, 1), 13 / 3);
add(R`Find the area enclosed between the curves $y=x$ and $y=x^3$.`, M(R`\frac12`), ['0', M(R`\frac14`), '1'], St(
  R`Step 1: Intersections: $x=x^3\Rightarrow x(1-x^2)=0\Rightarrow x=-1,0,1$. There are two enclosed regions.`,
  R`Step 2: On $[0,1]$ the line is above the cubic: area $=\int_0^1(x-x^3)dx=\left[\frac{x^2}2-\frac{x^4}4\right]_0^1=\frac12-\frac14=\frac14$.`,
  R`Step 3: On $[-1,0]$ the cubic is above the line, and the shape is the mirror image, giving another $\frac14$.`,
  R`Step 4: Total area $=\frac14+\frac14=\frac12$.`,
  R`Warning: if you integrate $x-x^3$ from $-1$ to $1$ in one go you get $0$, because the two regions cancel. An area cannot be $0$; that is why the region is split at $x=0$. Shortcut: the figure is symmetrical, so $2\times\frac14=\frac12$.`), T.ar);
chk(2 * simpson((x) => x - x ** 3, 0, 1), 0.5);
add(R`Find the area bounded by $y=4x-x^2$ and the $x$-axis.`, M(R`\frac{32}3`), [M(R`\frac{16}3`), M(R`-\frac{32}3`), M(R`\frac{64}3`)], St(
  R`Step 1: $4x-x^2=x(4-x)=0$ gives $x=0$ and $x=4$.`,
  R`Step 2: Area $=\int_0^4(4x-x^2)dx=\left[2x^2-\frac{x^3}3\right]_0^4$.`,
  R`Step 3: At $x=4$: $32-\frac{64}3=\frac{96-64}3=\frac{32}3$. At $x=0$: $0$.`,
  R`Step 4: Area $=\frac{32}3$ square units.`,
  R`Shortcut: $\frac{|a|(x_2-x_1)^3}6=\frac{4^3}6=\frac{64}6=\frac{32}3$.`), T.ar);
chk(simpson((x) => 4 * x - x * x, 0, 4), 32 / 3);
add(R`Find the area bounded by $y=3x^2+2x$, the $x$-axis and the lines $x=1$ and $x=3$.`, '34', ['36', '24', '28'], St(
  R`Step 1: Integrate: $\int(3x^2+2x)dx=x^3+x^2$.`,
  R`Step 2: Upper limit $x=3$: $27+9=36$.`,
  R`Step 3: Lower limit $x=1$: $1+1=2$.`,
  R`Step 4: $36-2=34$ square units.`,
  R`(The curve is above the axis for $x>0$, so no sign problem arises.)`), T.ar);
chk(simpson((x) => 3 * x * x + 2 * x, 1, 3), 34);
add(R`Find the area bounded by $y=\dfrac{x^2}{4}$, the $x$-axis and the lines $x=0$ and $x=4$.`, M(R`\frac{16}3`), [M(R`\frac{32}3`), M(R`\frac{4}{3}`), '4'], St(
  R`Step 1: Area $=\int_0^4\frac{x^2}4dx$.`,
  R`Step 2: $\left[\frac{x^3}{12}\right]_0^4=\frac{64}{12}$.`,
  R`Step 3: $\frac{64}{12}=\frac{16}3$.`), T.ar);
chk(simpson((x) => x * x / 4, 0, 4), 16 / 3);

// ============================================================ VOLUMES AND SURFACE AREA
add(R`The curve $y=\sqrt{1+x^2}$ between $x=1$ and $x=3$ is rotated about the $x$-axis. Its volume is:`, M(R`\frac{32\pi}3`), [M(R`\frac{16\pi}3`), M(R`\frac{32}3`), M(R`10\pi`)], St(
  R`Step 1: Disc formula: $V=\pi\int_a^by^2dx$.`,
  R`Step 2: $y^2=\left(\sqrt{1+x^2}\right)^2=1+x^2$ (squaring removes the root).`,
  R`Step 3: $V=\pi\int_1^3(1+x^2)dx=\pi\left[x+\frac{x^3}3\right]_1^3$.`,
  R`Step 4: At $x=3$: $3+9=12$. At $x=1$: $1+\frac13=\frac43$.`,
  R`Step 5: $V=\pi\left(12-\frac43\right)=\frac{32\pi}3$ cubic units.`), T.vol);
chk(PI * simpson((x) => 1 + x * x, 1, 3), 32 * PI / 3);
add(R`The area under $y=\cos x$ from $x=0$ to $x=\dfrac\pi2$ is rotated about the $x$-axis. The volume generated is:`, M(R`\frac{\pi^2}4`), [M(R`\frac{\pi^2}2`), M(R`\frac\pi4`), M(R`\pi`)], St(
  R`Step 1: $V=\pi\int_0^{\pi/2}\cos^2x\,dx$.`,
  R`Step 2: Use $\cos^2x=\frac{1+\cos2x}2$ (from $\cos2x=2\cos^2x-1$).`,
  R`Step 3: $V=\frac\pi2\int_0^{\pi/2}(1+\cos2x)dx=\frac\pi2\left[x+\frac{\sin2x}2\right]_0^{\pi/2}$.`,
  R`Step 4: At $\frac\pi2$: $\frac\pi2+\frac{\sin\pi}2=\frac\pi2$. At $0$: $0$.`,
  R`Step 5: $V=\frac\pi2\times\frac\pi2=\frac{\pi^2}4$.`), T.vol);
chk(PI * simpson((x) => Math.cos(x) ** 2, 0, PI / 2), PI * PI / 4);
add(R`The region bounded by $y=x^2-1$, $y=0$, $x=0$ and $x=1$ is rotated about the $x$-axis. The volume is:`, M(R`\frac{8\pi}{15}`), [M(R`\frac{8}{15}`), M(R`\frac{2\pi}{15}`), M(R`\frac{4\pi}{5}`)], St(
  R`Step 1: $V=\pi\int_0^1(x^2-1)^2dx$.`,
  R`Step 2: Expand the bracket: $(x^2-1)^2=x^4-2x^2+1$.`,
  R`Step 3: Integrate: $\left[\frac{x^5}5-\frac{2x^3}3+x\right]_0^1=\frac15-\frac23+1$.`,
  R`Step 4: Common denominator 15: $\frac3{15}-\frac{10}{15}+\frac{15}{15}=\frac8{15}$.`,
  R`Step 5: $V=\frac{8\pi}{15}$.`), T.vol);
chk(PI * simpson((x) => (x * x - 1) ** 2, 0, 1), 8 * PI / 15);
add(R`The curve $y=x^3$ between $y=0$ and $y=8$ is rotated about the $y$-axis. The volume is:`, M(R`\frac{96\pi}5`), [M(R`\frac{32\pi}5`), M(R`\frac{64\pi}{7}`), M(R`8\pi`)], St(
  R`Step 1: Rotating about the $y$-axis, use $V=\pi\int_c^dx^2\,dy$, so $x$ must be written in terms of $y$.`,
  R`Step 2: From $y=x^3$: $x=y^{1/3}$, so $x^2=y^{2/3}$.`,
  R`Step 3: $V=\pi\int_0^8y^{2/3}dy=\pi\left[\frac{y^{5/3}}{5/3}\right]_0^8=\frac{3\pi}5\left[y^{5/3}\right]_0^8$.`,
  R`Step 4: $8^{5/3}=(8^{1/3})^5=2^5=32$.`,
  R`Step 5: $V=\frac{3\pi}5\times32=\frac{96\pi}5$.`), T.vol);
chk(PI * (3 / 5) * 8 ** (5 / 3), 96 * PI / 5, 1e-9);
add(R`The curve $y=2\sqrt x$ for $1\le x\le2$ is rotated about the $x$-axis. Using $S=\int_a^b2\pi y\sqrt{1+\left(\dfrac{dy}{dx}\right)^2}dx$, the surface area is:`, M(R`\frac{8\pi}3\left(3\sqrt3-2\sqrt2\right)`), [M(R`\frac{8\pi}3\left(3\sqrt2-2\sqrt3\right)`), M(R`\frac{4\pi}3\left(3\sqrt3-2\sqrt2\right)`), M(R`8\pi\left(3\sqrt3-2\sqrt2\right)`)], St(
  R`Step 1: Differentiate: $y=2x^{1/2}$ so $\frac{dy}{dx}=x^{-1/2}=\frac1{\sqrt x}$.`,
  R`Step 2: $1+\left(\frac{dy}{dx}\right)^2=1+\frac1x=\frac{x+1}x$, so $\sqrt{1+\left(\frac{dy}{dx}\right)^2}=\frac{\sqrt{x+1}}{\sqrt x}$.`,
  R`Step 3: Multiply by $2\pi y=4\pi\sqrt x$: the $\sqrt x$ cancels, leaving $4\pi\sqrt{x+1}$.`,
  R`Step 4: $S=4\pi\int_1^2(x+1)^{1/2}dx=4\pi\cdot\frac23\left[(x+1)^{3/2}\right]_1^2=\frac{8\pi}3\left[3^{3/2}-2^{3/2}\right]$.`,
  R`Step 5: $3^{3/2}=3\sqrt3$ and $2^{3/2}=2\sqrt2$, so $S=\frac{8\pi}3\left(3\sqrt3-2\sqrt2\right)\approx30.8$ square units.`), T.sur);
chk(simpson((x) => 2 * PI * 2 * Math.sqrt(x) * Math.sqrt(1 + 1 / x), 1, 2), 8 * PI / 3 * (3 * Math.sqrt(3) - 2 * Math.sqrt(2)), 1e-5);

module.exports = out;
