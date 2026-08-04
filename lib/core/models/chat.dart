import 'package:flutter/foundation.dart';

/// Who sent a given message.
enum MessageAuthor { student, peer, assistant }

@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.author,
    required this.body,
    required this.sentAt,
    this.senderName = '',
    this.isPending = false,
  });

  final String id;
  final String conversationId;
  final MessageAuthor author;
  final String body;
  final DateTime sentAt;
  final String senderName;
  final bool isPending;

  bool get isMine => author == MessageAuthor.student;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'conversation_id': conversationId,
        'author': author.name,
        'body': body,
        'sent_at': sentAt.toIso8601String(),
        'sender_name': senderName,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: (json['id'] ?? '') as String,
        conversationId: (json['conversation_id'] ?? '') as String,
        author: MessageAuthor.values.firstWhere(
          (MessageAuthor a) => a.name == json['author'],
          orElse: () => MessageAuthor.peer,
        ),
        body: (json['body'] ?? '') as String,
        sentAt: DateTime.tryParse((json['sent_at'] ?? '') as String) ??
            DateTime.now(),
        senderName: (json['sender_name'] ?? '') as String,
      );
}

/// A one-to-one thread or a course study group.
@immutable
class Conversation {
  const Conversation({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.lastMessage,
    required this.lastActivity,
    this.isGroup = false,
    this.isAssistant = false,
    this.unread = 0,
    this.members = 2,
  });

  final String id;
  final String title;
  final String subtitle;
  final String lastMessage;
  final DateTime lastActivity;
  final bool isGroup;
  final bool isAssistant;
  final int unread;
  final int members;

  Conversation copyWith({
    String? lastMessage,
    DateTime? lastActivity,
    int? unread,
  }) =>
      Conversation(
        id: id,
        title: title,
        subtitle: subtitle,
        lastMessage: lastMessage ?? this.lastMessage,
        lastActivity: lastActivity ?? this.lastActivity,
        isGroup: isGroup,
        isAssistant: isAssistant,
        unread: unread ?? this.unread,
        members: members,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'last_message': lastMessage,
        'last_activity': lastActivity.toIso8601String(),
        'is_group': isGroup,
        'is_assistant': isAssistant,
        'unread': unread,
        'members': members,
      };

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: (json['id'] ?? '') as String,
        title: (json['title'] ?? '') as String,
        subtitle: (json['subtitle'] ?? '') as String,
        lastMessage: (json['last_message'] ?? '') as String,
        lastActivity:
            DateTime.tryParse((json['last_activity'] ?? '') as String) ??
                DateTime.now(),
        isGroup: (json['is_group'] ?? false) as bool,
        isAssistant: (json['is_assistant'] ?? false) as bool,
        unread: (json['unread'] as num?)?.toInt() ?? 0,
        members: (json['members'] as num?)?.toInt() ?? 2,
      );
}
