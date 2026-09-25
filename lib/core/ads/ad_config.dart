import 'package:flutter/foundation.dart';

/// Ad unit ids for the AdMob banner and rewarded video.
///
/// Debug runs always use Google's TEST ids (clearly labelled test ads, no
/// earnings) so nobody ever taps live ads while developing — that can get an
/// AdMob account suspended. Release builds use the real ids below. An id left
/// empty falls back to the test id until it is supplied.
///
/// Either can be overridden at build time:
/// `--dart-define=ADMOB_BANNER_ANDROID=ca-app-pub-XXXX/YYYY`
///
/// The AdMob *App id* (ca-app-pub-XXXX~NNNN) is not passed here — it lives in
/// `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`.
class AdConfig {
  const AdConfig._();

  // Google's official test ids.
  static const String _testBannerAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String _testRewardedAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String _testBannerIos = 'ca-app-pub-3940256099942544/2934735716';
  static const String _testRewardedIos =
      'ca-app-pub-3940256099942544/1712485313';

  // Real ids from the "Eduvora University Learn" app in AdMob.
  static const String _liveBannerAndroid = String.fromEnvironment(
    'ADMOB_BANNER_ANDROID',
    defaultValue: 'ca-app-pub-9619956975441424/1484458666',
  );
  static const String _liveRewardedAndroid = String.fromEnvironment(
    'ADMOB_REWARDED_ANDROID',
    defaultValue: 'ca-app-pub-9619956975441424/9909743590',
  );
  static const String _liveBannerIos = String.fromEnvironment(
    'ADMOB_BANNER_IOS',
  );
  static const String _liveRewardedIos = String.fromEnvironment(
    'ADMOB_REWARDED_IOS',
  );

  static String _pick(String live, String test) =>
      kReleaseMode && live.isNotEmpty ? live : test;

  static String get bannerAndroid =>
      _pick(_liveBannerAndroid, _testBannerAndroid);
  static String get rewardedAndroid =>
      _pick(_liveRewardedAndroid, _testRewardedAndroid);
  static String get bannerIos => _pick(_liveBannerIos, _testBannerIos);
  static String get rewardedIos => _pick(_liveRewardedIos, _testRewardedIos);
}
