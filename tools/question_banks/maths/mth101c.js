// MTH 101 - batch C: sequences and series, induction, trigonometry, circular measure.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { seq: 'Sequences and Series', ind: 'Mathematical Induction', trig: 'Trigonometric Functions', af: 'Addition and Factor Formulae', eq: 'Solving Trigonometric Equations', circ: 'Circular Measure' };
const chk = (a, b) => { if (Math.abs(a - b) > 1e-9) throw new Error('check failed: ' + a + ' vs ' + b); };
const rad = (d) => d * Math.PI / 180;

// ---------------- sequences and series
chk(5 + 19 * 3, 62);
add(R`The first term of an arithmetic progression is $5$ and the common difference is $3$. The $20$th term is:`, R`$62$`, [R`$60$`, R`$65$`, R`$57$`], R`$u_{20} = a+19d = 5+57 = 62$.`, T.seq);
chk(15 / 2 * (4 + 14 * 3), 345);
add(R`The sum of the first $15$ terms of the arithmetic progression $2, 5, 8, \dots$ is:`, R`$345$`, [R`$330$`, R`$360$`, R`$690$`], R`$S_{15} = \dfrac{15}{2}[2(2)+14(3)] = \dfrac{15}{2}(46) = 345$.`, T.seq);
add(R`Which term of the arithmetic progression $4, 9, 14, \dots$ equals $99$?`, R`The $20$th`, [R`The $19$th`, R`The $21$st`, R`The $25$th`], R`$4+(n-1)5 = 99$ gives $n-1 = 19$, so $n = 20$.`, T.seq);
add(R`The fifth term of the geometric progression $3, 6, 12, \dots$ is:`, R`$48$`, [R`$24$`, R`$96$`, R`$30$`], R`$u_5 = ar^4 = 3\cdot16 = 48$.`, T.seq);
chk(2 * (3 ** 8 - 1) / 2, 6560);
add(R`The sum of the first $8$ terms of the geometric progression $2, 6, 18, \dots$ is:`, R`$6560$`, [R`$13122$`, R`$6561$`, R`$3280$`], R`$S_8 = \dfrac{a(r^n-1)}{r-1} = \dfrac{2(3^8-1)}{2} = 6560$.`, T.seq);
add(R`The sum to infinity of $6+2+\dfrac23+\dfrac29+\cdots$ is:`, R`$9$`, [R`$8$`, R`$12$`, R`$\dfrac{9}{2}$`], R`$a = 6$, $r = \dfrac13$: $S_\infty = \dfrac{6}{1-\frac13} = 9$.`, T.seq);
add(R`The recurring decimal $0.\overline{36}$ is equal to the fraction:`, R`$\dfrac{4}{11}$`, [R`$\dfrac{9}{25}$`, R`$\dfrac{36}{100}$`, R`$\dfrac{1}{3}$`], R`$0.36+0.0036+\cdots = \dfrac{0.36}{1-0.01} = \dfrac{36}{99} = \dfrac{4}{11}$.`, T.seq);
add(R`The geometric series $1+\dfrac{x}{2}+\dfrac{x^2}{4}+\cdots$ converges when:`, R`$|x|<2$`, [R`$|x|<1$`, R`$x<2$`, R`$|x|<\dfrac12$`], R`The common ratio is $\dfrac x2$ and a geometric series converges when $\left|\dfrac x2\right|<1$.`, T.seq);
chk(9 / 10, 1 - 1 / 10);
add(R`The value of $\displaystyle\sum_{k=1}^{9}\dfrac{1}{k(k+1)}$ is:`, R`$\dfrac{9}{10}$`, [R`$\dfrac{1}{10}$`, R`$\dfrac{10}{9}$`, R`$\dfrac{8}{9}$`], R`Since $\dfrac{1}{k(k+1)} = \dfrac1k-\dfrac1{k+1}$, the sum telescopes to $1-\dfrac1{10}$.`, T.seq);
chk((6 * 7 / 2) ** 2, 441);
add(R`The value of $1^3+2^3+3^3+4^3+5^3+6^3$ is:`, R`$441$`, [R`$216$`, R`$91$`, R`$506$`], R`$\sum k^3 = \left[\dfrac{n(n+1)}{2}\right]^2 = 21^2 = 441$.`, T.seq);
chk(33 / 2 * (3 + 99), 1683);
add(R`The sum of all the multiples of $3$ from $3$ to $99$ inclusive is:`, R`$1683$`, [R`$1650$`, R`$1716$`, R`$3366$`], R`There are $33$ terms, so $S = \dfrac{33}{2}(3+99) = 1683$.`, T.seq);
add(R`The three arithmetic means inserted between $2$ and $18$ are:`, R`$6,\ 10,\ 14$`, [R`$5,\ 10,\ 15$`, R`$4,\ 8,\ 12$`, R`$6,\ 9,\ 12$`], R`With five terms in all, $18 = 2+4d$ so $d = 4$.`, T.seq);
chk(50000 * 1.08 ** 3, 62985.6);
add(R`A sum of ₦50,000 is invested at $8\%$ per annum compound interest. After $3$ years it amounts to:`, R`₦62,985.60`, [R`₦62,000.00`, R`₦60,000.00`, R`₦63,000.00`], R`$50000(1.08)^3 = 62985.60$.`, T.seq);
add(R`A ball is dropped from a height of $8$ m and after each bounce rises to $\dfrac34$ of its previous height. The total distance it travels before coming to rest is:`, R`$56$ m`, [R`$32$ m`, R`$48$ m`, R`$64$ m`], R`Distance $= 8+2\left(6+4.5+\cdots\right) = 8+2\cdot\dfrac{6}{1-\frac34} = 8+48 = 56$.`, T.seq);
add(R`The sum of the first $n$ terms of a sequence is $S_n = 3n^2-n$. The $n$th term is:`, R`$6n-4$`, [R`$6n-1$`, R`$3n-1$`, R`$6n+4$`], R`$u_n = S_n-S_{n-1} = 3n^2-n-3(n-1)^2+(n-1) = 6n-4$.`, T.seq);
add(R`The numbers $x-1$, $x+1$ and $2x+4$ are consecutive terms of a geometric progression. The values of $x$ are:`, R`$\pm\sqrt5$`, [R`$\pm5$`, R`$5$ only`, R`$\pm\sqrt3$`], R`$(x+1)^2 = (x-1)(2x+4)$ gives $x^2+2x+1 = 2x^2+2x-4$, so $x^2 = 5$.`, T.seq);
chk(3 * 210 - 40, 590);
add(R`The value of $\displaystyle\sum_{k=1}^{20}(3k-2)$ is:`, R`$590$`, [R`$610$`, R`$630$`, R`$570$`], R`$3\sum k-2(20) = 3(210)-40 = 590$.`, T.seq);

// ---------------- induction
add(R`In proving by induction that $1+3+5+\cdots+(2n-1) = n^2$, assume the result for $n = k$. The term that must be added to $k^2$ to reach the case $n = k+1$ is:`, R`$2k+1$`, [R`$2k-1$`, R`$k+1$`, R`$2k$`], R`The $(k+1)$th odd number is $2(k+1)-1 = 2k+1$, and $k^2+2k+1 = (k+1)^2$.`, T.ind);
add(R`The expression $n^3-n$ is divisible by $6$ for every positive integer $n$. Its value when $n = 2$ is:`, R`$6$`, [R`$8$`, R`$2$`, R`$0$`], R`$2^3-2 = 6$.`, T.ind);
add(R`To prove $2^n>n$ for all positive integers $n$ by induction, the basis step uses $n = 1$ and shows that:`, R`$2>1$`, [R`$2=1$`, R`$1>2$`, R`$4>2$`], R`When $n = 1$: $2^1 = 2>1$.`, T.ind);

// ---------------- trigonometry: exact values and identities
add(R`The exact value of $\sin^245^\circ+\cos^230^\circ$ is:`, R`$\dfrac54$`, [R`$1$`, R`$\dfrac34$`, R`$\dfrac{\sqrt2+\sqrt3}{2}$`], R`$\dfrac12+\dfrac34 = \dfrac54$.`, T.trig);
add(R`The exact value of $\tan120^\circ$ is:`, R`$-\sqrt3$`, [R`$\sqrt3$`, R`$-\dfrac{1}{\sqrt3}$`, R`$\dfrac{1}{\sqrt3}$`], R`$120^\circ$ is in the second quadrant where tangent is negative; reference angle $60^\circ$ has $\tan = \sqrt3$.`, T.trig);
add(R`The exact value of $\cos225^\circ$ is:`, R`$-\dfrac{\sqrt2}{2}$`, [R`$\dfrac{\sqrt2}{2}$`, R`$-\dfrac{\sqrt3}{2}$`, R`$-\dfrac12$`], R`$225^\circ$ is in the third quadrant with reference angle $45^\circ$.`, T.trig);
add(R`If $\tan\theta = \dfrac34$ and $\theta$ lies in the third quadrant, then $\sin\theta$ is:`, R`$-\dfrac35$`, [R`$\dfrac35$`, R`$-\dfrac45$`, R`$-\dfrac34$`], R`The hypotenuse is $5$. In the third quadrant sine is negative: $\sin\theta = -\dfrac35$.`, T.trig);
add(R`The expression $\sec^2\theta-\tan^2\theta$ simplifies to:`, R`$1$`, [R`$0$`, R`$\sin^2\theta$`, R`$\cos2\theta$`], R`Divide $\sin^2\theta+\cos^2\theta = 1$ by $\cos^2\theta$.`, T.trig);
add(R`The expression $(\sin x+\cos x)^2$ is equal to:`, R`$1+\sin2x$`, [R`$1+\cos2x$`, R`$1-\sin2x$`, R`$\sin^2x+\cos^2x+\sin x\cos x$`], R`$\sin^2x+\cos^2x+2\sin x\cos x = 1+\sin2x$.`, T.trig);
add(R`The amplitude and period of $y = 3\sin2x$ are respectively:`, R`$3$ and $\pi$`, [R`$3$ and $2\pi$`, R`$6$ and $\pi$`, R`$2$ and $3\pi$`], R`The amplitude is $3$ and the period is $\dfrac{2\pi}{2} = \pi$.`, T.trig);
add(R`The value of $\sin^{-1}\left(\dfrac12\right)$ is:`, R`$\dfrac{\pi}{6}$`, [R`$\dfrac{\pi}{3}$`, R`$\dfrac{\pi}{4}$`, R`$\dfrac{5\pi}{6}$`], R`The principal value of $\sin^{-1}x$ lies in $\left[-\dfrac\pi2,\dfrac\pi2\right]$, and $\sin\dfrac\pi6 = \dfrac12$.`, T.trig);

// ---------------- addition, double angle and factor formulae
{ const sinA = 3 / 5, cosA = 4 / 5, cosB = 5 / 13, sinB = 12 / 13; chk(sinA * cosB + cosA * sinB, 63 / 65); chk(cosA * cosB + sinA * sinB, 56 / 65); }
add(R`If $\sin A = \dfrac35$ and $\cos B = \dfrac{5}{13}$, with $A$ and $B$ both acute, then $\sin(A+B)$ is:`, R`$\dfrac{63}{65}$`, [R`$\dfrac{56}{65}$`, R`$\dfrac{33}{65}$`, R`$\dfrac{16}{65}$`], R`$\cos A = \dfrac45$ and $\sin B = \dfrac{12}{13}$. $\sin(A+B) = \dfrac35\cdot\dfrac5{13}+\dfrac45\cdot\dfrac{12}{13} = \dfrac{63}{65}$.`, T.af);
add(R`If $\sin A = \dfrac35$ and $\cos B = \dfrac{5}{13}$, with $A$ and $B$ both acute, then $\cos(A-B)$ is:`, R`$\dfrac{56}{65}$`, [R`$\dfrac{63}{65}$`, R`$\dfrac{33}{65}$`, R`$\dfrac{16}{65}$`], R`$\cos(A-B) = \cos A\cos B+\sin A\sin B = \dfrac45\cdot\dfrac5{13}+\dfrac35\cdot\dfrac{12}{13} = \dfrac{56}{65}$.`, T.af);
add(R`If $\tan A = \dfrac12$ and $\tan B = \dfrac13$, then $A+B$ equals:`, R`$45^\circ$`, [R`$30^\circ$`, R`$60^\circ$`, R`$90^\circ$`], R`$\tan(A+B) = \dfrac{\frac12+\frac13}{1-\frac16} = \dfrac{5/6}{5/6} = 1$.`, T.af);
add(R`If $\cos\theta = \dfrac13$, then $\cos2\theta$ is:`, R`$-\dfrac79$`, [R`$\dfrac79$`, R`$\dfrac29$`, R`$-\dfrac23$`], R`$\cos2\theta = 2\cos^2\theta-1 = \dfrac29-1 = -\dfrac79$.`, T.af);
add(R`If $\sin\theta = \dfrac12$, then $\sin3\theta$ is:`, R`$1$`, [R`$\dfrac32$`, R`$\dfrac12$`, R`$0$`], R`$\sin3\theta = 3\sin\theta-4\sin^3\theta = \dfrac32-\dfrac12 = 1$.`, T.af);
add(R`The exact value of $\sin75^\circ+\sin15^\circ$ is:`, R`$\dfrac{\sqrt6}{2}$`, [R`$\dfrac{\sqrt2}{2}$`, R`$\dfrac{\sqrt3}{2}$`, R`$\dfrac{\sqrt6}{4}$`], R`$\sin75^\circ+\sin15^\circ = 2\sin45^\circ\cos30^\circ = 2\cdot\dfrac{\sqrt2}{2}\cdot\dfrac{\sqrt3}{2} = \dfrac{\sqrt6}{2}$.`, T.af);
add(R`The sum $\cos5x+\cos3x$ can be written as:`, R`$2\cos4x\cos x$`, [R`$2\sin4x\sin x$`, R`$2\cos4x\sin x$`, R`$\cos8x$`], R`$\cos P+\cos Q = 2\cos\dfrac{P+Q}{2}\cos\dfrac{P-Q}{2}$.`, T.af);
add(R`The maximum value of $3\sin x+4\cos x$ is:`, R`$5$`, [R`$7$`, R`$12$`, R`$\sqrt7$`], R`$3\sin x+4\cos x = 5\sin(x+\alpha)$ with $R = \sqrt{3^2+4^2} = 5$.`, T.af);
add(R`The expansion of $\cos\left(\dfrac\pi3+x\right)$ is:`, R`$\dfrac12\cos x-\dfrac{\sqrt3}{2}\sin x$`, [R`$\dfrac12\cos x+\dfrac{\sqrt3}{2}\sin x$`, R`$\dfrac{\sqrt3}{2}\cos x-\dfrac12\sin x$`, R`$\cos x+\dfrac{\sqrt3}{2}$`], R`$\cos(A+B) = \cos A\cos B-\sin A\sin B$ with $A = \dfrac\pi3$.`, T.af);
add(R`The exact value of $\cos22.5^\circ$ is:`, R`$\dfrac{\sqrt{2+\sqrt2}}{2}$`, [R`$\dfrac{\sqrt{2-\sqrt2}}{2}$`, R`$\dfrac{1+\sqrt2}{4}$`, R`$\dfrac{\sqrt3}{4}$`], R`$\cos^2\theta = \dfrac{1+\cos2\theta}{2}$ with $2\theta = 45^\circ$ gives $\cos^222.5^\circ = \dfrac{2+\sqrt2}{4}$.`, T.af);

// ---------------- trigonometric equations
add(R`The solutions of $2\cos x = 1$ for $0^\circ\le x\le360^\circ$ are:`, R`$60^\circ$ and $300^\circ$`, [R`$30^\circ$ and $330^\circ$`, R`$60^\circ$ and $120^\circ$`, R`$120^\circ$ and $240^\circ$`], R`$\cos x = \dfrac12$ has solutions $x = 60^\circ$ and $360^\circ-60^\circ = 300^\circ$.`, T.eq);
add(R`The solutions of $\sin2x = \sin x$ for $0\le x<2\pi$ are:`, R`$0,\ \dfrac\pi3,\ \pi,\ \dfrac{5\pi}{3}$`, [R`$0,\ \dfrac\pi3,\ \dfrac{2\pi}{3},\ \pi$`, R`$\dfrac\pi3,\ \dfrac{5\pi}{3}$`, R`$0,\ \pi$`], R`$\sin x(2\cos x-1) = 0$ gives $\sin x = 0$ ($x = 0, \pi$) or $\cos x = \dfrac12$ ($x = \dfrac\pi3, \dfrac{5\pi}3$).`, T.eq);
add(R`The solutions of $\tan x = -1$ for $0\le x<2\pi$ are:`, R`$\dfrac{3\pi}{4}$ and $\dfrac{7\pi}{4}$`, [R`$\dfrac{\pi}{4}$ and $\dfrac{5\pi}{4}$`, R`$\dfrac{3\pi}{4}$ and $\dfrac{5\pi}{4}$`, R`$\dfrac{\pi}{4}$ and $\dfrac{7\pi}{4}$`], R`Tangent is negative in the second and fourth quadrants, with reference angle $\dfrac\pi4$.`, T.eq);
add(R`The solutions of $2\sin^2x+3\cos x-3=0$ for $0\le x<2\pi$ are:`, R`$0,\ \dfrac\pi3,\ \dfrac{5\pi}{3}$`, [R`$\dfrac\pi3,\ \dfrac{5\pi}{3}$`, R`$0,\ \dfrac{2\pi}{3},\ \dfrac{4\pi}{3}$`, R`$\dfrac\pi6,\ \dfrac{5\pi}{6}$`], R`Using $\sin^2x = 1-\cos^2x$: $2\cos^2x-3\cos x+1 = 0$, so $(2\cos x-1)(\cos x-1) = 0$ and $\cos x = \dfrac12$ or $1$.`, T.eq);
add(R`The general solution of $\sin x = \dfrac12$ is:`, R`$x = n\pi+(-1)^n\dfrac\pi6$`, [R`$x = 2n\pi\pm\dfrac\pi6$`, R`$x = n\pi+\dfrac\pi6$`, R`$x = 2n\pi+\dfrac\pi3$`], R`The general solution of $\sin x = \sin\alpha$ is $x = n\pi+(-1)^n\alpha$.`, T.eq);

// ---------------- circular measure
add(R`An angle of $135^\circ$ expressed in radians is:`, R`$\dfrac{3\pi}{4}$`, [R`$\dfrac{2\pi}{3}$`, R`$\dfrac{3\pi}{2}$`, R`$\dfrac{5\pi}{6}$`], R`$135\times\dfrac{\pi}{180} = \dfrac{3\pi}{4}$.`, T.circ);
add(R`A circle has radius $8$ cm. An arc subtends an angle of $0.75$ radians at the centre. The arc length is:`, R`$6$ cm`, [R`$12$ cm`, R`$0.75$ cm`, R`$24$ cm`], R`$s = r\theta = 8\times0.75 = 6$.`, T.circ);
add(R`The area of a sector of a circle of radius $10$ cm with angle $72^\circ$ is:`, R`$20\pi$ cm²`, [R`$10\pi$ cm²`, R`$40\pi$ cm²`, R`$72\pi$ cm²`], R`$72^\circ = \dfrac{2\pi}{5}$ and $A = \dfrac12r^2\theta = \dfrac12\cdot100\cdot\dfrac{2\pi}{5} = 20\pi$.`, T.circ);
chk(18 * (Math.PI / 3 - Math.sin(Math.PI / 3)), 6 * Math.PI - 9 * Math.sqrt(3));
add(R`The area of the segment cut off by a chord subtending an angle of $\dfrac\pi3$ at the centre of a circle of radius $6$ cm is:`, R`$6\pi-9\sqrt3$ cm²`, [R`$6\pi$ cm²`, R`$6\pi-18\sqrt3$ cm²`, R`$9\sqrt3$ cm²`], R`Segment $= \dfrac12r^2(\theta-\sin\theta) = 18\left(\dfrac\pi3-\dfrac{\sqrt3}{2}\right) = 6\pi-9\sqrt3$.`, T.circ);

module.exports = out;
