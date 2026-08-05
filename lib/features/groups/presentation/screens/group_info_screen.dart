import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/models/student_profile.dart';
import '../../../../core/models/study_group.dart';
import '../../../../core/services/group_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// Everything about a group in one place: who is in it, who runs it, and the
/// code to bring more people in.
///
/// Admin rights are the point of this screen. Whoever creates a group is its
/// admin from the start; from here they can hand that role to somebody else —
/// which matters when a course rep graduates and the group has to carry on.
class GroupInfoScreen extends StatefulWidget {
  const GroupInfoScreen({super.key, required this.group});

  final StudyGroup group;

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  static const GroupRepository _repo = GroupRepository();

  late StudyGroup _group = widget.group;
  List<GroupMember> _members = <GroupMember>[];
  bool _loading = true;

  /// True when the signed-in student may promote, dismiss and remove.
  bool _iAmAdmin = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final StudentProfile? me = sessionController.profile;
    final List<GroupMember> members = await _repo.members(_group.id);
    if (!mounted) return;

    setState(() {
      _members = members
        ..sort((GroupMember a, GroupMember b) {
          // Admins first, then alphabetically — the shape people expect.
          if (a.isAdmin != b.isAdmin) return a.isAdmin ? -1 : 1;
          return a.fullName.toLowerCase().compareTo(b.fullName.toLowerCase());
        });
      _iAmAdmin = members.any(
        (GroupMember m) => m.userId == me?.id && m.isAdmin,
      );
      _loading = false;
    });
  }

  bool _isFounder(GroupMember m) => m.userId == _group.createdBy;

  Future<void> _setAdmin(GroupMember member, bool makeAdmin) async {
    final bool? confirmed = await _confirm(
      title: makeAdmin
          ? 'Make ${member.firstName} an admin?'
          : 'Dismiss ${member.firstName} as admin?',
      message: makeAdmin
          ? '${member.fullName} will be able to add and remove members, '
                'delete any message, and make other people admins too.'
          : '${member.fullName} will stay in the group as an ordinary '
                'member.',
      action: makeAdmin ? 'Make admin' : 'Dismiss as admin',
      dangerous: !makeAdmin,
    );
    if (!(confirmed ?? false)) return;

    try {
      await _repo.setAdmin(
        group: _group,
        member: member,
        isAdmin: makeAdmin,
      );
      if (!mounted) return;
      await _load();
      if (!mounted) return;
      showEduvoraSnack(
        context,
        makeAdmin
            ? '${member.firstName} is now an admin.'
            : '${member.firstName} is no longer an admin.',
      );
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(context, '$error', isError: true);
    }
  }

  Future<void> _remove(GroupMember member) async {
    final bool? confirmed = await _confirm(
      title: 'Remove ${member.firstName}?',
      message:
          '${member.fullName} will lose access to this group. They can join '
          'again later if somebody shares the code with them.',
      action: 'Remove',
      dangerous: true,
    );
    if (!(confirmed ?? false)) return;

    try {
      await _repo.removeMember(group: _group, member: member);
      if (!mounted) return;
      await _load();
      if (!mounted) return;
      showEduvoraSnack(context, '${member.firstName} has been removed.');
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(context, '$error', isError: true);
    }
  }

  Future<bool?> _confirm({
    required String title,
    required String message,
    required String action,
    bool dangerous = false,
  }) => showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: dangerous
              ? TextButton.styleFrom(foregroundColor: AppColours.danger)
              : null,
          child: Text(action),
        ),
      ],
    ),
  );

  Future<void> _rename() async {
    final TextEditingController name = TextEditingController(text: _group.name);
    final TextEditingController description = TextEditingController(
      text: _group.description,
    );

    final bool? saved = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Group details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Group name'),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: description,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'What is this group for?',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    final String newName = name.text.trim();
    final String newDescription = description.text.trim();
    name.dispose();
    description.dispose();

    if (!(saved ?? false) || newName.length < 3 || !mounted) return;

    try {
      final StudyGroup updated = await _repo.updateGroup(
        group: _group,
        name: newName,
        description: newDescription,
      );
      if (!mounted) return;
      setState(() => _group = updated);
      showEduvoraSnack(context, 'Group details saved.');
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final StudentProfile? me = sessionController.profile;
    final int adminCount = _members.where((GroupMember m) => m.isAdmin).length;

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('Group info'),
        actions: <Widget>[
          if (_iAmAdmin)
            IconButton(
              onPressed: _rename,
              icon: const Icon(Icons.edit_rounded),
              tooltip: 'Edit group details',
            ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _load,
              color: AppColours.primary,
              child: ListView(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                children: <Widget>[
                  _header(),
                  _codeCard(),
                  SectionHeader(
                    title: '${_members.length} '
                        '${_members.length == 1 ? 'member' : 'members'}',
                    subtitle: adminCount == 1
                        ? '1 admin'
                        : '$adminCount admins',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Column(
                      children: _members
                          .map(
                            (GroupMember m) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                              child: _MemberRow(
                                member: m,
                                isMe: m.userId == me?.id,
                                isFounder: _isFounder(m),
                                // The founder's rights are permanent, so no
                                // menu is offered against them at all.
                                canManage: _iAmAdmin && !_isFounder(m),
                                onSetAdmin: (bool v) => _setAdmin(m, v),
                                onRemove: () => _remove(m),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  if (!_iAmAdmin) ...<Widget>[
                    const SizedBox(height: AppSpacing.md),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                      ),
                      child: Text(
                        'Only an admin can add or remove members and change '
                        'who else is an admin.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _header() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: AppColours.brandGradient,
          borderRadius: AppRadii.lg,
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: AppRadii.md,
                  ),
                  child: const Icon(
                    Icons.groups_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _group.name,
                        style: const TextStyle(
                          fontSize: 18,
                          height: 1.25,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _group.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_group.description.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              Text(
                _group.description,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.45,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
            if (_group.creatorName.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              Text(
                'Created by ${_group.creatorName}',
                style: TextStyle(
                  fontSize: 11.5,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _codeCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: EduvoraCard(
        shadows: AppShadows.subtle,
        onTap: () async {
          await Clipboard.setData(ClipboardData(text: _group.joinCode));
          if (!mounted) return;
          showEduvoraSnack(context, 'Code copied. Paste it to your class.');
        },
        child: Row(
          children: <Widget>[
            const Icon(Icons.key_rounded, color: AppColours.accent),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Invite code',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: AppColours.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _group.joinCode,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 3,
                      color: AppColours.text,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.copy_rounded, color: AppColours.textFaint),
          ],
        ),
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.member,
    required this.isMe,
    required this.isFounder,
    required this.canManage,
    required this.onSetAdmin,
    required this.onRemove,
  });

  final GroupMember member;
  final bool isMe;
  final bool isFounder;
  final bool canManage;
  final ValueChanged<bool> onSetAdmin;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Row(
        children: <Widget>[
          InitialsAvatar(initials: member.initials, size: 42),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        isMe ? '${member.fullName} (you)' : member.fullName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColours.text,
                        ),
                      ),
                    ),
                    if (member.isAdmin) ...<Widget>[
                      const SizedBox(width: 6),
                      Pill(
                        label: isFounder ? 'Creator' : 'Admin',
                        dense: true,
                        colour: isFounder
                            ? AppColours.accent
                            : AppColours.primary,
                      ),
                    ],
                  ],
                ),
                if (member.headline.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    member.headline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColours.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (canManage)
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: AppColours.textFaint,
              ),
              onSelected: (String value) {
                switch (value) {
                  case 'promote':
                    onSetAdmin(true);
                  case 'dismiss':
                    onSetAdmin(false);
                  case 'remove':
                    onRemove();
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                if (!member.isAdmin)
                  const PopupMenuItem<String>(
                    value: 'promote',
                    child: Text('Make group admin'),
                  )
                else
                  const PopupMenuItem<String>(
                    value: 'dismiss',
                    child: Text('Dismiss as admin'),
                  ),
                const PopupMenuItem<String>(
                  value: 'remove',
                  child: Text('Remove from group'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
