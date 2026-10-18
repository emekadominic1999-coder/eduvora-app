import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;

import '../../../../core/models/cbt.dart';
import '../../../../core/models/cbt_entitlement.dart';
import '../../../../core/models/student_profile.dart';
import '../../../../core/services/cbt_repository.dart';
import '../../../../core/services/paywall_repository.dart';
import '../../../../core/services/study_repository.dart';
import '../../../../core/state/session_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../tutors/presentation/screens/tutor_directory_screen.dart';
import '../widgets/exam_setup_sheet.dart';
import '../../../../core/ads/ads.dart';
import '../widgets/paywall_sheet.dart';
import 'cbt_exam_screen.dart';
import 'cbt_payment_screen.dart';
import 'course_pack_picker_screen.dart';

/// The CBT lobby: papers relevant to the student, plus their own record.
class CbtHomeScreen extends StatefulWidget {
  const CbtHomeScreen({super.key});

  @override
  State<CbtHomeScreen> createState() => _CbtHomeScreenState();
}

class _CbtHomeScreenState extends State<CbtHomeScreen> {
  static const StudyRepository _study = StudyRepository();
  static const CbtRepository _cbt = CbtRepository();
  static const PaywallRepository _paywall = PaywallRepository();

  bool _showAllPapers = false;
  late Future<List<CbtSubject>> _future;
  List<CbtEntitlement> _entitlements = <CbtEntitlement>[];

  @override
  void initState() {
    super.initState();
    _future = _load();
    // Warm up a rewarded ad well before anyone taps "watch ad to unlock" --
    // a fresh on-tap load racing a timeout was the main reason students on
    // a slow connection got told no ad was available.
    AdService.preloadRewarded();
    // The Android/iOS paywall's "Unlock on the Eduvora website" card opens
    // this exact URL shape (see paywall_sheet.dart) so a student lands
    // straight on that one paper's unlock screen here instead of having to
    // find it again by hand.
    if (kIsWeb) _openDeepLinkedUnlock();
  }

  void _openDeepLinkedUnlock() {
    final String fragment = Uri.base.fragment;
    final int queryStart = fragment.indexOf('?');
    if (queryStart == -1) return;
    final String subjectId = Uri.splitQueryString(
      fragment.substring(queryStart + 1),
    )['unlock'] ?? '';
    if (subjectId.isEmpty) return;

    _future.then((List<CbtSubject> subjects) {
      if (!mounted) return;
      CbtSubject? subject;
      for (final CbtSubject s in subjects) {
        if (s.id == subjectId) {
          subject = s;
          break;
        }
      }
      if (subject == null) return;
      final CbtSubject found = subject;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _start(found);
      });
    });
  }

  Future<void> _loadEntitlements() async {
    final List<CbtEntitlement> entitlements = await _paywall.myEntitlements();
    if (mounted) setState(() => _entitlements = entitlements);
  }

  /// A paper is "for you" if it matches your current faculty, OR you already
  /// hold an active entitlement covering it -- a paper you paid for must
  /// never quietly drop out of your list just because you later edited your
  /// department/faculty.
  ///
  /// Deliberately checks the entitlement list directly rather than going
  /// through [PaywallRepository.hasAccess] — that method also honours the
  /// testing-only "unlock everything" override, which must only affect
  /// whether a locked paper can be *started* without paying, not which
  /// papers show up here as relevant. Routing this list through it too
  /// meant every paper looked relevant to every faculty while that override
  /// was on, which is exactly the bug this comment is now warning against.
  Future<List<CbtSubject>> _load() async {
    // On some startup paths (a browser tab reloading straight back into this
    // screen instead of the dashboard, for instance) this screen can build
    // and call _load() before the splash gate's own bootstrap has finished
    // restoring the profile. Reading a momentarily-null profile here doesn't
    // show an empty list -- it silently filters "for you" down to only the
    // general-studies papers (they pass regardless of faculty), which looks
    // like most of the bank vanished rather than like a loading state. Wait
    // for the real profile once rather than show that falsely short list.
    await sessionController.ensureLoaded();
    final StudentProfile? profile = sessionController.profile;
    final List<CbtEntitlement> entitlements = await _paywall.myEntitlements();
    if (mounted) setState(() => _entitlements = entitlements);

    final List<CbtSubject> all = await _cbt.all();
    if (_showAllPapers) return all;

    return all
        .where(
          (CbtSubject s) =>
              s.isRelevantTo(profile?.faculty ?? '') ||
              entitlements.any((CbtEntitlement e) => e.coversSubjectId(s.id)),
        )
        .toList();
  }

  void _toggleShowAll() {
    setState(() {
      _showAllPapers = !_showAllPapers;
      _future = _load();
    });
  }

  Future<void> _refresh() async {
    setState(() => _future = _load());
    await _future;
  }

  CbtEntitlement? _entitlementFor(String subjectId) {
    for (final CbtEntitlement e in _entitlements) {
      if (e.coversSubjectId(subjectId)) return e;
    }
    return null;
  }

  Future<void> _showDeviceBlockedDialog() => showDialog<void>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Already in use on another device'),
      content: const Text(
        "This paid access is already tied to a different phone. If this is "
        "your account and you've genuinely switched devices, contact "
        'support to move your access here.',
      ),
      actions: <Widget>[
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );

  // Set only by [_watchAdToUnlock] succeeding -- read once, right after
  // [_startFreeTrialOrPaywall] returns, to tell "Try again" on the result
  // screen whether this sitting needs another ad rather than being free to
  // retake (a paid or owned paper never does).
  bool _lastUnlockWasViaAd = false;

  /// The paper list holds summaries only; the questions are downloaded here,
  /// just before they are needed. Null (after telling the student) on failure.
  Future<CbtSubject?> _loadQuestions(CbtSubject subject) async {
    if (subject.hasQuestions) return subject;
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Loading paper…'),
        duration: Duration(seconds: 30),
      ),
    );
    try {
      final CbtSubject loaded = await _cbt.withQuestions(subject);
      messenger.hideCurrentSnackBar();
      return loaded;
    } catch (error) {
      debugPrint('[Eduvora] loading paper failed: $error');
      messenger.hideCurrentSnackBar();
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Could not load this paper. Check your connection and try again.',
          ),
        ),
      );
      return null;
    }
  }

  Future<void> _start(CbtSubject subject) async {
    bool unlocked = _paywall.hasAccess(subject, _entitlements);
    _lastUnlockWasViaAd = false;

    if (!unlocked) {
      final bool tried = await _startFreeTrialOrPaywall(subject);
      if (!tried || !mounted) return;
      unlocked = true;
    }

    // A paid entitlement (as opposed to the testing-unlock override) is
    // tied to whichever device first used it -- catches a student sharing
    // their login so a friend can sit the paper they didn't pay for.
    final CbtEntitlement? entitlement = _entitlementFor(subject.id);
    if (entitlement != null) {
      final DeviceCheckResult check = await _paywall.verifyDevice(
        entitlement,
      );
      if (!mounted) return;
      if (check == DeviceCheckResult.blockedOtherDevice) {
        await _showDeviceBlockedDialog();
        return;
      }
    }

    final CbtSubject? loaded = await _loadQuestions(subject);
    if (loaded == null || !mounted) return;

    // Ask how they want to sit it before the clock starts.
    final CbtExamConfig? config = await showExamSetupSheet(context, loaded);
    if (config == null || !mounted) return;

    final bool? completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CbtExamScreen(
          subject: loaded,
          config: config,
          adUnlocked: _lastUnlockWasViaAd,
        ),
      ),
    );
    if ((completed ?? false) && mounted) setState(() {});
  }

  /// A locked paper is offered a short, once-only free trial first. Once that
  /// is spent, this opens the paywall and, if the student pays, waits for the
  /// unlock before letting [_start] carry on into the exam setup sheet.
  ///
  /// Returns true once the student is clear to proceed to a normal (full,
  /// timed) sitting; false if they backed out anywhere along the way.
  Future<bool> _startFreeTrialOrPaywall(CbtSubject subject) async {
    if (!_paywall.hasUsedFreeTrial(subject.id)) {
      final bool wantsTrial = await _confirmFreeTrial(subject);
      if (!mounted || !wantsTrial) return false;

      // Load before burning the one-time trial, so a failed download does
      // not use it up.
      final CbtSubject? loaded = await _loadQuestions(subject);
      if (loaded == null || !mounted) return false;

      await _paywall.markFreeTrialUsed(subject.id);
      if (!mounted) return false;
      final int count = loaded.questionCount < PaywallRepository.freeTrialQuestionCount
          ? loaded.questionCount
          : PaywallRepository.freeTrialQuestionCount;
      final bool? completed = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => CbtExamScreen(
            subject: loaded,
            freeTrial: true,
            config: CbtExamConfig(
              questionCount: count,
              minutes: 10,
              shuffleQuestions: true,
              isCustom: true,
            ),
          ),
        ),
      );
      if (!mounted) return false;
      if (completed != true) return false; // they backed out of the trial
      setState(() {});
      // The trial is finished: offer the unlock straight away instead of
      // leaving the student to work out they must tap the paper again.
    }

    final PaywallChoice? choice = await showPaywallSheet(
      context,
      subject,
      allowAd: AdService.supported,
    );
    if (choice == null || !mounted) return false;

    if (choice == PaywallChoice.watchAd) return _watchAdToUnlock();

    if (choice == PaywallChoice.accessCode) return _redeemCode(subject);

    if (choice == PaywallChoice.coursePack) {
      final List<CbtSubject> all = await _cbt.all();
      if (!mounted) return false;
      final CoursePackSelection? selection = await showCoursePackPicker(
        context,
        all,
      );
      if (selection == null || selection.subjects.isEmpty || !mounted) {
        return false;
      }

      final bool? paid = await Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) => CbtPaymentScreen.coursePack(selection: selection),
        ),
      );
      if (paid != true || !mounted) return false;
      await _loadEntitlements();
      return true;
    }

    final bool? paid = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CbtPaymentScreen.singlePaper(subject: subject),
      ),
    );
    if (paid != true || !mounted) return false;

    await _loadEntitlements();
    return true;
  }

  /// Asks for an access code, redeems it, and reports whether [subject] is now
  /// open. The code itself is checked entirely server-side.
  Future<bool> _redeemCode(CbtSubject subject) async {
    final TextEditingController controller = TextEditingController();
    // A student who has just copied their code from the website should not
    // have to retype it: if the clipboard holds something shaped like a code
    // (letters and digits, groups of four), fill it in.
    try {
      final ClipboardData? clip = await Clipboard.getData(Clipboard.kTextPlain);
      final String pasted = (clip?.text ?? '').trim().toUpperCase();
      if (RegExp(r'^[A-Z0-9]{4}(-?[A-Z0-9]{4}){2}$').hasMatch(pasted)) {
        controller.text = pasted;
      }
    } catch (_) {
      // Clipboard access can be refused; typing the code still works.
    }
    if (!mounted) return false;
    String? error;
    bool busy = false;
    final bool? redeemed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) =>
            AlertDialog(
              title: const Text('Enter access code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextField(
                    controller: controller,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'XXXX-XXXX-XXXX',
                      errorText: error,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: busy
                      ? null
                      : () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: busy
                      ? null
                      : () async {
                          if (controller.text.trim().isEmpty) {
                            setDialogState(() => error = 'Enter your code.');
                            return;
                          }
                          setDialogState(() {
                            busy = true;
                            error = null;
                          });
                          try {
                            await _paywall.redeemAccessCode(controller.text);
                            if (dialogContext.mounted) {
                              Navigator.of(dialogContext).pop(true);
                            }
                          } catch (e) {
                            setDialogState(() {
                              busy = false;
                              error = e.toString().replaceFirst(
                                'Bad state: ',
                                '',
                              );
                            });
                          }
                        },
                  child: Text(busy ? 'Checking…' : 'Unlock'),
                ),
              ],
            ),
      ),
    );
    controller.dispose();
    if (redeemed != true || !mounted) return false;
    await _loadEntitlements();
    if (!mounted) return false;
    final bool open = _paywall.hasAccess(subject, _entitlements);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          open
              ? 'Code accepted. Your papers are unlocked.'
              : 'Code accepted. This paper is not part of that code, but '
                    'your other papers are now unlocked.',
        ),
      ),
    );
    return open;
  }

  /// The student chose to watch a short video instead of paying. Opens the
  /// paper for this one sitting once the video has been watched to the end.
  Future<bool> _watchAdToUnlock() async {
    final RewardResult result = await AdService.showRewarded();
    if (!mounted) return false;
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    switch (result) {
      case RewardResult.earned:
        _lastUnlockWasViaAd = true;
        return true;
      case RewardResult.dismissed:
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Watch the whole video to open the paper.'),
          ),
        );
        return false;
      case RewardResult.unavailable:
        // No ad could be loaded (offline or nothing to show). The paper stays
        // locked: it is only opened by a finished video, an access code or
        // payment, so the student is asked to try again in a moment.
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'No video is available right now. Please check your '
              'connection and try again in a moment.',
            ),
          ),
        );
        return false;
    }
  }

  Future<bool> _confirmFreeTrial(CbtSubject subject) async {
    final bool? proceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Try before you unlock'),
        content: Text(
          'This paper is locked, but you can try it free. You get '
          '${PaywallRepository.freeTrialQuestionCount} questions each time, '
          'and ${_paywall.freeTrialsLeft(subject.id)} free '
          '${_paywall.freeTrialsLeft(subject.id) == 1 ? 'try' : 'tries'} '
          'left on this paper. After that you can watch a short ad or pay to '
          'unlock it.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Start free trial'),
          ),
        ],
      ),
    );
    return proceed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final StudentProfile? profile = sessionController.profile;
    final List<CbtAttempt> attempts = _study.attempts();
    final double average = _study.averageScore();

    return Scaffold(
      backgroundColor: AppColours.background,
      appBar: AppBar(
        title: const Text('CBT practice'),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const TutorDirectoryScreen(),
              ),
            ),
            icon: const Icon(Icons.person_search_rounded),
            tooltip: 'Find a tutor',
          ),
          IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColours.border),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        color: AppColours.primary,
        child: FutureBuilder<List<CbtSubject>>(
          future: _future,
          builder:
              (BuildContext context, AsyncSnapshot<List<CbtSubject>> snapshot) {
                final List<CbtSubject> papers = snapshot.data ?? <CbtSubject>[];
                final bool loading =
                    snapshot.connectionState == ConnectionState.waiting;

                return ListView(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                  children: <Widget>[
                    _summary(
                      attempts.length,
                      average,
                      papers.fold(
                        0,
                        (int sum, CbtSubject s) => sum + s.questionCount,
                      ),
                    ),
                    const _Disclaimer(),
                    SectionHeader(
                      title: _showAllPapers ? 'All papers' : 'Papers for you',
                      subtitle: _showAllPapers
                          ? 'Every paper in the Eduvora bank'
                          : 'Matched to ${profile?.faculty.isNotEmpty == true ? profile!.faculty : 'your faculty'}',
                      actionLabel: _showAllPapers ? 'Show mine' : 'Show all',
                      onAction: _toggleShowAll,
                    ),
                    if (loading && papers.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (papers.isEmpty)
                      EmptyState(
                        icon: Icons.quiz_outlined,
                        title: 'No papers yet',
                        message: _showAllPapers
                            ? 'Real past questions will appear here once '
                                  'they are added.'
                            : 'Nothing has been added for '
                                  '${profile?.faculty.isNotEmpty == true ? profile!.faculty : 'your faculty'} '
                                  'yet — tap "Show all" to see every paper in '
                                  'the bank.',
                        compact: true,
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        child: Column(
                          children: papers.map((CbtSubject s) {
                            final CbtAttempt? best = _study.bestAttemptFor(
                              s.id,
                            );
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.md,
                              ),
                              child: _PaperCard(
                                subject: s,
                                best: best,
                                unlocked: _paywall.hasAccess(s, _entitlements),
                                trialAvailable: !_paywall.hasUsedFreeTrial(s.id),
                                onStart: () => _start(s),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    if (attempts.isNotEmpty) ...<Widget>[
                      const SectionHeader(
                        title: 'Your record',
                        subtitle: 'Every paper you have sat, most recent first',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.screenPadding,
                        ),
                        child: Column(
                          children: attempts
                              .take(12)
                              .map(
                                (CbtAttempt a) => Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: AppSpacing.sm,
                                  ),
                                  child: _AttemptRow(attempt: a),
                                ),
                              )
                              .toList(),
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

  Widget _summary(int papers, double average, int totalQuestions) {
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
            Row(
              children: <Widget>[
                const Icon(Icons.quiz_rounded, color: Colors.white, size: 22),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Practise like it is the real thing',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withValues(alpha: 0.96),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Timed papers, a question grid, flags for items to revisit, and '
              'a full explanation for every answer once you submit.',
              style: TextStyle(
                fontSize: 13,
                height: 1.55,
                color: Colors.white.withValues(alpha: 0.78),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: <Widget>[
                _MiniStat(
                  value: '$papers',
                  label: papers == 1 ? 'paper sat' : 'papers sat',
                ),
                const SizedBox(width: AppSpacing.xl),
                _MiniStat(
                  value: papers == 0 ? '—' : '${average.round()}%',
                  label: 'average score',
                ),
                const SizedBox(width: AppSpacing.xl),
                _MiniStat(value: '$totalQuestions', label: 'in the bank'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Makes clear this is independent practice, not an official exam.
class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.info_outline_rounded, size: 15, color: AppColours.textFaint),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Independent practice app. Not affiliated with or endorsed by '
              'the University of Nigeria, Nsukka or any school. These are '
              'practice questions, not official exam papers.',
              style: TextStyle(
                fontSize: 11.5,
                height: 1.4,
                color: AppColours.textFaint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          value,
          style: const TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.72),
          ),
        ),
      ],
    );
  }
}

class _PaperCard extends StatelessWidget {
  const _PaperCard({
    required this.subject,
    required this.best,
    required this.unlocked,
    required this.trialAvailable,
    required this.onStart,
  });

  final CbtSubject subject;
  final CbtAttempt? best;
  final bool unlocked;
  final bool trialAvailable;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      shadows: AppShadows.subtle,
      onTap: onStart,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color:
                          (subject.isGeneralStudies
                                  ? AppColours.accent
                                  : AppColours.primary)
                              .withValues(alpha: 0.12),
                      borderRadius: AppRadii.sm,
                    ),
                    child: Icon(
                      subject.isGeneralStudies
                          ? Icons.public_rounded
                          : Icons.menu_book_rounded,
                      size: 20,
                      color: subject.isGeneralStudies
                          ? AppColours.accent
                          : AppColours.primary,
                    ),
                  ),
                  if (!unlocked)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: const BoxDecoration(
                          color: AppColours.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          size: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      subject.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subject.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Pill(
                label: '${subject.questionCount} questions',
                icon: Icons.list_alt_rounded,
                dense: true,
              ),
              const SizedBox(width: 6),
              Pill(
                label: '${subject.minutesPerAttempt} min',
                icon: Icons.timer_outlined,
                colour: AppColours.accent,
                dense: true,
              ),
              if (best != null) ...<Widget>[
                const SizedBox(width: 6),
                Pill(
                  label:
                      'Best ${best!.marksAwarded}/${CbtAttempt.totalMarks}',
                  icon: Icons.emoji_events_rounded,
                  colour: AppColours.success,
                  dense: true,
                ),
              ],
              if (!unlocked) ...<Widget>[
                const SizedBox(width: 6),
                Pill(
                  label: trialAvailable ? 'Free trial' : 'Locked',
                  icon: trialAvailable
                      ? Icons.play_circle_outline_rounded
                      : Icons.lock_outline_rounded,
                  colour: AppColours.accent,
                  dense: true,
                ),
              ],
              const Spacer(),
              Icon(
                unlocked
                    ? Icons.play_circle_fill_rounded
                    : Icons.lock_rounded,
                color: unlocked ? AppColours.primary : AppColours.accent,
                size: unlocked ? 26 : 22,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttemptRow extends StatelessWidget {
  const _AttemptRow({required this.attempt});

  final CbtAttempt attempt;

  Color get _colour {
    final double p = attempt.percentage;
    if (p >= 70) return AppColours.success;
    if (p >= 50) return AppColours.info;
    if (p >= 40) return AppColours.warning;
    return AppColours.danger;
  }

  @override
  Widget build(BuildContext context) {
    return EduvoraCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      shadows: AppShadows.subtle,
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _colour.withValues(alpha: 0.12),
              borderRadius: AppRadii.sm,
            ),
            child: Text(
              attempt.grade,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: _colour,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  attempt.subjectName,
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
                  '${attempt.score}/${attempt.totalQuestions} · '
                  '${attempt.verdict} · ${relativeTime(attempt.takenAt)}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColours.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '${attempt.marksAwarded}/${CbtAttempt.totalMarks}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: _colour,
                ),
              ),
              Text(
                '${attempt.percentage.round()}%',
                style: const TextStyle(
                  fontSize: 10.5,
                  color: AppColours.textFaint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
