import 'package:flutter/foundation.dart';

@immutable
class Tithi {
  final String name;
  final int number; // 1..30
  final String paksha; // "Shukla" or "Krishna"
  final String endTime;

  const Tithi({
    required this.name,
    required this.number,
    required this.paksha,
    required this.endTime,
  });

  bool get isShukla => paksha.toLowerCase() == 'shukla';

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'paksha': paksha,
        'endTime': endTime,
      };

  factory Tithi.fromJson(Map<String, dynamic> json) {
    return Tithi(
      name: json['name'] as String? ?? 'Pratipada',
      number: (json['number'] as num?)?.toInt() ?? 1,
      paksha: json['paksha'] as String? ?? 'Shukla',
      endTime: json['endTime'] as String? ?? '',
    );
  }
}

@immutable
class Nakshatra {
  final String name;
  final int number; // 1..27
  final String lord;
  final String endTime;

  const Nakshatra({
    required this.name,
    required this.number,
    required this.lord,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'lord': lord,
        'endTime': endTime,
      };

  factory Nakshatra.fromJson(Map<String, dynamic> json) {
    return Nakshatra(
      name: json['name'] as String? ?? 'Ashwini',
      number: (json['number'] as num?)?.toInt() ?? 1,
      lord: json['lord'] as String? ?? 'Ketu',
      endTime: json['endTime'] as String? ?? '',
    );
  }
}

@immutable
class Yoga {
  final String name;
  final int number; // 1..27
  final String endTime;

  const Yoga({
    required this.name,
    required this.number,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'endTime': endTime,
      };

  factory Yoga.fromJson(Map<String, dynamic> json) {
    return Yoga(
      name: json['name'] as String? ?? 'Vishkambha',
      number: (json['number'] as num?)?.toInt() ?? 1,
      endTime: json['endTime'] as String? ?? '',
    );
  }
}

@immutable
class Karana {
  final String name;
  final int number; // 1..60
  final String endTime;

  const Karana({
    required this.name,
    required this.number,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'endTime': endTime,
      };

  factory Karana.fromJson(Map<String, dynamic> json) {
    return Karana(
      name: json['name'] as String? ?? 'Bava',
      number: (json['number'] as num?)?.toInt() ?? 1,
      endTime: json['endTime'] as String? ?? '',
    );
  }
}

@immutable
class SunriseSunset {
  final String sunrise;
  final String sunset;
  final String moonrise;
  final String moonset;

  const SunriseSunset({
    required this.sunrise,
    required this.sunset,
    this.moonrise = '',
    this.moonset = '',
  });

  Map<String, dynamic> toJson() => {
        'sunrise': sunrise,
        'sunset': sunset,
        'moonrise': moonrise,
        'moonset': moonset,
      };

  factory SunriseSunset.fromJson(Map<String, dynamic> json) {
    return SunriseSunset(
      sunrise: json['sunrise'] as String? ?? '06:00 AM',
      sunset: json['sunset'] as String? ?? '06:30 PM',
      moonrise: json['moonrise'] as String? ?? '',
      moonset: json['moonset'] as String? ?? '',
    );
  }
}

@immutable
class TimeRange {
  final String start;
  final String end;

  const TimeRange({required this.start, required this.end});

  Map<String, dynamic> toJson() => {'start': start, 'end': end};

  factory TimeRange.fromJson(Map<String, dynamic> json) {
    return TimeRange(
      start: json['start'] as String? ?? '',
      end: json['end'] as String? ?? '',
    );
  }
}

@immutable
class PanchangData {
  final String date; // YYYY-MM-DD
  final String vara; // Day of the week
  final Tithi tithi;
  final Nakshatra nakshatra;
  final Yoga yoga;
  final Karana karana;
  final SunriseSunset sunriseSunset;
  final TimeRange? rahuKaal;
  final TimeRange? yamaghanta;
  final TimeRange? gulika;
  final TimeRange? abhijitMuhurat;
  final String rasiSun;
  final String rasiMoon;
  final List<String> specialYogas;

  const PanchangData({
    required this.date,
    required this.vara,
    required this.tithi,
    required this.nakshatra,
    required this.yoga,
    required this.karana,
    required this.sunriseSunset,
    this.rahuKaal,
    this.yamaghanta,
    this.gulika,
    this.abhijitMuhurat,
    this.rasiSun = '',
    this.rasiMoon = '',
    this.specialYogas = const [],
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'vara': vara,
        'tithi': tithi.toJson(),
        'nakshatra': nakshatra.toJson(),
        'yoga': yoga.toJson(),
        'karana': karana.toJson(),
        'sunriseSunset': sunriseSunset.toJson(),
        'rahuKaal': rahuKaal?.toJson(),
        'yamaghanta': yamaghanta?.toJson(),
        'gulika': gulika?.toJson(),
        'abhijitMuhurat': abhijitMuhurat?.toJson(),
        'rasiSun': rasiSun,
        'rasiMoon': rasiMoon,
        'specialYogas': specialYogas,
      };

  factory PanchangData.fromJson(Map<String, dynamic> json) {
    return PanchangData(
      date: json['date'] as String? ?? '',
      vara: json['vara'] as String? ?? 'Somavara',
      tithi: json['tithi'] != null
          ? Tithi.fromJson(json['tithi'] as Map<String, dynamic>)
          : const Tithi(name: 'Pratipada', number: 1, paksha: 'Shukla', endTime: '18:30'),
      nakshatra: json['nakshatra'] != null
          ? Nakshatra.fromJson(json['nakshatra'] as Map<String, dynamic>)
          : const Nakshatra(name: 'Rohini', number: 4, lord: 'Chandra', endTime: '14:20'),
      yoga: json['yoga'] != null
          ? Yoga.fromJson(json['yoga'] as Map<String, dynamic>)
          : const Yoga(name: 'Siddhi', number: 16, endTime: '11:15'),
      karana: json['karana'] != null
          ? Karana.fromJson(json['karana'] as Map<String, dynamic>)
          : const Karana(name: 'Bava', number: 1, endTime: '08:45'),
      sunriseSunset: json['sunriseSunset'] != null
          ? SunriseSunset.fromJson(json['sunriseSunset'] as Map<String, dynamic>)
          : const SunriseSunset(sunrise: '06:12 AM', sunset: '06:45 PM'),
      rahuKaal: json['rahuKaal'] != null
          ? TimeRange.fromJson(json['rahuKaal'] as Map<String, dynamic>)
          : const TimeRange(start: '07:30 AM', end: '09:00 AM'),
      yamaghanta: json['yamaghanta'] != null
          ? TimeRange.fromJson(json['yamaghanta'] as Map<String, dynamic>)
          : null,
      gulika: json['gulika'] != null
          ? TimeRange.fromJson(json['gulika'] as Map<String, dynamic>)
          : null,
      abhijitMuhurat: json['abhijitMuhurat'] != null
          ? TimeRange.fromJson(json['abhijitMuhurat'] as Map<String, dynamic>)
          : const TimeRange(start: '11:45 AM', end: '12:35 PM'),
      rasiSun: json['rasiSun'] as String? ?? 'Simha',
      rasiMoon: json['rasiMoon'] as String? ?? 'Vrishabha',
      specialYogas: (json['specialYogas'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const ['Sarvartha Siddhi Yoga'],
    );
  }
}
