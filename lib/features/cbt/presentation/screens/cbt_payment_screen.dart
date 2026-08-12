import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/services/paywall_repository.dart';
import '../../../../core/theme/app_theme.dart';
import 'course_pack_picker_screen.dart';

enum _Stage { starting, awaitingPayment, verifying, success, failed }

/// Starts a Paystack checkout — for one paper, or for a whole
/// [CoursePackSelection] — and walks the student through to confirmation.
///
/// The actual payment happens on Paystack's own hosted page — opened in the
/// system browser — which already offers bank transfer, USSD and card
/// without Eduvora ever handling card details itself. This screen's job is
/// just to start that checkout and then confirm it landed.
///
/// Pops `true` once access is confirmed, so the caller can drop straight into
/// the exam the student was trying to open.
class CbtPaymentScreen extends StatefulWidget {
  // Kept as a distinct required parameter (rather than `required this.subject`)
  // so this constructor enforces a non-null subject at compile time even
  // though the field itself is nullable to accommodate .coursePack.
  const CbtPaymentScreen.singlePaper({super.key, required CbtSubject subject})
    : subject = subject, // ignore: prefer_initializing_formals
      coursePack = null;

  const CbtPaymentScreen.coursePack({
    super.key,
    required CoursePackSelection selection,
  }) : subject = null,
       coursePack = selection;

  final CbtSubject? subject;
  final CoursePackSelection? coursePack;

  @override
  State<CbtPaymentScreen> createState() => _CbtPaymentScreenState();
}

class _CbtPaymentScreenState extends State<CbtPaymentScreen> {
  static const PaywallRepository _paywall = PaywallRepository();
  static const int _maxAutoChecks = 15;
  static const Duration _pollEvery = Duration(seconds: 4);

  _Stage _stage = _Stage.starting;
  PaystackCheckout? _checkout;
  String? _error;
  Timer? _pollTimer;
  int _checksDone = 0;

  bool get _isCoursePack => widget.coursePack != null;

  String get _planTitle {
    final CoursePackSelection? pack = widget.coursePack;
    if (pack == null) return widget.subject!.name;
    return pack.subjects.length == 1
        ? pack.subjects.single.name
        : '${pack.subjects.length} papers (${pack.totalUnits} units)';
  }

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
      final PaystackCheckout checkout = _isCoursePack
          ? await _paywall.startCoursePackCheckout(
              subjectIds: widget.coursePack!.subjects
                  .map((CbtSubject s) => s.id)
                  .toList(),
              department: widget.coursePack!.department,
              level: widget.coursePack!.level,
              semester: widget.coursePack!.semester,
            )
          : await _paywall.startSinglePaperCheckout(
              subjectId: widget.subject!.id,
              subjectName: widget.subject!.name,
            );
      if (!mounted) return;
      setState(() {
        _checkout = checkout;
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
    final PaystackCheckout? checkout = _checkout;
    if (checkout == null) return;
    final Uri uri = Uri.parse(checkout.authorizationUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _beginPolling() {
    _checksDone = 0;
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(_pollEvery, (_) => _checkOnce(silent: true));
  }

  Future<void> _checkOnce({bool silent = false}) async {
    final PaystackCheckout? checkout = _checkout;
    if (checkout == null || !mounted) return;
    if (!silent) setState(() => _stage = _Stage.verifying);

    final bool verified = await _paywall.verify(checkout.reference);
    if (!mounted) return;

    if (verified) {
      _pollTimer?.cancel();
      setState(() => _stage = _Stage.success);
      return;
    }

    _checksDone++;
    if (!silent) {
      setState(() => _stage = _Stage.awaitingPayment);
    }
    if (_checksDone >= _maxAutoChecks) {
      _pollTimer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Unlock CBT access')),
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
        return _AwaitingPayment(
          planTitle: _planTitle,
          amountNaira: _checkout?.amountNaira ?? 0,
          onOpenAgain: _openCheckout,
          onIvePaid: () => _checkOnce(),
        );
      case _Stage.success:
        return _Success(planTitle: _planTitle);
      case _Stage.failed:
        return _Failed(message: _error ?? 'Something went wrong.', onRetry: _start);
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

class _AwaitingPayment extends StatelessWidget {
  const _AwaitingPayment({
    required this.planTitle,
    required this.amountNaira,
    required this.onOpenAgain,
    required this.onIvePaid,
  });

  final String planTitle;
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
          'A secure Paystack page has opened for $planTitle — '
          '₦${amountNaira.toStringAsFixed(0)}. Pay by bank transfer, USSD or '
          'card, then come back here.',
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
  const _Success({required this.planTitle});

  final String planTitle;

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
        Text("You're all set", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 6),
        Text(
          '$planTitle is unlocked.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.xl),
        FilledButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.play_arrow_rounded, size: 20),
          label: const Text('Start practising'),
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
