import 'package:flutter/foundation.dart';

/// A plan a student has bought.
enum CbtPlan {
  /// Unlocks one specific paper.
  singlePaper,

  /// Unlocks a student-picked set of papers (up to the real course-load
  /// cap) for their chosen department, level and semester — one flat price
  /// regardless of how many papers that ends up being.
  coursePack;

  static CbtPlan fromName(String? name) => switch (name) {
    'course_pack' => CbtPlan.coursePack,
    _ => CbtPlan.singlePaper,
  };

  String get wireName => switch (this) {
    CbtPlan.singlePaper => 'single_paper',
    CbtPlan.coursePack => 'course_pack',
  };
}

/// What a student has unlocked, mirroring a row of `cbt_entitlements`.
///
/// Every entitlement — however it was bought — is scoped to exactly one
/// [subjectId]. A course pack is not a single wildcard row; buying one
/// produces a separate entitlement per paper chosen, so this stays a plain,
/// unambiguous "do you own this specific paper" check either way.
@immutable
class CbtEntitlement {
  const CbtEntitlement({
    required this.id,
    required this.subjectId,
    required this.plan,
    required this.expiresAt,
    this.boundDeviceId,
  });

  final String id;
  final String subjectId;
  final CbtPlan plan;
  final DateTime expiresAt;

  /// The device this entitlement was first used on, if any -- set once,
  /// the first time the student opens a paper it covers. A mismatch here
  /// on a later device means someone other than the original device is
  /// trying to use a login that isn't theirs.
  final String? boundDeviceId;

  bool get isActive => expiresAt.isAfter(DateTime.now());

  bool coversSubjectId(String id) => isActive && subjectId == id;

  factory CbtEntitlement.fromJson(Map<String, dynamic> json) => CbtEntitlement(
    id: (json['id'] ?? '') as String,
    subjectId: (json['subject_id'] ?? '') as String,
    plan: CbtPlan.fromName(json['plan'] as String?),
    expiresAt:
        DateTime.tryParse((json['expires_at'] ?? '') as String) ??
        DateTime.now(),
    boundDeviceId: json['bound_device_id'] as String?,
  );
}
