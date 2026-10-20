import 'package:flutter/material.dart';

import '../../../../core/services/email_repository.dart';
import '../../../../core/theme/app_theme.dart';

/// Owner-only: write a message and email it to a group of students.
///
/// The real gate is the `send-email` function, which refuses anyone but the
/// owner. Every message carries an unsubscribe link, and the screen always
/// shows how many people a message will reach before it is sent.
class EmailStudentsScreen extends StatefulWidget {
  const EmailStudentsScreen({super.key});

  @override
  State<EmailStudentsScreen> createState() => _EmailStudentsScreenState();
}

class _EmailStudentsScreenState extends State<EmailStudentsScreen> {
  static const EmailRepository _emails = EmailRepository();

  final TextEditingController _subject = TextEditingController();
  final TextEditingController _message = TextEditingController();
  EmailAudience _audience = EmailAudience.me;
  int? _count;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _refreshCount();
  }

  @override
  void dispose() {
    _subject.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _refreshCount() async {
    setState(() {
      _count = null;
      _error = null;
    });
    try {
      final int n = await _emails.previewCount(_audience);
      if (mounted) setState(() => _count = n);
    } on StateError catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not load the list.');
    }
  }

  bool get _ready =>
      _subject.text.trim().length >= 3 &&
      _message.text.trim().length >= 10 &&
      (_count ?? 0) > 0;

  Future<void> _send() async {
    final bool? yes = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        title: const Text('Send this email?'),
        content: Text(
          'It will go to $_count ${_count == 1 ? 'person' : 'people'} '
          '(${_audience.label.toLowerCase()}). You cannot take it back.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Send'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final EmailSendResult r = await _emails.send(
        subject: _subject.text.trim(),
        message: _message.text.trim(),
        audience: _audience,
      );
      if (!mounted) return;
      _subject.clear();
      _message.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sent to ${r.sent}.'
            '${r.skipped > 0 ? ' ${r.skipped} skipped (unsubscribed).' : ''}'
            '${r.failed > 0 ? ' ${r.failed} failed.' : ''}',
          ),
        ),
      );
    } on StateError catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Could not send. Please try again.');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Email students')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: <Widget>[
          const Text(
            'Write a message and send it to your students by email. '
            'Messages come from Eduvora and include an unsubscribe link.',
            style: TextStyle(color: AppColours.textMuted, height: 1.45),
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<EmailAudience>(
            initialValue: _audience,
            decoration: const InputDecoration(labelText: 'Send to'),
            items: <DropdownMenuItem<EmailAudience>>[
              for (final EmailAudience a in EmailAudience.values)
                DropdownMenuItem<EmailAudience>(value: a, child: Text(a.label)),
            ],
            onChanged: _busy
                ? null
                : (EmailAudience? a) {
                    if (a == null) return;
                    setState(() => _audience = a);
                    _refreshCount();
                  },
          ),
          const SizedBox(height: 6),
          Text(
            _count == null
                ? (_error ?? 'Counting…')
                : 'This will reach $_count ${_count == 1 ? 'person' : 'people'}.',
            style: TextStyle(
              color: _error != null ? AppColours.danger : AppColours.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _subject,
            enabled: !_busy,
            maxLength: 120,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(labelText: 'Subject'),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _message,
            enabled: !_busy,
            minLines: 8,
            maxLines: 16,
            maxLength: 4000,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Message',
              alignLabelWithHint: true,
              helperText: 'Leave a blank line between paragraphs.',
            ),
          ),
          if (_error != null && _count != null) ...<Widget>[
            const SizedBox(height: 6),
            Text(_error!, style: const TextStyle(color: AppColours.danger)),
          ],
          const SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: _busy || !_ready ? null : _send,
            icon: _busy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(_busy ? 'Sending…' : 'Send email'),
          ),
        ],
      ),
    );
  }
}
