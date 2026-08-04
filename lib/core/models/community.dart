import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Topic channels inside the Eduvora community.
enum CommunityTopic {
  general('General', Icons.forum_rounded, AppColours.primary),
  academics('Academics', Icons.school_rounded, AppColours.info),
  examPrep('Exam prep', Icons.quiz_rounded, AppColours.accent),
  scholarships('Scholarships', Icons.workspace_premium_rounded,
      AppColours.success),
  careers('Careers', Icons.badge_rounded, Color(0xFF7C3AED)),
  campusLife('Campus life', Icons.celebration_rounded, Color(0xFFDB2777)),
  wellbeing('Wellbeing', Icons.favorite_rounded, Color(0xFFE11D48));

  const CommunityTopic(this.label, this.icon, this.colour);

  final String label;
  final IconData icon;
  final Color colour;

  static CommunityTopic fromName(String? name) =>
      CommunityTopic.values.firstWhere(
        (CommunityTopic t) => t.name == name || t.label == name,
        orElse: () => CommunityTopic.general,
      );
}

@immutable
class CommunityPost {
  const CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.body,
    required this.topic,
    required this.createdAt,
    this.authorHeadline = '',
    this.likes = 0,
    this.commentCount = 0,
    this.institution = '',
    this.department = '',
  });

  final String id;
  final String authorId;
  final String authorName;
  final String authorHeadline;
  final String body;
  final CommunityTopic topic;
  final DateTime createdAt;
  final int likes;
  final int commentCount;
  final String institution;
  final String department;

  CommunityPost copyWith({int? likes, int? commentCount}) => CommunityPost(
        id: id,
        authorId: authorId,
        authorName: authorName,
        authorHeadline: authorHeadline,
        body: body,
        topic: topic,
        createdAt: createdAt,
        likes: likes ?? this.likes,
        commentCount: commentCount ?? this.commentCount,
        institution: institution,
        department: department,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'author_id': authorId,
        'author_name': authorName,
        'author_headline': authorHeadline,
        'body': body,
        'topic': topic.name,
        'created_at': createdAt.toIso8601String(),
        'likes': likes,
        'comment_count': commentCount,
        'institution': institution,
        'department': department,
      };

  factory CommunityPost.fromJson(Map<String, dynamic> json) => CommunityPost(
        id: (json['id'] ?? '') as String,
        authorId: (json['author_id'] ?? '') as String,
        authorName: (json['author_name'] ?? 'A student') as String,
        authorHeadline: (json['author_headline'] ?? '') as String,
        body: (json['body'] ?? '') as String,
        topic: CommunityTopic.fromName(json['topic'] as String?),
        createdAt: DateTime.tryParse((json['created_at'] ?? '') as String) ??
            DateTime.now(),
        likes: (json['likes'] as num?)?.toInt() ?? 0,
        commentCount: (json['comment_count'] as num?)?.toInt() ?? 0,
        institution: (json['institution'] ?? '') as String,
        department: (json['department'] ?? '') as String,
      );
}

@immutable
class CommunityComment {
  const CommunityComment({
    required this.id,
    required this.postId,
    required this.authorId,
    required this.authorName,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String postId;
  final String authorId;
  final String authorName;
  final String body;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'post_id': postId,
        'author_id': authorId,
        'author_name': authorName,
        'body': body,
        'created_at': createdAt.toIso8601String(),
      };

  factory CommunityComment.fromJson(Map<String, dynamic> json) =>
      CommunityComment(
        id: (json['id'] ?? '') as String,
        postId: (json['post_id'] ?? '') as String,
        authorId: (json['author_id'] ?? '') as String,
        authorName: (json['author_name'] ?? 'A student') as String,
        body: (json['body'] ?? '') as String,
        createdAt: DateTime.tryParse((json['created_at'] ?? '') as String) ??
            DateTime.now(),
      );
}
