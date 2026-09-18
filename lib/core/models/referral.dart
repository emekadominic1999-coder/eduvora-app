import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Formats an amount held in kobo as naira: whole naira as "₦1,200", anything
/// with kobo as "₦12.50".
String formatNaira(int kobo) {
  if (kobo % 100 == 0) {
    return '₦${NumberFormat('#,##0').format(kobo ~/ 100)}';
  }
  return '₦${NumberFormat('#,##0.00').format(kobo / 100)}';
}

/// One commission credited to the student because a friend they referred paid.
@immutable
class ReferralEarning {
  const ReferralEarning({
    required this.createdAt,
    required this.commissionKobo,
    required this.paymentAmountKobo,
    required this.firstName,
  });

  final DateTime createdAt;
  final int commissionKobo;
  final int paymentAmountKobo;

  /// First name only — a referrer never sees a friend's full name.
  final String firstName;

  factory ReferralEarning.fromJson(Map<String, dynamic> json) => ReferralEarning(
    createdAt: DateTime.tryParse('${json['created_at']}')?.toLocal() ??
        DateTime.now(),
    commissionKobo: (json['commission_kobo'] as num?)?.toInt() ?? 0,
    paymentAmountKobo: (json['payment_amount_kobo'] as num?)?.toInt() ?? 0,
    firstName: (json['first_name'] ?? 'A student') as String,
  );
}

/// A request to be paid out, and where it stands.
@immutable
class ReferralWithdrawal {
  const ReferralWithdrawal({
    required this.id,
    required this.amountKobo,
    required this.bankName,
    required this.accountNumber,
    required this.accountName,
    required this.status,
    required this.note,
    required this.createdAt,
    this.paidAt,
  });

  final String id;
  final int amountKobo;
  final String bankName;
  final String accountNumber;
  final String accountName;

  /// `pending`, `paid` or `rejected`.
  final String status;
  final String note;
  final DateTime createdAt;
  final DateTime? paidAt;

  bool get isPending => status == 'pending';
  bool get isPaid => status == 'paid';
  bool get isRejected => status == 'rejected';

  factory ReferralWithdrawal.fromJson(Map<String, dynamic> json) =>
      ReferralWithdrawal(
        id: (json['id'] ?? '') as String,
        amountKobo: (json['amount_kobo'] as num?)?.toInt() ?? 0,
        bankName: (json['bank_name'] ?? '') as String,
        accountNumber: (json['account_number'] ?? '') as String,
        accountName: (json['account_name'] ?? '') as String,
        status: (json['status'] ?? 'pending') as String,
        note: (json['note'] ?? '') as String,
        createdAt: DateTime.tryParse('${json['created_at']}')?.toLocal() ??
            DateTime.now(),
        paidAt: json['paid_at'] == null
            ? null
            : DateTime.tryParse('${json['paid_at']}')?.toLocal(),
      );
}

/// Everything the referral screen shows, as returned by the server.
@immutable
class ReferralSummary {
  const ReferralSummary({
    required this.code,
    required this.commissionPercent,
    required this.minWithdrawalKobo,
    required this.referredCount,
    required this.totalEarnedKobo,
    required this.withdrawnKobo,
    required this.availableKobo,
    required this.hasReferrer,
    required this.activity,
    required this.withdrawals,
  });

  final String code;
  final int commissionPercent;
  final int minWithdrawalKobo;
  final int referredCount;
  final int totalEarnedKobo;

  /// Already paid out, plus requests still waiting to be paid.
  final int withdrawnKobo;
  final int availableKobo;

  /// True once the student has applied someone else's code.
  final bool hasReferrer;
  final List<ReferralEarning> activity;
  final List<ReferralWithdrawal> withdrawals;

  bool get canWithdraw => availableKobo >= minWithdrawalKobo;
  int get shortfallKobo =>
      canWithdraw ? 0 : minWithdrawalKobo - availableKobo;

  factory ReferralSummary.fromJson(Map<String, dynamic> json) =>
      ReferralSummary(
        code: (json['code'] ?? '') as String,
        commissionPercent: (json['commission_percent'] as num?)?.toInt() ?? 10,
        minWithdrawalKobo:
            (json['min_withdrawal_kobo'] as num?)?.toInt() ?? 100000,
        referredCount: (json['referred_count'] as num?)?.toInt() ?? 0,
        totalEarnedKobo: (json['total_earned_kobo'] as num?)?.toInt() ?? 0,
        withdrawnKobo: (json['withdrawn_kobo'] as num?)?.toInt() ?? 0,
        availableKobo: (json['available_kobo'] as num?)?.toInt() ?? 0,
        hasReferrer: (json['has_referrer'] ?? false) as bool,
        activity: (json['activity'] as List<dynamic>? ?? <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(ReferralEarning.fromJson)
            .toList(),
        withdrawals: (json['withdrawals'] as List<dynamic>? ?? <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map(ReferralWithdrawal.fromJson)
            .toList(),
      );
}

/// Outcome of a server call that can be refused with a plain-English reason.
@immutable
class ReferralResult {
  const ReferralResult({required this.ok, this.error});

  final bool ok;
  final String? error;
}
