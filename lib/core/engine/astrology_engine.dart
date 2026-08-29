import 'models/game_plan_data.dart';
import 'models/panchang_data.dart';
import 'models/muhurat_data.dart';
import 'models/ai_data.dart';
import 'models/horoscope_data.dart';

abstract class AstrologyEngine {
  Future<GamePlanData> calculateDailyGamePlan(String date, String location, {String languageCode = 'en'});
  Future<PanchangData> calculatePanchang(String date, String location, {String languageCode = 'en'});
  Future<MuhuratResult> calculateMuhurat(MuhuratInput input, {String languageCode = 'en'});
  Future<AstroBabaResponse> askAstroBaba(String question, String date, String location, {String languageCode = 'en'});
  Future<HoroscopeData> getHoroscope(String sign, String timeframe, {String languageCode = 'en'});
  Future<Map<String, dynamic>> getBirthChart(String date, String time, String location, {String languageCode = 'en', String? profileId});
}
