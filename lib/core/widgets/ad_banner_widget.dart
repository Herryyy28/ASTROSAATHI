import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_colors.dart';
import '../theme/app_animations.dart';
import '../services/ad_service.dart';

/// Professional Ad Banner Widget supporting both Google Mobile Ads (BannerAd)
/// and a fallback high-converting Cosmic Promo Card UI when offline or ads are disabled.
class AdBannerWidget extends StatefulWidget {
  final String? adUnitId;
  final String placement; // 'home', 'horoscope', 'astrobaba', 'kundli', etc.
  final bool isDismissible;
  final VoidCallback? onAdClicked;

  const AdBannerWidget({
    super.key,
    this.adUnitId,
    this.placement = 'home',
    this.isDismissible = true,
    this.onAdClicked,
  });

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;
  bool _isDismissed = false;
  bool _isAdLoadingFailed = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    try {
      final unitId = widget.adUnitId ?? AdService.bannerAdUnitId;
      _bannerAd = BannerAd(
        adUnitId: unitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (!mounted) {
              ad.dispose();
              return;
            }
            setState(() {
              _isAdLoaded = true;
              _isAdLoadingFailed = false;
            });
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('BannerAd failed to load: $error');
            ad.dispose();
            if (mounted) {
              setState(() {
                _isAdLoaded = false;
                _isAdLoadingFailed = true;
              });
            }
          },
        ),
      );
      _bannerAd?.load();
    } catch (e) {
      debugPrint('Ad loading exception: $e');
      if (mounted) {
        setState(() {
          _isAdLoadingFailed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isDismissed) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _isAdLoaded && _bannerAd != null
          ? _buildGoogleAdContainer()
          : _buildCosmicPromoBannerContainer(),
    ).fadeSlideUp();
  }

  /// Outer container frame for Google Mobile Ads Banner
  Widget _buildGoogleAdContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.35), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.goldGlow.withOpacity(0.15),
            blurRadius: 16,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Header Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceHighlightDark,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 0.8),
                        ),
                        child: Text(
                          'AD',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Sponsored Cosmic Recommendation',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                      const Spacer(),
                      if (widget.isDismissible)
                        InkWell(
                          onTap: () => setState(() => _isDismissed = true),
                          child: const Padding(
                            padding: EdgeInsets.all(2),
                            child: Icon(Icons.close_rounded, size: 14, color: AppColors.textTertiaryDark),
                          ),
                        ),
                    ],
                  ),
                ),

                // Ad Content
                SizedBox(
                  width: _bannerAd!.size.width.toDouble(),
                  height: _bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// High-converting custom promotional banner when Google Mobile Ad is loading/failed
  Widget _buildCosmicPromoBannerContainer() {
    final promoInfo = _getPlacementPromoInfo(widget.placement);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.surfaceDark,
            AppColors.surfaceHighlightDark,
            promoInfo.accentColor.withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: promoInfo.accentColor.withOpacity(0.4),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: promoInfo.accentColor.withOpacity(0.18),
            blurRadius: 18,
            spreadRadius: -2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background cosmic motif circles
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: promoInfo.accentColor.withOpacity(0.08),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icon Circle Avatar
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          promoInfo.accentColor.withOpacity(0.3),
                          promoInfo.accentColor.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: promoInfo.accentColor.withOpacity(0.6),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      promoInfo.icon,
                      color: promoInfo.accentColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Title & Subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: promoInfo.accentColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: promoInfo.accentColor.withOpacity(0.5),
                                  width: 0.8,
                                ),
                              ),
                              child: Text(
                                promoInfo.badge,
                                style: GoogleFonts.outfit(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: promoInfo.accentColor,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                promoInfo.title,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimaryDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          promoInfo.subtitle,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondaryDark,
                            height: 1.25,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Action Button
                  ElevatedButton(
                    onPressed: () {
                      if (widget.onAdClicked != null) {
                        widget.onAdClicked!();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('✨ ${promoInfo.actionToast}'),
                            backgroundColor: AppColors.surfaceHighlightDark,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      backgroundColor: promoInfo.accentColor,
                      foregroundColor: Colors.black,
                      elevation: 4,
                      shadowColor: promoInfo.accentColor.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(0, 36),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      promoInfo.buttonText,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Dismiss Button
                  if (widget.isDismissible) ...[
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: () => setState(() => _isDismissed = true),
                      borderRadius: BorderRadius.circular(12),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: AppColors.textTertiaryDark,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _PromoInfo _getPlacementPromoInfo(String placement) {
    switch (placement) {
      case 'horoscope':
        return _PromoInfo(
          badge: 'FEATURED',
          title: '2026 Planetary Transit',
          subtitle: 'Detailed Saturn & Rahu predictions tailored for your Rashi',
          buttonText: 'View Report',
          icon: Icons.stars_rounded,
          accentColor: AppColors.secondary,
          actionToast: 'Opening 2026 Planetary Transit Analysis...',
        );
      case 'astrobaba':
        return _PromoInfo(
          badge: 'SPONSORED',
          title: 'Ask Astro Baba Premium',
          subtitle: 'Unlimited instant AI predictions & detailed Kundli remedies',
          buttonText: 'Try AI',
          icon: Icons.psychology_rounded,
          accentColor: const Color(0xFF00E5FF),
          actionToast: 'Astro Baba Premium activated for your session!',
        );
      case 'kundli':
        return _PromoInfo(
          badge: 'PRO',
          title: 'Unlimited Kundli Profiles',
          subtitle: 'Store full charts for friends & family with PDF export',
          buttonText: 'Upgrade',
          icon: Icons.workspace_premium_rounded,
          accentColor: AppColors.primary,
          actionToast: 'AstroSaathi Pro feature loaded!',
        );
      case 'home':
      default:
        return _PromoInfo(
          badge: 'AD / PROMO',
          title: 'AstroSaathi Premium',
          subtitle: 'Get 100% ad-free experience & instant PDF Kundli generation',
          buttonText: 'Explore',
          icon: Icons.auto_awesome_rounded,
          accentColor: AppColors.primary,
          actionToast: 'Redirecting to Premium Experience...',
        );
    }
  }
}

class _PromoInfo {
  final String badge;
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData icon;
  final Color accentColor;
  final String actionToast;

  _PromoInfo({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.icon,
    required this.accentColor,
    required this.actionToast,
  });
}
