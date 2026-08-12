import 'package:flutter/foundation.dart';

/// A plan a student has bought.
enum CbtPlan {
  /// Unlocks one specific paper.
  singlePaper,

  /// Unlocks every paper, current and future, for the access window.
  semesterAll;

  static CbtPlan fromName(String? name) => switch (name) {
    'semester_all' => CbtPlan.semesterAll,
    _ => CbtPlan.singlePaper,
  };

  String get wireName => switch (this) {
    CbtPlan.singlePaper => 'single_paper',
    CbtPlan.semesterAll => 'semester_all',
  };
}

/// What a student has unlocked, mirroring a row of `cbt_entitlements`.
@immutable
class CbtEntitlement {
  const CbtEntitlement({
    required this.subjectId,
    required this.plan,
    required this.expiresAt,
  });

  /// Empty means every subject (a [CbtPlan.semesterAll] purchase).
  final String subjectId;
  final CbtPlan plan;
  final DateTime expiresAt;

  bool get isAllSubjects => subjectId.isEmpty;

  bool get isActive => expiresAt.isAfter(DateTime.now());

  bool coversSubject(String id) => isActive && (isAllSubjects || subjectId == id);

  factory CbtEntitlement.fromJson(Map<String, dynamic> json) => CbtEntitlement(
    subjectId: (json['subject_id'] ?? '') as String,
    plan: CbtPlan.fromName(json['plan'] as String?),
    expiresAt:
        DateTime.tryParse((json['expires_at'] ?? '') as String) ??
        DateTime.now(),
  );
}
