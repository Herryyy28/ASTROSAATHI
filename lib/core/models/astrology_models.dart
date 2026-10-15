import 'package:flutter/foundation.dart';
import 'birth_details.dart';

@immutable
class PlanetPosition {
  final String name;
  final String sign;
  final int signIndex; // 1 = Aries, 12 = Pisces
  final double degree;
  final int house; // 1..12
  final bool isRetrograde;
  final String nakshatra;
  final int pada;
  final String dignity;

  const PlanetPosition({
    required this.name,
    required this.sign,
    required this.signIndex,
    required this.degree,
    required this.house,
    this.isRetrograde = false,
    this.nakshatra = '',
    this.pada = 1,
    this.dignity = 'Neutral',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'sign': sign,
        'signIndex': signIndex,
        'degree': degree,
        'house': house,
        'isRetrograde': isRetrograde,
        'nakshatra': nakshatra,
        'pada': pada,
        'dignity': dignity,
      };

  factory PlanetPosition.fromJson(Map<String, dynamic> json) {
    return PlanetPosition(
      name: json['name'] as String? ?? '',
      sign: json['sign'] as String? ?? 'Aries',
      signIndex: (json['signIndex'] as num?)?.toInt() ?? 1,
      degree: (json['degree'] as num?)?.toDouble() ?? 0.0,
      house: (json['house'] as num?)?.toInt() ?? 1,
      isRetrograde: json['isRetrograde'] as bool? ?? false,
      nakshatra: json['nakshatra'] as String? ?? '',
      pada: (json['pada'] as num?)?.toInt() ?? 1,
      dignity: json['dignity'] as String? ?? 'Neutral',
    );
  }
}

@immutable
class HouseData {
  final int houseNumber; // 1..12
  final String sign;
  final int signIndex;
  final double degree;
  final String lord;
  final List<String> planets;

  const HouseData({
    required this.houseNumber,
    required this.sign,
    required this.signIndex,
    this.degree = 0.0,
    required this.lord,
    this.planets = const [],
  });

  Map<String, dynamic> toJson() => {
        'houseNumber': houseNumber,
        'sign': sign,
        'signIndex': signIndex,
        'degree': degree,
        'lord': lord,
        'planets': planets,
      };

  factory HouseData.fromJson(Map<String, dynamic> json) {
    return HouseData(
      houseNumber: (json['houseNumber'] as num?)?.toInt() ?? 1,
      sign: json['sign'] as String? ?? '',
      signIndex: (json['signIndex'] as num?)?.toInt() ?? 1,
      degree: (json['degree'] as num?)?.toDouble() ?? 0.0,
      lord: json['lord'] as String? ?? '',
      planets: (json['planets'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

@immutable
class RasiData {
  final String name;
  final int number; // 1..12
  final String lord;
  final String element; // Fire, Earth, Air, Water

  const RasiData({
    required this.name,
    required this.number,
    required this.lord,
    required this.element,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'lord': lord,
        'element': element,
      };

  factory RasiData.fromJson(Map<String, dynamic> json) {
    return RasiData(
      name: json['name'] as String? ?? '',
      number: (json['number'] as num?)?.toInt() ?? 1,
      lord: json['lord'] as String? ?? '',
      element: json['element'] as String? ?? '',
    );
  }
}

@immutable
class NavamsaData {
  final String planet;
  final String navamsaSign;
  final int navamsaSignIndex;
  final int pada;

  const NavamsaData({
    required this.planet,
    required this.navamsaSign,
    required this.navamsaSignIndex,
    required this.pada,
  });

  Map<String, dynamic> toJson() => {
        'planet': planet,
        'navamsaSign': navamsaSign,
        'navamsaSignIndex': navamsaSignIndex,
        'pada': pada,
      };

  factory NavamsaData.fromJson(Map<String, dynamic> json) {
    return NavamsaData(
      planet: json['planet'] as String? ?? '',
      navamsaSign: json['navamsaSign'] as String? ?? '',
      navamsaSignIndex: (json['navamsaSignIndex'] as num?)?.toInt() ?? 1,
      pada: (json['pada'] as num?)?.toInt() ?? 1,
    );
  }
}

@immutable
class DashaData {
  final String planet;
  final String startDate;
  final String endDate;
  final int level; // 1 = Maha, 2 = Antar, 3 = Pratyantar
  final List<DashaData> subDashas;

  const DashaData({
    required this.planet,
    required this.startDate,
    required this.endDate,
    this.level = 1,
    this.subDashas = const [],
  });

  Map<String, dynamic> toJson() => {
        'planet': planet,
        'startDate': startDate,
        'endDate': endDate,
        'level': level,
        'subDashas': subDashas.map((s) => s.toJson()).toList(),
      };

  factory DashaData.fromJson(Map<String, dynamic> json) {
    return DashaData(
      planet: json['planet'] as String? ?? '',
      startDate: json['startDate'] as String? ?? '',
      endDate: json['endDate'] as String? ?? '',
      level: (json['level'] as num?)?.toInt() ?? 1,
      subDashas: (json['subDashas'] as List<dynamic>?)
              ?.map((e) => DashaData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

@immutable
class KundliData {
  final BirthDetails birthDetails;
  final String ascendantSign;
  final int ascendantSignIndex;
  final double ascendantDegree;
  final List<PlanetPosition> planets;
  final List<HouseData> houses;
  final List<NavamsaData> navamsa;
  final DashaData? currentDasha;
  final List<DashaData> dashas;
  final String chartType; // "D1", "D9", "Chalit"
  final DateTime generatedAt;

  const KundliData({
    required this.birthDetails,
    required this.ascendantSign,
    required this.ascendantSignIndex,
    required this.ascendantDegree,
    required this.planets,
    required this.houses,
    this.navamsa = const [],
    this.currentDasha,
    this.dashas = const [],
    this.chartType = 'D1',
    required this.generatedAt,
  });

  /// Formats the planets into a `Map<int, List<String>>` where key is house number (1..12).
  /// This integrates directly with [VedicChartPainter].
  Map<int, List<String>> toHousePlanetsMap() {
    final map = <int, List<String>>{
      for (int i = 1; i <= 12; i++) i: <String>[],
    };

    // First populate from houses if available
    for (final house in houses) {
      if (house.houseNumber >= 1 && house.houseNumber <= 12) {
        map[house.houseNumber] = List<String>.from(house.planets);
      }
    }

    // Populate or supplement from planets list
    for (final p in planets) {
      if (p.house >= 1 && p.house <= 12) {
        final shortName = _shortPlanetName(p.name);
        final displayName = p.isRetrograde ? '$shortName(R)' : shortName;
        if (!map[p.house]!.contains(displayName) && !map[p.house]!.contains(shortName)) {
          map[p.house]!.add(displayName);
        }
      }
    }

    return map;
  }

  int get lagnaSignIndex => ascendantSignIndex;

  PlanetPosition? getPlanet(String name) {
    try {
      return planets.firstWhere(
        (p) => p.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  HouseData? getHouse(int number) {
    try {
      return houses.firstWhere((h) => h.houseNumber == number);
    } catch (_) {
      return null;
    }
  }

  static String _shortPlanetName(String full) {
    switch (full.toLowerCase()) {
      case 'sun':
      case 'surya':
        return 'Su';
      case 'moon':
      case 'chandra':
        return 'Mo';
      case 'mars':
      case 'mangal':
        return 'Ma';
      case 'mercury':
      case 'budha':
        return 'Me';
      case 'jupiter':
      case 'guru':
        return 'Ju';
      case 'venus':
      case 'shukra':
        return 'Ve';
      case 'saturn':
      case 'shani':
        return 'Sa';
      case 'rahu':
        return 'Ra';
      case 'ketu':
        return 'Ke';
      case 'ascendant':
      case 'lagna':
        return 'Asc';
      default:
        return full.length > 2 ? full.substring(0, 2) : full;
    }
  }

  Map<String, dynamic> toJson() => {
        'birthDetails': birthDetails.toJson(),
        'ascendantSign': ascendantSign,
        'ascendantSignIndex': ascendantSignIndex,
        'ascendantDegree': ascendantDegree,
        'planets': planets.map((p) => p.toJson()).toList(),
        'houses': houses.map((h) => h.toJson()).toList(),
        'navamsa': navamsa.map((n) => n.toJson()).toList(),
        'currentDasha': currentDasha?.toJson(),
        'dashas': dashas.map((d) => d.toJson()).toList(),
        'chartType': chartType,
        'generatedAt': generatedAt.toIso8601String(),
      };

  factory KundliData.fromJson(Map<String, dynamic> json) {
    return KundliData(
      birthDetails: json['birthDetails'] != null
          ? BirthDetails.fromJson(json['birthDetails'] as Map<String, dynamic>)
          : BirthDetails.defaultDelhi,
      ascendantSign: json['ascendantSign'] as String? ?? 'Aries',
      ascendantSignIndex: (json['ascendantSignIndex'] as num?)?.toInt() ?? 1,
      ascendantDegree: (json['ascendantDegree'] as num?)?.toDouble() ?? 0.0,
      planets: (json['planets'] as List<dynamic>?)
              ?.map((e) => PlanetPosition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      houses: (json['houses'] as List<dynamic>?)
              ?.map((e) => HouseData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      navamsa: (json['navamsa'] as List<dynamic>?)
              ?.map((e) => NavamsaData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      currentDasha: json['currentDasha'] != null
          ? DashaData.fromJson(json['currentDasha'] as Map<String, dynamic>)
          : null,
      dashas: (json['dashas'] as List<dynamic>?)
              ?.map((e) => DashaData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      chartType: json['chartType'] as String? ?? 'D1',
      generatedAt: json['generatedAt'] != null
          ? DateTime.tryParse(json['generatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
