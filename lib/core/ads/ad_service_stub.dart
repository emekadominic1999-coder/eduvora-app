import 'package:flutter/widgets.dart';

/// How a rewarded-video attempt ended.
enum RewardResult {
  /// The student watched to the end and earned the reward.
  earned,

  /// The student closed the ad early.
  dismissed,

  /// No ad could be loaded (offline, no fill, or unsupported platform).
  unavailable,
}

/// Web / unsupported-platform stand-in: there are no ads on the website.
class AdService {
  const AdService._();

  static bool get supported => false;

  static Future<void> init() async {}

  static Future<RewardResult> showRewarded() async => RewardResult.unavailable;
}

/// Nothing to show where ads are unsupported.
class AdBanner extends StatelessWidget {
  const AdBanner({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
