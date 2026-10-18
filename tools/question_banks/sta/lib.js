// Shared helpers for generating exact-answer statistics questions.
let seed = 20261014;
const rnd = () => (seed = (seed * 1664525 + 1013904223) % 4294967296) / 4294967296;
const setSeed = s => { seed = s; };
const ri = (a, b) => a + Math.floor(rnd() * (b - a + 1));
const pick = arr => arr[Math.floor(rnd() * arr.length)];
const shuffle = arr => { const a = arr.slice(); for (let i = a.length - 1; i > 0; i--) { const j = Math.floor(rnd() * (i + 1)); [a[i], a[j]] = [a[j], a[i]]; } return a; };
const sum = a => a.reduce((s, x) => s + x, 0);
const mean = a => sum(a) / a.length;
const fact = n => { let r = 1; for (let i = 2; i <= n; i++) r *= i; return r; };
const nPr = (n, r) => fact(n) / fact(n - r);
const nCr = (n, r) => Math.round(fact(n) / (fact(r) * fact(n - r)));
const gcd = (a, b) => (b ? gcd(b, a % b) : Math.abs(a));
const frac = (n, d) => { const g = gcd(n, d); n /= g; d /= g; return d === 1 ? String(n) : n + '/' + d; };
const f = (v, d = 2) => { const x = Math.round(v * 10 ** d) / 10 ** d; return String(Object.is(x, -0) ? 0 : x); };
const erf = x => { // high-accuracy erf via series / continued fraction
  const sign = x < 0 ? -1 : 1; x = Math.abs(x);
  if (x < 3) { let t = x, s = x, n = 0; while (Math.abs(t) > 1e-17) { n++; t = -t * x * x / n; s += t / (2 * n + 1); } return sign * 2 / Math.sqrt(Math.PI) * s; }
  let c = 0; for (let k = 60; k >= 1; k--) c = k / 2 / (x + c); return sign * (1 - Math.exp(-x * x) / (Math.sqrt(Math.PI) * (x + c)));
};
const Phi = z => 0.5 * (1 + erf(z / Math.SQRT2));

const out = [];
const seen = new Set();
// q: question, correct: string, wrongs: array of strings (3+), e: explanation, t: topic
const add = (q, correct, wrongs, e, t) => {
  correct = String(correct);
  const ws = [];
  if (/probab/i.test(q) && (correct === '0' || correct === '1') && /rate|lifetime|binomial|independent|P\(A/i.test(q)) return false;
  wrongs = wrongs.map(String).map(w => (/^-?\d+\.\d{6,}$/.test(w) ? f(parseFloat(w), 4) : w));
  // probability-valued answers: no impossible (<0 or >1) or degenerate distractors; top up if needed
  if (/probab|P\(/i.test(q) && /^0\.\d+$/.test(correct) && !/z-score|z statistic|mean|variance|expected|value of/i.test(q)) {
    const dp = correct.split('.')[1].length, c0 = parseFloat(correct);
    wrongs = wrongs.filter(w => !/^-?\d+(\.\d+)?$/.test(w) || (parseFloat(w) > 0 && parseFloat(w) < 1));
    for (const w of [c0 * 0.5, c0 * 0.8, c0 * 1.25, (1 + c0) / 2, c0 + 0.05, c0 - 0.05, c0 / 3]) if (wrongs.length < 6 && w > 0 && w < 1) wrongs.push(w.toFixed(dp));
  }
  for (const w of wrongs.map(String)) if (!(w.startsWith("-") && !correct.startsWith("-")) && w !== correct && !ws.includes(w) && w !== 'NaN' && w !== 'Infinity') ws.push(w);
  const cn = parseFloat(correct), isNum = x => /^-?[0-9.,]+%?$/.test(x);
  const ok = ws.filter(w => !(isNum(correct) && isNum(w) && Math.abs(parseFloat(w) - cn) <= Math.max(0.011, 0.004 * Math.abs(cn))));
  ws.length = 0; ws.push(...ok);
  if (ws.length < 3 || seen.has(q)) return false;
  seen.add(q);
  out.push([q, [correct, ...ws.slice(0, 3)], 0, e, t]);
  return true;
};
// n-ary distractors around a number
const near = (v, d, steps) => steps.map(s => f(v + s, d));
module.exports = { rnd, setSeed, ri, pick, shuffle, sum, mean, fact, nPr, nCr, gcd, frac, f, erf, Phi, add, near, out, seen };
