import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show FunctionException;
import 'package:uuid/uuid.dart';

import '../models/cbt.dart';
import '../models/cbt_entitlement.dart';
import 'local_store.dart';
import 'supabase_service.dart';

/// Result of checking whether the current device is allowed to use a paid
/// entitlement.
enum DeviceCheckResult {
  /// First use (device just bound) or already matches the bound device.
  allowed,

  /// A different device already holds this entitlement's binding.
  blockedOtherDevice,

  /// The check itself failed (e.g. offline) -- treated as allowed so a
  /// network hiccup doesn't lock a paying student out of their own paper.
  error,
}

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

  static const Uuid _uuid = Uuid();

  /// TESTING OVERRIDE: set to true to unlock every CBT paper without an
  /// entitlement or payment. Live/production value is false -- students pay
  /// for CBT access via Paystack.
  ///
  /// Only meant to affect whether a locked paper can be *started* for free
  /// — anything deciding which papers to show a student as relevant to
  /// their faculty must check the real entitlement list directly instead
  /// of going through [hasAccess], or this override silently makes every
  /// paper look relevant to every faculty too (that exact bug shipped once
  /// already — see `cbt_home_screen.dart`'s `_load`).
  static const bool testingUnlockAll = true;

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

  bool hasAccess(CbtSubject subject, List<CbtEntitlement> entitlements) =>
      testingUnlockAll ||
      entitlements.any((CbtEntitlement e) => e.coversSubjectId(subject.id));

  /// A random id generated once per install and kept for the life of the
  /// app (survives sign-out) -- stands in for "this physical device".
  Future<String> deviceId() async {
    if (!LocalStore.isReady) return _uuid.v4();
    final String? existing = LocalStore.instance.readString(
      StoreKeys.deviceId,
    );
    if (existing != null && existing.isNotEmpty) return existing;
    final String fresh = _uuid.v4();
    await LocalStore.instance.writeString(StoreKeys.deviceId, fresh);
    return fresh;
  }

  /// Binds [entitlement] to this device on first use, or checks this
  /// device against whatever device it's already bound to. Only ever
  /// touches `bound_device_id` -- see the database trigger that enforces
  /// this same rule server-side, since a client-only check is trivially
  /// bypassed.
  Future<DeviceCheckResult> verifyDevice(CbtEntitlement entitlement) async {
    if (!SupabaseService.isReady) return DeviceCheckResult.allowed;
    final String thisDevice = await deviceId();
    final String? bound = entitlement.boundDeviceId;

    if (bound != null && bound.isNotEmpty) {
      return bound == thisDevice
          ? DeviceCheckResult.allowed
          : DeviceCheckResult.blockedOtherDevice;
    }

    try {
      await SupabaseService.client
          .from('cbt_entitlements')
          .update(<String, dynamic>{'bound_device_id': thisDevice})
          .eq('id', entitlement.id);
      return DeviceCheckResult.allowed;
    } catch (error) {
      debugPrint('[Eduvora] device bind failed: $error');
      return DeviceCheckResult.error;
    }
  }

  bool hasUsedFreeTrial(String subjectId) =>
      LocalStore.instance.readBool(_trialKey(subjectId));

  Future<void> markFreeTrialUsed(String subjectId) =>
      LocalStore.instance.writeBool(_trialKey(subjectId), value: true);

  String _trialKey(String subjectId) => '${StoreKeys.cbtFreeTrialUsed}.$subjectId';

  /// Starts a checkout for one specific paper.
  Future<PaystackCheckout> startSinglePaperCheckout({
    required String subjectId,
    required String subjectName,
  }) => _startCheckout(<String, dynamic>{
    'plan': CbtPlan.singlePaper.wireName,
    'subjectId': subjectId,
    'subjectName': subjectName,
  });

  /// Starts a checkout for a student-picked set of papers. Pricing and the
  /// 23-unit cap are both re-checked server-side against [subjectIds] —
  /// [department]/[level]/[semester] are recorded for the receipt only.
  Future<PaystackCheckout> startCoursePackCheckout({
    required List<String> subjectIds,
    required String department,
    required String level,
    required String semester,
  }) => _startCheckout(<String, dynamic>{
    'plan': CbtPlan.coursePack.wireName,
    'subjectIds': subjectIds,
    'department': department,
    'level': level,
    'semester': semester,
  });

  Future<PaystackCheckout> _startCheckout(Map<String, dynamic> body) async {
    if (!SupabaseService.isReady) {
      throw StateError(
        'Paying for CBT access needs the Eduvora backend to be connected.',
      );
    }

    try {
      final response = await SupabaseService.client.functions.invoke(
        'paystack-initialize',
        body: body,
      );
      final Map<String, dynamic> data = response.data as Map<String, dynamic>;
      return PaystackCheckout(
        authorizationUrl: data['authorizationUrl'] as String,
        reference: data['reference'] as String,
        amountKobo: (data['amountKobo'] as num).toInt(),
        accessDays: (data['accessDays'] as num).toInt(),
      );
    } on FunctionException catch (error) {
      // The function rejects with a plain-English reason (unknown plan,
      // over the unit cap, incomplete profile, ...) in the JSON body —
      // surface that instead of a raw HTTP exception.
      final Object? details = error.details;
      final String? reason = details is Map && details['error'] is String
          ? details['error'] as String
          : null;
      throw StateError(reason ?? 'Could not start checkout. Please try again.');
    }
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
