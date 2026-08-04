import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/data/academic_structure.dart';
import '../../../../core/models/institution.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/models/study_material.dart';
import '../../../../core/services/content_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// Share lecture notes, past questions, handouts and other resources.
class UploadMaterialScreen extends StatefulWidget {
  const UploadMaterialScreen({super.key});

  @override
  State<UploadMaterialScreen> createState() => _UploadMaterialScreenState();
}

class _UploadMaterialScreenState extends State<UploadMaterialScreen> {
  static const ContentRepository _content = ContentRepository();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _title = TextEditingController();
  final TextEditingController _course = TextEditingController();
  final TextEditingController _description = TextEditingController();

  MaterialKind _kind = MaterialKind.lectureNote;
  String? _level;
  PlatformFile? _file;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _level = sessionController.profile?.level;
  }

  @override
  void dispose() {
    _title.dispose();
    _course.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.custom,
        allowedExtensions: <String>[
          'pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx', 'txt',
          'jpg', 'jpeg', 'png', 'zip',
        ],
      );
      if (result == null || result.files.isEmpty) return;

      final PlatformFile picked = result.files.first;
      const int limit = 25 * 1024 * 1024;
      if (picked.size > limit) {
        if (!mounted) return;
        showEduvoraSnack(
          context,
          'That file is larger than 25 MB. Please compress it first.',
          isError: true,
        );
        return;
      }
      setState(() => _file = picked);
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(
        context,
        'We could not open the file picker on this device.',
        isError: true,
      );
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final StudentProfile? profile = sessionController.profile;
    if (profile == null) return;

    setState(() => _submitting = true);
    try {
      await _content.uploadMaterial(
        profile: profile,
        title: _title.text,
        courseCode: _course.text,
        description: _description.text,
        kind: _kind,
        level: _level ?? profile.level,
        fileName: _file?.name ?? '',
        bytes: _file?.bytes,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      showEduvoraSnack(
        context,
        'Thank you — your resource is now in the library.',
        icon: Icons.volunteer_activism_rounded,
      );
    } catch (error) {
      if (!mounted) return;
      showEduvoraSnack(
        context,
        SessionController.describeError(error),
        isError: true,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final StudentProfile? profile = sessionController.profile;
    final List<String> levels = AcademicStructure.levelsFor(
      profile?.institutionType ?? InstitutionType.university,
    );

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Share a resource')),
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
                    Icons.volunteer_activism_rounded,
                    size: 20,
                    color: AppColours.primary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      'Whatever you share goes to students in '
                      '${profile?.department.isNotEmpty == true ? profile!.department : 'your department'}. '
                      'Please keep it to material you are free to pass on.',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(height: 1.55),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            _label('Resource type'),
            _kindPicker(),
            const SizedBox(height: AppSpacing.xl),
            _label('Title'),
            TextFormField(
              controller: _title,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'e.g. Thermodynamics — complete lecture notes',
              ),
              validator: (String? v) => (v ?? '').trim().isEmpty
                  ? 'Please give your resource a title.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            _label('Course code'),
            TextFormField(
              controller: _course,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(hintText: 'e.g. MEE 301'),
              validator: (String? v) => (v ?? '').trim().isEmpty
                  ? 'A course code helps others find this.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            _label('Level'),
            DropdownButtonFormField<String>(
              initialValue: levels.contains(_level) ? _level : null,
              isExpanded: true,
              decoration: const InputDecoration(
                hintText: 'Which level is this for?',
              ),
              items: levels
                  .map(
                    (String l) => DropdownMenuItem<String>(
                      value: l,
                      child: Text(l),
                    ),
                  )
                  .toList(),
              onChanged: (String? v) => setState(() => _level = v),
              validator: (String? v) =>
                  (v ?? '').isEmpty ? 'Please choose a level.' : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            _label('Description'),
            TextFormField(
              controller: _description,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText:
                    'What does it cover? Anything a coursemate should know '
                    'before opening it?',
                alignLabelWithHint: true,
              ),
              validator: (String? v) => (v ?? '').trim().length < 10
                  ? 'A sentence or two really helps your coursemates.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            _label('Attachment'),
            _filePicker(),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton(
              onPressed: _submitting ? null : _submit,
              child: _submitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Publish to the library'),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'You can publish now and attach the file later if the network '
              'is poor.',
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

  Widget _kindPicker() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: MaterialKind.values.map((MaterialKind k) {
        final bool selected = _kind == k;
        return GestureDetector(
          onTap: () => setState(() => _kind = k),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            decoration: BoxDecoration(
              color: selected ? k.colour : AppColours.surface,
              borderRadius: AppRadii.md,
              border: Border.all(
                color: selected ? k.colour : AppColours.border,
                width: selected ? 1.6 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  k.icon,
                  size: 15,
                  color: selected ? Colors.white : k.colour,
                ),
                const SizedBox(width: 7),
                Text(
                  k.label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColours.text,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _filePicker() {
    final PlatformFile? file = _file;
    return EduvoraCard(
      onTap: _pickFile,
      padding: const EdgeInsets.all(AppSpacing.lg),
      shadows: AppShadows.subtle,
      border: Border.all(
        color: file == null ? AppColours.border : AppColours.primary,
        width: file == null ? 1 : 1.6,
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (file == null ? AppColours.textMuted : AppColours.primary)
                  .withValues(alpha: 0.12),
              borderRadius: AppRadii.sm,
            ),
            child: Icon(
              file == null
                  ? Icons.attach_file_rounded
                  : Icons.insert_drive_file_rounded,
              size: 20,
              color: file == null ? AppColours.textMuted : AppColours.primary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  file?.name ?? 'Choose a file',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColours.text,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  file == null
                      ? 'PDF, Word, PowerPoint, images or ZIP · up to 25 MB'
                      : _readable(file.size),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (file != null)
            IconButton(
              onPressed: () => setState(() => _file = null),
              icon: const Icon(Icons.close_rounded, size: 19),
              tooltip: 'Remove file',
            ),
        ],
      ),
    );
  }

  static String _readable(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
