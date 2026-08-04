import 'package:flutter/material.dart';

import '../../../../core/models/course_outline.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/services/course_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// Contribute a course, and optionally its syllabus, for your own school.
class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  static const CourseRepository _repo = CourseRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _code = TextEditingController();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _lecturer = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _topics = TextEditingController();

  Semester _semester = Semester.first;
  int _units = 3;
  bool _elective = false;
  bool _saving = false;

  @override
  void dispose() {
    _code.dispose();
    _title.dispose();
    _lecturer.dispose();
    _description.dispose();
    _topics.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    setState(() => _saving = true);
    try {
      await _repo.addCourse(
        profile: profile,
        courseCode: _code.text,
        courseTitle: _title.text,
        semester: _semester,
        creditUnits: _units,
        description: _description.text,
        topics: _topics.text.split('\n'),
        lecturer: _lecturer.text,
        isElective: _elective,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      showEduvoraSnack(
        context,
        'Added. Your coursemates can see it now.',
        icon: Icons.check_circle_outline_rounded,
      );
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(
        context,
        SessionController.describeError(error),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final StudentProfile? profile = sessionController.profile;

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Add a course')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          children: <Widget>[
            EduvoraCard(
              colour: AppColours.primaryTint,
              shadows: const <BoxShadow>[],
              border: Border.all(color: AppColours.primarySoft),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Icon(
                    Icons.account_balance_rounded,
                    size: 20,
                    color: AppColours.primary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'This will be filed under '
                      '${profile?.institutionName.isNotEmpty == true ? profile!.institutionName : 'your institution'}, '
                      '${profile?.department ?? ''}, ${profile?.level ?? ''}. '
                      'Please add it exactly as your own school teaches it.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(height: 1.55),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            _label('Course code'),
            TextFormField(
              controller: _code,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(hintText: 'e.g. MTH 101'),
              validator: (String? v) => (v ?? '').trim().isEmpty
                  ? 'The course code is needed.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            _label('Course title'),
            TextFormField(
              controller: _title,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. Elementary Mathematics I',
              ),
              validator: (String? v) => (v ?? '').trim().isEmpty
                  ? 'The course title is needed.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),

            _label('Semester'),
            Row(
              children: Semester.values.map((Semester s) {
                final bool selected = _semester == s;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: s == Semester.first ? AppSpacing.sm : 0,
                    ),
                    child: GestureDetector(
                      onTap: () => setState(() => _semester = s),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColours.primary
                              : AppColours.surface,
                          borderRadius: AppRadii.md,
                          border: Border.all(
                            color: selected
                                ? AppColours.primary
                                : AppColours.border,
                            width: selected ? 1.6 : 1,
                          ),
                        ),
                        child: Text(
                          s.label,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: selected ? Colors.white : AppColours.text,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),

            _label('Credit units'),
            Row(
              children: <Widget>[
                Expanded(
                  child: Slider(
                    value: _units.toDouble(),
                    min: 0,
                    max: 12,
                    divisions: 12,
                    label: '$_units',
                    onChanged: (double v) => setState(() => _units = v.round()),
                  ),
                ),
                SizedBox(
                  width: 62,
                  child: Text(
                    _units == 1 ? '1 unit' : '$_units units',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColours.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),

            SwitchListTile(
              value: _elective,
              onChanged: (bool v) => setState(() => _elective = v),
              contentPadding: EdgeInsets.zero,
              title: const Text('Elective'),
              subtitle: const Text('Leave off if the course is compulsory'),
            ),
            const SizedBox(height: AppSpacing.lg),

            _label('Lecturer'),
            TextFormField(
              controller: _lecturer,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Optional — e.g. Dr. A. Bello',
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            _label('Description'),
            TextFormField(
              controller: _description,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Optional — what the course is about.',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            _label('Course outline'),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, left: 2),
              child: Text(
                'One topic per line, in the order it is taught. Maths may be '
                r'written in LaTeX between dollar signs, e.g. $\int x\,dx$.',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(height: 1.45),
              ),
            ),
            TextFormField(
              controller: _topics,
              maxLines: 8,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText:
                    'Set theory and number systems\n'
                    'Sequences and series\n'
                    'Differentiation from first principles\n'
                    'Applications of integration',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            FilledButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Add to the outline'),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'You can add the course now and fill in its topics later.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _label(String value) => Padding(
    padding: const EdgeInsets.only(bottom: 8, left: 2),
    child: Text(
      value,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColours.text,
      ),
    ),
  );
}
