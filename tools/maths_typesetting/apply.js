// node apply.js [--dry]  : PATCH each changed row (question/options/explanation)
const fs = require('fs');
const ov = JSON.parse(fs.readFileSync(__dirname + '/overrides.json', 'utf8'));
const ch = JSON.parse(fs.readFileSync(__dirname + '/changes.json', 'utf8'));
const U = process.env.SUPABASE_URL || 'https://wdsvzhxhqzblpekdmsqs.supabase.co', K = process.env.SUPABASE_SERVICE_KEY;
const H = { apikey: K, Authorization: 'Bearer ' + K, 'Content-Type': 'application/json', Prefer: 'return=minimal' };
const dry = process.argv.includes('--dry');
const rows = ch.map((c) => ({ id: c.id, ...c.neu }));
// overrides for rows the generic pass left alone (or changed)
const seen = new Set(rows.map((r) => r.id));
const pulled = require('./pulled.json');
for (const sid in pulled) for (const q of pulled[sid]) {
  if (ov[q.id]) {
    let r = rows.find((x) => x.id === q.id);
    if (!r) { r = { id: q.id, question: q.question, options: q.options, explanation: q.explanation }; rows.push(r); }
    r.question = ov[q.id];
  }
}
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
(async () => {
  console.log('rows to patch:', rows.length, dry ? '(dry)' : '');
  if (dry) return;
  let done = 0, fail = 0;
  for (const r of rows) {
    const body = { question: r.question, options: r.options, explanation: r.explanation };
    let ok = false;
    for (let i = 0; i < 5 && !ok; i++) {
      try {
        const res = await fetch(`${U}/rest/v1/cbt_questions?id=eq.${r.id}`, { method: 'PATCH', headers: H, body: JSON.stringify(body) });
        if (res.ok) ok = true; else { await sleep(1500); }
      } catch (e) { await sleep(2500); }
    }
    if (ok) done++; else { fail++; console.log('FAILED', r.id); }
    if ((done + fail) % 100 === 0) console.log(done + fail, '/', rows.length);
  }
  console.log('done', done, 'failed', fail);
})();
