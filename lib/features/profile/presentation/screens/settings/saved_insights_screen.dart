import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/empty_state_widget.dart';

class SavedInsightsScreen extends StatelessWidget {
  const SavedInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Saved Insights',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryDark,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicRadialGradient,
        ),
        child: const EmptyStateWidget(
          icon: Icons.bookmark_outline_rounded,
          title: 'No Insights Saved Yet',
          description:
              'When you bookmark Astro Baba AI insights, planetary remedies, or daily horoscopes, they will appear here for instant reference.',
          emoji: '🔖',
        ),
      ),
    );
  }
}
