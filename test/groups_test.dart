import 'dart:math';

import 'package:eduvora/core/models/class_list.dart';
import 'package:eduvora/core/models/study_group.dart';
import 'package:eduvora/core/services/group_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('join codes', () {
    test('are six characters long', () {
      for (int i = 0; i < 200; i++) {
        expect(StudyGroup.generateJoinCode().length, 6);
      }
    });

    test('never contain characters that can be misread aloud', () {
      // O/0 and I/1 are excluded on purpose — a code gets read off a
      // whiteboard or dictated in a lecture hall.
      final RegExp allowed = RegExp(r'^[ABCDEFGHJKLMNPQRSTUVWXYZ23456789]{6}$');
      for (int i = 0; i < 500; i++) {
        expect(allowed.hasMatch(StudyGroup.generateJoinCode()), isTrue);
      }
    });

    test('are effectively unique across a large batch', () {
      final Set<String> seen = <String>{};
      for (int i = 0; i < 2000; i++) {
        seen.add(StudyGroup.generateJoinCode());
      }
      // 32^6 ≈ 1.07 billion, so 2000 draws should collide vanishingly rarely.
      expect(seen.length, greaterThan(1995));
    });

    test('are reproducible from a seeded generator', () {
      expect(
        StudyGroup.generateJoinCode(Random(7)),
        StudyGroup.generateJoinCode(Random(7)),
      );
    });
  });

  group('StudyGroup', () {
    test('knows when it came from a class list', () {
      const StudyGroup plain = StudyGroup(
        id: 'g1',
        name: 'Geology 300',
        joinCode: 'ABCDEF',
      );
      expect(plain.isFromClassList, isFalse);

      const StudyGroup fromList = StudyGroup(
        id: 'g2',
        name: 'Geology 300',
        joinCode: 'ABCDEF',
        classListId: 'cl1',
      );
      expect(fromList.isFromClassList, isTrue);
    });

    test('survives a JSON round trip', () {
      const StudyGroup original = StudyGroup(
        id: 'g1',
        name: 'Statistics 200 Level',
        joinCode: 'K7M2PQ',
        department: 'Statistics',
        level: '200 Level',
        classListId: 'cl9',
      );
      final StudyGroup restored = StudyGroup.fromJson(original.toJson());

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.joinCode, original.joinCode);
      expect(restored.department, original.department);
      expect(restored.classListId, original.classListId);
    });
  });

  group('ClassList', () {
    test('reports whether a group was created alongside it', () {
      const ClassList without = ClassList(id: 'c1', name: 'Geology 300');
      const ClassList with_ = ClassList(
        id: 'c2',
        name: 'Geology 300',
        groupId: 'g1',
      );
      expect(without.hasGroup, isFalse);
      expect(with_.hasGroup, isTrue);
    });

    test('builds a readable subtitle from what it has', () {
      const ClassList list = ClassList(
        id: 'c1',
        name: 'Geology 300',
        department: 'Geology',
        level: '300 Level',
        session: '2025/2026',
      );
      expect(list.subtitle, 'Geology · 300 Level · 2025/2026');

      const ClassList bare = ClassList(id: 'c2', name: 'Untitled');
      expect(bare.subtitle, 'Class list');
    });
  });

  group('ClassListCsv', () {
    ClassListEntry entry(
      String name, {
      String matric = '',
      String email = '',
      String phone = '',
      String note = '',
    }) => ClassListEntry(
      id: name,
      classListId: 'c1',
      fullName: name,
      matricNumber: matric,
      email: email,
      phone: phone,
      note: note,
    );

    const ClassList list = ClassList(
      id: 'c1',
      name: 'Geology 300 Level',
      institution: 'University of Nigeria, Nsukka',
      department: 'Geology',
      level: '300 Level',
      session: '2025/2026',
    );

    test('numbers every student in order', () {
      final String csv = ClassListCsv.build(list, <ClassListEntry>[
        entry('Chidera Okoye', matric: '2021/241001'),
        entry('Aisha Bello', matric: '2021/241002'),
        entry('Tunde Adeyemi', matric: '2021/241003'),
      ]);

      final List<String> lines = csv.trim().split('\n');
      expect(lines.any((String l) => l.startsWith('1,Chidera Okoye')), isTrue);
      expect(lines.any((String l) => l.startsWith('2,Aisha Bello')), isTrue);
      expect(lines.any((String l) => l.startsWith('3,Tunde Adeyemi')), isTrue);
    });

    test('carries the header row', () {
      final String csv = ClassListCsv.build(list, <ClassListEntry>[]);
      expect(csv, contains('S/N,Full name,Matriculation number'));
    });

    test('identifies itself with the class and institution', () {
      final String csv = ClassListCsv.build(list, <ClassListEntry>[]);
      expect(csv, contains('Geology 300 Level'));
      expect(csv, contains('University of Nigeria, Nsukka'));
      expect(csv, contains('2025/2026'));
    });

    test('quotes a field containing a comma', () {
      // The institution itself has a comma — it must not split into two cells.
      final String csv = ClassListCsv.build(list, <ClassListEntry>[]);
      expect(csv, contains('"University of Nigeria, Nsukka"'));
    });

    test('doubles inner quotes rather than breaking the row', () {
      final String csv = ClassListCsv.build(list, <ClassListEntry>[
        entry('Chidera "Chi" Okoye', matric: '2021/241001'),
      ]);
      expect(csv, contains('"Chidera ""Chi"" Okoye"'));
    });

    test('quotes a note containing a newline', () {
      final String csv = ClassListCsv.build(list, <ClassListEntry>[
        entry('Aisha Bello', note: 'Owes fees\nsee bursary'),
      ]);
      expect(csv, contains('"Owes fees\nsee bursary"'));
    });

    test('leaves ordinary fields unquoted', () {
      final String csv = ClassListCsv.build(list, <ClassListEntry>[
        entry('Aisha Bello', matric: '2021241002', phone: '08031234567'),
      ]);
      expect(csv, contains('Aisha Bello,2021241002'));
      expect(csv, isNot(contains('"Aisha Bello"')));
    });

    test('produces one row per student plus the header', () {
      final List<ClassListEntry> entries = List<ClassListEntry>.generate(
        12,
        (int i) => entry('Student $i', matric: '2021/2410${i.toString()}'),
      );
      final String csv = ClassListCsv.build(list, entries);

      final int dataRows = csv
          .trim()
          .split('\n')
          .where((String l) => RegExp(r'^\d+,').hasMatch(l))
          .length;
      expect(dataRows, 12);
    });

    test('handles an empty list without throwing', () {
      expect(
        () => ClassListCsv.build(list, <ClassListEntry>[]),
        returnsNormally,
      );
    });

    test('gives the file a sensible name', () {
      expect(ClassListCsv.fileNameFor(list), endsWith('.csv'));
      expect(ClassListCsv.fileNameFor(list), isNot(contains(' ')));
      expect(ClassListCsv.fileNameFor(list), isNot(contains('/')));
    });
  });

  group('ClassListEntry', () {
    test('survives a JSON round trip', () {
      const ClassListEntry original = ClassListEntry(
        id: 'e1',
        classListId: 'c1',
        fullName: 'Chidera Okoye',
        matricNumber: '2021/241001',
        email: 'chidera@example.com',
        phone: '08031234567',
        note: 'Class rep',
        position: 3,
      );
      final ClassListEntry restored = ClassListEntry.fromJson(
        original.toJson(),
      );

      expect(restored.fullName, original.fullName);
      expect(restored.matricNumber, original.matricNumber);
      expect(restored.email, original.email);
      expect(restored.phone, original.phone);
      expect(restored.note, original.note);
      expect(restored.position, original.position);
    });

    test('copyWith changes only what it is given', () {
      const ClassListEntry original = ClassListEntry(
        id: 'e1',
        classListId: 'c1',
        fullName: 'Chidera Okoye',
        matricNumber: '2021/241001',
      );
      final ClassListEntry edited = original.copyWith(note: 'Class rep');

      expect(edited.fullName, 'Chidera Okoye');
      expect(edited.matricNumber, '2021/241001');
      expect(edited.note, 'Class rep');
    });
  });

  group('GroupMember', () {
    test('derives initials from a full name', () {
      expect(
        const GroupMember(
          id: 'm1',
          groupId: 'g1',
          userId: 'u1',
          fullName: 'Chidera Okoye',
        ).initials,
        'CO',
      );
    });

    test('copes with a single name', () {
      expect(
        const GroupMember(
          id: 'm1',
          groupId: 'g1',
          userId: 'u1',
          fullName: 'Chidera',
        ).initials,
        'C',
      );
    });

    test('copes with an empty name', () {
      expect(
        const GroupMember(
          id: 'm1',
          groupId: 'g1',
          userId: 'u1',
          fullName: '',
        ).initials,
        isNotEmpty,
      );
    });

    test('gives a first name for confirmation prompts', () {
      expect(
        const GroupMember(
          id: 'm1',
          groupId: 'g1',
          userId: 'u1',
          fullName: 'Chidera Okoye',
        ).firstName,
        'Chidera',
      );
    });

    test('never leaves a prompt reading "Remove ?"', () {
      expect(
        const GroupMember(
          id: 'm1',
          groupId: 'g1',
          userId: 'u1',
          fullName: '',
        ).firstName,
        isNotEmpty,
      );
    });

    test('carries the admin flag through a JSON round trip', () {
      const GroupMember admin = GroupMember(
        id: 'm1',
        groupId: 'g1',
        userId: 'u1',
        fullName: 'Chidera Okoye',
        isAdmin: true,
      );
      expect(GroupMember.fromJson(admin.toJson()).isAdmin, isTrue);

      const GroupMember ordinary = GroupMember(
        id: 'm2',
        groupId: 'g1',
        userId: 'u2',
        fullName: 'Aisha Bello',
      );
      expect(GroupMember.fromJson(ordinary.toJson()).isAdmin, isFalse);
    });
  });

  group('group admin rules', () {
    const GroupRepository repo = GroupRepository();

    const StudyGroup group = StudyGroup(
      id: 'g1',
      name: 'Geology 300 Level',
      joinCode: 'K7M2PQ',
      createdBy: 'founder-id',
    );

    const GroupMember founder = GroupMember(
      id: 'm1',
      groupId: 'g1',
      userId: 'founder-id',
      fullName: 'Chidera Okoye',
      isAdmin: true,
    );

    const GroupMember member = GroupMember(
      id: 'm2',
      groupId: 'g1',
      userId: 'other-id',
      fullName: 'Aisha Bello',
    );

    test('the founder can never be dismissed as admin', () async {
      await expectLater(
        repo.setAdmin(group: group, member: founder, isAdmin: false),
        throwsA(isA<GroupFailure>()),
      );
    });

    test('the founder can never be removed from the group', () async {
      await expectLater(
        repo.removeMember(group: group, member: founder),
        throwsA(isA<GroupFailure>()),
      );
    });

    test('the refusal explains itself in plain words', () async {
      try {
        await repo.removeMember(group: group, member: founder);
        fail('expected a GroupFailure');
      } on GroupFailure catch (error) {
        expect(error.message, contains('created this group'));
      }
    });

    test('an ordinary member gets past the founder guard', () async {
      // Without a backend this fails at the connection check rather than the
      // founder check — which is the point: the guard did not block them.
      try {
        await repo.setAdmin(group: group, member: member, isAdmin: true);
        fail('expected a GroupFailure about being offline');
      } on GroupFailure catch (error) {
        expect(error.message, contains('online'));
      }
    });
  });

  group('GroupMessage', () {
    test('marks a question distinctly from ordinary chat', () {
      final GroupMessage question = GroupMessage(
        id: 'm1',
        groupId: 'g1',
        authorId: 'u1',
        authorName: 'Chidera',
        body: 'How do we solve part b?',
        sentAt: DateTime(2026, 8, 5, 9),
        isQuestion: true,
      );
      final GroupMessage chat = GroupMessage(
        id: 'm2',
        groupId: 'g1',
        authorId: 'u2',
        authorName: 'Aisha',
        body: 'See you at the lab',
        sentAt: DateTime(2026, 8, 5, 10),
      );

      expect(question.isQuestion, isTrue);
      expect(chat.isQuestion, isFalse);
    });

    test('a fresh message is neither deleted nor a reply', () {
      final GroupMessage m = GroupMessage(
        id: 'm1',
        groupId: 'g1',
        authorId: 'u1',
        authorName: 'Chidera',
        body: 'Hello',
        sentAt: DateTime(2026, 8, 5),
      );
      expect(m.isDeleted, isFalse);
      expect(m.isReply, isFalse);
      expect(m.displayBody, 'Hello');
    });

    test('a deleted message shows a notice instead of its body', () {
      final GroupMessage m = GroupMessage(
        id: 'm1',
        groupId: 'g1',
        authorId: 'u1',
        authorName: 'Chidera',
        body: '',
        sentAt: DateTime(2026, 8, 5),
        deletedAt: DateTime(2026, 8, 5, 10),
      );
      expect(m.isDeleted, isTrue);
      expect(m.displayBody, 'This message was deleted');
    });

    test('a reply carries the quoted original', () {
      final GroupMessage m = GroupMessage(
        id: 'm2',
        groupId: 'g1',
        authorId: 'u2',
        authorName: 'Aisha',
        body: 'Use the quadratic formula',
        sentAt: DateTime(2026, 8, 5, 11),
        replyToId: 'm1',
        replyToAuthor: 'Chidera',
        replyToBody: 'How do we solve part b?',
      );
      expect(m.isReply, isTrue);
      expect(m.replyToAuthor, 'Chidera');
      expect(m.replyToBody, 'How do we solve part b?');
    });

    test('the quote survives the original being deleted', () {
      // The reply stores its own copy of the quoted text, so clearing the
      // original must not blank the quote above the reply.
      final GroupMessage reply = GroupMessage(
        id: 'm2',
        groupId: 'g1',
        authorId: 'u2',
        authorName: 'Aisha',
        body: 'Use the quadratic formula',
        sentAt: DateTime(2026, 8, 5, 11),
        replyToId: 'm1',
        replyToAuthor: 'Chidera',
        replyToBody: 'How do we solve part b?',
      );
      final GroupMessage restored = GroupMessage.fromJson(reply.toJson());
      expect(restored.replyToBody, 'How do we solve part b?');
    });

    test('copyWith marks a message deleted without losing its identity', () {
      final GroupMessage original = GroupMessage(
        id: 'm1',
        groupId: 'g1',
        authorId: 'u1',
        authorName: 'Chidera',
        body: 'Oops, wrong group',
        sentAt: DateTime(2026, 8, 5),
        isQuestion: true,
      );
      final GroupMessage cleared = original.copyWith(
        body: '',
        deletedAt: DateTime(2026, 8, 5, 12),
      );

      expect(cleared.id, original.id);
      expect(cleared.authorName, 'Chidera');
      expect(cleared.sentAt, original.sentAt);
      expect(cleared.isDeleted, isTrue);
      expect(cleared.body, isEmpty);
    });

    test('a deletion survives a JSON round trip', () {
      final GroupMessage cleared = GroupMessage(
        id: 'm1',
        groupId: 'g1',
        authorId: 'u1',
        authorName: 'Chidera',
        body: '',
        sentAt: DateTime(2026, 8, 5),
        deletedAt: DateTime(2026, 8, 5, 12),
      );
      expect(GroupMessage.fromJson(cleared.toJson()).isDeleted, isTrue);
    });

    test('survives a JSON round trip with the question flag intact', () {
      final GroupMessage original = GroupMessage(
        id: 'm1',
        groupId: 'g1',
        authorId: 'u1',
        authorName: 'Chidera',
        body: r'Solve $x^2 + 2x + 1 = 0$',
        sentAt: DateTime(2026, 8, 5, 9),
        isQuestion: true,
      );
      final GroupMessage restored = GroupMessage.fromJson(original.toJson());

      expect(restored.body, original.body);
      expect(restored.isQuestion, isTrue);
      expect(restored.authorName, 'Chidera');
    });
  });
}
