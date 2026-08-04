import 'package:flutter/foundation.dart';

/// A recorded lecture or tutorial — maps to the `academic_videos` table.
@immutable
class AcademicVideo {
  const AcademicVideo({
    required this.id,
    required this.title,
    required this.department,
    required this.level,
    required this.videoUrl,
    this.thumbnail = '',
    this.faculty = '',
    this.courseCode = '',
    this.lecturer = '',
    this.description = '',
    this.durationLabel = '',
    this.views = 0,
    this.createdAt,
  });

  final String id;
  final String title;
  final String department;
  final String faculty;
  final String courseCode;
  final String level;
  final String videoUrl;
  final String thumbnail;
  final String lecturer;
  final String description;
  final String durationLabel;
  final int views;
  final DateTime? createdAt;

  /// Direct progressive files can play in-app; anything else opens externally.
  bool get isStreamable {
    final String lower = videoUrl.toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.m3u8') ||
        lower.endsWith('.webm') ||
        lower.endsWith('.mov');
  }

  String get viewsLabel {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M views';
    }
    if (views >= 1000) return '${(views / 1000).toStringAsFixed(1)}k views';
    return '$views views';
  }

  AcademicVideo copyWith({int? views}) => AcademicVideo(
        id: id,
        title: title,
        department: department,
        faculty: faculty,
        courseCode: courseCode,
        level: level,
        videoUrl: videoUrl,
        thumbnail: thumbnail,
        lecturer: lecturer,
        description: description,
        durationLabel: durationLabel,
        views: views ?? this.views,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'department': department,
        'faculty': faculty,
        'course_code': courseCode,
        'level': level,
        'video_url': videoUrl,
        'thumbnail': thumbnail,
        'lecturer': lecturer,
        'description': description,
        'duration': durationLabel,
        'views': views,
        'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
      };

  factory AcademicVideo.fromJson(Map<String, dynamic> json) => AcademicVideo(
        id: (json['id'] ?? '') as String,
        title: (json['title'] ?? '') as String,
        department: (json['department'] ?? '') as String,
        faculty: (json['faculty'] ?? '') as String,
        courseCode: (json['course_code'] ?? '') as String,
        level: (json['level'] ?? '') as String,
        videoUrl: (json['video_url'] ?? '') as String,
        thumbnail: (json['thumbnail'] ?? '') as String,
        lecturer: (json['lecturer'] ?? '') as String,
        description: (json['description'] ?? '') as String,
        durationLabel: (json['duration'] ?? '') as String,
        views: (json['views'] as num?)?.toInt() ?? 0,
        createdAt: DateTime.tryParse((json['created_at'] ?? '') as String),
      );
}
