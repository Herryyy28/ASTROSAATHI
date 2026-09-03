import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';
import '../../../astrology/presentation/screens/astro_decision_engine_screen.dart';
import '../../../astrology/presentation/screens/astro_scenario_simulator_screen.dart';
import '../../../astrology/presentation/screens/future_event_radar_screen.dart';
import '../../../search/presentation/widgets/astro_command_center_modal.dart';

class AstroWorkspaceScreen extends ConsumerWidget {
  const AstroWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final plan = ref.watch(dailyGamePlanProvider).value;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: isLight ? Theme.of(context).scaffoldBackgroundColor : null,
          gradient: isLight ? null : AppColors.cosmicRadialGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceElevated(context),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.getBorder(context), width: 0.8),
                        ),
                        child: Icon(Icons.arrow_back_rounded, color: AppColors.getTextPrimary(context), size: 18),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'AstroSaathi Workspace',
                                  style: GoogleFonts.outfit(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.getTextPrimary(context),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  gradient: AppColors.goldGradient,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'FLAGSHIP',
                                  style: GoogleFonts.outfit(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Unified life alignment, goals & timing dashboard',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.18),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withOpacity(0.5)),
                        ),
                        child: const Icon(Icons.bolt_rounded, color: AppColors.primary, size: 18),
                      ),
                      onPressed: () => AstroCommandCenterModal.show(context),
                    ),
                  ],
                ),
              ),

              // Scrollable Dashboard Body
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // Section 1: Today Score & Active Chapter
                    Row(
                      children: [
                        Expanded(
                          child: GlassCard(
                            padding: const EdgeInsets.all(16),
                            borderColor: AppColors.primary.withOpacity(0.4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('TODAY SCORE', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                                const SizedBox(height: 6),
                                Text(
                                  '${plan?.dayScore.toStringAsFixed(1) ?? "8.2"} / 10',
                                  style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                Text('▲ +0.8 vs Yesterday', style: GoogleFonts.inter(fontSize: 10, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GlassCard(
                            padding: const EdgeInsets.all(16),
                            borderColor: AppColors.secondary.withOpacity(0.4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('CURRENT CHAPTER', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                                const SizedBox(height: 6),
                                Text(
                                  'Jupiter Dasha',
                                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 2),
                                Text('Career & Expansion Period', style: GoogleFonts.inter(fontSize: 10, color: Colors.white70)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Section 2: Quick Power Actions Matrix
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('FLAGSHIP COMMAND SUITE', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildActionItem(context, Icons.bolt_rounded, 'Command Box', 'Universal Search', () => AstroCommandCenterModal.show(context)),
                              _buildActionItem(context, Icons.timer_rounded, 'Best Time', 'Muhurat Engine', () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const AstroDecisionEngineScreen()));
                              }),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildActionItem(context, Icons.science_rounded, 'Simulator', 'Scenario Lab', () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const AstroScenarioSimulatorScreen()));
                              }),
                              _buildActionItem(context, Icons.radar_rounded, 'Event Radar', 'Next 90 Days', () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const FutureEventRadarScreen()));
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Section 3: Active Goals Alignment Tracker
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('MY ASTRO GOALS (ACTIVE)', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
                              Text('4 Active', style: GoogleFonts.inter(fontSize: 10, color: Colors.white54)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildGoalTile(context, '💼 Executive Career Shift', 'Peak Window: Sep 12 – Oct 05', 0.85, Colors.amberAccent),
                          const SizedBox(height: 8),
                          _buildGoalTile(context, '🚀 Start New Venture', 'Peak Window: Oct 18 – Nov 10', 0.65, Colors.cyanAccent),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Section 4: Astro Baba AI Command
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      borderColor: AppColors.primary.withOpacity(0.5),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.goldGradient,
                            ),
                            child: const Icon(Icons.smart_toy_rounded, color: Colors.black, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Consult Astro Baba AI', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                                Text('Ask about your chart, dasha & timing', style: GoogleFonts.inter(fontSize: 11, color: Colors.white70)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_rounded, color: AppColors.primary),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const AstroBabaScreen()));
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(fontSize: 9.5, color: Colors.white54),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalTile(BuildContext context, String goal, String timing, double progress, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(goal, style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('${(progress * 100).toInt()}% Aligned', style: GoogleFonts.outfit(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 4),
          Text(timing, style: GoogleFonts.inter(fontSize: 10.5, color: Colors.white70)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
