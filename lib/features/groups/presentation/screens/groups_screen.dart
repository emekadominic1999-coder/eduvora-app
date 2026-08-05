import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/models/student_profile.dart';
import '../../../../core/models/study_group.dart';
import '../../../../core/services/group_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'group_chat_screen.dart';

/// The student's study groups, with create and join.
class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key, this.embedded = false});

  final bool embedded;

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  static const GroupRepository _repo = GroupRepository();

  late Future<List<StudyGroup>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<StudyGroup>> _load() {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return Future<List<StudyGroup>>.value(<StudyGroup>[]);
    return _repo.myGroups(profile);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  Future<void> _openGroup(StudyGroup group) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => GroupChatScreen(group: group)),
    );
    if (mounted) await _refresh();
  }

  Future<void> _create() async {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    final _NewGroup? draft = await showModalBottomSheet<_NewGroup>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => const _CreateGroupSheet(),
    );
    if (draft == null || !mounted) return;

    try {
      final StudyGroup group = await _repo.createGroup(
        profile: profile,
        name: draft.name,
        description: draft.description,
        courseCode: draft.courseCode,
      );
      if (!mounted) return;
      await _refresh();
      if (!mounted) return;
      await _showCodeDialog(group);
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(context, '$error', isError: true);
    }
  }

  Future<void> _join() async {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    final String? code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => const _JoinGroupSheet(),
    );
    if (code == null || !mounted) return;

    try {
      final StudyGroup group = await _repo.joinByCode(
        profile: profile,
        code: code,
      );
      if (!mounted) return;
      await _refresh();
      if (!mounted) return;
      showEduvoraSnack(context, 'You have joined ${group.name}.');
      await _openGroup(group);
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(context, '$error', isError: true);
    }
  }

  Future<void> _showCodeDialog(StudyGroup group) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Group created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Share this code with your coursemates so they can join '
              '${group.name}.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            _JoinCodeBox(code: group.joinCode),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        automaticallyImplyLeading: !widget.embedded,
        title: const Text('Study groups'),
        actions: <Widget>[
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        backgroundColor: AppColours.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.group_add_rounded),
        label: const Text('New group'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColours.primary,
        child: FutureBuilder<List<StudyGroup>>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<List<StudyGroup>> s) {
            if (s.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<StudyGroup> groups = s.data ?? <StudyGroup>[];

            return ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: <Widget>[
                _joinBanner(),
                if (groups.isEmpty)
                  EmptyState(
                    icon: Icons.groups_rounded,
                    title: 'No groups yet',
                    message:
                        'Create a group for your class or course, then share '
                        'the code with your coursemates. Everything you '
                        'discuss stays in one place.',
                    actionLabel: 'Create a group',
                    onAction: _create,
                  )
                else ...<Widget>[
                  SectionHeader(
                    title: 'Your groups',
                    subtitle:
                        '${groups.length} ${groups.length == 1 ? 'group' : 'groups'}',
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.screenPadding,
                    ),
                    child: Column(
                      children: groups
                          .map(
                            (StudyGroup g) => Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                              child: _GroupRow(
                                group: g,
                                onTap: () => _openGroup(g),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _joinBanner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: EduvoraCard(
        onTap: _join,
        colour: AppColours.primaryTint,
        shadows: const <BoxShadow>[],
        border: Border.all(color: AppColours.primarySoft),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColours.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.login_rounded,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Have a group code?',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Enter it to join your coursemates.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColours.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupRow extends StatelessWidget {
  const _GroupRow({required this.group, required this.onTap});

  final StudyGroup group;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: group.isFromClassList
                  ? AppColours.accent.withValues(alpha: 0.13)
                  : AppColours.primaryTint,
              borderRadius: AppRadii.md,
            ),
            child: Icon(
              group.isFromClassList
                  ? Icons.list_alt_rounded
                  : Icons.groups_rounded,
              color: group.isFromClassList
                  ? AppColours.accent
                  : AppColours.primary,
              size: 23,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  group.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColours.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  group.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColours.textMuted,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: <Widget>[
                    Pill(
                      label:
                          '${group.memberCount} ${group.memberCount == 1 ? 'member' : 'members'}',
                      icon: Icons.person_rounded,
                      dense: true,
                    ),
                    const SizedBox(width: 6),
                    Pill(
                      label: group.joinCode,
                      colour: AppColours.textMuted,
                      dense: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColours.borderStrong,
          ),
        ],
      ),
    );
  }
}

/// The code, large and tappable to copy.
class _JoinCodeBox extends StatelessWidget {
  const _JoinCodeBox({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Clipboard.setData(ClipboardData(text: code));
        if (context.mounted) {
          showEduvoraSnack(context, 'Code copied.', icon: Icons.copy_rounded);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColours.primaryTint,
          borderRadius: AppRadii.md,
          border: Border.all(color: AppColours.primarySoft),
        ),
        child: Column(
          children: <Widget>[
            Text(
              code,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 7,
                color: AppColours.primary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tap to copy',
              style: TextStyle(fontSize: 11.5, color: AppColours.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewGroup {
  const _NewGroup(this.name, this.description, this.courseCode);

  final String name;
  final String description;
  final String courseCode;
}

class _CreateGroupSheet extends StatefulWidget {
  const _CreateGroupSheet();

  @override
  State<_CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<_CreateGroupSheet> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _course = TextEditingController();
  final TextEditingController _description = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _course.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'New study group',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'You will get a code to share with your coursemates.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Group name',
                hintText: 'e.g. Geology 300 Level 2025/2026',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _course,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Course code (optional)',
                hintText: 'e.g. GLG 311',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _description,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'What is this group for? (optional)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () {
                if (_name.text.trim().length < 3) {
                  showEduvoraSnack(
                    context,
                    'Please give the group a name.',
                    isError: true,
                  );
                  return;
                }
                Navigator.of(context).pop(
                  _NewGroup(
                    _name.text,
                    _description.text,
                    _course.text,
                  ),
                );
              },
              child: const Text('Create group'),
            ),
          ],
        ),
      ),
    );
  }
}

class _JoinGroupSheet extends StatefulWidget {
  const _JoinGroupSheet();

  @override
  State<_JoinGroupSheet> createState() => _JoinGroupSheetState();
}

class _JoinGroupSheetState extends State<_JoinGroupSheet> {
  final TextEditingController _code = TextEditingController();

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text('Join a group', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Enter the six-character code your coursemate shared.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _code,
              autofocus: true,
              textCapitalization: TextCapitalization.characters,
              maxLength: 6,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                letterSpacing: 8,
              ),
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'ABC234',
                counterText: '',
              ),
              onSubmitted: (String v) => Navigator.of(context).pop(v),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_code.text),
              child: const Text('Join group'),
            ),
          ],
        ),
      ),
    );
  }
}
