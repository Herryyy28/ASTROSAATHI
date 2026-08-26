import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../engine/astrology_engine.dart';
import '../engine/api_astrology_engine.dart';
import '../engine/mock_astrology_engine.dart';
import '../engine/models/game_plan_data.dart';
import '../engine/models/panchang_data.dart';
import '../engine/models/muhurat_data.dart';

final astrologyEngineProvider = Provider<AstrologyEngine>((ref) {
  // Use ApiAstrologyEngine to connect to NestJS backend.
  // Start the API server first: cd api && npm run start:dev
  return ApiAstrologyEngine();
});

final dailyGamePlanProvider = FutureProvider<GamePlanData>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  return await engine.calculateDailyGamePlan('Today', 'Current Location');
});

final panchangProvider = FutureProvider<PanchangData>((ref) async {
  final engine = ref.watch(astrologyEngineProvider);
  return await engine.calculatePanchang('Today', 'Current Location');
});

final muhuratProvider = FutureProvider.family<MuhuratResult, String>((ref, category) async {
  final engine = ref.watch(astrologyEngineProvider);
  return await engine.calculateMuhurat(MuhuratInput(date: 'Today', location: 'Current Location', category: category));
});
