import 'dart:ui';
import 'package:flutter/material.dart';
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
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark.withOpacity(0.95),
            border: const Border(top: BorderSide(color: AppColors.glassBorder, width: 0.5)),
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
                              style: const TextStyle(
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
                      icon: const Icon(Icons.close_rounded, color: AppColors.textSecondaryDark),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                ),
                const SizedBox(height: 16),

                // Astronomical Factors Grid
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighlightDark.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    children: [
                      _buildFactorRow('Active Planet', planetFactor, Icons.auto_awesome_rounded),
                      const Divider(color: AppColors.glassBorder, height: 16),
                      _buildFactorRow('Kundli House', houseFactor, Icons.grid_view_rounded),
                      const Divider(color: AppColors.glassBorder, height: 16),
                      _buildFactorRow('Current Transit', transitFactor, Icons.swap_horiz_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Vedic Interpretation
                const Text(
                  'Vedic Jyotish Basis',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textSecondaryDark),
                ),
                const SizedBox(height: 6),
                Text(
                  vedicInterpretation,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimaryDark, height: 1.4),
                ),
                const SizedBox(height: 16),

                // Practical Action
                const Text(
                  'Practical Consideration',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
                ),
                const SizedBox(height: 6),
                Text(
                  practicalAction,
                  style: const TextStyle(fontSize: 13, color: AppColors.textPrimaryDark, height: 1.4),
                ),
                const SizedBox(height: 20),

                // Responsible Guidance Disclaimer
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.glassBorder.withOpacity(0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, color: AppColors.textTertiaryDark, size: 16),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Astrology provides traditional self-awareness guidance. Predictions are non-deterministic and do not replace professional advice.',
                          style: TextStyle(fontSize: 11, color: AppColors.textTertiaryDark, height: 1.3),
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

  Widget _buildFactorRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 16),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryLight),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
