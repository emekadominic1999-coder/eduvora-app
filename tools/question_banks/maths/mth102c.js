// MTH 102 - batch C: vectors in two and three dimensions, lines, differentiation and integration of vectors, motion in a plane.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { vec: 'Scalar and vector products of two vectors', rep: 'Geometric representation of vectors, components and direction cosines', lin: 'Addition of vectors, scalar multiplication and linear independence', dif: 'Differentiation and integration of vectors with respect to a scalar', kin: 'Components of velocity and acceleration in a plane' };
const chk = (a, b) => { if (Math.abs(a - b) > 1e-9) throw new Error('check failed: ' + a + ' vs ' + b); };
const dot = (a, b) => a.reduce((s, x, i) => s + x * b[i], 0);
const cross = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const norm = (a) => Math.sqrt(dot(a, a));

// ---------------- products and geometry of vectors
chk(norm([3, -4, 12]), 13);
add(R`The magnitude of the vector $3\mathbf{i}-4\mathbf{j}+12\mathbf{k}$ is:`, R`$13$`, [R`$11$`, R`$\sqrt{119}$`, R`$19$`], R`$\sqrt{9+16+144} = 13$.`, T.rep);
chk(dot([2, 3, -1], [4, -2, 5]), -3);
add(R`If $\mathbf{a} = (2,3,-1)$ and $\mathbf{b} = (4,-2,5)$, then $\mathbf{a}\cdot\mathbf{b}$ is:`, R`$-3$`, [R`$3$`, R`$-19$`, R`$13$`], R`$8-6-5 = -3$.`, T.vec);
add(R`The angle between the vectors $(1,1,0)$ and $(0,1,1)$ is:`, R`$60^\circ$`, [R`$30^\circ$`, R`$45^\circ$`, R`$90^\circ$`], R`$\cos\theta = \dfrac{1}{\sqrt2\cdot\sqrt2} = \dfrac12$.`, T.vec);
add(R`The vector projection of $\mathbf{a} = (2,3)$ on $\mathbf{b} = (1,1)$ is:`, R`$\left(\dfrac52,\dfrac52\right)$`, [R`$(5,5)$`, R`$\left(\dfrac52,0\right)$`, R`$(2,3)$`], R`$\dfrac{\mathbf{a}\cdot\mathbf{b}}{|\mathbf{b}|^2}\mathbf{b} = \dfrac52(1,1)$.`, T.vec);
add(R`The cross product $\mathbf{i}\times\mathbf{j}$ equals:`, R`$\mathbf{k}$`, [R`$-\mathbf{k}$`, R`$0$`, R`$1$`], R`$\mathbf{i},\mathbf{j},\mathbf{k}$ form a right-handed set, so $\mathbf{i}\times\mathbf{j} = \mathbf{k}$.`, T.vec);
{ const c = cross([2, 1, 3], [1, -1, 2]); chk(c[0], 5); chk(c[1], -1); chk(c[2], -3); }
add(R`If $\mathbf{a} = (2,1,3)$ and $\mathbf{b} = (1,-1,2)$, then $\mathbf{a}\times\mathbf{b}$ is:`, R`$(5,-1,-3)$`, [R`$(-5,1,3)$`, R`$(5,1,-3)$`, R`$(2,-1,6)$`], R`$(1\cdot2-3\cdot(-1),\ 3\cdot1-2\cdot2,\ 2\cdot(-1)-1\cdot1) = (5,-1,-3)$.`, T.vec);
chk(norm(cross([1, 2, 0], [0, 1, 3])), Math.sqrt(46));
add(R`The area of the parallelogram with adjacent sides $(1,2,0)$ and $(0,1,3)$ is:`, R`$\sqrt{46}$`, [R`$\sqrt{14}$`, R`$6$`, R`$\sqrt{10}$`], R`$\mathbf{a}\times\mathbf{b} = (6,-3,1)$, with magnitude $\sqrt{36+9+1} = \sqrt{46}$.`, T.vec);
{ const c = cross([1, 2, 3], [2, 1, 0]); chk(c[0], -3); chk(c[1], 6); chk(c[2], -3); }
add(R`A unit vector perpendicular to both $(1,2,3)$ and $(2,1,0)$ is:`, R`$\dfrac{1}{\sqrt6}(-1,2,-1)$`, [R`$\dfrac{1}{\sqrt6}(1,2,1)$`, R`$\dfrac{1}{\sqrt{14}}(1,2,3)$`, R`$\dfrac{1}{3}(-1,2,-1)$`], R`The cross product is $(-3,6,-3) = 3(-1,2,-1)$, with $|(-1,2,-1)| = \sqrt6$.`, T.vec);
add(R`The vectors $(\lambda,2,-1)$ and $(3,-1,4)$ are perpendicular when $\lambda$ equals:`, R`$2$`, [R`$-2$`, R`$\dfrac{2}{3}$`, R`$6$`], R`$3\lambda-2-4 = 0$ gives $\lambda = 2$.`, T.vec);
{ const ab = [2, 3, 4], ac = [4, 6, 8]; chk(ac[0] / ab[0], 2); chk(ac[1] / ab[1], 2); chk(ac[2] / ab[2], 2); }
add(R`The points $A(1,2,3)$, $B(3,5,7)$ and $C(5,8,11)$ are:`, R`Collinear`, [R`The vertices of a right-angled triangle`, R`The vertices of an equilateral triangle`, R`Not collinear`], R`$\overrightarrow{AB} = (2,3,4)$ and $\overrightarrow{AC} = (4,6,8) = 2\overrightarrow{AB}$.`, T.lin);
add(R`The unit vector in the direction of $3\mathbf{i}-4\mathbf{j}$ is:`, R`$\dfrac35\mathbf{i}-\dfrac45\mathbf{j}$`, [R`$3\mathbf{i}-4\mathbf{j}$`, R`$\dfrac13\mathbf{i}-\dfrac14\mathbf{j}$`, R`$\dfrac45\mathbf{i}-\dfrac35\mathbf{j}$`], R`The magnitude is $5$.`, T.rep);
add(R`The point $P$ divides the line joining $A(1,0,2)$ and $B(4,3,5)$ internally in the ratio $2:1$. The coordinates of $P$ are:`, R`$(3,2,4)$`, [R`$(2,1,3)$`, R`$(4,3,5)$`, R`$\left(\dfrac52,\dfrac32,\dfrac72\right)$`], R`$P = \dfrac{1\cdot A+2\cdot B}{3} = \dfrac{(1+8,\ 0+6,\ 2+10)}{3} = (3,2,4)$.`, T.rep);
{ const bc = cross([0, 1, 4], [5, 6, 0]); chk(dot([1, 2, 3], bc), 1); }
add(R`The scalar triple product $\mathbf{a}\cdot(\mathbf{b}\times\mathbf{c})$ for $\mathbf{a} = (1,2,3)$, $\mathbf{b} = (0,1,4)$ and $\mathbf{c} = (5,6,0)$ is:`, R`$1$`, [R`$-1$`, R`$24$`, R`$0$`], R`$\mathbf{b}\times\mathbf{c} = (-24,20,-5)$ and $\mathbf{a}\cdot(-24,20,-5) = -24+40-15 = 1$.`, T.vec);
add(R`A line passes through $(1,2,3)$ in the direction $(2,-1,4)$. The point on the line corresponding to $t = 2$ in $\mathbf{r} = (1,2,3)+t(2,-1,4)$ is:`, R`$(5,0,11)$`, [R`$(3,1,7)$`, R`$(4,0,11)$`, R`$(5,4,11)$`], R`$(1+4,\ 2-2,\ 3+8) = (5,0,11)$.`, T.rep);
add(R`The direction cosines of the vector $(1,1,1)$ are:`, R`$\dfrac{1}{\sqrt3},\ \dfrac{1}{\sqrt3},\ \dfrac{1}{\sqrt3}$`, [R`$\dfrac13,\ \dfrac13,\ \dfrac13$`, R`$1,\ 1,\ 1$`, R`$\dfrac{1}{\sqrt2},\ \dfrac{1}{\sqrt2},\ 0$`], R`The modulus is $\sqrt3$.`, T.rep);
add(R`The component of $\mathbf{a} = (4,3)$ along the direction of $\mathbf{b} = (3,4)$ is:`, R`$\dfrac{24}{5}$`, [R`$\dfrac{25}{5}$`, R`$24$`, R`$\dfrac{12}{5}$`], R`Component $= \dfrac{\mathbf{a}\cdot\mathbf{b}}{|\mathbf{b}|} = \dfrac{12+12}{5} = \dfrac{24}{5}$.`, T.vec);
add(R`If $|\mathbf{a}| = 3$, $|\mathbf{b}| = 4$ and $\mathbf{a}\cdot\mathbf{b} = 6$, then $|\mathbf{a}+\mathbf{b}|$ is:`, R`$\sqrt{37}$`, [R`$7$`, R`$5$`, R`$\sqrt{13}$`], R`$|\mathbf{a}+\mathbf{b}|^2 = 9+16+2(6) = 37$.`, T.vec);
add(R`If $\mathbf{a}$ and $\mathbf{b}$ are perpendicular with $|\mathbf{a}| = 2$ and $|\mathbf{b}| = 3$, then $|\mathbf{a}-\mathbf{b}|$ is:`, R`$\sqrt{13}$`, [R`$1$`, R`$5$`, R`$\sqrt{5}$`], R`$|\mathbf{a}-\mathbf{b}|^2 = 4+9-0 = 13$.`, T.vec);
add(R`The vectors $(1,2,3)$, $(0,1,2)$ and $(0,0,1)$ are:`, R`Linearly independent`, [R`Linearly dependent`, R`Mutually perpendicular`, R`Coplanar`], R`The determinant of the matrix with these rows is $1\ne0$.`, T.lin);
add(R`The vectors $(1,2,3)$ and $(2,4,6)$ are:`, R`Linearly dependent`, [R`Linearly independent`, R`Perpendicular`, R`Of equal length`], R`The second is twice the first.`, T.lin);
chk(dot([1, -1, 2], [2, 1, -1]) / (norm([1, -1, 2]) * norm([2, 1, -1])), -1 / 6);
add(R`The cosine of the angle between $\mathbf{a} = (1,-1,2)$ and $\mathbf{b} = (2,1,-1)$ is:`, R`$-\dfrac16$`, [R`$\dfrac16$`, R`$-\dfrac{1}{\sqrt6}$`, R`$-1$`], R`$\mathbf{a}\cdot\mathbf{b} = 2-1-2 = -1$ and $|\mathbf{a}| = |\mathbf{b}| = \sqrt6$.`, T.vec);
add(R`A force of magnitude $10$ makes an angle of $30^\circ$ with the positive $x$-axis. Its components are:`, R`$(5\sqrt3,\ 5)$`, [R`$(5,\ 5\sqrt3)$`, R`$(10,\ 5)$`, R`$(5\sqrt3,\ 10)$`], R`$(10\cos30^\circ,\ 10\sin30^\circ) = (5\sqrt3,5)$.`, T.rep);
add(R`The vector $\overrightarrow{AB}$ from $A(1,2)$ to $B(4,6)$ and its length are:`, R`$(3,4)$ and $5$`, [R`$(5,8)$ and $\sqrt{89}$`, R`$(-3,-4)$ and $5$`, R`$(3,4)$ and $7$`], R`$\overrightarrow{AB} = B-A = (3,4)$ with length $\sqrt{9+16} = 5$.`, T.rep);
add(R`$ABCD$ is a parallelogram with $A(0,0)$, $B(3,1)$ and $C(4,4)$. The coordinates of $D$ are:`, R`$(1,3)$`, [R`$(7,5)$`, R`$(3,4)$`, R`$(4,0)$`], R`In a parallelogram $\overrightarrow{AD} = \overrightarrow{BC} = (1,3)$.`, T.lin);
add(R`The vectors $(2,2,1)$ and $(1,-2,2)$ are:`, R`Perpendicular`, [R`Parallel`, R`At $60^\circ$ to each other`, R`Of equal length but not perpendicular`], R`The dot product is $2-4+2 = 0$.`, T.vec);
add(R`The value of $k$ for which $(1,k,-2)$ is perpendicular to $(2,-3,1)$ is:`, R`$0$`, [R`$1$`, R`$-\dfrac{4}{3}$`, R`$\dfrac{4}{3}$`], R`$2-3k-2 = 0$ gives $k = 0$.`, T.vec);
add(R`The area of the triangle with vertices $O(0,0,0)$, $B(2,0,0)$ and $C(0,3,0)$ is:`, R`$3$`, [R`$6$`, R`$5$`, R`$\dfrac32$`], R`Area $= \dfrac12|\overrightarrow{OB}\times\overrightarrow{OC}| = \dfrac12|(0,0,6)| = 3$.`, T.vec);
add(R`For any vector $\mathbf{a}$, the cross product $\mathbf{a}\times\mathbf{a}$ is:`, R`The zero vector`, [R`$|\mathbf{a}|^2$`, R`$\mathbf{a}$`, R`$2\mathbf{a}$`], R`The angle between $\mathbf{a}$ and itself is $0$, so $|\mathbf{a}\times\mathbf{a}| = |\mathbf{a}|^2\sin0 = 0$.`, T.vec);
add(R`For any vectors $\mathbf{a}$ and $\mathbf{b}$, the scalar $(\mathbf{a}\times\mathbf{b})\cdot\mathbf{a}$ equals:`, R`$0$`, [R`$|\mathbf{a}||\mathbf{b}|$`, R`$\mathbf{a}\cdot\mathbf{b}$`, R`$1$`], R`$\mathbf{a}\times\mathbf{b}$ is perpendicular to $\mathbf{a}$.`, T.vec);
add(R`The volume of the tetrahedron with edges $\mathbf{i}$, $\mathbf{j}$ and $\mathbf{k}$ from the origin is:`, R`$\dfrac16$`, [R`$1$`, R`$\dfrac13$`, R`$\dfrac12$`], R`Volume $= \dfrac16|\mathbf{a}\cdot(\mathbf{b}\times\mathbf{c})| = \dfrac16$.`, T.vec);
add(R`The sine of the angle between $(1,0,0)$ and $(1,1,0)$ is:`, R`$\dfrac{1}{\sqrt2}$`, [R`$1$`, R`$\dfrac12$`, R`$\sqrt2$`], R`$\sin\theta = \dfrac{|\mathbf{a}\times\mathbf{b}|}{|\mathbf{a}||\mathbf{b}|} = \dfrac{1}{1\cdot\sqrt2}$.`, T.vec);
add(R`The line through the points $(1,2)$ and $(3,6)$ has vector equation:`, R`$\mathbf{r} = (1,2)+t(2,4)$`, [R`$\mathbf{r} = (1,2)+t(3,6)$`, R`$\mathbf{r} = (2,4)+t(1,2)$`, R`$\mathbf{r} = (1,2)+t(4,8)\cdot(-1)$`], R`The direction vector is $(3-1,6-2) = (2,4)$.`, T.rep);
add(R`The line $x = 1+2t$, $y = 3-t$ has gradient:`, R`$-\dfrac12$`, [R`$-2$`, R`$\dfrac12$`, R`$2$`], R`$\dfrac{dy}{dx} = \dfrac{-1}{2}$.`, T.rep);

// ---------------- motion in a plane
add(R`A particle has position $\mathbf{r}(t) = (t^3, 2t^2)$. Its velocity and speed at $t = 1$ are:`, R`$(3,4)$ and $5$`, [R`$(3,2)$ and $\sqrt{13}$`, R`$(1,2)$ and $\sqrt5$`, R`$(6,4)$ and $\sqrt{52}$`], R`$\mathbf{v} = (3t^2, 4t) = (3,4)$ with speed $\sqrt{9+16} = 5$.`, T.kin);
add(R`A particle moves with $\mathbf{r}(t) = (2\cos t, 2\sin t)$. Its speed is:`, R`constant and equal to $2$`, [R`constant and equal to $4$`, R`equal to $2t$`, R`equal to $\sqrt2$`], R`$\mathbf{v} = (-2\sin t, 2\cos t)$ and $|\mathbf{v}| = 2$.`, T.kin);
add(R`A particle moves with $\mathbf{r}(t) = (2\cos t, 2\sin t)$. The magnitude of its acceleration is:`, R`$2$`, [R`$4$`, R`$0$`, R`$1$`], R`$\mathbf{a} = (-2\cos t, -2\sin t) = -\mathbf{r}$, with magnitude $2$.`, T.kin);
add(R`A particle moves with $\mathbf{r}(t) = (t,\ t^2-2t)$. At the instant its velocity is parallel to the $x$-axis, its position is:`, R`$(1,-1)$`, [R`$(1,1)$`, R`$(0,0)$`, R`$(2,0)$`], R`$\mathbf{v} = (1, 2t-2)$ is horizontal when $t = 1$, giving $\mathbf{r}(1) = (1,-1)$.`, T.kin);
add(R`A projectile has position $\mathbf{r}(t) = (3t,\ 4t-5t^2)$. Its velocity at $t = 0.4$ is:`, R`$(3, 0)$`, [R`$(3, 4)$`, R`$(3, -4)$`, R`$(0, 0)$`], R`$\mathbf{v} = (3, 4-10t) = (3, 0)$ at $t = 0.4$, the top of the path.`, T.kin);
add(R`A particle has constant acceleration $(0,-10)$ and initial velocity $(6,8)$, starting at the origin. Its position at $t = 1$ is:`, R`$(6, 3)$`, [R`$(6, -2)$`, R`$(6, 8)$`, R`$(6, 13)$`], R`$\mathbf{r} = \mathbf{u}t+\dfrac12\mathbf{a}t^2 = (6, 8-5) = (6,3)$.`, T.kin);
add(R`The value of $\displaystyle\int_0^{\pi/2}(\sin t\,\mathbf{i}+\cos t\,\mathbf{j})\,dt$ is:`, R`$\mathbf{i}+\mathbf{j}$`, [R`$\mathbf{i}-\mathbf{j}$`, R`$-\mathbf{i}+\mathbf{j}$`, R`$0$`], R`$[-\cos t]_0^{\pi/2} = 1$ and $[\sin t]_0^{\pi/2} = 1$.`, T.dif);
add(R`If $\mathbf{r}(t)$ is a position vector, then $\dfrac{d}{dt}(\mathbf{r}\cdot\mathbf{r})$ equals:`, R`$2\mathbf{r}\cdot\mathbf{v}$`, [R`$\mathbf{r}\cdot\mathbf{v}$`, R`$2|\mathbf{r}|$`, R`$\mathbf{v}\cdot\mathbf{v}$`], R`By the product rule $\dfrac{d}{dt}(\mathbf{r}\cdot\mathbf{r}) = 2\mathbf{r}\cdot\dfrac{d\mathbf{r}}{dt}$.`, T.dif);
add(R`A particle has velocity $\mathbf{v} = (2t, 3t^2)$ and starts at $(1,0)$. Its position at $t = 2$ is:`, R`$(5, 8)$`, [R`$(4, 8)$`, R`$(5, 12)$`, R`$(4, 12)$`], R`$\mathbf{r} = (t^2+1,\ t^3)$, which is $(5,8)$ at $t = 2$.`, T.kin);
add(R`A particle has position $\mathbf{r}(t) = (e^t\cos t,\ e^t\sin t)$. Its speed at time $t$ is:`, R`$\sqrt2\,e^t$`, [R`$e^t$`, R`$2e^t$`, R`$e^{2t}$`], R`$\mathbf{v} = e^t(\cos t-\sin t,\ \sin t+\cos t)$ and $|\mathbf{v}| = e^t\sqrt{2}$.`, T.kin);
add(R`A particle has position $\mathbf{r}(t) = (t^2, t^3)$. Its velocity is zero when $t$ equals:`, R`$0$`, [R`$1$`, R`$\dfrac23$`, R`$\dfrac32$`], R`$\mathbf{v} = (2t, 3t^2) = \mathbf{0}$ only when $t = 0$.`, T.kin);
add(R`For uniform circular motion $\mathbf{r} = (\cos t,\sin t)$, the angle between the velocity and the acceleration is:`, R`$90^\circ$`, [R`$0^\circ$`, R`$180^\circ$`, R`$45^\circ$`], R`$\mathbf{v}\cdot\mathbf{a} = (-\sin t)(-\cos t)+(\cos t)(-\sin t) = 0$.`, T.kin);
add(R`A particle has position $\mathbf{r}(t) = (t^2, 3t)$. Its average velocity over the interval $t = 0$ to $t = 2$ is:`, R`$(2,3)$`, [R`$(4,3)$`, R`$(4,6)$`, R`$(2,6)$`], R`$\dfrac{\mathbf{r}(2)-\mathbf{r}(0)}{2} = \dfrac{(4,6)}{2} = (2,3)$.`, T.kin);
add(R`A particle moves with $\mathbf{r}(t) = (t, t^2)$. The gradient $\dfrac{dy}{dx}$ of its path at $t = 2$ is:`, R`$4$`, [R`$2$`, R`$1$`, R`$\dfrac14$`], R`$\dfrac{dy}{dx} = \dfrac{\dot y}{\dot x} = \dfrac{2t}{1} = 4$.`, T.kin);
add(R`The unit tangent vector to the curve $\mathbf{r}(t) = (\cos t, \sin t, t)$ at $t = 0$ is:`, R`$\dfrac{1}{\sqrt2}(0,1,1)$`, [R`$(0,1,1)$`, R`$(1,0,0)$`, R`$\dfrac{1}{\sqrt2}(1,0,1)$`], R`$\mathbf{r}' = (-\sin t, \cos t, 1) = (0,1,1)$ at $t = 0$, with magnitude $\sqrt2$.`, T.dif);
add(R`A particle has acceleration $\mathbf{a} = (6t, 2)$ and is at rest at $t = 0$. Its velocity at $t = 1$ is:`, R`$(3, 2)$`, [R`$(6, 2)$`, R`$(3, 1)$`, R`$(1, 2)$`], R`$\mathbf{v} = \int(6t, 2)\,dt = (3t^2, 2t)$ with $\mathbf{v}(0) = \mathbf{0}$, so $\mathbf{v}(1) = (3,2)$.`, T.kin);
add(R`If $\mathbf{a}(t)$ and $\mathbf{b}(t)$ are differentiable vector functions, then $\dfrac{d}{dt}(\mathbf{a}\times\mathbf{b})$ equals:`, R`$\mathbf{a}'\times\mathbf{b}+\mathbf{a}\times\mathbf{b}'$`, [R`$\mathbf{a}'\times\mathbf{b}'$`, R`$\mathbf{a}'\times\mathbf{b}-\mathbf{a}\times\mathbf{b}'$`, R`$\mathbf{a}\times\mathbf{b}'$`], R`The product rule holds for the cross product, with the order of the factors kept.`, T.dif);
add(R`A particle has position $\mathbf{r}(t) = (t, t^2, t^3)$. Its acceleration at $t = 1$ is:`, R`$(0,2,6)$`, [R`$(1,2,3)$`, R`$(0,2,3)$`, R`$(1,2,6)$`], R`$\mathbf{r}'' = (0, 2, 6t) = (0,2,6)$ at $t = 1$.`, T.kin);
add(R`A particle moves with constant velocity $(3,4)$. The distance it travels in $5$ seconds is:`, R`$25$`, [R`$35$`, R`$7$`, R`$5$`], R`The speed is $5$, so the distance is $5\times5 = 25$.`, T.kin);

module.exports = out;
