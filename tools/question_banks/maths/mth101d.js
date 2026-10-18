// MTH 101 - batch D: complex numbers, De Moivre's theorem, roots of unity, the binomial theorem, counting.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { cx: 'Complex Numbers', arg: 'Argand Diagram', pol: 'Complex Numbers — Polar Form', dm: 'De Moivre\'s Theorem', ru: 'Roots of Unity', bin: 'Binomial Theorem', bn: 'Binomial Expansion — Negative and Fractional Index', cnt: 'Combinations — Selection Problems', perm: 'Permutations' };
const chk = (a, b) => { if (Math.abs(a - b) > 1e-9) throw new Error('check failed: ' + a + ' vs ' + b); };
const cmul = ([a, b], [c, d]) => [a * c - b * d, a * d + b * c];
const nCr = (n, r) => { let x = 1; for (let i = 1; i <= r; i++) x = x * (n - r + i) / i; return Math.round(x); };

// ---------------- complex numbers
{ const p = cmul([2, -3], [4, 1]); chk(p[0], 11); chk(p[1], -10); }
add(R`Simplify $(2-3i)(4+i)$.`, R`$11-10i$`, [R`$11+10i$`, R`$5-10i$`, R`$8-3i$`], R`$8+2i-12i-3i^2 = 8-10i+3 = 11-10i$.`, T.cx);
{ const p = cmul([1, 2], [1, 2]); chk(p[0], -3); chk(p[1], 4); }
add(R`The value of $(1+2i)^2$ is:`, R`$-3+4i$`, [R`$3+4i$`, R`$-3+2i$`, R`$5+4i$`], R`$1+4i+4i^2 = -3+4i$.`, T.cx);
add(R`The product $(3+4i)(3-4i)$ equals:`, R`$25$`, [R`$9-16i$`, R`$-7$`, R`$5$`], R`$(a+bi)(a-bi) = a^2+b^2 = 9+16 = 25$.`, T.cx);
add(R`The reciprocal $\dfrac{1}{2-i}$ in the form $a+bi$ is:`, R`$\dfrac25+\dfrac15i$`, [R`$\dfrac25-\dfrac15i$`, R`$2+i$`, R`$\dfrac12+i$`], R`Multiply numerator and denominator by $2+i$: $\dfrac{2+i}{5}$.`, T.cx);
add(R`The modulus of $-5+12i$ is:`, R`$13$`, [R`$7$`, R`$17$`, R`$\sqrt{119}$`], R`$\sqrt{25+144} = 13$.`, T.cx);
add(R`The complex number $z$ satisfying $z(2+i) = 3+4i$ is:`, R`$2+i$`, [R`$2-i$`, R`$1+2i$`, R`$\dfrac{3}{2}+4i$`], R`$z = \dfrac{(3+4i)(2-i)}{5} = \dfrac{10+5i}{5} = 2+i$.`, T.cx);
add(R`If $(x+2i)+(3-yi) = 5+i$ with $x$ and $y$ real, then $x$ and $y$ are:`, R`$x = 2,\ y = 1$`, [R`$x = 2,\ y = 3$`, R`$x = 8,\ y = 1$`, R`$x = 2,\ y = -1$`], R`Real parts: $x+3 = 5$. Imaginary parts: $2-y = 1$.`, T.cx);
add(R`The complex conjugate of $\dfrac{2+3i}{1-i}$ is:`, R`$\dfrac{-1-5i}{2}$`, [R`$\dfrac{-1+5i}{2}$`, R`$\dfrac{5-i}{2}$`, R`$-1-5i$`], R`$\dfrac{(2+3i)(1+i)}{2} = \dfrac{-1+5i}{2}$; its conjugate is $\dfrac{-1-5i}{2}$.`, T.cx);
add(R`The square roots of $-3+4i$ are:`, R`$\pm(1+2i)$`, [R`$\pm(2+i)$`, R`$\pm(1-2i)$`, R`$\pm(2-i)$`], R`$(1+2i)^2 = 1+4i-4 = -3+4i$.`, T.cx);
add(R`The value of $i+i^2+i^3+i^4$ is:`, R`$0$`, [R`$1$`, R`$i$`, R`$-1$`], R`$i-1-i+1 = 0$.`, T.cx);
add(R`The principal argument of $1-i\sqrt3$ is:`, R`$-\dfrac\pi3$`, [R`$\dfrac\pi3$`, R`$-\dfrac{2\pi}{3}$`, R`$\dfrac{5\pi}{3}$`], R`The point is in the fourth quadrant with $\tan^{-1}\sqrt3 = \dfrac\pi3$, so the argument is $-\dfrac\pi3$.`, T.arg);
add(R`The principal argument of $-1+i$ is:`, R`$\dfrac{3\pi}{4}$`, [R`$-\dfrac\pi4$`, R`$\dfrac\pi4$`, R`$-\dfrac{3\pi}{4}$`], R`The point is in the second quadrant at $45^\circ$ from the negative real axis.`, T.arg);
add(R`The locus of points $z$ in the Argand diagram satisfying $|z-2| = |z+2|$ is:`, R`The imaginary axis`, [R`The real axis`, R`The circle $|z| = 2$`, R`The line $y = 2$`], R`The points are equidistant from $(2,0)$ and $(-2,0)$, so $z$ lies on the perpendicular bisector $x = 0$.`, T.arg);
add(R`The locus of $z$ satisfying $\arg z = \dfrac\pi4$ is:`, R`The half-line $y = x$ with $x>0$`, [R`The whole line $y = x$`, R`The circle $|z| = \dfrac{\pi}{4}$`, R`The half-line $y = x$ with $x<0$`], R`All points at angle $\dfrac\pi4$ from the positive real axis form a half-line from the origin.`, T.arg);
add(R`If $|z| = 1$ and $z = \cos\theta+i\sin\theta$, then $z+\dfrac1z$ equals:`, R`$2\cos\theta$`, [R`$2i\sin\theta$`, R`$2$`, R`$\cos2\theta$`], R`$\dfrac1z = \cos\theta-i\sin\theta$, so the sum is $2\cos\theta$.`, T.pol);

// ---------------- polar form and De Moivre
add(R`The product $2(\cos30^\circ+i\sin30^\circ)\times3(\cos60^\circ+i\sin60^\circ)$ equals:`, R`$6i$`, [R`$6$`, R`$5i$`, R`$-6i$`], R`Multiply moduli and add arguments: $6(\cos90^\circ+i\sin90^\circ) = 6i$.`, T.pol);
add(R`The quotient $\dfrac{8(\cos150^\circ+i\sin150^\circ)}{2(\cos30^\circ+i\sin30^\circ)}$ equals:`, R`$-2+2\sqrt3\,i$`, [R`$2-2\sqrt3\,i$`, R`$4$`, R`$-2-2\sqrt3\,i$`], R`Divide moduli, subtract arguments: $4(\cos120^\circ+i\sin120^\circ) = 4\left(-\dfrac12+\dfrac{\sqrt3}{2}i\right)$.`, T.pol);
add(R`The value of $(\sqrt3+i)^6$ is:`, R`$-64$`, [R`$64$`, R`$-64i$`, R`$64i$`], R`$\sqrt3+i = 2\left(\cos\dfrac\pi6+i\sin\dfrac\pi6\right)$, so the sixth power is $64(\cos\pi+i\sin\pi) = -64$.`, T.dm);
add(R`The expression $\dfrac{(\cos\theta+i\sin\theta)^5}{(\cos\theta-i\sin\theta)^2}$ simplifies to:`, R`$\cos7\theta+i\sin7\theta$`, [R`$\cos3\theta+i\sin3\theta$`, R`$\cos10\theta+i\sin10\theta$`, R`$\cos\dfrac52\theta+i\sin\dfrac52\theta$`], R`The denominator is $(\cos\theta+i\sin\theta)^{-2}$, so the result is $(\cos\theta+i\sin\theta)^7$.`, T.dm);
add(R`The value of $(1+i)^{4}$ is:`, R`$-4$`, [R`$4$`, R`$-4i$`, R`$4i$`], R`$(1+i)^2 = 2i$ and $(2i)^2 = -4$.`, T.dm);
add(R`The four fourth roots of $-4$ are:`, R`$\pm1\pm i$`, [R`$\pm2\pm2i$`, R`$\pm\sqrt2\pm\sqrt2\,i$`, R`$\pm1,\ \pm i$`], R`$-4 = 4(\cos\pi+i\sin\pi)$, so the roots have modulus $\sqrt2$ and arguments $\dfrac\pi4+\dfrac{k\pi}{2}$, i.e. $\pm1\pm i$.`, T.dm);
add(R`If $\omega$ is a non-real cube root of unity, then $1+\omega+\omega^2$ equals:`, R`$0$`, [R`$1$`, R`$\omega$`, R`$-1$`], R`The sum of all the $n$th roots of unity ($n\ge2$) is zero.`, T.ru);
add(R`If $\omega$ is a non-real cube root of unity, then $(1+\omega)^3$ equals:`, R`$-1$`, [R`$1$`, R`$0$`, R`$\omega$`], R`$1+\omega = -\omega^2$, so $(1+\omega)^3 = -\omega^6 = -1$.`, T.ru);
add(R`The non-real roots of $z^3 = 1$ are:`, R`$\dfrac{-1\pm i\sqrt3}{2}$`, [R`$\dfrac{1\pm i\sqrt3}{2}$`, R`$\pm i$`, R`$-1\pm i$`], R`$z^3-1 = (z-1)(z^2+z+1)$, and $z^2+z+1 = 0$ gives $z = \dfrac{-1\pm i\sqrt3}{2}$.`, T.ru);
add(R`Euler's formula $e^{i\pi}+1$ equals:`, R`$0$`, [R`$1$`, R`$2$`, R`$-2$`], R`$e^{i\pi} = \cos\pi+i\sin\pi = -1$.`, T.pol);

// ---------------- binomial theorem
chk(nCr(5, 3) * 4, 40);
add(R`The coefficient of $x^3$ in the expansion of $(x+2)^5$ is:`, R`$40$`, [R`$80$`, R`$10$`, R`$20$`], R`$\binom53\cdot2^2 = 10\cdot4 = 40$.`, T.bin);
add(R`The coefficient of $x^4$ in the expansion of $(1-x)^7$ is:`, R`$35$`, [R`$-35$`, R`$21$`, R`$7$`], R`$\binom74(-1)^4 = 35$.`, T.bin);
chk(nCr(4, 2) * 9 * 4, 216);
add(R`The coefficient of $x^2$ in the expansion of $(3x-2)^4$ is:`, R`$216$`, [R`$-216$`, R`$144$`, R`$54$`], R`$\binom42(3x)^2(-2)^2 = 6\cdot9\cdot4 = 216$.`, T.bin);
add(R`The middle term in the expansion of $(a+b)^6$ is:`, R`$20a^3b^3$`, [R`$15a^3b^3$`, R`$20a^2b^4$`, R`$6a^3b^3$`], R`There are $7$ terms; the fourth is $\binom63a^3b^3$.`, T.bin);
chk(nCr(9, 3) * 64 * -1, -5376);
add(R`The term independent of $x$ in the expansion of $\left(2x-\dfrac{1}{x^2}\right)^9$ is:`, R`$-5376$`, [R`$5376$`, R`$-672$`, R`$84$`], R`The general term is $\binom9r(2x)^{9-r}\left(-\dfrac1{x^2}\right)^r$, with power $x^{9-3r}$. For $r = 3$: $\binom93\cdot2^6\cdot(-1)^3 = -5376$.`, T.bin);
add(R`The sum of the coefficients in the expansion of $(2x-1)^5$ is:`, R`$1$`, [R`$32$`, R`$-1$`, R`$243$`], R`Put $x = 1$: $(2-1)^5 = 1$.`, T.bin);
add(R`The value of $n$ for which the coefficients of $x^2$ and $x^3$ in $(1+x)^n$ are equal is:`, R`$5$`, [R`$4$`, R`$6$`, R`$3$`], R`$\binom n2 = \binom n3$ requires $n = 2+3 = 5$.`, T.bin);
add(R`The largest coefficient in the expansion of $(1+x)^8$ is:`, R`$70$`, [R`$56$`, R`$28$`, R`$256$`], R`The middle coefficient is $\binom84 = 70$.`, T.bin);
add(R`The first four terms of $(1+x)^{-1}$ in ascending powers of $x$ are:`, R`$1-x+x^2-x^3$`, [R`$1+x+x^2+x^3$`, R`$1-x-x^2-x^3$`, R`$1-x+\dfrac{x^2}{2}-\dfrac{x^3}{6}$`], R`$(1+x)^{-1} = 1-x+x^2-x^3+\cdots$, valid for $|x|<1$.`, T.bn);
add(R`The expansion of $(1+2x)^{1/2}$ begins:`, R`$1+x-\dfrac{x^2}{2}+\dfrac{x^3}{2}-\cdots$`, [R`$1+x+\dfrac{x^2}{2}+\dfrac{x^3}{2}$`, R`$1+2x-2x^2+4x^3$`, R`$1+x-x^2+x^3$`], R`With $u = 2x$: $1+\dfrac u2-\dfrac{u^2}{8}+\dfrac{u^3}{16}$.`, T.bn);
add(R`The first three terms in the expansion of $(4-x)^{1/2}$ are:`, R`$2-\dfrac x4-\dfrac{x^2}{64}$`, [R`$2-\dfrac x2-\dfrac{x^2}{16}$`, R`$2+\dfrac x4-\dfrac{x^2}{64}$`, R`$2-\dfrac x4+\dfrac{x^2}{64}$`], R`$(4-x)^{1/2} = 2\left(1-\dfrac x4\right)^{1/2} = 2\left(1-\dfrac x8-\dfrac{x^2}{128}-\cdots\right)$.`, T.bn);
add(R`Using the first three terms of the binomial expansion, $\sqrt{1.04}$ is approximately:`, R`$1.0198$`, [R`$1.0200$`, R`$1.0400$`, R`$1.0202$`], R`$(1+0.04)^{1/2}\approx1+0.02-\dfrac{(0.04)^2}{8} = 1+0.02-0.0002 = 1.0198$.`, T.bn);
add(R`The coefficient of $x^5$ in the expansion of $(1-2x)^{-2}$ is:`, R`$192$`, [R`$160$`, R`$64$`, R`$-192$`], R`$(1-2x)^{-2} = \sum(n+1)(2x)^n$, so the coefficient of $x^5$ is $6\cdot32 = 192$.`, T.bn);
add(R`The expansion of $(2+3x)^{-1}$ in powers of $x$ is valid for:`, R`$|x|<\dfrac23$`, [R`$|x|<\dfrac32$`, R`$|x|<1$`, R`$|x|<3$`], R`$(2+3x)^{-1} = \dfrac12\left(1+\dfrac{3x}{2}\right)^{-1}$ needs $\left|\dfrac{3x}2\right|<1$.`, T.bn);

// ---------------- counting
add(R`The number of distinct arrangements of the letters of the word LEVEL is:`, R`$30$`, [R`$120$`, R`$60$`, R`$15$`], R`Five letters with $L$ twice and $E$ twice: $\dfrac{5!}{2!\,2!} = 30$.`, T.perm);
add(R`Four boys and three girls stand in a row with the three girls always together. The number of arrangements is:`, R`$720$`, [R`$5040$`, R`$144$`, R`$120$`], R`Treat the girls as one block: $5!$ arrangements of the five units, and $3!$ orders within the block: $120\times6 = 720$.`, T.perm);
chk(nCr(6, 2) * nCr(4, 2), 90);
add(R`A committee of $4$ is chosen from $6$ men and $4$ women. The number of committees with exactly $2$ women is:`, R`$90$`, [R`$210$`, R`$60$`, R`$45$`], R`$\binom42\binom62 = 6\times15 = 90$.`, T.cnt);
add(R`The number of even three-digit numbers that can be formed from the digits $1, 2, 3, 4, 5$ without repetition is:`, R`$24$`, [R`$60$`, R`$30$`, R`$12$`], R`The last digit is $2$ or $4$ (2 ways); the first two places use $4\times3 = 12$ arrangements. Total $= 24$.`, T.perm);
add(R`The value of $^{10}P_3$ is:`, R`$720$`, [R`$120$`, R`$1000$`, R`$30$`], R`$10\times9\times8 = 720$.`, T.perm);
add(R`The value of $n$ for which $\binom n2 = 45$ is:`, R`$10$`, [R`$9$`, R`$11$`, R`$12$`], R`$\dfrac{n(n-1)}{2} = 45$ gives $n^2-n-90 = 0$, so $n = 10$.`, T.cnt);

module.exports = out;
