import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class SaturnReturnScreen extends StatelessWidget {
  const SaturnReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceElevated(context),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: AppColors.getTextPrimary(context), size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Saturn Return Center',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'CYCLE 1',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '29.5-year karmic maturity cycle',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main Body Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    GlassCard(
                      padding: const EdgeInsets.all(18),
                      borderColor: Colors.purpleAccent.withOpacity(0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('1ST SATURN RETURN (AGE 27–30)', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purpleAccent)),
                          const SizedBox(height: 12),
                          Text('Phase Status: Active Integration Window', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                          const SizedBox(height: 6),
                          Text(
                            'Saturn transits natal Saturn position in Aquarius (5th House). This 2.5-year cycle restructures long-term goals, self-discipline, and core life foundation.',
                            style: GoogleFonts.inter(fontSize: 12, color: AppColors.getTextSecondary(context), height: 1.4),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: Text('Start: Mar 2025', style: GoogleFonts.outfit(fontSize: 11, color: AppColors.getTextSecondary(context))),
                              ),
                              Expanded(
                                child: Text('Peak: Jan 2026', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.purpleAccent), textAlign: TextAlign.center),
                              ),
                              Expanded(
                                child: Text('End: Feb 2028', style: GoogleFonts.outfit(fontSize: 11, color: AppColors.getTextSecondary(context)), textAlign: TextAlign.end),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
