import 'package:uuid/uuid.dart';

import '../models/chat.dart';
import '../models/student_profile.dart';
import 'local_store.dart';

/// Conversations, messages and the pinned assistant thread.
///
/// Threads are seeded from the student's own department and level so the app
/// feels populated from the first launch, then persisted locally as the
/// student takes part.
class ChatRepository {
  const ChatRepository();

  static const Uuid _uuid = Uuid();
  static const String assistantThreadId = 'ada-assistant';

  List<Conversation> conversations(StudentProfile profile) {
    final List<Conversation> stored = LocalStore.instance
        .readList(StoreKeys.conversations)
        .map(Conversation.fromJson)
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

  List<Conversation> _seedConversations(StudentProfile profile) {
    final DateTime now = DateTime.now();
    final String department =
        profile.department.isNotEmpty ? profile.department : 'Your department';
    final String level = profile.level.isNotEmpty ? profile.level : 'Your level';

    return <Conversation>[
      Conversation(
        id: assistantThreadId,
        title: 'Ada · Eduvora Assistant',
        subtitle: 'Always here to help you find your way',
        lastMessage:
            'Hello — I am Ada. Ask me anything about Eduvora, or just say hello.',
        lastActivity: now,
        isAssistant: true,
      ),
      Conversation(
        id: 'group-department',
        title: '$department · $level',
        subtitle: 'Course study group',
        lastMessage:
            'Has anyone got the tutorial questions from last week’s class?',
        lastActivity: now.subtract(const Duration(minutes: 24)),
        isGroup: true,
        unread: 3,
        members: 148,
      ),
      Conversation(
        id: 'group-exam-prep',
        title: 'Exam Prep Circle',
        subtitle: 'Revision partners across your faculty',
        lastMessage: 'Meeting at 6pm as usual. Bring your past questions.',
        lastActivity: now.subtract(const Duration(hours: 2)),
        isGroup: true,
        unread: 1,
        members: 62,
      ),
      Conversation(
        id: 'peer-adaeze',
        title: 'Adaeze Nwankwo',
        subtitle: 'Course representative',
        lastMessage: 'I have uploaded the handout to the materials library.',
        lastActivity: now.subtract(const Duration(hours: 5)),
      ),
      Conversation(
        id: 'peer-ibrahim',
        title: 'Ibrahim Suleiman',
        subtitle: 'Study partner',
        lastMessage: 'Thanks for the notes — they were very clear.',
        lastActivity: now.subtract(const Duration(days: 1, hours: 3)),
      ),
    ];
  }

  List<ChatMessage> messages(String conversationId) {
    final List<ChatMessage> stored = LocalStore.instance
        .readList('${StoreKeys.messages}.$conversationId')
        .map(ChatMessage.fromJson)
        .toList();
    if (stored.isNotEmpty) return stored;
    return _seedMessages(conversationId);
  }

  List<ChatMessage> _seedMessages(String conversationId) {
    final DateTime now = DateTime.now();

    List<List<Object>> raw;
    switch (conversationId) {
      case 'group-department':
        raw = <List<Object>>[
          <Object>[
            MessageAuthor.peer,
            'Chinedu',
            'Has anyone got the tutorial questions from last week’s class?',
            180,
          ],
          <Object>[
            MessageAuthor.peer,
            'Aisha',
            'Yes — I have uploaded them to the materials library under the '
                'course code.',
            140,
          ],
          <Object>[
            MessageAuthor.peer,
            'Tobi',
            'Found them, thank you. Question 4 is the tricky one.',
            96,
          ],
          <Object>[
            MessageAuthor.peer,
            'Aisha',
            'Work it from the free-body diagram first, then substitute. It '
                'falls out neatly.',
            24,
          ],
        ];
      case 'group-exam-prep':
        raw = <List<Object>>[
          <Object>[
            MessageAuthor.peer,
            'Grace',
            'Meeting at 6pm as usual. Bring your past questions.',
            120,
          ],
          <Object>[
            MessageAuthor.peer,
            'Samuel',
            'I will be there. Shall we start with the 2022 paper?',
            110,
          ],
        ];
      case 'peer-adaeze':
        raw = <List<Object>>[
          <Object>[
            MessageAuthor.peer,
            'Adaeze',
            'Good afternoon — did you get the departmental announcement?',
            420,
          ],
          <Object>[
            MessageAuthor.student,
            'You',
            'Not yet. What was it about?',
            400,
          ],
          <Object>[
            MessageAuthor.peer,
            'Adaeze',
            'I have uploaded the handout to the materials library.',
            300,
          ],
        ];
      case 'peer-ibrahim':
        raw = <List<Object>>[
          <Object>[
            MessageAuthor.peer,
            'Ibrahim',
            'Thanks for the notes — they were very clear.',
            1620,
          ],
        ];
      default:
        raw = <List<Object>>[];
    }

    return List<ChatMessage>.generate(raw.length, (int i) {
      return ChatMessage(
        id: '$conversationId-seed-$i',
        conversationId: conversationId,
        author: raw[i][0] as MessageAuthor,
        senderName: raw[i][1] as String,
        body: raw[i][2] as String,
        sentAt: now.subtract(Duration(minutes: raw[i][3] as int)),
      );
    });
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
    final List<Map<String, dynamic>> stored =
        LocalStore.instance.readList(StoreKeys.conversations);
    final int index =
        stored.indexWhere((Map<String, dynamic> c) => c['id'] == id);

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
    final List<Map<String, dynamic>> stored =
        LocalStore.instance.readList(StoreKeys.conversations);
    final int index = stored
        .indexWhere((Map<String, dynamic> c) => c['id'] == conversationId);
    if (index >= 0) {
      stored[index]['unread'] = 0;
      await LocalStore.instance.writeList(StoreKeys.conversations, stored);
    }
  }

  int unreadTotal(StudentProfile profile) => conversations(profile)
      .fold(0, (int sum, Conversation c) => sum + c.unread);
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final Iterator<T> it = iterator;
    return it.moveNext() ? it.current : null;
  }
}
