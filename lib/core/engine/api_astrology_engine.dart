import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:http/http.dart' as http;
import 'astrology_engine.dart';
import 'models/game_plan_data.dart';
import 'models/panchang_data.dart';
import 'models/muhurat_data.dart';
import 'models/ai_data.dart';
import 'models/horoscope_data.dart';

/// Calls the real backend API.
class ApiAstrologyEngine implements AstrologyEngine {
  final String baseUrl = kIsWeb
      ? 'http://localhost:3000/api/v1'
      : 'http://10.0.2.2:3000/api/v1';

  Map<String, String> _parseLocation(String location) {
    String lat = '28.6139';
    String lon = '77.2090';
    String tz = '5.5';
    
    if (location.contains(',')) {
      final parts = location.split(',');
      if (parts.length >= 2) {
        lat = parts[0];
        lon = parts[1];
      }
      if (parts.length >= 3) {
        tz = parts[2];
      }
    }
    return {'lat': lat, 'lon': lon, 'tz': tz};
  }

  @override
  Future<GamePlanData> calculateDailyGamePlan(String date, String location, {String languageCode = 'en'}) async {
    final locData = _parseLocation(location);
    final response = await http.get(
      Uri.parse('$baseUrl/astrology/game-plan?date=$date&lat=${locData['lat']}&lon=${locData['lon']}&tz=${locData['tz']}&languageCode=$languageCode'),
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
    throw Exception('Failed to load daily game plan: ${response.statusCode}');
  }

  @override
  Future<PanchangData> calculatePanchang(String date, String location, {String languageCode = 'en'}) async {
    final locData = _parseLocation(location);
    final response = await http.get(
      Uri.parse('$baseUrl/astrology/panchang?date=$date&lat=${locData['lat']}&lon=${locData['lon']}&tz=${locData['tz']}&languageCode=$languageCode'),
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
    throw Exception('Failed to load Panchang: ${response.statusCode}');
  }

  @override
  Future<MuhuratResult> calculateMuhurat(MuhuratInput input, {String languageCode = 'en'}) async {
    final locData = _parseLocation(input.location);
    final response = await http.get(
      Uri.parse('$baseUrl/astrology/muhurat?category=${input.category}&date=${input.date}&lat=${locData['lat']}&lon=${locData['lon']}&tz=${locData['tz']}&languageCode=$languageCode'),
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
    throw Exception('Failed to load Muhurat: ${response.statusCode}');
  }

  @override
  Future<AstroBabaResponse> askAstroBaba(
    String question,
    String date,
    String location, {
    String languageCode = 'en',
  }) async {
    final locData = _parseLocation(location);
    final response = await http.post(
      Uri.parse('$baseUrl/ai/ask-astro-baba'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'question': question,
        'date': date,
        'lat': double.tryParse(locData['lat']!) ?? 28.6139,
        'lon': double.tryParse(locData['lon']!) ?? 77.2090,
        'tz': locData['tz'],
        'languageCode': languageCode,
      }),
    ).timeout(const Duration(seconds: 15));
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final json = jsonDecode(response.body)['data'];
      return AstroBabaResponse(
        answer: json['answer'],
        confidence: json['confidence'],
        actions: List<String>.from(json['actions'] ?? []),
        warnings: List<String>.from(json['warnings'] ?? []),
      );
    }
    throw Exception('Failed to communicate with Astro Baba: ${response.statusCode}');
  }

  @override
  Future<HoroscopeData> getHoroscope(String sign, String timeframe, {String languageCode = 'en'}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/astrology/horoscope?sign=$sign&timeframe=$timeframe&languageCode=$languageCode'),
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
    throw Exception('Failed to load Horoscope: ${response.statusCode}');
  }

  @override
  Future<Map<String, dynamic>> getBirthChart(String date, String time, String location, {String languageCode = 'en', String? profileId}) async {
    final locData = _parseLocation(location);
    final pId = profileId ?? 'default';
    final response = await http.get(
      Uri.parse('$baseUrl/astrology/birth-chart?profileId=$pId&date=$date&time=$time&lat=${locData['lat']}&lon=${locData['lon']}&tz=${locData['tz']}&languageCode=$languageCode'),
    ).timeout(const Duration(seconds: 10));
    
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      // Ensure we return the root object which has lagna, rashi, planets instead of just data. 
      // NestJS might return it directly, or inside 'data'. If it's the canonical object, it should be the whole response.
      return jsonResponse;
    }
    throw Exception('Failed to load Birth Chart: ${response.statusCode}');
  }
}
