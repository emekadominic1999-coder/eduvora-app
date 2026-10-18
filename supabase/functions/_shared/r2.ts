// Cloudflare R2 helpers shared by the material functions. R2 speaks the S3
// protocol, so a "presigned URL" is just an AWS Signature V4 query-string
// signature (region `auto`, service `s3`) built here with the Web Crypto API
// — no SDK needed. The access keys only ever live in the function's
// environment: they are never logged and never returned to the app.

export interface R2Config {
  accountId: string;
  accessKeyId: string;
  secretAccessKey: string;
  bucket: string;
}

/// Reads the four R2 secrets. Returns null when any is missing so the caller
/// can answer with a plain "not set up yet" error (and the app falls back).
export function readR2Config(): R2Config | null {
  const accountId = Deno.env.get('R2_ACCOUNT_ID');
  const accessKeyId = Deno.env.get('R2_ACCESS_KEY_ID');
  const secretAccessKey = Deno.env.get('R2_SECRET_ACCESS_KEY');
  const bucket = Deno.env.get('R2_BUCKET');
  if (!accountId || !accessKeyId || !secretAccessKey || !bucket) return null;
  return { accountId, accessKeyId, secretAccessKey, bucket };
}

const encoder = new TextEncoder();

function toHex(bytes: ArrayBuffer): string {
  return Array.from(new Uint8Array(bytes))
    .map((b) => b.toString(16).padStart(2, '0'))
    .join('');
}

async function sha256Hex(text: string): Promise<string> {
  return toHex(await crypto.subtle.digest('SHA-256', encoder.encode(text)));
}

async function hmac(key: ArrayBuffer | Uint8Array, data: string): Promise<ArrayBuffer> {
  const cryptoKey = await crypto.subtle.importKey(
    'raw',
    key,
    { name: 'HMAC', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  return crypto.subtle.sign('HMAC', cryptoKey, encoder.encode(data));
}

// RFC 3986 encoding, as AWS requires (encodeURIComponent leaves !'()* alone).
function rfc3986(value: string): string {
  return encodeURIComponent(value).replace(
    /[!'()*]/g,
    (c) => `%${c.charCodeAt(0).toString(16).toUpperCase()}`,
  );
}

/// Builds a presigned R2 URL for [method] on [key].
/// [signedContentType], when given, is signed into the URL — the uploader
/// must then send exactly that Content-Type header or R2 rejects the PUT.
export async function presignR2Url(
  config: R2Config,
  options: {
    method: 'GET' | 'PUT';
    key: string;
    expiresSeconds: number;
    signedContentType?: string;
    extraQuery?: Record<string, string>;
  },
): Promise<string> {
  const host = `${config.accountId}.r2.cloudflarestorage.com`;
  const canonicalUri =
    '/' + [config.bucket, ...options.key.split('/')].map(rfc3986).join('/');

  const now = new Date();
  const amzDate = now.toISOString().replace(/[:-]|\.\d{3}/g, ''); // 20260101T120000Z
  const dateStamp = amzDate.slice(0, 8);
  const scope = `${dateStamp}/auto/s3/aws4_request`;

  const signedHeaders = options.signedContentType ? 'content-type;host' : 'host';
  const canonicalHeaders =
    (options.signedContentType ? `content-type:${options.signedContentType.trim()}\n` : '') +
    `host:${host}\n`;

  const query: Record<string, string> = {
    ...(options.extraQuery ?? {}),
    'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
    'X-Amz-Credential': `${config.accessKeyId}/${scope}`,
    'X-Amz-Date': amzDate,
    'X-Amz-Expires': String(options.expiresSeconds),
    'X-Amz-SignedHeaders': signedHeaders,
  };
  const canonicalQuery = Object.keys(query)
    .sort()
    .map((k) => `${rfc3986(k)}=${rfc3986(query[k])}`)
    .join('&');

  const canonicalRequest = [
    options.method,
    canonicalUri,
    canonicalQuery,
    canonicalHeaders,
    signedHeaders,
    'UNSIGNED-PAYLOAD',
  ].join('\n');

  const stringToSign = [
    'AWS4-HMAC-SHA256',
    amzDate,
    scope,
    await sha256Hex(canonicalRequest),
  ].join('\n');

  const kDate = await hmac(encoder.encode(`AWS4${config.secretAccessKey}`), dateStamp);
  const kRegion = await hmac(kDate, 'auto');
  const kService = await hmac(kRegion, 's3');
  const kSigning = await hmac(kService, 'aws4_request');
  const signature = toHex(await hmac(kSigning, stringToSign));

  return `https://${host}${canonicalUri}?${canonicalQuery}&X-Amz-Signature=${signature}`;
}
