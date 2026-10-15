import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/astro_components.dart';

class NumerologyScreen extends ConsumerWidget {
  const NumerologyScreen({super.key});

  String _interpretation(int number) => switch (number) {
    1 => 'Independent, original and motivated by meaningful achievement.',
    2 => 'Diplomatic, perceptive and naturally attuned to partnership.',
    3 => 'Creative, expressive and gifted at bringing ideas to life.',
    4 => 'Practical, disciplined and focused on building lasting stability.',
    5 => 'Adaptable, curious and energized by freedom and constructive change.',
    6 => 'Responsible, caring and committed to harmony and belonging.',
    7 => 'Analytical, intuitive and drawn toward deeper truth.',
    8 => 'Ambitious, capable and skilled at turning vision into results.',
    9 => 'Compassionate, idealistic and motivated by collective wellbeing.',
    11 => 'Highly intuitive, inspiring and receptive to spiritual insight.',
    22 => 'A visionary builder capable of translating large ideas into form.',
    33 => 'A compassionate teacher with a strong instinct to uplift others.',
    _ => 'A distinctive path with its own rhythm, lessons and potential.',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(activeProfileProvider);
    final numbers = ref.watch(numerologyProvider);
    final lifePath = numbers.lifePath;
    final destiny = numbers.destiny;

    return AstroDetailScaffold(
      title: 'Numerology',
      subtitle: 'Reveal the patterns hidden within your numbers.',
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            right: 8,
            top: -34,
            child: _FaintNumber('9', size: 72),
          ),
          const Positioned(
            left: 4,
            top: 104,
            child: _FaintNumber('2', size: 56),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileCard(profile.name, profile.dob),
              const SizedBox(height: 22),
              Text(
                'Your Core Numbers',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryLightMode,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Calculated from the birth details saved in your active profile.',
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _numberHero(
                      number: lifePath,
                      label: 'Life Path',
                      source: 'Birth date',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _numberHero(
                      number: destiny,
                      label: 'Destiny',
                      source: 'Full name',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _numberHero(
                      number: numbers.soulUrge,
                      label: 'Soul Urge',
                      source: 'Name vowels',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _numberHero(
                      number: numbers.birthday,
                      label: 'Birthday',
                      source: 'Birth day',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const AstroSectionHeader(title: 'Detailed interpretation'),
              const SizedBox(height: 10),
              if (lifePath != null)
                _interpretationCard(
                  glyph: '$lifePath',
                  title: 'Life Path · $lifePath',
                  eyebrow: 'CORE PATTERN',
                  body: _interpretation(lifePath),
                )
              else
                const AstroCard(
                  child: AstroEmptyState(
                    icon: Icons.numbers_rounded,
                    title: 'Life Path unavailable',
                    subtitle:
                        'Add a valid birth date to calculate this number.',
                  ),
                ),
              const SizedBox(height: 12),
              if (destiny != null)
                _interpretationCard(
                  glyph: '$destiny',
                  title: 'Destiny · $destiny',
                  eyebrow: 'OUTER EXPRESSION',
                  body: _interpretation(destiny),
                )
              else
                const AstroCard(
                  child: AstroEmptyState(
                    icon: Icons.person_outline_rounded,
                    title: 'Destiny number unavailable',
                    subtitle: 'Add a valid full name to calculate this number.',
                  ),
                ),
              const SizedBox(height: 24),
              const AstroSectionHeader(title: 'Interpretation themes'),
              const SizedBox(height: 10),
              AstroCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _InterpretationTheme(
                      label: 'Strengths',
                      value: _sectionInterpretation('Strengths', lifePath),
                    ),
                    _InterpretationTheme(
                      label: 'Challenges',
                      value: _sectionInterpretation('Challenges', lifePath),
                    ),
                    _InterpretationTheme(
                      label: 'Relationships',
                      value: _sectionInterpretation(
                        'Relationships',
                        numbers.soulUrge ?? lifePath,
                      ),
                    ),
                    _InterpretationTheme(
                      label: 'Career',
                      value: _sectionInterpretation('Career', destiny),
                    ),
                    _InterpretationTheme(
                      label: 'Growth',
                      value: _sectionInterpretation('Growth', lifePath),
                      showDivider: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _sectionInterpretation(String section, int? number) {
    if (number == null) return 'Not available for the current profile.';
    final core = _interpretation(number);
    return switch (section) {
      'Strengths' => 'Your $number vibration supports these qualities: $core',
      'Challenges' =>
        'Growth comes from balancing the natural intensity of your $number vibration with flexibility and self-awareness.',
      'Relationships' =>
        'In close bonds, your $number vibration seeks expression through the same inner pattern: $core',
      'Career' => 'Your work style is guided by the $number vibration. $core',
      _ =>
        'Personal growth strengthens when the constructive qualities of your $number vibration are practiced consistently.',
    };
  }

  Widget _profileCard(String name, String dob) => AstroCard(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    child: Row(
      children: [
        const AstroGlyphIcon(glyph: '№', semanticLabel: 'Numerology profile'),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name.isEmpty ? 'Your profile' : name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                dob.isEmpty ? 'Add a birth date to personalize' : dob,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ).animate().fadeIn(duration: 220.ms).slideY(begin: .04, end: 0);

  Widget _numberHero({
    required int? number,
    required String label,
    required String source,
  }) => AstroCard(
    color: AppColors.highlightSurface,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
    child: Column(
      children: [
        if (number == null)
          Text(
            '—',
            style: GoogleFonts.playfairDisplay(
              fontSize: 48,
              height: 1,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryLightMode,
            ),
          )
        else
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: number.toDouble()),
            duration: const Duration(milliseconds: 300),
            builder: (_, value, _) => Text(
              '${value.round()}',
              style: GoogleFonts.playfairDisplay(
                fontSize: 48,
                height: 1,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryLightMode,
              ),
            ),
          ),
        const SizedBox(height: 10),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          source,
          style: const TextStyle(
            fontSize: 10.5,
            color: AppColors.textSecondaryLight,
          ),
        ),
      ],
    ),
  ).animate().fadeIn(delay: 100.ms, duration: 220.ms).slideY(begin: .05);

  Widget _interpretationCard({
    required String glyph,
    required String title,
    required String eyebrow,
    required String body,
  }) => AstroCard(
    padding: const EdgeInsets.all(18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AstroGlyphIcon(glyph: glyph, size: 42, semanticLabel: title),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    eyebrow,
                    style: const TextStyle(
                      fontSize: 10,
                      letterSpacing: .9,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: AppColors.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            body,
            style: const TextStyle(
              fontSize: 14,
              height: 1.55,
              color: AppColors.textPrimaryLight,
            ),
          ),
        ),
      ],
    ),
  );
}

class _FaintNumber extends StatelessWidget {
  const _FaintNumber(this.value, {required this.size});
  final String value;
  final double size;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Text(
      value,
      style: GoogleFonts.playfairDisplay(
        fontSize: size,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryLightMode.withValues(alpha: .05),
      ),
    ),
  );
}

class _InterpretationTheme extends StatelessWidget {
  const _InterpretationTheme({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 11.5,
                  height: 1.35,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ),
          ],
        ),
      ),
      if (showDivider) const Divider(height: 1, color: AppColors.softLavender),
    ],
  );
}
