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
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/why_this_bottom_sheet.dart';
import '../../../../core/widgets/admob_banner_widget.dart';
import '../../../../core/theme/utils/responsive.dart';
import '../../../../l10n/app_localizations.dart';

class PanchangScreen extends ConsumerWidget {
  const PanchangScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panchangAsync = ref.watch(panchangProvider);

    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
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
              data: (panchang) => _buildPanchangUI(context, ref, panchang),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPanchangUI(BuildContext context, WidgetRef ref, PanchangData panchang) {
    final l10n = AppLocalizations.of(context, ref);
    final isLight = Theme.of(context).brightness == Brightness.light;
    final hPad = context.responsive<double>(mobile: 20, tablet: 32, desktop: 40);
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(hPad, 24, hPad, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header with Navigation Arrows ──────────────────
                Row(
                  children: [
                    if (Navigator.canPop(context))
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 22),
                        onPressed: () => Navigator.pop(context),
                      ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.panchangTitle,
                            style: GoogleFonts.outfit(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.todaysPanchang,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLight
                        ? AppColors.surfaceSecondaryLight
                        : AppColors.surfaceHighlightDark.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.sync, size: 12, color: AppColors.getTextMuted(context)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Calculated for New Delhi • Live',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.getTextMuted(context),
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Date Navigation Card (Backward & Forward Arrows) ──
                Consumer(
                  builder: (context, ref, _) {
                    final selectedDate = ref.watch(selectedPanchangDateProvider);
                    final isToday = selectedDate.year == DateTime.now().year &&
                        selectedDate.month == DateTime.now().month &&
                        selectedDate.day == DateTime.now().day;
                    final formattedDate =
                        '${selectedDate.day} ${_monthName(selectedDate.month)} ${selectedDate.year}';

                    return GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primary, size: 18),
                            tooltip: 'Previous Day',
                            onPressed: () {
                              ref.read(selectedPanchangDateProvider.notifier).state =
                                  selectedDate.subtract(const Duration(days: 1));
                            },
                          ),
                          Column(
                            children: [
                              Text(
                                isToday ? 'Today ($formattedDate)' : formattedDate,
                                style: GoogleFonts.outfit(
                                  color: AppColors.getTextPrimary(context),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              if (!isToday)
                                TextButton(
                                  onPressed: () {
                                    ref.read(selectedPanchangDateProvider.notifier).state = DateTime.now();
                                  },
                                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 20)),
                                  child: Text(
                                    'Reset to Today',
                                    style: GoogleFonts.inter(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.w600),
                                  ),
                                ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primary, size: 18),
                            tooltip: 'Next Day',
                            onPressed: () {
                              ref.read(selectedPanchangDateProvider.notifier).state =
                                  selectedDate.add(const Duration(days: 1));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // ── Sunrise / Sunset ──────────────────────────────
                _buildSunMoonTimings(context, panchang).fadeSlideUp(delay: 100.ms),
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

                _buildElementCard(context, 'Tithi', panchang.tithi, 'Lunar day', '🌙', 0),
                _buildElementCard(context, 'Vara', panchang.vara, 'Day of the week', '📅', 1),
                _buildElementCard(context, 'Nakshatra', panchang.nakshatra, 'Lunar mansion', '⭐', 2),
                _buildElementCard(context, 'Yoga', panchang.yoga, 'Sun-Moon angle', '🔮', 3),
                _buildElementCard(context, 'Karana', panchang.karana, 'Half lunar day', '☯️', 4),

                const SizedBox(height: 16),

                const AdMobBannerWidget(),
                const SizedBox(height: 16),

                // ── Inauspicious Timings ──────────────────────────
                _buildInauspiciousTimings(context, panchang),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSunMoonTimings(BuildContext context, PanchangData panchang) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildTimingItem(
              context,
              '☀️',
              'Sunrise',
              panchang.sunrise,
              AppColors.primary,
            ),
          ),
          Container(
            width: 1,
            height: 50,
            color: AppColors.getGlassBorder(context),
          ),
          Expanded(
            child: _buildTimingItem(
              context,
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

  Widget _buildTimingItem(BuildContext context, String emoji, String label, String time, Color color) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.getTextSecondary(context),
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
            color: AppColors.getTextPrimary(context),
          ),
        ),
      ],
    );
  }

  Widget _buildElementCard(BuildContext context, String name, String value, String description, String emoji, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () {
          WhyThisBottomSheet.show(
            context,
            title: '$name: $value',
            planetFactor: name,
            houseFactor: 'Panchang Element ${index + 1}',
            transitFactor: 'Real-time Moon & Sun degree',
            vedicInterpretation: 'In Vedic Astrology, $name ($value) is a fundamental pillar of $description influencing daily vital energy and Muhurat strength.',
            practicalAction: 'Favorable for aligned spiritual routines and mindful decision-making.',
          );
        },
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
                      style: TextStyle(
                        color: AppColors.getTextSecondary(context),
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
                        color: AppColors.getTextPrimary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.getSurfaceSecondary(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.primary,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    ).fadeSlideUp(delay: Duration(milliseconds: 240 + (index * 80)));
  }

  Widget _buildInauspiciousTimings(BuildContext context, PanchangData panchang) {
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
          decoration: AppDecorations.alertCard(alertColor: AppColors.error, context: context),
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
                        color: AppColors.getTextPrimary(context),
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
                        color: AppColors.getTextSecondary(context),
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

  String _monthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[(month - 1) % 12];
  }
}
