import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_config.dart';

/// How a rewarded-video attempt ended.
enum RewardResult {
  /// The student watched to the end and earned the reward.
  earned,

  /// The student closed the ad early.
  dismissed,

  /// No ad could be loaded (offline, no fill, or unsupported platform).
  unavailable,
}

/// Google AdMob for the Android and iOS apps: an anchored banner and an
/// optional rewarded video. Nothing here runs on the website.
class AdService {
  const AdService._();

  static bool get supported => Platform.isAndroid || Platform.isIOS;

  static Future<void>? _starting;

  /// Asks for ad consent where the law requires it (EU/UK), then starts the
  /// Mobile Ads SDK. Safe to call more than once.
  static Future<void> init() => _starting ??= _start();

  static Future<void> _start() async {
    if (!supported) return;
    try {
      final Completer<void> consent = Completer<void>();
      ConsentInformation.instance.requestConsentInfoUpdate(
        ConsentRequestParameters(),
        () async {
          try {
            await ConsentForm.loadAndShowConsentFormIfRequired(
              (FormError? _) {},
            );
          } catch (_) {}
          if (!consent.isCompleted) consent.complete();
        },
        (FormError _) {
          if (!consent.isCompleted) consent.complete();
        },
      );
      await consent.future.timeout(
        const Duration(seconds: 20),
        onTimeout: () {},
      );
      await MobileAds.instance.initialize();
    } catch (error) {
      debugPrint('[Eduvora] ads init failed: $error');
    }
  }

  static String get bannerId =>
      Platform.isIOS ? AdConfig.bannerIos : AdConfig.bannerAndroid;
  static String get rewardedId =>
      Platform.isIOS ? AdConfig.rewardedIos : AdConfig.rewardedAndroid;

  /// Loads and shows one rewarded video. The student chose to watch it, so
  /// this is only ever called from a tap.
  static Future<RewardResult> showRewarded() async {
    if (!supported) return RewardResult.unavailable;
    await init();
    try {
      if (!await ConsentInformation.instance.canRequestAds()) {
        return RewardResult.unavailable;
      }
    } catch (_) {}

    final Completer<RewardedAd?> loaded = Completer<RewardedAd?>();
    RewardedAd.load(
      adUnitId: rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          if (!loaded.isCompleted) loaded.complete(ad);
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('[Eduvora] rewarded failed to load: $error');
          if (!loaded.isCompleted) loaded.complete(null);
        },
      ),
    );
    final RewardedAd? ad = await loaded.future.timeout(
      const Duration(seconds: 15),
      onTimeout: () => null,
    );
    if (ad == null) return RewardResult.unavailable;

    bool earned = false;
    final Completer<void> closed = Completer<void>();
    ad.fullScreenContentCallback = FullScreenContentCallback<RewardedAd>(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        if (!closed.isCompleted) closed.complete();
      },
    );
    await ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      earned = true;
    });
    await closed.future;
    return earned ? RewardResult.earned : RewardResult.dismissed;
  }
}

/// A small anchored banner. Collapses to nothing while there is no ad, so it
/// never leaves an empty gap.
class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _ad;
  bool _ready = false;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started || !AdService.supported) return;
    _started = true;
    unawaited(_load());
  }

  Future<void> _load() async {
    await AdService.init();
    if (!mounted) return;
    try {
      if (!await ConsentInformation.instance.canRequestAds()) return;
    } catch (_) {}
    if (!mounted) return;
    final BannerAd ad = BannerAd(
      adUnitId: AdService.bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad _) {
          if (mounted) setState(() => _ready = true);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          debugPrint('[Eduvora] banner failed to load: $error');
          ad.dispose();
          if (mounted) setState(() => _ad = null);
        },
      ),
    );
    _ad = ad;
    await ad.load();
  }

  @override
  void dispose() {
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BannerAd? ad = _ad;
    if (!_ready || ad == null) return const SizedBox.shrink();
    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
