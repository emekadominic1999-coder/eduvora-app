import 'dart:async';

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
/// Two tabs: **Calculate** (add courses, tap grades, watch the GPA update)
/// and **My results** (every saved semester, the CGPA and the trend). The
/// semester being entered is saved automatically as a draft, so leaving and
/// coming back never loses it.
///
/// GPA = TCP ⁄ TNU, where TCP is the total credit points (credit units ×
/// grade point, summed) and TNU the total number of units registered.
class GpaCalculatorScreen extends StatefulWidget {
  const GpaCalculatorScreen({super.key});

  @override
  State<GpaCalculatorScreen> createState() => _GpaCalculatorScreenState();
}

class _GpaCalculatorScreenState extends State<GpaCalculatorScreen>
    with SingleTickerProviderStateMixin {
  static const StudyRepository _study = StudyRepository();
  static const Uuid _uuid = Uuid();

  late final TabController _tabs;
  final List<CourseEntry> _courses = <CourseEntry>[];
  final TextEditingController _label = TextEditingController();
  final TextEditingController _prevCgpa = TextEditingController();
  final TextEditingController _prevUnits = TextEditingController();
  final TextEditingController _nextUnits = TextEditingController(text: '24');

  List<SemesterRecord> _saved = <SemesterRecord>[];
  GpaSettings _settings = const GpaSettings();
  String? _editingId;
  DateTime? _editingSavedAt;
  double _target = 4.5;

  /// Bumped whenever the course list is replaced wholesale, so the rows
  /// rebuild their text fields from the new entries.
  int _rev = 0;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (mounted) setState(() {});
      });
    _saved = _study.semesters();
    _settings = _study.gpaSettings();
    if (_settings.hasPrevious) {
      _prevCgpa.text = _settings.previousCgpa.toStringAsFixed(2);
      _prevUnits.text = '${_settings.previousUnits}';
    }
    _restoreDraft();
    if (_courses.isEmpty) _courses.add(_blank());
    if (_label.text.trim().isEmpty) _label.text = _defaultLabel();
  }

  @override
  void dispose() {
    _tabs.dispose();
    _label.dispose();
    _prevCgpa.dispose();
    _prevUnits.dispose();
    _nextUnits.dispose();
    super.dispose();
  }

  String _defaultLabel() => 'Semester ${_saved.length + 1}';

  CourseEntry _blank() => CourseEntry(id: _uuid.v4(), code: '', creditUnits: 3);

  // -------------------------------------------------------------- the draft

  void _restoreDraft() {
    final Map<String, dynamic>? draft = _study.gpaDraft();
    if (draft == null) return;
    final String? editing = draft['editing_id'] as String?;
    final bool stillThere =
        editing != null && _saved.any((SemesterRecord s) => s.id == editing);
    _editingId = stillThere ? editing : null;
    _editingSavedAt = stillThere
        ? DateTime.tryParse((draft['editing_saved_at'] ?? '') as String)
        : null;
    _label.text = (draft['label'] ?? '') as String;
    final List<dynamic> raw = draft['courses'] as List<dynamic>? ?? <dynamic>[];
    _courses.addAll(
      raw.whereType<Map<dynamic, dynamic>>().map(
        (Map<dynamic, dynamic> e) =>
            CourseEntry.fromJson(Map<String, dynamic>.from(e)),
      ),
    );
  }

  void _persistDraft() {
    unawaited(
      _study.saveGpaDraft(<String, dynamic>{
        'label': _label.text,
        'editing_id': _editingId,
        'editing_saved_at': _editingSavedAt?.toIso8601String(),
        'courses': _courses.map((CourseEntry c) => c.toJson()).toList(),
      }),
    );
  }

  bool get _draftHasContent => _courses.any(
    (CourseEntry c) => c.code.trim().isNotEmpty || c.isGraded,
  );

  // ----------------------------------------------------------------- courses

  void _addCourse() {
    setState(() => _courses.add(_blank()));
    _persistDraft();
  }

  void _removeCourse(String id) {
    setState(() => _courses.removeWhere((CourseEntry c) => c.id == id));
    _persistDraft();
  }

  void _update(String id, CourseEntry updated) {
    final int index = _courses.indexWhere((CourseEntry c) => c.id == id);
    if (index < 0) return;
    setState(() => _courses[index] = updated);
    _persistDraft();
  }

  /// Throws the current entry away and starts a clean semester.
  void _startNew() {
    setState(() {
      _editingId = null;
      _editingSavedAt = null;
      _courses
        ..clear()
        ..add(_blank());
      _label.text = _defaultLabel();
      _rev++;
    });
    _persistDraft();
    _tabs.animateTo(0);
  }

  // ----------------------------------------------------------------- numbers

  List<CourseEntry> get _graded =>
      _courses.where((CourseEntry c) => c.isGraded && c.creditUnits > 0).toList();

  int get _totalUnits =>
      _graded.fold(0, (int sum, CourseEntry c) => sum + c.creditUnits);

  int get _totalPoints =>
      _graded.fold(0, (int sum, CourseEntry c) => sum + c.qualityPoints);

  double get _gpa => _totalUnits == 0 ? 0 : _totalPoints / _totalUnits;

  SemesterRecord _draft() => SemesterRecord(
    id: _editingId ?? 'draft',
    label: _label.text,
    courses: _graded,
    savedAt: _editingSavedAt ?? DateTime.now(),
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

  // ----------------------------------------------------------------- actions

  Future<void> _save() async {
    final List<CourseEntry> filled = _courses
        .where((CourseEntry c) => c.code.trim().isNotEmpty || c.isGraded)
        .toList();
    if (filled.any((CourseEntry c) => !c.isGraded)) {
      showEduvoraSnack(
        context,
        'Tap a grade (or type a score) for every course first.',
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
      label: _label.text.trim().isEmpty ? _defaultLabel() : _label.text.trim(),
      courses: valid,
      // Keep the original date when editing, so the semester stays in the
      // same place in the CGPA order.
      savedAt: _editingSavedAt ?? DateTime.now(),
    );

    await _study.saveSemester(record);
    await _study.clearGpaDraft();
    if (!mounted) return;

    setState(() {
      _saved = _study.semesters();
      _editingId = null;
      _editingSavedAt = null;
      _courses
        ..clear()
        ..add(_blank());
      _label.text = _defaultLabel();
      _rev++;
    });

    showEduvoraSnack(
      context,
      'Saved to My results. Your CGPA is now '
      '${_study.cumulativeGpa().toStringAsFixed(2)}.',
      icon: Icons.save_rounded,
    );
    _tabs.animateTo(1);
  }

  Future<void> _loadForEdit(SemesterRecord record) async {
    final bool replacing = _editingId != record.id && _draftHasContent;
    if (replacing) {
      final bool? go = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Replace what you are typing?'),
          content: const Text(
            'You have a semester you have not saved yet. Opening this one '
            'will replace it.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Keep mine'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Open it'),
            ),
          ],
        ),
      );
      if (!(go ?? false) || !mounted) return;
    }
    setState(() {
      _editingId = record.id;
      _editingSavedAt = record.savedAt;
      _label.text = record.label;
      _courses
        ..clear()
        ..addAll(record.courses);
      _rev++;
    });
    _persistDraft();
    _tabs.animateTo(0);
    showEduvoraSnack(
      context,
      'Editing "${record.label}". Change anything, then tap Update.',
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
    final bool wasEditing = _editingId == record.id;
    setState(() {
      _saved = _study.semesters();
      if (wasEditing) {
        _editingId = null;
        _editingSavedAt = null;
      }
    });
    if (wasEditing) _persistDraft();
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
        title: const Text('Add courses from which semester?'),
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
        showEduvoraSnack(context, 'Sign in to add your courses.', isError: true);
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
      _rev++;
    });
    _persistDraft();
    showEduvoraSnack(
      context,
      '${pick.length} courses added. Now tap your grade for each.',
      icon: Icons.download_done_rounded,
    );
  }

  // ---------------------------------------------------------------------- UI

  @override
  Widget build(BuildContext context) {
    final bool onCalculate = _tabs.index == 0;
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
        bottom: TabBar(
          controller: _tabs,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
          tabs: <Widget>[
            const Tab(text: 'Calculate'),
            Tab(
              text: _saved.isEmpty
                  ? 'My results'
                  : 'My results (${_saved.length})',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: <Widget>[_calculateTab(), _resultsTab()],
      ),
      bottomNavigationBar: onCalculate ? _calculateBar() : null,
    );
  }

  // ------------------------------------------------------------ Calculate tab

  Widget _calculateTab() {
    final CumulativeResult now = _projected;
    final Set<String> failedBefore = _failedBefore;
    final bool anyCarryover = _courses.any((CourseEntry c) => c.carryover);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.xxl,
      ),
      children: <Widget>[
        _howToCard(),
        if (_editingId != null) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          EduvoraCard(
            colour: AppColours.primaryTint,
            border: Border.all(color: AppColours.primary),
            padding: const EdgeInsets.all(AppSpacing.md),
            shadows: const <BoxShadow>[],
            child: Row(
              children: <Widget>[
                const Icon(Icons.edit_rounded, color: AppColours.primary, size: 19),
                const SizedBox(width: AppSpacing.sm),
                const Expanded(
                  child: Text(
                    'You are editing a saved semester. Tap Update to keep '
                    'your changes.',
                    style: TextStyle(fontSize: 12.5, height: 1.4),
                  ),
                ),
                TextButton(onPressed: _startNew, child: const Text('Cancel')),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        TextField(
          controller: _label,
          onChanged: (_) => _persistDraft(),
          decoration: const InputDecoration(
            labelText: 'Which semester is this?',
            hintText: 'e.g. 200L First Semester',
            prefixIcon: Icon(Icons.label_outline_rounded, size: 20),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: <Widget>[
            const Expanded(
              child: Text(
                'Your courses',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColours.text,
                ),
              ),
            ),
            if (_draftHasContent)
              TextButton.icon(
                onPressed: _startNew,
                icon: const Icon(Icons.refresh_rounded, size: 17),
                label: const Text('Start over'),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (int i = 0; i < _courses.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _CourseRow(
              key: ValueKey<String>('${_courses[i].id}-$_rev'),
              number: i + 1,
              entry: _courses[i],
              isResit: failedBefore.contains(_courses[i].key),
              canRemove: _courses.length > 1,
              onChanged: (CourseEntry updated) => _update(_courses[i].id, updated),
              onRemove: () => _removeCourse(_courses[i].id),
            ),
          ),
        Row(
          children: <Widget>[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _addCourse,
                icon: const Icon(Icons.add_rounded, size: 19),
                label: const Text('Add a course'),
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
        if (anyCarryover || _settings.replaceRetakenFails) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          EduvoraCard(
            shadows: AppShadows.subtle,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _settings.replaceRetakenFails,
              onChanged: (bool v) =>
                  _saveSettings(_settings.copyWith(replaceRetakenFails: v)),
              title: const Text(
                'My school removes the old F once I pass',
                style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Off: the F and the new grade both count (the usual rule). '
                'On: the old F is taken out once you pass the course again. '
                'Check your result slip if you are not sure.',
                style: TextStyle(fontSize: 12, height: 1.4),
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        _workingCard(now),
        const SizedBox(height: AppSpacing.md),
        _previousResultsCard(),
        const SizedBox(height: AppSpacing.md),
        Center(
          child: Text(
            'Everything you type here is saved automatically.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _howToCard() {
    Widget step(int n, String text) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColours.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$n',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: AppColours.text,
              ),
            ),
          ),
        ],
      ),
    );

    return EduvoraCard(
      colour: AppColours.primaryTint,
      shadows: const <BoxShadow>[],
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _saved.isEmpty && !_draftHasContent,
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.sm,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: const Icon(Icons.lightbulb_outline_rounded, color: AppColours.primary),
          title: const Text(
            'How to use this',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
          ),
          subtitle: const Text('Three easy steps', style: TextStyle(fontSize: 12)),
          children: <Widget>[
            step(
              1,
              'Add a course for every subject you took this semester. Type '
              'its code, like PHY 102.',
            ),
            step(
              2,
              'Set its units with + and − (it is the number next to the '
              'course on your outline, usually 1 to 4). Then tap the grade '
              'you got. If you only know your score, type it in and the '
              'grade is filled for you.',
            ),
            step(
              3,
              'Your GPA shows at the bottom of the screen. Tap Save and it '
              'goes into My results, where you can open it again any time.',
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                'Failed a course before and retaking it? Tick "Carryover" on '
                'that course.',
                style: TextStyle(fontSize: 13, height: 1.45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Shows the sums behind the GPA, so it never feels like a black box.
  Widget _workingCard(CumulativeResult now) {
    final List<CourseEntry> graded = _graded;
    final bool hasHistory = _others.isNotEmpty || _settings.hasPrevious;
    return EduvoraCard(
      shadows: AppShadows.subtle,
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: const Text(
            'See how this GPA is worked out',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          subtitle: const Text(
            'Units × grade point, added up',
            style: TextStyle(fontSize: 12),
          ),
          children: <Widget>[
            if (graded.isEmpty)
              const Text(
                'Tap a grade on at least one course and the working appears '
                'here.',
                style: TextStyle(fontSize: 13, height: 1.45),
              )
            else ...<Widget>[
              for (final CourseEntry c in graded)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          c.code.trim().isEmpty ? 'Course' : c.code.trim().toUpperCase(),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${c.creditUnits} units × ${c.grade!.letter} (${c.grade!.point})',
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: AppColours.textMuted,
                        ),
                      ),
                      SizedBox(
                        width: 64,
                        child: Text(
                          '= ${c.qualityPoints}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(),
              Text(
                'Total points $_totalPoints ÷ total units $_totalUnits = '
                '${_gpa.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                  color: AppColours.primary,
                ),
              ),
              if (hasHistory) ...<Widget>[
                const SizedBox(height: 6),
                Text(
                  'With your earlier semesters, CGPA = ${now.points} ÷ '
                  '${now.units} = ${now.cgpa.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.45,
                    color: AppColours.textMuted,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _previousResultsCard() {
    return EduvoraCard(
      shadows: AppShadows.subtle,
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _settings.hasPrevious,
          tilePadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: const Text(
            'I already have results from before',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          subtitle: const Text(
            'Start from the CGPA on your last result slip',
            style: TextStyle(fontSize: 12),
          ),
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
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                    ],
                    onChanged: (_) => _onPreviousChanged(),
                    decoration: const InputDecoration(
                      labelText: 'CGPA on my last slip',
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
                      labelText: 'Total units (TNU)',
                      hintText: 'e.g. 96',
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Both numbers are on your last result slip. Leave them blank '
              'if you are adding every semester here. If an old F is inside '
              'that CGPA and you are retaking the course, tick "Carryover" '
              'on it above.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  /// The bar that stays at the bottom while calculating: the answer, always
  /// in view, and the Save button.
  Widget _calculateBar() {
    final CumulativeResult now = _projected;
    final bool any = _totalUnits > 0;
    Widget stat(String label, String value, String note) => Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColours.textMuted,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              height: 1.15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              color: AppColours.primary,
            ),
          ),
          Text(
            note,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11.5, color: AppColours.textMuted),
          ),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.md,
      ),
      decoration: const BoxDecoration(
        color: AppColours.surface,
        border: Border(top: BorderSide(color: AppColours.border)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                stat(
                  'This semester GPA',
                  any ? _gpa.toStringAsFixed(2) : '–',
                  any ? Classification.of(_gpa) : 'Tap a grade to start',
                ),
                Container(width: 1, height: 52, color: AppColours.border),
                const SizedBox(width: AppSpacing.lg),
                stat(
                  'Your CGPA',
                  now.units > 0 ? now.cgpa.toStringAsFixed(2) : '–',
                  now.units > 0 ? Classification.of(now.cgpa) : 'Not yet',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save_rounded, size: 19),
                label: Text(
                  _editingId == null ? 'Save this semester' : 'Update semester',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------- My results tab

  Widget _resultsTab() {
    final CumulativeResult total = GpaEngine.cumulative(_saved, _settings);
    final bool empty = _saved.isEmpty && !_settings.hasPrevious;

    if (empty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.history_edu_rounded,
                size: 52,
                color: AppColours.textFaint,
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                'Nothing saved yet',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Work out a semester on the Calculate tab and tap Save. It '
                'will be kept here, with your CGPA, so you can come back to '
                'it any time.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  height: 1.5,
                  color: AppColours.textMuted,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FilledButton(
                onPressed: () => _tabs.animateTo(0),
                child: const Text('Calculate a semester'),
              ),
            ],
          ),
        ),
      );
    }

    final List<SemesterRecord> newestFirst = _saved.reversed.toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        AppSpacing.xxl,
      ),
      children: <Widget>[
        _cgpaCard(total),
        if (total.carryovers.isNotEmpty) ...<Widget>[
          const SizedBox(height: AppSpacing.md),
          _carryoverCard(total.carryovers),
        ],
        if (_saved.length >= 2) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          const Text(
            'Your progress',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.sm),
          EduvoraCard(
            shadows: AppShadows.subtle,
            child: CgpaTrendChart(semesters: _saved, cgpa: total.cgpa),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        const Text(
          'Your semesters',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 2),
        Text(
          'Tap a semester to see its courses',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.sm),
        for (final SemesterRecord s in newestFirst)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _SavedSemesterTile(
              record: s,
              isEditing: _editingId == s.id,
              onEdit: () => _loadForEdit(s),
              onDelete: () => _delete(s),
            ),
          ),
        if (_settings.hasPrevious)
          EduvoraCard(
            shadows: AppShadows.subtle,
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: <Widget>[
                const Icon(Icons.history_rounded, color: AppColours.textMuted),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Results from before the app: CGPA '
                    '${_settings.previousCgpa.toStringAsFixed(2)} over '
                    '${_settings.previousUnits} units',
                    style: const TextStyle(fontSize: 12.5, height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: _startNew,
          icon: const Icon(Icons.add_rounded, size: 19),
          label: const Text('Add another semester'),
        ),
        if (total.units > 0) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          _plannerCard(total),
        ],
      ],
    );
  }

  Widget _cgpaCard(CumulativeResult total) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColours.brandGradient,
        borderRadius: AppRadii.lg,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Your CGPA',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            total.cgpa.toStringAsFixed(2),
            style: const TextStyle(
              fontSize: 48,
              height: 1.1,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.6,
              color: Colors.white,
            ),
          ),
          Text(
            Classification.of(total.cgpa),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColours.accent,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: AppRadii.sm,
            ),
            child: Text(
              '${_saved.length} semester${_saved.length == 1 ? '' : 's'} saved · '
              '${total.units} units counted · ${total.unitsPassed} passed',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            Classification.encouragementFor(total.cgpa),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: Colors.white.withValues(alpha: 0.82),
            ),
          ),
        ],
      ),
    );
  }

  Widget _carryoverCard(List<String> carryovers) {
    return EduvoraCard(
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
                  '${carryovers.length} carryover${carryovers.length == 1 ? '' : 's'} still to clear',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColours.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${carryovers.join(', ')}. When you retake one, add it again '
                  'in that semester with its new grade and tick "Carryover".',
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
    if (needed == null) {
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
          const Text(
            'What GPA do I need next semester?',
            style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSpacing.md),
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
            width: 190,
            child: TextField(
              controller: _nextUnits,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Units you will take next',
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
                'How GPA works',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Each grade is worth points. Multiply those points by the '
                'course units, add them all up, then divide by the total '
                'units.\n\n'
                'Example: PHY 102 (3 units, grade B) and MTH 102 (2 units, '
                'grade A).\n'
                '3 × 4 = 12 and 2 × 5 = 10, so total points = 22.\n'
                'Total units = 5. GPA = 22 ÷ 5 = 4.40.\n\n'
                'TNU = total units · TCP = total credit points · GPA = TCP ÷ TNU',
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
                'If you failed a course (carryover)',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '• An F counts with 0 points, and its units still count, so '
                'it lowers that semester\'s GPA.\n'
                '• When you retake it, add the course again in the semester '
                'you take it, enter the new grade and tick "Carryover".\n'
                '• Usually both attempts stay in your CGPA. If your school '
                'removes the old F once you pass, switch on "My school '
                'removes the old F once I pass".\n'
                '• Check your result slip: the units and points there should '
                'match the numbers here.\n'
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

class _CourseRow extends StatefulWidget {
  const _CourseRow({
    super.key,
    required this.number,
    required this.entry,
    required this.isResit,
    required this.canRemove,
    required this.onChanged,
    required this.onRemove,
  });

  final int number;
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
    final Grade? grade = entry.grade;
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColours.primaryTint,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${widget.number}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w800,
                    color: AppColours.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
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
                  tooltip: 'Remove this course',
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              const Text(
                'Units',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColours.textMuted,
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: entry.creditUnits > 1
                    ? () => widget.onChanged(
                        entry.copyWith(creditUnits: entry.creditUnits - 1),
                      )
                    : null,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.remove_circle_outline_rounded),
                tooltip: 'Fewer units',
              ),
              SizedBox(
                width: 22,
                child: Text(
                  '${entry.creditUnits}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColours.text,
                  ),
                ),
              ),
              IconButton(
                onPressed: entry.creditUnits < 12
                    ? () => widget.onChanged(
                        entry.copyWith(creditUnits: entry.creditUnits + 1),
                      )
                    : null,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.add_circle_outline_rounded),
                tooltip: 'More units',
              ),
              const Spacer(),
              SizedBox(
                width: 118,
                child: TextField(
                  controller: _score,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  onChanged: _onScore,
                  decoration: const InputDecoration(
                    labelText: 'Score (optional)',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          const Text(
            'Tap your grade',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColours.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: <Widget>[
              for (final Grade g in Grade.values)
                ChoiceChip(
                  label: Text(
                    g.letter,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  showCheckmark: false,
                  selected: grade == g,
                  onSelected: (_) {
                    _score.clear();
                    widget.onChanged(entry.copyWith(grade: g, clearScore: true));
                  },
                ),
            ],
          ),
          if (grade != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                '${grade.category} · ${entry.creditUnits} units × '
                '${grade.point} = ${entry.qualityPoints} points',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: AppColours.textMuted,
                ),
              ),
            ),
          const SizedBox(height: 4),
          CheckboxListTile(
            value: entry.carryover,
            onChanged: (bool? v) =>
                widget.onChanged(entry.copyWith(carryover: v ?? false)),
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              widget.isResit && !entry.carryover
                  ? 'Carryover: I failed this before (tick if so)'
                  : 'Carryover: I failed this before and am retaking it',
              style: const TextStyle(fontSize: 12.5, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }
}

/// One saved semester in My results: tap to see its courses, with Edit and
/// Remove inside.
class _SavedSemesterTile extends StatelessWidget {
  const _SavedSemesterTile({
    required this.record,
    required this.isEditing,
    required this.onEdit,
    required this.onDelete,
  });

  final SemesterRecord record;
  final bool isEditing;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final int fails = record.failedCount;
    return EduvoraCard(
      shadows: AppShadows.subtle,
      padding: EdgeInsets.zero,
      border: isEditing
          ? Border.all(color: AppColours.primary, width: 1.6)
          : null,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 2,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: Container(
            width: 50,
            height: 46,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColours.primaryTint,
              borderRadius: AppRadii.sm,
            ),
            child: Text(
              record.gpa.toStringAsFixed(2),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: AppColours.primary,
              ),
            ),
          ),
          title: Text(
            record.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColours.text,
            ),
          ),
          subtitle: Text(
            '${record.courses.length} courses · ${record.totalUnits} units · '
            '${Classification.of(record.gpa)}'
            '${fails > 0 ? ' · $fails failed' : ''}',
            style: const TextStyle(fontSize: 11.5, color: AppColours.textMuted),
          ),
          children: <Widget>[
            for (final CourseEntry c in record.courses)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${c.code.trim().toUpperCase()}'
                        '${c.carryover ? '  (carryover)' : ''}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${c.creditUnits} units',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppColours.textMuted,
                      ),
                    ),
                    SizedBox(
                      width: 56,
                      child: Text(
                        c.grade?.letter ?? '–',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: c.grade == Grade.f
                              ? AppColours.danger
                              : AppColours.text,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_rounded, size: 17),
                    label: const Text('Open and edit'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColours.danger,
                  ),
                  tooltip: 'Remove semester',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
