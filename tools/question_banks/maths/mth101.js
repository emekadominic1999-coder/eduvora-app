// MTH 101 (Elementary Mathematics I) - hand-set questions: algebra, logarithms, sequences, trigonometry, complex numbers, binomial theorem.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { pf: 'Partial Fractions', ineq: 'Inequalities', log: 'Logarithms and Exponential Equations', poly: 'Polynomials and the Factor Theorem', quad: 'Theory of Quadratic Equations', seq: 'Sequences and Series', ind: 'Mathematical Induction', trig: 'Trigonometric Functions', eq: 'Solving Trigonometric Equations', circ: 'Circular Measure', cx: 'Complex Numbers', pol: 'De Moivre\'s Theorem', bin: 'Binomial Theorem', fn: 'Functions and Relations' };
const eq = (a, b, m) => { if (Math.abs(a - b) > 1e-9) throw new Error('check failed: ' + m + ' ' + a + ' vs ' + b); };

// ---------------- partial fractions
add(R`Resolve $\dfrac{3x+5}{(x+1)(x+3)}$ into partial fractions.`, R`$\dfrac{1}{x+1}+\dfrac{2}{x+3}$`, [R`$\dfrac{2}{x+1}+\dfrac{1}{x+3}$`, R`$\dfrac{1}{x+1}-\dfrac{2}{x+3}$`, R`$\dfrac{3}{x+1}+\dfrac{5}{x+3}$`], R`Put $3x+5 = A(x+3)+B(x+1)$. At $x=-1$: $2 = 2A$ so $A = 1$. At $x=-3$: $-4 = -2B$ so $B = 2$.`, T.pf);
add(R`Resolve $\dfrac{2x^2+3}{x(x^2+1)}$ into partial fractions.`, R`$\dfrac{3}{x}-\dfrac{x}{x^2+1}$`, [R`$\dfrac{3}{x}+\dfrac{x}{x^2+1}$`, R`$\dfrac{2}{x}+\dfrac{3}{x^2+1}$`, R`$\dfrac{3}{x}-\dfrac{1}{x^2+1}$`], R`Write $2x^2+3 = A(x^2+1)+(Bx+C)x$. Then $A = 3$, $A+B = 2$ so $B = -1$, and $C = 0$.`, T.pf);
add(R`Resolve $\dfrac{x+4}{(x-1)^2}$ into partial fractions.`, R`$\dfrac{1}{x-1}+\dfrac{5}{(x-1)^2}$`, [R`$\dfrac{5}{x-1}+\dfrac{1}{(x-1)^2}$`, R`$\dfrac{1}{x-1}-\dfrac{5}{(x-1)^2}$`, R`$\dfrac{4}{x-1}+\dfrac{1}{(x-1)^2}$`], R`Write $x+4 = (x-1)+5$ and divide by $(x-1)^2$.`, T.pf);
add(R`If $\dfrac{7x-1}{(x-1)(x+2)(x-3)} = \dfrac{A}{x-1}+\dfrac{B}{x+2}+\dfrac{C}{x-3}$, then $A$ is:`, R`$-1$`, [R`$1$`, R`$\dfrac{1}{2}$`, R`$-\dfrac{1}{2}$`], R`By the cover-up rule at $x = 1$: $A = \dfrac{7(1)-1}{(1+2)(1-3)} = \dfrac{6}{-6} = -1$.`, T.pf);

// ---------------- inequalities
add(R`The solution set of $|2x-3|<5$ is:`, R`$-1<x<4$`, [R`$x<-1$ or $x>4$`, R`$-4<x<1$`, R`$1<x<4$`], R`$-5<2x-3<5$ gives $-2<2x<8$, so $-1<x<4$.`, T.ineq);
add(R`The solution set of $|x+1|\ge3$ is:`, R`$x\le-4$ or $x\ge2$`, [R`$-4\le x\le2$`, R`$x\le-2$ or $x\ge4$`, R`$x\ge2$`], R`$x+1\ge3$ or $x+1\le-3$, so $x\ge2$ or $x\le-4$.`, T.ineq);
add(R`The values of $x$ satisfying $x^2-5x+6<0$ are:`, R`$2<x<3$`, [R`$x<2$ or $x>3$`, R`$-3<x<-2$`, R`$x<3$`], R`$(x-2)(x-3)<0$ holds between the roots.`, T.ineq);
add(R`The solution of $\dfrac{x-1}{x+2}\ge0$ is:`, R`$x<-2$ or $x\ge1$`, [R`$-2<x\le1$`, R`$x\le-2$ or $x\ge1$`, R`$x\ge1$`], R`The quotient is non-negative when numerator and denominator have the same sign (denominator non-zero): $x<-2$ or $x\ge1$.`, T.ineq);
add(R`The solution of $\dfrac{3}{x-2}<1$ is:`, R`$x<2$ or $x>5$`, [R`$2<x<5$`, R`$x>5$`, R`$x<5$`], R`$\dfrac{3-(x-2)}{x-2} = \dfrac{5-x}{x-2}<0$, which holds for $x<2$ or $x>5$.`, T.ineq);
add(R`The inequality $x^2-4x-5>0$ has solution set:`, R`$x<-1$ or $x>5$`, [R`$-1<x<5$`, R`$x<-5$ or $x>1$`, R`$x>5$`], R`$(x-5)(x+1)>0$ holds outside the roots.`, T.ineq);

// ---------------- logarithms and exponential equations
add(R`Solve $\log_2x+\log_2(x-2)=3$.`, R`$x = 4$`, [R`$x = -2$`, R`$x = 4$ or $x = -2$`, R`$x = 2$`], R`$x(x-2) = 8$ gives $x^2-2x-8 = 0$, so $x = 4$ or $-2$. Only $x = 4$ keeps both logarithms defined.`, T.log);
add(R`Solve $4^x-5\cdot2^x+4=0$.`, R`$x = 0$ or $x = 2$`, [R`$x = 1$ or $x = 4$`, R`$x = 0$ only`, R`$x = 2$ only`], R`Let $u = 2^x$: $u^2-5u+4 = 0$ gives $u = 1$ or $u = 4$, so $x = 0$ or $x = 2$.`, T.log);
add(R`Solve $e^{2x}-3e^x+2=0$.`, R`$x = 0$ or $x = \ln2$`, [R`$x = 1$ or $x = 2$`, R`$x = \ln3$`, R`$x = 0$ or $x = 2$`], R`Let $u = e^x$: $(u-1)(u-2) = 0$, so $x = \ln1 = 0$ or $x = \ln2$.`, T.log);
add(R`If $\ln(x+1)=2$, then $x$ equals:`, R`$e^2-1$`, [R`$e^2+1$`, R`$2e-1$`, R`$2$`], R`$x+1 = e^2$.`, T.log);
add(R`Simplify $\log_3 81-\log_3 3+\log_3\dfrac{1}{9}$.`, R`$1$`, [R`$2$`, R`$3$`, R`$-1$`], R`$4-1-2 = 1$.`, T.log);
add(R`Solve $3^{2x+1}=27$.`, R`$x = 1$`, [R`$x = 2$`, R`$x = \dfrac{3}{2}$`, R`$x = 0$`], R`$3^{2x+1} = 3^3$, so $2x+1 = 3$ and $x = 1$.`, T.log);

// ---------------- polynomials and quadratics
add(R`The remainder when $x^3-2x+5$ is divided by $x-2$ is:`, R`$9$`, [R`$5$`, R`$1$`, R`$17$`], R`By the remainder theorem the remainder is $P(2) = 8-4+5 = 9$.`, T.poly);
add(R`If $(x-1)$ is a factor of $x^3+kx^2-4x+4$, then $k$ equals:`, R`$-1$`, [R`$1$`, R`$-4$`, R`$0$`], R`$P(1) = 1+k-4+4 = k+1 = 0$, so $k = -1$.`, T.poly);
add(R`The sum and product of the roots of $2x^3-5x^2+x+3=0$ are respectively:`, R`$\dfrac{5}{2}$ and $-\dfrac{3}{2}$`, [R`$-\dfrac{5}{2}$ and $\dfrac{3}{2}$`, R`$\dfrac{5}{2}$ and $\dfrac{3}{2}$`, R`$5$ and $-3$`], R`For $ax^3+bx^2+cx+d$: sum $= -\dfrac ba = \dfrac52$ and product $= -\dfrac da = -\dfrac32$.`, T.poly);
add(R`If $\alpha$ and $\beta$ are the roots of $x^2-6x+4=0$, then $\alpha^2+\beta^2$ is:`, R`$28$`, [R`$36$`, R`$32$`, R`$20$`], R`$\alpha^2+\beta^2 = (\alpha+\beta)^2-2\alpha\beta = 36-8 = 28$.`, T.quad);
add(R`If $\alpha$ and $\beta$ are the roots of $x^2-6x+4=0$, then $\alpha^3+\beta^3$ is:`, R`$144$`, [R`$216$`, R`$72$`, R`$168$`], R`$\alpha^3+\beta^3 = (\alpha+\beta)^3-3\alpha\beta(\alpha+\beta) = 216-72 = 144$.`, T.quad);
add(R`If $\alpha$ and $\beta$ are the roots of $x^2-6x+4=0$, the quadratic equation with roots $\alpha+1$ and $\beta+1$ is:`, R`$x^2-8x+11=0$`, [R`$x^2-8x+4=0$`, R`$x^2-6x+11=0$`, R`$x^2-8x+9=0$`], R`Sum $= 6+2 = 8$; product $= \alpha\beta+\alpha+\beta+1 = 4+6+1 = 11$.`, T.quad);
add(R`The equation $x^2+kx+9=0$ has equal roots when $k$ equals:`, R`$\pm6$`, [R`$\pm3$`, R`$6$ only`, R`$\pm9$`], R`Equal roots need $k^2-4(9) = 0$, so $k = \pm6$.`, T.quad);
add(R`For what values of $k$ does $x^2-4x+k=0$ have real roots?`, R`$k\le4$`, [R`$k\ge4$`, R`$k<4$`, R`$k>4$`], R`Real roots need discriminant $16-4k\ge0$, so $k\le4$.`, T.quad);

// ---------------- sequences and series
add(R`The 3rd term of an arithmetic progression is $12$ and the 7th term is $28$. The sum of the first $20$ terms is:`, R`$840$`, [R`$800$`, R`$880$`, R`$420$`], R`$d = \dfrac{28-12}{4} = 4$ and $a = 12-8 = 4$. $S_{20} = 10(2\cdot4+19\cdot4) = 10(84) = 840$.`, T.seq);
add(R`The sum to infinity of the geometric series $2+1+\dfrac12+\dfrac14+\cdots$ is:`, R`$4$`, [R`$3$`, R`$2$`, R`$\infty$`], R`$S_\infty = \dfrac{a}{1-r} = \dfrac{2}{1-\frac12} = 4$.`, T.seq);
add(R`The smallest number of terms of the geometric progression $3, 6, 12, \dots$ whose sum exceeds $1000$ is:`, R`$9$`, [R`$8$`, R`$10$`, R`$334$`], R`$S_n = 3(2^n-1)>1000$ gives $2^n>334.3$, so $n = 9$ (since $2^8 = 256$ is too small).`, T.seq);
add(R`The sum $\displaystyle\sum_{k=1}^{10}k^2$ equals:`, R`$385$`, [R`$55$`, R`$3025$`, R`$330$`], R`$\dfrac{n(n+1)(2n+1)}{6} = \dfrac{10\cdot11\cdot21}{6} = 385$.`, T.seq);
add(R`The sum of the first $n$ odd numbers $1+3+5+\cdots+(2n-1)$ is:`, R`$n^2$`, [R`$n(n+1)$`, R`$2n-1$`, R`$\dfrac{n(n+1)}{2}$`], R`This is an arithmetic series with $a = 1$, $d = 2$: $S_n = \dfrac n2[2+2(n-1)] = n^2$.`, T.seq);
add(R`If the sum of the first $n$ terms of a sequence is $S_n = n^2+2n$, the $n$th term is:`, R`$2n+1$`, [R`$2n$`, R`$n^2+2n-1$`, R`$2n+2$`], R`$a_n = S_n-S_{n-1} = n^2+2n-(n-1)^2-2(n-1) = 2n+1$.`, T.seq);
add(R`The sequence is defined by $u_1 = 1$ and $u_{n+1} = 2u_n+1$. The value of $u_4$ is:`, R`$15$`, [R`$7$`, R`$16$`, R`$9$`], R`$u_2 = 3$, $u_3 = 7$, $u_4 = 15$.`, T.seq);
add(R`Three numbers are in arithmetic progression with sum $24$ and product $480$. The numbers are:`, R`$6, 8, 10$`, [R`$4, 8, 12$`, R`$5, 8, 11$`, R`$2, 8, 14$`], R`The middle term is $24/3 = 8$. With common difference $d$: $8(8-d)(8+d) = 480$ gives $64-d^2 = 60$, so $d = \pm2$ and the numbers are $6, 8, 10$.`, T.seq);

// ---------------- induction
add(R`In proving by induction that $1+2+3+\cdots+n = \dfrac{n(n+1)}{2}$, the inductive step assumes the result for $n = k$ and then shows that $1+2+\cdots+k+(k+1)$ equals:`, R`$\dfrac{(k+1)(k+2)}{2}$`, [R`$\dfrac{k(k+1)}{2}+1$`, R`$\dfrac{(k+1)^2}{2}$`, R`$\dfrac{k(k+2)}{2}$`], R`The result for $n = k+1$ is obtained by replacing $n$ with $k+1$ in the formula.`, T.ind);
add(R`To prove by induction that $7^n-1$ is divisible by $6$ for all positive integers $n$, which expression is used in the inductive step?`, R`$7^{k+1}-1 = 7(7^k-1)+6$`, [R`$7^{k+1}-1 = 7^k-1+7$`, R`$7^{k+1}-1 = 6(7^k-1)$`, R`$7^{k+1}-1 = 7^k+6$`], R`Since $7^k-1$ is a multiple of $6$ by hypothesis, so is $7(7^k-1)+6$.`, T.ind);

// ---------------- trigonometry
add(R`The exact value of $\sin75^\circ$ is:`, R`$\dfrac{\sqrt6+\sqrt2}{4}$`, [R`$\dfrac{\sqrt6-\sqrt2}{4}$`, R`$\dfrac{\sqrt3+1}{2}$`, R`$\dfrac{\sqrt6+\sqrt2}{2}$`], R`$\sin(45^\circ+30^\circ) = \dfrac{\sqrt2}{2}\cdot\dfrac{\sqrt3}{2}+\dfrac{\sqrt2}{2}\cdot\dfrac12 = \dfrac{\sqrt6+\sqrt2}{4}$.`, T.trig);
add(R`The exact value of $\tan75^\circ$ is:`, R`$2+\sqrt3$`, [R`$2-\sqrt3$`, R`$\sqrt3+1$`, R`$\dfrac{\sqrt3}{3}$`], R`$\tan(45^\circ+30^\circ) = \dfrac{1+\frac{1}{\sqrt3}}{1-\frac{1}{\sqrt3}} = \dfrac{\sqrt3+1}{\sqrt3-1} = 2+\sqrt3$.`, T.trig);
add(R`If $\sin\theta = \dfrac{3}{5}$ and $\theta$ is acute, then $\sin2\theta$ is:`, R`$\dfrac{24}{25}$`, [R`$\dfrac{6}{5}$`, R`$\dfrac{7}{25}$`, R`$\dfrac{12}{25}$`], R`$\cos\theta = \dfrac45$ and $\sin2\theta = 2\cdot\dfrac35\cdot\dfrac45 = \dfrac{24}{25}$.`, T.trig);
add(R`If $\sin\theta = \dfrac{3}{5}$ and $\theta$ is acute, then $\cos2\theta$ is:`, R`$\dfrac{7}{25}$`, [R`$\dfrac{24}{25}$`, R`$-\dfrac{7}{25}$`, R`$\dfrac{16}{25}$`], R`$\cos2\theta = 1-2\sin^2\theta = 1-\dfrac{18}{25} = \dfrac{7}{25}$.`, T.trig);
add(R`The maximum value of $\sin x+\cos x$ is:`, R`$\sqrt2$`, [R`$2$`, R`$1$`, R`$\dfrac{\sqrt2}{2}$`], R`$\sin x+\cos x = \sqrt2\sin\left(x+\dfrac\pi4\right)$, with maximum $\sqrt2$.`, T.trig);
add(R`The expression $\dfrac{1-\cos2x}{\sin2x}$ simplifies to:`, R`$\tan x$`, [R`$\cot x$`, R`$\sin x$`, R`$2\tan x$`], R`$\dfrac{2\sin^2x}{2\sin x\cos x} = \tan x$.`, T.trig);
add(R`The solutions of $2\sin^2x-\sin x-1=0$ for $0\le x<2\pi$ are:`, R`$\dfrac\pi2$, $\dfrac{7\pi}{6}$, $\dfrac{11\pi}{6}$`, [R`$\dfrac\pi6$, $\dfrac{5\pi}{6}$, $\dfrac{3\pi}{2}$`, R`$\dfrac\pi2$, $\dfrac{\pi}{6}$, $\dfrac{5\pi}{6}$`, R`$\dfrac{3\pi}{2}$ only`], R`$(2\sin x+1)(\sin x-1) = 0$: $\sin x = 1$ gives $\dfrac\pi2$; $\sin x = -\dfrac12$ gives $\dfrac{7\pi}6$ and $\dfrac{11\pi}6$.`, T.eq);
add(R`The solution of $\tan2x=1$ for $0\le x<\dfrac\pi2$ is:`, R`$x = \dfrac\pi8$`, [R`$x = \dfrac\pi4$`, R`$x = \dfrac\pi2$`, R`$x = \dfrac{\pi}{16}$`], R`$2x = \dfrac\pi4+n\pi$, so $x = \dfrac\pi8+\dfrac{n\pi}2$. In $[0,\pi/2)$ only $x = \dfrac\pi8$ qualifies.`, T.eq);
add(R`An angle of $660^\circ$ expressed in radians is:`, R`$\dfrac{11\pi}{3}$`, [R`$\dfrac{11\pi}{6}$`, R`$\dfrac{22\pi}{3}$`, R`$\dfrac{5\pi}{3}$`], R`$660\times\dfrac{\pi}{180} = \dfrac{11\pi}{3}$.`, T.circ);
add(R`A circle has radius $6$ cm. The length of an arc subtending an angle of $\dfrac\pi3$ radians at the centre is:`, R`$2\pi$ cm`, [R`$6\pi$ cm`, R`$\pi$ cm`, R`$\dfrac{\pi}{3}$ cm`], R`$s = r\theta = 6\cdot\dfrac\pi3 = 2\pi$.`, T.circ);
add(R`A circle has radius $6$ cm. The area of the sector with angle $\dfrac\pi3$ radians is:`, R`$6\pi$ cm²`, [R`$2\pi$ cm²`, R`$12\pi$ cm²`, R`$18\pi$ cm²`], R`$A = \dfrac12r^2\theta = \dfrac12\cdot36\cdot\dfrac\pi3 = 6\pi$.`, T.circ);

// ---------------- complex numbers
add(R`The value of $(3+2i)(1-i)$ is:`, R`$5-i$`, [R`$5+i$`, R`$1-i$`, R`$3-2i$`], R`$3-3i+2i-2i^2 = 3-i+2 = 5-i$.`, T.cx);
add(R`The complex number $\dfrac{2+i}{1-i}$ in the form $a+bi$ is:`, R`$\dfrac12+\dfrac32i$`, [R`$\dfrac12-\dfrac32i$`, R`$1+i$`, R`$2+i$`], R`Multiply by $\dfrac{1+i}{1+i}$: $\dfrac{(2+i)(1+i)}{2} = \dfrac{1+3i}{2}$.`, T.cx);
add(R`The principal argument of $-1-i$ is:`, R`$-\dfrac{3\pi}{4}$`, [R`$\dfrac{3\pi}{4}$`, R`$-\dfrac{\pi}{4}$`, R`$\dfrac{5\pi}{4}$`], R`The point is in the third quadrant at $45^\circ$ from the negative real axis; the principal argument lies in $(-\pi,\pi]$, so it is $-\dfrac{3\pi}{4}$.`, T.cx);
add(R`The value of $i^{2025}$ is:`, R`$i$`, [R`$1$`, R`$-1$`, R`$-i$`], R`$2025 = 4(506)+1$, so $i^{2025} = i$.`, T.cx);
add(R`The solutions of $z^2+2z+5=0$ are:`, R`$z = -1\pm2i$`, [R`$z = 1\pm2i$`, R`$z = -1\pm i$`, R`$z = -2\pm i$`], R`$z = \dfrac{-2\pm\sqrt{4-20}}{2} = -1\pm2i$.`, T.cx);
add(R`The polar form of $-\sqrt3+i$ is:`, R`$2\left(\cos\dfrac{5\pi}{6}+i\sin\dfrac{5\pi}{6}\right)$`, [R`$2\left(\cos\dfrac{\pi}{6}+i\sin\dfrac{\pi}{6}\right)$`, R`$2\left(\cos\dfrac{2\pi}{3}+i\sin\dfrac{2\pi}{3}\right)$`, R`$4\left(\cos\dfrac{5\pi}{6}+i\sin\dfrac{5\pi}{6}\right)$`], R`$r = \sqrt{3+1} = 2$ and the point is in the second quadrant with $\tan^{-1}\left(\dfrac{1}{\sqrt3}\right) = \dfrac\pi6$ from the negative axis, so $\theta = \dfrac{5\pi}{6}$.`, T.cx);
add(R`The value of $(1+i)^8$ is:`, R`$16$`, [R`$8$`, R`$-16$`, R`$16i$`], R`$(1+i)^2 = 2i$, so $(1+i)^8 = (2i)^4 = 16$.`, T.pol);
add(R`The value of $(1+i)^6$ is:`, R`$-8i$`, [R`$8i$`, R`$-8$`, R`$8$`], R`$(1+i)^2 = 2i$, so $(1+i)^6 = (2i)^3 = 8i^3 = -8i$.`, T.pol);
add(R`The three cube roots of $8$ are:`, R`$2$, $-1+i\sqrt3$, $-1-i\sqrt3$`, [R`$2$, $1+i\sqrt3$, $1-i\sqrt3$`, R`$2$, $-2$, $2i$`, R`$2$, $-1+i$, $-1-i$`], R`They are $2\left(\cos\dfrac{2k\pi}{3}+i\sin\dfrac{2k\pi}{3}\right)$ for $k = 0, 1, 2$.`, T.pol);
add(R`The modulus of $\dfrac{3-4i}{1+i}$ is:`, R`$\dfrac{5}{\sqrt2}$`, [R`$5\sqrt2$`, R`$\dfrac{5}{2}$`, R`$5$`], R`$|z_1/z_2| = |z_1|/|z_2| = \dfrac{5}{\sqrt2}$.`, T.cx);
add(R`In the Argand diagram, the locus of $z$ satisfying $|z-1|=2$ is:`, R`A circle with centre $(1, 0)$ and radius $2$`, [R`A circle with centre $(-1, 0)$ and radius $2$`, R`A circle with centre $(1, 0)$ and radius $4$`, R`A straight line through $(1, 0)$`], R`$|z-z_0| = r$ is the circle with centre $z_0$ and radius $r$.`, T.cx);

// ---------------- binomial theorem
add(R`The coefficient of $x^3$ in the expansion of $(1+2x)^6$ is:`, R`$160$`, [R`$20$`, R`$120$`, R`$80$`], R`$\binom63(2x)^3 = 20\cdot8x^3 = 160x^3$.`, T.bin);
add(R`The term independent of $x$ in the expansion of $\left(x+\dfrac1x\right)^6$ is:`, R`$20$`, [R`$15$`, R`$6$`, R`$1$`], R`The general term is $\binom6rx^{6-2r}$; $r = 3$ gives $\binom63 = 20$.`, T.bin);
add(R`The coefficient of $x^2$ in the expansion of $(2-x)^5$ is:`, R`$80$`, [R`$-80$`, R`$40$`, R`$10$`], R`$\binom52(2)^3(-x)^2 = 10\cdot8x^2 = 80x^2$.`, T.bin);
add(R`The first three terms in the expansion of $(1-3x)^{-2}$ in ascending powers of $x$ are:`, R`$1+6x+27x^2$`, [R`$1-6x+27x^2$`, R`$1+6x+9x^2$`, R`$1+3x+9x^2$`], R`$(1+u)^{-2} = 1-2u+3u^2$ with $u = -3x$: $1+6x+27x^2$.`, T.bin);
add(R`Using the first three terms of a binomial expansion, $(1.02)^{10}$ is approximately:`, R`$1.219$`, [R`$1.200$`, R`$1.020$`, R`$1.250$`], R`$(1+0.02)^{10}\approx1+10(0.02)+45(0.02)^2 = 1+0.2+0.018 = 1.218\approx1.219$ (the next term adds $0.001$).`, T.bin);
add(R`The sum of the coefficients in the expansion of $(1+x)^{10}$ is:`, R`$1024$`, [R`$100$`, R`$512$`, R`$1023$`], R`Put $x = 1$: $2^{10} = 1024$.`, T.bin);

// ---------------- functions
add(R`If $f(x) = \dfrac{2x+1}{x-3}$, then $f^{-1}(x)$ is:`, R`$\dfrac{3x+1}{x-2}$`, [R`$\dfrac{x-3}{2x+1}$`, R`$\dfrac{3x-1}{x+2}$`, R`$\dfrac{x+3}{2x-1}$`], R`Put $y = \dfrac{2x+1}{x-3}$: $xy-3y = 2x+1$ so $x(y-2) = 3y+1$ and $x = \dfrac{3y+1}{y-2}$.`, T.fn);
add(R`If $f(x) = x^2+1$ and $g(x) = 2x-3$, then $(f\circ g)(2)$ is:`, R`$2$`, [R`$5$`, R`$1$`, R`$10$`], R`$g(2) = 1$ and $f(1) = 2$.`, T.fn);
add(R`The domain of $f(x) = \sqrt{x-1}+\dfrac{1}{x-5}$ is:`, R`$x\ge1$ and $x\ne5$`, [R`$x>1$`, R`$x\ge1$`, R`$x\ne5$`], R`The root needs $x\ge1$ and the fraction needs $x\ne5$.`, T.fn);

module.exports = out;
