import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/gpa.dart';
import '../../../../core/services/study_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../widgets/cgpa_trend_chart.dart';

/// Semester GPA and cumulative CGPA on the 5-point scale.
///
/// GPA = Σ (credit units × grade value) ⁄ Σ credit units, exactly as set out
/// in the Eduvora technical documentation.
class GpaCalculatorScreen extends StatefulWidget {
  const GpaCalculatorScreen({super.key});

  @override
  State<GpaCalculatorScreen> createState() => _GpaCalculatorScreenState();
}

class _GpaCalculatorScreenState extends State<GpaCalculatorScreen> {
  static const StudyRepository _study = StudyRepository();
  static const Uuid _uuid = Uuid();

  final List<CourseEntry> _courses = <CourseEntry>[];
  final TextEditingController _label = TextEditingController();

  List<SemesterRecord> _saved = <SemesterRecord>[];
  String? _editingId;

  @override
  void initState() {
    super.initState();
    _saved = _study.semesters();
    _label.text = 'Semester ${_saved.length + 1}';
    _addCourse();
  }

  @override
  void dispose() {
    _label.dispose();
    super.dispose();
  }

  void _addCourse() {
    setState(() {
      _courses.add(
        CourseEntry(id: _uuid.v4(), code: '', creditUnits: 3, grade: Grade.a),
      );
    });
  }

  void _removeCourse(String id) {
    setState(() => _courses.removeWhere((CourseEntry c) => c.id == id));
  }

  void _update(String id, CourseEntry updated) {
    final int index = _courses.indexWhere((CourseEntry c) => c.id == id);
    if (index >= 0) setState(() => _courses[index] = updated);
  }

  int get _totalUnits =>
      _courses.fold(0, (int sum, CourseEntry c) => sum + c.creditUnits);

  int get _totalPoints =>
      _courses.fold(0, (int sum, CourseEntry c) => sum + c.qualityPoints);

  double get _gpa => _totalUnits == 0 ? 0 : _totalPoints / _totalUnits;

  /// The CGPA this semester would produce once saved.
  double get _projectedCgpa {
    final List<SemesterRecord> others = _saved
        .where((SemesterRecord s) => s.id != _editingId)
        .toList();
    final int units = others.fold(
      _totalUnits,
      (int sum, SemesterRecord s) => sum + s.totalUnits,
    );
    if (units == 0) return 0;
    final int points = others.fold(
      _totalPoints,
      (int sum, SemesterRecord s) => sum + s.totalQualityPoints,
    );
    return points / units;
  }

  Future<void> _save() async {
    final List<CourseEntry> valid = _courses
        .where((CourseEntry c) => c.creditUnits > 0)
        .toList();
    if (valid.isEmpty) {
      showEduvoraSnack(
        context,
        'Add at least one course with its credit units first.',
        isError: true,
      );
      return;
    }

    final SemesterRecord record = SemesterRecord(
      id: _editingId ?? _uuid.v4(),
      label: _label.text.trim().isEmpty
          ? 'Semester ${_saved.length + 1}'
          : _label.text.trim(),
      courses: valid,
      savedAt: DateTime.now(),
    );

    await _study.saveSemester(record);
    if (!mounted) return;

    setState(() {
      _saved = _study.semesters();
      _editingId = null;
      _courses
        ..clear()
        ..add(
          CourseEntry(id: _uuid.v4(), code: '', creditUnits: 3, grade: Grade.a),
        );
      _label.text = 'Semester ${_saved.length + 1}';
    });

    showEduvoraSnack(
      context,
      'Saved. Your CGPA is now ${_study.cumulativeGpa().toStringAsFixed(2)}.',
      icon: Icons.save_rounded,
    );
  }

  void _loadForEdit(SemesterRecord record) {
    setState(() {
      _editingId = record.id;
      _label.text = record.label;
      _courses
        ..clear()
        ..addAll(record.courses);
    });
    showEduvoraSnack(
      context,
      'Editing "${record.label}". Save to update it.',
      icon: Icons.edit_rounded,
    );
  }

  Future<void> _delete(SemesterRecord record) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Remove ${record.label}?'),
        content: const Text(
          'This semester will no longer count towards your CGPA. You can '
          'always add it again.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep it'),
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

    await _study.deleteSemester(record.id);
    if (!mounted) return;
    setState(() => _saved = _study.semesters());
  }

  @override
  Widget build(BuildContext context) {
    final double cgpa = _study.cumulativeGpa();

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('GP calculator'),
        actions: <Widget>[
          IconButton(
            onPressed: _showScale,
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Grading scale',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: <Widget>[
          _resultCard(cgpa),
          if (_saved.length >= 2) ...<Widget>[
            const SectionHeader(
              title: 'Your trend',
              subtitle: 'GPA by semester, with your CGPA line',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: EduvoraCard(
                shadows: AppShadows.subtle,
                child: CgpaTrendChart(semesters: _saved, cgpa: cgpa),
              ),
            ),
          ],
          SectionHeader(
            title: _editingId == null ? 'This semester' : 'Editing semester',
            subtitle: 'Add each course with its credit units and grade',
            actionLabel: 'Add course',
            onAction: _addCourse,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _label,
                  decoration: const InputDecoration(
                    labelText: 'Semester name',
                    prefixIcon: Icon(Icons.label_outline_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                ..._courses.map(
                  (CourseEntry c) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _CourseRow(
                      key: ValueKey<String>(c.id),
                      entry: c,
                      canRemove: _courses.length > 1,
                      onChanged: (CourseEntry updated) =>
                          _update(c.id, updated),
                      onRemove: () => _removeCourse(c.id),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: _addCourse,
                  icon: const Icon(Icons.add_rounded, size: 19),
                  label: const Text('Add another course'),
                ),
              ],
            ),
          ),
          if (_saved.isNotEmpty) ...<Widget>[
            const SectionHeader(
              title: 'Saved semesters',
              subtitle: 'Tap to edit, swipe the bin to remove',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenPadding,
              ),
              child: Column(
                children: _saved
                    .map(
                      (SemesterRecord s) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: _SavedSemesterRow(
                          record: s,
                          isEditing: _editingId == s.id,
                          onTap: () => _loadForEdit(s),
                          onDelete: () => _delete(s),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          AppSpacing.md,
          AppSpacing.screenPadding,
          AppSpacing.lg,
        ),
        decoration: const BoxDecoration(
          color: AppColours.surface,
          border: Border(top: BorderSide(color: AppColours.border)),
        ),
        child: SafeArea(
          top: false,
          child: FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save_rounded, size: 19),
            label: Text(
              _editingId == null ? 'Save this semester' : 'Update semester',
            ),
          ),
        ),
      ),
    );
  }

  Widget _resultCard(double cgpa) {
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
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'This semester',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.72),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        _gpa.toStringAsFixed(2),
                        style: const TextStyle(
                          fontSize: 42,
                          height: 1.05,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1.6,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        Classification.of(_gpa),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColours.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 62,
                  color: Colors.white.withValues(alpha: 0.18),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _saved.isEmpty ? 'Projected CGPA' : 'Running CGPA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.72),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          (_saved.isEmpty ? _gpa : _projectedCgpa)
                              .toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 30,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          _saved.isEmpty
                              ? 'Save to begin tracking'
                              : 'With this semester included',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.66),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: AppRadii.sm,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _HeaderMetric(
                      value: '$_totalUnits',
                      label: 'Credit units',
                    ),
                  ),
                  Expanded(
                    child: _HeaderMetric(
                      value: '$_totalPoints',
                      label: 'Quality points',
                    ),
                  ),
                  Expanded(
                    child: _HeaderMetric(
                      value: '${_courses.length}',
                      label: 'Courses',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              Classification.encouragementFor(_gpa),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: Colors.white.withValues(alpha: 0.82),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showScale() {
    showModalBottomSheet<void>(
      context: context,
      // The full scale plus the classification bands is taller than a small
      // handset in landscape, so the sheet scrolls rather than overflowing.
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.sm,
            AppSpacing.xl,
            AppSpacing.xxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'The 5-point scale',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'GPA = Σ (credit units × grade value) ⁄ Σ credit units',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              ...Grade.values.map(
                (Grade g) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: _gradeColour(g).withValues(alpha: 0.12),
                          borderRadius: AppRadii.sm,
                        ),
                        child: Text(
                          g.letter,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _gradeColour(g),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          g.category,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColours.text,
                          ),
                        ),
                      ),
                      Text(
                        '${g.point} point${g.point == 1 ? '' : 's'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColours.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Degree classification',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'First Class from 4.50 · Second Class Upper from 3.50 · '
                'Second Class Lower from 2.40 · Third Class from 1.50',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(height: 1.6),
              ),
            ],
          ),
        );
      },
    );
  }

  static Color _gradeColour(Grade g) {
    switch (g) {
      case Grade.a:
        return AppColours.success;
      case Grade.b:
        return AppColours.info;
      case Grade.c:
        return AppColours.primary;
      case Grade.d:
        return AppColours.warning;
      case Grade.e:
        return AppColours.accent;
      case Grade.f:
        return AppColours.danger;
    }
  }
}

class _HeaderMetric extends StatelessWidget {
  const _HeaderMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

class _CourseRow extends StatefulWidget {
  const _CourseRow({
    super.key,
    required this.entry,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final CourseEntry entry;
  final bool canRemove;
  final ValueChanged<CourseEntry> onChanged;
  final VoidCallback onRemove;

  @override
  State<_CourseRow> createState() => _CourseRowState();
}

class _CourseRowState extends State<_CourseRow> {
  late final TextEditingController _code;

  @override
  void initState() {
    super.initState();
    _code = TextEditingController(text: widget.entry.code);
  }

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: TextField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              onChanged: (String v) =>
                  widget.onChanged(widget.entry.copyWith(code: v)),
              decoration: const InputDecoration(
                hintText: 'Course code',
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<int>(
              initialValue: widget.entry.creditUnits,
              isExpanded: true,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
              ),
              items: List<DropdownMenuItem<int>>.generate(
                12,
                (int i) => DropdownMenuItem<int>(
                  value: i + 1,
                  child: Text(
                    '${i + 1} u',
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              onChanged: (int? v) =>
                  widget.onChanged(widget.entry.copyWith(creditUnits: v ?? 1)),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 3,
            child: DropdownButtonFormField<Grade>(
              initialValue: widget.entry.grade,
              isExpanded: true,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 12,
                ),
              ),
              items: Grade.values
                  .map(
                    (Grade g) => DropdownMenuItem<Grade>(
                      value: g,
                      child: Text(
                        '${g.letter} (${g.point})',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (Grade? v) =>
                  widget.onChanged(widget.entry.copyWith(grade: v ?? Grade.a)),
            ),
          ),
          if (widget.canRemove)
            IconButton(
              onPressed: widget.onRemove,
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.remove_circle_outline_rounded,
                size: 19,
                color: AppColours.textFaint,
              ),
              tooltip: 'Remove course',
            ),
        ],
      ),
    );
  }
}

class _SavedSemesterRow extends StatelessWidget {
  const _SavedSemesterRow({
    required this.record,
    required this.isEditing,
    required this.onTap,
    required this.onDelete,
  });

  final SemesterRecord record;
  final bool isEditing;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      border: isEditing
          ? Border.all(color: AppColours.primary, width: 1.6)
          : null,
      child: Row(
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColours.primaryTint,
              borderRadius: AppRadii.sm,
            ),
            child: Text(
              record.gpa.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: AppColours.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  record.label,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColours.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${record.courses.length} courses · '
                  '${record.totalUnits} units · '
                  '${Classification.of(record.gpa)}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColours.textMuted,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            visualDensity: VisualDensity.compact,
            icon: const Icon(
              Icons.delete_outline_rounded,
              size: 19,
              color: AppColours.textFaint,
            ),
            tooltip: 'Remove semester',
          ),
        ],
      ),
    );
  }
}
