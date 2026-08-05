import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/models/class_list.dart';
import '../../../../core/services/file_export.dart';
import '../../../../core/services/group_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// One class list: its students, and the export.
class ClassListDetailScreen extends StatefulWidget {
  const ClassListDetailScreen({super.key, required this.list});

  final ClassList list;

  @override
  State<ClassListDetailScreen> createState() => _ClassListDetailScreenState();
}

class _ClassListDetailScreenState extends State<ClassListDetailScreen> {
  static const GroupRepository _repo = GroupRepository();

  List<ClassListEntry> _entries = <ClassListEntry>[];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final List<ClassListEntry> entries = await _repo.entries(widget.list.id);
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  Future<void> _addStudent() async {
    final ClassListEntry? draft = await showModalBottomSheet<ClassListEntry>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) =>
          _AddStudentSheet(classListId: widget.list.id),
    );
    if (draft == null || !mounted) return;

    await _repo.addEntry(
      classListId: widget.list.id,
      fullName: draft.fullName,
      matricNumber: draft.matricNumber,
      email: draft.email,
      phone: draft.phone,
      note: draft.note,
      position: _entries.length,
    );
    await _load();
  }

  Future<void> _remove(ClassListEntry entry) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Remove ${entry.fullName}?'),
        content: const Text('This takes them off the class list.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColours.danger),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (!(confirm ?? false)) return;

    await _repo.removeEntry(
      classListId: widget.list.id,
      entryId: entry.id,
    );
    await _load();
  }

  Future<void> _export() async {
    if (_entries.isEmpty) {
      showEduvoraSnack(
        context,
        'Add a student or two before exporting.',
        isError: true,
      );
      return;
    }

    final String csv = ClassListCsv.build(widget.list, _entries);
    final String fileName = ClassListCsv.fileNameFor(widget.list);

    if (FileExport.isSupported) {
      final bool ok = await FileExport.downloadCsv(
        fileName: fileName,
        contents: csv,
      );
      if (!mounted) return;
      showEduvoraSnack(
        context,
        ok
            ? 'Downloading $fileName'
            : 'The download could not be started. Copy the list instead.',
        isError: !ok,
        icon: Icons.download_rounded,
      );
      return;
    }

    // No browser to hand a download to, so offer the clipboard instead of a
    // button that quietly does nothing.
    await Clipboard.setData(ClipboardData(text: csv));
    if (!mounted) return;
    showEduvoraSnack(
      context,
      'Class list copied as CSV — paste it into a spreadsheet or a message.',
      icon: Icons.copy_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String q = _query.trim().toLowerCase();
    final List<ClassListEntry> shown = q.isEmpty
        ? _entries
        : _entries
              .where(
                (ClassListEntry e) =>
                    e.fullName.toLowerCase().contains(q) ||
                    e.matricNumber.toLowerCase().contains(q),
              )
              .toList();

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: Text(
          widget.list.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _export,
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Export as CSV',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addStudent,
        backgroundColor: AppColours.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Add student'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                _header(),
                if (_entries.length > 5)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.screenPadding,
                      AppSpacing.md,
                      AppSpacing.screenPadding,
                      0,
                    ),
                    child: SearchField(
                      hint: 'Search by name or matric number',
                      onChanged: (String v) => setState(() => _query = v),
                    ),
                  ),
                Expanded(
                  child: shown.isEmpty
                      ? EmptyState(
                          icon: Icons.person_add_alt_rounded,
                          title: _entries.isEmpty
                              ? 'No students yet'
                              : 'Nobody matches that search',
                          message: _entries.isEmpty
                              ? 'Add your coursemates one at a time. Name is '
                                    'all that is required — matric number, '
                                    'email and phone are optional.'
                              : 'Try a different name or matric number.',
                          actionLabel: _entries.isEmpty ? 'Add student' : null,
                          onAction: _entries.isEmpty ? _addStudent : null,
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.screenPadding,
                            AppSpacing.md,
                            AppSpacing.screenPadding,
                            96,
                          ),
                          itemCount: shown.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (BuildContext context, int i) {
                            final ClassListEntry e = shown[i];
                            return _EntryRow(
                              index: _entries.indexOf(e) + 1,
                              entry: e,
                              onRemove: () => _remove(e),
                            );
                          },
                        ),
                ),
              ],
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
            Text(
              widget.list.name,
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.list.subtitle,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    '${_entries.length} '
                    '${_entries.length == 1 ? 'student' : 'students'}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                if (widget.list.hasGroup)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: AppRadii.pill,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(
                          Icons.groups_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Group chat ready',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EntryRow extends StatelessWidget {
  const _EntryRow({
    required this.index,
    required this.entry,
    required this.onRemove,
  });

  final int index;
  final ClassListEntry entry;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 26,
            child: Text(
              '$index',
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: AppColours.textFaint,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  entry.fullName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColours.text,
                  ),
                ),
                if (entry.matricNumber.isNotEmpty ||
                    entry.email.isNotEmpty ||
                    entry.phone.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 3),
                  Text(
                    <String>[
                      entry.matricNumber,
                      entry.email,
                      entry.phone,
                    ].where((String s) => s.isNotEmpty).join('  ·  '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColours.textMuted,
                    ),
                  ),
                ],
                if (entry.note.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Pill(label: entry.note, dense: true),
                ],
              ],
            ),
          ),
          IconButton(
            onPressed: onRemove,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.close_rounded,
              size: 18,
              color: AppColours.textFaint,
            ),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}

class _AddStudentSheet extends StatefulWidget {
  const _AddStudentSheet({required this.classListId});

  final String classListId;

  @override
  State<_AddStudentSheet> createState() => _AddStudentSheetState();
}

class _AddStudentSheetState extends State<_AddStudentSheet> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _matric = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _note = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _matric.dispose();
    _email.dispose();
    _phone.dispose();
    _note.dispose();
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
              'Add a student',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Only the name is required.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Full name'),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _matric,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Matriculation number',
                hintText: 'e.g. 2021/241056',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _note,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Note',
                hintText: 'Anything else the class needs to track',
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton(
              onPressed: () {
                if (_name.text.trim().length < 2) {
                  showEduvoraSnack(
                    context,
                    'Please enter the student’s name.',
                    isError: true,
                  );
                  return;
                }
                Navigator.of(context).pop(
                  ClassListEntry(
                    id: '',
                    classListId: widget.classListId,
                    fullName: _name.text,
                    matricNumber: _matric.text,
                    email: _email.text,
                    phone: _phone.text,
                    note: _note.text,
                  ),
                );
              },
              child: const Text('Add to class list'),
            ),
          ],
        ),
      ),
    );
  }
}
