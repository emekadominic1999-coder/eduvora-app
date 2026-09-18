import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/models/referral.dart';
import '../../../../core/services/referral_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';

/// "Refer & earn": a student's code, what it has earned, and how to cash out.
class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  static const ReferralRepository _repo = ReferralRepository();

  late Future<ReferralSummary> _future = _repo.summary();
  final TextEditingController _friendCode = TextEditingController();
  bool _applying = false;

  @override
  void dispose() {
    _friendCode.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    setState(() => _future = _repo.summary());
    try {
      await _future;
    } catch (_) {
      // The builder shows the error; refresh just needs to finish.
    }
  }

  void _toast(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _copy(String text, String done) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (mounted) _toast(done);
  }

  Future<void> _shareOnWhatsApp(String code) async {
    final Uri uri = ReferralRepository.whatsAppUri(code);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      await _copy(
        ReferralRepository.shareMessage(code),
        'Message copied — paste it wherever you like.',
      );
    }
  }

  Future<void> _applyFriendCode() async {
    final String code = _friendCode.text.trim();
    if (code.isEmpty || _applying) return;
    setState(() => _applying = true);
    final ReferralResult result = await _repo.applyCode(code);
    if (!mounted) return;
    setState(() => _applying = false);
    if (result.ok) {
      _friendCode.clear();
      _toast('Referral code added. Thanks for joining through a friend!');
      await _reload();
    } else {
      _toast(result.error ?? 'That code could not be used.');
    }
  }

  Future<void> _withdraw(ReferralSummary summary) async {
    final bool? requested = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => _WithdrawSheet(summary: summary),
    );
    if (requested == true && mounted) {
      _toast('Withdrawal requested. You will be paid by bank transfer.');
      await _reload();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(title: const Text('Refer & earn')),
      body: RefreshIndicator(
        onRefresh: _reload,
        color: AppColours.primary,
        child: FutureBuilder<ReferralSummary>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<ReferralSummary> snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError || snap.data == null) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: <Widget>[
                  const SizedBox(height: 80),
                  EmptyState(
                    icon: Icons.wifi_off_rounded,
                    title: 'Could not load your referrals',
                    message: 'Check your connection and try again.',
                    actionLabel: 'Retry',
                    onAction: _reload,
                  ),
                ],
              );
            }
            return _content(snap.data!);
          },
        ),
      ),
    );
  }

  Widget _content(ReferralSummary s) {
    final DateFormat dateFormat = DateFormat('d MMM yyyy');

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        AppSpacing.xxxl,
      ),
      children: <Widget>[
        _CodeCard(
          summary: s,
          onCopy: () => _copy(s.code, 'Code ${s.code} copied.'),
          onCopyLink: () => _copy(
            ReferralRepository.shareLink(s.code),
            'Invite link copied.',
          ),
          onShare: () => _shareOnWhatsApp(s.code),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: <Widget>[
            Expanded(
              child: StatTile(
                label: 'Friends joined',
                value: '${s.referredCount}',
                icon: Icons.group_add_rounded,
                colour: AppColours.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                label: 'Total earned',
                value: formatNaira(s.totalEarnedKobo),
                icon: Icons.savings_rounded,
                colour: AppColours.accent,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatTile(
                label: 'Available',
                value: formatNaira(s.availableKobo),
                icon: Icons.account_balance_wallet_rounded,
                colour: AppColours.success,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _WithdrawCard(summary: s, onWithdraw: () => _withdraw(s)),
        if (!s.hasReferrer) ...<Widget>[
          const SizedBox(height: AppSpacing.lg),
          _FriendCodeCard(
            controller: _friendCode,
            busy: _applying,
            onApply: _applyFriendCode,
          ),
        ],
        SectionHeader(
          title: 'Earnings',
          subtitle: 'Every time a friend you referred pays',
          padding: const EdgeInsets.only(
            top: AppSpacing.xl,
            bottom: AppSpacing.md,
          ),
        ),
        if (s.activity.isEmpty)
          const EmptyState(
            icon: Icons.hourglass_empty_rounded,
            title: 'No earnings yet',
            message:
                'Share your code. When a friend signs up with it and pays, '
                'your commission shows up here.',
            compact: true,
          )
        else
          ...s.activity.map(
            (ReferralEarning e) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: EduvoraCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                shadows: AppShadows.subtle,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColours.successSoft,
                        borderRadius: AppRadii.sm,
                      ),
                      child: const Icon(
                        Icons.arrow_downward_rounded,
                        size: 18,
                        color: AppColours.success,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '${e.firstName} paid ${formatNaira(e.paymentAmountKobo)}',
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppColours.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            dateFormat.format(e.createdAt),
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColours.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '+${formatNaira(e.commissionKobo)}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColours.success,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (s.withdrawals.isNotEmpty) ...<Widget>[
          SectionHeader(
            title: 'Withdrawals',
            padding: const EdgeInsets.only(
              top: AppSpacing.xl,
              bottom: AppSpacing.md,
            ),
          ),
          ...s.withdrawals.map(
            (ReferralWithdrawal w) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: EduvoraCard(
                padding: const EdgeInsets.all(AppSpacing.md),
                shadows: AppShadows.subtle,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            formatNaira(w.amountKobo),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColours.text,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${w.bankName} · ${w.accountNumber} · '
                            '${dateFormat.format(w.createdAt)}',
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColours.textMuted,
                            ),
                          ),
                          if (w.isRejected && w.note.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                w.note,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: AppColours.danger,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Pill(
                      label: w.isPaid
                          ? 'Paid'
                          : w.isRejected
                          ? 'Declined'
                          : 'Pending',
                      colour: w.isPaid
                          ? AppColours.success
                          : w.isRejected
                          ? AppColours.danger
                          : AppColours.warning,
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
        SectionHeader(
          title: 'How it works',
          padding: const EdgeInsets.only(
            top: AppSpacing.xl,
            bottom: AppSpacing.md,
          ),
        ),
        EduvoraCard(
          shadows: AppShadows.subtle,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Step(
                number: '1',
                text: 'Share your code or invite link with friends.',
              ),
              _Step(
                number: '2',
                text: 'They sign up and enter your code before their first '
                    'purchase.',
              ),
              _Step(
                number: '3',
                text: 'You earn ${s.commissionPercent}% of every payment they '
                    'make, for as long as they use Eduvora.',
              ),
              _Step(
                number: '4',
                text: 'Withdraw once you reach '
                    '${formatNaira(s.minWithdrawalKobo)}. We pay you by bank '
                    'transfer.',
                last: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CodeCard extends StatelessWidget {
  const _CodeCard({
    required this.summary,
    required this.onCopy,
    required this.onCopyLink,
    required this.onShare,
  });

  final ReferralSummary summary;
  final VoidCallback onCopy;
  final VoidCallback onCopyLink;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: AppColours.brandGradient,
        borderRadius: AppRadii.lg,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Earn ${summary.commissionPercent}% on every purchase',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Friends who join with your code — you earn each time they pay.',
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: Colors.white.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
              horizontal: AppSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: AppRadii.md,
            ),
            child: Column(
              children: <Widget>[
                Text(
                  'YOUR CODE',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  summary.code,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 6,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_rounded, size: 17),
                  label: const Text('Copy code'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onShare,
                  icon: const Icon(Icons.share_rounded, size: 17),
                  label: const Text('Share'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColours.primaryDeep,
                    minimumSize: const Size(0, 44),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: onCopyLink,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Copy invite link instead'),
            ),
          ),
        ],
      ),
    );
  }
}

class _WithdrawCard extends StatelessWidget {
  const _WithdrawCard({required this.summary, required this.onWithdraw});

  final ReferralSummary summary;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    final bool hasPending = summary.withdrawals.any(
      (ReferralWithdrawal w) => w.isPending,
    );

    return EduvoraCard(
      shadows: AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            summary.canWithdraw
                ? 'You can withdraw ${formatNaira(summary.availableKobo)}'
                : 'Withdraw at ${formatNaira(summary.minWithdrawalKobo)}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColours.text,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (!summary.canWithdraw) ...<Widget>[
            ClipRRect(
              borderRadius: AppRadii.pill,
              child: LinearProgressIndicator(
                value: (summary.availableKobo / summary.minWithdrawalKobo)
                    .clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppColours.surfaceMuted,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${formatNaira(summary.shortfallKobo)} more to reach the '
              '${formatNaira(summary.minWithdrawalKobo)} minimum.',
              style: const TextStyle(
                fontSize: 12.5,
                color: AppColours.textMuted,
              ),
            ),
          ] else ...<Widget>[
            FilledButton.icon(
              onPressed: onWithdraw,
              icon: const Icon(Icons.payments_rounded, size: 18),
              label: const Text('Withdraw earnings'),
              style: FilledButton.styleFrom(minimumSize: const Size(0, 46)),
            ),
          ],
          if (hasPending) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'A withdrawal is waiting to be paid — you will get it by bank '
              'transfer.',
              style: TextStyle(fontSize: 12, color: AppColours.textMuted),
            ),
          ],
        ],
      ),
    );
  }
}

class _FriendCodeCard extends StatelessWidget {
  const _FriendCodeCard({
    required this.controller,
    required this.busy,
    required this.onApply,
  });

  final TextEditingController controller;
  final bool busy;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      shadows: AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Did a friend invite you?',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColours.text,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Enter their code before your first purchase so they earn from '
            'it. You can only do this once.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: AppColours.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: controller,
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 12,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                  ],
                  decoration: const InputDecoration(
                    hintText: 'Friend\'s code',
                    counterText: '',
                  ),
                  onSubmitted: (_) => onApply(),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton(
                onPressed: busy ? null : onApply,
                style: FilledButton.styleFrom(minimumSize: const Size(0, 50)),
                child: busy
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Apply'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.number, required this.text, this.last = false});

  final String number;
  final String text;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColours.primaryTint,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColours.primary,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.45,
                color: AppColours.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Collects bank details and the amount, then asks the server to record the
/// payout request. The server re-checks everything.
class _WithdrawSheet extends StatefulWidget {
  const _WithdrawSheet({required this.summary});

  final ReferralSummary summary;

  @override
  State<_WithdrawSheet> createState() => _WithdrawSheetState();
}

class _WithdrawSheetState extends State<_WithdrawSheet> {
  static const ReferralRepository _repo = ReferralRepository();

  late final TextEditingController _amount = TextEditingController(
    text: _plainNaira(widget.summary.availableKobo),
  );
  final TextEditingController _bank = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _name = TextEditingController();
  bool _busy = false;
  String? _error;

  static String _plainNaira(int kobo) =>
      kobo % 100 == 0 ? '${kobo ~/ 100}' : (kobo / 100).toStringAsFixed(2);

  @override
  void dispose() {
    _amount.dispose();
    _bank.dispose();
    _number.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final double? naira = double.tryParse(_amount.text.trim());
    if (naira == null) {
      setState(() => _error = 'Enter the amount you want to withdraw.');
      return;
    }
    final int kobo = (naira * 100).round();
    if (kobo < widget.summary.minWithdrawalKobo) {
      setState(
        () => _error =
            'The minimum withdrawal is '
            '${formatNaira(widget.summary.minWithdrawalKobo)}.',
      );
      return;
    }
    if (kobo > widget.summary.availableKobo) {
      setState(() => _error = 'That is more than your available balance.');
      return;
    }

    setState(() {
      _busy = true;
      _error = null;
    });
    final ReferralResult result = await _repo.requestWithdrawal(
      amountKobo: kobo,
      bankName: _bank.text,
      accountNumber: _number.text,
      accountName: _name.text,
    );
    if (!mounted) return;
    if (result.ok) {
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _busy = false;
        _error = result.error ?? 'Could not submit the request.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.sm,
        AppSpacing.xl,
        AppSpacing.xl + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Withdraw earnings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Available: ${formatNaira(widget.summary.availableKobo)} · '
            'minimum ${formatNaira(widget.summary.minWithdrawalKobo)}. '
            'We pay by bank transfer.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: const InputDecoration(
              labelText: 'Amount (₦)',
              prefixText: '₦ ',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _bank,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              labelText: 'Bank name',
              hintText: 'e.g. GTBank, Access, Opay',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _number,
            keyboardType: TextInputType.number,
            maxLength: 10,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            decoration: const InputDecoration(
              labelText: 'Account number',
              counterText: '',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          TextField(
            controller: _name,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(labelText: 'Name on the account'),
          ),
          if (_error != null) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            Text(
              _error!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColours.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: _busy ? null : _submit,
            style: FilledButton.styleFrom(minimumSize: const Size(0, 50)),
            child: _busy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Request withdrawal'),
          ),
        ],
      ),
    );
  }
}
