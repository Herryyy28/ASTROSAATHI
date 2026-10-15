import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/engine/models/game_plan_data.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';

class TransitCenterScreen extends ConsumerWidget {
  const TransitCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileProvider);
    final plan = ref.watch(dailyGamePlanProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            AstroPrimaryHeader(
              eyebrow: 'Planetary weather',
              title: 'Transits',
              subtitle:
                  'Current planetary influence for ${profile.name.isEmpty ? "your active profile" : profile.name}',
              trailing: IconButton(
                tooltip: 'Close',
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.primaryLightMode,
                ),
              ),
            ),
            Expanded(
              child: plan.when(
                loading: () => const SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 8, 20, 32),
                  child: AstroLoadingState(
                    label: 'Calculating current transits…',
                  ),
                ),
                error: (_, _) => AstroErrorState(
                  message: 'Current transit guidance could not be loaded.',
                  onRetry: () => ref.invalidate(dailyGamePlanProvider),
                ),
                data: _content,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(GamePlanData data) {
    final planet = data.planetFactor?.trim();
    final transit = data.transitFactor?.trim();
    final house = data.houseFactor?.trim();
    final interpretation = data.vedicInterpretation?.trim();
    final action = data.practicalAction?.trim();
    final hasTransit = [
      planet,
      transit,
      house,
      interpretation,
      action,
    ].any((value) => value?.isNotEmpty ?? false);

    if (!hasTransit) {
      return const Padding(
        padding: EdgeInsets.all(32),
        child: AstroEmptyState(
          icon: Icons.public_rounded,
          title: 'No current transit insight',
          subtitle:
              'Transit details will appear when they are available for this profile.',
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        const AstroPageIntro(
          tag: 'Current influence',
          title: 'Your planetary weather',
          subtitle:
              'A focused view of the live transit factors returned for your chart.',
          icon: Icons.track_changes_rounded,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (planet?.isNotEmpty == true) const _ThemeChip(label: 'Planet'),
            if (house?.isNotEmpty == true)
              const _ThemeChip(label: 'Chart area'),
            if (transit?.isNotEmpty == true)
              const _ThemeChip(label: 'Current transit'),
            if (interpretation?.isNotEmpty == true)
              const _ThemeChip(label: 'Personal relevance'),
          ],
        ),
        const SizedBox(height: 12),
        AstroCard(
          radius: 22,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AstroGlyphIcon(
                    glyph: AstroSymbols.planet(planet ?? transit ?? ''),
                    size: 50,
                    emphasized: true,
                    semanticLabel: planet ?? 'Current planet',
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planet?.isNotEmpty == true
                              ? planet!
                              : 'Current transit',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryLightMode,
                          ),
                        ),
                        if (transit?.isNotEmpty == true) ...[
                          const SizedBox(height: 3),
                          Text(
                            transit!,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const _ImpactIndicator(),
                ],
              ),
              if (house?.isNotEmpty == true) ...[
                const SizedBox(height: 16),
                _InsightLine(
                  icon: Icons.home_work_outlined,
                  label: 'Chart area',
                  value: house!,
                ),
              ],
              if (interpretation?.isNotEmpty == true) ...[
                const SizedBox(height: 10),
                _InsightLine(
                  icon: Icons.auto_awesome_outlined,
                  label: 'Personal relevance',
                  value: interpretation!,
                ),
              ],
              if (action?.isNotEmpty == true) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.softLavender,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    action!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.45,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        if (data.doList.isNotEmpty || data.avoidList.isNotEmpty) ...[
          const SizedBox(height: 18),
          const AstroSectionHeader(title: 'Use this transit well'),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final cards = <Widget>[
                if (data.doList.isNotEmpty)
                  _ActionListCard(
                    title: 'FOCUS',
                    icon: Icons.adjust_rounded,
                    items: data.doList.take(3).toList(),
                    color: AppColors.primaryLightMode,
                  ),
                if (data.avoidList.isNotEmpty)
                  _ActionListCard(
                    title: 'AVOID',
                    icon: Icons.error_outline_rounded,
                    items: data.avoidList.take(3).toList(),
                    color: AppColors.pink,
                  ),
              ];
              if (constraints.maxWidth < 380 || cards.length == 1) {
                return Column(
                  children: cards
                      .map(
                        (card) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: card,
                        ),
                      )
                      .toList(),
                );
              }
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: cards.first),
                  const SizedBox(width: 12),
                  Expanded(child: cards.last),
                ],
              );
            },
          ),
        ],
        if (_mentionsRetrograde(data)) ...[
          const SizedBox(height: 16),
          AstroCard(
            child: Row(
              children: [
                const AstroGlyphIcon(
                  glyph: '℞',
                  size: 42,
                  semanticLabel: 'Retrograde',
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Retrograde influence',
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimaryLight,
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Shown because the current provider insight identifies retrograde motion.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  bool _mentionsRetrograde(GamePlanData data) =>
      [
        data.planetFactor,
        data.transitFactor,
        data.vedicInterpretation,
      ].whereType<String>().any(
        (value) =>
            value.toLowerCase().contains('retrograde') || value.contains('℞'),
      );
}

class _ImpactIndicator extends StatelessWidget {
  const _ImpactIndicator();

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Current influence active',
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondaryBackground,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.graphic_eq_rounded, size: 14, color: AppColors.secondary),
          SizedBox(width: 4),
          Text(
            'Active',
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLightMode,
            ),
          ),
        ],
      ),
    ),
  );
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.secondaryBackground,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.softLavender),
    ),
    child: Text(
      label,
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryLightMode,
      ),
    ),
  );
}

class _ActionListCard extends StatelessWidget {
  const _ActionListCard({
    required this.title,
    required this.icon,
    required this.items,
    required this.color,
  });

  final String title;
  final IconData icon;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) => AstroCard(
    padding: const EdgeInsets.all(15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                letterSpacing: .8,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 7),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• ', style: TextStyle(color: color)),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 12.5,
                      height: 1.35,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _InsightLine extends StatelessWidget {
  const _InsightLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 18, color: AppColors.secondary),
      const SizedBox(width: 9),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 9.5,
                letterSpacing: .8,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: AppColors.textPrimaryLight,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
