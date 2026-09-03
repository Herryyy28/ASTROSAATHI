import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../../../../core/widgets/why_this_bottom_sheet.dart';
import '../../../../core/providers/astro_intelligence_provider.dart';
import '../../../reminders/presentation/screens/astro_reminders_screen.dart';

class DecisionAssistantScreen extends ConsumerStatefulWidget {
  const DecisionAssistantScreen({super.key});

  @override
  ConsumerState<DecisionAssistantScreen> createState() => _DecisionAssistantScreenState();
}

class _DecisionAssistantScreenState extends ConsumerState<DecisionAssistantScreen> {
  String selectedQuestion = 'Should I schedule a job interview tomorrow?';

  final List<String> questions = [
    'Should I schedule a job interview tomorrow?',
    'Is today favorable for a major financial transaction?',
    'Should I schedule a critical business negotiation?',
    'Is today good for travel or relocating?',
    'Is this the right window for launching a new business product?',
    'Should I take an important exam or certification today?',
  ];

  Map<String, dynamic> getDecisionVerdict(String q, AstroIntelligenceSummary intel) {
    if (q.contains('financial') || q.contains('transaction')) {
      return {
        'verdict': 'Caution Advised',
        'color': AppColors.warning,
        'icon': Icons.warning_rounded,
        'window': 'Golden Window: 11:15 AM – 01:20 PM',
        'reason': 'Jupiter aspect provides financial expansion, but Rahu Kaal requires double-checking payment details.',
        'action': 'Finalize terms before 01:20 PM; avoid wire transfers during Rahu Kaal.',
        'planetFactor': 'Jupiter & Mercury in 2nd Dhana House',
        'houseFactor': '2nd Wealth & 11th Gain Axis',
        'transitFactor': 'Moon in ${intel.moonSign} • ${intel.panchangSummary}',
      };
    } else if (q.contains('interview') || q.contains('negotiation') || q.contains('business')) {
      return {
        'verdict': 'Highly Favorable',
        'color': AppColors.success,
        'icon': Icons.check_circle_rounded,
        'window': 'Peak Golden Window: 11:30 AM – 02:00 PM',
        'reason': 'Sun and Mercury alignment in 10th Karma house heightens persuasive authority and executive clarity.',
        'action': 'Schedule key talking points at 11:30 AM to maximize cosmic alignment.',
        'planetFactor': 'Sun-Mercury Karma Yoga Conjunction',
        'houseFactor': '10th Karma & 1st Lagna Axis',
        'transitFactor': '${intel.currentDasha} • ${intel.nakshatra}',
      };
    } else {
      return {
        'verdict': 'Favorable with Focus',
        'color': AppColors.success,
        'icon': Icons.check_circle_rounded,
        'window': 'Recommended Window: 10:30 AM – 01:15 PM',
        'reason': 'Siddhi Yoga favors new initiatives when launched before afternoon transit shifts.',
        'action': 'Proceed with confidence and document major milestones in writing.',
        'planetFactor': 'Venus-Jupiter Aspect',
        'houseFactor': '5th Intelligence & 9th Fortune Axis',
        'transitFactor': '${intel.panchangSummary}',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final intel = ref.watch(astroIntelligenceProvider);
    final decision = getDecisionVerdict(selectedQuestion, intel);
    final Color verdictColor = decision['color'] as Color;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : AppColors.backgroundDark,
      body: CosmicParticleBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
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
                          Text(
                            'Daily Decision Assistant',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.getTextPrimary(context),
                            ),
                          ),
                          Text(
                            'Kundli, Dasha & Transit Timing Engine',
                            style: GoogleFonts.inter(
                              fontSize: 11.5,
                              color: AppColors.getTextSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Question Dropdown Container
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isLight ? AppColors.surfaceLight : AppColors.surfaceHighlightDark.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.getGlassBorder(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'WHAT DECISION ARE YOU CONSIDERING?',
                        style: GoogleFonts.outfit(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedQuestion,
                        isExpanded: true,
                        dropdownColor: AppColors.getSurface(context),
                        style: GoogleFonts.outfit(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.getSurfaceSecondary(context),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        items: questions
                            .map((q) => DropdownMenuItem(
                                  value: q,
                                  child: Text(q, overflow: TextOverflow.ellipsis),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedQuestion = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Verdict Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: verdictColor.withOpacity(isLight ? 0.08 : 0.12),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: verdictColor.withOpacity(0.5), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(decision['icon'] as IconData, color: verdictColor, size: 26),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ASTROLOGICAL TIMING VERDICT',
                                  style: GoogleFonts.outfit(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.getTextSecondary(context),
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                Text(
                                  decision['verdict'] as String,
                                  style: GoogleFonts.outfit(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: verdictColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceSecondary(context),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          decision['window'] as String,
                          style: GoogleFonts.outfit(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        decision['reason'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 12.5,
                          color: AppColors.getTextPrimary(context),
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: verdictColor.withOpacity(0.8)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              WhyThisBottomSheet.show(
                                context,
                                title: selectedQuestion,
                                planetFactor: decision['planetFactor'] as String,
                                houseFactor: decision['houseFactor'] as String,
                                transitFactor: decision['transitFactor'] as String,
                                vedicInterpretation: decision['reason'] as String,
                                practicalAction: decision['action'] as String,
                              );
                            },
                            icon: const Icon(Icons.info_outline_rounded, size: 15, color: AppColors.primary),
                            label: Text(
                              'Why this verdict?',
                              style: GoogleFonts.outfit(
                                color: AppColors.primary,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AstroRemindersScreen()),
                              );
                            },
                            icon: const Icon(Icons.event_available_rounded, size: 15, color: Colors.black),
                            label: Text(
                              'Save Event & Reminder',
                              style: GoogleFonts.outfit(
                                color: Colors.black,
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fade().slideY(begin: 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
