import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/tutor.dart';
import '../../../../core/services/tutor_repository.dart';
import '../../../../core/theme/app_theme.dart';

enum _Stage { starting, awaitingPayment, verifying, success, failed }

/// Pays for an accepted session through Paystack's hosted page.
///
/// Mirrors the CBT paywall's flow deliberately — same hosted checkout, same
/// "I've paid" re-check, same background polling — so a student who has
/// bought a paper already recognises this screen.
class SessionPaymentScreen extends StatefulWidget {
  const SessionPaymentScreen({super.key, required this.session});

  final TutorSession session;

  @override
  State<SessionPaymentScreen> createState() => _SessionPaymentScreenState();
}

class _SessionPaymentScreenState extends State<SessionPaymentScreen> {
  static const TutorRepository _tutors = TutorRepository();
  static const int _maxAutoChecks = 15;
  static const Duration _pollEvery = Duration(seconds: 4);

  _Stage _stage = _Stage.starting;
  String? _authorizationUrl;
  String? _reference;
  int _amountKobo = 0;
  String? _error;
  Timer? _pollTimer;
  int _checksDone = 0;

  @override
  void initState() {
    super.initState();
    _start();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _start() async {
    setState(() {
      _stage = _Stage.starting;
      _error = null;
    });
    try {
      final ({String authorizationUrl, String reference, int amountKobo})
      checkout = await _tutors.paySession(widget.session.id);
      if (!mounted) return;
      setState(() {
        _authorizationUrl = checkout.authorizationUrl;
        _reference = checkout.reference;
        _amountKobo = checkout.amountKobo;
        _stage = _Stage.awaitingPayment;
      });
      await _openCheckout();
      _beginPolling();
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _stage = _Stage.failed;
        _error = error is StateError
            ? error.message
            : 'Could not start checkout. Please try again.';
      });
    }
  }

  Future<void> _openCheckout() async {
    final String? url = _authorizationUrl;
    if (url == null) return;
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _beginPolling() {
    _checksDone = 0;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollEvery, (_) => _check(silent: true));
  }

  Future<void> _check({bool silent = false}) async {
    final String? reference = _reference;
    if (reference == null || !mounted) return;
    if (!silent) setState(() => _stage = _Stage.verifying);

    final bool verified = await _tutors.verifyPayment(reference);
    if (!mounted) return;

    if (verified) {
      _pollTimer?.cancel();
      setState(() => _stage = _Stage.success);
      return;
    }

    _checksDone++;
    if (!silent) setState(() => _stage = _Stage.awaitingPayment);
    if (_checksDone >= _maxAutoChecks) _pollTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Pay for your session')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(child: _body()),
        ),
      ),
    );
  }

  Widget _body() {
    switch (_stage) {
      case _Stage.starting:
        return const _Busy(message: 'Starting checkout…');
      case _Stage.verifying:
        return const _Busy(message: 'Confirming your payment…');
      case _Stage.awaitingPayment:
        return _Awaiting(
          session: widget.session,
          amountNaira: _amountKobo / 100,
          onOpenAgain: _openCheckout,
          onIvePaid: () => _check(),
        );
      case _Stage.success:
        return _Success(session: widget.session);
      case _Stage.failed:
        return _Failed(
          message: _error ?? 'Something went wrong.',
          onRetry: _start,
        );
    }
  }
}

class _Busy extends StatelessWidget {
  const _Busy({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const CircularProgressIndicator(color: AppColours.primary),
        const SizedBox(height: AppSpacing.lg),
        Text(message, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

class _Awaiting extends StatelessWidget {
  const _Awaiting({
    required this.session,
    required this.amountNaira,
    required this.onOpenAgain,
    required this.onIvePaid,
  });

  final TutorSession session;
  final double amountNaira;
  final VoidCallback onOpenAgain;
  final VoidCallback onIvePaid;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColours.primarySoft,
            borderRadius: AppRadii.md,
          ),
          child: const Icon(
            Icons.open_in_new_rounded,
            color: AppColours.primary,
            size: 26,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Complete your payment',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Text(
          'A secure Paystack page has opened for '
          '${session.subjectName} — ₦${amountNaira.round()} for '
          '${session.durationLabel}. Pay by bank transfer, USSD or card, '
          'then come back here.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton.icon(
          onPressed: onIvePaid,
          icon: const Icon(Icons.check_rounded, size: 19),
          label: const Text("I've completed payment"),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextButton(
          onPressed: onOpenAgain,
          child: const Text('Reopen the payment page'),
        ),
      ],
    );
  }
}

class _Success extends StatelessWidget {
  const _Success({required this.session});

  final TutorSession session;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColours.successSoft,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            color: AppColours.success,
            size: 28,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Session confirmed', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          'Your tutor has been notified. Message them in Eduvora to agree a '
          'time, and confirm the session here once it has happened — that is '
          'what releases their payment.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.5),
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class _Failed extends StatelessWidget {
  const _Failed({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColours.dangerSoft,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.close_rounded,
            color: AppColours.danger,
            size: 28,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.xl),
        FilledButton(onPressed: onRetry, child: const Text('Try again')),
      ],
    );
  }
}
