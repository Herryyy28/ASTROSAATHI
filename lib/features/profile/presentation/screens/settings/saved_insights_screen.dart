import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/empty_state_widget.dart';

class SavedInsightsScreen extends StatelessWidget {
  const SavedInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : Colors.transparent,
        elevation: 0,
        title: Text(
          'Saved Insights',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: AppColors.getTextPrimary(context),
          ),
        ),
        iconTheme: IconThemeData(color: AppColors.getTextPrimary(context)),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
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
