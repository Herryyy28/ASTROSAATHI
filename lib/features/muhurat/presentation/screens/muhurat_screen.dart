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
import '../../../../core/engine/models/muhurat_data.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/theme/utils/responsive.dart';

final selectedCategoryProvider = StateProvider<String>((ref) => 'Business');

class MuhuratScreen extends ConsumerWidget {
  const MuhuratScreen({super.key});

  final List<String> categories = const [
    'Business', 'Meeting', 'Travel', 'Investment', 'Contract', 'Marriage', 'Property',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final muhuratAsync = ref.watch(muhuratProvider(selectedCategory));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.cosmicRadialGradient),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.responsive<double>(mobile: 20, tablet: 32, desktop: 40),
                24,
                context.responsive<double>(mobile: 20, tablet: 32, desktop: 40),
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header with Back Arrow ────────────────────────
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
                              'Muhurat',
                              style: GoogleFonts.outfit(
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'What are you planning?',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondaryDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ).fadeSlideUp(),

                  const SizedBox(height: 24),

                  // ── Category Selector ─────────────────────────────
                  _buildCategorySelector(ref, selectedCategory).fadeSlideUp(delay: 100.ms),

                  const SizedBox(height: 32),

                  // ── Result ────────────────────────────────────────
                  Expanded(
                    child: muhuratAsync.when(
                      loading: () => const ShimmerLoader(itemCount: 3, itemHeight: 90),
                      error: (error, stack) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                            const SizedBox(height: 12),
                            Text('Error finding Muhurat', style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                      data: (result) => _buildMuhuratResult(result),
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

  Widget _buildCategorySelector(WidgetRef ref, String selected) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((category) {
          final isSelected = category == selected;
          final icon = AppColors.muhuratIcons[category] ?? Icons.circle;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => ref.read(selectedCategoryProvider.notifier).state = category,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.goldGradient : null,
                  color: isSelected ? null : AppColors.glassSurface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : AppColors.glassBorder,
                    width: 0.5,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(color: AppColors.goldGlow, blurRadius: 12, spreadRadius: -4),
                  ] : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color: isSelected ? Colors.black : AppColors.textSecondaryDark,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected ? Colors.black : AppColors.textPrimaryDark,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMuhuratResult(MuhuratResult result) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 100),
      children: [
        // ── Best Time Display ─────────────────────────────────
        GlassCard(
          padding: const EdgeInsets.all(28),
          glowColor: AppColors.goldGlow,
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.12),
                ),
                child: const Icon(Icons.access_time_filled_rounded, color: AppColors.primary, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                'Best Time',
                style: TextStyle(
                  color: AppColors.textSecondaryDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${result.bestWindow.start} — ${result.bestWindow.end}',
                  style: GoogleFonts.outfit(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ).fadeSlideUp(delay: 200.ms),

        const SizedBox(height: 20),

        // ── Detail Cards ──────────────────────────────────────
        _buildDetailCard(
          'Strength',
          result.strength,
          Icons.bolt_rounded,
          AppColors.success,
        ).fadeSlideUp(delay: 300.ms),

        const SizedBox(height: 12),

        _buildDetailCard(
          'Best For',
          result.bestFor,
          Icons.check_circle_rounded,
          AppColors.primary,
        ).fadeSlideUp(delay: 380.ms),

        // ── Avoid Section ─────────────────────────────────────
        if (result.avoidWindow != null) ...[
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: AppDecorations.alertCard(alertColor: AppColors.error),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error.withOpacity(0.12),
                  ),
                  child: const Icon(Icons.block_rounded, color: AppColors.error, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Avoid',
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${result.avoidWindow!.start} — ${result.avoidWindow!.end}',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).fadeSlideUp(delay: 460.ms),
        ],
      ],
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  value,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimaryDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
