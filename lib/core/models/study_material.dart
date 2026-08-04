import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// What kind of resource a student has shared.
enum MaterialKind {
  lectureNote('Lecture note', Icons.description_rounded, AppColours.primary),
  pastQuestion('Past question', Icons.history_edu_rounded, AppColours.accent),
  handout('Handout', Icons.article_rounded, AppColours.info),
  textbook('Textbook', Icons.menu_book_rounded, AppColours.success),
  projectWork('Project work', Icons.science_rounded, Color(0xFF7C3AED)),
  slide('Slides', Icons.slideshow_rounded, Color(0xFFDB2777));

  const MaterialKind(this.label, this.icon, this.colour);

  final String label;
  final IconData icon;
  final Color colour;

  static MaterialKind fromName(String? name) => MaterialKind.values.firstWhere(
        (MaterialKind k) => k.name == name || k.label == name,
        orElse: () => MaterialKind.lectureNote,
      );
}

/// A shared academic resource — maps to the `materials` table.
@immutable
class StudyMaterial {
  const StudyMaterial({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.department,
    required this.level,
    required this.fileUrl,
    required this.uploadedBy,
    required this.uploaderName,
    this.faculty = '',
    this.institution = '',
    this.description = '',
    this.kind = MaterialKind.lectureNote,
    this.fileName = '',
    this.fileSizeBytes = 0,
    this.downloads = 0,
    this.createdAt,
  });

  final String id;
  final String title;
  final String courseCode;
  final String department;
  final String faculty;
  final String institution;
  final String level;
  final String fileUrl;
  final String fileName;
  final int fileSizeBytes;
  final String uploadedBy;
  final String uploaderName;
  final String description;
  final MaterialKind kind;
  final int downloads;
  final DateTime? createdAt;

  String get extension {
    final String source = fileName.isNotEmpty ? fileName : fileUrl;
    final int dot = source.lastIndexOf('.');
    if (dot == -1 || dot == source.length - 1) return 'FILE';
    return source.substring(dot + 1).split('?').first.toUpperCase();
  }

  String get readableSize {
    if (fileSizeBytes <= 0) return '—';
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  StudyMaterial copyWith({int? downloads}) => StudyMaterial(
        id: id,
        title: title,
        courseCode: courseCode,
        department: department,
        faculty: faculty,
        institution: institution,
        level: level,
        fileUrl: fileUrl,
        fileName: fileName,
        fileSizeBytes: fileSizeBytes,
        uploadedBy: uploadedBy,
        uploaderName: uploaderName,
        description: description,
        kind: kind,
        downloads: downloads ?? this.downloads,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'course_code': courseCode,
        'department': department,
        'faculty': faculty,
        'institution': institution,
        'level': level,
        'file_url': fileUrl,
        'file_name': fileName,
        'file_size': fileSizeBytes,
        'uploaded_by': uploadedBy,
        'uploader_name': uploaderName,
        'description': description,
        'kind': kind.name,
        'downloads': downloads,
        'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
      };

  factory StudyMaterial.fromJson(Map<String, dynamic> json) => StudyMaterial(
        id: (json['id'] ?? '') as String,
        title: (json['title'] ?? '') as String,
        courseCode: (json['course_code'] ?? '') as String,
        department: (json['department'] ?? '') as String,
        faculty: (json['faculty'] ?? '') as String,
        institution: (json['institution'] ?? '') as String,
        level: (json['level'] ?? '') as String,
        fileUrl: (json['file_url'] ?? '') as String,
        fileName: (json['file_name'] ?? '') as String,
        fileSizeBytes: (json['file_size'] as num?)?.toInt() ?? 0,
        uploadedBy: (json['uploaded_by'] ?? '') as String,
        uploaderName: (json['uploader_name'] ?? 'A fellow student') as String,
        description: (json['description'] ?? '') as String,
        kind: MaterialKind.fromName(json['kind'] as String?),
        downloads: (json['downloads'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.tryParse((json['created_at'] ?? '') as String),
      );
}
