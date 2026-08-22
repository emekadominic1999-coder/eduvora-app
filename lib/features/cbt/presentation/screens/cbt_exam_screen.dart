import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/models/cbt.dart';
import '../../../../core/services/cbt_progress_store.dart';
import '../../../../core/services/local_store.dart';
import '../../../../core/services/study_repository.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../../../core/widgets/math_text.dart';
import 'cbt_result_screen.dart';

/// The exam itself: a countdown, one question at a time, a jump grid and
/// flags for questions worth revisiting.
class CbtExamScreen extends StatefulWidget {
  const CbtExamScreen({super.key, required this.subject, this.config});

  final CbtSubject subject;

  /// How the student chose to sit this paper. Falls back to the paper's own
  /// standard settings when the screen is opened without a choice.
  final CbtExamConfig? config;

  @override
  State<CbtExamScreen> createState() => _CbtExamScreenState();
}

class _CbtExamScreenState extends State<CbtExamScreen> {
  static const StudyRepository _study = StudyRepository();

  late final PageController _pages;
  final Map<String, int> _answers = <String, int>{};
  final Set<String> _flagged = <String>{};

  late final CbtExamConfig _config;
  late final List<CbtQuestion> _questions;
  late final int _totalSeconds;
  late int _remaining;
  Timer? _timer;
  int _index = 0;
  bool _submitted = false;
  bool _resumed = false;
  int _ticksSinceSave = 0;

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? CbtExamConfig.standard(widget.subject);

    final Map<String, dynamic>? saved = _readSavedProgress();
    if (saved != null) {
      _questions = (saved['questions'] as List<dynamic>)
          .map(
            (dynamic e) => CbtQuestion.fromJson(e as Map<String, dynamic>),
          )
          .toList();
      _answers.addAll(
        (saved['answers'] as Map<String, dynamic>).map(
          (String k, dynamic v) => MapEntry<String, int>(k, v as int),
        ),
      );
      _flagged.addAll((saved['flagged'] as List<dynamic>).cast<String>());
      _index = (saved['index'] as num).toInt().clamp(
        0,
        _questions.isEmpty ? 0 : _questions.length - 1,
      );
      _totalSeconds = (saved['totalSeconds'] as num).toInt();
      final DateTime savedAt = DateTime.parse(saved['savedAt'] as String);
      final int elapsed = DateTime.now().difference(savedAt).inSeconds;
      _remaining = ((saved['remaining'] as num).toInt() - elapsed).clamp(
        0,
        _totalSeconds,
      );
      _resumed = true;
    } else {
      // Built once, so the paper cannot reshuffle underneath the student.
      _questions = _config.buildPaper(widget.subject);
      _totalSeconds = _config.minutes * 60;
      _remaining = _totalSeconds;
    }

    _pages = PageController(initialPage: _index);
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);

    if (_resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_remaining <= 0) {
          _submit(auto: true);
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Picked up where you left off on this paper.'),
            duration: Duration(seconds: 3),
          ),
        );
      });
    }
  }

  /// Reads a saved in-progress attempt for this exact subject, if one exists
  /// and is recent enough to trust as an interruption rather than a
  /// long-abandoned attempt.
  Map<String, dynamic>? _readSavedProgress() {
    final Map<String, dynamic>? saved = CbtProgressStore.readValid();
    if (saved == null) return null;
    if (saved['subjectId'] != widget.subject.id) return null;
    return saved;
  }

  /// Persists everything needed to reconstruct this exact attempt — so a
  /// student never loses a paper to something outside their control, like
  /// the browser reclaiming a locked/backgrounded tab and reloading it from
  /// scratch. [HomeShell] uses the same saved record to walk the student
  /// straight back into this screen when that happens, rather than leaving
  /// them stranded on the dashboard. A deliberate exit clears this again
  /// (see [_leaveIfConfirmed]).
  Future<void> _saveProgress() async {
    if (!LocalStore.isReady || _submitted) return;
    await LocalStore.instance.writeMap(StoreKeys.cbtInProgress, <String, dynamic>{
      'subjectId': widget.subject.id,
      'subjectName': widget.subject.name,
      'questions': _questions.map((CbtQuestion q) => q.toJson()).toList(),
      'answers': _answers,
      'flagged': _flagged.toList(),
      'index': _index,
      'remaining': _remaining,
      'totalSeconds': _totalSeconds,
      'savedAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _clearSavedProgress() async {
    if (!LocalStore.isReady) return;
    final Map<String, dynamic>? saved = LocalStore.instance.readMap(
      StoreKeys.cbtInProgress,
    );
    if (saved != null && saved['subjectId'] == widget.subject.id) {
      await LocalStore.instance.remove(StoreKeys.cbtInProgress);
    }
  }

  void _tick(Timer timer) {
    if (!mounted) return;
    if (_remaining <= 1) {
      timer.cancel();
      setState(() => _remaining = 0);
      _submit(auto: true);
      return;
    }
    setState(() => _remaining--);
    // Every ~5s rather than every tick — frequent enough that a lost second
    // never costs more than that, without hammering storage every tick.
    _ticksSinceSave++;
    if (_ticksSinceSave >= 5) {
      _ticksSinceSave = 0;
      unawaited(_saveProgress());
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pages.dispose();
    super.dispose();
  }

  void _select(CbtQuestion question, int option) {
    setState(() => _answers[question.id] = option);
    unawaited(_saveProgress());
  }

  void _goTo(int index) {
    setState(() => _index = index);
    _pages.animateToPage(
      index,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _submit({bool auto = false}) async {
    if (_submitted) return;

    if (!auto) {
      final int unanswered = _questions.length - _answers.length;
      if (unanswered > 0) {
        final bool? proceed = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Submit now?'),
            content: Text(
              unanswered == 1
                  ? 'You have one question still unanswered. Would you like to '
                        'go back to it, or submit as you are?'
                  : 'You have $unanswered questions still unanswered. Would '
                        'you like to go back to them, or submit as you are?',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Go back'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(0, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        );
        if (!(proceed ?? false)) return;
      }
    }

    _submitted = true;
    _timer?.cancel();

    int score = 0;
    for (final CbtQuestion q in _questions) {
      if (_answers[q.id] == q.correctIndex) score++;
    }

    final CbtAttempt attempt = CbtAttempt(
      subjectId: widget.subject.id,
      subjectName: widget.subject.name,
      totalQuestions: _questions.length,
      answers: Map<String, int>.from(_answers),
      score: score,
      durationSeconds: _totalSeconds - _remaining,
      takenAt: DateTime.now(),
    );
    await _study.saveAttempt(attempt);
    await _clearSavedProgress();

    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => CbtResultScreen(
          subject: widget.subject,
          attempt: attempt,
          questions: _questions,
          config: _config,
          autoSubmitted: auto,
        ),
      ),
    );
  }

  Future<bool> _confirmExit() async {
    if (_submitted) return true;
    final bool? leave = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Leave this paper?'),
        content: const Text(
          'Your answers will not be saved if you leave now. There is no rush '
          '— you may take the paper again whenever you wish.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Stay'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColours.danger),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  /// Asks before abandoning the paper, then pops if the student confirms.
  Future<void> _leaveIfConfirmed() async {
    final bool leave = await _confirmExit();
    if (!leave) return;
    await _clearSavedProgress();
    if (!mounted) return;
    Navigator.of(context).pop(false);
  }

  String get _clock {
    final int minutes = _remaining ~/ 60;
    final int seconds = _remaining % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  bool get _lowTime => _remaining <= 60;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) return;
        _leaveIfConfirmed();
      },
      child: Scaffold(
        backgroundColor: AppColours.background,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            onPressed: _leaveIfConfirmed,
          ),
          title: Text(
            widget.subject.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: AppSpacing.sm,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _lowTime
                    ? AppColours.dangerSoft
                    : AppColours.primaryTint,
                borderRadius: AppRadii.pill,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.timer_outlined,
                    size: 15,
                    color: _lowTime ? AppColours.danger : AppColours.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _clock,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      fontFeatures: const <FontFeature>[
                        FontFeature.tabularFigures(),
                      ],
                      color: _lowTime ? AppColours.danger : AppColours.primary,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _submit(),
              style: TextButton.styleFrom(
                foregroundColor: AppColours.success,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                minimumSize: const Size(0, 34),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
          ],
        ),
        body: Column(
          children: <Widget>[
            _progressBar(),
            _grid(),
            Expanded(
              child: PageView.builder(
                controller: _pages,
                onPageChanged: (int i) => setState(() => _index = i),
                itemCount: _questions.length,
                itemBuilder: (BuildContext context, int index) =>
                    _questionView(_questions[index], index),
              ),
            ),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _progressBar() {
    final double fraction = _questions.isEmpty
        ? 0
        : _answers.length / _questions.length;
    return Container(
      color: AppColours.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        0,
        AppSpacing.screenPadding,
        AppSpacing.md,
      ),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 6,
              backgroundColor: AppColours.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColours.primary,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: <Widget>[
              Text(
                'Question ${_index + 1} of ${_questions.length}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColours.textMuted,
                ),
              ),
              const Spacer(),
              Text(
                '${_answers.length} answered',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColours.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _grid() {
    return Container(
      height: 52,
      color: AppColours.surface,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenPadding,
          0,
          AppSpacing.screenPadding,
          AppSpacing.md,
        ),
        itemCount: _questions.length,
        separatorBuilder: (_, _) => const SizedBox(width: 7),
        itemBuilder: (BuildContext context, int index) {
          final CbtQuestion q = _questions[index];
          final bool answered = _answers.containsKey(q.id);
          final bool current = index == _index;
          final bool flagged = _flagged.contains(q.id);

          Color background;
          Color foreground;
          if (current) {
            background = AppColours.primary;
            foreground = Colors.white;
          } else if (flagged) {
            background = AppColours.warningSoft;
            foreground = const Color(0xFF854D0E);
          } else if (answered) {
            background = AppColours.successSoft;
            foreground = AppColours.success;
          } else {
            background = AppColours.surfaceMuted;
            foreground = AppColours.textMuted;
          }

          return GestureDetector(
            onTap: () => _goTo(index),
            child: Container(
              width: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: background,
                borderRadius: AppRadii.sm,
                border: flagged && !current
                    ? Border.all(color: AppColours.warning, width: 1.3)
                    : null,
              ),
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: foreground,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _questionView(CbtQuestion question, int index) {
    final int? selected = _answers[question.id];
    final bool flagged = _flagged.contains(question.id);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      children: <Widget>[
        Row(
          children: <Widget>[
            if (question.topic.isNotEmpty)
              Pill(label: question.topic, dense: true),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  flagged
                      ? _flagged.remove(question.id)
                      : _flagged.add(question.id);
                });
                unawaited(_saveProgress());
              },
              icon: Icon(
                flagged ? Icons.flag_rounded : Icons.flag_outlined,
                size: 17,
              ),
              style: TextButton.styleFrom(
                foregroundColor: flagged
                    ? AppColours.warning
                    : AppColours.textMuted,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              label: Text(flagged ? 'Flagged' : 'Flag'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        MathText(
          _stripMarkdown(question.question),
          style: const TextStyle(
            fontSize: 17,
            height: 1.5,
            fontWeight: FontWeight.w400,
            color: AppColours.text,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ...List<Widget>.generate(question.options.length, (int i) {
          final bool active = selected == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: EduvoraCard(
              onTap: () => _select(question, i),
              padding: const EdgeInsets.all(AppSpacing.lg),
              shadows: AppShadows.subtle,
              colour: active ? AppColours.primaryTint : AppColours.surface,
              border: Border.all(
                color: active ? AppColours.primary : AppColours.border,
                width: active ? 1.7 : 1,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColours.primary
                          : AppColours.surfaceMuted,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      CbtQuestion.letterFor(i),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: active ? Colors.white : AppColours.textMuted,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: MathText(
                        question.options[i],
                        style: TextStyle(
                          fontSize: 15.5,
                          height: 1.45,
                          fontWeight: active
                              ? FontWeight.w500
                              : FontWeight.w400,
                          color: active
                              ? AppColours.primaryDeep
                              : AppColours.text,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  Widget _bottomBar() {
    final bool isLast = _index == _questions.length - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        AppSpacing.md,
        AppSpacing.screenPadding,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColours.surface,
        border: Border(top: BorderSide(color: AppColours.border)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: <Widget>[
            if (_index > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _goTo(_index - 1),
                  child: const Text('Previous'),
                ),
              ),
            if (_index > 0) const SizedBox(width: AppSpacing.md),
            Expanded(
              flex: _index > 0 ? 1 : 2,
              child: FilledButton(
                onPressed: isLast ? () => _submit() : () => _goTo(_index + 1),
                style: isLast
                    ? FilledButton.styleFrom(
                        backgroundColor: AppColours.success,
                      )
                    : null,
                child: Text(isLast ? 'Submit paper' : 'Next'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The bank uses light markdown emphasis for key terms; the exam view shows
  /// plain text so nothing renders as stray asterisks.
  static String _stripMarkdown(String value) =>
      value.replaceAll('**', '').replaceAll('__', '');
}
