import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/zodiac_icon.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/utils/responsive.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../../../core/utils/zodiac_sign_utils.dart';

final selectedSignProvider = StateProvider<String>((ref) {
  final profile = ref.read(activeProfileProvider);
  if (profile.name.isNotEmpty) {
    final zodiac = ZodiacSignUtils.getZodiacFromName(profile.name);
    if (zodiac != null) {
      return zodiac.englishName;
    }
  }
  return 'Aries';
});

final horoscopeProvider = FutureProvider.family<dynamic, String>((
  ref,
  timeframe,
) async {
  final engine = ref.watch(astrologyEngineProvider);
  final sign = ref.watch(selectedSignProvider);
  return await engine.getHoroscope(sign, timeframe);
});

class HoroscopeScreen extends ConsumerWidget {
  const HoroscopeScreen({super.key});

  static const List<String> signs = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
        body: Container(
          decoration: BoxDecoration(
            color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
            gradient: isLight ? null : AppColors.cosmicRadialGradient,
          ),
          child: SafeArea(
            bottom: false,
            child: ResponsiveLayout(
              child: Column(
                children: [
                  // ── Header ────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.responsive<double>(
                        mobile: 20,
                        tablet: 32,
                        desktop: 40,
                      ),
                      20,
                      context.responsive<double>(
                        mobile: 20,
                        tablet: 32,
                        desktop: 40,
                      ),
                      0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Horoscope',
                            style: GoogleFonts.outfit(
                              fontSize: context.responsive<double>(
                                mobile: 22,
                                tablet: 28,
                                desktop: 32,
                              ),
                              fontWeight: FontWeight.w700,
                              color: AppColors.getTextPrimary(context),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildSignDropdown(context, ref),
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
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        indicatorColor: AppColors.primary,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.getTextSecondary(context),
                        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                        labelStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
                        unselectedLabelStyle: GoogleFonts.outfit(fontWeight: FontWeight.w500, fontSize: 14),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        tabs: const [
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
                  ZodiacIcon(sign: sign, size: 36, isSelected: isSelected),
                  const SizedBox(height: 4),
                  Text(
                    sign.substring(0, 3),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.getTextMuted(context),
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

  Widget _buildSignDropdown(BuildContext context, WidgetRef ref) {
    final currentSign = ref.watch(selectedSignProvider);
    return PopupMenuButton<String>(
      onSelected: (sign) {
        ref.read(selectedSignProvider.notifier).state = sign;
      },
      color: AppColors.getSurface(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      itemBuilder: (context) => signs.map((sign) {
        return PopupMenuItem<String>(
          value: sign,
          child: Row(
            children: [
              Text(
                AppColors.zodiacEmojis[sign] ?? '⭐',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(width: 10),
              Text(
                sign,
                style: TextStyle(
                  color: sign == currentSign
                      ? AppColors.primary
                      : AppColors.getTextPrimary(context),
                  fontWeight: sign == currentSign
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: GlassCard(
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
            Flexible(
              child: Text(
                currentSign,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primary,
              size: 18,
            ),
          ],
        ),
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
        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.getSurface(context),
          onRefresh: () async {
            ref.refresh(horoscopeProvider(timeframe));
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
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
                            color: AppColors.getTextPrimary(context),
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
                      color: AppColors.getTextPrimary(context),
                    ),
                  ),
                ).fadeSlideUp(delay: 100.ms),

                const SizedBox(height: 20),

                // ── Lucky Info Cards ────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoCard(
                        context,
                        'Lucky Number',
                        data.luckyNumber.toString(),
                        Icons.tag_rounded,
                        AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildInfoCard(
                        context,
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

  Widget _buildInfoCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color accentColor,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(0.12),
                ),
                child: Icon(icon, color: accentColor, size: 14),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: AppColors.getTextSecondary(context),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: AppColors.getTextPrimary(context),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
