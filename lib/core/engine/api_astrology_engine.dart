import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;
import 'astrology_engine.dart';
import 'mock_astrology_engine.dart';
import 'models/game_plan_data.dart';
import 'models/panchang_data.dart';
import 'models/muhurat_data.dart';
import 'models/ai_data.dart';
import 'models/horoscope_data.dart';

/// Tries the real API first, falls back to MockAstrologyEngine if unreachable.
class ApiAstrologyEngine implements AstrologyEngine {
  final String baseUrl = kIsWeb
      ? 'http://localhost:3000/api/v1'
      : 'http://10.0.2.2:3000/api/v1';

  final MockAstrologyEngine _fallback = MockAstrologyEngine();

  @override
  Future<GamePlanData> calculateDailyGamePlan(String date, String location) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/astrology/game-plan?date=$date&lat=28.6139&lon=77.2090&tz=5.5'),
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body)['data'];
        return GamePlanData(
          date: json['date'],
          dayScore: (json['dayScore'] as num).toDouble(),
          doList: List<String>.from(json['doList']),
          beCarefulList: List<String>.from(json['beCarefulList']),
          avoidList: List<String>.from(json['avoidList']),
          bestWindow: TimeWindow(start: json['bestWindow']['start'], end: json['bestWindow']['end']),
          categories: Map<String, double>.from(
            (json['categories'] as Map).map((key, value) => MapEntry(key.toString(), (value as num).toDouble())),
          ),
        );
      }
    } catch (e) {
      debugPrint('API unreachable for game-plan, using fallback: $e');
    }
    return _fallback.calculateDailyGamePlan(date, location);
  }

  @override
  Future<PanchangData> calculatePanchang(String date, String location) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/astrology/panchang?date=$date&lat=28.6139&lon=77.2090&tz=5.5'),
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body)['data'];
        return PanchangData(
          tithi: json['tithi'],
          vara: json['vara'],
          nakshatra: json['nakshatra'],
          yoga: json['yoga'],
          karana: json['karana'],
          sunrise: json['sunrise'],
          sunset: json['sunset'],
          rahuKaal: json['rahuKaal'] != null
              ? TimeWindow(start: json['rahuKaal']['start'], end: json['rahuKaal']['end'])
              : null,
        );
      }
    } catch (e) {
      debugPrint('API unreachable for panchang, using fallback: $e');
    }
    return _fallback.calculatePanchang(date, location);
  }

  @override
  Future<MuhuratResult> calculateMuhurat(MuhuratInput input) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/astrology/muhurat?category=${input.category}&date=${input.date}&lat=28.6139&lon=77.2090&tz=5.5'),
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body)['data'];
        return MuhuratResult(
          category: json['category'],
          bestWindow: TimeWindow(start: json['bestWindow']['start'], end: json['bestWindow']['end']),
          strength: json['strength'],
          bestFor: json['bestFor'],
          avoidWindow: json['avoidWindow'] != null
              ? TimeWindow(start: json['avoidWindow']['start'], end: json['avoidWindow']['end'])
              : null,
        );
      }
    } catch (e) {
      debugPrint('API unreachable for muhurat, using fallback: $e');
    }
    return _fallback.calculateMuhurat(input);
  }

  @override
  Future<AstroBabaResponse> askAstroBaba(String question, String date, String location) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ai/ask-astro-baba'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'question': question,
          'date': date,
          'lat': 28.6139,
          'lon': 77.2090,
          'tz': '5.5'
        }),
      ).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body)['data'];
        return AstroBabaResponse(
          answer: json['answer'],
          confidence: json['confidence'],
          actions: List<String>.from(json['actions'] ?? []),
          warnings: List<String>.from(json['warnings'] ?? []),
        );
      }
    } catch (e) {
      debugPrint('API unreachable for astro-baba, using fallback: $e');
    }
    return _fallback.askAstroBaba(question, date, location);
  }

  @override
  Future<HoroscopeData> getHoroscope(String sign, String timeframe) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/astrology/horoscope?sign=$sign&timeframe=$timeframe'),
      ).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body)['data'];
        return HoroscopeData(
          sign: json['sign'],
          timeframe: json['timeframe'],
          reading: json['reading'],
          luckyNumber: json['luckyNumber'],
          luckyColor: json['luckyColor'],
        );
      }
    } catch (e) {
      debugPrint('API unreachable for horoscope, using fallback: $e');
    }
    return _fallback.getHoroscope(sign, timeframe);
  }
}
