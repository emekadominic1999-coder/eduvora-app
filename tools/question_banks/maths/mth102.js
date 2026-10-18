// MTH 102 (Vectors, Coordinate Geometry and Elementary Dynamics) - hand-set questions.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { line: 'Two-dimensional coordinate geometry and the straight line', circ: 'Coordinate geometry of the circle', con: 'Conic sections: parabola, ellipse and hyperbola', vec: 'Scalar and vector products of two vectors', rep: 'Geometric representation of vectors, components and direction cosines', lin: 'Addition of vectors, scalar multiplication and linear independence', dif: 'Differentiation and integration of vectors with respect to a scalar', kin: 'Components of velocity and acceleration in a plane', tan: 'Tangents and normals' };
const dot = (a, b) => a.reduce((s, x, i) => s + x * b[i], 0);
const cross = (a, b) => [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
const chk = (a, b) => { if (Math.abs(a - b) > 1e-9) throw new Error('check failed ' + a + ' vs ' + b); };

// ---------------- the straight line
add(R`The equation of the line through $(2,-1)$ with gradient $3$ is:`, R`$y = 3x-7$`, [R`$y = 3x+7$`, R`$y = 3x-5$`, R`$y = -3x+5$`], R`$y+1 = 3(x-2)$, so $y = 3x-7$.`, T.line);
add(R`The perpendicular distance from the point $(1,2)$ to the line $3x+4y-10=0$ is:`, R`$\dfrac{1}{5}$`, [R`$1$`, R`$\dfrac{21}{5}$`, R`$5$`], R`$d = \dfrac{|3(1)+4(2)-10|}{\sqrt{3^2+4^2}} = \dfrac{1}{5}$.`, T.line);
chk(Math.abs(3 + 8 - 10) / 5, 0.2);
add(R`The acute angle between the lines $y = x$ and $y = 3x$ is:`, R`$\tan^{-1}\dfrac{1}{2}$`, [R`$45^\circ$`, R`$\tan^{-1}2$`, R`$\tan^{-1}\dfrac{1}{4}$`], R`$\tan\theta = \left|\dfrac{m_2-m_1}{1+m_1m_2}\right| = \dfrac{3-1}{1+3} = \dfrac12$.`, T.line);
add(R`The lines $2x+y=7$ and $x-y=2$ intersect at the point:`, R`$(3, 1)$`, [R`$(2, 3)$`, R`$(1, 5)$`, R`$(3, -1)$`], R`Adding the equations gives $3x = 9$, so $x = 3$ and $y = 1$.`, T.line);
add(R`The point which divides the line joining $A(1,2)$ and $B(7,8)$ internally in the ratio $1:2$ is:`, R`$(3, 4)$`, [R`$(5, 6)$`, R`$(4, 5)$`, R`$(2, 3)$`], R`$\left(\dfrac{2(1)+1(7)}{3},\dfrac{2(2)+1(8)}{3}\right) = (3, 4)$.`, T.line);
add(R`The equation of the line through $(1,2)$ parallel to $2x-3y+5=0$ is:`, R`$2x-3y+4=0$`, [R`$2x-3y-4=0$`, R`$3x+2y-7=0$`, R`$2x+3y-8=0$`], R`A parallel line has the same left-hand side: $2(1)-3(2)+k = 0$ gives $k = 4$.`, T.line);
add(R`The perpendicular bisector of the segment joining $A(1,1)$ and $B(5,3)$ has equation:`, R`$2x+y=8$`, [R`$x-2y=-1$`, R`$2x+y=4$`, R`$x+2y=8$`], R`The midpoint is $(3,2)$ and $AB$ has gradient $\dfrac12$, so the bisector has gradient $-2$: $y-2 = -2(x-3)$, i.e. $2x+y = 8$.`, T.line);
add(R`The area of the triangle with vertices $(0,0)$, $(4,0)$ and $(2,5)$ is:`, R`$10$`, [R`$20$`, R`$5$`, R`$14$`], R`Area $= \dfrac12\times\text{base}\times\text{height} = \dfrac12(4)(5) = 10$.`, T.line);
add(R`The lines $kx+2y=3$ and $4x-y=5$ are perpendicular when $k$ equals:`, R`$\dfrac{1}{2}$`, [R`$-\dfrac{1}{2}$`, R`$2$`, R`$-8$`], R`Gradients: $-\dfrac k2$ and $4$. Perpendicular means product $-1$: $-2k = -1$, so $k = \dfrac12$.`, T.line);

// ---------------- circles
add(R`The equation of the circle with centre $(2,-3)$ and radius $4$ is:`, R`$x^2+y^2-4x+6y-3=0$`, [R`$x^2+y^2+4x-6y-3=0$`, R`$x^2+y^2-4x+6y+13=0$`, R`$x^2+y^2-4x+6y-16=0$`], R`$(x-2)^2+(y+3)^2 = 16$ expands to $x^2+y^2-4x+6y-3 = 0$.`, T.circ);
add(R`The circle $x^2+y^2+6x-8y=0$ has centre and radius:`, R`centre $(-3,4)$, radius $5$`, [R`centre $(3,-4)$, radius $5$`, R`centre $(-3,4)$, radius $25$`, R`centre $(3,-4)$, radius $\sqrt{5}$`], R`Complete the square: $(x+3)^2+(y-4)^2 = 25$.`, T.circ);
add(R`The length of the tangent from the point $(5,0)$ to the circle $x^2+y^2=9$ is:`, R`$4$`, [R`$5$`, R`$\sqrt{34}$`, R`$3$`], R`$L = \sqrt{x_1^2+y_1^2-r^2} = \sqrt{25-9} = 4$.`, T.circ);
add(R`The equation of the tangent to the circle $x^2+y^2=25$ at the point $(3,4)$ is:`, R`$3x+4y=25$`, [R`$4x+3y=25$`, R`$3x-4y=25$`, R`$3x+4y=5$`], R`The tangent at $(x_1,y_1)$ is $xx_1+yy_1 = r^2$, i.e. $3x+4y = 25$.`, T.tan);
add(R`The circle passing through $(0,0)$, $(4,0)$ and $(0,2)$ has equation:`, R`$x^2+y^2-4x-2y=0$`, [R`$x^2+y^2+4x+2y=0$`, R`$x^2+y^2-4x-2y+4=0$`, R`$x^2+y^2-2x-4y=0$`], R`The circle through the origin has no constant term: $x^2+y^2+Dx+Ey = 0$. Using $(4,0)$: $D = -4$; using $(0,2)$: $E = -2$.`, T.circ);
add(R`The line $y = x+k$ is tangent to the circle $x^2+y^2=2$ when $k$ equals:`, R`$\pm2$`, [R`$\pm1$`, R`$\pm\sqrt2$`, R`$\pm4$`], R`The distance from the origin to the line $x-y+k = 0$ must equal the radius: $\dfrac{|k|}{\sqrt2} = \sqrt2$, so $k = \pm2$.`, T.tan);
add(R`The locus of a point $P$ that moves so that its distance from $C(-5,3)$ is always $2$ is:`, R`$x^2+y^2+10x-6y+30=0$`, [R`$x^2+y^2-10x+6y+30=0$`, R`$x^2+y^2+10x-6y+34=0$`, R`$x^2+y^2+10x-6y-30=0$`], R`$(x+5)^2+(y-3)^2 = 4$ expands to $x^2+y^2+10x-6y+30 = 0$.`, T.circ);

// ---------------- conics
add(R`The focus and directrix of the parabola $y^2 = 12x$ are respectively:`, R`$(3,0)$ and $x = -3$`, [R`$(-3,0)$ and $x = 3$`, R`$(6,0)$ and $x = -6$`, R`$(0,3)$ and $y = -3$`], R`$y^2 = 4ax$ with $a = 3$ has focus $(a,0)$ and directrix $x = -a$.`, T.con);
add(R`The parabola with focus $(2,0)$ and directrix $x = -2$ has equation:`, R`$y^2 = 8x$`, [R`$y^2 = 4x$`, R`$x^2 = 8y$`, R`$y^2 = 2x$`], R`Here $a = 2$ so $y^2 = 4ax = 8x$.`, T.con);
add(R`The length of the latus rectum of the parabola $x^2 = 8y$ is:`, R`$8$`, [R`$2$`, R`$4$`, R`$16$`], R`$x^2 = 4ay$ with $a = 2$; the latus rectum is $4a = 8$.`, T.con);
add(R`The eccentricity of the ellipse $\dfrac{x^2}{25}+\dfrac{y^2}{9}=1$ is:`, R`$\dfrac{4}{5}$`, [R`$\dfrac{3}{5}$`, R`$\dfrac{16}{25}$`, R`$\dfrac{5}{4}$`], R`$e = \sqrt{1-\dfrac{b^2}{a^2}} = \sqrt{1-\dfrac{9}{25}} = \dfrac45$.`, T.con);
add(R`The foci of the ellipse $\dfrac{x^2}{25}+\dfrac{y^2}{9}=1$ are:`, R`$(\pm4, 0)$`, [R`$(\pm5, 0)$`, R`$(0, \pm4)$`, R`$(\pm3, 0)$`], R`$c^2 = a^2-b^2 = 16$, so the foci are $(\pm c, 0) = (\pm4, 0)$.`, T.con);
add(R`The length of the major axis of the ellipse $9x^2+4y^2=36$ is:`, R`$6$`, [R`$4$`, R`$3$`, R`$12$`], R`In standard form $\dfrac{x^2}{4}+\dfrac{y^2}{9} = 1$, the larger semi-axis is $3$ (along the $y$-axis), so the major axis is $6$.`, T.con);
add(R`The asymptotes of the hyperbola $\dfrac{x^2}{16}-\dfrac{y^2}{9}=1$ are:`, R`$y = \pm\dfrac{3}{4}x$`, [R`$y = \pm\dfrac{4}{3}x$`, R`$y = \pm\dfrac{9}{16}x$`, R`$y = \pm\dfrac{3}{5}x$`], R`The asymptotes are $y = \pm\dfrac bax = \pm\dfrac34x$.`, T.con);
add(R`The eccentricity of the hyperbola $\dfrac{x^2}{16}-\dfrac{y^2}{9}=1$ is:`, R`$\dfrac{5}{4}$`, [R`$\dfrac{4}{5}$`, R`$\dfrac{3}{4}$`, R`$\dfrac{25}{16}$`], R`$e = \sqrt{1+\dfrac{b^2}{a^2}} = \sqrt{1+\dfrac{9}{16}} = \dfrac54$.`, T.con);
add(R`The gradient of the tangent to the parabola $y^2=8x$ at the point $(2,4)$ is:`, R`$1$`, [R`$2$`, R`$\dfrac{1}{2}$`, R`$4$`], R`$2yy' = 8$, so $y' = \dfrac{4}{y} = 1$ at $y = 4$.`, T.tan);

// ---------------- vectors
const a1 = [2, -1, 3], b1 = [1, 4, -2];
chk(dot(a1, b1), -8); chk(cross(a1, b1)[0], -10); chk(cross(a1, b1)[1], 7); chk(cross(a1, b1)[2], 9);
add(R`If $\mathbf{a} = 2\mathbf{i}-\mathbf{j}+3\mathbf{k}$ and $\mathbf{b} = \mathbf{i}+4\mathbf{j}-2\mathbf{k}$, then $\mathbf{a}\cdot\mathbf{b}$ is:`, R`$-8$`, [R`$8$`, R`$-4$`, R`$0$`], R`$2(1)+(-1)(4)+3(-2) = 2-4-6 = -8$.`, T.vec);
add(R`If $\mathbf{a} = 2\mathbf{i}-\mathbf{j}+3\mathbf{k}$ and $\mathbf{b} = \mathbf{i}+4\mathbf{j}-2\mathbf{k}$, then $\mathbf{a}\times\mathbf{b}$ is:`, R`$-10\mathbf{i}+7\mathbf{j}+9\mathbf{k}$`, [R`$10\mathbf{i}-7\mathbf{j}-9\mathbf{k}$`, R`$-10\mathbf{i}-7\mathbf{j}+9\mathbf{k}$`, R`$2\mathbf{i}-4\mathbf{j}-6\mathbf{k}$`], R`Expanding the determinant: $\mathbf{i}[(-1)(-2)-3\cdot4] - \mathbf{j}[2(-2)-3\cdot1]+\mathbf{k}[2\cdot4-(-1)(1)] = -10\mathbf{i}+7\mathbf{j}+9\mathbf{k}$.`, T.vec);
add(R`The angle between the vectors $\mathbf{a} = (1,2,2)$ and $\mathbf{b} = (2,-2,1)$ is:`, R`$90^\circ$`, [R`$0^\circ$`, R`$60^\circ$`, R`$45^\circ$`], R`$\mathbf{a}\cdot\mathbf{b} = 2-4+2 = 0$, so the vectors are perpendicular.`, T.vec);
chk(dot([1, 2, 2], [2, -2, 1]), 0);
add(R`The scalar projection of $\mathbf{a} = (3,4)$ onto $\mathbf{b} = (1,0)$ is:`, R`$3$`, [R`$4$`, R`$5$`, R`$\dfrac{3}{5}$`], R`Projection $= \dfrac{\mathbf{a}\cdot\mathbf{b}}{|\mathbf{b}|} = \dfrac{3}{1} = 3$.`, T.vec);
add(R`The unit vector in the direction of $2\mathbf{i}-3\mathbf{j}+6\mathbf{k}$ is:`, R`$\dfrac{1}{7}(2\mathbf{i}-3\mathbf{j}+6\mathbf{k})$`, [R`$\dfrac{1}{5}(2\mathbf{i}-3\mathbf{j}+6\mathbf{k})$`, R`$\dfrac{1}{11}(2\mathbf{i}-3\mathbf{j}+6\mathbf{k})$`, R`$\dfrac{1}{49}(2\mathbf{i}-3\mathbf{j}+6\mathbf{k})$`], R`$|\mathbf{v}| = \sqrt{4+9+36} = 7$.`, T.rep);
add(R`The direction cosines of the vector $\mathbf{i}+2\mathbf{j}+2\mathbf{k}$ are:`, R`$\dfrac13,\dfrac23,\dfrac23$`, [R`$\dfrac13,\dfrac13,\dfrac13$`, R`$1,2,2$`, R`$\dfrac15,\dfrac25,\dfrac25$`], R`The modulus is $3$, so the direction cosines are $\dfrac13,\dfrac23,\dfrac23$.`, T.rep);
const AB = [-1, 2, 0], AC = [-1, 0, 3];
chk(Math.hypot(...cross(AB, AC)) / 2, 3.5);
add(R`The area of the triangle with vertices $A(1,0,0)$, $B(0,2,0)$ and $C(0,0,3)$ is:`, R`$\dfrac{7}{2}$`, [R`$\dfrac{\sqrt{14}}{2}$`, R`$3$`, R`$7$`], R`$\overrightarrow{AB}\times\overrightarrow{AC} = (-1,2,0)\times(-1,0,3) = (6,3,2)$ with modulus $7$, so the area is $\dfrac72$.`, T.vec);
add(R`The vectors $\mathbf{a} = (1,k,3)$ and $\mathbf{b} = (2,6,6)$ are parallel when $k$ equals:`, R`$3$`, [R`$2$`, R`$6$`, R`$\dfrac{1}{3}$`], R`Parallel vectors have proportional components: $\dfrac{1}{2} = \dfrac{k}{6} = \dfrac{3}{6}$, so $k = 3$.`, T.lin);
add(R`The volume of the parallelepiped whose edges are $\mathbf{i}$, $2\mathbf{j}$ and $3\mathbf{k}$ is:`, R`$6$`, [R`$11$`, R`$5$`, R`$\sqrt{14}$`], R`Volume $= |\mathbf{a}\cdot(\mathbf{b}\times\mathbf{c})| = 1\cdot2\cdot3 = 6$.`, T.vec);
add(R`The vectors $(1,0,1)$, $(0,1,1)$ and $(1,1,2)$ are:`, R`Linearly dependent`, [R`Linearly independent`, R`Mutually perpendicular`, R`All of unit length`], R`The third vector is the sum of the first two, so they are linearly dependent.`, T.lin);
add(R`The position vector of the midpoint of the line joining $(2,3,4)$ and $(6,7,8)$ is:`, R`$4\mathbf{i}+5\mathbf{j}+6\mathbf{k}$`, [R`$8\mathbf{i}+10\mathbf{j}+12\mathbf{k}$`, R`$2\mathbf{i}+2\mathbf{j}+2\mathbf{k}$`, R`$4\mathbf{i}+4\mathbf{j}+4\mathbf{k}$`], R`The midpoint is the average of the two position vectors.`, T.rep);
add(R`If $|\mathbf{a}| = 3$, $|\mathbf{b}| = 4$ and the angle between them is $60^\circ$, then $\mathbf{a}\cdot\mathbf{b}$ is:`, R`$6$`, [R`$12$`, R`$6\sqrt3$`, R`$3$`], R`$\mathbf{a}\cdot\mathbf{b} = |\mathbf{a}||\mathbf{b}|\cos60^\circ = 12\cdot\dfrac12 = 6$.`, T.vec);
add(R`If $|\mathbf{a}| = 3$, $|\mathbf{b}| = 4$ and the angle between them is $30^\circ$, then $|\mathbf{a}\times\mathbf{b}|$ is:`, R`$6$`, [R`$12$`, R`$6\sqrt3$`, R`$3$`], R`$|\mathbf{a}\times\mathbf{b}| = |\mathbf{a}||\mathbf{b}|\sin30^\circ = 12\cdot\dfrac12 = 6$.`, T.vec);

// ---------------- differentiation and integration of vectors, motion in a plane
add(R`A particle has position vector $\mathbf{r}(t) = t^2\mathbf{i}+3t\mathbf{j}$. Its velocity at $t = 2$ is:`, R`$4\mathbf{i}+3\mathbf{j}$`, [R`$2\mathbf{i}+3\mathbf{j}$`, R`$4\mathbf{i}+6\mathbf{j}$`, R`$4\mathbf{i}$`], R`$\mathbf{v} = \dfrac{d\mathbf{r}}{dt} = 2t\mathbf{i}+3\mathbf{j}$, which is $4\mathbf{i}+3\mathbf{j}$ at $t = 2$.`, T.kin);
add(R`A particle has position vector $\mathbf{r}(t) = t^2\mathbf{i}+3t\mathbf{j}$. Its speed at $t = 2$ is:`, R`$5$`, [R`$7$`, R`$\sqrt7$`, R`$25$`], R`$|\mathbf{v}| = \sqrt{4^2+3^2} = 5$.`, T.kin);
add(R`A particle has position vector $\mathbf{r}(t) = t^2\mathbf{i}+3t\mathbf{j}$. Its acceleration is:`, R`$2\mathbf{i}$`, [R`$2t\mathbf{i}+3\mathbf{j}$`, R`$3\mathbf{j}$`, R`$2\mathbf{i}+3\mathbf{j}$`], R`$\mathbf{a} = \dfrac{d\mathbf{v}}{dt} = 2\mathbf{i}$.`, T.kin);
add(R`A particle moves with $\mathbf{r}(t) = \cos t\,\mathbf{i}+\sin t\,\mathbf{j}$. Its speed is:`, R`constant and equal to $1$`, [R`equal to $t$`, R`equal to $\sin t+\cos t$`, R`zero`], R`$\mathbf{v} = -\sin t\,\mathbf{i}+\cos t\,\mathbf{j}$ and $|\mathbf{v}| = \sqrt{\sin^2t+\cos^2t} = 1$.`, T.kin);
add(R`If $\mathbf{r}(t) = t\mathbf{i}+t^2\mathbf{j}$, the velocity vector at $t = 1$ makes with the $x$-axis an angle whose tangent is:`, R`$2$`, [R`$1$`, R`$\dfrac{1}{2}$`, R`$0$`], R`$\mathbf{v} = \mathbf{i}+2t\mathbf{j} = \mathbf{i}+2\mathbf{j}$ at $t = 1$, so the tangent of the angle is $\dfrac{2}{1} = 2$.`, T.kin);
add(R`The value of $\displaystyle\int_0^1(2t\mathbf{i}+3t^2\mathbf{j})\,dt$ is:`, R`$\mathbf{i}+\mathbf{j}$`, [R`$2\mathbf{i}+3\mathbf{j}$`, R`$\mathbf{i}+3\mathbf{j}$`, R`$\dfrac12\mathbf{i}+\dfrac13\mathbf{j}$`], R`Integrate each component: $[t^2]_0^1\mathbf{i}+[t^3]_0^1\mathbf{j} = \mathbf{i}+\mathbf{j}$.`, T.dif);
add(R`If $\mathbf{r}(t) = e^t\mathbf{i}+t^2\mathbf{j}$, then $\dfrac{d\mathbf{r}}{dt}$ is:`, R`$e^t\mathbf{i}+2t\mathbf{j}$`, [R`$e^t\mathbf{i}+t\mathbf{j}$`, R`$te^{t-1}\mathbf{i}+2t\mathbf{j}$`, R`$e^t\mathbf{i}+\dfrac{t^3}{3}\mathbf{j}$`], R`Differentiate each component with respect to $t$.`, T.dif);
add(R`If $\mathbf{a}(t)$ and $\mathbf{b}(t)$ are differentiable vector functions, then $\dfrac{d}{dt}(\mathbf{a}\cdot\mathbf{b})$ equals:`, R`$\mathbf{a}'\cdot\mathbf{b}+\mathbf{a}\cdot\mathbf{b}'$`, [R`$\mathbf{a}'\cdot\mathbf{b}'$`, R`$\mathbf{a}'\times\mathbf{b}+\mathbf{a}\times\mathbf{b}'$`, R`$\mathbf{a}\cdot\mathbf{b}'$`], R`The product rule holds for the dot product.`, T.dif);
add(R`If $\mathbf{a}(t)$ has constant magnitude, then $\mathbf{a}\cdot\dfrac{d\mathbf{a}}{dt}$ equals:`, R`$0$`, [R`$|\mathbf{a}|$`, R`$1$`, R`$|\mathbf{a}|^2$`], R`Differentiating $\mathbf{a}\cdot\mathbf{a} = $ constant gives $2\mathbf{a}\cdot\mathbf{a}' = 0$.`, T.dif);

module.exports = out;
