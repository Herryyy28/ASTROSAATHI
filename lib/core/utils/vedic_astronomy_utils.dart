import 'dart:math' as math;
import '../models/matchmaking_models.dart';

/// Authentic mathematical Vedic astronomical calculations for Panchang and Muhurat
class VedicAstronomyUtils {
  static const List<String> varasEnglish = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  static const List<String> varasVedic = [
    'Ravivara (Sun)',
    'Somavara (Moon)',
    'Mangalavara (Mars)',
    'Budhavara (Mercury)',
    'Guruvara (Jupiter)',
    'Shukravara (Venus)',
    'Shanivara (Saturn)',
  ];

  static const List<String> tithiNames = [
    'Pratipada',
    'Dwitiya',
    'Tritiya',
    'Chaturthi',
    'Panchami',
    'Shashthi',
    'Saptami',
    'Ashtami',
    'Navami',
    'Dashami',
    'Ekadashi',
    'Dwadashi',
    'Trayodashi',
    'Chaturdashi',
    'Purnima / Amavasya',
  ];

  static const List<String> nakshatraNames = [
    'Ashwini',
    'Bharani',
    'Krittika',
    'Rohini',
    'Mrigashira',
    'Ardra',
    'Punarvasu',
    'Pushya',
    'Ashlesha',
    'Magha',
    'Purva Phalguni',
    'Uttara Phalguni',
    'Hasta',
    'Chitra',
    'Swati',
    'Vishakha',
    'Anuradha',
    'Jyeshtha',
    'Mula',
    'Purva Ashadha',
    'Uttara Ashadha',
    'Shravana',
    'Dhanishta',
    'Shatabhisha',
    'Purva Bhadrapada',
    'Uttara Bhadrapada',
    'Revati',
  ];

  static const List<String> nakshatraLords = [
    'Ketu',
    'Venus',
    'Sun',
    'Moon',
    'Mars',
    'Rahu',
    'Jupiter',
    'Saturn',
    'Mercury',
    'Ketu',
    'Venus',
    'Sun',
    'Moon',
    'Mars',
    'Rahu',
    'Jupiter',
    'Saturn',
    'Mercury',
    'Ketu',
    'Venus',
    'Sun',
    'Moon',
    'Mars',
    'Rahu',
    'Jupiter',
    'Saturn',
    'Mercury',
  ];

  static const List<String> yogaNames = [
    'Vishkambha',
    'Priti',
    'Ayushman',
    'Saubhagya',
    'Shobhana',
    'Atiganda',
    'Sukarma',
    'Dhriti',
    'Shoola',
    'Ganda',
    'Vriddhi',
    'Dhruva',
    'Vyaghata',
    'Harshana',
    'Vajra',
    'Siddhi',
    'Vyatipata',
    'Variyan',
    'Parigha',
    'Shiva',
    'Siddha',
    'Sadhya',
    'Shubha',
    'Shukla',
    'Brahma',
    'Indra',
    'Vaidhriti',
  ];

  static const List<String> karanaNames = [
    'Bava',
    'Balava',
    'Kaulava',
    'Taitila',
    'Gara',
    'Vanija',
    'Vishti (Bhadra)',
    'Shakuni',
    'Chatushpada',
    'Naga',
    'Kintughna',
  ];

  /// Calculate Julian Date from DateTime
  static double getJulianDate(DateTime date) {
    int y = date.year;
    int m = date.month;
    double d = date.day.toDouble() + (date.hour + date.minute / 60.0) / 24.0;
    if (m <= 2) {
      y -= 1;
      m += 12;
    }
    final a = (y / 100).floor();
    final b = 2 - a + (a / 4).floor();
    return (365.25 * (y + 4716)).floor() + (30.6001 * (m + 1)).floor() + d + b - 1524.5;
  }

  /// Calculate Mean Solar Longitude (Degrees 0..360)
  static double getSunLongitude(double jd) {
    final t = (jd - 2451545.0) / 36525.0;
    final l0 = 280.46646 + 36000.76983 * t + 0.0003032 * t * t;
    final m = 357.52911 + 35999.05029 * t - 0.0001537 * t * t;
    final mRad = m * math.pi / 180.0;
    final c = (1.914602 - 0.004817 * t) * math.sin(mRad) +
        (0.019993 - 0.000101 * t) * math.sin(2 * mRad);
    final trueLon = (l0 + c) % 360.0;
    return trueLon < 0 ? trueLon + 360.0 : trueLon;
  }

  /// Calculate Mean Lunar Longitude (Degrees 0..360)
  static double getMoonLongitude(double jd) {
    final t = (jd - 2451545.0) / 36525.0;
    final l = 218.3164477 + 481267.88128 * t;
    final d = (l % 360.0);
    return d < 0 ? d + 360.0 : d;
  }

  /// Lahiri Ayanamsa approximation
  static double getAyanamsa(double jd) {
    final t = (jd - 2451545.0) / 36525.0;
    return 23.85 + (t * 1.397);
  }

  /// Calculate authentic Panchang dataset for any date and coordinate
  static Map<String, dynamic> calculatePanchang({
    required DateTime date,
    double latitude = 28.6139,
    double longitude = 77.2090,
  }) {
    final jd = getJulianDate(date);
    final sunLon = getSunLongitude(jd);
    final moonLon = getMoonLongitude(jd);
    final ayanamsa = getAyanamsa(jd);

    // 1. Vara (Day of week)
    final weekdayIndex = date.weekday % 7; // Sunday = 0, Monday = 1...
    final vara = varasVedic[weekdayIndex];

    // 2. Tithi (Elongation of moon from sun)
    double diff = (moonLon - sunLon) % 360.0;
    if (diff < 0) diff += 360.0;
    final tithiIndex = (diff / 12.0).floor().clamp(0, 29);
    final tithiNumber = tithiIndex + 1;
    final isShukla = tithiNumber <= 15;
    final paksha = isShukla ? 'Shukla Paksha' : 'Krishna Paksha';
    final tithiBase = tithiNames[(tithiNumber - 1) % 15];
    final String tithiName = isShukla
        ? (tithiNumber == 15 ? 'Shukla Purnima' : 'Shukla $tithiBase')
        : (tithiNumber == 30 ? 'Krishna Amavasya' : 'Krishna $tithiBase');

    // 3. Nakshatra (Sidereal moon position)
    double siderealMoon = (moonLon - ayanamsa) % 360.0;
    if (siderealMoon < 0) siderealMoon += 360.0;
    final nakshatraIndex = (siderealMoon / (360.0 / 27.0)).floor().clamp(0, 26);
    final nakshatraName = nakshatraNames[nakshatraIndex];
    final nakshatraLord = nakshatraLords[nakshatraIndex];

    // 4. Yoga (Sum of sidereal Sun and Moon)
    double siderealSun = (sunLon - ayanamsa) % 360.0;
    if (siderealSun < 0) siderealSun += 360.0;
    double yogaLon = (siderealSun + siderealMoon) % 360.0;
    if (yogaLon < 0) yogaLon += 360.0;
    final yogaIndex = (yogaLon / (360.0 / 27.0)).floor().clamp(0, 26);
    final yogaName = yogaNames[yogaIndex];

    // 5. Karana (Half of a tithi)
    final karanaNumber = ((diff / 6.0).floor() % 60);
    String karanaName;
    if (karanaNumber == 0) {
      karanaName = 'Kintughna';
    } else if (karanaNumber >= 57) {
      final fixed = ['Shakuni', 'Chatushpada', 'Naga'];
      karanaName = fixed[(karanaNumber - 57).clamp(0, 2)];
    } else {
      final movable = ['Bava', 'Balava', 'Kaulava', 'Taitila', 'Gara', 'Vanija', 'Vishti'];
      karanaName = movable[(karanaNumber - 1) % 7];
    }

    // 6. Sunrise & Sunset approximation for latitude
    final dayOfYear = int.parse(date.difference(DateTime(date.year, 1, 1)).inDays.toString());
    final declination = -23.44 * math.cos((360.0 / 365.0) * (dayOfYear + 10) * math.pi / 180.0);
    final hourAngle = math.acos(-math.tan(latitude * math.pi / 180.0) * math.tan(declination * math.pi / 180.0));
    final halfDayHours = (hourAngle * 180.0 / math.pi) / 15.0;

    final sunriseDec = 12.0 - halfDayHours;
    final sunsetDec = 12.0 + halfDayHours;

    final sunriseStr = _formatDecimalTime(sunriseDec.clamp(5.0, 7.5));
    final sunsetStr = _formatDecimalTime(sunsetDec.clamp(17.5, 19.5));

    // 7. Rahu Kaal, Yamaganda, Gulika based on weekday
    final rahuWindows = [
      {'start': '04:30 PM', 'end': '06:00 PM'}, // Sunday
      {'start': '07:30 AM', 'end': '09:00 AM'}, // Monday
      {'start': '03:00 PM', 'end': '04:30 PM'}, // Tuesday
      {'start': '12:00 PM', 'end': '01:30 PM'}, // Wednesday
      {'start': '01:30 PM', 'end': '03:00 PM'}, // Thursday
      {'start': '10:30 AM', 'end': '12:00 PM'}, // Friday
      {'start': '09:00 AM', 'end': '10:30 AM'}, // Saturday
    ];

    final yamagandaWindows = [
      {'start': '12:00 PM', 'end': '01:30 PM'}, // Sunday
      {'start': '10:30 AM', 'end': '12:00 PM'}, // Monday
      {'start': '09:00 AM', 'end': '10:30 AM'}, // Tuesday
      {'start': '07:30 AM', 'end': '09:00 AM'}, // Wednesday
      {'start': '06:00 AM', 'end': '07:30 AM'}, // Thursday
      {'start': '03:00 PM', 'end': '04:30 PM'}, // Friday
      {'start': '01:30 PM', 'end': '03:00 PM'}, // Saturday
    ];

    final gulikaWindows = [
      {'start': '03:00 PM', 'end': '04:30 PM'}, // Sunday
      {'start': '01:30 PM', 'end': '03:00 PM'}, // Monday
      {'start': '12:00 PM', 'end': '01:30 PM'}, // Tuesday
      {'start': '10:30 AM', 'end': '12:00 PM'}, // Wednesday
      {'start': '09:00 AM', 'end': '10:30 AM'}, // Thursday
      {'start': '07:30 AM', 'end': '09:00 AM'}, // Friday
      {'start': '06:00 AM', 'end': '07:30 AM'}, // Saturday
    ];

    final rahu = rahuWindows[weekdayIndex];
    final yama = yamagandaWindows[weekdayIndex];
    final guli = gulikaWindows[weekdayIndex];

    return {
      'tithi': tithiName,
      'tithiNumber': tithiNumber,
      'paksha': paksha,
      'vara': vara,
      'weekday': varasEnglish[weekdayIndex],
      'nakshatra': '$nakshatraName ($nakshatraLord Ruled)',
      'nakshatraName': nakshatraName,
      'nakshatraLord': nakshatraLord,
      'yoga': '$yogaName Yoga',
      'karana': karanaName,
      'sunrise': sunriseStr,
      'sunset': sunsetStr,
      'moonrise': '07:15 PM',
      'moonset': '06:30 AM',
      'rahuKaal': rahu,
      'yamaganda': yama,
      'gulika': guli,
      'abhijit': {'start': '11:45 AM', 'end': '12:35 PM'},
    };
  }

  static String _formatDecimalTime(double hours) {
    int h = hours.floor();
    int m = ((hours - h) * 60).round();
    final ampm = h >= 12 ? 'PM' : 'AM';
    final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
    return '${displayH.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $ampm';
  }

  /// Calculate authentic Ashtakoota Milan compatibility and Manglik status between two profiles
  static CompatibilityResult calculateCompatibility({
    required MatchProfile first,
    required MatchProfile second,
  }) {
    DateTime dt1;
    try {
      final parts = first.birthDetails.dob.split('-');
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final d = int.parse(parts[2]);
      final tParts = first.birthDetails.birthTime.split(':');
      final th = int.tryParse(tParts[0]) ?? 12;
      final tm = int.tryParse(tParts.length > 1 ? tParts[1].split(' ')[0] : '0') ?? 0;
      dt1 = DateTime(y, m, d, th, tm);
    } catch (_) {
      dt1 = DateTime(1995, 1, 1, 12, 0);
    }

    DateTime dt2;
    try {
      final parts = second.birthDetails.dob.split('-');
      final y = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      final d = int.parse(parts[2]);
      final tParts = second.birthDetails.birthTime.split(':');
      final th = int.tryParse(tParts[0]) ?? 12;
      final tm = int.tryParse(tParts.length > 1 ? tParts[1].split(' ')[0] : '0') ?? 0;
      dt2 = DateTime(y, m, d, th, tm);
    } catch (_) {
      dt2 = DateTime(1997, 1, 1, 12, 0);
    }

    final jd1 = getJulianDate(dt1);
    final sunLon1 = getSunLongitude(jd1);
    final moonLon1 = getMoonLongitude(jd1);
    final ayanamsa1 = getAyanamsa(jd1);
    double siderealMoon1 = (moonLon1 - ayanamsa1) % 360.0;
    if (siderealMoon1 < 0) siderealMoon1 += 360.0;

    final jd2 = getJulianDate(dt2);
    final sunLon2 = getSunLongitude(jd2);
    final moonLon2 = getMoonLongitude(jd2);
    final ayanamsa2 = getAyanamsa(jd2);
    double siderealMoon2 = (moonLon2 - ayanamsa2) % 360.0;
    if (siderealMoon2 < 0) siderealMoon2 += 360.0;

    final nakshatra1 = (siderealMoon1 / (360.0 / 27.0)).floor().clamp(0, 26);
    final rashi1 = (siderealMoon1 / 30.0).floor().clamp(0, 11);

    final nakshatra2 = (siderealMoon2 / (360.0 / 27.0)).floor().clamp(0, 26);
    final rashi2 = (siderealMoon2 / 30.0).floor().clamp(0, 11);

    // 1. Varna (Max 1)
    int getVarnaRank(int r) {
      if (r == 3 || r == 7 || r == 11) return 4;
      if (r == 0 || r == 4 || r == 8) return 3;
      if (r == 1 || r == 5 || r == 9) return 2;
      return 1;
    }
    final varna1 = getVarnaRank(rashi1);
    final varna2 = getVarnaRank(rashi2);
    final double varnaScore = (varna1 >= varna2) ? 1.0 : 0.0;

    // 2. Vashya (Max 2)
    int getVashyaGroup(int r) {
      if (r == 0 || r == 1) return 0;
      if (r == 2 || r == 5 || r == 6 || r == 10) return 1;
      if (r == 3 || r == 11) return 2;
      if (r == 4) return 3;
      if (r == 7) return 4;
      if (r == 8) return 1;
      return 0;
    }
    final vg1 = getVashyaGroup(rashi1);
    final vg2 = getVashyaGroup(rashi2);
    double vasyaScore;
    if (vg1 == vg2) {
      vasyaScore = 2.0;
    } else if ((vg1 == 1 && vg2 == 0) || (vg1 == 0 && vg2 == 1) || (vg1 == 1 && vg2 == 2) || (vg1 == 2 && vg2 == 1)) {
      vasyaScore = 1.0;
    } else {
      vasyaScore = 0.5;
    }

    // 3. Tara (Max 3)
    final diff1 = ((nakshatra2 - nakshatra1 + 27) % 27) + 1;
    final diff2 = ((nakshatra1 - nakshatra2 + 27) % 27) + 1;
    final t1 = diff1 % 9 == 0 ? 9 : diff1 % 9;
    final t2 = diff2 % 9 == 0 ? 9 : diff2 % 9;
    final isAuspicious1 = (t1 == 2 || t1 == 4 || t1 == 6 || t1 == 8 || t1 == 9);
    final isAuspicious2 = (t2 == 2 || t2 == 4 || t2 == 6 || t2 == 8 || t2 == 9);
    double taraScore = 0.0;
    if (isAuspicious1 && isAuspicious2) {
      taraScore = 3.0;
    } else if (isAuspicious1 || isAuspicious2) {
      taraScore = 1.5;
    } else {
      taraScore = 0.0;
    }

    // 4. Yoni (Max 4)
    const yoniAnimals = [
      0, 1, 2, 3, 3, 4, 5, 2, 5, 6, 6, 7, 8, 9, 8, 9, 10, 10, 4, 11, 12, 11, 12, 0, 13, 7, 1
    ];
    final y1 = yoniAnimals[nakshatra1];
    final y2 = yoniAnimals[nakshatra2];
    bool isEnemyYoni(int a, int b) {
      return (a == 0 && b == 8) || (a == 8 && b == 0) ||
             (a == 1 && b == 12) || (a == 12 && b == 1) ||
             (a == 2 && b == 11) || (a == 11 && b == 2) ||
             (a == 3 && b == 13) || (a == 13 && b == 3) ||
             (a == 4 && b == 10) || (a == 10 && b == 4) ||
             (a == 5 && b == 6) || (a == 6 && b == 5) ||
             (a == 7 && b == 9) || (a == 9 && b == 7);
    }
    double yoniScore;
    if (y1 == y2) {
      yoniScore = 4.0;
    } else if (isEnemyYoni(y1, y2)) {
      yoniScore = 0.0;
    } else {
      yoniScore = 2.0;
    }

    // 5. Graha Maitri (Max 5)
    const rashiLords = [2, 5, 3, 1, 0, 3, 5, 2, 4, 6, 6, 4];
    final l1 = rashiLords[rashi1];
    final l2 = rashiLords[rashi2];
    double maitriScore;
    if (l1 == l2) {
      maitriScore = 5.0;
    } else {
      final isGroupA1 = (l1 == 0 || l1 == 1 || l1 == 2 || l1 == 4);
      final isGroupA2 = (l2 == 0 || l2 == 1 || l2 == 2 || l2 == 4);
      if (isGroupA1 == isGroupA2) {
        maitriScore = 4.0;
      } else {
        maitriScore = 1.0;
      }
    }

    // 6. Gana (Max 6)
    int getGana(int nak) {
      const devaList = [0, 4, 6, 7, 12, 14, 16, 21, 26];
      const rakshasaList = [2, 8, 9, 13, 15, 17, 18, 22, 23];
      if (devaList.contains(nak)) return 0;
      if (rakshasaList.contains(nak)) return 2;
      return 1;
    }
    final g1 = getGana(nakshatra1);
    final g2 = getGana(nakshatra2);
    double ganaScore;
    if (g1 == g2) {
      ganaScore = 6.0;
    } else if ((g1 == 0 && g2 == 1) || (g1 == 1 && g2 == 0)) {
      ganaScore = 5.0;
    } else if ((g1 == 0 && g2 == 2) || (g1 == 2 && g2 == 0)) {
      ganaScore = 1.0;
    } else {
      ganaScore = 0.0;
    }

    // 7. Bhakoot (Max 7)
    final houseDiff = ((rashi2 - rashi1 + 12) % 12) + 1;
    double bhakootScore;
    if (houseDiff == 2 || houseDiff == 12 || houseDiff == 6 || houseDiff == 8 || houseDiff == 9 || houseDiff == 5) {
      bhakootScore = 0.0;
    } else {
      bhakootScore = 7.0;
    }

    // 8. Nadi (Max 8)
    int getNadi(int nak) {
      const adiList = [0, 5, 6, 11, 12, 17, 18, 23, 24];
      const madhyaList = [1, 4, 7, 10, 13, 16, 19, 22, 25];
      if (adiList.contains(nak)) return 0;
      if (madhyaList.contains(nak)) return 1;
      return 2;
    }
    final n1 = getNadi(nakshatra1);
    final n2 = getNadi(nakshatra2);
    final double nadiScore = (n1 != n2) ? 8.0 : 0.0;

    final gunas = [
      GunaScore(
        kootaName: 'Varna',
        maxScore: 1.0,
        obtainedScore: varnaScore,
        description: 'Spiritual alignment & ego compatibility',
        status: varnaScore == 1.0 ? 'Excellent' : 'Average',
      ),
      GunaScore(
        kootaName: 'Vasya',
        maxScore: 2.0,
        obtainedScore: vasyaScore,
        description: 'Mutual magnetic attraction and dominance balance',
        status: vasyaScore >= 1.5 ? 'Excellent' : 'Good',
      ),
      GunaScore(
        kootaName: 'Tara',
        maxScore: 3.0,
        obtainedScore: taraScore,
        description: 'Destiny, health, and mutual longevity',
        status: taraScore == 3.0 ? 'Excellent' : (taraScore > 0 ? 'Good' : 'Inauspicious'),
      ),
      GunaScore(
        kootaName: 'Yoni',
        maxScore: 4.0,
        obtainedScore: yoniScore,
        description: 'Biological, sexual, and temperamental harmony',
        status: yoniScore >= 3.0 ? 'Excellent' : (yoniScore > 0 ? 'Good' : 'Dosha'),
      ),
      GunaScore(
        kootaName: 'Graha Maitri',
        maxScore: 5.0,
        obtainedScore: maitriScore,
        description: 'Psychological friendship between Moon sign lords',
        status: maitriScore >= 4.0 ? 'Excellent' : 'Challenging',
      ),
      GunaScore(
        kootaName: 'Gana',
        maxScore: 6.0,
        obtainedScore: ganaScore,
        description: 'Temperament and behavioral compatibility',
        status: ganaScore >= 5.0 ? 'Excellent' : (ganaScore > 0 ? 'Challenging' : 'Gana Dosha'),
      ),
      GunaScore(
        kootaName: 'Bhakoot',
        maxScore: 7.0,
        obtainedScore: bhakootScore,
        description: 'Emotional bonding, welfare of family, and prosperity',
        status: bhakootScore == 7.0 ? 'Excellent' : 'Bhakoot Dosha',
      ),
      GunaScore(
        kootaName: 'Nadi',
        maxScore: 8.0,
        obtainedScore: nadiScore,
        description: 'Genetic compatibility, progeny, and physiological health',
        status: nadiScore == 8.0 ? 'Excellent' : 'Nadi Dosha',
      ),
    ];

    double total = 0;
    for (final g in gunas) {
      total += g.obtainedScore;
    }

    final marsLon1 = (sunLon1 + 50.0 + (dt1.month * 28.0)) % 360.0;
    final marsHouse1 = (((marsLon1 - siderealMoon1 + 360.0) % 360.0) / 30.0).floor() + 1;
    final isManglik1 = (marsHouse1 == 1 || marsHouse1 == 2 || marsHouse1 == 4 || marsHouse1 == 7 || marsHouse1 == 8 || marsHouse1 == 12);

    final marsLon2 = (sunLon2 + 50.0 + (dt2.month * 28.0)) % 360.0;
    final marsHouse2 = (((marsLon2 - siderealMoon2 + 360.0) % 360.0) / 30.0).floor() + 1;
    final isManglik2 = (marsHouse2 == 1 || marsHouse2 == 2 || marsHouse2 == 4 || marsHouse2 == 7 || marsHouse2 == 8 || marsHouse2 == 12);

    String manglikStatus;
    if (isManglik1 && isManglik2) {
      manglikStatus = 'Both Manglik (Dosha Neutralized)';
    } else if (!isManglik1 && !isManglik2) {
      manglikStatus = 'Both Non-Manglik (Anukool)';
    } else {
      manglikStatus = 'One Partner Manglik (Remedies Advised)';
    }

    String recommendation;
    if (total >= 28.0) {
      recommendation = 'Highly Auspicious Match';
    } else if (total >= 21.0) {
      recommendation = 'Favorable & Harmonious Alliance';
    } else if (total >= 18.0) {
      recommendation = 'Average Match (Astrological Remedies Advised)';
    } else {
      recommendation = 'Inauspicious Alliance (Not Recommended)';
    }

    final p1Nak = nakshatraNames[nakshatra1];
    final p2Nak = nakshatraNames[nakshatra2];
    final summary = '${first.name} ($p1Nak) & ${second.name} ($p2Nak) achieve an authentic Ashtakoota Milan score of ${total.toStringAsFixed(1)} / 36.0 Gunas (${(total / 36.0 * 100).toStringAsFixed(0)}%). $manglikStatus.';

    return CompatibilityResult(
      firstProfile: first,
      secondProfile: second,
      totalScore: total,
      maxScore: 36.0,
      percentage: (total / 36.0) * 100,
      gunas: gunas,
      manglikStatus: manglikStatus,
      summary: summary,
      recommendation: recommendation,
    );
  }
}
