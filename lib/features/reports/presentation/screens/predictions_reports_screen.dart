import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/profile_provider.dart';
import '../../../../core/providers/subscription_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';
import '../../../ai/presentation/screens/astro_baba_screen.dart';
import '../../../subscription/presentation/screens/premium_upgrade_modal.dart';

class PredictionsReportsScreen extends ConsumerWidget {
  const PredictionsReportsScreen({super.key, this.isEmbedded = false});
  final bool isEmbedded;

  static const _groups = <String, List<(String, bool)>>{
    'Love & Relationships': [
      ('Marriage', false),
      ('Ideal Partner', true),
      ('Love Style', false),
      ('Spouse', true),
    ],
    'Career & Business': [('Career', false), ('Job', true), ('Business', true)],
    'Money & Wealth': [
      ('Wealth', false),
      ('Finance', true),
      ('Property', true),
      ('Investment', true),
    ],
    'Health & Wellness': [
      ('Health & Wellness', false),
      ('Wellbeing Timing', true),
    ],
    'Self & Growth': [
      ('Personality', false),
      ('Strengths', false),
      ('Life Purpose', true),
    ],
    'Yearly Forecast': [('Annual Forecast', true), ('Important Periods', true)],
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const AstroPrimaryHeader(
                padding: EdgeInsets.fromLTRB(0, 18, 0, 12),
                eyebrow: 'Your astrology library',
                title: 'Personal Reports',
                subtitle: 'Deep readings written around your birth chart',
              ),
              const SizedBox(height: 8),
              ..._groups.entries.expand(
                (group) => [
                  Text(
                    group.key,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 11),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: group.value.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.47,
                        ),
                    itemBuilder: (_, i) {
                      final report = group.value[i];
                      return AstroReportCard(
                        title: report.$1,
                        subtitle: _reportDescription(report.$1),
                        icon: _reportIcon(report.$1),
                        locked:
                            report.$2 &&
                            !ref.read(subscriptionProvider).isPremium,
                        onTap: () => _open(context, ref, report.$1, report.$2),
                      );
                    },
                  ),
                  const SizedBox(height: 26),
                ],
              ),
            ]),
          ),
        ),
      ],
    );
    return isEmbedded
        ? content
        : Material(
            color: AppColors.backgroundLight,
            child: SafeArea(bottom: false, child: content),
          );
  }

  String _reportDescription(String title) {
    if (title.contains('Marriage') ||
        title.contains('Partner') ||
        title.contains('Love') ||
        title.contains('Spouse')) {
      return 'Relationship patterns';
    }
    if (title.contains('Career') ||
        title.contains('Job') ||
        title.contains('Business')) {
      return 'Work and opportunity';
    }
    if (title.contains('Wealth') ||
        title.contains('Finance') ||
        title.contains('Property') ||
        title.contains('Investment')) {
      return 'Money and resources';
    }
    if (title.contains('Health') || title.contains('Wellbeing')) {
      return 'Wellness rhythms';
    }
    if (title.contains('Annual') || title.contains('Periods')) {
      return 'Your year ahead';
    }
    return 'Personal chart insight';
  }

  IconData _reportIcon(String title) {
    if (title.contains('Marriage') ||
        title.contains('Partner') ||
        title.contains('Love') ||
        title.contains('Spouse')) {
      return Icons.favorite_outline_rounded;
    }
    if (title.contains('Career') ||
        title.contains('Job') ||
        title.contains('Business')) {
      return Icons.work_outline_rounded;
    }
    if (title.contains('Wealth') ||
        title.contains('Finance') ||
        title.contains('Property') ||
        title.contains('Investment')) {
      return Icons.savings_outlined;
    }
    if (title.contains('Health') || title.contains('Wellbeing')) {
      return Icons.spa_outlined;
    }
    if (title.contains('Annual') || title.contains('Periods')) {
      return Icons.calendar_month_outlined;
    }
    return Icons.auto_awesome_outlined;
  }

  void _open(BuildContext context, WidgetRef ref, String title, bool premium) {
    if (premium && !ref.read(subscriptionProvider).isPremium) {
      PremiumUpgradeModal.show(context);
      return;
    }
    final profile = ref.read(activeProfileProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => DraggableScrollableSheet(
        initialChildSize: .7,
        maxChildSize: .92,
        minChildSize: .5,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: AppColors.backgroundLight,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.highlightSurface,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.softLavender,
                    child: Icon(Icons.auto_awesome, color: AppColors.secondary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryLightMode,
                          ),
                        ),
                        Text(
                          'Personalized for ${profile.name.isEmpty ? 'you' : profile.name}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(sheetContext),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const AstroCard(
                child: Text(
                  'Your report is calculated from your saved birth chart and current planetary periods. Open the detailed consultation to explore timing, strengths, cautions and practical remedies.',
                  style: TextStyle(
                    height: 1.55,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const AstroSectionHeader(title: 'What this report covers'),
              const SizedBox(height: 8),
              ...[
                'Key planetary influences',
                'Important timing windows',
                'Practical focus areas',
                'Personalized remedies',
              ].map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.secondary,
                        size: 19,
                      ),
                      const SizedBox(width: 10),
                      Text(e),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              AstroPrimaryButton(
                label: 'Discuss with AstroSaathi',
                icon: Icons.chat_bubble_outline_rounded,
                onPressed: () {
                  Navigator.pop(sheetContext);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AstroBabaScreen(
                        initialMessage:
                            'Please explain my $title report in detail with remedies.',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
