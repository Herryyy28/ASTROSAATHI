import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../../../../core/widgets/why_this_bottom_sheet.dart';

class DecisionAssistantScreen extends StatefulWidget {
  const DecisionAssistantScreen({super.key});

  @override
  State<DecisionAssistantScreen> createState() => _DecisionAssistantScreenState();
}

class _DecisionAssistantScreenState extends State<DecisionAssistantScreen> {
  String selectedQuestion = 'Should I start a new venture today?';

  final List<String> questions = [
    'Should I start a new venture today?',
    'Is today favorable for a major financial purchase?',
    'Should I schedule a critical negotiation meeting?',
    'Is today good for travel or contract signing?',
  ];

  Map<String, dynamic> getDecisionVerdict(String q) {
    if (q.contains('financial') || q.contains('purchase')) {
      return {
        'verdict': 'Caution Advised',
        'color': AppColors.warning,
        'icon': Icons.warning_rounded,
        'window': 'Best Window: 11:15 AM – 1:20 PM',
        'reason': 'Jupiter aspect provides growth, but Rahu Kaal (1:30 PM - 3:00 PM) requires double-checking contracts.',
        'action': 'Finalize negotiations before 1:20 PM; avoid wire transfers during Rahu Kaal.',
      };
    } else if (q.contains('meeting') || q.contains('negotiation')) {
      return {
        'verdict': 'Highly Favorable',
        'color': AppColors.success,
        'icon': Icons.check_circle_rounded,
        'window': 'Golden Window: 11:15 AM – 1:20 PM',
        'reason': 'Sun and Mercury conjunct in 10th Karma house heightens persuasive authority and clarity.',
        'action': 'Schedule key talking points at 11:30 AM to maximize alignment.',
      };
    } else {
      return {
        'verdict': 'Favorable with Focus',
        'color': AppColors.success,
        'icon': Icons.check_circle_rounded,
        'window': 'Recommended Window: 10:30 AM – 1:15 PM',
        'reason': 'Siddhi Yoga under Rohini Nakshatra favors new initiatives when launched before afternoon.',
        'action': 'Proceed with clarity and document main milestones in writing.',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final decision = getDecisionVerdict(selectedQuestion);
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
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.goldGradient,
                      ),
                      child: const Icon(Icons.explore_rounded, color: Colors.black, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Decision Assistant',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.getTextPrimary(context)),
                          ),
                          Text(
                            'Vedic Timing & Planetary Alignment Evaluator',
                            style: TextStyle(fontSize: 12, color: AppColors.getTextSecondary(context)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Question Dropdown Container
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isLight ? AppColors.surfaceLight : AppColors.surfaceHighlightDark.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.getGlassBorder(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('What decision are you considering?', style: TextStyle(fontSize: 13, color: AppColors.getTextSecondary(context))),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedQuestion,
                        isExpanded: true,
                        dropdownColor: AppColors.getSurface(context),
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.getSurfaceSecondary(context),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                        ),
                        items: questions.map((q) => DropdownMenuItem(value: q, child: Text(q, overflow: TextOverflow.ellipsis))).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedQuestion = val);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Verdict Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: verdictColor.withOpacity(isLight ? 0.08 : 0.12),
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: verdictColor.withOpacity(0.5), width: 1.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(decision['icon'] as IconData, color: verdictColor, size: 28),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Astrological Verdict', style: TextStyle(fontSize: 11, color: AppColors.getTextSecondary(context))),
                              Text(
                                decision['verdict'] as String,
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: verdictColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.getSurfaceSecondary(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          decision['window'] as String,
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        decision['reason'] as String,
                        style: TextStyle(fontSize: 13, color: AppColors.getTextPrimary(context), height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: verdictColor, width: 0.8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {
                          WhyThisBottomSheet.show(
                            context,
                            title: selectedQuestion,
                            planetFactor: 'Sun-Mercury Conjunction & Moon Transit',
                            houseFactor: '10th Karma & 1st Lagna Axis',
                            transitFactor: 'Siddhi Yoga (Rohini Nakshatra)',
                            vedicInterpretation: decision['reason'] as String,
                            practicalAction: decision['action'] as String,
                          );
                        },
                        icon: const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                        label: const Text('Why this verdict?', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
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
