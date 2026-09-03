import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class AstrocartographyScreen extends StatelessWidget {
  const AstrocartographyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLight = AppColors.isLight(context);
    final primaryTextColor = AppColors.getTextPrimary(context);

    final cities = [
      {
        'city': 'Dubai, UAE',
        'line': 'Jupiter Midheaven (MC) Line',
        'vibe': 'Highly Favorable',
        'career': 'Rapid executive career promotion & business wealth creation.',
        'relationship': 'Expansive global network.',
        'color': const Color(0xFF00796B),
      },
      {
        'city': 'London, UK',
        'line': 'Mercury Ascendant Line',
        'vibe': 'Highly Favorable',
        'career': 'High intellectual output, publication & media success.',
        'relationship': 'Intellectually stimulating connections.',
        'color': const Color(0xFF00796B),
      },
      {
        'city': 'Toronto, Canada',
        'line': 'Venus Descendant (DC) Line',
        'vibe': 'Harmonic & Peaceful',
        'career': 'Creative partnerships & diplomacy.',
        'relationship': 'Harmonic romantic prospects & family peace.',
        'color': isLight ? const Color(0xFFB87308) : const Color(0xFFFFD700),
      },
      {
        'city': 'Tokyo, Japan',
        'line': 'Mars Imum Coeli (IC) Line',
        'vibe': 'Growth & Challenge',
        'career': 'Technical mastery & high drive.',
        'relationship': 'Dynamic & active domestic environment.',
        'color': isLight ? const Color(0xFFC62828) : const Color(0xFFFF1744),
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.getBackground(context),
      appBar: AppBar(
        backgroundColor: AppColors.getSurface(context),
        elevation: 0,
        title: Text(
          'Astrocartography & Relocation Analysis',
          style: GoogleFonts.outfit(
            color: primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // World Map Radar Placeholder Box
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.getSurfaceElevated(context),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.getBorder(context)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Icon(
                    Icons.public_rounded,
                    size: 110,
                    color: (isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF)).withOpacity(0.15),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map_rounded, color: isLight ? const Color(0xFF00796B) : const Color(0xFF00E5FF), size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'Global Planetary Power Lines Map',
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: primaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Primary Zenith Line: Jupiter MC Line (Career Pinnacle)',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          color: AppColors.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // City Relocation Analysis Cards Header
            Text(
              '✦ City Relocation Comparison Indicators',
              style: GoogleFonts.outfit(
                color: primaryTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            // City Cards
            ...cities.map((c) {
              final Color col = c['color'] as Color;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.getSurface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: col.withOpacity(0.35)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          c['city'] as String,
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: primaryTextColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: col.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            c['vibe'] as String,
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: col,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Dominant Line: ${c['line']}',
                      style: GoogleFonts.outfit(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: col,
                      ),
                    ),
                    Divider(color: AppColors.getDivider(context), height: 18),
                    _buildRow('💼 Career Impact:', c['career'] as String, context),
                    const SizedBox(height: 4),
                    _buildRow('💞 Relationships:', c['relationship'] as String, context),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String val, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.getTextMuted(context),
            ),
          ),
        ),
        Expanded(
          child: Text(
            val,
            style: GoogleFonts.outfit(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.getTextPrimary(context),
            ),
          ),
        ),
      ],
    );
  }
}
