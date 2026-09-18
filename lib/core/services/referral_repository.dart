import 'package:flutter/foundation.dart';

import '../models/referral.dart';
import 'local_store.dart';
import 'supabase_service.dart';

/// Fronts the referral programme: the student's code and earnings, applying a
/// friend's code, and requesting a payout.
///
/// Nothing here can create money or a referral on its own — every call goes
/// through a server function that checks the rules (own code, one referrer
/// per student, minimum withdrawal, real balance). Commission itself is
/// credited by the database the moment a payment is verified as successful.
class ReferralRepository {
  const ReferralRepository();

  static const String _pendingCodeKey = 'pending_referral_code';

  /// Where a shared link sends a friend.
  static const String shareBaseUrl = 'https://eduvora-app.vercel.app';

  static final RegExp _codePattern = RegExp(r'^[A-Za-z0-9]{4,12}$');

  /// On the web, a friend who opens `…/?ref=CODE` has that code remembered so
  /// it can be applied once they have signed up — sign-in redirects would
  /// otherwise lose it. Call once at start-up, after [LocalStore.init].
  static Future<void> captureLinkCode() async {
    if (!kIsWeb || !LocalStore.isReady) return;
    final String? code = Uri.base.queryParameters['ref'];
    if (code == null || !_codePattern.hasMatch(code)) return;
    await LocalStore.instance.writeString(_pendingCodeKey, code.toUpperCase());
  }

  /// Applies a code remembered from a shared link, quietly. A definite answer
  /// (accepted or refused) clears it; a network failure keeps it to retry.
  Future<void> applyPendingLinkCode() async {
    if (!SupabaseService.isReady || !LocalStore.isReady) return;
    final String? code = LocalStore.instance.readString(_pendingCodeKey);
    if (code == null || code.isEmpty) return;
    try {
      await SupabaseService.client.rpc(
        'apply_referral_code',
        params: <String, dynamic>{'p_code': code},
      );
      await LocalStore.instance.remove(_pendingCodeKey);
    } catch (error) {
      debugPrint('[Eduvora] pending referral code not applied yet: $error');
    }
  }

  /// The student's code, balance, and history. Throws with a readable message
  /// if the server cannot be reached.
  Future<ReferralSummary> summary() async {
    if (!SupabaseService.isReady) {
      throw StateError('Referrals need the Eduvora backend to be connected.');
    }
    final Object? data = await SupabaseService.client.rpc(
      'get_referral_summary',
    );
    if (data is! Map<String, dynamic>) {
      throw StateError('Could not load your referral details.');
    }
    return ReferralSummary.fromJson(data);
  }

  Future<ReferralResult> applyCode(String code) =>
      _call('apply_referral_code', <String, dynamic>{'p_code': code.trim()});

  Future<ReferralResult> requestWithdrawal({
    required int amountKobo,
    required String bankName,
    required String accountNumber,
    required String accountName,
  }) => _call('request_referral_withdrawal', <String, dynamic>{
    'p_amount_kobo': amountKobo,
    'p_bank_name': bankName.trim(),
    'p_account_number': accountNumber.trim(),
    'p_account_name': accountName.trim(),
  });

  Future<ReferralResult> _call(String fn, Map<String, dynamic> params) async {
    if (!SupabaseService.isReady) {
      return const ReferralResult(
        ok: false,
        error: 'Referrals need the Eduvora backend to be connected.',
      );
    }
    try {
      final Object? data = await SupabaseService.client.rpc(fn, params: params);
      if (data is Map<String, dynamic>) {
        return ReferralResult(
          ok: data['ok'] == true,
          error: data['error'] as String?,
        );
      }
      return const ReferralResult(ok: false, error: 'Something went wrong.');
    } catch (error) {
      debugPrint('[Eduvora] $fn failed: $error');
      return const ReferralResult(
        ok: false,
        error: 'Could not reach the server. Check your connection and retry.',
      );
    }
  }

  static String shareLink(String code) => '$shareBaseUrl/?ref=$code';

  static String shareMessage(String code) =>
      'I use Eduvora for my courses — outlines, CBT practice and more. '
      'Sign up with my referral code $code: ${shareLink(code)}';

  static Uri whatsAppUri(String code) => Uri.parse(
    'https://wa.me/?text=${Uri.encodeComponent(shareMessage(code))}',
  );
}
