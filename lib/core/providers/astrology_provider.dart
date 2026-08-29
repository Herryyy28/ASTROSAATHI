import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/astrology_engine.dart';
import '../engine/api_astrology_engine.dart';
import '../engine/models/game_plan_data.dart';
import '../engine/models/panchang_data.dart';
import '../engine/models/muhurat_data.dart';
import 'locale_provider.dart';
import 'user_profile_provider.dart';

final astrologyEngineProvider = Provider<AstrologyEngine>((ref) {
  // Use ApiAstrologyEngine to connect to NestJS backend.
  // Start the API server first: cd api && npm run start:dev
  return ApiAstrologyEngine();
});

String _getLocationString(ref) {
  final profile = ref.watch(userProfileProvider);
  return '${profile.latitude},${profile.longitude},${profile.timeZone}';
}

final dailyGamePlanProvider = FutureProvider<GamePlanData>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final location = _getLocationString(ref);
  final date = DateTime.now().toIso8601String();
  return await engine.calculateDailyGamePlan(date, location, languageCode: lang.code);
});

final panchangProvider = FutureProvider<PanchangData>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final location = _getLocationString(ref);
  final date = DateTime.now().toIso8601String();
  return await engine.calculatePanchang(date, location, languageCode: lang.code);
});

final muhuratProvider = FutureProvider.family<MuhuratResult, String>((ref, category) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final location = _getLocationString(ref);
  final date = DateTime.now().toIso8601String();
  return await engine.calculateMuhurat(
    MuhuratInput(date: date, location: location, category: category),
    languageCode: lang.code,
  );
});

final birthChartProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  final lang = ref.watch(localeProvider);
  final profile = ref.watch(userProfileProvider);
  final location = '${profile.latitude},${profile.longitude},${profile.timeZone}';
  
  // Use profile dob and time if available, otherwise fallback to current date
  final date = profile.dob.isNotEmpty ? profile.dob : DateTime.now().toIso8601String();
  final time = profile.time.isNotEmpty ? profile.time : '12:00';
  
  return await engine.getBirthChart(date, time, location, languageCode: lang.code);
});
