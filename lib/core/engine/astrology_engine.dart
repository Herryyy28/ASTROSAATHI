import 'models/game_plan_data.dart';
import 'models/panchang_data.dart';
import 'models/muhurat_data.dart';
import 'models/ai_data.dart';
import 'models/horoscope_data.dart';

abstract class AstrologyEngine {
  Future<GamePlanData> calculateDailyGamePlan(String date, String location);
  Future<PanchangData> calculatePanchang(String date, String location);
  Future<MuhuratResult> calculateMuhurat(MuhuratInput input);
  Future<AstroBabaResponse> askAstroBaba(String question, String date, String location);
  Future<HoroscopeData> getHoroscope(String sign, String timeframe);
}
