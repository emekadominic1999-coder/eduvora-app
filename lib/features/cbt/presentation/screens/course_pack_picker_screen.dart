import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// What the student picked, handed back to whoever pushed this screen.
class CoursePackSelection {
  const CoursePackSelection({
    required this.subjects,
    required this.department,
    required this.level,
    required this.semester,
  });

  final List<CbtSubject> subjects;
  final String department;
  final String level;
  final String semester;

  int get totalUnits =>
      subjects.fold(0, (int sum, CbtSubject s) => sum + s.units);
}

/// Lets the student build their own course pack: department, level and
/// semester first, then a checklist of only the papers that actually exist
/// for that combination, capped at a real semester's course load.
///
/// [allSubjects] should already be loaded (the CBT home screen has it).
Future<CoursePackSelection?> showCoursePackPicker(
  BuildContext context,
  List<CbtSubject> allSubjects,
) {
  return Navigator.of(context).push<CoursePackSelection>(
    MaterialPageRoute<CoursePackSelection>(
      builder: (_) => CoursePackPickerScreen(allSubjects: allSubjects),
    ),
  );
}

class CoursePackPickerScreen extends StatefulWidget {
  const CoursePackPickerScreen({super.key, required this.allSubjects});

  final List<CbtSubject> allSubjects;

  /// The real course-registration cap a pack can never exceed.
  static const int maxUnits = 23;

  @override
  State<CoursePackPickerScreen> createState() =>
      _CoursePackPickerScreenState();
}

class _CoursePackPickerScreenState extends State<CoursePackPickerScreen> {
  String? _department;
  String? _level;
  String? _semester;
  final Set<String> _selectedIds = <String>{};

  List<CbtSubject> get _withDepartment => widget.allSubjects
      .where((CbtSubject s) => s.department.isNotEmpty)
      .toList();

  List<String> get _departments =>
      _withDepartment.map((CbtSubject s) => s.department).toSet().toList()
        ..sort();

  List<String> get _levels => _withDepartment
      .where((CbtSubject s) => s.department == _department)
      .map((CbtSubject s) => s.level)
      .where((String l) => l.isNotEmpty)
      .toSet()
      .toList()
    ..sort();

  List<String> get _semesters => _withDepartment
      .where((CbtSubject s) => s.department == _department && s.level == _level)
      .map((CbtSubject s) => s.semester)
      .where((String sem) => sem.isNotEmpty)
      .toSet()
      .toList()
    ..sort();

  List<CbtSubject> get _available => _withDepartment
      .where(
        (CbtSubject s) =>
            s.department == _department &&
            s.level == _level &&
            s.semester == _semester,
      )
      .toList();

  int get _selectedUnits => _available
      .where((CbtSubject s) => _selectedIds.contains(s.id))
      .fold(0, (int sum, CbtSubject s) => sum + s.units);

  @override
  void initState() {
    super.initState();
    final String? profileDepartment = sessionController.profile?.department;
    if (profileDepartment != null && _departments.contains(profileDepartment)) {
      _department = profileDepartment;
    }
  }

  void _toggle(CbtSubject subject) {
    setState(() {
      if (_selectedIds.contains(subject.id)) {
        _selectedIds.remove(subject.id);
      } else if (_selectedUnits + subject.units <=
          CoursePackPickerScreen.maxUnits) {
        _selectedIds.add(subject.id);
      }
    });
  }

  void _confirm() {
    final List<CbtSubject> chosen = _available
        .where((CbtSubject s) => _selectedIds.contains(s.id))
        .toList();
    Navigator.of(context).pop(
      CoursePackSelection(
        subjects: chosen,
        department: _department ?? '',
        level: _level ?? '',
        semester: _semester ?? '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Build your course pack')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                children: <Widget>[
                  Text(
                    'Pick your department, level and semester, then choose '
                    'which papers to unlock — up to ${CoursePackPickerScreen.maxUnits} '
                    'units, the same cap as real course registration. One flat '
                    '₦1,200 either way.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _Selector(
                    label: 'Department',
                    value: _department,
                    options: _departments,
                    onChanged: (String? v) => setState(() {
                      _department = v;
                      _level = null;
                      _semester = null;
                      _selectedIds.clear();
                    }),
                  ),
                  if (_department != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.md),
                    _Selector(
                      label: 'Level',
                      value: _level,
                      options: _levels,
                      onChanged: (String? v) => setState(() {
                        _level = v;
                        _semester = null;
                        _selectedIds.clear();
                      }),
                    ),
                  ],
                  if (_level != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.md),
                    _Selector(
                      label: 'Semester',
                      value: _semester,
                      options: _semesters,
                      labelFor: (String s) =>
                          s == 'first' ? 'First semester' : 'Second semester',
                      onChanged: (String? v) => setState(() {
                        _semester = v;
                        _selectedIds.clear();
                      }),
                    ),
                  ],
                  if (_semester != null) ...<Widget>[
                    const SizedBox(height: AppSpacing.xl),
                    if (_available.isEmpty)
                      const EmptyState(
                        icon: Icons.quiz_outlined,
                        title: 'No papers yet',
                        message:
                            'Nothing has been added for this department, '
                            'level and semester yet — try another combination, '
                            'or unlock a single paper instead.',
                        compact: true,
                      )
                    else ...<Widget>[
                      SectionHeader(
                        title: 'Available papers',
                        subtitle:
                            '$_selectedUnits / ${CoursePackPickerScreen.maxUnits} units selected',
                      ),
                      ..._available.map(
                        (CbtSubject s) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: AppSpacing.sm,
                          ),
                          child: _SubjectTile(
                            subject: s,
                            selected: _selectedIds.contains(s.id),
                            disabled:
                                !_selectedIds.contains(s.id) &&
                                _selectedUnits + s.units >
                                    CoursePackPickerScreen.maxUnits,
                            onTap: () => _toggle(s),
                          ),
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  0,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: FilledButton(
                  onPressed: _selectedIds.isEmpty ? null : _confirm,
                  child: Text(
                    _selectedIds.isEmpty
                        ? 'Select at least one paper'
                        : 'Continue to payment — ₦1,200',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Selector extends StatelessWidget {
  const _Selector({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.labelFor,
  });

  final String label;
  final String? value;
  final List<String> options;
  final String Function(String)? labelFor;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((String option) {
            final bool selected = option == value;
            return ChoiceChip(
              label: Text(labelFor?.call(option) ?? option),
              selected: selected,
              onSelected: (_) => onChanged(option),
              selectedColor: AppColours.primaryTint,
              labelStyle: TextStyle(
                color: selected ? AppColours.primary : AppColours.text,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
              side: BorderSide(
                color: selected ? AppColours.primary : AppColours.border,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({
    required this.subject,
    required this.selected,
    required this.disabled,
    required this.onTap,
  });

  final CbtSubject subject;
  final bool selected;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      onTap: disabled ? null : onTap,
      colour: selected ? AppColours.primaryTint : AppColours.surface,
      border: Border.all(
        color: selected ? AppColours.primary : AppColours.border,
        width: selected ? 1.7 : 1,
      ),
      shadows: AppShadows.subtle,
      child: Opacity(
        opacity: disabled ? 0.45 : 1,
        child: Row(
          children: <Widget>[
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              size: 21,
              color: selected ? AppColours.primary : AppColours.borderStrong,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    subject.name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${subject.questions.length} questions',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Pill(
              label: '${subject.units} units',
              icon: Icons.stacked_line_chart_rounded,
              colour: AppColours.accent,
              dense: true,
            ),
          ],
        ),
      ),
    );
  }
}
