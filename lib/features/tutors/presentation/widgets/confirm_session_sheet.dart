import 'package:flutter/material.dart';

import '../../../../core/models/tutor.dart';
import '../../../../core/services/tutor_repository.dart';
import '../../../../core/theme/app_theme.dart';

/// The student confirms a session happened, and rates it.
///
/// This is the moment the tutor actually gets paid, which is why it sits
/// with the student rather than running automatically on a timer — if the
/// tutor never showed up, the money should not move.
Future<bool?> showConfirmSessionSheet(
  BuildContext context, {
  required TutorSession session,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => _ConfirmSessionSheet(session: session),
  );
}

class _ConfirmSessionSheet extends StatefulWidget {
  const _ConfirmSessionSheet({required this.session});

  final TutorSession session;

  @override
  State<_ConfirmSessionSheet> createState() => _ConfirmSessionSheetState();
}

class _ConfirmSessionSheetState extends State<_ConfirmSessionSheet> {
  static const TutorRepository _tutors = TutorRepository();

  final TextEditingController _comment = TextEditingController();
  int _rating = 5;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _tutors.completeSession(
        widget.session.id,
        rating: _rating,
        comment: _comment.text.trim(),
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = error is StateError
            ? error.message
            : 'Could not confirm that. Please try again.';
      });
    }
  }

  Future<void> _report() async {
    setState(() => _busy = true);
    try {
      await _tutors.setSessionStatus(
        widget.session.id,
        TutorSessionStatus.disputed,
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (mounted) setState(() => _busy = false);
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
            'How did it go?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Confirming releases ₦${widget.session.tutorEarningsNaira.round()} '
            'to your tutor.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),

          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List<Widget>.generate(5, (int i) {
                final int value = i + 1;
                return IconButton(
                  onPressed: () => setState(() => _rating = value),
                  icon: Icon(
                    value <= _rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 34,
                    color: AppColours.warning,
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _comment,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'Anything worth telling other students? (optional)',
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
            onPressed: _busy ? null : _confirm,
            icon: _busy
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_rounded, size: 19),
            label: Text(_busy ? 'Confirming…' : 'Confirm and pay the tutor'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 50),
              backgroundColor: AppColours.success,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: TextButton(
              onPressed: _busy ? null : _report,
              style: TextButton.styleFrom(foregroundColor: AppColours.danger),
              child: const Text('It did not happen — report this'),
            ),
          ),
        ],
      ),
    );
  }
}
