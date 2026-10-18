const fs = require('fs');
const { fixMath, fixPlain, fixProseOption, fixProse } = require('./norm.js');
const d = require('./pulled.json');
const MATH = ['mth-101-elementary-mathematics-1', 'mth-102-vectors-geometry-dynamics', 'mth-103-calculus', 'mth-206-advanced-mathematics-vi', 'mth-208-numerical-analysis'];
const PLAIN = ['sta-111-probability-1', 'sta-112-probability-2', 'sta-131-inference-1', 'sta-132-inference-2', 'sta-172-statistical-computing-1', 'agr-101-biomathematics'];
const changes = [];
const stat = {};
for (const sid of Object.keys(d)) {
  const isMath = MATH.includes(sid);
  const f = (s) => (isMath ? fixProse(fixMath(s)) : sid.startsWith('sta-172') ? s : fixPlain(fixMath(s)));
  for (const q of d[sid]) {
    const nq = f(q.question);
    const no = (q.options || []).map((o) => (isMath ? fixProse(fixProseOption(fixMath(o))) : f(o)));
    const ne = q.explanation == null ? q.explanation : f(q.explanation);
    const diff = nq !== q.question || JSON.stringify(no) !== JSON.stringify(q.options) || ne !== q.explanation;
    if (diff) {
      changes.push({ id: q.id, sid, old: { question: q.question, options: q.options, explanation: q.explanation }, neu: { question: nq, options: no, explanation: ne } });
      stat[sid] = (stat[sid] || 0) + 1;
    }
  }
}
fs.writeFileSync('changes.json', JSON.stringify(changes));
console.log(stat, 'total', changes.length);
const n = +process.argv[2] || 0;
const sid = process.argv[3];
let shown = 0;
for (const c of changes) {
  if (sid && c.sid !== sid) continue;
  if (shown++ >= n) break;
  const o = c.old, w = c.neu;
  if (o.question !== w.question) console.log('Q-', o.question, '\nQ+', w.question);
  w.options.forEach((x, i) => { if (x !== o.options[i]) console.log(' O-', o.options[i], '\n O+', x); });
  if (o.explanation !== w.explanation) console.log(' E-', (o.explanation || '').slice(0, 220), '\n E+', (w.explanation || '').slice(0, 220));
  console.log('---');
}
