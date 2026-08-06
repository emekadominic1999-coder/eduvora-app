import 'dart:math';

import 'package:flutter/foundation.dart';

/// A student-created study group, joined by a short code.
///
/// Groups are the retention backbone of Eduvora: a student comes back for
/// their coursemates far more reliably than for content. A group is therefore
/// deliberately cheap to create and to join — one screen and a six-character
/// code passed round a class WhatsApp or written on a board.
@immutable
class StudyGroup {
  const StudyGroup({
    required this.id,
    required this.name,
    required this.joinCode,
    this.description = '',
    this.institution = '',
    this.faculty = '',
    this.department = '',
    this.level = '',
    this.courseCode = '',
    this.createdBy = '',
    this.creatorName = '',
    this.classListId,
    this.memberCount = 0,
    this.lastMessage = '',
    this.lastActivity,
    this.createdAt,
  });

  final String id;
  final String name;

  /// Short, shareable code. Deliberately unambiguous — no O/0 or I/1.
  final String joinCode;
  final String description;
  final String institution;
  final String faculty;
  final String department;
  final String level;
  final String courseCode;
  final String createdBy;
  final String creatorName;

  /// Set when this group was created alongside a class list.
  final String? classListId;

  final int memberCount;
  final String lastMessage;
  final DateTime? lastActivity;
  final DateTime? createdAt;

  bool get isFromClassList => classListId != null && classListId!.isNotEmpty;

  String get subtitle {
    final List<String> parts = <String>[
      if (courseCode.isNotEmpty) courseCode,
      if (department.isNotEmpty) department,
      if (level.isNotEmpty) level,
    ];
    return parts.isEmpty ? 'Study group' : parts.join(' · ');
  }

  /// Characters chosen so a code read aloud or copied off a whiteboard cannot
  /// be misheard: no O versus 0, no I versus 1.
  static const String _codeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static String generateJoinCode([Random? rng]) {
    final Random random = rng ?? Random.secure();
    return List<String>.generate(
      6,
      (_) => _codeAlphabet[random.nextInt(_codeAlphabet.length)],
    ).join();
  }

  StudyGroup copyWith({
    String? name,
    String? description,
    int? memberCount,
    String? lastMessage,
    DateTime? lastActivity,
  }) => StudyGroup(
    id: id,
    name: name ?? this.name,
    joinCode: joinCode,
    description: description ?? this.description,
    institution: institution,
    faculty: faculty,
    department: department,
    level: level,
    courseCode: courseCode,
    createdBy: createdBy,
    creatorName: creatorName,
    classListId: classListId,
    memberCount: memberCount ?? this.memberCount,
    lastMessage: lastMessage ?? this.lastMessage,
    lastActivity: lastActivity ?? this.lastActivity,
    createdAt: createdAt,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'join_code': joinCode,
    'description': description,
    'institution': institution,
    'faculty': faculty,
    'department': department,
    'level': level,
    'course_code': courseCode,
    'created_by': createdBy.isEmpty ? null : createdBy,
    'creator_name': creatorName,
    'class_list_id': classListId,
    'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
  };

  factory StudyGroup.fromJson(Map<String, dynamic> json) => StudyGroup(
    id: (json['id'] ?? '') as String,
    name: (json['name'] ?? '') as String,
    joinCode: (json['join_code'] ?? '') as String,
    description: (json['description'] ?? '') as String,
    institution: (json['institution'] ?? '') as String,
    faculty: (json['faculty'] ?? '') as String,
    department: (json['department'] ?? '') as String,
    level: (json['level'] ?? '') as String,
    courseCode: (json['course_code'] ?? '') as String,
    createdBy: (json['created_by'] ?? '') as String,
    creatorName: (json['creator_name'] ?? '') as String,
    classListId: json['class_list_id'] as String?,
    memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
    lastMessage: (json['last_message'] ?? '') as String,
    lastActivity: DateTime.tryParse((json['last_activity'] ?? '') as String),
    createdAt: DateTime.tryParse((json['created_at'] ?? '') as String),
  );
}

/// Somebody who has joined a group.
@immutable
class GroupMember {
  const GroupMember({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.fullName,
    this.headline = '',
    this.isAdmin = false,
    this.joinedAt,
  });

  final String id;
  final String groupId;
  final String userId;
  final String fullName;
  final String headline;
  final bool isAdmin;
  final DateTime? joinedAt;

  /// Used wherever a full name would be too formal — "Remove Chidera?" reads
  /// better than "Remove Chidera Okoye?".
  String get firstName {
    final String trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'this student';
    return trimmed.split(RegExp(r'\s+')).first;
  }

  String get initials {
    final List<String> parts = fullName
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'S';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'group_id': groupId,
    'user_id': userId,
    'full_name': fullName,
    'headline': headline,
    'is_admin': isAdmin,
    'joined_at': (joinedAt ?? DateTime.now()).toIso8601String(),
  };

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
    id: (json['id'] ?? '') as String,
    groupId: (json['group_id'] ?? '') as String,
    userId: (json['user_id'] ?? '') as String,
    fullName: (json['full_name'] ?? '') as String,
    headline: (json['headline'] ?? '') as String,
    isAdmin: (json['is_admin'] ?? false) as bool,
    joinedAt: DateTime.tryParse((json['joined_at'] ?? '') as String),
  );
}

/// What kind of file is attached to a message, so the bubble knows whether to
/// draw a picture inline or a document card.
enum GroupAttachmentType {
  image,
  file;

  static GroupAttachmentType? fromName(String? name) {
    if (name == null || name.isEmpty) return null;
    return GroupAttachmentType.values.firstWhere(
      (GroupAttachmentType t) => t.name == name,
      orElse: () => GroupAttachmentType.file,
    );
  }
}

/// A message posted in a group.
@immutable
class GroupMessage {
  const GroupMessage({
    required this.id,
    required this.groupId,
    required this.authorId,
    required this.authorName,
    required this.body,
    required this.sentAt,
    this.isQuestion = false,
    this.replyToId,
    this.replyToAuthor = '',
    this.replyToBody = '',
    this.deletedAt,
    this.attachmentUrl = '',
    this.attachmentName = '',
    this.attachmentType,
    this.attachmentSize = 0,
    this.reactions = const <GroupMessageReaction>[],
  });

  final String id;
  final String groupId;
  final String authorId;
  final String authorName;
  final String body;
  final DateTime sentAt;

  /// Marked by the sender so the group can filter down to questions only.
  final bool isQuestion;

  /// The message being replied to. The author and body are copied rather than
  /// looked up, so a quoted reply still reads correctly once the original has
  /// been deleted.
  final String? replyToId;
  final String replyToAuthor;
  final String replyToBody;

  /// Deleted messages keep their place in the thread with the body blanked,
  /// so a reply above them does not become nonsense.
  final DateTime? deletedAt;

  /// A photo or document shared alongside — or instead of — text.
  final String attachmentUrl;
  final String attachmentName;
  final GroupAttachmentType? attachmentType;
  final int attachmentSize;

  /// Populated separately from the reactions table and merged in, since a
  /// reaction is its own row rather than a column on the message.
  final List<GroupMessageReaction> reactions;

  bool get isDeleted => deletedAt != null;
  bool get isReply => replyToId != null && replyToId!.isNotEmpty;
  bool get hasAttachment => attachmentUrl.isNotEmpty;
  bool get isImageAttachment => attachmentType == GroupAttachmentType.image;

  /// What to actually draw in the bubble.
  String get displayBody =>
      isDeleted ? 'This message was deleted' : body;

  /// Emoji grouped with how many members picked each one, most popular first.
  List<MapEntry<String, List<GroupMessageReaction>>> get reactionGroups {
    final Map<String, List<GroupMessageReaction>> byEmoji =
        <String, List<GroupMessageReaction>>{};
    for (final GroupMessageReaction r in reactions) {
      byEmoji.putIfAbsent(r.emoji, () => <GroupMessageReaction>[]).add(r);
    }
    final List<MapEntry<String, List<GroupMessageReaction>>> groups = byEmoji
        .entries
        .toList()
      ..sort((MapEntry<String, List<GroupMessageReaction>> a,
              MapEntry<String, List<GroupMessageReaction>> b) =>
          b.value.length.compareTo(a.value.length));
    return groups;
  }

  /// The emoji this student has already picked, if any — a fresh tap on the
  /// same one removes it rather than adding a second.
  String? myReaction(String userId) {
    for (final GroupMessageReaction r in reactions) {
      if (r.userId == userId) return r.emoji;
    }
    return null;
  }

  GroupMessage copyWith({
    String? body,
    DateTime? deletedAt,
    List<GroupMessageReaction>? reactions,
  }) => GroupMessage(
    id: id,
    groupId: groupId,
    authorId: authorId,
    authorName: authorName,
    body: body ?? this.body,
    sentAt: sentAt,
    isQuestion: isQuestion,
    replyToId: replyToId,
    replyToAuthor: replyToAuthor,
    replyToBody: replyToBody,
    deletedAt: deletedAt ?? this.deletedAt,
    attachmentUrl: attachmentUrl,
    attachmentName: attachmentName,
    attachmentType: attachmentType,
    attachmentSize: attachmentSize,
    reactions: reactions ?? this.reactions,
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'group_id': groupId,
    'author_id': authorId.isEmpty ? null : authorId,
    'author_name': authorName,
    'body': body,
    'is_question': isQuestion,
    'reply_to_id': replyToId,
    'reply_to_author': replyToAuthor,
    'reply_to_body': replyToBody,
    'deleted_at': deletedAt?.toIso8601String(),
    'attachment_url': attachmentUrl,
    'attachment_name': attachmentName,
    'attachment_type': attachmentType?.name,
    'attachment_size': attachmentSize,
    'sent_at': sentAt.toIso8601String(),
  };

  factory GroupMessage.fromJson(Map<String, dynamic> json) => GroupMessage(
    id: (json['id'] ?? '') as String,
    groupId: (json['group_id'] ?? '') as String,
    authorId: (json['author_id'] ?? '') as String,
    authorName: (json['author_name'] ?? '') as String,
    body: (json['body'] ?? '') as String,
    isQuestion: (json['is_question'] ?? false) as bool,
    replyToId: json['reply_to_id'] as String?,
    replyToAuthor: (json['reply_to_author'] ?? '') as String,
    replyToBody: (json['reply_to_body'] ?? '') as String,
    deletedAt: DateTime.tryParse((json['deleted_at'] ?? '') as String),
    attachmentUrl: (json['attachment_url'] ?? '') as String,
    attachmentName: (json['attachment_name'] ?? '') as String,
    attachmentType: GroupAttachmentType.fromName(
      json['attachment_type'] as String?,
    ),
    attachmentSize: (json['attachment_size'] as num?)?.toInt() ?? 0,
    sentAt:
        DateTime.tryParse((json['sent_at'] ?? '') as String) ?? DateTime.now(),
  );
}

/// One member's emoji reaction to a message. Whoever sent the message is not
/// asked to guess who felt what — this is deliberately visible, the way a
/// classroom raising hands is visible, not an anonymous poll.
@immutable
class GroupMessageReaction {
  const GroupMessageReaction({
    required this.id,
    required this.messageId,
    required this.userId,
    required this.userName,
    required this.emoji,
    this.createdAt,
  });

  final String id;
  final String messageId;
  final String userId;
  final String userName;
  final String emoji;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'message_id': messageId,
    'user_id': userId,
    'user_name': userName,
    'emoji': emoji,
    'created_at': (createdAt ?? DateTime.now()).toIso8601String(),
  };

  factory GroupMessageReaction.fromJson(Map<String, dynamic> json) =>
      GroupMessageReaction(
        id: (json['id'] ?? '') as String,
        messageId: (json['message_id'] ?? '') as String,
        userId: (json['user_id'] ?? '') as String,
        userName: (json['user_name'] ?? '') as String,
        emoji: (json['emoji'] ?? '') as String,
        createdAt: DateTime.tryParse((json['created_at'] ?? '') as String),
      );
}
