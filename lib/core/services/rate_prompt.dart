import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';

import '../theme/app_theme.dart';
import 'local_store.dart';

/// Asks happy students to rate Eduvora on Google Play, without nagging.
///
/// The prompt shows at most twice: after a student has finished a few exams
/// and did reasonably well, and once more much later. Anyone who taps
/// "Rate us" is never asked again. The Profile screen has a permanent
/// "Rate Eduvora" row for anyone who wants to do it on their own.
class RatePrompt {
  const RatePrompt._();

  static const String _examsKey = 'eduvora.rate.exams_done';
  static const String _askedKey = 'eduvora.rate.asked';
  static const String _ratedKey = 'eduvora.rate.rated';

  static const int firstAskAfterExams = 3;
  static const int secondAskAfterExams = 12;

  static bool get _supported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static int _int(String key) =>
      int.tryParse(LocalStore.instance.readString(key) ?? '') ?? 0;

  /// Call once each time a student sees their exam result.
  static Future<void> afterExam(
    BuildContext context, {
    required double percentage,
  }) async {
    if (!_supported || !LocalStore.isReady) return;
    final LocalStore store = LocalStore.instance;
    final int done = _int(_examsKey) + 1;
    await store.writeString(_examsKey, '$done');

    if (store.readBool(_ratedKey) || percentage < 50) return;
    final int asked = _int(_askedKey);
    final bool due =
        (asked == 0 && done >= firstAskAfterExams) ||
        (asked == 1 && done >= secondAskAfterExams);
    if (!due) return;

    await store.writeString(_askedKey, '${asked + 1}');
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!context.mounted) return;
    final bool? yes = await showDialog<bool>(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Enjoying Eduvora?'),
        content: const Text(
          'Your rating helps other students find us. It takes less than '
          'ten seconds.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Maybe later'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColours.primary),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Rate us'),
          ),
        ],
      ),
    );
    if (yes == true) await rateNow();
  }

  /// Opens Google's rating box, or the Play Store page when the box is not
  /// available. Safe to call from a button.
  static Future<void> rateNow() async {
    if (LocalStore.isReady) {
      await LocalStore.instance.writeBool(_ratedKey, value: true);
    }
    if (!_supported) return;
    try {
      final InAppReview review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
      } else {
        await review.openStoreListing();
      }
    } catch (error) {
      debugPrint('[Eduvora] rating prompt failed: $error');
      try {
        await InAppReview.instance.openStoreListing();
      } catch (_) {}
    }
  }

  static bool get canRateFromProfile => _supported;
}

/// Drop this anywhere in a result screen. It draws nothing and asks, once per
/// sitting, whether the rating prompt is due.
class RatePromptTrigger extends StatefulWidget {
  const RatePromptTrigger({super.key, required this.percentage});

  final double percentage;

  @override
  State<RatePromptTrigger> createState() => _RatePromptTriggerState();
}

class _RatePromptTriggerState extends State<RatePromptTrigger> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) RatePrompt.afterExam(context, percentage: widget.percentage);
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
