import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

/// Single entry point to the Supabase client.
///
/// Initialisation is intentionally forgiving: if the project has not been
/// provisioned yet, or the network is unavailable at cold start, the app drops
/// into Campus Mode instead of crashing on the splash screen.
class SupabaseService {
  const SupabaseService._();

  static bool _ready = false;
  static String? _initError;

  /// True when a live Supabase client is available for reads and writes.
  static bool get isReady => _ready;

  /// Human-readable reason the backend is unavailable, if any.
  static String? get initError => _initError;

  static SupabaseClient get client {
    if (!_ready) {
      throw StateError(
        'Supabase is not configured. Guard calls with SupabaseService.isReady.',
      );
    }
    return Supabase.instance.client;
  }

  static GoTrueClient get auth => client.auth;

  static Session? get currentSession =>
      _ready ? Supabase.instance.client.auth.currentSession : null;

  static User? get currentUser =>
      _ready ? Supabase.instance.client.auth.currentUser : null;

  static Future<void> initialise() async {
    if (!AppConfig.hasBackend) {
      _initError = 'No Supabase credentials supplied at build time.';
      debugPrint('[Eduvora] Campus Mode: $_initError');
      return;
    }

    try {
      await Supabase.initialize(
        url: AppConfig.supabaseUrl,
        // The anon key is also accepted here; newer projects issue a
        // publishable key for the same purpose.
        publishableKey: AppConfig.supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(
          authFlowType: AuthFlowType.pkce,
        ),
        realtimeClientOptions: const RealtimeClientOptions(
          logLevel: RealtimeLogLevel.error,
        ),
      );
      _ready = true;
      _initError = null;
      debugPrint('[Eduvora] Connected to Supabase.');
    } catch (error, stack) {
      _ready = false;
      _initError = error.toString();
      debugPrint('[Eduvora] Supabase initialisation failed: $error');
      debugPrintStack(stackTrace: stack, maxFrames: 6);
    }
  }
}
