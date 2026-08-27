import 'package:astrosaathi/features/astrology/presentation/widgets/birth_chart_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_decorations.dart';
import '../../../../core/theme/app_animations.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../../../../core/widgets/shimmer_loader.dart';
import '../../../../core/widgets/error_state_widget.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/engine/models/game_plan_data.dart';
import 'main_screen.dart';

/// Provider that loads the user's name from SharedPreferences.
final userNameProvider = FutureProvider<String>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_name') ?? '';
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gamePlanAsync = ref.watch(dailyGamePlanProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          bottom: false,
          child: ResponsiveLayout(
            child: gamePlanAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(24),
                child: ShimmerLoader(itemCount: 5, itemHeight: 100),
              ),
              error: (error, stack) => ErrorStateWidget(
                onRetry: () => ref.invalidate(dailyGamePlanProvider),
              ),
              data: (plan) => _buildGamePlanUI(context, plan),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGamePlanUI(BuildContext context, GamePlanData plan) {
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
                // ── Greeting ──────────────────────────────────────
                _buildGreeting().fadeSlideUp(),
                const SizedBox(height: 24),

                // ── Visual Birth Chart ─────────────────────────────
                const BirthChartCard(),
                const SizedBox(height: 32),

                // ── Energy Score Card ─────────────────────────────
                _buildEnergyCard(plan).fadeSlideUp(delay: 100.ms),
                const SizedBox(height: 28),

                // ── Do / Careful / Avoid ──────────────────────────
                _buildActionSection(
                  'DO',
                  plan.doList,
                  AppColors.success,
                  Icons.check_circle_rounded,
                  200,
                ),
                const SizedBox(height: 16),
                _buildActionSection(
                  'BE CAREFUL',
                  plan.beCarefulList,
                  AppColors.warning,
                  Icons.warning_rounded,
                  280,
                ),
                const SizedBox(height: 16),
                _buildActionSection(
                  'AVOID',
                  plan.avoidList,
                  AppColors.error,
                  Icons.cancel_rounded,
                  360,
                ),
                const SizedBox(height: 28),

                // ── Best Window ───────────────────────────────────
                _buildBestWindow(plan).fadeSlideUp(delay: 440.ms),
                const SizedBox(height: 28),

                // ── Categories ────────────────────────────────────
                _buildCategories(plan).fadeSlideUp(delay: 520.ms),
                const SizedBox(height: 28),

                // ── Ask Astro Baba ────────────────────────────────
                _buildAstroBabaPrompt().fadeSlideUp(delay: 600.ms),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGreeting() {
    final hour = DateTime.now().hour;
    String greeting;
    String emoji;
    if (hour < 12) {
      greeting = 'Good morning';
      emoji = '☀️';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
      emoji = '🌤️';
    } else {
      greeting = 'Good evening';
      emoji = '🌙';
    }

    return Consumer(
      builder: (context, ref, _) {
        final nameAsync = ref.watch(userNameProvider);
        final userName = nameAsync.whenOrNull(data: (name) => name) ?? '';
        final displayGreeting = userName.isNotEmpty
            ? '$greeting, $userName'
            : greeting;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    displayGreeting,
                    style: GoogleFonts.outfit(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark,
                      letterSpacing: -0.3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _formatDate(),
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.textSecondaryDark,
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDate() {
    final now = DateTime.now();
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${days[now.weekday - 1]} · ${now.day} ${months[now.month - 1]}';
  }

  Widget _buildEnergyCard(GamePlanData plan) {
    return GlassCard(
      padding: const EdgeInsets.all(28),
      glowColor: AppColors.goldGlow,
      gradient: AppColors.premiumGradient,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text('TODAY\'S ENERGY', style: AppDecorations.sectionHeader()),
            ],
          ),
          const SizedBox(height: 24),

          // Score display
          Stack(
            alignment: Alignment.center,
            children: [
              // Background ring
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: plan.dayScore / 10,
                  strokeWidth: 6,
                  backgroundColor: AppColors.surfaceHighlightDark,
                  color: AppColors.primary,
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text(
                    plan.dayScore.toStringAsFixed(0),
                    style: GoogleFonts.outfit(
                      fontSize: 44,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark,
                      height: 1,
                    ),
                  ),
                  Text(
                    '/10',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: AppColors.textSecondaryDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _getEnergyLabel(plan.dayScore),
            style: GoogleFonts.inter(
              fontSize: 16,
              color: AppColors.textSecondaryDark,
            ),
          ),
        ],
      ),
    );
  }

  String _getEnergyLabel(double score) {
    if (score >= 8) return 'Excellent energy today ✨';
    if (score >= 6) return 'Your day looks favorable';
    if (score >= 4) return 'A balanced day ahead';
    return 'Take it easy today';
  }

  Widget _buildActionSection(
    String title,
    List<String> items,
    Color color,
    IconData icon,
    int delayMs,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppDecorations.accentCard(accentColor: color),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontSize: 13,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...items.asMap().entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 7),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: AppColors.textPrimaryDark,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).fadeSlideUp(delay: Duration(milliseconds: delayMs));
  }

  Widget _buildBestWindow(GamePlanData plan) {
    return Consumer(
      builder: (context, ref, _) {
        return GlassCard(
          onTap: () {
            ref.read(mainNavIndexProvider.notifier).state = 3; // Navigate to Muhurat tab
          },
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.12),
                ),
                child: const Icon(
                  Icons.wb_sunny_rounded,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BEST WINDOW', style: AppDecorations.sectionHeader()),
                    const SizedBox(height: 6),
                    Text(
                      '${plan.bestWindow.start} — ${plan.bestWindow.end}',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: AppColors.textTertiaryDark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategories(GamePlanData plan) {
    final entries = plan.categories.entries.toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: entries.map((e) {
          return Container(
            width: 105,
            margin: const EdgeInsets.only(right: 12),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 14,
              ),
              child: Column(
                children: [
                  Text(
                    e.key.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.value.toStringAsFixed(0),
                    style: GoogleFonts.outfit(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Mini progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: e.value / 10,
                      backgroundColor: AppColors.surfaceHighlightDark,
                      color: _getCategoryColor(e.value),
                      minHeight: 3,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _getCategoryColor(double score) {
    if (score >= 7) return AppColors.success;
    if (score >= 5) return AppColors.primary;
    return AppColors.warning;
  }

  Widget _buildAstroBabaPrompt() {
    return Consumer(
      builder: (context, ref, _) {
        return GlassCard(
          onTap: () {
            ref.read(mainNavIndexProvider.notifier).state = 4; // Navigate to Astro Baba tab
          },
          borderColor: AppColors.secondary.withOpacity(0.4),
          glowColor: AppColors.purpleGlow,
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: AppColors.secondary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Ask Astro Baba',
                style: GoogleFonts.outfit(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textTertiaryDark,
                size: 16,
              ),
            ],
          ),
        );
      },
    );
  }
}
