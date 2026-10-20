import 'package:flutter/material.dart';

import '../models/content_report.dart';
import '../services/moderation_repository.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// Report-and-block bottom sheet shared by every user-generated-content
/// surface (group messages, community posts, community comments), so the
/// three never drift into three slightly different flows.
///
/// "Block" is only offered when [authorId] is not [myUserId] -- a student
/// cannot block themselves. [onBlocked] lets the caller refresh its list
/// immediately rather than waiting for the next natural refetch.
Future<void> showModerationSheet({
  required BuildContext context,
  required ReportedContentType contentType,
  required String contentId,
  required String authorId,
  required String authorName,
  required String myUserId,
  VoidCallback? onBlocked,
}) async {
  final bool isMine = authorId.isNotEmpty && authorId == myUserId;

  final String? action = await showModalBottomSheet<String>(
    context: context,
    builder: (BuildContext context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.flag_outlined, color: AppColours.danger),
            title: const Text('Report'),
            onTap: () => Navigator.of(context).pop('report'),
          ),
          if (!isMine)
            ListTile(
              leading: const Icon(
                Icons.block_rounded,
                color: AppColours.danger,
              ),
              title: Text(
                'Block ${authorName.isEmpty ? 'this student' : authorName}',
              ),
              onTap: () => Navigator.of(context).pop('block'),
            ),
        ],
      ),
    ),
  );
  if (action == null || !context.mounted) return;

  if (action == 'report') {
    await promptReport(context, contentType: contentType, contentId: contentId);
  } else if (action == 'block') {
    await promptBlockUser(
      context,
      userId: authorId,
      userName: authorName,
      onBlocked: onBlocked,
    );
  }
}

/// Opens the "why are you reporting this" sheet and submits it. Usable on
/// its own by a screen that already has its own long-press action sheet
/// (see GroupChatScreen's `_messageActions`) and just wants the report flow,
/// without the combined report-or-block picker above.
Future<void> promptReport(
  BuildContext context, {
  required ReportedContentType contentType,
  required String contentId,
}) async {
  final _ReportDraft? draft = await showModalBottomSheet<_ReportDraft>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => const _ReportSheet(),
  );
  if (draft == null || !context.mounted) return;

  try {
    await const ModerationRepository().reportContent(
      contentType: contentType,
      contentId: contentId,
      reason: draft.reason,
      note: draft.note,
    );
    if (context.mounted) {
      showEduvoraSnack(
        context,
        'Thank you -- we have received your report.',
        icon: Icons.flag_rounded,
      );
    }
  } catch (error) {
    if (context.mounted) showEduvoraSnack(context, '$error', isError: true);
  }
}

/// Confirms, then blocks [userId]. Usable on its own, the same way
/// [promptReport] is.
Future<void> promptBlockUser(
  BuildContext context, {
  required String userId,
  required String userName,
  VoidCallback? onBlocked,
}) async {
  final String name = userName.isEmpty ? 'this student' : userName;
  final bool? confirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text('Block $name?'),
      content: Text(
        'You will stop seeing messages, posts and comments from $name. '
        'They will not be told they were blocked.',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColours.danger),
          child: const Text('Block'),
        ),
      ],
    ),
  );
  if (!(confirm ?? false) || !context.mounted) return;

  try {
    await const ModerationRepository().blockUser(userId);
    if (context.mounted) {
      showEduvoraSnack(context, '$name is blocked.', icon: Icons.block_rounded);
    }
    onBlocked?.call();
  } catch (error) {
    if (context.mounted) showEduvoraSnack(context, '$error', isError: true);
  }
}

class _ReportDraft {
  const _ReportDraft(this.reason, this.note);

  final ReportReason reason;
  final String note;
}

class _ReportSheet extends StatefulWidget {
  const _ReportSheet();

  @override
  State<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends State<_ReportSheet> {
  ReportReason _reason = ReportReason.spam;
  final TextEditingController _note = TextEditingController();

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Report this', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Tell us what is wrong. Reports go only to the Eduvora team.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: ReportReason.values
                  .map(
                    (ReportReason r) => _ReasonChip(
                      label: r.label,
                      selected: _reason == r,
                      onTap: () => setState(() => _reason = r),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _note,
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'Add details (optional)',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => Navigator.of(
                context,
              ).pop(_ReportDraft(_reason, _note.text.trim())),
              child: const Text('Submit report'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A single reason choice, in the same pill-chip language as the topic
/// picker in Community's own compose sheet.
class _ReasonChip extends StatelessWidget {
  const _ReasonChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColours.primary : AppColours.surfaceMuted,
      borderRadius: AppRadii.pill,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pill,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColours.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
