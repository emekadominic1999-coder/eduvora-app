import 'package:uuid/uuid.dart';

import '../models/chat.dart';
import '../models/student_profile.dart';
import 'local_store.dart';

/// Conversations, messages and the pinned assistant thread.
///
/// Only the Ada assistant thread is built in; every other conversation is one
/// the student has genuinely taken part in.
class ChatRepository {
  const ChatRepository();

  static const Uuid _uuid = Uuid();
  static const String assistantThreadId = 'ada-assistant';

  List<Conversation> conversations(StudentProfile profile) {
    final List<Conversation> stored = LocalStore.instance
        .readList(StoreKeys.conversations)
        .map(Conversation.fromJson)
        .where((Conversation c) => !_retiredDemoThreads.contains(c.id))
        .toList();

    final Map<String, Conversation> byId = <String, Conversation>{};
    for (final Conversation c in <Conversation>[
      ..._seedConversations(profile),
      ...stored,
    ]) {
      byId[c.id] = c;
    }

    final List<Conversation> all = byId.values.toList()
      ..sort((Conversation a, Conversation b) {
        if (a.isAssistant != b.isAssistant) return a.isAssistant ? -1 : 1;
        return b.lastActivity.compareTo(a.lastActivity);
      });
    return all;
  }

  /// The only built-in thread is Ada, the Eduvora assistant. Everything else
  /// a student sees in Chats is real: their own conversations.
  List<Conversation> _seedConversations(StudentProfile profile) {
    return <Conversation>[
      Conversation(
        id: assistantThreadId,
        title: 'Ada · Eduvora Assistant',
        subtitle: 'Always here to help you find your way',
        lastMessage:
            'Hello — I am Ada. Ask me anything about Eduvora, or just say hello.',
        lastActivity: DateTime.now(),
        isAssistant: true,
      ),
    ];
  }

  /// Ids of the sample chats an earlier version pre-loaded. They may still be
  /// saved on a device, so they are ignored wherever they turn up.
  static const Set<String> _retiredDemoThreads = <String>{
    'group-department',
    'group-exam-prep',
    'peer-adaeze',
    'peer-ibrahim',
  };

  List<ChatMessage> messages(String conversationId) {
    if (_retiredDemoThreads.contains(conversationId)) return <ChatMessage>[];
    return LocalStore.instance
        .readList('${StoreKeys.messages}.$conversationId')
        .map(ChatMessage.fromJson)
        .toList();
  }

  Future<ChatMessage> send({
    required String conversationId,
    required String body,
    required MessageAuthor author,
    String senderName = '',
  }) async {
    final ChatMessage message = ChatMessage(
      id: _uuid.v4(),
      conversationId: conversationId,
      author: author,
      body: body.trim(),
      sentAt: DateTime.now(),
      senderName: senderName,
    );

    final List<ChatMessage> existing = messages(conversationId)..add(message);
    await LocalStore.instance.writeList(
      '${StoreKeys.messages}.$conversationId',
      existing.map((ChatMessage m) => m.toJson()).toList(),
    );

    await _touchConversation(conversationId, message.body);
    return message;
  }

  Future<void> _touchConversation(String id, String preview) async {
    final List<Map<String, dynamic>> stored = LocalStore.instance.readList(
      StoreKeys.conversations,
    );
    final int index = stored.indexWhere(
      (Map<String, dynamic> c) => c['id'] == id,
    );

    if (index >= 0) {
      stored[index]['last_message'] = preview;
      stored[index]['last_activity'] = DateTime.now().toIso8601String();
      stored[index]['unread'] = 0;
    } else {
      // Persist the seeded thread the first time it is used.
      final Conversation? seed = _seedConversations(
        const StudentProfile(id: '', fullName: '', email: ''),
      ).where((Conversation c) => c.id == id).firstOrNull;
      if (seed != null) {
        stored.add(
          seed
              .copyWith(
                lastMessage: preview,
                lastActivity: DateTime.now(),
                unread: 0,
              )
              .toJson(),
        );
      }
    }
    await LocalStore.instance.writeList(StoreKeys.conversations, stored);
  }

  Future<void> markRead(String conversationId) async {
    final List<Map<String, dynamic>> stored = LocalStore.instance.readList(
      StoreKeys.conversations,
    );
    final int index = stored.indexWhere(
      (Map<String, dynamic> c) => c['id'] == conversationId,
    );
    if (index >= 0) {
      stored[index]['unread'] = 0;
      await LocalStore.instance.writeList(StoreKeys.conversations, stored);
    }
  }

  int unreadTotal(StudentProfile profile) => conversations(
    profile,
  ).fold(0, (int sum, Conversation c) => sum + c.unread);
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final Iterator<T> it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
