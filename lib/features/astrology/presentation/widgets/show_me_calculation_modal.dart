import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class ShowMeCalculationModal extends StatelessWidget {
  final String title;
  final Map<String, String> mathDetails;

  const ShowMeCalculationModal({
    super.key,
    required this.title,
    required this.mathDetails,
  });

  static void show(BuildContext context, {String title = 'Score Calculation Engine', Map<String, String>? mathDetails}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => ShowMeCalculationModal(
        title: title,
        mathDetails: mathDetails ?? {
          'Ayanamsa System': 'Lahiri True Chitra (24° 12\' 34")',
          'Sidereal Ascendant': 'Libra 14° 22\' 18" (Swati Nakshatra P2)',
          'Moon Longitude': 'Aquarius 08° 45\' (Shatabhisha Nakshatra P1)',
          'Active Mahadasha': 'Jupiter (Rahu Antardasha)',
          'Transit Ashtakavarga Points': '32 Points in 10th House (Strong)',
          'Panchang Tithi Suitability': 'Shukla Navami (+1.2 pts)',
          'Rahu Kaal Deduction': '0.0 pts (Not Active)',
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      decoration: BoxDecoration(
        color: isLight
            ? AppColors.surfaceLight.withOpacity(0.96)
            : const Color(0xFF161922),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.getGlassBorder(context), width: 0.8),
      ),
      padding: const EdgeInsets.all(20),
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
                        color: AppColors.primary.withOpacity(0.18),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.calculate_rounded, color: AppColors.primary, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.getTextPrimary(context),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.close_rounded, color: AppColors.getTextSecondary(context), size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),

          Text(
            'EXACT MATHEMATICAL ENGINE INPUTS',
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 10),

          ...mathDetails.entries.map((e) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isLight
                    ? AppColors.getSurfaceSecondary(context)
                    : Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.getGlassBorder(context)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      e.key,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: AppColors.getTextSecondary(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3,
                    child: Text(
                      e.value,
                      textAlign: TextAlign.end,
                      style: GoogleFonts.outfit(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: isLight ? AppColors.getPrimary(context) : AppColors.primary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
