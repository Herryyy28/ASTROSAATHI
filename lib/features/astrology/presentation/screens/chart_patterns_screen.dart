import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class ChartPatternsScreen extends StatelessWidget {
  const ChartPatternsScreen({super.key});

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
                                  'Aspect Patterns & Dominance',
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
                                  'ANALYSIS',
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
                            'Aspect patterns & element balance',
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

              // Main Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Section 1: Detected Aspect Patterns
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      borderColor: Colors.greenAccent.withOpacity(0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('DETECTED PATTERN: GRAND AIR TRINE', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.greenAccent)),
                          const SizedBox(height: 8),
                          Text('Sun (Libra) ↔ Moon (Aquarius) ↔ Mars (Gemini)', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context))),
                          const SizedBox(height: 4),
                          Text('Harmonious 120° tri-angle bringing effortless intellectual communication, strategic diplomacy, and social influence.', style: GoogleFonts.inter(fontSize: 11.5, color: AppColors.getTextSecondary(context), height: 1.35)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Section 2: Element Balance Breakdown
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ELEMENT BALANCE BREAKDOWN', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const SizedBox(height: 12),
                          _buildElementRow(context, 'Air Element (Intellect)', 0.40, Colors.cyanAccent),
                          const SizedBox(height: 8),
                          _buildElementRow(context, 'Fire Element (Action)', 0.30, Colors.orangeAccent),
                          const SizedBox(height: 8),
                          _buildElementRow(context, 'Earth Element (Structure)', 0.20, Colors.amberAccent),
                          const SizedBox(height: 8),
                          _buildElementRow(context, 'Water Element (Emotion)', 0.10, Colors.blueAccent),
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

  Widget _buildElementRow(BuildContext context, String label, double val, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.getTextSecondary(context))),
            ),
            const SizedBox(width: 8),
            Text('${(val * 100).toInt()}%', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: val,
            minHeight: 4,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
