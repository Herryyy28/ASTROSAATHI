import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class FutureRadarScreen extends StatelessWidget {
  const FutureRadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = AppColors.isLight(context);
    final primaryTextColor = AppColors.getTextPrimary(context);

    final events = [
      {
        'day': 'Day +4',
        'title': 'Jupiter Trine Natal Sun',
        'category': 'Transit',
        'rating': 'Favorable',
        'desc': 'High confidence & expansion window for contract negotiations and executive leadership decisions.',
        'color': isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF),
      },
      {
        'day': 'Day +14',
        'title': 'Mercury Antardasha Shift',
        'category': 'Dasha',
        'rating': 'High Impact',
        'desc': 'New 4-month sub-period activating intellect, trading, and strategic media opportunities.',
        'color': isLight ? const Color(0xFFB87308) : const Color(0xFFFFD700),
      },
      {
        'day': 'Day +28',
        'title': 'Solar Eclipse in 10th House',
        'category': 'Eclipse',
        'rating': 'Caution',
        'desc': 'Avoid impulsive career announcements; focus on strategic observation.',
        'color': isLight ? const Color(0xFFC62828) : const Color(0xFFFF1744),
      },
      {
        'day': 'Day +45',
        'title': 'Venus Trine Natal Moon',
        'category': 'Relationship',
        'rating': 'Favorable',
        'desc': 'Peak emotional alignment & relationship harmony window.',
        'color': isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF),
      },
      {
        'day': 'Day +65',
        'title': 'Mars Transit 10th House',
        'category': 'Career',
        'rating': 'High Impact',
        'desc': 'High drive & execution speed. Channel energy productively to avoid friction.',
        'color': isLight ? const Color(0xFFB87308) : const Color(0xFFFFD700),
      },
      {
        'day': 'Day +82',
        'title': 'Saturn Direct Gochar',
        'category': 'Transit',
        'rating': 'Favorable',
        'desc': 'Structural clarity returns; long-term delayed plans gain steady momentum.',
        'color': isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getSurface(context),
        elevation: 0,
        title: Text(
          '90-Day Future Radar',
          style: GoogleFonts.outfit(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radar Hero Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.getSurfaceElevated(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.getBorder(context)),
              ),
              child: Row(
                children: [
                  Icon(Icons.radar_rounded, color: isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF), size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next 90 Days Timeline',
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        Text(
                          '6 Key Planetary Events Detected • 4 Favorable, 1 Caution',
                          style: GoogleFonts.outfit(
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
            const SizedBox(height: 20),

            // Timeline Items
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final item = events[index];
                final Color itemCol = item['color'] as Color;

                return IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Timeline Indicator Column
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: itemCol.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item['day'] as String,
                              style: GoogleFonts.outfit(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: itemCol,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 2,
                              color: AppColors.getBorder(context),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),

                      // Event Card
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.getSurface(context),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: itemCol.withOpacity(0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item['title'] as String,
                                      style: GoogleFonts.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: itemCol,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: itemCol.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item['rating'] as String,
                                      style: GoogleFonts.outfit(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        color: itemCol,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['desc'] as String,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: AppColors.getTextSecondary(context),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
