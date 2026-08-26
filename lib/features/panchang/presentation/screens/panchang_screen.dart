import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/engine/models/panchang_data.dart';

class PanchangScreen extends ConsumerWidget {
  const PanchangScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panchangAsync = ref.watch(panchangProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.cosmicRadialGradient),
        child: SafeArea(
          bottom: false,
          child: panchangAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(24),
              child: ShimmerLoader(itemCount: 5, itemHeight: 70),
            ),
            error: (error, stack) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                  const SizedBox(height: 16),
                  Text('Error loading Panchang', style: TextStyle(color: AppColors.error)),
                ],
              ),
            ),
            data: (panchang) => _buildPanchangUI(context, panchang),
          ),
        ),
      ),
    );
  }

  Widget _buildPanchangUI(BuildContext context, PanchangData panchang) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Panchang',
                      style: GoogleFonts.outfit(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'The astrological map for today',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHighlightDark.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.sync, size: 12, color: AppColors.textTertiaryDark),
                          const SizedBox(width: 4),
                          Text(
                            'Calculated for New Delhi • Live', // In production, this binds to actual location state
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textTertiaryDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).fadeSlideUp(),

                const SizedBox(height: 28),

                // ── Sunrise / Sunset ──────────────────────────────
                _buildSunMoonTimings(panchang).fadeSlideUp(delay: 100.ms),
                const SizedBox(height: 28),

                // ── Five Elements Section ─────────────────────────
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'FIVE ELEMENTS',
                      style: AppDecorations.sectionHeader(color: AppColors.secondary),
                    ),
                  ],
                ).fadeSlideUp(delay: 180.ms),
                const SizedBox(height: 16),

                _buildElementCard('Tithi', panchang.tithi, 'Lunar day', '🌙', 0),
                _buildElementCard('Vara', panchang.vara, 'Day of the week', '📅', 1),
                _buildElementCard('Nakshatra', panchang.nakshatra, 'Lunar mansion', '⭐', 2),
                _buildElementCard('Yoga', panchang.yoga, 'Sun-Moon angle', '🔮', 3),
                _buildElementCard('Karana', panchang.karana, 'Half lunar day', '☯️', 4),

                const SizedBox(height: 28),

                // ── Inauspicious Timings ──────────────────────────
                _buildInauspiciousTimings(panchang),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSunMoonTimings(PanchangData panchang) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildTimingItem(
              '☀️',
              'Sunrise',
              panchang.sunrise,
              AppColors.primary,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.glassBorder,
          ),
          Expanded(
            child: _buildTimingItem(
              '🌅',
              'Sunset',
              panchang.sunset,
              AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimingItem(String emoji, String label, String time, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondaryDark,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryDark,
          ),
        ),
      ],
    );
  }

  Widget _buildElementCard(String name, String value, String description, String emoji, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.glassSurface,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                description,
                style: const TextStyle(
                  color: AppColors.textTertiaryDark,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ).fadeSlideUp(delay: Duration(milliseconds: 240 + (index * 80))),
    );
  }

  Widget _buildInauspiciousTimings(PanchangData panchang) {
    if (panchang.rahuKaal == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'TIMINGS TO AVOID',
              style: AppDecorations.sectionHeader(color: AppColors.error),
            ),
          ],
        ).fadeSlideUp(delay: 640.ms),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: AppDecorations.alertCard(alertColor: AppColors.error),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.error.withOpacity(0.12),
                ),
                child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rahu Kaal',
                      style: GoogleFonts.outfit(
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${panchang.rahuKaal!.start} — ${panchang.rahuKaal!.end}',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.error,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Unfavorable for starting important activities',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondaryDark,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).fadeSlideUp(delay: 720.ms),
      ],
    );
  }
}
