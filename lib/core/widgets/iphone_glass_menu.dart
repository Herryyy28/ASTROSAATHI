import 'dart:ui';
import '../../features/ai/presentation/screens/astro_baba_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import 'zodiac_icon.dart';
import '../providers/locale_provider.dart';
import '../providers/profile_provider.dart';
import '../providers/astrology_provider.dart';
import '../../features/ai/presentation/providers/astro_baba_provider.dart';
import '../../features/astrology/services/pdf_report_generator.dart';
import '../../features/search/presentation/screens/astrology_search_screen.dart';
import '../../features/support/presentation/screens/trust_center_screen.dart';
import '../../features/panchang/presentation/screens/panchang_screen.dart';
import '../../features/matching/presentation/screens/matching_screen.dart';
import '../../features/remedies/presentation/screens/remedy_hub_screen.dart';
import '../../features/muhurat/presentation/screens/muhurat_screen.dart';
import '../providers/subscription_provider.dart';

class IPhoneGlassMenu {
  static void show(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return const _IPhoneGlassMenuContent();
      },
    );
  }
}

class _IPhoneGlassMenuContent extends ConsumerWidget {
  const _IPhoneGlassMenuContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(localeProvider);
    final activeProfile = ref.watch(activeProfileProvider);

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
          decoration: BoxDecoration(
            color: const Color(0xEB0E121A),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
            border: Border.all(
              color: AppColors.glassBorder.withOpacity(0.8),
              width: 0.8,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40D4AF37),
                blurRadius: 40,
                spreadRadius: -10,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Sheet Handle Bar
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiaryDark.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 18),

                // Title Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.goldSubtleGradient,
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.4),
                                width: 0.8,
                              ),
                            ),
                            child: const Text(
                              '✦',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Cosmic Menu & Tools',
                              style: GoogleFonts.outfit(
                                color: AppColors.textPrimaryDark,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppColors.textSecondaryDark,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                 const SizedBox(height: 16),

                // 2-Column Grid of Tools
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.85,
                  children: [
                    _glassMenuItem(
                      context,
                      icon: Icons.picture_as_pdf_rounded,
                      title: 'PDF Kundli',
                      subtitle: 'Print & Download',
                      color: AppColors.primary,
                      onTap: () async {
                        Navigator.pop(context);
                        await PdfReportGenerator.downloadAndPrintPdf(
                          userName: activeProfile.name,
                          dob: activeProfile.dob,
                          birthTime: activeProfile.birthTime,
                          birthPlace: activeProfile.birthPlace,
                          language: currentLang,
                        );
                      },
                    ),
                    _glassMenuItem(
                      context,
                      icon: Icons.psychology_rounded,
                      title: 'Astro Baba AI',
                      subtitle: 'Ask Any Question',
                      color: Colors.cyanAccent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AstroBabaScreen(),
                          ),
                        );
                      },
                    ),
                    _glassMenuItem(
                      context,
                      icon: Icons.wb_sunny_rounded,
                      title: 'Panchang',
                      subtitle: 'Tithi & Rahu Kaal',
                      color: Colors.amber,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PanchangScreen(),
                          ),
                        );
                      },
                    ),
                    _glassMenuItem(
                      context,
                      icon: Icons.favorite_rounded,
                      title: 'Matching',
                      subtitle: 'Guna & Kundli Milan',
                      color: Colors.pinkAccent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MatchingScreen(),
                          ),
                        );
                      },
                    ),
                    _glassMenuItem(
                      context,
                      icon: Icons.auto_fix_high_rounded,
                      title: 'Remedies',
                      subtitle: 'Mantras & Gems',
                      color: Colors.purpleAccent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RemedyHubScreen(),
                          ),
                        );
                      },
                    ),
                    _glassMenuItem(
                      context,
                      icon: Icons.access_time_filled_rounded,
                      title: 'Muhurat',
                      subtitle: 'Shubh Windows',
                      color: Colors.orangeAccent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MuhuratScreen(),
                          ),
                        );
                      },
                    ),
                    _glassMenuItem(
                      context,
                      icon: Icons.search_rounded,
                      title: 'Glossary',
                      subtitle: 'Search Vedic Terms',
                      color: Colors.lightBlueAccent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AstrologySearchScreen(),
                          ),
                        );
                      },
                    ),
                    _glassMenuItem(
                      context,
                      icon: Icons.shield_rounded,
                      title: 'Trust Center',
                      subtitle: 'Privacy & Safety',
                      color: Colors.greenAccent,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const TrustCenterScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Language Selector Row
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.glassBorder,
                      width: 0.6,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.language_rounded,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Language',
                        style: GoogleFonts.outfit(
                          color: AppColors.textPrimaryDark,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ...AppLanguage.values.map((lang) {
                                final isSelected = currentLang == lang;
                                return Padding(
                                  padding: const EdgeInsets.only(left: 6),
                                  child: ChoiceChip(
                                    label: Text(
                                      '${lang.flagEmoji} ${lang.code.toUpperCase()}',
                                    ),
                                    selected: isSelected,
                                    selectedColor: AppColors.primary,
                                    backgroundColor:
                                        AppColors.surfaceHighlightDark,
                                    labelStyle: TextStyle(
                                      color: isSelected
                                          ? Colors.black
                                          : AppColors.textPrimaryDark,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 11,
                                    ),
                                    onSelected: (sel) {
                                      if (sel) {
                                        ref
                                            .read(localeProvider.notifier)
                                            .setLanguage(lang);
                                        ref.invalidate(dailyGamePlanProvider);
                                        ref.invalidate(panchangProvider);
                                        ref.invalidate(birthChartProvider);
                                        ref.invalidate(astroBabaProvider);
                                      }
                                    },
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _glassMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x99151D2C),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.35), width: 0.8),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: -2,
            ),
          ],
        ),
        child: Row(
          children: [
            CosmicIconBadge(
              icon: icon,
              size: 18,
              color: color,
              isGlowing: true,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: AppColors.textTertiaryDark,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
