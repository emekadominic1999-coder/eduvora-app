import 'package:flutter/foundation.dart';

import 'institution.dart';

/// The academic identity a student sets during onboarding.
///
/// This is the single object every feed in Eduvora filters against, so that a
/// 300 level Mechanical Engineering student at FUTA sees Mechanical Engineering
/// material rather than a generic firehose.
@immutable
class StudentProfile {
  const StudentProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
    this.institutionName = '',
    this.institutionAbbreviation = '',
    this.institutionState = '',
    this.institutionType = InstitutionType.university,
    this.faculty = '',
    this.department = '',
    this.level = '',
    this.matricNumber = '',
    this.bio = '',
    this.joinedAt,
  });

  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;

  final String institutionName;
  final String institutionAbbreviation;
  final String institutionState;
  final InstitutionType institutionType;

  final String faculty;
  final String department;
  final String level;
  final String matricNumber;
  final String bio;
  final DateTime? joinedAt;

  /// Onboarding is complete once the academic identity is fully known.
  bool get isComplete =>
      institutionName.isNotEmpty &&
      faculty.isNotEmpty &&
      department.isNotEmpty &&
      level.isNotEmpty;

  String get firstName {
    final String trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'Scholar';
    return trimmed.split(RegExp(r'\s+')).first;
  }

  String get initials {
    final List<String> parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'E';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  /// e.g. "300 Level · Mechanical Engineering · FUTA"
  String get academicSummary {
    final List<String> parts = <String>[
      if (level.isNotEmpty) level,
      if (department.isNotEmpty) department,
      if (institutionAbbreviation.isNotEmpty)
        institutionAbbreviation
      else if (institutionName.isNotEmpty)
        institutionName,
    ];
    return parts.isEmpty ? 'Academic details pending' : parts.join('  ·  ');
  }

  StudentProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? avatarUrl,
    String? institutionName,
    String? institutionAbbreviation,
    String? institutionState,
    InstitutionType? institutionType,
    String? faculty,
    String? department,
    String? level,
    String? matricNumber,
    String? bio,
    DateTime? joinedAt,
  }) {
    return StudentProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      institutionName: institutionName ?? this.institutionName,
      institutionAbbreviation:
          institutionAbbreviation ?? this.institutionAbbreviation,
      institutionState: institutionState ?? this.institutionState,
      institutionType: institutionType ?? this.institutionType,
      faculty: faculty ?? this.faculty,
      department: department ?? this.department,
      level: level ?? this.level,
      matricNumber: matricNumber ?? this.matricNumber,
      bio: bio ?? this.bio,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

  StudentProfile withInstitution(Institution institution) => copyWith(
    institutionName: institution.name,
    institutionAbbreviation: institution.abbreviation,
    institutionState: institution.state,
    institutionType: institution.type,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'full_name': fullName,
    'email': email,
    'avatar_url': avatarUrl,
    'institution_name': institutionName,
    'institution_abbreviation': institutionAbbreviation,
    'institution_state': institutionState,
    'institution_type': institutionType.name,
    'faculty': faculty,
    'department': department,
    'level': level,
    'matric_number': matricNumber,
    'bio': bio,
    'joined_at': (joinedAt ?? DateTime.now()).toIso8601String(),
  };

  factory StudentProfile.fromJson(Map<String, dynamic> json) {
    return StudentProfile(
      id: (json['id'] ?? '') as String,
      fullName: (json['full_name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      avatarUrl: json['avatar_url'] as String?,
      institutionName: (json['institution_name'] ?? '') as String,
      institutionAbbreviation:
          (json['institution_abbreviation'] ?? '') as String,
      institutionState: (json['institution_state'] ?? '') as String,
      institutionType: InstitutionType.fromName(
        json['institution_type'] as String?,
      ),
      faculty: (json['faculty'] ?? '') as String,
      department: (json['department'] ?? '') as String,
      level: (json['level'] ?? '') as String,
      matricNumber: (json['matric_number'] ?? '') as String,
      bio: (json['bio'] ?? '') as String,
      joinedAt: DateTime.tryParse((json['joined_at'] ?? '') as String),
    );
  }

  static StudentProfile empty(String id, String email, String name) =>
      StudentProfile(
        id: id,
        fullName: name,
        email: email,
        joinedAt: DateTime.now(),
      );
}
