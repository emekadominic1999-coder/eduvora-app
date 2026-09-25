/// Ad unit ids for the AdMob banner and rewarded video.
///
/// The defaults below are Google's own TEST ids: they show clearly labelled
/// test ads and earn nothing. Before publishing, create the app in AdMob and
/// build with the real ids:
///
/// ```
/// flutter build appbundle --release \
///   --dart-define=ADMOB_BANNER_ANDROID=ca-app-pub-XXXX/YYYY \
///   --dart-define=ADMOB_REWARDED_ANDROID=ca-app-pub-XXXX/ZZZZ
/// ```
///
/// The AdMob *App id* (ca-app-pub-XXXX~NNNN) is not passed here — it lives in
/// `android/app/src/main/AndroidManifest.xml` and `ios/Runner/Info.plist`.
class AdConfig {
  const AdConfig._();

  static const String bannerAndroid = String.fromEnvironment(
    'ADMOB_BANNER_ANDROID',
    defaultValue: 'ca-app-pub-3940256099942544/6300978111',
  );
  static const String rewardedAndroid = String.fromEnvironment(
    'ADMOB_REWARDED_ANDROID',
    defaultValue: 'ca-app-pub-3940256099942544/5224354917',
  );
  static const String bannerIos = String.fromEnvironment(
    'ADMOB_BANNER_IOS',
    defaultValue: 'ca-app-pub-3940256099942544/2934735716',
  );
  static const String rewardedIos = String.fromEnvironment(
    'ADMOB_REWARDED_IOS',
    defaultValue: 'ca-app-pub-3940256099942544/1712485313',
  );
}
