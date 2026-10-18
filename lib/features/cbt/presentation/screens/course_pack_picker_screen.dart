import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';

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

/// Lets the student build their own course pack: one list of every paper
/// that has been uploaded, with a search box. They tick what they want, up to
/// a real semester's course load, and pay once.
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
  State<CoursePackPickerScreen> createState() => _CoursePackPickerScreenState();
}

class _CoursePackPickerScreenState extends State<CoursePackPickerScreen> {
  final Set<String> _selectedIds = <String>{};
  String _query = '';

  List<CbtSubject> get _all =>
      widget.allSubjects.where((CbtSubject s) => s.questionCount > 0).toList()
        ..sort((CbtSubject a, CbtSubject b) => a.name.compareTo(b.name));

  List<CbtSubject> get _visible {
    final String q = _query.trim().toLowerCase();
    if (q.isEmpty) return _all;
    return _all
        .where((CbtSubject s) => s.name.toLowerCase().contains(q))
        .toList();
  }

  int get _selectedUnits => widget.allSubjects
      .where((CbtSubject s) => _selectedIds.contains(s.id))
      .fold(0, (int sum, CbtSubject s) => sum + s.units);

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
    final List<CbtSubject> chosen = widget.allSubjects
        .where((CbtSubject s) => _selectedIds.contains(s.id))
        .toList();
    Navigator.of(context).pop(
      CoursePackSelection(
        subjects: chosen,
        department: '',
        level: '',
        semester: '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<CbtSubject> visible = _visible;
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Choose your courses')),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tick every course you want, then pay once — one flat ₦2,300. '
                    'You can pick up to ${CoursePackPickerScreen.maxUnits} units in total.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    onChanged: (String v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search_rounded),
                      hintText: 'Search a course, e.g. MTH 101',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '$_selectedUnits / ${CoursePackPickerScreen.maxUnits} units selected',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              child: visible.isEmpty
                  ? const EmptyState(
                      icon: Icons.quiz_outlined,
                      title: 'No course found',
                      message: 'Try a different search.',
                      compact: true,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.sm,
                      ),
                      itemCount: visible.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (BuildContext context, int i) {
                        final CbtSubject s = visible[i];
                        return _SubjectTile(
                          subject: s,
                          selected: _selectedIds.contains(s.id),
                          disabled:
                              !_selectedIds.contains(s.id) &&
                              _selectedUnits + s.units >
                                  CoursePackPickerScreen.maxUnits,
                          onTap: () => _toggle(s),
                        );
                      },
                    ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.sm,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: FilledButton(
                  onPressed: _selectedIds.isEmpty ? null : _confirm,
                  child: Text(
                    _selectedIds.isEmpty
                        ? 'Select at least one course'
                        : 'Continue to payment — ₦2,300',
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
                    '${subject.questionCount} questions',
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
