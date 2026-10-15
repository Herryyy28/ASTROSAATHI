import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';

class FutureRadarScreen extends StatelessWidget {
  const FutureRadarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final format = DateFormat('MMM d');
    final events = <_RadarEvent>[
      _RadarEvent(
        day: '${format.format(now.add(const Duration(days: 4)))} · +4d',
        title: 'Jupiter trine natal Sun',
        rating: 'Favorable',
        description:
            'A confidence and expansion window for negotiations and leadership decisions.',
        color: AppColors.secondary,
      ),
      _RadarEvent(
        day: '${format.format(now.add(const Duration(days: 14)))} · +14d',
        title: 'Mercury antardasha shift',
        rating: 'High impact',
        description:
            'A new sub-period activates intellect, trading, and strategic communication.',
        color: AppColors.actionPurple,
      ),
      _RadarEvent(
        day: '${format.format(now.add(const Duration(days: 28)))} · +28d',
        title: 'Solar eclipse in 10th house',
        rating: 'Careful',
        description:
            'Observe career developments before making an impulsive announcement.',
        color: AppColors.pink,
      ),
      _RadarEvent(
        day: '${format.format(now.add(const Duration(days: 45)))} · +45d',
        title: 'Venus trine natal Moon',
        rating: 'Favorable',
        description:
            'Emotional alignment and relationship harmony come into focus.',
        color: AppColors.secondary,
      ),
      _RadarEvent(
        day: '${format.format(now.add(const Duration(days: 65)))} · +65d',
        title: 'Mars transit 10th house',
        rating: 'High impact',
        description:
            'Channel increased drive carefully to avoid unnecessary friction.',
        color: AppColors.actionPurple,
      ),
      _RadarEvent(
        day: '${format.format(now.add(const Duration(days: 82)))} · +82d',
        title: 'Saturn direct gochar',
        rating: 'Favorable',
        description: 'Long-delayed plans regain clarity and steady momentum.',
        color: AppColors.secondary,
      ),
    ];

    return AstroDetailScaffold(
      title: '90-day future radar',
      subtitle: 'A timeline of the strongest upcoming planetary windows.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AstroPageIntro(
            icon: Icons.radar_rounded,
            tag: 'NEXT 90 DAYS',
            title: '6 key events detected',
            subtitle:
                'Four favorable windows, one higher-impact shift, and one period to approach carefully.',
          ),
          const SizedBox(height: 24),
          const AstroSectionHeader(title: 'Your timeline'),
          const SizedBox(height: 12),
          ...events.map((event) => _RadarEventCard(event: event)),
        ],
      ),
    );
  }
}

class _RadarEvent {
  const _RadarEvent({
    required this.day,
    required this.title,
    required this.rating,
    required this.description,
    required this.color,
  });
  final String day;
  final String title;
  final String rating;
  final String description;
  final Color color;
}

class _RadarEventCard extends StatelessWidget {
  const _RadarEventCard({required this.event});
  final _RadarEvent event;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: AstroCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _Pill(label: event.day, color: AppColors.primaryLightMode),
              _Pill(label: event.rating, color: event.color),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.title,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            event.description,
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.45,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ],
      ),
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    ),
  );
}
