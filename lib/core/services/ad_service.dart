import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoaded = false;

  // Use test ad unit ID for development. Replace with actual ID for production.
  final String _rewardedAdUnitId = defaultTargetPlatform == TargetPlatform.android
      ? 'ca-app-pub-3940256099942544/5224354917'
      : 'ca-app-pub-3940256099942544/1712485313';

  // Banner ad unit ID getter (AstroSaathi production Ad Unit ID)
  static String get bannerAdUnitId => defaultTargetPlatform == TargetPlatform.android
      ? 'ca-app-pub-2130675826290872/7456657453'
      : 'ca-app-pub-2130675826290872/7456657453';

  Future<void> init() async {
    await MobileAds.instance.initialize();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          debugPrint('Rewarded ad loaded.');
          _rewardedAd = ad;
          _isRewardedAdLoaded = true;

          // Automatically reload another ad when this one is dismissed or fails
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isRewardedAdLoaded = false;
              _loadRewardedAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _isRewardedAdLoaded = false;
              _loadRewardedAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Rewarded ad failed to load: $error');
          _isRewardedAdLoaded = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAd({required Function onUserEarnedReward, Function? onAdFailedToLoad}) {
    if (_isRewardedAdLoaded && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
          debugPrint('User earned reward: ${rewardItem.amount} ${rewardItem.type}');
          onUserEarnedReward();
        },
      );
    } else {
      debugPrint('Rewarded ad was not loaded yet.');
      if (onAdFailedToLoad != null) {
        onAdFailedToLoad();
      }
      _loadRewardedAd();
    }
  }
}
