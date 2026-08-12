import 'package:flutter/material.dart';

import '../../../../core/models/tutor.dart';
import '../../../../core/services/supabase_service.dart';
import '../../../../core/services/tutor_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../widgets/confirm_session_sheet.dart';
import '../widgets/withdraw_sheet.dart';
import 'session_payment_screen.dart';

/// Both halves of the marketplace in one place: the sessions a student has
/// booked, and — for anyone who also tutors — the requests coming in and
/// what they have earned.
class TutorSessionsScreen extends StatefulWidget {
  const TutorSessionsScreen({super.key});

  @override
  State<TutorSessionsScreen> createState() => _TutorSessionsScreenState();
}

class _TutorSessionsScreenState extends State<TutorSessionsScreen> {
  static const TutorRepository _tutors = TutorRepository();

  late Future<_SessionsData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_SessionsData> _load() async {
    final List<TutorSession> sessions = await _tutors.mySessions();
    final Tutor? mine = await _tutors.myTutorProfile();
    return _SessionsData(sessions: sessions, myProfile: mine);
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  Future<void> _pay(TutorSession session) async {
    final bool? paid = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => SessionPaymentScreen(session: session),
      ),
    );
    if ((paid ?? false) && mounted) _refresh();
  }

  Future<void> _accept(TutorSession session) async {
    await _tutors.setSessionStatus(session.id, TutorSessionStatus.accepted);
    if (mounted) _refresh();
  }

  Future<void> _cancel(TutorSession session) async {
    await _tutors.setSessionStatus(session.id, TutorSessionStatus.cancelled);
    if (mounted) _refresh();
  }

  Future<void> _confirm(TutorSession session) async {
    final bool? done = await showConfirmSessionSheet(context, session: session);
    if ((done ?? false) && mounted) _refresh();
  }

  Future<void> _withdraw(Tutor tutor) async {
    final bool? requested = await showWithdrawSheet(context, tutor: tutor);
    if ((requested ?? false) && mounted) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final String? me = SupabaseService.currentUser?.id;

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('My sessions'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColours.primary,
        child: FutureBuilder<_SessionsData>(
          future: _future,
          builder:
              (BuildContext context, AsyncSnapshot<_SessionsData> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final _SessionsData? data = snapshot.data;
                final List<TutorSession> all =
                    data?.sessions ?? <TutorSession>[];
                final Tutor? mine = data?.myProfile;

                final List<TutorSession> booked = all
                    .where((TutorSession s) => s.studentId == me)
                    .toList();
                final List<TutorSession> teaching = mine == null
                    ? <TutorSession>[]
                    : all
                          .where((TutorSession s) => s.tutorId == mine.id)
                          .toList();

                if (booked.isEmpty && teaching.isEmpty) {
                  return ListView(
                    children: const <Widget>[
                      SizedBox(height: AppSpacing.xxl),
                      EmptyState(
                        icon: Icons.event_note_outlined,
                        title: 'No sessions yet',
                        message:
                            'Book a tutor and your sessions will appear here, '
                            'along with anything you are teaching.',
                      ),
                    ],
                  );
                }

                return ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  children: <Widget>[
                    if (mine != null) _Earnings(
                      tutor: mine,
                      onWithdraw: () => _withdraw(mine),
                    ),
                    if (teaching.isNotEmpty) ...<Widget>[
                      const SectionHeader(
                        title: 'You are teaching',
                        subtitle: 'Requests and confirmed sessions',
                      ),
                      ...teaching.map(
                        (TutorSession s) => Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.screenPadding,
                            0,
                            AppSpacing.screenPadding,
                            AppSpacing.sm,
                          ),
                          child: _SessionRow(
                            session: s,
                            asTutor: true,
                            onAccept: s.status == TutorSessionStatus.requested
                                ? () => _accept(s)
                                : null,
                            onCancel:
                                s.status == TutorSessionStatus.requested ||
                                    s.status == TutorSessionStatus.accepted
                                ? () => _cancel(s)
                                : null,
                          ),
                        ),
                      ),
                    ],
                    if (booked.isNotEmpty) ...<Widget>[
                      const SectionHeader(
                        title: 'You booked',
                        subtitle: 'Sessions you are taking',
                      ),
                      ...booked.map(
                        (TutorSession s) => Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.screenPadding,
                            0,
                            AppSpacing.screenPadding,
                            AppSpacing.sm,
                          ),
                          child: _SessionRow(
                            session: s,
                            asTutor: false,
                            onPay: s.awaitingPayment ? () => _pay(s) : null,
                            onConfirm: s.status == TutorSessionStatus.paid
                                ? () => _confirm(s)
                                : null,
                            onCancel:
                                s.status == TutorSessionStatus.requested ||
                                    s.status == TutorSessionStatus.accepted
                                ? () => _cancel(s)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              },
        ),
      ),
    );
  }
}

class _SessionsData {
  const _SessionsData({required this.sessions, required this.myProfile});

  final List<TutorSession> sessions;
  final Tutor? myProfile;
}

class _Earnings extends StatelessWidget {
  const _Earnings({required this.tutor, required this.onWithdraw});

  final Tutor tutor;
  final VoidCallback onWithdraw;

  @override
  Widget build(BuildContext context) {
    final bool canWithdraw =
        tutor.balanceKobo >= TutorRepository.minPayoutKobo;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.lg,
        AppSpacing.screenPadding,
        0,
      ),
      child: Container(
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
              'Available to withdraw',
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '₦${tutor.balanceNaira.round()}',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Earned in total: ₦${tutor.lifetimeEarnedNaira.round()} · '
              '${tutor.sessionsCompleted} '
              '${tutor.sessionsCompleted == 1 ? 'session' : 'sessions'}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: canWithdraw ? onWithdraw : null,
              icon: const Icon(Icons.account_balance_rounded, size: 18),
              label: Text(
                canWithdraw
                    ? 'Withdraw'
                    : 'Withdraw at ₦${TutorRepository.minPayoutKobo ~/ 100}',
              ),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColours.primaryDeep,
                disabledBackgroundColor: Colors.white.withValues(alpha: 0.35),
                disabledForegroundColor: Colors.white.withValues(alpha: 0.75),
                minimumSize: const Size(0, 42),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.session,
    required this.asTutor,
    this.onPay,
    this.onAccept,
    this.onConfirm,
    this.onCancel,
  });

  final TutorSession session;
  final bool asTutor;
  final VoidCallback? onPay;
  final VoidCallback? onAccept;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  Color get _statusColour => switch (session.status) {
    TutorSessionStatus.requested => AppColours.info,
    TutorSessionStatus.accepted => AppColours.warning,
    TutorSessionStatus.paid => AppColours.primary,
    TutorSessionStatus.completed => AppColours.success,
    TutorSessionStatus.cancelled => AppColours.textMuted,
    TutorSessionStatus.disputed => AppColours.danger,
  };

  @override
  Widget build(BuildContext context) {
    final bool hasActions =
        onPay != null ||
        onAccept != null ||
        onConfirm != null ||
        onCancel != null;

    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      session.subjectName.isEmpty
                          ? session.subjectId
                          : session.subjectName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      <String>[
                        session.durationLabel,
                        session.meetingMode.label,
                        if (session.topic.trim().isNotEmpty) session.topic,
                      ].join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColours.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              if (session.amountKobo > 0)
                Text(
                  asTutor
                      ? '₦${session.tutorEarningsNaira.round()}'
                      : '₦${session.amountNaira.round()}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColours.text,
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: <Widget>[
              Pill(
                label: asTutor
                    ? session.status.tutorLabel
                    : session.status.studentLabel,
                colour: _statusColour,
                dense: true,
              ),
              if (asTutor && session.status == TutorSessionStatus.completed)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Pill(
                    label: 'Paid to balance',
                    icon: Icons.savings_rounded,
                    colour: AppColours.success,
                    dense: true,
                  ),
                ),
            ],
          ),
          if (hasActions) ...<Widget>[
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: <Widget>[
                if (onAccept != null)
                  Expanded(
                    child: FilledButton(
                      onPressed: onAccept,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 38),
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                if (onPay != null)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onPay,
                      icon: const Icon(Icons.lock_rounded, size: 16),
                      label: const Text('Pay now'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 38),
                      ),
                    ),
                  ),
                if (onConfirm != null)
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: onConfirm,
                      icon: const Icon(Icons.check_rounded, size: 16),
                      label: const Text('It happened'),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 38),
                        backgroundColor: AppColours.success,
                      ),
                    ),
                  ),
                if (onCancel != null) ...<Widget>[
                  if (onAccept != null || onPay != null || onConfirm != null)
                    const SizedBox(width: AppSpacing.sm),
                  TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColours.danger,
                      minimumSize: const Size(0, 38),
                    ),
                    child: const Text('Cancel'),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
