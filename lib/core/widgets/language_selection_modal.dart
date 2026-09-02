import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_colors.dart';
import '../providers/locale_provider.dart';
import '../providers/astrology_provider.dart';
import '../../features/ai/presentation/providers/astro_baba_provider.dart';
import '../../l10n/app_localizations.dart';

class LanguageSelectionModal extends ConsumerWidget {
  const LanguageSelectionModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const LanguageSelectionModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context, ref);

    final languages = [
      AppLanguage.english,
      AppLanguage.hindi,
      AppLanguage.gujarati,
    ];

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.getSurface(context).withOpacity(0.96),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(top: BorderSide(color: AppColors.getGlassBorder(context), width: 1)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.getTextMuted(context),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Header title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.goldGradient,
                    ),
                    child: const Text('🌍', style: TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.chooseLanguage,
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.getTextPrimary(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          l10n.chooseLanguageSub,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.getTextSecondary(context),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Language Cards
              ...languages.map((lang) {
                final isSelected = currentLang == lang;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      ref.read(localeProvider.notifier).setLanguage(lang);
                      ref.invalidate(dailyGamePlanProvider);
                      ref.invalidate(panchangProvider);
                      ref.invalidate(birthChartProvider);
                      ref.invalidate(astroBabaProvider);
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.getPrimary(context).withOpacity(0.14)
                            : AppColors.getSurfaceSecondary(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppColors.getPrimary(context) : AppColors.getGlassBorder(context),
                          width: isSelected ? 1.5 : 0.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            lang.flagEmoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  lang.nativeName,
                                  style: GoogleFonts.outfit(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? AppColors.getPrimary(context) : AppColors.getTextPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  lang.englishName,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: AppColors.getTextSecondary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          if (isSelected)
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.getPrimary(context),
                              ),
                              child: const Icon(Icons.check, color: Colors.black, size: 16),
                            )
                          else
                            Icon(Icons.circle_outlined, color: AppColors.getTextMuted(context), size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
