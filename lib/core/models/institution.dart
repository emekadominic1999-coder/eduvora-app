import 'package:flutter/material.dart';

/// The three categories of Nigerian higher institution Eduvora serves.
enum InstitutionType {
  university('University', 'Universities', Icons.account_balance_rounded),
  polytechnic('Polytechnic', 'Polytechnics', Icons.engineering_rounded),
  collegeOfEducation(
    'College of Education',
    'Colleges of Education',
    Icons.menu_book_rounded,
  );

  const InstitutionType(this.label, this.plural, this.icon);

  final String label;
  final String plural;
  final IconData icon;

  static InstitutionType fromName(String? name) {
    return InstitutionType.values.firstWhere(
      (InstitutionType t) => t.name == name || t.label == name,
      orElse: () => InstitutionType.university,
    );
  }
}

/// Who runs the institution. Useful for filtering and for fee expectations.
enum Ownership {
  federal('Federal'),
  state('State'),
  private('Private');

  const Ownership(this.label);

  final String label;

  static Ownership fromName(String? name) {
    return Ownership.values.firstWhere(
      (Ownership o) => o.name == name || o.label == name,
      orElse: () => Ownership.federal,
    );
  }
}

/// A single higher institution in Nigeria.
@immutable
class Institution {
  const Institution({
    required this.name,
    required this.abbreviation,
    required this.state,
    required this.type,
    required this.ownership,
  });

  final String name;
  final String abbreviation;
  final String state;
  final InstitutionType type;
  final Ownership ownership;

  /// Everything a student might type when hunting for their school.
  String get searchIndex =>
      '$name $abbreviation $state ${type.label} ${ownership.label}'
          .toLowerCase();

  bool matches(String query) {
    final String needle = query.trim().toLowerCase();
    if (needle.isEmpty) return true;
    return needle
        .split(RegExp(r'\s+'))
        .every((String token) => searchIndex.contains(token));
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'abbreviation': abbreviation,
        'state': state,
        'type': type.name,
        'ownership': ownership.name,
      };

  factory Institution.fromJson(Map<String, dynamic> json) => Institution(
        name: (json['name'] ?? '') as String,
        abbreviation: (json['abbreviation'] ?? '') as String,
        state: (json['state'] ?? '') as String,
        type: InstitutionType.fromName(json['type'] as String?),
        ownership: Ownership.fromName(json['ownership'] as String?),
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is Institution && other.name == name);

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => '$name ($abbreviation)';
}
