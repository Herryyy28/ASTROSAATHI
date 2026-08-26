import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/zodiac_icon.dart';
import '../../../../core/widgets/shimmer_loader.dart';

final selectedSignProvider = StateProvider<String>((ref) => 'Aries');

final horoscopeProvider = FutureProvider.family<dynamic, String>((ref, timeframe) async {
  final engine = ref.watch(astrologyEngineProvider);
  final sign = ref.watch(selectedSignProvider);
  return await engine.getHoroscope(sign, timeframe);
});

class HoroscopeScreen extends ConsumerWidget {
  const HoroscopeScreen({super.key});

  static const List<String> signs = [
    'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
    'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.cosmicRadialGradient),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ── Header ────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                  child: Row(
                    children: [
                      Text(
                        'Horoscope',
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      const Spacer(),
                      _buildSignDropdown(ref),
                    ],
                  ),
                ).fadeSlideUp(),

                const SizedBox(height: 16),

                // ── Zodiac Carousel ───────────────────────────────
                _buildZodiacCarousel(ref).fadeSlideUp(delay: 100.ms),

                const SizedBox(height: 20),

                // ── Tabs ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlassCard(
                    padding: EdgeInsets.zero,
                    borderRadius: 14,
                    child: const TabBar(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      tabs: [
                        Tab(text: 'Daily'),
                        Tab(text: 'Weekly'),
                        Tab(text: 'Monthly'),
                      ],
                    ),
                  ),
                ).fadeSlideUp(delay: 200.ms),

                const SizedBox(height: 8),

                // ── Tab Content ───────────────────────────────────
                const Expanded(
                  child: TabBarView(
                    children: [
                      _HoroscopeTabView(timeframe: 'daily'),
                      _HoroscopeTabView(timeframe: 'weekly'),
                      _HoroscopeTabView(timeframe: 'monthly'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZodiacCarousel(WidgetRef ref) {
    final currentSign = ref.watch(selectedSignProvider);

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: signs.length,
        itemBuilder: (context, index) {
          final sign = signs[index];
          final isSelected = sign == currentSign;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () {
                ref.read(selectedSignProvider.notifier).state = sign;
              },
              child: Column(
                children: [
                  ZodiacIcon(
                    sign: sign,
                    size: 36,
                    isSelected: isSelected,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    sign.substring(0, 3),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppColors.primary : AppColors.textTertiaryDark,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignDropdown(WidgetRef ref) {
    final currentSign = ref.watch(selectedSignProvider);
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: 12,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppColors.zodiacEmojis[currentSign] ?? '⭐',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 6),
          Text(
            currentSign,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _HoroscopeTabView extends ConsumerWidget {
  final String timeframe;
  const _HoroscopeTabView({required this.timeframe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final horoscopeAsync = ref.watch(horoscopeProvider(timeframe));
    final sign = ref.watch(selectedSignProvider);

    return horoscopeAsync.when(
      data: (data) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Sign Header ─────────────────────────────────────
              Row(
                children: [
                  Text(
                    AppColors.zodiacEmojis[sign] ?? '⭐',
                    style: const TextStyle(fontSize: 36),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sign,
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      Text(
                        timeframe.toUpperCase(),
                        style: TextStyle(
                          color: AppColors.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ).fadeSlideUp(),
              const SizedBox(height: 24),

              // ── Reading Card ────────────────────────────────────
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Text(
                  data.reading,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    height: 1.7,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
              ).fadeSlideUp(delay: 100.ms),

              const SizedBox(height: 20),

              // ── Lucky Info Cards ────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      'Lucky Number',
                      data.luckyNumber.toString(),
                      Icons.tag_rounded,
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildInfoCard(
                      'Lucky Color',
                      data.luckyColor,
                      Icons.palette_rounded,
                      AppColors.secondary,
                    ),
                  ),
                ],
              ).fadeSlideUp(delay: 200.ms),
            ],
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(24),
        child: ShimmerLoader(itemCount: 3),
      ),
      error: (e, st) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.error, size: 40),
            const SizedBox(height: 12),
            Text('Failed to load', style: TextStyle(color: AppColors.error)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon, Color accentColor) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(0.12),
                ),
                child: Icon(icon, color: accentColor, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: AppColors.textPrimaryDark,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
