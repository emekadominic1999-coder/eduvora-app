import 'package:flutter/material.dart';

import '../../../../core/models/tutor.dart';
import '../../../../core/services/tutor_repository.dart';
import '../../../../core/theme/app_theme.dart';

/// A tutor cashes out. The account details are collected here rather than
/// kept on the profile, so a stale account number can never be paid by
/// accident months later.
Future<bool?> showWithdrawSheet(
  BuildContext context, {
  required Tutor tutor,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) => _WithdrawSheet(tutor: tutor),
  );
}

class _WithdrawSheet extends StatefulWidget {
  const _WithdrawSheet({required this.tutor});

  final Tutor tutor;

  @override
  State<_WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<_WithdrawSheet> {
  static const TutorRepository _tutors = TutorRepository();

  final TextEditingController _bank = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _name = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _bank.dispose();
    _number.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await _tutors.requestPayout(
        amountKobo: widget.tutor.balanceKobo,
        bankName: _bank.text.trim(),
        accountNumber: _number.text.trim(),
        accountName: _name.text.trim(),
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Withdrawal requested. Payment lands within 48 hours.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _busy = false;
        _error = error is StateError
            ? error.message
            : 'Could not request that. Please try again.';
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
            'Withdraw ₦${widget.tutor.balanceNaira.round()}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Paid by bank transfer, usually within 48 hours.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),

          TextField(
            controller: _bank,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Bank',
              hintText: 'e.g. Access Bank',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _number,
            keyboardType: TextInputType.number,
            maxLength: 10,
            decoration: const InputDecoration(
              labelText: 'Account number',
              hintText: '10 digits',
              counterText: '',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Account name',
              hintText: 'Exactly as it appears on the account',
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
            onPressed: _busy ? null : _submit,
            icon: _busy
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.account_balance_rounded, size: 18),
            label: Text(_busy ? 'Requesting…' : 'Request withdrawal'),
            style: FilledButton.styleFrom(minimumSize: const Size(0, 50)),
          ),
        ],
      ),
    );
  }
}
