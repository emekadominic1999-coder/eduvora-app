import 'package:flutter/material.dart';

import '../../../../core/models/tutor.dart';
import '../../../../core/services/tutor_repository.dart';
import '../../../../core/theme/app_theme.dart';

/// Collects what a student wants from a session and sends the request.
///
/// Deliberately no payment here — the tutor has to accept first, and the
/// price is then set server-side from their own listed rate. Asking for
/// money before anyone has agreed to meet would be the wrong order.
Future<bool?> showBookSessionSheet(
  BuildContext context, {
  required Tutor tutor,
  String preselectedSubjectId = '',
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => _BookSessionSheet(
      tutor: tutor,
      preselectedSubjectId: preselectedSubjectId,
    ),
  );
}

class _BookSessionSheet extends StatefulWidget {
  const _BookSessionSheet({
    required this.tutor,
    required this.preselectedSubjectId,
  });

  final Tutor tutor;
  final String preselectedSubjectId;

  @override
  State<_BookSessionSheet> createState() => _BookSessionSheetState();
}

class _BookSessionSheetState extends State<_BookSessionSheet> {
  static const TutorRepository _tutors = TutorRepository();

  final TextEditingController _topic = TextEditingController();
  late TutorCourse _course;
  TutorMeetingMode _mode = TutorMeetingMode.online;
  int _minutes = 60;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _course =
        widget.tutor.courseFor(widget.preselectedSubjectId) ??
        widget.tutor.courses.first;
  }

  @override
  void dispose() {
    _topic.dispose();
    super.dispose();
  }

  int get _estimatedKobo =>
      (_course.hourlyRateKobo * _minutes / 60).round();

  Future<void> _send() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _tutors.requestSession(
        tutorId: widget.tutor.id,
        subjectId: _course.subjectId,
        subjectName: _course.subjectName,
        topic: _topic.text.trim(),
        mode: _mode,
        durationMinutes: _minutes,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = error is StateError
            ? error.message
            : 'Could not send that request. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.xl + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Request a session',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'with ${widget.tutor.fullName.isEmpty ? 'this tutor' : widget.tutor.fullName}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),

          Text('Course', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.tutor.courses.map((TutorCourse c) {
              final bool selected = c.subjectId == _course.subjectId;
              return ChoiceChip(
                label: Text(
                  c.subjectName.isEmpty ? c.subjectId : c.subjectName,
                ),
                selected: selected,
                onSelected: (_) => setState(() => _course = c),
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

          const SizedBox(height: AppSpacing.lg),
          Text(
            'What do you need help with?',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _topic,
            maxLines: 2,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'e.g. Integration by parts, and curve sketching',
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          Text('How long?', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            children: <int>[30, 60, 90, 120].map((int m) {
              final bool selected = m == _minutes;
              return ChoiceChip(
                label: Text(m % 60 == 0 ? '${m ~/ 60} hr' : '$m min'),
                selected: selected,
                onSelected: (_) => setState(() => _minutes = m),
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

          const SizedBox(height: AppSpacing.lg),
          Text('Where?', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            children: TutorMeetingMode.values.map((TutorMeetingMode m) {
              final bool selected = m == _mode;
              return ChoiceChip(
                label: Text(m.label),
                selected: selected,
                onSelected: (_) => setState(() => _mode = m),
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

          const SizedBox(height: AppSpacing.xl),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColours.surfaceMuted,
              borderRadius: AppRadii.sm,
            ),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.receipt_long_rounded,
                  size: 17,
                  color: AppColours.textMuted,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'About ₦${(_estimatedKobo / 100).round()} for '
                    '${_minutes % 60 == 0 ? '${_minutes ~/ 60} hour' : '$_minutes minutes'}. '
                    'You only pay once the tutor accepts.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(height: 1.45),
                  ),
                ),
              ],
            ),
          ),

          if (_error != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(
              _error!,
              style: const TextStyle(fontSize: 13, color: AppColours.danger),
            ),
          ],

          const SizedBox(height: AppSpacing.xl),
          FilledButton.icon(
            onPressed: _busy ? null : _send,
            icon: _busy
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(_busy ? 'Sending…' : 'Send request'),
          ),
        ],
      ),
    );
  }
}
