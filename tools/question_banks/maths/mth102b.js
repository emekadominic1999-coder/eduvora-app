// MTH 102 - batch B: straight lines, circles, conic sections and their tangents and normals.
const L = require('../sta/lib');
const { add, out } = L;
const R = String.raw;
const T = { line: 'Two-dimensional coordinate geometry and the straight line', circ: 'Coordinate geometry of the circle', con: 'Conic sections: parabola, ellipse and hyperbola', tan: 'Tangents and normals' };
const chk = (a, b) => { if (Math.abs(a - b) > 1e-9) throw new Error('check failed: ' + a + ' vs ' + b); };

// ---------------- the straight line
add(R`The gradient of the line through $(1,2)$ and $(5,10)$ is:`, R`$2$`, [R`$\dfrac12$`, R`$-2$`, R`$4$`], R`$m = \dfrac{10-2}{5-1} = 2$.`, T.line);
add(R`The equation of the line through $(-1,3)$ and $(2,9)$ is:`, R`$y = 2x+5$`, [R`$y = 2x+1$`, R`$y = 3x+6$`, R`$y = 2x-5$`], R`$m = \dfrac{9-3}{2+1} = 2$ and $y-3 = 2(x+1)$.`, T.line);
chk(Math.hypot(6, -8), 10);
add(R`The distance between the points $(-2,3)$ and $(4,-5)$ is:`, R`$10$`, [R`$2$`, R`$14$`, R`$\sqrt{28}$`], R`$\sqrt{(4+2)^2+(-5-3)^2} = \sqrt{36+64} = 10$.`, T.line);
add(R`The midpoint of the segment joining $(-3,7)$ and $(5,-1)$ is:`, R`$(1, 3)$`, [R`$(4, 4)$`, R`$(-1, 3)$`, R`$(1, 4)$`], R`$\left(\dfrac{-3+5}{2},\dfrac{7-1}{2}\right) = (1,3)$.`, T.line);
add(R`The line $3x-4y=12$ cuts the axes at:`, R`$(4,0)$ and $(0,-3)$`, [R`$(4,0)$ and $(0,3)$`, R`$(3,0)$ and $(0,-4)$`, R`$(12,0)$ and $(0,-12)$`], R`Setting $y = 0$ gives $x = 4$; setting $x = 0$ gives $y = -3$.`, T.line);
add(R`The distance between the parallel lines $3x+4y-5=0$ and $3x+4y+10=0$ is:`, R`$3$`, [R`$5$`, R`$\dfrac{15}{7}$`, R`$15$`], R`$d = \dfrac{|-5-10|}{\sqrt{3^2+4^2}} = \dfrac{15}{5} = 3$.`, T.line);
add(R`The lines $3x+2y=12$ and $x-y=1$ intersect at:`, R`$\left(\dfrac{14}{5},\dfrac95\right)$`, [R`$\left(\dfrac95,\dfrac{14}{5}\right)$`, R`$(3,2)$`, R`$(2,3)$`], R`Put $x = y+1$: $3y+3+2y = 12$, so $y = \dfrac95$ and $x = \dfrac{14}{5}$.`, T.line);
add(R`The line with $x$-intercept $3$ and $y$-intercept $-2$ has equation:`, R`$2x-3y=6$`, [R`$2x+3y=6$`, R`$3x-2y=6$`, R`$2x-3y=1$`], R`$\dfrac x3+\dfrac{y}{-2} = 1$, i.e. $2x-3y = 6$.`, T.line);
add(R`The points $(1,1)$, $(3,5)$ and $(k,9)$ are collinear when $k$ equals:`, R`$5$`, [R`$4$`, R`$6$`, R`$7$`], R`The gradient between the first two points is $2$, so $\dfrac{9-1}{k-1} = 2$ and $k = 5$.`, T.line);
add(R`The area of the triangle with vertices $(1,2)$, $(4,6)$ and $(7,2)$ is:`, R`$12$`, [R`$24$`, R`$10$`, R`$18$`], R`The base from $(1,2)$ to $(7,2)$ is $6$ and the height is $6-2 = 4$: area $= \dfrac12\cdot6\cdot4 = 12$.`, T.line);
add(R`The line $y = \sqrt3x$ makes an angle with the positive $x$-axis of:`, R`$60^\circ$`, [R`$30^\circ$`, R`$45^\circ$`, R`$120^\circ$`], R`$\tan\theta = \sqrt3$ gives $\theta = 60^\circ$.`, T.line);
add(R`The perpendicular distance from the point $(2,3)$ to the line $x+y=1$ is:`, R`$2\sqrt2$`, [R`$4$`, R`$\sqrt2$`, R`$\dfrac{4}{\sqrt2}\cdot2$`], R`$d = \dfrac{|2+3-1|}{\sqrt{1^2+1^2}} = \dfrac{4}{\sqrt2} = 2\sqrt2$.`, T.line);
add(R`The line through $(3,-2)$ perpendicular to $2x-5y=1$ has equation:`, R`$5x+2y=11$`, [R`$5x-2y=19$`, R`$2x-5y=16$`, R`$5x+2y=1$`], R`The given line has gradient $\dfrac25$, so the perpendicular has gradient $-\dfrac52$: $y+2 = -\dfrac52(x-3)$, i.e. $5x+2y = 11$.`, T.line);
add(R`The reflection of the point $(2,5)$ in the line $y = x$ is:`, R`$(5, 2)$`, [R`$(2,-5)$`, R`$(-2,5)$`, R`$(-5,-2)$`], R`Reflection in $y = x$ interchanges the coordinates.`, T.line);
add(R`The locus of a point equidistant from $(0,0)$ and $(4,0)$ is:`, R`$x = 2$`, [R`$y = 2$`, R`$x+y = 2$`, R`$y = 2x$`], R`It is the perpendicular bisector of the segment, passing through $(2,0)$ and vertical.`, T.line);
add(R`The point which divides the line joining $(0,0)$ and $(10,5)$ internally in the ratio $2:3$ is:`, R`$(4, 2)$`, [R`$(6, 3)$`, R`$(5, 2.5)$`, R`$(2, 1)$`], R`$\left(\dfrac{3(0)+2(10)}{5},\dfrac{3(0)+2(5)}{5}\right) = (4,2)$.`, T.line);

// ---------------- circles
add(R`The circle with centre $(-1,2)$ passing through the point $(2,6)$ has equation:`, R`$(x+1)^2+(y-2)^2=25$`, [R`$(x-1)^2+(y+2)^2=25$`, R`$(x+1)^2+(y-2)^2=5$`, R`$(x+1)^2+(y-2)^2=7$`], R`The radius is $\sqrt{3^2+4^2} = 5$.`, T.circ);
add(R`The circle $x^2+y^2-6x-8y+9=0$ has radius:`, R`$4$`, [R`$5$`, R`$3$`, R`$16$`], R`$(x-3)^2+(y-4)^2 = 9+16-9 = 16$.`, T.circ);
add(R`The point $(4,1)$ with respect to the circle $x^2+y^2=16$ is:`, R`Outside the circle`, [R`Inside the circle`, R`On the circle`, R`At the centre`], R`$4^2+1^2 = 17>16$.`, T.circ);
add(R`The circle with centre $(3,-4)$ that touches the $x$-axis has equation:`, R`$(x-3)^2+(y+4)^2=16$`, [R`$(x-3)^2+(y+4)^2=9$`, R`$(x-3)^2+(y+4)^2=25$`, R`$(x+3)^2+(y-4)^2=16$`], R`The radius equals the distance from the centre to the $x$-axis, which is $4$.`, T.circ);
add(R`The length of the tangent from the point $(6,8)$ to the circle $x^2+y^2=25$ is:`, R`$5\sqrt3$`, [R`$5$`, R`$10$`, R`$\sqrt{75}\cdot2$`], R`$L = \sqrt{36+64-25} = \sqrt{75} = 5\sqrt3$.`, T.tan);
add(R`The tangent to the circle $x^2+y^2=10$ at the point $(1,3)$ has equation:`, R`$x+3y=10$`, [R`$3x+y=10$`, R`$x-3y=10$`, R`$x+3y=1$`], R`The tangent at $(x_1,y_1)$ is $xx_1+yy_1 = r^2$.`, T.tan);
add(R`The circle through $(1,0)$, $(0,1)$ and $(-1,0)$ has equation:`, R`$x^2+y^2=1$`, [R`$x^2+y^2=2$`, R`$x^2+y^2-x=0$`, R`$(x-1)^2+y^2=1$`], R`All three points are at distance $1$ from the origin.`, T.circ);
add(R`The circles $x^2+y^2=4$ and $(x-3)^2+y^2=1$:`, R`touch externally`, [R`touch internally`, R`intersect at two points`, R`do not meet and lie apart`], R`The distance between the centres is $3 = 2+1$, the sum of the radii.`, T.circ);
add(R`The line $y = x+1$ meets the circle $x^2+y^2=13$ at the points:`, R`$(2,3)$ and $(-3,-2)$`, [R`$(3,2)$ and $(-2,-3)$`, R`$(2,3)$ and $(3,-2)$`, R`$(1,2)$ and $(-2,-1)$`], R`$x^2+(x+1)^2 = 13$ gives $x^2+x-6 = 0$, so $x = 2$ or $-3$.`, T.circ);
add(R`The length of the chord cut from the circle $x^2+y^2=5$ by the line $x = 1$ is:`, R`$4$`, [R`$2$`, R`$\sqrt5$`, R`$2\sqrt5$`], R`At $x = 1$, $y^2 = 4$, so $y = \pm2$ and the chord has length $4$.`, T.circ);
add(R`The circle with diameter endpoints $(-2,1)$ and $(4,5)$ has equation:`, R`$(x-1)^2+(y-3)^2=13$`, [R`$(x-1)^2+(y-3)^2=52$`, R`$(x+1)^2+(y+3)^2=13$`, R`$(x-1)^2+(y-3)^2=26$`], R`The centre is $(1,3)$ and the diameter is $\sqrt{36+16} = \sqrt{52}$, so $r^2 = 13$.`, T.circ);
add(R`The circle $x^2+y^2-2x-4y-4=0$ has centre and radius:`, R`centre $(1,2)$, radius $3$`, [R`centre $(-1,-2)$, radius $3$`, R`centre $(1,2)$, radius $9$`, R`centre $(2,4)$, radius $3$`], R`$(x-1)^2+(y-2)^2 = 4+1+4 = 9$.`, T.circ);
add(R`The normal to the circle $x^2+y^2-4x+6y=0$ at the origin has equation:`, R`$3x+2y=0$`, [R`$2x-3y=0$`, R`$3x-2y=0$`, R`$2x+3y=0$`], R`The centre is $(2,-3)$; the normal at the origin is the line through the origin and the centre, $y = -\dfrac32x$.`, T.tan);
add(R`The power of the point $(5,0)$ with respect to the circle $x^2+y^2=9$ is:`, R`$16$`, [R`$25$`, R`$9$`, R`$4$`], R`Power $= x_1^2+y_1^2-r^2 = 25-9 = 16$, which is the square of the tangent length.`, T.circ);

// ---------------- parabolas, ellipses and hyperbolas
add(R`The focus and directrix of the parabola $y^2=-8x$ are respectively:`, R`$(-2,0)$ and $x = 2$`, [R`$(2,0)$ and $x = -2$`, R`$(0,-2)$ and $y = 2$`, R`$(-4,0)$ and $x = 4$`], R`$y^2 = -4ax$ with $a = 2$ opens to the left, with focus $(-a,0)$ and directrix $x = a$.`, T.con);
add(R`The vertex of the parabola $(x-1)^2=4(y+2)$ is:`, R`$(1,-2)$`, [R`$(-1,2)$`, R`$(1,2)$`, R`$(-1,-2)$`], R`The equation has the form $(x-h)^2 = 4a(y-k)$ with vertex $(h,k) = (1,-2)$.`, T.con);
add(R`The length of the latus rectum of the parabola $y^2=16x$ is:`, R`$16$`, [R`$4$`, R`$8$`, R`$32$`], R`$4a = 16$, so the latus rectum has length $16$.`, T.con);
add(R`On the parabola $y^2=4x$, the points whose distance from the focus is $5$ are:`, R`$(4,\pm4)$`, [R`$(5,\pm\sqrt{20})$`, R`$(4,\pm2)$`, R`$(6,\pm4)$`], R`The focal distance of $(x,y)$ is $x+a = x+1 = 5$, so $x = 4$ and $y = \pm4$.`, T.con);
add(R`The foci and eccentricity of the ellipse $\dfrac{x^2}{16}+\dfrac{y^2}{7}=1$ are:`, R`$(\pm3,0)$ and $e = \dfrac34$`, [R`$(\pm4,0)$ and $e = \dfrac34$`, R`$(\pm3,0)$ and $e = \dfrac43$`, R`$(0,\pm3)$ and $e = \dfrac34$`], R`$c^2 = 16-7 = 9$, so $c = 3$ and $e = \dfrac ca = \dfrac34$.`, T.con);
add(R`The ellipse with foci $(\pm3,0)$ and major axis of length $10$ has equation:`, R`$\dfrac{x^2}{25}+\dfrac{y^2}{16}=1$`, [R`$\dfrac{x^2}{25}+\dfrac{y^2}{9}=1$`, R`$\dfrac{x^2}{16}+\dfrac{y^2}{25}=1$`, R`$\dfrac{x^2}{100}+\dfrac{y^2}{91}=1$`], R`$a = 5$ and $c = 3$, so $b^2 = a^2-c^2 = 16$.`, T.con);
add(R`The length of the latus rectum of the ellipse $\dfrac{x^2}{25}+\dfrac{y^2}{9}=1$ is:`, R`$\dfrac{18}{5}$`, [R`$\dfrac{9}{5}$`, R`$\dfrac{50}{3}$`, R`$6$`], R`The latus rectum is $\dfrac{2b^2}{a} = \dfrac{2\cdot9}{5} = \dfrac{18}{5}$.`, T.con);
add(R`The foci of the ellipse $\dfrac{x^2}{9}+\dfrac{y^2}{25}=1$ are:`, R`$(0,\pm4)$`, [R`$(\pm4,0)$`, R`$(0,\pm5)$`, R`$(\pm3,0)$`], R`The major axis is along the $y$-axis with $c^2 = 25-9 = 16$.`, T.con);
add(R`The vertices and foci of the hyperbola $\dfrac{x^2}{9}-\dfrac{y^2}{16}=1$ are:`, R`vertices $(\pm3,0)$ and foci $(\pm5,0)$`, [R`vertices $(\pm4,0)$ and foci $(\pm5,0)$`, R`vertices $(\pm3,0)$ and foci $(\pm\sqrt7,0)$`, R`vertices $(0,\pm3)$ and foci $(0,\pm5)$`], R`$a = 3$ and $c^2 = a^2+b^2 = 25$, so $c = 5$.`, T.con);
add(R`The hyperbola $9x^2-16y^2=144$ in standard form is:`, R`$\dfrac{x^2}{16}-\dfrac{y^2}{9}=1$`, [R`$\dfrac{x^2}{9}-\dfrac{y^2}{16}=1$`, R`$\dfrac{y^2}{9}-\dfrac{x^2}{16}=1$`, R`$\dfrac{x^2}{144}-\dfrac{y^2}{144}=1$`], R`Divide by $144$.`, T.con);
add(R`The eccentricity of the rectangular hyperbola $xy = c^2$ is:`, R`$\sqrt2$`, [R`$2$`, R`$1$`, R`$\dfrac{1}{\sqrt2}$`], R`Its asymptotes are perpendicular, giving $a = b$ and $e = \sqrt{1+1} = \sqrt2$.`, T.con);
add(R`The curve $x^2+4y^2-4x+8y-8=0$ is:`, R`An ellipse with centre $(2,-1)$`, [R`A hyperbola with centre $(2,-1)$`, R`A circle with centre $(2,-1)$`, R`An ellipse with centre $(-2,1)$`], R`Completing squares: $(x-2)^2+4(y+1)^2 = 16$, i.e. $\dfrac{(x-2)^2}{16}+\dfrac{(y+1)^2}{4} = 1$.`, T.con);
add(R`The curve $4x^2-y^2=4$ is:`, R`A hyperbola`, [R`An ellipse`, R`A parabola`, R`A circle`], R`Dividing by $4$ gives $x^2-\dfrac{y^2}{4} = 1$, a hyperbola.`, T.con);
add(R`The curve $y^2-8y-4x+16=0$ is a parabola with vertex:`, R`$(0,4)$`, [R`$(4,0)$`, R`$(0,-4)$`, R`$(-4,0)$`], R`$(y-4)^2 = 4x$, so the vertex is $(0,4)$.`, T.con);

// ---------------- tangents and normals to conics
add(R`The tangent to the parabola $y^2=8x$ at the point $(2,4)$ has equation:`, R`$y = x+2$`, [R`$y = x-2$`, R`$y = 2x$`, R`$y = -x+6$`], R`$2yy' = 8$ gives gradient $1$ at $(2,4)$: $y-4 = x-2$.`, T.tan);
add(R`The tangent to the ellipse $\dfrac{x^2}{9}+\dfrac{y^2}{4}=1$ at the point $(0,2)$ is:`, R`$y = 2$`, [R`$x = 0$`, R`$y = -2$`, R`$x = 3$`], R`The tangent at $(x_1,y_1)$ is $\dfrac{xx_1}{9}+\dfrac{yy_1}{4} = 1$, i.e. $\dfrac{2y}{4} = 1$.`, T.tan);
add(R`The normal to the parabola $y^2=4x$ at the point $(1,2)$ has equation:`, R`$x+y=3$`, [R`$x-y=-1$`, R`$y = x+1$`, R`$x+y=1$`], R`The tangent gradient is $\dfrac{2}{y} = 1$, so the normal has gradient $-1$: $y-2 = -(x-1)$.`, T.tan);
add(R`The line $y = x+c$ is tangent to the ellipse $\dfrac{x^2}{4}+y^2=1$ when $c$ equals:`, R`$\pm\sqrt5$`, [R`$\pm1$`, R`$\pm\sqrt3$`, R`$\pm5$`], R`The tangency condition is $c^2 = a^2m^2+b^2 = 4+1 = 5$.`, T.tan);
add(R`The line $y = mx+\dfrac1m$ is tangent to the parabola:`, R`$y^2 = 4x$`, [R`$y^2 = x$`, R`$x^2 = 4y$`, R`$y^2 = 2x$`], R`For $y^2 = 4ax$ the tangent is $y = mx+\dfrac am$; here $a = 1$.`, T.tan);
add(R`The gradient of the tangent to the circle $x^2+y^2=25$ at the point $(-3,4)$ is:`, R`$\dfrac34$`, [R`$-\dfrac34$`, R`$\dfrac43$`, R`$-\dfrac43$`], R`$y' = -\dfrac xy = \dfrac34$.`, T.tan);

module.exports = out;
