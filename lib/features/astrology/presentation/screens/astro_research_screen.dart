import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';

class AstroResearchScreen extends StatelessWidget {
  const AstroResearchScreen({super.key});

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
                                  'Astrology Research Mode',
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
                                  'PRACTITIONER',
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
                            'Raw coordinates, house cusps & notes',
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

              // Main Body
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    GlassCard(
                      padding: const EdgeInsets.all(18),
                      borderColor: AppColors.primary.withOpacity(0.4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('RAW EPHEMERIS COORDINATES (ARC-SECONDS)', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const SizedBox(height: 10),
                          _buildCoordTile(context, 'Sun ☀️', '194° 22\' 18.42"', 'Declination: -05° 42\' 11"'),
                          _buildCoordTile(context, 'Moon 🌙', '308° 45\' 02.19"', 'Declination: -12° 18\' 45"'),
                          _buildCoordTile(context, 'Ascendant ⬆️', '194° 12\' 34.00"', 'Sidereal Time: 14h 22m 18s'),
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

  Widget _buildCoordTile(BuildContext context, String body, String long, String decl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              body,
              style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(long, style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text(decl, style: GoogleFonts.inter(fontSize: 10, color: AppColors.getTextSecondary(context))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
