// Normalises the maths typesetting of CBT questions so they render the way a
// printed paper does: full-size fractions (\dfrac), upright function names
// (\cos, \ln ...), proper \sqrt / exponents, no slash-fractions, no stray
// "2.0" / "+ 0" artefacts, balanced $ delimiters.

const FUNCS = 'arcsin|arccos|arctan|sinh|cosh|tanh|sin|cos|tan|cot|sec|csc|log|ln|lim|exp|det';
const FUNC_WORD = new RegExp('(?<![\\\\A-Za-z])(' + FUNCS + ')(?![A-Za-z])', 'g');
const FUNC_DIGIT = new RegExp('(\\\\(?:' + FUNCS + '))(?=[0-9])', 'g');

function protect(x) {
  const keep = [];
  const y = x.replace(/\\(?:text|mathbf|operatorname|mathrm|vec)\{[^{}]*\}/g, (m) => {
    keep.push(m);
    return '\u0001' + (keep.length - 1) + '\u0002';
  });
  return [y, (z) => z.replace(/\u0001(\d+)\u0002/g, (_, i) => keep[+i])];
}

function slashFractions(x0) {
  // slashes inside exponents (e^{5i\pi/4}, |b|^{1/n}) stay as written
  const mask = [];
  let y = x0.replace(/\^\{[^{}]*\}|\^\([^()]*\)/g, (m) => {
    mask.push(m);
    return '\u0003' + (mask.length - 1) + '\u0004';
  });
  // f(x_1)/f'(x_1), g(x)/h(x)
  y = y.replace(/(?<![\w\\])([a-zA-Z]'?\([^()]*\))\s*\/\s*([a-zA-Z]'?\([^()]*\))/g, '\\dfrac{$1}{$2}');
  // \partial f/\partial x, d\mathbf{a}/dt, \det(B_1)/\det(A)
  y = y.replace(/\\partial\s*([A-Za-z](?:_\w)?)\s*\/\s*\\partial\s*([A-Za-z])/g, '\\dfrac{\\partial $1}{\\partial $2}');
  y = y.replace(/(\\det\([^()]+\))\s*\/\s*(\\det\([^()]+\))/g, '\\dfrac{$1}{$2}');
  y = y.replace(/(?<![\w\\])d(\\mathbf\{[a-z]\}|\\mathbf[a-z]|\\vec\{?[a-z]\}?)\s*\/\s*d([a-z])(?![\w])/g, '\\dfrac{d$1}{d$2}');
  // D_1/D, x_1/x_2, 12/(-5), n/(n^2+1), b^2/a^2, 90/-15, -4/k
  y = y.replace(/(?<![\w}\\.^_])([A-Za-z]_\{?\w\}?)\s*\/\s*([A-Za-z](?:_\{?\w\}?)?|-?\d+)(?![\w])/g, '\\dfrac{$1}{$2}');
  y = y.replace(/(?<![\w}\\.^_])([A-Za-z]|-?\d+)\s*\/\s*\(([^()]+)\)/g, '\\dfrac{$1}{$2}');
  y = y.replace(/(?<![\w}\\.^_])([A-Za-z]\^\{?\d\}?)\s*\/\s*([A-Za-z]\^\{?\d\}?)/g, '\\dfrac{$1}{$2}');
  y = y.replace(/(?<![\w}\\.^_])(-?\d+)\s*\/\s*(-\d+)(?![\w.])/g, '\\dfrac{$1}{$2}');
  y = y.replace(/(?<![\w}\\.^_])(-?\d+)\s*\/\s*([a-zA-Z])(?![\w])/g, '\\dfrac{$1}{$2}');
  y = slashFractions1(y);
  return y.replace(/\u0003(\d+)\u0004/g, (_, i) => mask[+i]);
}

function slashFractions1(x) {
  let y = x;
  // dy/dx
  y = y.replace(/(?<![\w\\])d([a-zA-Z])\s*\/\s*d([a-zA-Z])(?![\w])/g, '\\dfrac{d$1}{d$2}');
  // (a+b)/(c+d)
  y = y.replace(/(?<![A-Za-z\\'])\(([^()]+)\)\s*\/\s*\(([^()]+)\)/g, '\\dfrac{$1}{$2}');
  // (a+b)/c  (not a function call such as f(x_1)/f'(x_1))
  y = y.replace(/(?<![A-Za-z\\'])\(([^()]+)\)\s*\/\s*(\d+|[a-zA-Z](?![a-zA-Z'(]))/g, '\\dfrac{$1}{$2}');
  // \sqrt{..}/n  and  n/\sqrt{..}
  y = y.replace(/(\\sqrt\{[^{}]+\}|\\sqrt\d)\s*\/\s*(\d+|[a-zA-Z](?![a-zA-Z])|\\sqrt\{[^{}]+\})/g, '\\dfrac{$1}{$2}');
  y = y.replace(/(?<![\w}\\.])(\d+)\s*\/\s*(\\sqrt\{[^{}]+\})/g, '\\dfrac{$1}{$2}');
  // \pi/6, 3\pi/4, 5\pi/6
  y = y.replace(/(?<![\w}\\.])(\d*\\pi)\s*\/\s*(\d+)/g, '\\dfrac{$1}{$2}');
  // -3/7, 6/5, 59/3
  y = y.replace(/(?<![\w}\\.^_])(\d+(?:\.\d+)?)\s*\/\s*(\d+(?:\.\d+)?)(?![\w.])/g, '\\dfrac{$1}{$2}');
  // a/b between single letters / letter-number
  y = y.replace(/(?<![\w}\\.^_])([a-zA-Z])\s*\/\s*(\d+|[a-zA-Z])(?![\w])/g, '\\dfrac{$1}{$2}');
  return y;
}

function fixSpan(x) {
  x = x.replace(/(?<![\w\\])d(\\mathbf\{[a-zA-Z]\}|\\vec\{?[a-zA-Z]\}?)\s*\/\s*d([a-zA-Z])(?![\w])/g, '\\dfrac{d$1}{d$2}');
  x = x.replace(/(?<![\w}\\.^_])(\d+)\s*\/\s*(\\sqrt\d)(?![\w])/g, '\\dfrac{$1}{$2}');
  const [y0, restore] = protect(x);
  let y = y0;
  // shorthand fractions and size
  y = y.replace(/\\(?:tfrac|frac|cfrac)(?=[^a-zA-Z])/g, '\\dfrac');
  y = y.replace(/\\dfrac(?!\s*\{)\s*([0-9a-zA-Z])\s*([0-9a-zA-Z])/g, '\\dfrac{$1}{$2}');
  // numerator over (x-1)^2 typed as \frac{a}{x-1}^2
  y = y.replace(/\\dfrac\{([^{}]+)\}\{(\([^{}]+\)|[^{}]+)\}\^(\{[^{}]+\}|\w)/g, (m, a, b, p) => {
    const pw = p.startsWith('{') ? p : '{' + p + '}';
    const base = /^\(.*\)$/.test(b) ? b : '(' + b + ')';
    return '\\dfrac{' + a + '}{' + base + '^' + pw + '}';
  });
  // sympy-style logs
  y = y.replace(/\\log\{\\left\(\\left\|\{([^{}]+)\}\\right\|\s*\\right\)\}/g, '\\ln\\left|$1\\right|');
  y = y.replace(/\\log\{\\left\(\s*([^{}()]+?)\s*\\right\)\}/g, '\\ln\\left($1\\right)');
  // bare function names -> upright operators
  y = y.replace(FUNC_WORD, '\\$1');
  y = y.replace(FUNC_DIGIT, '$1 ');
  // decimal artefacts and trailing "+ 0"
  y = y.replace(/(\d)\.0(?!\d)/g, '$1');
  y = y.replace(/\s*\+\s*0\s*$/, '');
  // slash fractions
  y = slashFractions(y);
  return restore(y);
}

function repairDollars(s) {
  // "A^{-1} = $\begin{pmatrix} .. \end{pmatrix}$$"  ->  one balanced span
  let t = s.replace(/=\s*\$(\\begin\{[pb]matrix\})/g, '= $1');
  const n = (t.match(/\$/g) || []).length;
  if (n % 2 === 1) t = t.replace(/(\\end\{[pb]matrix\})\$\$/g, '$1$');
  return t;
}

function fixMath(s) {
  if (typeof s !== 'string' || s.indexOf('$') < 0) return s;
  const t = repairDollars(s);
  return t.replace(/\$([^$]+)\$/g, (m, x) => '$' + fixSpan(x) + '$');
}

// Plain text (outside $) used by the statistics / biomathematics banks:
// wrap "35/72" and "2^3" style tokens so they typeset as real fractions /
// exponents. Deliberately conservative: digit/digit fractions and
// letter-or-digit ^ digit only.
function fixPlain(s) {
  if (typeof s !== 'string') return s;
  // R / pseudo-code (statistical computing, sum(x^2) ...) stays as written
  if (/[*]|<-|\b(sum|mean|var|sd|cumsum|seq|rep|c)\(/.test(s)) return s;
  const parts = s.split(/(\$[^$]+\$)/g);
  return parts
    .map((p, i) => {
      if (i % 2 === 1) return p; // already maths
      let q = p;
      const inner = (e) =>
        e.replace(/−/g, '-').replace(/(?<![\w.])(-?\d+)\s*\/\s*(\d+)(?![\w.]|\/)/g, '\\dfrac{$1}{$2}');
      // 16^(3/4), x^(1/2), 8^(−2/3)
      q = q.replace(/(?<![\w.$])([A-Za-z]|\d+)\^\(([^()]+)\)/g, (m, a, e) => '$' + a + '^{' + inner(e) + '}$');
      q = q.replace(/(?<![\w.$\/])(-?)(\d+)\/(\d+)(?![\w\/]|\.\d)/g, (m, s, a, b) => '$' + s + '\\dfrac{' + a + '}{' + b + '}$');
      q = q.replace(/(?<![\w.$])([A-Za-z]|\d+|\))\^(\{[^{}]+\}|-?\d+)/g, (m, a, e) => {
        const ex = e.startsWith('{') ? e : '{' + e + '}';
        return '$' + a + '^' + ex + '$';
      });
      return q;
    })
    .join('');
}

// Options of the MTH banks that are not inside $...$ at all.
function fixProseOption(o) {
  if (typeof o !== 'string' || o.indexOf('$') >= 0) return o;
  let t = o.trim();
  let m;
  if ((m = /^(-?)(\d+)\/(\d+)$/.exec(t))) return '$' + m[1] + '\\dfrac{' + m[2] + '}{' + m[3] + '}$';
  if (t === 'ln x') return '$\\ln x$';
  if (t === 'x') return '$x$';
  if (t === 'e') return '$e$';
  if (t === 'R') return '$\\mathbb{R}$';
  if ((m = /^(-?)(sinh|cosh|tanh)\(x\)$/.exec(t))) return '$' + m[1] + '\\' + m[2] + '(x)$';
  if (t === '1/cosh(x)') return '$\\dfrac{1}{\\cosh(x)}$';
  if (t === 'xe^(x) + C') return '$xe^{x} + C$';
  if (t === 'log_b(x) = ln(x) times ln(b)') return '$\\log_b(x) = \\ln(x)\\times\\ln(b)$';
  t = t.replace(/^R except /, '$\\mathbb{R}$ except ');
  t = t.replace(/(?<![\w$\\])([a-z])\s*=\s*(-?\d+(?:\.\d+)?)(?!\w|\.\d)/g, (mm, v, n) => '$' + v + '=' + n + '$');
  return t;
}

// Maths left sitting in running prose of the MTH banks: "at x = 0", "(3,0)",
// "[a,b]", "f(a) = f(b)", "(g o f)(x)", "sqrt(4.1)", "x-axis" ...
function fixProse(s) {
  if (typeof s !== 'string') return s;
  const parts = s.split(/(\$[^$]+\$)/g);
  const out = parts
    .map((p, i) => {
      if (i % 2 === 1) return p;
      let q = p;
      q = q.replace(/\(\s*([a-z])\s+o\s+([a-z])\s*\)\(\s*([a-z])\s*\)/g, '$($1\\circ $2)($3)$');
      q = q.replace(/\(\s*([fgh])\s*([+\-*])\s*([fgh])\s*\)\(\s*([a-z])\s*\)/g, '$($1$2$3)($4)$');
      q = q.replace(/(?<![\w$\\])([fgFh]'?)\(([fg])\(([a-z])\)\)/g, '$$$1($2($3))$$');
      q = q.replace(/(?<![\w$\\])([fgFh]'?)\(([a-z0-9+\-*^ ]{1,8})\)/g, '$$$1($2)$$');
      q = q.replace(/sqrt\(([^()]+)\)/g, '$\\sqrt{$1}$');
      q = q.replace(/(?<![\w$\\])\(\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)(?:\s*,\s*(-?\d+(?:\.\d+)?))?\s*\)/g, (m, a, b, c) => '$(' + a + ',' + b + (c ? ',' + c : '') + ')$');
      q = q.replace(/(?<![\w$\\])([\[(])([a-z]),\s*([a-z])([\])])/g, '$$$1$2,$3$4$$');
      q = q.replace(/(?<![\w$\\])([\[(])(-?\d+(?:\.\d+)?),\s*(-?\d+(?:\.\d+)?)([\])])/g, '$$$1$2,$3$4$$');
      q = q.replace(/(?<![\w$\\])([a-z])\s*=\s*([a-z])(?![\w'(])/g, '$$$1 = $2$$');
      q = q.replace(/(?<![\w$\\])([a-zA-Z])\s*=\s*(-?\d+(?:\.\d+)?)(?!\w|\.\d)/g, '$$$1 = $2$$');
      q = q.replace(/(?<![\w$\\])([xyz])-axis/g, '$$$1$$-axis');
      q = q.replace(/\b(function|vector|matrix|curve|point|scalar|constant)\s+([a-zA-Z])(?=[ ,.:?)])/g, '$1 $$$2$$');
      return q;
    })
    .join('');
  return out.replace(/\$ = \$/g, ' = ');
}

module.exports = { fixMath, fixPlain, fixSpan, fixProseOption, fixProse };
