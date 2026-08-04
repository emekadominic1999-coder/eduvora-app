import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;
import 'package:uuid/uuid.dart';

import '../config/app_config.dart';
import '../models/student_profile.dart';
import '../services/local_store.dart';
import '../services/supabase_service.dart';

/// Where the app is in the sign-in → onboarding → dashboard journey.
enum AuthStatus {
  /// Still restoring persisted state.
  unknown,

  /// No student is signed in; the sign-in screen is shown.
  signedOut,

  /// Signed in, but the academic identity has not been chosen yet.
  needsOnboarding,

  /// Fully set up; the dashboard is shown.
  ready,
}

/// Raised for any expected authentication failure so the UI can show a calm,
/// plain-English message instead of a raw exception.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Owns the authentication session and the signed-in student's profile.
///
/// Works against Supabase when credentials were supplied at build time, and
/// against on-device storage otherwise. The rest of the app never needs to
/// know which path is live.
class SessionController extends ChangeNotifier {
  SessionController();

  static const Uuid _uuid = Uuid();

  AuthStatus _status = AuthStatus.unknown;
  StudentProfile? _profile;
  bool _busy = false;

  AuthStatus get status => _status;
  StudentProfile? get profile => _profile;
  bool get isBusy => _busy;
  bool get isSignedIn =>
      _status == AuthStatus.ready || _status == AuthStatus.needsOnboarding;

  /// True when a live Supabase project is backing this session.
  bool get usingBackend => SupabaseService.isReady;

  String get backendLabel => usingBackend ? 'Connected' : 'Campus Mode';

  // ------------------------------------------------------------- bootstrap

  /// Restores any persisted session. Called once from the splash gate.
  Future<void> bootstrap() async {
    try {
      if (SupabaseService.isReady) {
        final sb.Session? session = SupabaseService.currentSession;
        if (session != null) {
          await _loadRemoteProfile(session.user);
          return;
        }
      }

      final Map<String, dynamic>? cached =
          LocalStore.instance.readMap(StoreKeys.profile);
      final String? currentUser =
          LocalStore.instance.readString(StoreKeys.currentUser);

      if (cached != null && currentUser != null && currentUser.isNotEmpty) {
        _profile = StudentProfile.fromJson(cached);
        _status = _profile!.isComplete
            ? AuthStatus.ready
            : AuthStatus.needsOnboarding;
      } else {
        _status = AuthStatus.signedOut;
      }
    } catch (error) {
      debugPrint('[Eduvora] bootstrap failed: $error');
      _status = AuthStatus.signedOut;
    }
    notifyListeners();
  }

  // ------------------------------------------------------- email & password

  Future<void> signUpWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setBusy(true);
    try {
      final String cleanEmail = email.trim().toLowerCase();

      if (SupabaseService.isReady) {
        final sb.AuthResponse response = await SupabaseService.auth.signUp(
          email: cleanEmail,
          password: password,
          data: <String, dynamic>{'full_name': fullName.trim()},
        );
        final sb.User? user = response.user;
        if (user == null) {
          throw const AuthFailure(
            'We have sent a confirmation link to your email. Please open it, '
            'then come back and sign in.',
          );
        }
        await _loadRemoteProfile(user, fallbackName: fullName.trim());
        return;
      }

      // ---- Campus Mode ----
      final List<Map<String, dynamic>> accounts =
          LocalStore.instance.readList(StoreKeys.localAccounts);
      final bool exists = accounts.any(
        (Map<String, dynamic> a) => a['email'] == cleanEmail,
      );
      if (exists) {
        throw const AuthFailure(
          'An account already exists for this email address. Please sign in '
          'instead.',
        );
      }

      final String salt = _newSalt();
      final String id = _uuid.v4();
      accounts.add(<String, dynamic>{
        'id': id,
        'email': cleanEmail,
        'full_name': fullName.trim(),
        'salt': salt,
        'password_hash': _hash(password, salt),
        'created_at': DateTime.now().toIso8601String(),
      });
      await LocalStore.instance.writeList(StoreKeys.localAccounts, accounts);

      final StudentProfile fresh =
          StudentProfile.empty(id, cleanEmail, fullName.trim());
      await _persistLocalSession(fresh);
      _profile = fresh;
      _status = AuthStatus.needsOnboarding;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _setBusy(true);
    try {
      final String cleanEmail = email.trim().toLowerCase();

      if (SupabaseService.isReady) {
        final sb.AuthResponse response =
            await SupabaseService.auth.signInWithPassword(
          email: cleanEmail,
          password: password,
        );
        final sb.User? user = response.user;
        if (user == null) {
          throw const AuthFailure(
            'We could not sign you in. Please check your details and try again.',
          );
        }
        await _loadRemoteProfile(user);
        return;
      }

      // ---- Campus Mode ----
      final List<Map<String, dynamic>> accounts =
          LocalStore.instance.readList(StoreKeys.localAccounts);
      Map<String, dynamic>? account;
      for (final Map<String, dynamic> a in accounts) {
        if (a['email'] == cleanEmail) {
          account = a;
          break;
        }
      }

      if (account == null) {
        throw const AuthFailure(
          'We could not find an account with that email address. Would you '
          'like to create one?',
        );
      }

      final String salt = (account['salt'] ?? '') as String;
      if (_hash(password, salt) != account['password_hash']) {
        throw const AuthFailure(
          'That password does not match our records. Do try again, or reset it '
          'if you have forgotten.',
        );
      }

      final Map<String, dynamic>? saved =
          LocalStore.instance.readMap('${StoreKeys.profile}.$cleanEmail');
      final StudentProfile restored = saved != null
          ? StudentProfile.fromJson(saved)
          : StudentProfile.empty(
              (account['id'] ?? _uuid.v4()) as String,
              cleanEmail,
              (account['full_name'] ?? '') as String,
            );

      await _persistLocalSession(restored);
      _profile = restored;
      _status =
          restored.isComplete ? AuthStatus.ready : AuthStatus.needsOnboarding;
    } finally {
      _setBusy(false);
    }
  }

  // -------------------------------------------------------------- Google

  /// Starts the Google OAuth flow through Supabase.
  ///
  /// Returns `true` when the browser hand-off was launched. The session itself
  /// arrives asynchronously through [listenToAuthChanges].
  Future<bool> signInWithGoogle() async {
    if (!SupabaseService.isReady) {
      throw const AuthFailure(
        'Google sign-in needs the Eduvora backend to be connected. For now, '
        'please continue with your email address — everything else works '
        'exactly the same.',
      );
    }

    _setBusy(true);
    try {
      return await SupabaseService.auth.signInWithOAuth(
        sb.OAuthProvider.google,
        redirectTo: kIsWeb ? null : AppConfig.oauthRedirect,
        authScreenLaunchMode: kIsWeb
            ? sb.LaunchMode.platformDefault
            : sb.LaunchMode.externalApplication,
      );
    } finally {
      _setBusy(false);
    }
  }

  /// Bridges Supabase auth events into this controller.
  void listenToAuthChanges() {
    if (!SupabaseService.isReady) return;
    SupabaseService.auth.onAuthStateChange.listen(
      (sb.AuthState event) async {
        final sb.Session? session = event.session;
        if (session == null) {
          if (_status != AuthStatus.signedOut) {
            _profile = null;
            _status = AuthStatus.signedOut;
            notifyListeners();
          }
          return;
        }
        if (_profile?.id != session.user.id) {
          await _loadRemoteProfile(session.user);
        }
      },
      onError: (Object error) =>
          debugPrint('[Eduvora] auth stream error: $error'),
    );
  }

  // -------------------------------------------------------------- profile

  /// Saves the academic identity chosen during onboarding, or later edits.
  Future<void> saveProfile(StudentProfile updated) async {
    _setBusy(true);
    try {
      _profile = updated;

      if (SupabaseService.isReady) {
        try {
          await SupabaseService.client
              .from('profiles')
              .upsert(updated.toJson())
              .select()
              .maybeSingle();
        } catch (error) {
          // A network hiccup must never cost the student their onboarding.
          debugPrint('[Eduvora] profile upsert failed, cached locally: $error');
        }
      }

      await LocalStore.instance
          .writeMap(StoreKeys.profile, updated.toJson());
      await LocalStore.instance.writeMap(
        '${StoreKeys.profile}.${updated.email}',
        updated.toJson(),
      );
      _status =
          updated.isComplete ? AuthStatus.ready : AuthStatus.needsOnboarding;
    } finally {
      _setBusy(false);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    final String cleanEmail = email.trim().toLowerCase();
    if (cleanEmail.isEmpty) {
      throw const AuthFailure('Please enter your email address first.');
    }
    if (!SupabaseService.isReady) {
      throw const AuthFailure(
        'Password resets need the Eduvora backend to be connected. In Campus '
        'Mode you can simply create a fresh account.',
      );
    }
    await SupabaseService.auth.resetPasswordForEmail(cleanEmail);
  }

  Future<void> signOut() async {
    _setBusy(true);
    try {
      if (SupabaseService.isReady) {
        try {
          await SupabaseService.auth.signOut();
        } catch (error) {
          debugPrint('[Eduvora] remote sign-out failed: $error');
        }
      }
      await LocalStore.instance.remove(StoreKeys.currentUser);
      await LocalStore.instance.remove(StoreKeys.profile);
      _profile = null;
      _status = AuthStatus.signedOut;
    } finally {
      _setBusy(false);
    }
  }

  // -------------------------------------------------------------- helpers

  Future<void> _loadRemoteProfile(
    sb.User user, {
    String fallbackName = '',
  }) async {
    final String name = fallbackName.isNotEmpty
        ? fallbackName
        : (user.userMetadata?['full_name'] as String?) ??
            (user.userMetadata?['name'] as String?) ??
            (user.email?.split('@').first ?? 'Student');

    StudentProfile resolved = StudentProfile.empty(
      user.id,
      user.email ?? '',
      name,
    ).copyWith(
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );

    try {
      final Map<String, dynamic>? row = await SupabaseService.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      if (row != null) {
        resolved = StudentProfile.fromJson(row);
      }
    } catch (error) {
      debugPrint('[Eduvora] profile fetch failed, using cache: $error');
      final Map<String, dynamic>? cached =
          LocalStore.instance.readMap('${StoreKeys.profile}.${user.email}');
      if (cached != null) resolved = StudentProfile.fromJson(cached);
    }

    await _persistLocalSession(resolved);
    _profile = resolved;
    _status =
        resolved.isComplete ? AuthStatus.ready : AuthStatus.needsOnboarding;
    notifyListeners();
  }

  Future<void> _persistLocalSession(StudentProfile p) async {
    await LocalStore.instance.writeString(StoreKeys.currentUser, p.email);
    await LocalStore.instance.writeMap(StoreKeys.profile, p.toJson());
    await LocalStore.instance
        .writeMap('${StoreKeys.profile}.${p.email}', p.toJson());
  }

  void _setBusy(bool value) {
    if (_busy == value) return;
    _busy = value;
    notifyListeners();
  }

  static String _newSalt() {
    final Random rng = Random.secure();
    final List<int> bytes =
        List<int>.generate(16, (_) => rng.nextInt(256));
    return base64Url.encode(bytes);
  }

  static String _hash(String password, String salt) =>
      sha256.convert(utf8.encode('$salt::$password')).toString();

  /// Translates backend errors into language a stressed student can read.
  static String describeError(Object error) {
    if (error is AuthFailure) return error.message;
    if (error is sb.AuthException) {
      final String message = error.message.toLowerCase();
      if (message.contains('invalid login')) {
        return 'That email and password combination did not work. Do check '
            'them and try once more.';
      }
      if (message.contains('already registered') ||
          message.contains('already exists')) {
        return 'An account already exists for this email address. Please sign '
            'in instead.';
      }
      if (message.contains('email not confirmed')) {
        return 'Please confirm your email address first — the link is in your '
            'inbox.';
      }
      if (message.contains('password')) {
        return 'Your password needs to be at least six characters long.';
      }
      return error.message;
    }
    if (error is sb.PostgrestException) {
      return 'We could not reach your records just now. Please try again in a '
          'moment.';
    }
    final String text = error.toString();
    if (text.contains('SocketException') ||
        text.contains('Failed host lookup') ||
        text.contains('ClientException')) {
      return 'You appear to be offline. Eduvora will keep your work safely on '
          'this device until the network returns.';
    }
    return 'Something did not go to plan. Please try again.';
  }
}

/// The single session used across the app.
final SessionController sessionController = SessionController();
