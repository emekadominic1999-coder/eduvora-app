/// Environment configuration for Eduvora.
///
/// Credentials are injected at build time so that no secret is ever committed:
///
/// ```
/// flutter run \
///   --dart-define=SUPABASE_URL=https://xxxx.supabase.co \
///   --dart-define=SUPABASE_ANON_KEY=eyJhbGciOi...
/// ```
///
/// When the values are absent the app starts in **Campus Mode** — a fully
/// functional offline build backed by on-device storage and the bundled
/// starter library. Every screen behaves identically; only the persistence
/// target changes. This keeps the app demonstrable before the backend project
/// has been provisioned.
class AppConfig {
  const AppConfig._();

  static const String appName = 'Eduvora';
  static const String tagline = 'Learn together. Graduate stronger.';
  static const String supportEmail = 'hello@eduvora.ng';
  static const String githubUser = 'DominicEmeka';
  static const String githubUrl =
      'https://github.com/emekadominic1999-coder/DominicEmeka';
  static const String version = '1.0.0';

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey =
      String.fromEnvironment('SUPABASE_ANON_KEY');

  /// Deep link registered in the Supabase dashboard for OAuth callbacks.
  static const String oauthRedirect = 'com.dominicemeka.eduvora://login-callback';

  /// True when a Supabase project has been wired up for this build.
  static bool get hasBackend =>
      supabaseUrl.trim().isNotEmpty && supabaseAnonKey.trim().isNotEmpty;

  /// Storage bucket holding lecture notes, past questions and handouts.
  static const String materialsBucket = 'materials';

  /// Storage bucket holding academic video files and thumbnails.
  static const String videosBucket = 'academic-videos';
}
