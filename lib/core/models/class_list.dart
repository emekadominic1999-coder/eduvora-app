import 'package:flutter/foundation.dart';

/// A register of the students in a class.
///
/// Creating one also creates its study group, so a course representative can
/// set the class up once and immediately have somewhere for everybody to talk.
/// The list itself stays available and can be exported as CSV for the sort of
/// paperwork Nigerian departments actually ask for — attendance sheets,
/// course registration returns, exam lists.
@immutable
class ClassList {
  const ClassList({
    required this.id,
    required this.name,
    this.institution = '',
    this.faculty = '',
    this.department = '',
    this.level = '',
    this.session = '',
    this.ownerId = '',
    this.ownerName = '',
    this.groupId,
    this.entryCount = 0,
    this.createdAt,
  });

  final String id;
  final String name;
  final String institution;
  final String faculty;
  final String department;
  final String level;

  /// Academic session, e.g. "2025/2026".
  final String session;
  final String ownerId;
  final String ownerName;

  /// The group created alongside this list.
  final String? groupId;
  final int entryCount;
  final DateTime? createdAt;

  bool get hasGroup => groupId != null && groupId!.isNotEmpty;

  String get subtitle {
    final List<String> parts = <String>[
      if (department.isNotEmpty) department,
      if (level.isNotEmpty) level,
      if (session.isNotEmpty) session,
    ];
    return parts.isEmpty ? 'Class list' : parts.join(' · ');
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'institution': institution,
    'faculty': faculty,
    'department': department,
    'level': level,
    'session': session,
    'owner_id': ownerId.isEmpty ? null : ownerId,
    'owner_name': ownerName,
    'group_id': groupId,
    'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
  };

  factory ClassList.fromJson(Map<String, dynamic> json) => ClassList(
    id: (json['id'] ?? '') as String,
    name: (json['name'] ?? '') as String,
    institution: (json['institution'] ?? '') as String,
    faculty: (json['faculty'] ?? '') as String,
    department: (json['department'] ?? '') as String,
    level: (json['level'] ?? '') as String,
    session: (json['session'] ?? '') as String,
    ownerId: (json['owner_id'] ?? '') as String,
    ownerName: (json['owner_name'] ?? '') as String,
    groupId: json['group_id'] as String?,
    entryCount: (json['entry_count'] as num?)?.toInt() ?? 0,
    createdAt: DateTime.tryParse((json['created_at'] ?? '') as String),
  );
}

/// One student on a class list.
@immutable
class ClassListEntry {
  const ClassListEntry({
    required this.id,
    required this.classListId,
    required this.fullName,
    this.matricNumber = '',
    this.email = '',
    this.phone = '',
    this.note = '',
    this.position = 0,
    this.createdAt,
  });

  final String id;
  final String classListId;
  final String fullName;
  final String matricNumber;
  final String email;
  final String phone;

  /// Free-text column, for whatever the class actually needs to track.
  final String note;
  final int position;
  final DateTime? createdAt;

  ClassListEntry copyWith({
    String? fullName,
    String? matricNumber,
    String? email,
    String? phone,
    String? note,
    int? position,
  }) => ClassListEntry(
    id: id,
    classListId: classListId,
    fullName: fullName ?? this.fullName,
    matricNumber: matricNumber ?? this.matricNumber,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    note: note ?? this.note,
    position: position ?? this.position,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'class_list_id': classListId,
    'full_name': fullName,
    'matric_number': matricNumber,
    'email': email,
    'phone': phone,
    'note': note,
    'position': position,
    'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
  };

  factory ClassListEntry.fromJson(Map<String, dynamic> json) => ClassListEntry(
    id: (json['id'] ?? '') as String,
    classListId: (json['class_list_id'] ?? '') as String,
    fullName: (json['full_name'] ?? '') as String,
    matricNumber: (json['matric_number'] ?? '') as String,
    email: (json['email'] ?? '') as String,
    phone: (json['phone'] ?? '') as String,
    note: (json['note'] ?? '') as String,
    position: (json['position'] as num?)?.toInt() ?? 0,
    createdAt: DateTime.tryParse((json['created_at'] ?? '') as String),
  );
}

/// Turns a class list into CSV for download.
class ClassListCsv {
  const ClassListCsv._();

  static const List<String> headers = <String>[
    'S/N',
    'Full name',
    'Matriculation number',
    'Email',
    'Phone',
    'Note',
  ];

  /// A field is quoted when it contains a comma, quote or newline, and inner
  /// quotes are doubled — the RFC 4180 rules Excel actually follows.
  static String _escape(String value) {
    final bool needsQuoting =
        value.contains(',') || value.contains('"') || value.contains('\n');
    final String escaped = value.replaceAll('"', '""');
    return needsQuoting ? '"$escaped"' : escaped;
  }

  static String build(ClassList list, List<ClassListEntry> entries) {
    final StringBuffer buffer = StringBuffer();

    // A short preamble so a printed register identifies itself.
    buffer.writeln(_escape(list.name));
    if (list.institution.isNotEmpty) buffer.writeln(_escape(list.institution));
    final String context = <String>[
      list.department,
      list.level,
      list.session,
    ].where((String s) => s.isNotEmpty).join(' · ');
    if (context.isNotEmpty) buffer.writeln(_escape(context));
    buffer.writeln();

    buffer.writeln(headers.map(_escape).join(','));
    for (int i = 0; i < entries.length; i++) {
      final ClassListEntry e = entries[i];
      buffer.writeln(
        <String>[
          '${i + 1}',
          e.fullName,
          e.matricNumber,
          e.email,
          e.phone,
          e.note,
        ].map(_escape).join(','),
      );
    }
    return buffer.toString();
  }

  /// A filesystem-safe name for the downloaded file.
  static String fileNameFor(ClassList list) {
    final String base = list.name
        .replaceAll(RegExp(r'[^A-Za-z0-9 _-]'), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '_');
    return '${base.isEmpty ? 'class_list' : base}.csv';
  }
}
