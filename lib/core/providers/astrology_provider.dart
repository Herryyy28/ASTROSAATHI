import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/astrology_engine.dart';
import '../engine/mock_astrology_engine.dart';
import '../engine/models/game_plan_data.dart';
import '../engine/models/panchang_data.dart';
import '../engine/models/muhurat_data.dart';
import 'locale_provider.dart';
import 'profile_provider.dart';

final astrologyEngineProvider = Provider<AstrologyEngine>((ref) {
  return MockAstrologyEngine();
});

String _getLocationString(ref) {
  final profile = ref.watch(activeProfileProvider);
  return '${profile.latitude},${profile.longitude},${profile.timezone}';
}

final dailyGamePlanProvider = FutureProvider<GamePlanData>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final location = _getLocationString(ref);
  final now = DateTime.now();
  final date = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return await engine.calculateDailyGamePlan(date, location, languageCode: lang.code);
});

final selectedPanchangDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final panchangProvider = FutureProvider<PanchangData>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final location = _getLocationString(ref);
  final selectedDate = ref.watch(selectedPanchangDateProvider);
  final date = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
  return await engine.calculatePanchang(date, location, languageCode: lang.code);
});

final muhuratProvider = FutureProvider.family<MuhuratResult, String>((ref, category) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final location = _getLocationString(ref);
  final now = DateTime.now();
  final date = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  return await engine.calculateMuhurat(
    MuhuratInput(date: date, location: location, category: category),
    languageCode: lang.code,
  );
});

final birthChartProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final profile = ref.watch(activeProfileProvider);
  final location = '${profile.latitude},${profile.longitude},${profile.timezone}';
  
  final now = DateTime.now();
  final defaultDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  final date = profile.dob.isNotEmpty ? profile.dob : defaultDate;
  final time = profile.birthTime.isNotEmpty ? profile.birthTime : '12:00';
  
  return await engine.getBirthChart(date, time, location, languageCode: lang.code, profileId: profile.id);
});
