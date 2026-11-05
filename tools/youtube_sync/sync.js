// Copies new videos from the Eduvora YouTube playlists into the app's
// `academic_videos` table. Runs every half hour from GitHub Actions
// (.github/workflows/sync-youtube-videos.yml) and can be run by hand:
//
//   SUPABASE_URL=... SUPABASE_SERVICE_KEY=... node tools/youtube_sync/sync.js [--dry]
//
// To add a playlist, add an entry to PLAYLISTS below.
const SUPABASE_URL = process.env.SUPABASE_URL || 'https://wdsvzhxhqzblpekdmsqs.supabase.co';
const KEY = process.env.SUPABASE_SERVICE_KEY;
const DRY = process.argv.includes('--dry');

const PLAYLISTS = [
  {
    id: 'PLFo1dsgWC5eI',
    course_code: 'MTH 101',
    department: 'All departments',
    level: '100L',
    lecturer: 'Eduvora',
  },
];

if (!KEY) {
  console.error('SUPABASE_SERVICE_KEY is not set');
  process.exit(1);
}

const headers = { apikey: KEY, Authorization: 'Bearer ' + KEY, 'Content-Type': 'application/json' };
const rest = (path, init) => fetch(SUPABASE_URL + '/rest/v1/' + path, { ...init, headers: { ...headers, ...(init && init.headers) } });
const decode = (s) => s.replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&quot;/g, '"').replace(/&#39;/g, "'");
const idOf = (url) => {
  const m = String(url || '').match(/[?&]v=([\w-]{11})/) || String(url || '').match(/youtu\.be\/([\w-]{11})/);
  return m ? m[1] : null;
};
const lessonOf = (title) => {
  const m = String(title || '').match(/lesson\s*0*(\d+)/i);
  return m ? Number(m[1]) : null;
};

const sleep = (ms) => new Promise((res) => setTimeout(res, ms));

// YouTube's public feeds answer 404/500 now and then even for good playlists,
// so try a few times before giving up.
async function feed(playlistId) {
  let r;
  for (let i = 1; i <= 6; i++) {
    r = await fetch('https://www.youtube.com/feeds/videos.xml?playlist_id=' + playlistId);
    if (r.ok) break;
    console.log('YouTube feed ' + playlistId + ' returned ' + r.status + ' (try ' + i + ' of 6)');
    if (i < 6) await sleep(i * 5000);
  }
  if (!r.ok) {
    const e = new Error('YouTube feed ' + playlistId + ' returned ' + r.status);
    e.transient = true;
    throw e;
  }
  const xml = await r.text();
  return [...xml.matchAll(/<entry>([\s\S]*?)<\/entry>/g)]
    .map((m) => ({
      id: (m[1].match(/<yt:videoId>([^<]+)/) || [])[1],
      title: decode((m[1].match(/<title>([^<]*)/) || [])[1] || ''),
      published: (m[1].match(/<published>([^<]*)/) || [])[1],
    }))
    .filter((v) => v.id)
    .sort((a, b) => String(a.published).localeCompare(String(b.published)));
}

async function main() {
  let added = 0, replaced = 0, skipped = 0;
  for (const pl of PLAYLISTS) {
    const videos = await feed(pl.id);
    const q = await rest('academic_videos?select=id,title,video_url,created_at&course_code=eq.' + encodeURIComponent(pl.course_code) + '&order=created_at.asc');
    if (!q.ok) throw new Error('Reading rows failed: ' + q.status + ' ' + (await q.text()));
    const rows = await q.json();
    for (const v of videos) {
      const url = 'https://www.youtube.com/watch?v=' + v.id;
      if (rows.some((r) => idOf(r.video_url) === v.id)) { skipped++; continue; }
      const n = lessonOf(v.title);
      const old = n == null ? null : rows.find((r) => lessonOf(r.title) === n);
      if (old) {
        console.log('REPLACE lesson ' + n + ': ' + old.video_url + ' -> ' + url + ' | ' + v.title);
        if (!DRY) {
          const r = await rest('academic_videos?id=eq.' + old.id, { method: 'PATCH', body: JSON.stringify({ title: v.title, video_url: url, thumbnail: '' }), headers: { Prefer: 'return=minimal' } });
          if (!r.ok) throw new Error('Update failed: ' + r.status + ' ' + (await r.text()));
        }
        old.video_url = url; old.title = v.title; replaced++;
      } else {
        console.log('ADD: ' + url + ' | ' + v.title);
        const row = { title: v.title, department: pl.department, faculty: '', course_code: pl.course_code, level: pl.level, video_url: url, thumbnail: '', lecturer: pl.lecturer, description: '', duration: '' };
        if (!DRY) {
          const r = await rest('academic_videos', { method: 'POST', body: JSON.stringify(row), headers: { Prefer: 'return=minimal' } });
          if (!r.ok) throw new Error('Insert failed: ' + r.status + ' ' + (await r.text()));
        }
        rows.push({ id: null, title: v.title, video_url: url }); added++;
      }
    }
  }
  console.log((DRY ? '[dry run] ' : '') + 'added ' + added + ', replaced ' + replaced + ', already up to date ' + skipped);
}

main().catch((e) => {
  if (e.transient) {
    // A YouTube hiccup is not worth a red failure: the next run, half an
    // hour later, tries again.
    console.log('::warning::' + e.message + ' - will retry on the next run');
    return;
  }
  console.error(e.message);
  process.exit(1);
});
