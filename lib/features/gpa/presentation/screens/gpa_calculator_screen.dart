import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/models/course_outline.dart';
import '../../../../core/models/gpa.dart';
import '../../../../core/services/course_repository.dart';
import '../../../../core/services/study_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../widgets/cgpa_trend_chart.dart';

/// Semester GPA and cumulative CGPA on the Nigerian 5-point scale.
///
/// GPA = TCP ⁄ TNU, where TCP is the total credit points (credit units ×
/// grade point, summed) and TNU the total number of units registered. Failed
/// courses count with 0 points, and a resit is recorded in the semester it is
/// taken, so both attempts stay in the record unless the student's school
/// replaces the F (a switch below).
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
  final TextEditingController _prevCgpa = TextEditingController();
  final TextEditingController _prevUnits = TextEditingController();
  final TextEditingController _nextUnits = TextEditingController(text: '24');

  List<SemesterRecord> _saved = <SemesterRecord>[];
  GpaSettings _settings = const GpaSettings();
  String? _editingId;
  double _target = 4.5;

  @override
  void initState() {
    super.initState();
    _saved = _study.semesters();
    _settings = _study.gpaSettings();
    if (_settings.hasPrevious) {
      _prevCgpa.text = _settings.previousCgpa.toStringAsFixed(2);
      _prevUnits.text = '${_settings.previousUnits}';
    }
    _label.text = 'Semester ${_saved.length + 1}';
    _addCourse();
  }

  @override
  void dispose() {
    _label.dispose();
    _prevCgpa.dispose();
    _prevUnits.dispose();
    _nextUnits.dispose();
    super.dispose();
  }

  CourseEntry _blank() => CourseEntry(id: _uuid.v4(), code: '', creditUnits: 2);

  void _addCourse() => setState(() => _courses.add(_blank()));

  void _removeCourse(String id) {
    setState(() => _courses.removeWhere((CourseEntry c) => c.id == id));
  }

  void _update(String id, CourseEntry updated) {
    final int index = _courses.indexWhere((CourseEntry c) => c.id == id);
    if (index >= 0) setState(() => _courses[index] = updated);
  }

  // ------------------------------------------------------------- numbers

  List<CourseEntry> get _graded =>
      _courses.where((CourseEntry c) => c.isGraded && c.creditUnits > 0).toList();

  int get _totalUnits =>
      _graded.fold(0, (int sum, CourseEntry c) => sum + c.creditUnits);

  int get _totalPoints =>
      _graded.fold(0, (int sum, CourseEntry c) => sum + c.qualityPoints);

  int get _unitsPassed => _graded
      .where((CourseEntry c) => c.grade != Grade.f)
      .fold(0, (int sum, CourseEntry c) => sum + c.creditUnits);

  double get _gpa => _totalUnits == 0 ? 0 : _totalPoints / _totalUnits;

  SemesterRecord _draft() => SemesterRecord(
    id: _editingId ?? 'draft',
    label: _label.text,
    courses: _graded,
    savedAt: DateTime.now(),
  );

  List<SemesterRecord> get _others =>
      _saved.where((SemesterRecord s) => s.id != _editingId).toList();

  /// The cumulative position if this semester were saved now.
  CumulativeResult get _projected =>
      GpaEngine.cumulative(_others, _settings, extra: _draft());

  /// Codes that already carry an F in an earlier saved semester.
  Set<String> get _failedBefore {
    final Set<String> out = <String>{};
    for (final SemesterRecord s in _others) {
      for (final CourseEntry c in s.courses) {
        if (c.grade == Grade.f && c.key.isNotEmpty) out.add(c.key);
      }
    }
    return out;
  }

  // ------------------------------------------------------------ actions

  Future<void> _save() async {
    final List<CourseEntry> filled = _courses
        .where((CourseEntry c) => c.code.trim().isNotEmpty || c.isGraded)
        .toList();
    if (filled.any((CourseEntry c) => !c.isGraded)) {
      showEduvoraSnack(
        context,
        'Choose a grade (or type a score) for every course first.',
        isError: true,
      );
      return;
    }
    final List<CourseEntry> valid = filled
        .where((CourseEntry c) => c.creditUnits > 0)
        .toList();
    if (valid.isEmpty) {
      showEduvoraSnack(
        context,
        'Add at least one course with its units and grade first.',
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
        ..add(_blank());
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
    setState(() {
      _saved = _study.semesters();
      if (_editingId == record.id) _editingId = null;
    });
  }

  Future<void> _saveSettings(GpaSettings next) async {
    setState(() => _settings = next);
    await _study.saveGpaSettings(next);
  }

  void _onPreviousChanged() {
    final double cgpa = double.tryParse(_prevCgpa.text.trim()) ?? 0;
    final int units = int.tryParse(_prevUnits.text.trim()) ?? 0;
    _saveSettings(
      _settings.copyWith(
        previousCgpa: cgpa.clamp(0, 5).toDouble(),
        previousUnits: units,
      ),
    );
  }

  /// Fills the semester with the student's own registered courses so the
  /// units are right and only the grades are left to enter.
  Future<void> _importFromOutline() async {
    final Semester? semester = await showDialog<Semester>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Import which semester?'),
        children: <Widget>[
          for (final Semester s in Semester.values)
            SimpleDialogOption(
              onPressed: () => Navigator.of(context).pop(s),
              child: Text(s.label),
            ),
        ],
      ),
    );
    if (semester == null || !mounted) return;

    await sessionController.ensureLoaded();
    final profile = sessionController.profile;
    if (profile == null) {
      if (mounted) {
        showEduvoraSnack(context, 'Sign in to import your courses.', isError: true);
      }
      return;
    }
    List<CourseOutline> outline;
    try {
      outline = await const CourseRepository().forStudent(profile);
    } catch (_) {
      outline = <CourseOutline>[];
    }
    if (!mounted) return;
    final Set<String> have = _courses.map((CourseEntry c) => c.key).toSet();
    final List<CourseOutline> pick = outline
        .where((CourseOutline c) => c.semester == semester)
        .where(
          (CourseOutline c) =>
              !have.contains(c.courseCode.replaceAll(RegExp(r'\s+'), '').toUpperCase()),
        )
        .toList();
    if (pick.isEmpty) {
      showEduvoraSnack(
        context,
        'No courses found for ${semester.label.toLowerCase()} in your outline.',
        isError: true,
      );
      return;
    }
    setState(() {
      _courses.removeWhere((CourseEntry c) => c.code.trim().isEmpty && !c.isGraded);
      for (final CourseOutline c in pick) {
        _courses.add(
          CourseEntry(
            id: _uuid.v4(),
            code: c.courseCode,
            creditUnits: c.creditUnits > 0 ? c.creditUnits : 2,
          ),
        );
      }
    });
    showEduvoraSnack(
      context,
      '${pick.length} courses added. Now choose your grade for each.',
      icon: Icons.download_done_rounded,
    );
  }

  // ---------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final CumulativeResult now = _projected;
    final CumulativeResult savedOnly = GpaEngine.cumulative(_saved, _settings);
    final bool hasHistory = _saved.isNotEmpty || _settings.hasPrevious;
    final Set<String> failedBefore = _failedBefore;

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('GP calculator'),
        actions: <Widget>[
          IconButton(
            onPressed: _showScale,
            icon: const Icon(Icons.help_outline_rounded),
            tooltip: 'Grading scale and rules',
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
          _resultCard(now, hasHistory),
          if (now.carryovers.isNotEmpty) _carryoverCard(now.carryovers),
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
                child: CgpaTrendChart(
                  semesters: _saved,
                  cgpa: savedOnly.cgpa,
                ),
              ),
            ),
          ],
          SectionHeader(
            title: _editingId == null ? 'This semester' : 'Editing semester',
            subtitle: 'Enter each course, its units and your grade or score',
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
                    hintText: 'e.g. 200L First Semester',
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
                      isResit: failedBefore.contains(c.key),
                      canRemove: _courses.length > 1,
                      onChanged: (CourseEntry updated) =>
                          _update(c.id, updated),
                      onRemove: () => _removeCourse(c.id),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _addCourse,
                        icon: const Icon(Icons.add_rounded, size: 19),
                        label: const Text('Add course'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _importFromOutline,
                        icon: const Icon(Icons.download_rounded, size: 19),
                        label: const Text('From my outline'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SectionHeader(
            title: 'Results before this app',
            subtitle: 'Already have a CGPA from earlier sessions? Start from it',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: EduvoraCard(
              shadows: AppShadows.subtle,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: _prevCgpa,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.]'),
                            ),
                          ],
                          onChanged: (_) => _onPreviousChanged(),
                          decoration: const InputDecoration(
                            labelText: 'Previous CGPA',
                            hintText: 'e.g. 3.85',
                            isDense: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: TextField(
                          controller: _prevUnits,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (_) => _onPreviousChanged(),
                          decoration: const InputDecoration(
                            labelText: 'Total units so far',
                            hintText: 'e.g. 96',
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Found on your last result slip as CGPA and TNU (total '
                    'number of units). Leave blank if you are entering every '
                    'semester here.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(height: AppSpacing.xl),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _settings.replaceRetakenFails,
                    onChanged: (bool v) =>
                        _saveSettings(_settings.copyWith(replaceRetakenFails: v)),
                    title: const Text(
                      'My school drops an F once I pass the resit',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text(
                      'Off is the usual rule: every attempt stays in your '
                      'record, so the F and the resit both count. Turn on only '
                      'if your result slips show the F removed.',
                      style: TextStyle(fontSize: 12, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SectionHeader(
            title: 'Set a target',
            subtitle: 'What GPA do you need next semester?',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            child: _plannerCard(now),
          ),
          if (_saved.isNotEmpty) ...<Widget>[
            const SectionHeader(
              title: 'Saved semesters',
              subtitle: 'Tap to edit, use the bin to remove',
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

  Widget _carryoverCard(List<String> carryovers) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        0,
      ),
      child: EduvoraCard(
        colour: AppColours.accentSoft,
        border: Border.all(color: AppColours.accent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(Icons.flag_rounded, color: AppColours.accent, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '${carryovers.length} carryover${carryovers.length == 1 ? '' : 's'} to clear',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColours.text,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${carryovers.join(', ')}. Add each one again in the '
                    'semester you resit it, with its new grade.',
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.45,
                      color: AppColours.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _plannerCard(CumulativeResult now) {
    final int next = int.tryParse(_nextUnits.text.trim()) ?? 0;
    final double? needed = GpaEngine.neededGpa(
      target: _target,
      unitsSoFar: now.units,
      pointsSoFar: now.points,
      nextUnits: next,
    );
    String message;
    Color colour = AppColours.textMuted;
    if (now.units == 0) {
      message = 'Add some graded courses first, then see what you need.';
    } else if (needed == null) {
      message = 'Enter the number of units you will register next semester.';
    } else if (needed <= 0) {
      message =
          'Your CGPA is already safe for ${_target.toStringAsFixed(2)}, even '
          'with a poor next semester.';
      colour = AppColours.success;
    } else if (needed > 5) {
      message =
          'Even straight A\'s over $next units would not reach '
          '${_target.toStringAsFixed(2)} in one semester (it needs '
          '${needed.toStringAsFixed(2)}). Spread it over more semesters.';
      colour = AppColours.danger;
    } else {
      message =
          'You need a GPA of ${needed.toStringAsFixed(2)} over your next '
          '$next units to reach a CGPA of ${_target.toStringAsFixed(2)}.';
      colour = AppColours.primary;
    }
    const List<double> targets = <double>[4.5, 3.5, 2.4, 1.5];
    return EduvoraCard(
      shadows: AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: <Widget>[
              for (final double t in targets)
                ChoiceChip(
                  label: Text(
                    '${t.toStringAsFixed(2)} · ${Classification.of(t)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  selected: _target == t,
                  onSelected: (_) => setState(() => _target = t),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SizedBox(
            width: 170,
            child: TextField(
              controller: _nextUnits,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Next semester units',
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            message,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: colour,
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultCard(CumulativeResult now, bool hasHistory) {
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
                        'This semester GPA',
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
                          hasHistory ? 'CGPA with this' : 'CGPA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.72),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          now.cgpa.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 30,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          Classification.of(now.cgpa),
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
                    child: _HeaderMetric(value: '$_totalUnits', label: 'TNU'),
                  ),
                  Expanded(
                    child: _HeaderMetric(value: '$_totalPoints', label: 'TCP'),
                  ),
                  Expanded(
                    child: _HeaderMetric(
                      value: '$_unitsPassed',
                      label: 'Units passed',
                    ),
                  ),
                  Expanded(
                    child: _HeaderMetric(
                      value: '${_graded.length}',
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
      // The full scale plus the rules is taller than a small handset in
      // landscape, so the sheet scrolls rather than overflowing.
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
                'TNU = total units registered\n'
                'TCP = total credit points (units × grade point)\n'
                'GPA = TCP ÷ TNU',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.6,
                ),
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
                          '${g.category} · ${g.scoreBand}',
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
                'First Class 4.50 – 5.00 · Second Class Upper 3.50 – 4.49 · '
                'Second Class Lower 2.40 – 3.49 · Third Class 1.50 – 2.39 · '
                'Pass 1.00 – 1.49',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(height: 1.6),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Divider(),
              const SizedBox(height: AppSpacing.md),
              Text(
                'If you failed a course',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '• An F counts with 0 points, and its units still count in '
                'TNU, so it lowers that semester\'s GPA.\n'
                '• When you resit it, enter the course again in the semester '
                'you take it, with the new grade.\n'
                '• Usually both attempts stay in your CGPA. If your school '
                'removes the F once you pass, switch on "My school drops an F" '
                'under Results before this app.\n'
                '• Check your result slip: TNU and TCP there should match the '
                'numbers here.\n'
                '• Grade bands and rules can differ slightly between schools; '
                'your school\'s own result is the official one.',
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
          textAlign: TextAlign.center,
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
    required this.isResit,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final CourseEntry entry;
  final bool isResit;
  final bool canRemove;
  final ValueChanged<CourseEntry> onChanged;
  final VoidCallback onRemove;

  @override
  State<_CourseRow> createState() => _CourseRowState();
}

class _CourseRowState extends State<_CourseRow> {
  late final TextEditingController _code;
  late final TextEditingController _score;

  @override
  void initState() {
    super.initState();
    _code = TextEditingController(text: widget.entry.code);
    _score = TextEditingController(
      text: widget.entry.score == null ? '' : '${widget.entry.score}',
    );
  }

  @override
  void dispose() {
    _code.dispose();
    _score.dispose();
    super.dispose();
  }

  void _onScore(String text) {
    final int? value = int.tryParse(text.trim());
    if (text.trim().isEmpty) {
      widget.onChanged(widget.entry.copyWith(clearScore: true));
    } else if (value != null && value >= 0 && value <= 100) {
      widget.onChanged(
        widget.entry.copyWith(score: value, grade: Grade.fromScore(value)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final CourseEntry entry = widget.entry;
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _code,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (String v) =>
                      widget.onChanged(entry.copyWith(code: v)),
                  decoration: const InputDecoration(
                    hintText: 'Course code, e.g. PHY 102',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
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
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: DropdownButtonFormField<int>(
                  initialValue: entry.creditUnits,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Units',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                  items: List<DropdownMenuItem<int>>.generate(
                    12,
                    (int i) => DropdownMenuItem<int>(
                      value: i + 1,
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  onChanged: (int? v) =>
                      widget.onChanged(entry.copyWith(creditUnits: v ?? 1)),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _score,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  onChanged: _onScore,
                  decoration: const InputDecoration(
                    labelText: 'Score',
                    hintText: '0–100',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                flex: 4,
                child: DropdownButtonFormField<Grade>(
                  key: ValueKey<Grade?>(entry.grade),
                  initialValue: entry.grade,
                  isExpanded: true,
                  hint: const Text('Grade', style: TextStyle(fontSize: 13)),
                  decoration: const InputDecoration(
                    labelText: 'Grade',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
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
                  onChanged: (Grade? v) {
                    _score.clear();
                    widget.onChanged(
                      entry.copyWith(grade: v, clearScore: true),
                    );
                  },
                ),
              ),
            ],
          ),
          if (widget.isResit && entry.key.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.replay_rounded,
                    size: 14,
                    color: AppColours.accent,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Resit: you have an earlier F in ${entry.code.trim().toUpperCase()}',
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColours.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
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
    final int fails = record.failedCount;
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
                  '${Classification.of(record.gpa)}'
                  '${fails > 0 ? ' · $fails failed' : ''}',
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
