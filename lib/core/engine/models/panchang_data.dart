import 'game_plan_data.dart';

class PanchangData {
  final String tithi;
  final String vara;
  final String nakshatra;
  final String yoga;
  final String karana;
  final String sunrise;
  final String sunset;
  final TimeWindow? rahuKaal;

  PanchangData({
    required this.tithi,
    required this.vara,
    required this.nakshatra,
    required this.yoga,
    required this.karana,
    required this.sunrise,
    required this.sunset,
    this.rahuKaal,
  });
}
