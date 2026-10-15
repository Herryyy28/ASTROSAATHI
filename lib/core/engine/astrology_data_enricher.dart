import 'models/astrology_validation.dart';

class AstrologyDataEnricher {
  static const _signs = <String>[
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces',
  ];

  static const _elements = <String, String>{
    'Aries': 'Fire',
    'Leo': 'Fire',
    'Sagittarius': 'Fire',
    'Taurus': 'Earth',
    'Virgo': 'Earth',
    'Capricorn': 'Earth',
    'Gemini': 'Air',
    'Libra': 'Air',
    'Aquarius': 'Air',
    'Cancer': 'Water',
    'Scorpio': 'Water',
    'Pisces': 'Water',
  };

  static const _modalities = <String, String>{
    'Aries': 'Cardinal',
    'Cancer': 'Cardinal',
    'Libra': 'Cardinal',
    'Capricorn': 'Cardinal',
    'Taurus': 'Fixed',
    'Leo': 'Fixed',
    'Scorpio': 'Fixed',
    'Aquarius': 'Fixed',
    'Gemini': 'Mutable',
    'Virgo': 'Mutable',
    'Sagittarius': 'Mutable',
    'Pisces': 'Mutable',
  };

  static Map<String, dynamic> enrichBirthChart(Map<String, dynamic> response) {
    final unwrapped = _unwrap(response);
    final result = Map<String, dynamic>.from(unwrapped);
    final planets = normalizePlanets(result['planets']);
    if (planets.isEmpty) return result;

    result['planets'] = planets;
    result.putIfAbsent('elements', () => _distribution(planets, _elements));
    result.putIfAbsent('modalities', () => _distribution(planets, _modalities));

    final aspects = calculateAspects(planets);
    if (aspects.isNotEmpty) {
      result.putIfAbsent('aspects', () => aspects);
    }
    final patterns = detectPatterns(planets, aspects);
    if (patterns.isNotEmpty) {
      result.putIfAbsent('patterns', () => patterns);
    }
    return result;
  }

  static Map<String, dynamic> _unwrap(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is Map) return Map<String, dynamic>.from(data);
    return response;
  }

  static List<Map<String, dynamic>> normalizePlanets(dynamic raw) {
    final values = raw is List
        ? raw
        : raw is Map
        ? raw.values.toList()
        : const <dynamic>[];
    return values.whereType<Map>().map((planet) {
      final item = Map<String, dynamic>.from(planet);
      final sign = (item['sign'] ?? item['rashi'])?.toString();
      final degree = _number(item['degree']);
      final longitude =
          _number(item['longitude']) ??
          (sign == null || degree == null ? null : longitudeFor(sign, degree));
      if (sign != null) {
        item['sign'] = sign;
        item['rashi'] ??= sign;
      }
      if (degree != null) item['degree'] = degree;
      if (longitude != null) item['longitude'] = longitude;
      item['retrograde'] ??= item['isRetrograde'];
      return item;
    }).toList();
  }

  static double? longitudeFor(String sign, double degree) {
    final index = _signs.indexWhere(
      (value) => value.toLowerCase() == sign.toLowerCase(),
    );
    if (index < 0 || degree < 0 || degree >= 30) return null;
    return index * 30 + degree;
  }

  static Map<String, double> _distribution(
    List<Map<String, dynamic>> planets,
    Map<String, String> lookup,
  ) {
    final labels = lookup.values.toSet();
    final counts = {for (final label in labels) label: 0};
    var total = 0;
    for (final planet in planets) {
      final name = planet['name']?.toString().toLowerCase();
      if (name == 'rahu' ||
          name == 'ketu' ||
          name == 'north node' ||
          name == 'south node') {
        continue;
      }
      final sign = (planet['sign'] ?? planet['rashi'])?.toString();
      if (sign == null) continue;
      final canonical = _signs.cast<String?>().firstWhere(
        (value) => value?.toLowerCase() == sign.toLowerCase(),
        orElse: () => null,
      );
      final label = canonical == null ? null : lookup[canonical];
      if (label == null) continue;
      counts[label] = (counts[label] ?? 0) + 1;
      total++;
    }
    if (total == 0) return {};
    return {
      for (final entry in counts.entries)
        entry.key: double.parse((entry.value * 100 / total).toStringAsFixed(1)),
    };
  }

  static List<Map<String, dynamic>> calculateAspects(
    List<Map<String, dynamic>> first, [
    List<Map<String, dynamic>>? second,
  ]) {
    final aspects = <Map<String, dynamic>>[];
    final crossChart = second != null;
    final right = second ?? first;
    for (var i = 0; i < first.length; i++) {
      final leftPlanet = first[i];
      final leftLongitude = _number(leftPlanet['longitude']);
      if (leftLongitude == null) continue;
      final start = crossChart ? 0 : i + 1;
      for (var j = start; j < right.length; j++) {
        final rightPlanet = right[j];
        final rightLongitude = _number(rightPlanet['longitude']);
        if (rightLongitude == null) continue;
        var separation = (leftLongitude - rightLongitude).abs();
        if (separation > 180) separation = 360 - separation;
        final classification = _classifyAspect(separation);
        if (classification == null) continue;
        aspects.add({
          'planet1': leftPlanet['name']?.toString() ?? '',
          'planet2': rightPlanet['name']?.toString() ?? '',
          'aspectName': classification.$1,
          'aspect': classification.$1,
          'angle': classification.$2,
          'orb': double.parse(classification.$3.toStringAsFixed(2)),
          'separation': double.parse(separation.toStringAsFixed(2)),
          if (crossChart) 'crossChart': true,
        });
      }
    }
    return aspects;
  }

  static (String, double, double)? _classifyAspect(double separation) {
    const targets = <(String, double, double)>[
      ('Conjunction', 0, 8),
      ('Sextile', 60, 6),
      ('Square', 90, 7),
      ('Trine', 120, 8),
      ('Quincunx', 150, 3),
      ('Opposition', 180, 8),
    ];
    for (final target in targets) {
      final orb = (separation - target.$2).abs();
      if (orb <= target.$3) return (target.$1, target.$2, orb);
    }
    return null;
  }

  static List<Map<String, dynamic>> detectPatterns(
    List<Map<String, dynamic>> planets,
    List<Map<String, dynamic>> aspects,
  ) {
    final patterns = <Map<String, dynamic>>[];
    final bySign = <String, List<String>>{};
    for (final planet in planets) {
      final sign = (planet['sign'] ?? planet['rashi'])?.toString();
      final name = planet['name']?.toString();
      if (sign != null && name != null) {
        bySign.putIfAbsent(sign, () => []).add(name);
      }
    }
    for (final entry in bySign.entries) {
      if (entry.value.length >= 3) {
        patterns.add({
          'name': 'Stellium',
          'modality': entry.key,
          'planets': entry.value,
          'interpretation':
              '${entry.value.length} calculated placements are concentrated in ${entry.key}.',
        });
      }
    }

    bool hasAspect(String a, String b, String type) => aspects.any(
      (aspect) =>
          aspect['aspectName'] == type &&
          ((aspect['planet1'] == a && aspect['planet2'] == b) ||
              (aspect['planet1'] == b && aspect['planet2'] == a)),
    );
    final names = planets
        .map((planet) => planet['name']?.toString())
        .whereType<String>()
        .toList();
    for (var i = 0; i < names.length; i++) {
      for (var j = i + 1; j < names.length; j++) {
        for (var k = j + 1; k < names.length; k++) {
          final a = names[i];
          final b = names[j];
          final c = names[k];
          if (hasAspect(a, b, 'Trine') &&
              hasAspect(a, c, 'Trine') &&
              hasAspect(b, c, 'Trine')) {
            patterns.add({
              'name': 'Grand Trine',
              'planets': [a, b, c],
              'interpretation':
                  'Three calculated trine aspects form a closed harmonic pattern.',
            });
          }
          final tSquare =
              (hasAspect(a, b, 'Opposition') &&
                  hasAspect(a, c, 'Square') &&
                  hasAspect(b, c, 'Square')) ||
              (hasAspect(a, c, 'Opposition') &&
                  hasAspect(a, b, 'Square') &&
                  hasAspect(c, b, 'Square')) ||
              (hasAspect(b, c, 'Opposition') &&
                  hasAspect(b, a, 'Square') &&
                  hasAspect(c, a, 'Square'));
          if (tSquare) {
            patterns.add({
              'name': 'T-Square',
              'planets': [a, b, c],
              'interpretation':
                  'A calculated opposition is connected by two square aspects.',
            });
          }
        }
      }
    }
    return patterns;
  }

  static double? _number(dynamic value) => value is num
      ? value.toDouble()
      : value == null
      ? null
      : double.tryParse(value.toString());
}

class NumerologyResult {
  const NumerologyResult({
    required this.lifePath,
    required this.destiny,
    required this.soulUrge,
    required this.birthday,
  });

  final int? lifePath;
  final int? destiny;
  final int? soulUrge;
  final int? birthday;
}

class NumerologyCalculator {
  static const _values = <String, int>{
    'a': 1,
    'i': 1,
    'j': 1,
    'q': 1,
    'y': 1,
    'b': 2,
    'k': 2,
    'r': 2,
    'c': 3,
    'g': 3,
    'l': 3,
    's': 3,
    'd': 4,
    'm': 4,
    't': 4,
    'e': 5,
    'h': 5,
    'n': 5,
    'x': 5,
    'u': 6,
    'v': 6,
    'w': 6,
    'o': 7,
    'z': 7,
    'f': 8,
    'p': 8,
  };

  static NumerologyResult calculate({
    required String name,
    required String dob,
  }) {
    final digits = dob.replaceAll(RegExp(r'[^0-9]'), '');
    DateTime? date;
    try {
      date = AstrologyValidator.parseDate(dob);
    } on AstrologyValidationException {
      date = null;
    }
    final cleanName = name.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    final allName = cleanName.isEmpty
        ? null
        : cleanName.split('').fold<int>(0, (sum, c) => sum + (_values[c] ?? 0));
    final vowels = cleanName
        .split('')
        .where((char) => 'aeiou'.contains(char))
        .fold<int>(0, (sum, c) => sum + (_values[c] ?? 0));
    return NumerologyResult(
      lifePath: digits.isEmpty
          ? null
          : _reduce(
              digits.split('').fold<int>(0, (sum, d) => sum + int.parse(d)),
            ),
      destiny: allName == null || allName == 0 ? null : _reduce(allName),
      soulUrge: vowels == 0 ? null : _reduce(vowels),
      birthday: date == null ? null : _reduce(date.day),
    );
  }

  static int _reduce(int value) {
    var result = value;
    while (result > 9 && result != 11 && result != 22 && result != 33) {
      result = result
          .toString()
          .split('')
          .fold<int>(0, (sum, digit) => sum + int.parse(digit));
    }
    return result;
  }
}
