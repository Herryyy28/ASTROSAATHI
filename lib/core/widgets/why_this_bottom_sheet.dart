import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class WhyThisBottomSheet extends StatelessWidget {
  final String title;
  final String planetFactor;
  final String houseFactor;
  final String transitFactor;
  final String vedicInterpretation;
  final String practicalAction;

  const WhyThisBottomSheet({
    super.key,
    required this.title,
    required this.planetFactor,
    required this.houseFactor,
    required this.transitFactor,
    required this.vedicInterpretation,
    required this.practicalAction,
  });

  static void show(
    BuildContext context, {
    required String title,
    required String planetFactor,
    required String houseFactor,
    required String transitFactor,
    required String vedicInterpretation,
    required String practicalAction,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => WhyThisBottomSheet(
        title: title,
        planetFactor: planetFactor,
        houseFactor: houseFactor,
        transitFactor: transitFactor,
        vedicInterpretation: vedicInterpretation,
        practicalAction: practicalAction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isLight
                ? AppColors.surfaceLight.withOpacity(0.96)
                : AppColors.surfaceDark.withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: AppColors.getGlassBorder(context), width: 0.8),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.info_outline_rounded, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Why this prediction?',
                              style: GoogleFonts.outfit(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close_rounded, color: AppColors.getTextSecondary(context)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextPrimary(context),
                  ),
                ),
                const SizedBox(height: 16),

                // Astronomical Factors Grid
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isLight
                        ? AppColors.getSurfaceSecondary(context)
                        : AppColors.surfaceHighlightDark.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.getGlassBorder(context)),
                  ),
                  child: Column(
                    children: [
                      _buildFactorRow(context, 'Active Planet', planetFactor, Icons.auto_awesome_rounded),
                      Divider(color: AppColors.getGlassBorder(context), height: 16),
                      _buildFactorRow(context, 'Kundli House', houseFactor, Icons.grid_view_rounded),
                      Divider(color: AppColors.getGlassBorder(context), height: 16),
                      _buildFactorRow(context, 'Current Transit', transitFactor, Icons.swap_horiz_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Vedic Interpretation
                Text(
                  'Vedic Jyotish Basis',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.getTextSecondary(context),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  vedicInterpretation,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.getTextPrimary(context),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),

                // Practical Action
                Text(
                  'Practical Consideration',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isLight ? AppColors.primary : AppColors.primaryLight,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  practicalAction,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.getTextPrimary(context),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                // Responsible Guidance Disclaimer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isLight
                        ? AppColors.getSurfaceElevated(context)
                        : AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.getGlassBorder(context).withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppColors.getTextMuted(context), size: 16),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Astrology provides traditional self-awareness guidance. Predictions are non-deterministic and do not replace professional advice.',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.getTextMuted(context),
                            height: 1.3,
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

  Widget _buildFactorRow(BuildContext context, String label, String value, IconData icon) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.getTextSecondary(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isLight ? AppColors.primary : AppColors.primaryLight,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
