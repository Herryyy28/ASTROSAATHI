import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/locale_provider.dart';
import '../theme/app_colors.dart';

/// Interactive modal/drawer displaying the 9 authentic Indian language ribbons
/// inspired by the AstroSage multi-language experience.
class NineLanguagesModal extends ConsumerWidget {
  const NineLanguagesModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NineLanguagesModal(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(localeProvider);
    final isLight = Theme.of(context).brightness == Brightness.light;

    const languages = [
      AppLanguage.english,
      AppLanguage.hindi,
      AppLanguage.tamil,
      AppLanguage.kannada,
      AppLanguage.malayalam,
      AppLanguage.gujarati,
      AppLanguage.marathi,
      AppLanguage.bengali,
      AppLanguage.telugu,
    ];

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isLight ? Colors.white.withValues(alpha: 0.96) : AppColors.surfaceDark.withValues(alpha: 0.96),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(top: BorderSide(color: AppColors.getGlassBorder(context), width: 1.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: AppColors.getTextMuted(context).withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.goldGradient,
                      ),
                      child: const Icon(Icons.translate_rounded, color: Colors.black, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '9 Languages',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.getTextPrimary(context),
                          ),
                        ),
                        Text(
                          'Select your preferred Jyotish language',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.getTextSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.getTextSecondary(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Ribbon list
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: languages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final lang = languages[index];
                  final isSelected = lang == currentLang;

                  return _buildRibbonTile(
                    context: context,
                    ref: ref,
                    language: lang,
                    isSelected: isSelected,
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRibbonTile({
    required BuildContext context,
    required WidgetRef ref,
    required AppLanguage language,
    required bool isSelected,
    required int index,
  }) {
    // Saffron/Orange gradient shades inspired by AstroSage UI
    final List<Color> ribbonColors = isSelected
        ? [const Color(0xFFFF5722), const Color(0xFFFF8F00)]
        : [const Color(0xFFFF9100), const Color(0xFFFFAB00)];

    return GestureDetector(
      onTap: () async {
        HapticFeedback.lightImpact();
        await ref.read(localeProvider.notifier).setLanguage(language);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Language switched to ${language.nativeName} (${language.englishName})'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: const Color(0xFFFF6D00),
            ),
          );
          Navigator.pop(context);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        height: 52,
        child: ClipPath(
          clipper: _LeftArrowRibbonClipper(),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: ribbonColors,
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6D00).withValues(alpha: isSelected ? 0.45 : 0.20),
                  blurRadius: isSelected ? 12 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 36), // spacing for arrow indent
                Text(
                  language.flagEmoji,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    language.nativeName,
                    style: GoogleFonts.outfit(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                      shadows: const [
                        Shadow(
                          color: Color(0x66000000),
                          blurRadius: 4,
                          offset: Offset(0, 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
                Text(
                  language.englishName,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(width: 12),
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Color(0xFFFF6D00),
                      size: 14,
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white70,
                      size: 14,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom clipper to create the authentic angled ribbon banner shown in AstroSage
class _LeftArrowRibbonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    const double arrowWidth = 20.0;

    // Start top-left arrow tip point
    path.moveTo(arrowWidth, 0);
    path.lineTo(size.width - 6, 0);
    // Top-right slight rounded curve
    path.quadraticBezierTo(size.width, 0, size.width, 6);
    path.lineTo(size.width, size.height - 6);
    // Bottom-right slight rounded curve
    path.quadraticBezierTo(size.width, size.height, size.width - 6, size.height);
    path.lineTo(arrowWidth, size.height);
    // Inward chevron arrow on left
    path.lineTo(0, size.height / 2);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
