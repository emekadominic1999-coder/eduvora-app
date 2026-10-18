# Storing study materials in Cloudflare R2 (private)

Why: Supabase Storage is nearly full. R2 gives much more room, and the files
stay PRIVATE — students can only view them in the app through links that expire
after 5 minutes. Until you finish these steps the app keeps using Supabase
Storage automatically, so nothing breaks while you set this up.

## 1. Create the bucket

1. Sign up / log in at https://dash.cloudflare.com
2. Left menu: **R2 Object Storage** (it may ask for a payment card; the free
   allowance is 10 GB, and there are no download fees).
3. **Create bucket** -> name it `eduvora-materials` -> leave it **private**
   (do NOT turn on "Public access" or attach a public domain).
4. Note your **Account ID** (shown on the R2 overview page, right side).

## 2. Create an API token

1. R2 overview -> **Manage API Tokens** -> **Create API token**.
2. Permission: **Object Read & Write**. Apply to specific bucket:
   `eduvora-materials`.
3. Create. Copy the **Access Key ID** and **Secret Access Key** now (the secret
   is shown only once).

## 3. Add the secrets to Supabase

Supabase Dashboard -> your project -> **Edge Functions** -> **Secrets** -> add
these four (type the values yourself; never paste them into chat or code):

| Name | Value |
| --- | --- |
| `R2_ACCOUNT_ID` | your Cloudflare Account ID |
| `R2_ACCESS_KEY_ID` | the Access Key ID |
| `R2_SECRET_ACCESS_KEY` | the Secret Access Key |
| `R2_BUCKET` | `eduvora-materials` |

## 4. Deploy the two functions

The Supabase CLI is not installed on this computer; earlier functions were
deployed with `npx` (see `supabase/functions/fetch-news/README.md`). From the
project folder:

```
npx supabase login
npx supabase link --project-ref wdsvzhxhqzblpekdmsqs
npx supabase functions deploy material-upload-url
npx supabase functions deploy material-url
```

(`login` and `link` only need doing once; skip them if already done.)

## 5. Allow web uploads (CORS)

Cloudflare -> R2 -> `eduvora-materials` -> **Settings** -> **CORS Policy** ->
**Add CORS policy**, paste:

```json
[
  {
    "AllowedOrigins": ["*"],
    "AllowedMethods": ["PUT"],
    "AllowedHeaders": ["Content-Type"],
    "MaxAgeSeconds": 3600
  }
]
```

This is only needed for uploads from the website; the Android app does not use
CORS.

## How to check it works

Upload a small PDF from the app, then open it. In the `materials` table its
`file_url` should look like `r2://<user-id>/<id>-name.pdf`. Old files keep
working unchanged. Limits: 60 MB; PDF, JPG, PNG, DOCX, PPTX, XLSX only.
