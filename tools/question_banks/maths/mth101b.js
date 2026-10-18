// MTH 101 - batch B: sets, relations and functions, real numbers, quadratics, polynomials, logarithms.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { set: 'Set Theory', rel: 'Relations and Functions', real: 'Real Numbers', quad: 'Theory of Quadratic Equations', poly: 'Polynomials and the Factor Theorem', log: 'Logarithms and Exponential Equations', ineq: 'Inequalities', pf: 'Partial Fractions' };
const chk = (a, b) => { if (Math.abs(a - b) > 1e-9) throw new Error('check failed: ' + a + ' vs ' + b); };

// ---------------- sets
add(R`In a school of $120$ students, $70$ study Physics, $60$ study Chemistry and $50$ study Biology. $30$ study Physics and Chemistry, $25$ study Chemistry and Biology, $20$ study Physics and Biology, and $10$ study all three. The number who study at least one of the three subjects is:`, R`$115$`, [R`$105$`, R`$120$`, R`$125$`], R`$n(P\cup C\cup B) = 70+60+50-30-25-20+10 = 115$.`, T.set);
add(R`If $A = \{1,2,3,4\}$ and $B = \{3,4,5\}$, the number of elements of the Cartesian product $A\times B$ is:`, R`$12$`, [R`$7$`, R`$6$`, R`$9$`], R`$n(A\times B) = n(A)\cdot n(B) = 4\times3 = 12$.`, T.set);
add(R`If $A\subseteq B$, the set $A\cap B'$ is equal to:`, R`$\varnothing$`, [R`$A$`, R`$B$`, R`$B-A$`], R`Every element of $A$ lies in $B$, so no element of $A$ is outside $B$.`, T.set);
add(R`For any sets $A$ and $B$, $(A\cup B)\cap A'$ equals:`, R`$B-A$`, [R`$A-B$`, R`$A\cap B$`, R`$B'$`], R`Elements of $A\cup B$ that are not in $A$ are exactly those of $B$ not in $A$.`, T.set);
add(R`The set $\{x\in\mathbb{R}: x^2-5x+6=0\}$ is:`, R`$\{2, 3\}$`, [R`$\{-2,-3\}$`, R`$\{1, 6\}$`, R`$\{5, 6\}$`], R`$(x-2)(x-3) = 0$.`, T.set);
add(R`In a class, $40$ students offer English, $35$ offer Mathematics and every student offers at least one of them. If $20$ offer both, the number of students in the class is:`, R`$55$`, [R`$75$`, R`$95$`, R`$35$`], R`$40+35-20 = 55$.`, T.set);
add(R`The number of subsets of a set with $6$ elements that contain exactly $2$ elements is:`, R`$15$`, [R`$12$`, R`$30$`, R`$64$`], R`$\binom62 = 15$.`, T.set);
chk(15, 6 * 5 / 2);

// ---------------- relations and functions
add(R`A relation $R$ on $\{1,2,3\}$ is given by $R = \{(1,1),(2,2),(3,3),(1,2),(2,1)\}$. The relation $R$ is:`, R`An equivalence relation`, [R`Reflexive and symmetric, but not transitive`, R`Reflexive only`, R`Symmetric only`], R`It is reflexive because $(1,1),(2,2),(3,3)\in R$; symmetric because $(1,2)$ and $(2,1)$ both occur; and transitive because $(1,2),(2,1)$ require $(1,1)$ and $(2,2)$, which are present. So $R$ is an equivalence relation.`, T.rel);
add(R`The domain of the function $f(x) = \dfrac{\sqrt{4-x^2}}{x-1}$ is:`, R`$[-2, 1)\cup(1, 2]$`, [R`$[-2, 2]$`, R`$(-2, 2)$`, R`$(-\infty, 1)\cup(1,\infty)$`], R`The root needs $|x|\le2$ and the denominator excludes $x = 1$.`, T.rel);
add(R`If $f(x) = 3x-2$ and $g(x) = x^2+1$, then $(f\circ g)(x)$ is:`, R`$3x^2+1$`, [R`$9x^2-12x+5$`, R`$3x^2-2$`, R`$x^2+3x-1$`], R`$f(g(x)) = 3(x^2+1)-2 = 3x^2+1$.`, T.rel);
add(R`If $f(x) = 3x-2$ and $g(x) = x^2+1$, then $(g\circ f)(x)$ is:`, R`$9x^2-12x+5$`, [R`$3x^2+1$`, R`$3x^2-2$`, R`$9x^2+5$`], R`$g(f(x)) = (3x-2)^2+1 = 9x^2-12x+5$.`, T.rel);
add(R`The inverse of the relation $\{(1,2),(3,4),(5,6)\}$ is:`, R`$\{(2,1),(4,3),(6,5)\}$`, [R`$\{(1,2),(3,4),(5,6)\}$`, R`$\{(-1,-2),(-3,-4),(-5,-6)\}$`, R`$\{(2,1),(3,4),(6,5)\}$`], R`The inverse reverses each ordered pair.`, T.rel);
add(R`Which of the following functions is one-to-one on $\mathbb{R}$?`, R`$f(x) = x^3+x$`, [R`$f(x) = x^2$`, R`$f(x) = |x|$`, R`$f(x) = \sin x$`], R`$f'(x) = 3x^2+1>0$, so $f$ is strictly increasing and therefore one-to-one.`, T.rel);
add(R`The range of $f(x) = x^2-6x+11$ is:`, R`$[2,\infty)$`, [R`$[11,\infty)$`, R`$(-\infty, 2]$`, R`$[3,\infty)$`], R`$f(x) = (x-3)^2+2\ge2$.`, T.rel);
add(R`If $f(x) = \dfrac{x+1}{x-1}$, then $f(f(x))$ equals:`, R`$x$`, [R`$\dfrac{x+1}{x-1}$`, R`$\dfrac{1}{x}$`, R`$-x$`], R`$f(f(x)) = \dfrac{\frac{x+1}{x-1}+1}{\frac{x+1}{x-1}-1} = \dfrac{2x}{2} = x$, so $f$ is its own inverse.`, T.rel);

// ---------------- real numbers: surds, indices
add(R`Rationalising the denominator, $\dfrac{1}{\sqrt3-\sqrt2}$ equals:`, R`$\sqrt3+\sqrt2$`, [R`$\sqrt3-\sqrt2$`, R`$\dfrac{\sqrt3+\sqrt2}{5}$`, R`$\sqrt6$`], R`Multiply by $\dfrac{\sqrt3+\sqrt2}{\sqrt3+\sqrt2}$: the denominator becomes $3-2 = 1$.`, T.real);
add(R`The expression $\sqrt{7+4\sqrt3}$ simplifies to:`, R`$2+\sqrt3$`, [R`$\sqrt7+2\sqrt3$`, R`$4+\sqrt3$`, R`$1+2\sqrt3$`], R`$(2+\sqrt3)^2 = 4+4\sqrt3+3 = 7+4\sqrt3$.`, T.real);
add(R`Simplify $\dfrac{2^{n+2}-2^n}{2^{n+1}}$.`, R`$\dfrac32$`, [R`$2$`, R`$\dfrac12$`, R`$3$`], R`$\dfrac{2^n(4-1)}{2^n\cdot2} = \dfrac32$.`, T.real);
add(R`The value of $8^{-2/3}\times16^{3/4}$ is:`, R`$2$`, [R`$\dfrac12$`, R`$4$`, R`$8$`], R`$8^{-2/3} = \dfrac14$ and $16^{3/4} = 8$, so the product is $2$.`, T.real);
add(R`Which of the following numbers is irrational?`, R`$\sqrt{12}$`, [R`$\sqrt{16}$`, R`$0.\overline{3}$`, R`$\dfrac{22}{7}$`], R`$\sqrt{12} = 2\sqrt3$ is irrational; the others are rational.`, T.real);
add(R`The recurring decimal $0.\overline{27}$ expressed as a fraction in its lowest terms is:`, R`$\dfrac{3}{11}$`, [R`$\dfrac{27}{100}$`, R`$\dfrac{27}{99}$`, R`$\dfrac{1}{4}$`], R`$0.\overline{27} = \dfrac{27}{99} = \dfrac{3}{11}$.`, T.real);
add(R`If $x = \sqrt2+1$, then $x+\dfrac1x$ equals:`, R`$2\sqrt2$`, [R`$2$`, R`$\sqrt2$`, R`$2\sqrt2+2$`], R`$\dfrac1x = \sqrt2-1$, so the sum is $(\sqrt2+1)+(\sqrt2-1) = 2\sqrt2$.`, T.real);
add(R`The solution set of $|x-2|<|x+4|$ is:`, R`$x>-1$`, [R`$x<-1$`, R`$x>1$`, R`$-4<x<2$`], R`Squaring: $(x-2)^2<(x+4)^2$ gives $-4x+4<8x+16$, so $x>-1$.`, T.ineq);
add(R`The solution set of $x^2\le4$ is:`, R`$-2\le x\le2$`, [R`$x\le2$`, R`$x\le-2$ or $x\ge2$`, R`$0\le x\le2$`], R`$|x|\le2$.`, T.ineq);
add(R`The inequality $\dfrac{x+3}{x-1}\le0$ is satisfied for:`, R`$-3\le x<1$`, [R`$-3\le x\le1$`, R`$x\le-3$ or $x>1$`, R`$x<1$`], R`The quotient is non-positive between the zero of the numerator ($x = -3$, included) and the pole ($x = 1$, excluded).`, T.ineq);

// ---------------- quadratics
add(R`The roots of $x^2+kx+4=0$ are real and distinct when:`, R`$k>4$ or $k<-4$`, [R`$-4<k<4$`, R`$k>4$ only`, R`$k\ne\pm4$`], R`Discriminant $k^2-16>0$, so $|k|>4$.`, T.quad);
add(R`The equation $2x^2-3x+k=0$ has one root equal to twice the other when $k$ equals:`, R`$1$`, [R`$\dfrac{1}{2}$`, R`$\dfrac{9}{8}$`, R`$2$`], R`Let the roots be $\alpha$ and $2\alpha$. The sum $3\alpha = \dfrac32$ gives $\alpha = \dfrac12$. The product $2\alpha^2 = \dfrac12$ equals $\dfrac k2$, so $k = 1$.`, T.quad);
add(R`If $\alpha$ and $\beta$ are the roots of $2x^2-5x+1=0$, then $\dfrac1\alpha+\dfrac1\beta$ is:`, R`$5$`, [R`$\dfrac52$`, R`$\dfrac15$`, R`$2$`], R`$\dfrac{\alpha+\beta}{\alpha\beta} = \dfrac{5/2}{1/2} = 5$.`, T.quad);
add(R`If $\alpha$ and $\beta$ are the roots of $x^2-4x+2=0$, then $\dfrac\alpha\beta+\dfrac\beta\alpha$ is:`, R`$6$`, [R`$4$`, R`$8$`, R`$2$`], R`$\dfrac{\alpha^2+\beta^2}{\alpha\beta} = \dfrac{16-4}{2} = 6$.`, T.quad);
add(R`The quadratic equation whose roots are the squares of the roots of $x^2-3x+1=0$ is:`, R`$x^2-7x+1=0$`, [R`$x^2-9x+1=0$`, R`$x^2-3x+1=0$`, R`$x^2-7x-1=0$`], R`Sum of squares $= 9-2 = 7$; product $= (\alpha\beta)^2 = 1$.`, T.quad);
add(R`The minimum value of $y = 2x^2-8x+5$ is:`, R`$-3$`, [R`$5$`, R`$-8$`, R`$3$`], R`$y = 2(x-2)^2-3$, with minimum $-3$ at $x = 2$.`, T.quad);
add(R`The value of $m$ for which the line $y = 2x+m$ touches the parabola $y = x^2+1$ is:`, R`$0$`, [R`$1$`, R`$2$`, R`$-1$`], R`$x^2-2x+1-m = 0$ has equal roots when $4-4(1-m) = 0$, so $m = 0$.`, T.quad);
add(R`The roots of $x^2-2x+5=0$ are:`, R`$1\pm2i$`, [R`$1\pm i$`, R`$-1\pm2i$`, R`$2\pm i$`], R`$x = \dfrac{2\pm\sqrt{4-20}}{2} = 1\pm2i$.`, T.quad);
add(R`If one root of $x^2+px+12=0$ is $3$, then $p$ is:`, R`$-7$`, [R`$7$`, R`$-4$`, R`$4$`], R`$9+3p+12 = 0$ gives $p = -7$.`, T.quad);
add(R`The sum of the squares of two consecutive positive integers is $113$. The integers are:`, R`$7$ and $8$`, [R`$6$ and $7$`, R`$8$ and $9$`, R`$5$ and $6$`], R`$n^2+(n+1)^2 = 113$ gives $n^2+n-56 = 0$, so $n = 7$.`, T.quad);

// ---------------- polynomials
add(R`When $x^3-3x^2+kx-4$ is divided by $x-2$ the remainder is $2$. The value of $k$ is:`, R`$5$`, [R`$9$`, R`$7$`, R`$-3$`], R`By the remainder theorem $P(2) = 8-12+2k-4 = 2k-8 = 2$, so $k = 5$.`, T.poly);
add(R`The polynomial $x^3-6x^2+11x-6$ factorises completely as:`, R`$(x-1)(x-2)(x-3)$`, [R`$(x+1)(x+2)(x+3)$`, R`$(x-1)(x+2)(x-3)$`, R`$(x-1)^2(x-6)$`], R`$P(1) = 0$, and division gives $x^2-5x+6 = (x-2)(x-3)$.`, T.poly);
add(R`When $x^3+2x^2-x+3$ is divided by $x+1$, the quotient is:`, R`$x^2+x-2$`, [R`$x^2+x+2$`, R`$x^2-x-2$`, R`$x^2+3x+2$`], R`Synthetic division by $-1$: coefficients $1, 2, -1, 3$ give $1, 1, -2$ and remainder $5$.`, T.poly);
add(R`If $(x-2)$ and $(x+1)$ are both factors of $x^3+ax^2+bx-6$, then $a$ and $b$ are:`, R`$a = 2,\ b = -5$`, [R`$a = -2,\ b = -5$`, R`$a = 2,\ b = 5$`, R`$a = 1,\ b = -6$`], R`$P(2) = 8+4a+2b-6 = 0$ gives $2a+b = -1$, and $P(-1) = -1+a-b-6 = 0$ gives $a-b = 7$. Adding, $3a = 6$, so $a = 2$ and $b = -5$.`, T.poly);
add(R`The remainder when $x^{100}-1$ is divided by $x+1$ is:`, R`$0$`, [R`$2$`, R`$-2$`, R`$1$`], R`$P(-1) = (-1)^{100}-1 = 0$.`, T.poly);
add(R`If $f(x) = x^3-2x^2-5x+6$, then $f(x) = 0$ has roots:`, R`$1,\ 3,\ -2$`, [R`$1,\ -3,\ 2$`, R`$-1,\ -2,\ 3$`, R`$1,\ 2,\ -3$`], R`$f(1) = 0$; dividing gives $x^2-x-6 = (x-3)(x+2)$.`, T.poly);
add(R`The sum of the roots of $3x^3-2x^2+x-5=0$ is:`, R`$\dfrac{2}{3}$`, [R`$-\dfrac23$`, R`$\dfrac53$`, R`$\dfrac13$`], R`The sum of the roots is $-\dfrac{b}{a} = \dfrac23$.`, T.poly);

// ---------------- logarithms and exponentials
add(R`If $\log_a2 = 0.3$ and $\log_a3 = 0.48$, then $\log_a12$ equals:`, R`$1.08$`, [R`$0.78$`, R`$1.44$`, R`$0.96$`], R`$\log_a12 = 2\log_a2+\log_a3 = 0.6+0.48 = 1.08$.`, T.log);
add(R`The value of $\log_5125-\log_28$ is:`, R`$0$`, [R`$6$`, R`$3$`, R`$-3$`], R`$3-3 = 0$.`, T.log);
add(R`Solve $\log_x64 = 3$.`, R`$x = 4$`, [R`$x = 8$`, R`$x = 2$`, R`$x = 16$`], R`$x^3 = 64$.`, T.log);
add(R`The solution of $2\ln x = \ln(3x+4)$ is:`, R`$x = 4$`, [R`$x = -1$`, R`$x = 4$ or $x = -1$`, R`$x = 2$`], R`$x^2 = 3x+4$ gives $x = 4$ or $-1$; only $x = 4$ is admissible.`, T.log);
add(R`Solve $5^{x+1}=25^{x-1}$.`, R`$x = 3$`, [R`$x = 2$`, R`$x = 1$`, R`$x = 4$`], R`$5^{x+1} = 5^{2x-2}$ gives $x+1 = 2x-2$.`, T.log);
add(R`If $a = \log_{10}2$, then $\log_{10}5$ in terms of $a$ is:`, R`$1-a$`, [R`$a-1$`, R`$\dfrac{1}{a}$`, R`$2a$`], R`$\log5 = \log\dfrac{10}{2} = 1-a$.`, T.log);
add(R`The number of years for an investment growing by $10\%$ compound interest per year to double is the least integer $n$ satisfying:`, R`$1.1^n\ge2$, which gives $n = 8$`, [R`$1.1n\ge2$, which gives $n = 10$`, R`$1.1^n\ge2$, which gives $n = 7$`, R`$0.1^n\ge2$, which gives $n = 7$`], R`$n\ge\dfrac{\ln2}{\ln1.1} = 7.27$, so $n = 8$.`, T.log);
add(R`Solve $\log_2(x+3)+\log_2(x-3)=4$.`, R`$x = 5$`, [R`$x = -5$`, R`$x = \pm5$`, R`$x = 7$`], R`$x^2-9 = 16$ gives $x = \pm5$; only $x = 5$ satisfies the domain $x>3$.`, T.log);

module.exports = out;
