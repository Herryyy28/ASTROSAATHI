import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';

class AstroResearchScreen extends StatelessWidget {
  const AstroResearchScreen({super.key});

  @override
  Widget build(BuildContext context) => AstroDetailScaffold(
    title: 'Research mode',
    subtitle:
        'Raw ephemeris coordinates and calculation notes for practitioners.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AstroPageIntro(
          icon: Icons.science_outlined,
          tag: 'PRACTITIONER VIEW',
          title: 'Ephemeris coordinates',
          subtitle:
              'Precise longitude, declination, and sidereal values in one readable surface.',
        ),
        const SizedBox(height: 24),
        const AstroSectionHeader(title: 'Current positions'),
        const SizedBox(height: 12),
        AstroCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Column(
            children: const [
              _CoordinateRow(
                body: 'Sun',
                longitude: '194° 22′ 18.42″',
                detail: 'Declination −05° 42′ 11″',
              ),
              Divider(),
              _CoordinateRow(
                body: 'Moon',
                longitude: '308° 45′ 02.19″',
                detail: 'Declination −12° 18′ 45″',
              ),
              Divider(),
              _CoordinateRow(
                body: 'Ascendant',
                longitude: '194° 12′ 34.00″',
                detail: 'Sidereal time 14h 22m 18s',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _CoordinateRow extends StatelessWidget {
  const _CoordinateRow({
    required this.body,
    required this.longitude,
    required this.detail,
  });
  final String body;
  final String longitude;
  final String detail;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.softLavender,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.public_rounded,
            size: 19,
            color: AppColors.primaryLightMode,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                body,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            longitude,
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLightMode,
            ),
          ),
        ),
      ],
    ),
  );
}
