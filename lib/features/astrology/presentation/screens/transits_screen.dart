import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/providers/astrology_provider.dart';

final currentTransitsProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  final now = DateTime.now();
  final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  
  // Using Delhi location for general transits if no location provided
  return await engine.getBirthChart(dateStr, timeStr, 'Delhi, India');
});

class TransitsScreen extends ConsumerWidget {
  const TransitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transitsAsync = ref.watch(currentTransitsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
            child: transitsAsync.when(
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: ShimmerLoader(itemCount: 6, itemHeight: 90),
                ),
              ),
              error: (error, stack) => ErrorStateWidget(
                message: error.toString().replaceFirst('Exception: ', ''),
                onRetry: () => ref.invalidate(currentTransitsProvider),
              ),
              data: (data) {
                final planets = (data['planets'] as List<dynamic>?) ?? [];
                
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    _buildHeader(context),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final planet = planets[index] as Map<String, dynamic>;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildPlanetTransitCard(planet, index),
                            );
                          },
                          childCount: planets.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final todayStr = '${now.day} ${months[now.month - 1]}, ${now.year}';

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 24, 24),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFF27AE60), Color(0xFF145A32)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF27AE60).withOpacity(0.3),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🪐', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Planetary Transits',
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  Text(
                    'Current positions for $todayStr',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1),
    );
  }

  Widget _buildPlanetTransitCard(Map<String, dynamic> planet, int index) {
    final name = planet['name'] as String? ?? 'Unknown';
    final sign = planet['sign'] as String? ?? 'Unknown';
    final house = planet['house']?.toString() ?? '1';
    final nakshatra = planet['nakshatra'] as String? ?? '';
    final isRetrograde = planet['isRetrograde'] as bool? ?? false;
    final degree = planet['degree'] as double? ?? 0.0;

    // Use specific colors for planets based on a predefined mapping or fallback to primary
    final colorMap = {
      'Sun': const Color(0xFFFF9500),
      'Moon': const Color(0xFFE0E0E0),
      'Mars': const Color(0xFFFF3B30),
      'Mercury': const Color(0xFF34C759),
      'Jupiter': const Color(0xFFFFD60A),
      'Venus': const Color(0xFFFF69B4),
      'Saturn': const Color(0xFF0A84FF),
      'Rahu': const Color(0xFF5E5CE6),
      'Ketu': const Color(0xFF8E8E93),
    };
    final pColor = colorMap[name] ?? AppColors.primary;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 16,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pColor.withOpacity(0.15),
              border: Border.all(color: pColor.withOpacity(0.5)),
            ),
            child: Center(
              child: Text(
                name.substring(0, 1),
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: pColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    if (isRetrograde) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Retro',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Transiting $sign • House $house',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
                if (nakshatra.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Nakshatra: $nakshatra (${degree.toStringAsFixed(1)}°)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textTertiaryDark,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: 100 + (index * 50))).slideX(begin: 0.05);
  }
}
