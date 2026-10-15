import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/astrology_engine.dart';
import '../engine/astrology_data_enricher.dart';
import '../../demo/demo_astrology_engine.dart';
import '../engine/models/game_plan_data.dart';
import '../engine/models/panchang_data.dart';
import '../engine/models/muhurat_data.dart';
import 'locale_provider.dart';
import 'profile_provider.dart';
import '../models/astrology_models.dart';
import '../network/api_result.dart';
import 'repository_providers.dart';

final astrologyEngineProvider = Provider<AstrologyEngine>((ref) {
  return DemoAstrologyEngine();
});

String _getLocationString(Ref ref) {
  final profile = ref.watch(activeProfileProvider);
  return '${profile.latitude},${profile.longitude},${profile.timezone}';
}

final dailyGamePlanProvider = FutureProvider<GamePlanData>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final profile = ref.watch(activeProfileProvider);
  final location = _getLocationString(ref);
  final now = DateTime.now();
  final date =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return await engine.calculateDailyGamePlan(
    date,
    location,
    languageCode: lang.code,
    profileName: profile.name,
    dob: profile.dob,
    birthTime: profile.birthTime,
  );
});

final selectedPanchangDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final panchangProvider = FutureProvider<PanchangData>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final location = _getLocationString(ref);
  final selectedDate = ref.watch(selectedPanchangDateProvider);
  final date =
      '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
  return await engine.calculatePanchang(
    date,
    location,
    languageCode: lang.code,
  );
});

final muhuratProvider = FutureProvider.family<MuhuratResult, String>((
  ref,
  category,
) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final location = _getLocationString(ref);
  final now = DateTime.now();
  final date =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return await engine.calculateMuhurat(
    MuhuratInput(date: date, location: location, category: category),
    languageCode: lang.code,
  );
});

final birthChartProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final profile = ref.watch(activeProfileProvider);
  final location =
      '${profile.latitude},${profile.longitude},${profile.timezone}';

  final now = DateTime.now();
  final defaultDate =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  final date = profile.dob.isNotEmpty ? profile.dob : defaultDate;
  final time = profile.birthTime.isNotEmpty ? profile.birthTime : '12:00';

  final profileIdentifier = profile.name.isNotEmpty ? profile.name : profile.id;
  final chart = await engine.getBirthChart(
    date,
    time,
    location,
    languageCode: lang.code,
    profileId: profileIdentifier,
  );
  return AstrologyDataEnricher.enrichBirthChart(chart);
});

final typedKundliDataProvider = FutureProvider<KundliData>((ref) async {
  final repo = ref.watch(astrologyRepoProvider);
  final profile = ref.watch(activeProfileProvider);
  final result = await repo.generateKundli(profile.toBirthDetails());
  return switch (result) {
    Success(data: final k) => k,
    Failure(exception: final e) => throw e,
  };
});

final currentPlanetaryPositionsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
      final engine = ref.watch(astrologyEngineProvider);
      final location = _getLocationString(ref);
      final now = DateTime.now();
      final date =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final planets = await engine.getCurrentPlanetaryPositions(date, location);
      return AstrologyDataEnricher.normalizePlanets(planets);
    });

class SynastryRequest {
  const SynastryRequest(this.firstId, this.secondId);
  final String firstId;
  final String secondId;

  @override
  bool operator ==(Object other) =>
      other is SynastryRequest &&
      other.firstId == firstId &&
      other.secondId == secondId;

  @override
  int get hashCode => Object.hash(firstId, secondId);
}

class SynastryData {
  const SynastryData({
    required this.firstPlanets,
    required this.secondPlanets,
    required this.aspects,
  });
  final List<Map<String, dynamic>> firstPlanets;
  final List<Map<String, dynamic>> secondPlanets;
  final List<Map<String, dynamic>> aspects;
}

final synastryDataProvider = FutureProvider.autoDispose
    .family<SynastryData, SynastryRequest>((ref, request) async {
      final profiles = ref.watch(profilesListProvider);
      final first = profiles
          .where((profile) => profile.id == request.firstId)
          .firstOrNull;
      final second = profiles
          .where((profile) => profile.id == request.secondId)
          .firstOrNull;
      if (first == null || second == null) {
        return const SynastryData(
          firstPlanets: [],
          secondPlanets: [],
          aspects: [],
        );
      }
      final engine = ref.watch(astrologyEngineProvider);
      Future<Map<String, dynamic>> chartFor(BirthProfileData profile) =>
          engine.getBirthChart(
            profile.dob,
            profile.birthTime,
            '${profile.latitude},${profile.longitude},${profile.timezone}',
            profileId: profile.id,
          );
      final charts = await Future.wait([chartFor(first), chartFor(second)]);
      final firstChart = AstrologyDataEnricher.enrichBirthChart(charts[0]);
      final secondChart = AstrologyDataEnricher.enrichBirthChart(charts[1]);
      final firstPlanets = AstrologyDataEnricher.normalizePlanets(
        firstChart['planets'],
      );
      final secondPlanets = AstrologyDataEnricher.normalizePlanets(
        secondChart['planets'],
      );
      return SynastryData(
        firstPlanets: firstPlanets,
        secondPlanets: secondPlanets,
        aspects: AstrologyDataEnricher.calculateAspects(
          firstPlanets,
          secondPlanets,
        ),
      );
    });

final numerologyProvider = Provider<NumerologyResult>((ref) {
  final profile = ref.watch(activeProfileProvider);
  return NumerologyCalculator.calculate(name: profile.name, dob: profile.dob);
});
