import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Categories in the Eduvora noticeboard.
enum NewsCategory {
  scholarship('Scholarships', Icons.workspace_premium_rounded,
      AppColours.accent),
  admission('Admissions', Icons.how_to_reg_rounded, AppColours.primary),
  academic('Academic notices', Icons.campaign_rounded, AppColours.info),
  opportunity('Internships & jobs', Icons.work_rounded, AppColours.success),
  competition('Competitions', Icons.emoji_events_rounded, Color(0xFF7C3AED));

  const NewsCategory(this.label, this.icon, this.colour);

  final String label;
  final IconData icon;
  final Color colour;

  static NewsCategory fromName(String? name) => NewsCategory.values.firstWhere(
        (NewsCategory c) => c.name == name || c.label == name,
        orElse: () => NewsCategory.academic,
      );
}

@immutable
class NewsItem {
  const NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.source,
    required this.publishedAt,
    this.body = '',
    this.link = '',
    this.deadline,
    this.isFeatured = false,
  });

  final String id;
  final String title;
  final String summary;
  final String body;
  final NewsCategory category;
  final String source;
  final DateTime publishedAt;
  final String link;
  final DateTime? deadline;
  final bool isFeatured;

  bool get hasDeadline => deadline != null;

  int? get daysLeft {
    final DateTime? close = deadline;
    if (close == null) return null;
    return close.difference(DateTime.now()).inDays;
  }

  String get deadlineLabel {
    final int? days = daysLeft;
    if (days == null) return 'Rolling application';
    if (days < 0) return 'Closed';
    if (days == 0) return 'Closes today';
    if (days == 1) return 'Closes tomorrow';
    return 'Closes in $days days';
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'summary': summary,
        'body': body,
        'category': category.name,
        'source': source,
        'published_at': publishedAt.toIso8601String(),
        'link': link,
        'deadline': deadline?.toIso8601String(),
        'is_featured': isFeatured,
      };

  factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
        id: (json['id'] ?? '') as String,
        title: (json['title'] ?? '') as String,
        summary: (json['summary'] ?? '') as String,
        body: (json['body'] ?? '') as String,
        category: NewsCategory.fromName(json['category'] as String?),
        source: (json['source'] ?? '') as String,
        publishedAt:
            DateTime.tryParse((json['published_at'] ?? '') as String) ??
                DateTime.now(),
        link: (json['link'] ?? '') as String,
        deadline: DateTime.tryParse((json['deadline'] ?? '') as String),
        isFeatured: (json['is_featured'] ?? false) as bool,
      );
}
