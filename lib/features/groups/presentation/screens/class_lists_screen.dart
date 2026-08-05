import 'package:flutter/material.dart';

import '../../../../core/models/class_list.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/services/group_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import 'class_list_detail_screen.dart';

/// The class lists this student owns.
class ClassListsScreen extends StatefulWidget {
  const ClassListsScreen({super.key});

  @override
  State<ClassListsScreen> createState() => _ClassListsScreenState();
}

class _ClassListsScreenState extends State<ClassListsScreen> {
  static const GroupRepository _repo = GroupRepository();

  late Future<List<ClassList>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<ClassList>> _load() {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return Future<List<ClassList>>.value(<ClassList>[]);
    return _repo.myClassLists(profile);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  Future<void> _create() async {
    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    final _NewClassList? draft = await showModalBottomSheet<_NewClassList>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => const _CreateClassListSheet(),
    );
    if (draft == null || !mounted) return;

    try {
      final ClassList list = await _repo.createClassList(
        profile: profile,
        name: draft.name,
        session: draft.session,
        withGroup: draft.withGroup,
      );
      if (!mounted) return;
      await _refresh();
      if (!mounted) return;
      showEduvoraSnack(
        context,
        draft.withGroup
            ? 'Class list created, with its group chat.'
            : 'Class list created.',
      );
      await Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ClassListDetailScreen(list: list),
        ),
      );
      if (mounted) await _refresh();
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(context, '$error', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('Class lists'),
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
        backgroundColor: AppColours.accent,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.playlist_add_rounded),
        label: const Text('New class list'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColours.primary,
        child: FutureBuilder<List<ClassList>>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<List<ClassList>> s) {
            if (s.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final List<ClassList> lists = s.data ?? <ClassList>[];

            if (lists.isEmpty) {
              return ListView(
                children: <Widget>[
                  EmptyState(
                    icon: Icons.list_alt_rounded,
                    title: 'No class lists yet',
                    message:
                        'Build a register of your class once — names, matric '
                        'numbers, contacts — and Eduvora sets up the group '
                        'chat alongside it. You can export the list whenever '
                        'the department asks for one.',
                    actionLabel: 'Create a class list',
                    onAction: _create,
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: <Widget>[
                const SectionHeader(
                  title: 'Your class lists',
                  subtitle: 'Tap one to add students or export it',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenPadding,
                  ),
                  child: Column(
                    children: lists
                        .map(
                          (ClassList l) => Padding(
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.sm,
                            ),
                            child: _ClassListRow(
                              list: l,
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        ClassListDetailScreen(list: l),
                                  ),
                                );
                                if (mounted) await _refresh();
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ClassListRow extends StatelessWidget {
  const _ClassListRow({required this.list, required this.onTap});

  final ClassList list;
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
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColours.accent.withValues(alpha: 0.12),
              borderRadius: AppRadii.md,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '${list.entryCount}',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColours.accent,
                  ),
                ),
                const Text(
                  'names',
                  style: TextStyle(fontSize: 8.5, color: AppColours.accent),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  list.name,
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
                  list.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColours.textMuted,
                  ),
                ),
                if (list.hasGroup) ...<Widget>[
                  const SizedBox(height: 6),
                  const Pill(
                    label: 'Group chat created',
                    icon: Icons.groups_rounded,
                    colour: AppColours.success,
                    dense: true,
                  ),
                ],
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

class _NewClassList {
  const _NewClassList(this.name, this.session, this.withGroup);

  final String name;
  final String session;
  final bool withGroup;
}

class _CreateClassListSheet extends StatefulWidget {
  const _CreateClassListSheet();

  @override
  State<_CreateClassListSheet> createState() => _CreateClassListSheetState();
}

class _CreateClassListSheetState extends State<_CreateClassListSheet> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _session = TextEditingController();
  bool _withGroup = true;

  @override
  void dispose() {
    _name.dispose();
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final StudentProfile? profile = sessionController.profile;

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
              'New class list',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Filed under ${profile?.department ?? 'your department'}, '
              '${profile?.level ?? 'your level'}.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Class name',
                hintText: 'e.g. Geology 300 Level',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _session,
              decoration: const InputDecoration(
                labelText: 'Session (optional)',
                hintText: 'e.g. 2025/2026',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SwitchListTile(
              value: _withGroup,
              onChanged: (bool v) => setState(() => _withGroup = v),
              contentPadding: EdgeInsets.zero,
              title: const Text('Create the group chat too'),
              subtitle: const Text(
                'Sets up a group for this class with a code to share',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () {
                if (_name.text.trim().length < 3) {
                  showEduvoraSnack(
                    context,
                    'Please name the class.',
                    isError: true,
                  );
                  return;
                }
                Navigator.of(context).pop(
                  _NewClassList(_name.text, _session.text, _withGroup),
                );
              },
              child: const Text('Create class list'),
            ),
          ],
        ),
      ),
    );
  }
}
