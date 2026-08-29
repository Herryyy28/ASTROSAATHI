import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/cosmic_particle_background.dart';
import '../widgets/mantra_japa_counter_widget.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';

class RemedyHubScreen extends StatefulWidget {
  const RemedyHubScreen({super.key});

  @override
  State<RemedyHubScreen> createState() => _RemedyHubScreenState();
}

class _RemedyHubScreenState extends State<RemedyHubScreen> {
  String selectedPlanet = 'Jupiter (Guru)';

  final Map<String, Map<String, dynamic>> planetRemedies = {
    'Jupiter (Guru)': {
      'gemstone': 'Yellow Sapphire (Pukhraj)',
      'emoji': '🟡',
      'wearing': 'Wear on Index Finger • Thursday Morning',
      'benefit': 'Strengthens wisdom, higher learning, career growth, and wealth.',
      'mantraTitle': 'Guru (Jupiter) Beej Mantra',
      'mantraText': 'Om Gram Greem Grom Sah Gurave Namah\n(108 Chants on Thursday)',
      'rituals': [
        'Offer yellow flowers and chana dal to Lord Vishnu on Thursdays',
        'Chant Vishnu Sahasranama at sunrise',
        'Donate yellow sweets or books to students',
      ],
    },
    'Saturn (Shani)': {
      'gemstone': 'Blue Sapphire (Neelam) / Amethyst',
      'emoji': '🔵',
      'wearing': 'Wear on Middle Finger • Saturday Evening',
      'benefit': 'Removes obstacles, balances Karma, brings discipline and stability.',
      'mantraTitle': 'Shani Beej Mantra & Hanuman Chalisa',
      'mantraText': 'Om Sham Shanaiscarya Namah\n(108 Chants on Saturday)',
      'rituals': [
        'Light a mustard oil lamp under a Peepal tree on Saturday evening',
        'Chant Hanuman Chalisa daily',
        'Donate black sesame seeds, iron, or shoes to the needy',
      ],
    },
    'Mars (Mangal)': {
      'gemstone': 'Red Coral (Moonga)',
      'emoji': '🔴',
      'wearing': 'Wear on Ring Finger • Tuesday Morning',
      'benefit': 'Boosts courage, energy, property gains, and resolves Mangal Dosh.',
      'mantraTitle': 'Mangal Beej Mantra',
      'mantraText': 'Om Kram Kreem Krom Sah Bhaumaya Namah\n(108 Chants on Tuesday)',
      'rituals': [
        'Offer red flowers and jaggery to Lord Hanuman on Tuesdays',
        'Recite Sundarkand or Hanuman Bahuk',
        'Donate red lentils (Masoor Dal) or blood donation',
      ],
    },
    'Venus (Shukra)': {
      'gemstone': 'Diamond / Opal',
      'emoji': '⚪',
      'wearing': 'Wear on Middle or Ring Finger • Friday Morning',
      'benefit': 'Enhances love, luxury, arts, relationship harmony, and magnetic charm.',
      'mantraTitle': 'Shukra Beej Mantra',
      'mantraText': 'Om Dram Dreem Drom Sah Shukraya Namah\n(108 Chants on Friday)',
      'rituals': [
        'Offer white sweets, rice, or ghee to needy women on Fridays',
        'Chant Shri Suktam for Lakshmi grace',
        'Use sandalwood fragrance and maintain cleanliness',
      ],
    },
    'Mercury (Budh)': {
      'gemstone': 'Emerald (Panna)',
      'emoji': '🟢',
      'wearing': 'Wear on Little Finger • Wednesday Morning',
      'benefit': 'Sharpens intelligence, communication, business success, and analytical skills.',
      'mantraTitle': 'Budh Beej Mantra',
      'mantraText': 'Om Bram Breem Brom Sah Budhaya Namah\n(108 Chants on Wednesday)',
      'rituals': [
        'Feed green grass or spinaches to cows on Wednesdays',
        'Pray to Lord Ganesha offering Durva grass',
        'Donate green clothes or green moong dal',
      ],
    },
  };

  @override
  Widget build(BuildContext context) {
    final remedy = planetRemedies[selectedPlanet]!;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
                      child: const Icon(Icons.wb_incandescent_rounded, color: Colors.black, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Consumer(
                      builder: (context, ref, _) {
                        final l10n = AppLocalizations.of(context, ref);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.remediesTitle,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                            Text(
                              l10n.remediesSub,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Planet Selector Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: planetRemedies.keys.map((planet) {
                      final isSelected = planet == selectedPlanet;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(planet),
                          selected: isSelected,
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.surfaceDark,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.black : AppColors.textPrimaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          onSelected: (selected) {
                            if (selected) setState(() => selectedPlanet = planet);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Recommended Gemstone Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.cardGradient,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 16),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.2),
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: Center(
                          child: Text(remedy['emoji'] as String, style: const TextStyle(fontSize: 28)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              remedy['gemstone'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              remedy['benefit'] as String,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryDark, height: 1.3),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              remedy['wearing'] as String,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fade().slideY(begin: 0.1),
                const SizedBox(height: 24),

                // Interactive Japa Counter with selected Mantra
                MantraJapaCounterWidget(
                  mantraTitle: remedy['mantraTitle'] as String,
                  mantraText: remedy['mantraText'] as String,
                ).animate().fade(delay: 150.ms).slideY(begin: 0.1),
                const SizedBox(height: 24),

                // Daily Karma Ritual Checklist
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceHighlightDark.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.glassBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Authentic Upay for $selectedPlanet',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimaryDark),
                      ),
                      const SizedBox(height: 12),
                      ...(remedy['rituals'] as List<String>).map((r) => _buildRitualTile(r)),
                    ],
                  ),
                ).animate().fade(delay: 300.ms).slideY(begin: 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRitualTile(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.primary,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textPrimaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
