# Eduvora

Eduvora is a Flutter mobile app built for students at Nigerian universities,
polytechnics and colleges of education. One home for lecture videos, past
questions, CBT practice papers, a GP calculator, a student community, chats,
and an AI companion — filtered to your own institution, faculty, department
and level.

Built by [Dominic Emeka](https://github.com/emekadominic1999-coder/DominicEmeka).

## What's inside

| Feature | Where |
|---|---|
| Sign in / create account (email + Google, password eye toggle) | `lib/features/auth` |
| Onboarding: institution type → institution → faculty → department → level | `lib/features/onboarding` |
| Landing page (with the footer — the only screen that has one) | `lib/features/landing` |
| Home dashboard | `lib/features/home` |
| Academic videos, in-app player | `lib/features/videos` |
| Materials library + upload | `lib/features/materials` |
| CBT exam practice (timed, scored, full review) | `lib/features/cbt` |
| GP calculator (5-point scale, CGPA trend) | `lib/features/gpa` |
| Community channels | `lib/features/community` |
| Chats + study groups | `lib/features/chats` |
| Ada — the Eduvora AI assistant | `lib/features/chats/.../assistant_screen.dart` |
| Noticeboard (scholarships, admissions, opportunities) | `lib/features/news` |
| Profile | `lib/features/profile` |

Shared brand palette, spacing, and widgets live in `lib/core`.

## Brand palette

| Role | Colour |
|---|---|
| Primary (Royal Blue) | `#2563EB` |
| Accent (Bright Orange) | `#F97316` |
| Background | `#F8FAFC` |
| Text | `#1E293B` |

Defined once in [`lib/core/theme/app_theme.dart`](lib/core/theme/app_theme.dart).

## Running it

```bash
flutter pub get
flutter run
```

The app boots straight into the **sign-in screen** — that's the first thing a
student sees, by design.

### Campus Mode (no backend required)

Eduvora runs perfectly well with **no Supabase project configured**. Accounts,
academic profiles, GPA records, CBT history, community posts and uploads are
all kept on-device (`shared_preferences`), and every screen behaves exactly
as it would with a live backend. This is deliberate: the app needs to be
demonstrable and usable before a backend has been provisioned, and it needs
to keep working on a patchy campus network afterwards.

The Profile tab shows **Campus Mode** whenever this is the active path.

### Connecting Supabase (optional)

To share accounts and content across devices:

1. Create a project at [supabase.com](https://supabase.com).
2. Run [`supabase/schema.sql`](supabase/schema.sql) in the SQL editor. It creates
   `profiles`, `materials`, `academic_videos`, `community_posts`,
   `community_comments`, `gpa_semesters`, `cbt_attempts` and `news`, all with
   Row Level Security enabled, plus the `materials` and `academic-videos`
   storage buckets.
3. (Optional, for Google sign-in) Enable the Google provider under
   **Authentication → Providers**, and add the redirect URL
   `com.dominicemeka.eduvora://login-callback` under
   **Authentication → URL Configuration**.
4. Run with your project's credentials:

   ```bash
   flutter run \
     --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
     --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...
   ```

Without these two `--dart-define` values, the app quietly falls back to
Campus Mode — there is no crash, no error screen, nothing to configure first.

## Testing

```bash
flutter analyze   # 0 issues
flutter test      # unit + widget tests
```

`test/eduvora_test.dart` covers the GPA formula, the CBT bank, the Nigerian
institution directory, the academic taxonomy and Ada's intent matching.
`test/widget_flow_test.dart` drives the real screens: sign-in validation and
the password eye toggle, the five-step onboarding flow, the dashboard shell,
the GP calculator's live computation, and Ada's replies.

## Architecture notes

- **State**: a single `SessionController` (`lib/core/state/session_controller.dart`)
  owns authentication and the student's academic profile, and switches
  transparently between the Supabase and Campus Mode code paths.
- **Data**: repositories in `lib/core/services/*_repository.dart` merge
  locally-created records, remote records (when connected) and a bundled
  seed library, so every feed is populated on first launch.
- **Content coverage**: `lib/core/data/nigerian_institutions.dart` and
  `lib/core/data/academic_structure.dart` cover all three institution types
  (university, polytechnic, college of education) across every Nigerian
  state, with faculties/schools and departments for each.
- **Ada**: `lib/core/services/eduvora_ai.dart` is a fully on-device,
  intent-matching assistant — no network call, no API key, works offline. She
  answers "how do I…" questions about the app and responds with warmth when a
  student says they're struggling.

## Language

Written in British English throughout, as requested — "favourite", not
"favorite"; "organise", not "organize".
