import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import 'local_store.dart';
import 'supabase_service.dart';

/// Who an owner message goes to.
enum EmailAudience {
  me('Only me (a test)', 'me'),
  all('Everyone', 'all'),
  paid('Students with paid access', 'paid'),
  unpaid('Students without paid access', 'unpaid');

  const EmailAudience(this.label, this.value);
  final String label;
  final String value;
}

class EmailSendResult {
  const EmailSendResult({
    required this.sent,
    required this.skipped,
    required this.failed,
  });

  final int sent;
  final int skipped;
  final int failed;
}

/// Talks to the `send-email` edge function. Receipts, access codes and expiry
/// reminders are sent by the server on its own; this only covers the welcome
/// email and the messages the owner writes.
class EmailRepository {
  const EmailRepository();

  static String _welcomeKey(String userId) => 'eduvora.welcome_email.$userId';

  /// Asks the server to send the welcome email, once per student. The server
  /// refuses to send it twice, so a missed flag here is harmless. Never throws.
  Future<void> sendWelcomeOnce(String userId) async {
    if (!SupabaseService.isReady || !LocalStore.isReady) return;
    if (LocalStore.instance.readBool(_welcomeKey(userId))) return;
    try {
      await SupabaseService.client.functions.invoke(
        'send-email',
        body: <String, dynamic>{'type': 'welcome'},
      );
      await LocalStore.instance.writeBool(_welcomeKey(userId), value: true);
    } catch (error) {
      debugPrint('[Eduvora] welcome email request failed: $error');
    }
  }

  /// How many people a message to [audience] would reach. Sends nothing.
  Future<int> previewCount(EmailAudience audience) async {
    final Map<String, dynamic> data = await _call(<String, dynamic>{
      'type': 'broadcast',
      'audience': audience.value,
      'preview': true,
    });
    return (data['count'] as num?)?.toInt() ?? 0;
  }

  Future<EmailSendResult> send({
    required String subject,
    required String message,
    required EmailAudience audience,
  }) async {
    final Map<String, dynamic> data = await _call(<String, dynamic>{
      'type': 'broadcast',
      'subject': subject,
      'message': message,
      'audience': audience.value,
    });
    return EmailSendResult(
      sent: (data['sent'] as num?)?.toInt() ?? 0,
      skipped: (data['skipped'] as num?)?.toInt() ?? 0,
      failed: (data['failed'] as num?)?.toInt() ?? 0,
    );
  }

  Future<Map<String, dynamic>> _call(Map<String, dynamic> body) async {
    if (!SupabaseService.isReady) {
      throw StateError('Sending email needs the Eduvora backend.');
    }
    try {
      final sb.FunctionResponse response = await SupabaseService
          .client
          .functions
          .invoke('send-email', body: body);
      return Map<String, dynamic>.from(response.data as Map);
    } on sb.FunctionException catch (error) {
      final Object? details = error.details;
      final String? reason = details is Map && details['error'] is String
          ? details['error'] as String
          : null;
      throw StateError(
        reason ?? 'Could not reach the email service. Please try again.',
      );
    }
  }
}
