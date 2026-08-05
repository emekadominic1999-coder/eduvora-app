import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../models/class_list.dart';
import '../models/student_profile.dart';
import '../models/study_group.dart';
import 'local_store.dart';
import 'supabase_service.dart';

/// Raised when a group action fails in a way worth telling the student about.
class GroupFailure implements Exception {
  const GroupFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Study groups, their members and messages, plus class lists.
///
/// Everything is written locally as well as remotely, so a group created on a
/// weak campus network still appears immediately and syncs when it can.
class GroupRepository {
  const GroupRepository();

  static const Uuid _uuid = Uuid();

  // ------------------------------------------------------------------ groups

  /// Groups this student belongs to.
  Future<List<StudyGroup>> myGroups(StudentProfile profile) async {
    if (!SupabaseService.isReady) return _localGroupsFor(profile.id);

    try {
      final List<dynamic> memberships = await SupabaseService.client
          .from('chat_group_members')
          .select('group_id')
          .eq('user_id', profile.id);

      final List<String> ids = memberships
          .whereType<Map<String, dynamic>>()
          .map((Map<String, dynamic> m) => (m['group_id'] ?? '') as String)
          .where((String id) => id.isNotEmpty)
          .toList();

      if (ids.isEmpty) return <StudyGroup>[];

      final List<dynamic> rows = await SupabaseService.client
          .from('chat_groups')
          .select()
          .inFilter('id', ids)
          .order('created_at', ascending: false);

      final List<StudyGroup> groups = rows
          .whereType<Map<String, dynamic>>()
          .map(StudyGroup.fromJson)
          .toList();

      // Member counts are fetched per group rather than joined, which keeps
      // the query simple at the cost of a few extra round trips.
      return Future.wait(groups.map(_withMemberCount));
    } catch (error) {
      debugPrint('[Eduvora] group fetch failed: $error');
      return _localGroupsFor(profile.id);
    }
  }

  Future<StudyGroup> _withMemberCount(StudyGroup group) async {
    try {
      final List<dynamic> members = await SupabaseService.client
          .from('chat_group_members')
          .select('id')
          .eq('group_id', group.id);
      return group.copyWith(memberCount: members.length);
    } catch (_) {
      return group;
    }
  }

  Future<StudyGroup> createGroup({
    required StudentProfile profile,
    required String name,
    String description = '',
    String courseCode = '',
    String? classListId,
  }) async {
    final StudyGroup group = StudyGroup(
      id: _uuid.v4(),
      name: name.trim(),
      joinCode: StudyGroup.generateJoinCode(),
      description: description.trim(),
      institution: profile.institutionName,
      faculty: profile.faculty,
      department: profile.department,
      level: profile.level,
      courseCode: courseCode.trim().toUpperCase(),
      createdBy: profile.id,
      creatorName: profile.fullName,
      classListId: classListId,
      memberCount: 1,
      createdAt: DateTime.now(),
    );

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client.from('chat_groups').insert(group.toJson());
        // The creator is the first member, and its admin.
        await SupabaseService.client.from('chat_group_members').insert(
          GroupMember(
            id: _uuid.v4(),
            groupId: group.id,
            userId: profile.id,
            fullName: profile.fullName,
            headline: profile.academicSummary,
            isAdmin: true,
            joinedAt: DateTime.now(),
          ).toJson(),
        );
      } catch (error) {
        debugPrint('[Eduvora] group create failed: $error');
        throw const GroupFailure(
          'We could not create the group just now. Please check your '
          'connection and try again.',
        );
      }
    }

    await _cacheGroup(group, profile.id);
    return group;
  }

  /// Joins by code. Returns the group so the caller can open it.
  Future<StudyGroup> joinByCode({
    required StudentProfile profile,
    required String code,
  }) async {
    final String clean = code.trim().toUpperCase();
    if (clean.isEmpty) {
      throw const GroupFailure('Please enter the group code.');
    }

    if (!SupabaseService.isReady) {
      throw const GroupFailure(
        'Joining a group needs a connection, so the group can be found. '
        'Please try again once you are online.',
      );
    }

    try {
      final Map<String, dynamic>? row = await SupabaseService.client
          .from('chat_groups')
          .select()
          .eq('join_code', clean)
          .maybeSingle();

      if (row == null) {
        throw const GroupFailure(
          'No group has that code. Do check it with whoever shared it — the '
          'code is six characters, with no letter O or I in it.',
        );
      }

      final StudyGroup group = StudyGroup.fromJson(row);

      // Already a member? Just hand the group back rather than erroring.
      final List<dynamic> existing = await SupabaseService.client
          .from('chat_group_members')
          .select('id')
          .eq('group_id', group.id)
          .eq('user_id', profile.id);

      if (existing.isEmpty) {
        await SupabaseService.client.from('chat_group_members').insert(
          GroupMember(
            id: _uuid.v4(),
            groupId: group.id,
            userId: profile.id,
            fullName: profile.fullName,
            headline: profile.academicSummary,
            joinedAt: DateTime.now(),
          ).toJson(),
        );
      }

      await _cacheGroup(group, profile.id);
      return group;
    } on GroupFailure {
      rethrow;
    } catch (error) {
      debugPrint('[Eduvora] join failed: $error');
      throw const GroupFailure(
        'We could not join that group just now. Please try again.',
      );
    }
  }

  Future<void> leaveGroup({
    required StudentProfile profile,
    required String groupId,
  }) async {
    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('chat_group_members')
            .delete()
            .eq('group_id', groupId)
            .eq('user_id', profile.id);
      } catch (error) {
        debugPrint('[Eduvora] leave failed: $error');
      }
    }
    await _uncacheGroup(groupId, profile.id);
  }

  Future<List<GroupMember>> members(String groupId) async {
    if (!SupabaseService.isReady) return <GroupMember>[];
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('chat_group_members')
          .select()
          .eq('group_id', groupId)
          .order('joined_at');
      return rows
          .whereType<Map<String, dynamic>>()
          .map(GroupMember.fromJson)
          .toList();
    } catch (error) {
      debugPrint('[Eduvora] member fetch failed: $error');
      return <GroupMember>[];
    }
  }

  // ---------------------------------------------------------------- messages

  Future<List<GroupMessage>> messages(String groupId) async {
    final List<GroupMessage> local = LocalStore.instance
        .readList('${StoreKeys.groupMessages}.$groupId')
        .map(GroupMessage.fromJson)
        .toList();

    if (!SupabaseService.isReady) return local;

    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('chat_group_messages')
          .select()
          .eq('group_id', groupId)
          .order('sent_at')
          .limit(300);

      final List<GroupMessage> remote = rows
          .whereType<Map<String, dynamic>>()
          .map(GroupMessage.fromJson)
          .toList();

      final Map<String, GroupMessage> byId = <String, GroupMessage>{};
      for (final GroupMessage m in <GroupMessage>[...remote, ...local]) {
        byId[m.id] = m;
      }
      final List<GroupMessage> merged = byId.values.toList()
        ..sort((GroupMessage a, GroupMessage b) => a.sentAt.compareTo(b.sentAt));
      return merged;
    } catch (error) {
      debugPrint('[Eduvora] group messages failed: $error');
      return local;
    }
  }

  /// Live messages for a group.
  ///
  /// Without this a message only arrives when somebody pulls to refresh,
  /// which is the difference between a message board and a chat. The stream
  /// carries inserts and updates — a deletion is an update, since deleting
  /// blanks the body rather than removing the row.
  Stream<GroupMessage> watchMessages(String groupId) {
    if (!SupabaseService.isReady) return const Stream<GroupMessage>.empty();

    final StreamController<GroupMessage> controller =
        StreamController<GroupMessage>.broadcast();

    final RealtimeChannel channel = SupabaseService.client
        .channel('group:$groupId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'chat_group_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'group_id',
            value: groupId,
          ),
          callback: (PostgresChangePayload payload) {
            if (payload.newRecord.isEmpty) return;
            try {
              controller.add(GroupMessage.fromJson(payload.newRecord));
            } catch (error) {
              debugPrint('[Eduvora] realtime decode failed: $error');
            }
          },
        );

    channel.subscribe();
    controller.onCancel = () => SupabaseService.client.removeChannel(channel);
    return controller.stream;
  }

  Future<GroupMessage> sendMessage({
    required StudentProfile profile,
    required String groupId,
    required String body,
    bool isQuestion = false,
    GroupMessage? replyTo,
  }) async {
    final GroupMessage message = GroupMessage(
      id: _uuid.v4(),
      groupId: groupId,
      authorId: profile.id,
      authorName: profile.fullName,
      body: body.trim(),
      isQuestion: isQuestion,
      replyToId: replyTo?.id,
      replyToAuthor: replyTo?.authorName ?? '',
      // Quoted text is trimmed here rather than in the bubble, so a very long
      // original does not bloat every reply row in the database.
      replyToBody: _shortQuote(replyTo?.displayBody ?? ''),
      sentAt: DateTime.now(),
    );

    // Cache first: the message should appear in the thread instantly even if
    // the network is slow, which is how a chat is expected to feel.
    await _cacheMessage(message);

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('chat_group_messages')
            .insert(message.toJson());
      } catch (error) {
        debugPrint('[Eduvora] group send failed: $error');
        throw const GroupFailure(
          'That message stayed on your phone — we could not reach the group '
          'just now. Check your connection and send it again.',
        );
      }
    }

    return message;
  }

  /// Blanks a message. Authors may clear their own; admins may clear anyone's.
  Future<GroupMessage> deleteMessage({
    required GroupMessage message,
  }) async {
    final GroupMessage cleared = message.copyWith(
      body: '',
      deletedAt: DateTime.now(),
    );

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('chat_group_messages')
            .update(<String, dynamic>{
              'body': '',
              'deleted_at': cleared.deletedAt!.toIso8601String(),
            })
            .eq('id', message.id);
      } catch (error) {
        debugPrint('[Eduvora] message delete failed: $error');
        throw const GroupFailure(
          'We could not delete that message just now. Please try again.',
        );
      }
    }

    await _replaceCachedMessage(cleared);
    return cleared;
  }

  static String _shortQuote(String body) =>
      body.length <= 160 ? body : '${body.substring(0, 158)}…';

  Future<void> _cacheMessage(GroupMessage message) async {
    final List<Map<String, dynamic>> cached = LocalStore.instance.readList(
      '${StoreKeys.groupMessages}.${message.groupId}',
    )..add(message.toJson());
    await LocalStore.instance.writeList(
      '${StoreKeys.groupMessages}.${message.groupId}',
      cached.length > 300 ? cached.sublist(cached.length - 300) : cached,
    );
  }

  Future<void> _replaceCachedMessage(GroupMessage message) async {
    final List<Map<String, dynamic>> cached = LocalStore.instance
        .readList('${StoreKeys.groupMessages}.${message.groupId}')
        .map(
          (Map<String, dynamic> row) =>
              row['id'] == message.id ? message.toJson() : row,
        )
        .toList();
    await LocalStore.instance.writeList(
      '${StoreKeys.groupMessages}.${message.groupId}',
      cached,
    );
  }

  // ------------------------------------------------------------------ admins

  /// Promotes or dismisses an admin. The person who created the group keeps
  /// their rights permanently — the database enforces this too, so a group
  /// cannot be taken from its founder by an admin they appointed.
  Future<void> setAdmin({
    required StudyGroup group,
    required GroupMember member,
    required bool isAdmin,
  }) async {
    if (member.userId == group.createdBy) {
      throw const GroupFailure(
        'The student who created this group always stays an admin.',
      );
    }
    if (!SupabaseService.isReady) {
      throw const GroupFailure(
        'Admins can only be changed once the group is online.',
      );
    }

    try {
      await SupabaseService.client
          .from('chat_group_members')
          .update(<String, dynamic>{'is_admin': isAdmin})
          .eq('id', member.id);
    } catch (error) {
      debugPrint('[Eduvora] admin change failed: $error');
      throw GroupFailure(
        isAdmin
            ? 'We could not make ${member.fullName} an admin just now.'
            : 'We could not dismiss ${member.fullName} as an admin just now.',
      );
    }
  }

  /// Removes somebody from a group. Admins only, and never the founder.
  Future<void> removeMember({
    required StudyGroup group,
    required GroupMember member,
  }) async {
    if (member.userId == group.createdBy) {
      throw const GroupFailure(
        'The student who created this group cannot be removed from it.',
      );
    }
    if (!SupabaseService.isReady) {
      throw const GroupFailure(
        'Members can only be removed once the group is online.',
      );
    }

    try {
      await SupabaseService.client
          .from('chat_group_members')
          .delete()
          .eq('id', member.id);
    } catch (error) {
      debugPrint('[Eduvora] member removal failed: $error');
      throw GroupFailure(
        'We could not remove ${member.fullName} just now. Please try again.',
      );
    }
  }

  /// Renames a group or changes its description. Admins only.
  Future<StudyGroup> updateGroup({
    required StudyGroup group,
    String? name,
    String? description,
  }) async {
    final StudyGroup updated = group.copyWith(
      name: name?.trim(),
      description: description?.trim(),
    );

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('chat_groups')
            .update(<String, dynamic>{
              if (name != null) 'name': updated.name,
              if (description != null) 'description': updated.description,
            })
            .eq('id', group.id);
      } catch (error) {
        debugPrint('[Eduvora] group update failed: $error');
        throw const GroupFailure(
          'We could not save that change just now. Please try again.',
        );
      }
    }

    return updated;
  }

  // ------------------------------------------------------------ class lists

  Future<List<ClassList>> myClassLists(StudentProfile profile) async {
    if (!SupabaseService.isReady) {
      return LocalStore.instance
          .readList(StoreKeys.classLists)
          .map(ClassList.fromJson)
          .toList();
    }
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('class_lists')
          .select()
          .eq('owner_id', profile.id)
          .order('created_at', ascending: false);
      final List<ClassList> lists = rows
          .whereType<Map<String, dynamic>>()
          .map(ClassList.fromJson)
          .toList();
      return Future.wait(lists.map(_withEntryCount));
    } catch (error) {
      debugPrint('[Eduvora] class list fetch failed: $error');
      return LocalStore.instance
          .readList(StoreKeys.classLists)
          .map(ClassList.fromJson)
          .toList();
    }
  }

  Future<ClassList> _withEntryCount(ClassList list) async {
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('class_list_entries')
          .select('id')
          .eq('class_list_id', list.id);
      return ClassList(
        id: list.id,
        name: list.name,
        institution: list.institution,
        faculty: list.faculty,
        department: list.department,
        level: list.level,
        session: list.session,
        ownerId: list.ownerId,
        ownerName: list.ownerName,
        groupId: list.groupId,
        entryCount: rows.length,
        createdAt: list.createdAt,
      );
    } catch (_) {
      return list;
    }
  }

  /// Creates a class list and, alongside it, the group for that class.
  Future<ClassList> createClassList({
    required StudentProfile profile,
    required String name,
    String session = '',
    bool withGroup = true,
  }) async {
    final String listId = _uuid.v4();

    StudyGroup? group;
    if (withGroup) {
      group = await createGroup(
        profile: profile,
        name: name.trim(),
        description:
            'Group for ${name.trim()}. Created automatically with the class '
            'list.',
        classListId: listId,
      );
    }

    final ClassList list = ClassList(
      id: listId,
      name: name.trim(),
      institution: profile.institutionName,
      faculty: profile.faculty,
      department: profile.department,
      level: profile.level,
      session: session.trim(),
      ownerId: profile.id,
      ownerName: profile.fullName,
      groupId: group?.id,
      createdAt: DateTime.now(),
    );

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client.from('class_lists').insert(list.toJson());
      } catch (error) {
        debugPrint('[Eduvora] class list create failed: $error');
        throw const GroupFailure(
          'We could not create the class list just now. Please try again.',
        );
      }
    }

    final List<Map<String, dynamic>> cached = LocalStore.instance.readList(
      StoreKeys.classLists,
    )..insert(0, list.toJson());
    await LocalStore.instance.writeList(StoreKeys.classLists, cached);

    return list;
  }

  Future<List<ClassListEntry>> entries(String classListId) async {
    if (!SupabaseService.isReady) {
      return LocalStore.instance
          .readList('${StoreKeys.classEntries}.$classListId')
          .map(ClassListEntry.fromJson)
          .toList();
    }
    try {
      final List<dynamic> rows = await SupabaseService.client
          .from('class_list_entries')
          .select()
          .eq('class_list_id', classListId)
          .order('position');
      return rows
          .whereType<Map<String, dynamic>>()
          .map(ClassListEntry.fromJson)
          .toList();
    } catch (error) {
      debugPrint('[Eduvora] entries fetch failed: $error');
      return LocalStore.instance
          .readList('${StoreKeys.classEntries}.$classListId')
          .map(ClassListEntry.fromJson)
          .toList();
    }
  }

  Future<ClassListEntry> addEntry({
    required String classListId,
    required String fullName,
    String matricNumber = '',
    String email = '',
    String phone = '',
    String note = '',
    int position = 0,
  }) async {
    final ClassListEntry entry = ClassListEntry(
      id: _uuid.v4(),
      classListId: classListId,
      fullName: fullName.trim(),
      matricNumber: matricNumber.trim().toUpperCase(),
      email: email.trim(),
      phone: phone.trim(),
      note: note.trim(),
      position: position,
      createdAt: DateTime.now(),
    );

    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('class_list_entries')
            .insert(entry.toJson());
      } catch (error) {
        debugPrint('[Eduvora] entry insert failed: $error');
      }
    }

    final List<Map<String, dynamic>> cached = LocalStore.instance.readList(
      '${StoreKeys.classEntries}.$classListId',
    )..add(entry.toJson());
    await LocalStore.instance.writeList(
      '${StoreKeys.classEntries}.$classListId',
      cached,
    );

    return entry;
  }

  Future<void> removeEntry({
    required String classListId,
    required String entryId,
  }) async {
    if (SupabaseService.isReady) {
      try {
        await SupabaseService.client
            .from('class_list_entries')
            .delete()
            .eq('id', entryId);
      } catch (error) {
        debugPrint('[Eduvora] entry delete failed: $error');
      }
    }
    final List<Map<String, dynamic>> cached =
        LocalStore.instance.readList('${StoreKeys.classEntries}.$classListId')
          ..removeWhere((Map<String, dynamic> e) => e['id'] == entryId);
    await LocalStore.instance.writeList(
      '${StoreKeys.classEntries}.$classListId',
      cached,
    );
  }

  // ------------------------------------------------------------ local cache

  List<StudyGroup> _localGroupsFor(String userId) => LocalStore.instance
      .readList('${StoreKeys.myGroups}.$userId')
      .map(StudyGroup.fromJson)
      .toList();

  Future<void> _cacheGroup(StudyGroup group, String userId) async {
    final List<Map<String, dynamic>> cached = LocalStore.instance.readList(
      '${StoreKeys.myGroups}.$userId',
    );
    cached.removeWhere((Map<String, dynamic> g) => g['id'] == group.id);
    cached.insert(0, group.toJson());
    await LocalStore.instance.writeList(
      '${StoreKeys.myGroups}.$userId',
      cached,
    );
  }

  Future<void> _uncacheGroup(String groupId, String userId) async {
    final List<Map<String, dynamic>> cached =
        LocalStore.instance.readList('${StoreKeys.myGroups}.$userId')
          ..removeWhere((Map<String, dynamic> g) => g['id'] == groupId);
    await LocalStore.instance.writeList(
      '${StoreKeys.myGroups}.$userId',
      cached,
    );
  }
}
