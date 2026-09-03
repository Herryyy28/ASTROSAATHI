import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_provider.dart';

class AstroIntelligenceSummary {
  final String activeProfileName;
  final String sunSign;
  final String moonSign;
  final String nakshatra;
  final String currentDasha;
  final String todayTransitHighlight;
  final String panchangSummary;
  final String keyRecommendation;
  final double cosmicAlignmentScore;

  AstroIntelligenceSummary({
    required this.activeProfileName,
    required this.sunSign,
    required this.moonSign,
    required this.nakshatra,
    required this.currentDasha,
    required this.todayTransitHighlight,
    required this.panchangSummary,
    required this.keyRecommendation,
    required this.cosmicAlignmentScore,
  });
}

final astroIntelligenceProvider = Provider<AstroIntelligenceSummary>((ref) {
  final profile = ref.watch(activeProfileProvider);

  String profileName = profile.name.isEmpty ? 'Seeker' : profile.name;

  return AstroIntelligenceSummary(
    activeProfileName: profileName,
    sunSign: 'Leo ♌',
    moonSign: 'Aquarius ♒',
    nakshatra: 'Shatabhisha Nakshatra (Pada 2)',
    currentDasha: 'Mahadasha: Jupiter • Antardasha: Venus',
    todayTransitHighlight: 'Moon transiting 7th House favors partnerships & key decisions.',
    panchangSummary: 'Shukla Paksha Dashami • Abhijit Muhurat: 11:45 AM - 12:35 PM',
    keyRecommendation: 'Optimal time between 11:30 AM and 02:00 PM for major commitments.',
    cosmicAlignmentScore: 8.8,
  );
});
