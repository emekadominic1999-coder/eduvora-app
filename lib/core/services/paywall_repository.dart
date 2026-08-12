import 'package:flutter/foundation.dart';

import '../models/cbt_entitlement.dart';
import 'local_store.dart';
import 'supabase_service.dart';

/// What the paystack-initialize function hands back to start a checkout.
@immutable
class PaystackCheckout {
  const PaystackCheckout({
    required this.authorizationUrl,
    required this.reference,
    required this.amountKobo,
    required this.accessDays,
  });

  final String authorizationUrl;
  final String reference;
  final int amountKobo;
  final int accessDays;

  double get amountNaira => amountKobo / 100;
}

/// Fronts the CBT paywall: what a student has unlocked, the free-trial
/// allowance on a locked paper, and starting/confirming a Paystack checkout.
///
/// Entitlements and payments are only ever written server-side by the two
/// edge functions — this repository never writes either table directly, so
/// there is no client-side path to unlocking a paper without actually paying.
class PaywallRepository {
  const PaywallRepository();

  /// How many questions a locked paper allows for free, once, before the
  /// paywall is shown. Tracked on-device only — a soft nudge rather than a
  /// hard limit, since a reinstall resets it. Full server-side enforcement
  /// is a reasonable future hardening step if this turns out to be abused.
  static const int freeTrialQuestionCount = 5;

  Future<List<CbtEntitlement>> myEntitlements() async {
    if (!SupabaseService.isReady) return <CbtEntitlement>[];
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('cbt_entitlements')
          .select();
      return rows
          .whereType<Map<String, dynamic>>()
          .map(CbtEntitlement.fromJson)
          .where((CbtEntitlement e) => e.isActive)
          .toList();
    } catch (error) {
      debugPrint('[Eduvora] entitlements fetch failed: $error');
      return <CbtEntitlement>[];
    }
  }

  bool hasAccess(String subjectId, List<CbtEntitlement> entitlements) =>
      entitlements.any((CbtEntitlement e) => e.coversSubject(subjectId));

  bool hasUsedFreeTrial(String subjectId) =>
      LocalStore.instance.readBool(_trialKey(subjectId));

  Future<void> markFreeTrialUsed(String subjectId) =>
      LocalStore.instance.writeBool(_trialKey(subjectId), value: true);

  String _trialKey(String subjectId) => '${StoreKeys.cbtFreeTrialUsed}.$subjectId';

  /// Starts a checkout for [plan]. [subjectId]/[subjectName] are required for
  /// [CbtPlan.singlePaper] and ignored for [CbtPlan.semesterAll].
  Future<PaystackCheckout> startCheckout({
    required CbtPlan plan,
    String subjectId = '',
    String subjectName = '',
  }) async {
    if (!SupabaseService.isReady) {
      throw StateError(
        'Paying for CBT access needs the Eduvora backend to be connected.',
      );
    }

    final Map<String, dynamic> response = await SupabaseService.client.functions
        .invoke(
          'paystack-initialize',
          body: <String, dynamic>{
            'plan': plan.wireName,
            if (plan == CbtPlan.singlePaper) 'subjectId': subjectId,
            if (plan == CbtPlan.singlePaper) 'subjectName': subjectName,
          },
        )
        .then((response) => response.data as Map<String, dynamic>);

    return PaystackCheckout(
      authorizationUrl: response['authorizationUrl'] as String,
      reference: response['reference'] as String,
      amountKobo: (response['amountKobo'] as num).toInt(),
      accessDays: (response['accessDays'] as num).toInt(),
    );
  }

  /// Asks the backend to check a checkout's status with Paystack directly.
  /// Returns true once the charge is confirmed and the entitlement is live.
  Future<bool> verify(String reference) async {
    if (!SupabaseService.isReady) return false;
    try {
      final response = await SupabaseService.client.functions.invoke(
        'paystack-verify',
        body: <String, dynamic>{'reference': reference},
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      return data['verified'] == true;
    } catch (error) {
      debugPrint('[Eduvora] payment verify failed: $error');
      return false;
    }
  }
}
