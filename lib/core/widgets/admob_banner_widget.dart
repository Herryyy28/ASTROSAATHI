import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../providers/subscription_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../../features/subscription/presentation/screens/premium_upgrade_modal.dart';

/// AdMob Banner Widget that displays ads on Normal Free Accounts,
/// but COMPLETELY HIDES ads when the user has an active VIP Subscription.
class AdMobBannerWidget extends ConsumerStatefulWidget {
  final AdSize adSize;

  const AdMobBannerWidget({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  ConsumerState<AdMobBannerWidget> createState() => _AdMobBannerWidgetState();
}

class _AdMobBannerWidgetState extends ConsumerState<AdMobBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _initAd();
  }

  void _initAd() {
    // Do not load ads if user is already premium
    final isPremium = ref.read(isPremiumProvider);
    if (isPremium) return;

    if (kIsWeb) return;

    final String adUnitId = Platform.isAndroid
        ? (kDebugMode
            ? 'ca-app-pub-3940256099942544/6300978111' // Google Android Test Banner ID
            : 'ca-app-pub-2130675826290872/6020392051') // Production AstroSaathi AdMob Banner ID
        : 'ca-app-pub-3940256099942544/2934735716';

    try {
      _bannerAd = BannerAd(
        adUnitId: adUnitId,
        size: widget.adSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted) {
              setState(() {
                _isAdLoaded = true;
              });
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (mounted) {
              setState(() {
                _bannerAd = null;
                _isAdLoaded = false;
              });
            }
          },
        ),
      );
      _bannerAd?.load();
    } catch (e) {
      debugPrint('AdMob load error: $e');
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── CRITICAL SUBSCRIPTION CHECK ─────────────────────────────────────
    // When user subscribes (VIP / Premium), IMMEDIATELY HIDE ALL ADS!
    final isPremium = ref.watch(isPremiumProvider);
    if (isPremium) {
      return const SizedBox.shrink();
    }

    // ── NORMAL ACCOUNT: SHOW ADMOB BANNER ──────────────────────────────
    if (_isAdLoaded && _bannerAd != null) {
      return Container(
        alignment: Alignment.center,
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // Fallback card for normal accounts when ad is loading or on web/test platforms
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onTap: () => PremiumUpgradeModal.show(context),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: const Text(
                'AD',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'AdMob Sponsored Partner',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Tap to upgrade to VIP & remove all ads permanently',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondaryDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700).withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Remove Ads 👑',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
