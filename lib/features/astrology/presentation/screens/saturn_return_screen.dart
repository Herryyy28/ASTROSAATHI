import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';

class SaturnReturnScreen extends StatelessWidget {
  const SaturnReturnScreen({super.key});

  @override
  Widget build(BuildContext context) => AstroDetailScaffold(
    title: 'Saturn return',
    subtitle:
        'Your 29.5-year cycle of structure, maturity, and long-term growth.',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AstroPageIntro(
          icon: Icons.track_changes_rounded,
          tag: 'CYCLE 1 · AGE 27–30',
          title: 'Active integration window',
          subtitle:
              'Saturn is revisiting your natal position in Aquarius and reshaping long-term goals, discipline, and your core foundation.',
        ),
        const SizedBox(height: 24),
        const AstroSectionHeader(title: 'Cycle timeline'),
        const SizedBox(height: 12),
        const AstroCard(
          child: Column(
            children: [
              _TimelinePoint(label: 'Start', value: 'Mar 2025', active: false),
              SizedBox(height: 12),
              _TimelinePoint(label: 'Peak', value: 'Jan 2026', active: true),
              SizedBox(height: 12),
              _TimelinePoint(label: 'End', value: 'Feb 2028', active: false),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const AstroSectionHeader(title: 'What this phase emphasizes'),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _ThemeChip(label: 'Long-term goals'),
            _ThemeChip(label: 'Self-discipline'),
            _ThemeChip(label: 'Creative responsibility'),
            _ThemeChip(label: 'Stable foundations'),
          ],
        ),
      ],
    ),
  );
}

class _TimelinePoint extends StatelessWidget {
  const _TimelinePoint({
    required this.label,
    required this.value,
    required this.active,
  });
  final String label;
  final String value;
  final bool active;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
      color: active
          ? AppColors.highlightSurface
          : AppColors.secondaryBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: active ? AppColors.primaryLightMode : AppColors.borderLight,
      ),
    ),
    child: Row(
      children: [
        Icon(
          active ? Icons.radio_button_checked_rounded : Icons.circle_outlined,
          size: 18,
          color: active
              ? AppColors.primaryLightMode
              : AppColors.textSecondaryLight,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondaryLight,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
      ],
    ),
  );
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
    decoration: BoxDecoration(
      color: AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.borderLight),
    ),
    child: Text(
      label,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryLightMode,
      ),
    ),
  );
}
