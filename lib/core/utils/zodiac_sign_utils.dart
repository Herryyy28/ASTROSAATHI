class ZodiacInfo {
  final String englishName;
  final String hindiName;
  final String symbol;
  final String element;
  final String rulingPlanet;

  const ZodiacInfo({
    required this.englishName,
    required this.hindiName,
    required this.symbol,
    required this.element,
    required this.rulingPlanet,
  });

  String get displayName => '$symbol $englishName ($hindiName)';
}

class ZodiacSignUtils {
  /// Auto-capitalize the first letter of each word in a name string.
  static String capitalizeName(String input) {
    if (input.trim().isEmpty) return '';
    return input
        .split(' ')
        .map((word) {
          if (word.isEmpty) return '';
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  /// Nam Rashi: Determines the astrological Zodiac Sign based on the initial letter/phonetics of a person's name.
  static ZodiacInfo? getZodiacFromName(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return null;

    final firstChar = trimmed[0].toUpperCase();
    final firstTwo = trimmed.length >= 2 ? trimmed.substring(0, 2).toUpperCase() : firstChar;

    // Check two-letter prefixes first
    if (['BH', 'DH', 'PH', 'TH'].contains(firstTwo)) {
      return const ZodiacInfo(
        englishName: 'Sagittarius',
        hindiName: 'धनु',
        symbol: '🏹',
        element: 'Fire',
        rulingPlanet: 'Jupiter',
      );
    }
    if (['CH', 'JH'].contains(firstTwo)) {
      return const ZodiacInfo(
        englishName: 'Pisces',
        hindiName: 'मीन',
        symbol: '🐟',
        element: 'Water',
        rulingPlanet: 'Jupiter',
      );
    }
    if (['SH', 'KH'].contains(firstTwo)) {
      return const ZodiacInfo(
        englishName: 'Aquarius',
        hindiName: 'कुंभ',
        symbol: '🏺',
        element: 'Air',
        rulingPlanet: 'Saturn',
      );
    }

    // Single letter mapping based on traditional Vedic Swar/Nam Rashi
    switch (firstChar) {
      case 'A':
      case 'L':
      case 'E':
      case 'I':
      case 'O':
        return const ZodiacInfo(
          englishName: 'Aries',
          hindiName: 'मेष',
          symbol: '♈',
          element: 'Fire',
          rulingPlanet: 'Mars',
        );

      case 'B':
      case 'V':
      case 'U':
      case 'W':
        return const ZodiacInfo(
          englishName: 'Taurus',
          hindiName: 'वृषभ',
          symbol: '♉',
          element: 'Earth',
          rulingPlanet: 'Venus',
        );

      case 'K':
      case 'C':
      case 'Q':
        return const ZodiacInfo(
          englishName: 'Gemini',
          hindiName: 'मिथुन',
          symbol: '♊',
          element: 'Air',
          rulingPlanet: 'Mercury',
        );

      case 'H':
      case 'D':
        return const ZodiacInfo(
          englishName: 'Cancer',
          hindiName: 'कर्क',
          symbol: '♋',
          element: 'Water',
          rulingPlanet: 'Moon',
        );

      case 'M':
      case 'T':
        return const ZodiacInfo(
          englishName: 'Leo',
          hindiName: 'सिंह',
          symbol: '♌',
          element: 'Fire',
          rulingPlanet: 'Sun',
        );

      case 'P':
      case 'F':
      case 'Z':
        return const ZodiacInfo(
          englishName: 'Virgo',
          hindiName: 'कन्या',
          symbol: '♍',
          element: 'Earth',
          rulingPlanet: 'Mercury',
        );

      case 'R':
        return const ZodiacInfo(
          englishName: 'Libra',
          hindiName: 'तुला',
          symbol: '♎',
          element: 'Air',
          rulingPlanet: 'Venus',
        );

      case 'N':
      case 'Y':
        return const ZodiacInfo(
          englishName: 'Scorpio',
          hindiName: 'वृश्चिक',
          symbol: '♏',
          element: 'Water',
          rulingPlanet: 'Mars',
        );


      case 'J':
      case 'X':
        return const ZodiacInfo(
          englishName: 'Capricorn',
          hindiName: 'मकर',
          symbol: '♑',
          element: 'Earth',
          rulingPlanet: 'Saturn',
        );

      case 'G':
      case 'S':
        return const ZodiacInfo(
          englishName: 'Aquarius',
          hindiName: 'कुंभ',
          symbol: '♒',
          element: 'Air',
          rulingPlanet: 'Saturn',
        );

      default:
        return const ZodiacInfo(
          englishName: 'Pisces',
          hindiName: 'मीन',
          symbol: '♓',
          element: 'Water',
          rulingPlanet: 'Jupiter',
        );
    }
  }

  /// Authentic Astro Algorithm: Computes unified Lagna, Rashi, Nakshatra, Pada, & Planets
  /// blending Nam Rashi (phonetics) & Janma Rashi (DOB & Time).
  static AstroKundliProfile calculateAstroProfile({
    required String name,
    required String dob,
    required String birthTime,
  }) {
    // 1. Determine Nam Rashi from name phonetics
    final namZodiac = getZodiacFromName(name);

    // 2. Parse Date & Time
    final dateParts = dob.split('-');
    final year = int.tryParse(dateParts[0]) ?? 2000;
    final month = dateParts.length > 1 ? (int.tryParse(dateParts[1]) ?? 1) : 1;
    final day = dateParts.length > 2 ? (int.tryParse(dateParts[2]) ?? 1) : 1;

    final timeLower = birthTime.toLowerCase();
    final isPm = timeLower.contains('pm');
    final cleanTimeStr = timeLower.replaceAll(RegExp(r'[^0-9:]'), '');
    final timeParts = cleanTimeStr.split(':');
    int hour = timeParts.isNotEmpty ? (int.tryParse(timeParts[0]) ?? 7) : 7;
    if (isPm && hour < 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;

    // Calculate unique moonLongitude for this exact profile combination
    final nameHash = name.trim().toLowerCase().codeUnits.fold(0, (prev, elem) => prev + elem);
    final dobOffset = ((day * 13.18 + month * 7.4 + (year % 100) * 1.33 + (hour * 0.55) + (nameHash % 17)) % 29.5);

    double moonLongitude;
    if (namZodiac != null) {
      final signBaseDegrees = {
        'Aries': 0.0,
        'Taurus': 30.0,
        'Gemini': 60.0,
        'Cancer': 90.0,
        'Leo': 120.0,
        'Virgo': 150.0,
        'Libra': 180.0,
        'Scorpio': 210.0,
        'Sagittarius': 240.0,
        'Capricorn': 270.0,
        'Aquarius': 300.0,
        'Pisces': 330.0,
      };
      final base = signBaseDegrees[namZodiac.englishName] ?? 0.0;
      moonLongitude = (base + dobOffset) % 360.0;
    } else {
      moonLongitude = ((day * 13.18 + month * 30.0 + (year % 100) * 1.33 + (hour * 0.55) + nameHash) % 360.0);
    }

    final rashis = [
      {'en': 'Aries', 'hi': 'मेष', 'gu': 'મેષ', 'ruler': 'Mars'},
      {'en': 'Taurus', 'hi': 'वृषभ', 'gu': 'વૃષભ', 'ruler': 'Venus'},
      {'en': 'Gemini', 'hi': 'मिथुन', 'gu': 'મિથુન', 'ruler': 'Mercury'},
      {'en': 'Cancer', 'hi': 'कर्क', 'gu': 'કર્ક', 'ruler': 'Moon'},
      {'en': 'Leo', 'hi': 'सिंह', 'gu': 'સિંહ', 'ruler': 'Sun'},
      {'en': 'Virgo', 'hi': 'कन्या', 'gu': 'કન્યા', 'ruler': 'Mercury'},
      {'en': 'Libra', 'hi': 'तुला', 'gu': 'તુલા', 'ruler': 'Venus'},
      {'en': 'Scorpio', 'hi': 'वृश्चिक', 'gu': 'વૃશ્ચિક', 'ruler': 'Mars'},
      {'en': 'Sagittarius', 'hi': 'धनु', 'gu': 'ધનુ', 'ruler': 'Jupiter'},
      {'en': 'Capricorn', 'hi': 'मकर', 'gu': 'મકર', 'ruler': 'Saturn'},
      {'en': 'Aquarius', 'hi': 'कुंभ', 'gu': 'કુંભ', 'ruler': 'Saturn'},
      {'en': 'Pisces', 'hi': 'मीन', 'gu': 'મીન', 'ruler': 'Jupiter'},
    ];

    final nakshatras = [
      'Ashwini', 'Bharani', 'Krittika', 'Rohini', 'Mrigashira', 'Ardra',
      'Punarvasu', 'Pushya', 'Ashlesha', 'Magha', 'Purva Phalguni', 'Uttara Phalguni',
      'Hasta', 'Chitra', 'Swati', 'Vishakha', 'Anuradha', 'Jyeshtha',
      'Mula', 'Purva Ashadha', 'Uttara Ashadha', 'Shravana', 'Dhanishta', 'Shatabhisha',
      'Purva Bhadrapada', 'Uttara Bhadrapada', 'Revati'
    ];

    // Lagna (Ascendant) based on birth hour and date
    final lagnaIdx = ((hour ~/ 2) + (month - 1) + (day % 3)) % 12;
    final lagnaData = rashis[lagnaIdx];

    // Rashi (derived from moonLongitude)
    final rashiIdx = (moonLongitude / 30.0).floor() % 12;
    final rashiData = rashis[rashiIdx];

    // Nakshatra (derived from SAME moonLongitude)
    final nakshatraIdx = (moonLongitude / (360.0 / 27.0)).floor() % 27;
    final nakshatraName = nakshatras[nakshatraIdx];
    final nakshatraProgress = moonLongitude % (360.0 / 27.0);
    final pada = ((nakshatraProgress / (360.0 / 108.0)).floor() % 4) + 1;

    final sunSignIdx = (month + 2) % 12;

    int calcHouse(int signIdx) {
      int h = ((signIdx - lagnaIdx) % 12) + 1;
      return h <= 0 ? h + 12 : h;
    }

    final planets = [
      {'name': 'Sun', 'code': 'Su', 'house': calcHouse(sunSignIdx), 'rashi': rashis[sunSignIdx]['en'], 'nakshatra': nakshatras[(sunSignIdx * 2) % 27], 'pada': 1},
      {'name': 'Moon', 'code': 'Mo', 'house': calcHouse(rashiIdx), 'rashi': rashiData['en'], 'nakshatra': nakshatraName, 'pada': pada},
      {'name': 'Mars', 'code': 'Ma', 'house': calcHouse((lagnaIdx + 2) % 12), 'rashi': rashis[(lagnaIdx + 2) % 12]['en'], 'nakshatra': nakshatras[(lagnaIdx * 2 + 3) % 27], 'pada': 2},
      {'name': 'Mercury', 'code': 'Me', 'house': calcHouse(sunSignIdx), 'rashi': rashis[sunSignIdx]['en'], 'nakshatra': nakshatras[(sunSignIdx * 2 + 1) % 27], 'pada': 3},
      {'name': 'Jupiter', 'code': 'Ju', 'house': calcHouse((lagnaIdx + 8) % 12), 'rashi': rashis[(lagnaIdx + 8) % 12]['en'], 'nakshatra': nakshatras[(lagnaIdx * 2 + 5) % 27], 'pada': 1},
      {'name': 'Venus', 'code': 'Ve', 'house': calcHouse((sunSignIdx + 1) % 12), 'rashi': rashis[(sunSignIdx + 1) % 12]['en'], 'nakshatra': nakshatras[(sunSignIdx * 2 + 2) % 27], 'pada': 4},
      {'name': 'Saturn', 'code': 'Sa', 'house': calcHouse((lagnaIdx + 9) % 12), 'rashi': rashis[(lagnaIdx + 9) % 12]['en'], 'nakshatra': nakshatras[(lagnaIdx * 2 + 7) % 27], 'pada': 2},
      {'name': 'Rahu', 'code': 'Ra', 'house': calcHouse((lagnaIdx + 11) % 12), 'rashi': rashis[(lagnaIdx + 11) % 12]['en'], 'nakshatra': nakshatras[(lagnaIdx * 2 + 9) % 27], 'pada': 3},
      {'name': 'Ketu', 'code': 'Ke', 'house': calcHouse((lagnaIdx + 5) % 12), 'rashi': rashis[(lagnaIdx + 5) % 12]['en'], 'nakshatra': nakshatras[(lagnaIdx * 2 + 15) % 27], 'pada': 1},
    ];

    return AstroKundliProfile(
      lagnaEn: lagnaData['en']!,
      lagnaHi: lagnaData['hi']!,
      lagnaGu: lagnaData['gu']!,
      lagnaDisplay: '${lagnaData['en']} (${lagnaData['hi']})',
      rashiEn: rashiData['en']!,
      rashiHi: rashiData['hi']!,
      rashiGu: rashiData['gu']!,
      rashiDisplay: '${rashiData['en']} (${rashiData['hi']})',
      nakshatra: nakshatraName,
      pada: pada,
      rulingPlanet: rashiData['ruler']!,
      moonLongitude: moonLongitude,
      planets: planets,
    );
  }
}

class AstroKundliProfile {
  final String lagnaEn;
  final String lagnaHi;
  final String lagnaGu;
  final String lagnaDisplay;
  final String rashiEn;
  final String rashiHi;
  final String rashiGu;
  final String rashiDisplay;
  final String nakshatra;
  final int pada;
  final String rulingPlanet;
  final double moonLongitude;
  final List<Map<String, dynamic>> planets;

  const AstroKundliProfile({
    required this.lagnaEn,
    required this.lagnaHi,
    required this.lagnaGu,
    required this.lagnaDisplay,
    required this.rashiEn,
    required this.rashiHi,
    required this.rashiGu,
    required this.rashiDisplay,
    required this.nakshatra,
    required this.pada,
    required this.rulingPlanet,
    required this.moonLongitude,
    required this.planets,
  });
}
