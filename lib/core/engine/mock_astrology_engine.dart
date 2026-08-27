import 'models/game_plan_data.dart';
import 'models/panchang_data.dart';
import 'models/muhurat_data.dart';
import 'models/ai_data.dart';
import 'models/horoscope_data.dart';
import 'astrology_engine.dart';

class MockAstrologyEngine implements AstrologyEngine {
  @override
  Future<GamePlanData> calculateDailyGamePlan(String date, String location) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return GamePlanData(
      date: date,
      dayScore: 8.7,
      doList: [
        'Initiate key career discussions between 11:15 AM and 1:20 PM',
        'Chant Gayatri Mantra or meditate at sunrise for mental clarity',
        'Take leadership on strategic projects while Jupiter is strong',
      ],
      beCarefulList: [
        'Avoid making hasty financial commitments before 2 PM',
        'Double-check contract terms and legal wording',
      ],
      avoidList: [
        'Avoid starting new long-term ventures during Rahu Kaal',
        'Unnecessary arguments or emotional confrontations',
      ],
      bestWindow: TimeWindow(start: '11:15 AM', end: '01:20 PM'),
      categories: {
        'Career': 8.9,
        'Love': 7.8,
        'Money': 8.5,
      },
    );
  }

  @override
  Future<PanchangData> calculatePanchang(String date, String location) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return PanchangData(
      tithi: 'Shukla Paksha Dashami',
      vara: 'Thursday',
      nakshatra: 'Rohini (Moon Ruled)',
      yoga: 'Siddhi Yoga',
      karana: 'Taitila',
      sunrise: '06:12 AM',
      sunset: '06:45 PM',
      rahuKaal: TimeWindow(start: '01:30 PM', end: '03:00 PM'),
    );
  }

  @override
  Future<MuhuratResult> calculateMuhurat(MuhuratInput input) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MuhuratResult(
      category: input.category,
      bestWindow: TimeWindow(start: '11:15 AM', end: '01:20 PM'),
      strength: 'Abhijit Muhurat (Highest Strength)',
      bestFor: 'Crucial professional decisions, investments, and contracts',
      avoidWindow: TimeWindow(start: '01:30 PM', end: '03:00 PM'),
    );
  }

  @override
  Future<AstroBabaResponse> askAstroBaba(String question, String date, String location) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final q = question.toLowerCase();
    String answer;
    List<String> actions;
    List<String> warnings;

    if (q.contains('job') || q.contains('career') || q.contains('promotion')) {
      answer = '✦ Vedic Bhavishyavani Analysis: Jupiter (Guru) is transiting favorably over your 10th Karma house, creating a strong Mahabhagya alignment. This signifies high probability for career expansion and recognition. Your auspicious window today is between 11:15 AM and 1:20 PM.';
      actions = [
        'Schedule key promotional meetings during Abhijit Muhurat (11:15 AM - 1:20 PM)',
        'Wear a Yellow Sapphire or gold accent on Thursday to boost Jupiter energy',
        'Offer water to the rising Sun while chanting Surya Mantra',
      ];
      warnings = ['Avoid signing major binding contracts during Rahu Kaal (1:30 PM - 3:00 PM)'];
    } else if (q.contains('love') || q.contains('marriage') || q.contains('partner')) {
      answer = '✦ Vedic Relationship Analysis: Venus (Shukra) occupies your 7th house of partnerships alongside Moon in Rohini Nakshatra. This alignment fosters magnetic attraction, emotional warmth, and relationship resolution.';
      actions = [
        'Express gratitude to your partner during sunset',
        'Perform Shukra Beej Mantra (Om Dram Dreem Drom Sah Shukraya Namah)',
        'Wear white or light pastel attire on Fridays',
      ];
      warnings = ['Avoid heated debates when Moon transits 6th/8th house axis'];
    } else if (q.contains('gemstone') || q.contains('remedy') || q.contains('shani')) {
      answer = '✦ Vedic Remedy Insight: To balance planetary afflictions and strengthen weak grahas, focus on Mahadasha remedies. Yellow Sapphire (Pukhraj) boosts Jupiter, while Hanuman Chalisa chanting neutralizes Saturn (Shani) transits.';
      actions = [
        'Chant Hanuman Chalisa 7 times on Saturday evenings',
        'Donate yellow sweets or books to deserving students',
        'Use 108-bead Japa Counter for daily mantra discipline',
      ];
      warnings = ['Always test gemstones for 3 days under pillow before wearing permanently'];
    } else {
      answer = '✦ Vedic Celestial Map Reading: Today\'s cosmic blueprint shows Siddhi Yoga active under Rohini Nakshatra. Your overall celestial energy score stands strong at 8.7/10, making this an empowered phase for manifestation and focused execution.';
      actions = [
        'Capitalize on your Golden Window between 11:15 AM and 1:20 PM',
        'Practice 5 minutes of pranayama breathing at dawn',
        'Keep a grain of turmeric or yellow handkerchief for luck',
      ];
      warnings = ['Steer clear of impulsive spending during evening hours'];
    }

    return AstroBabaResponse(
      answer: answer,
      confidence: '94% Authentic Astrological Match',
      actions: actions,
      warnings: warnings,
    );
  }

  @override
  Future<HoroscopeData> getHoroscope(String sign, String timeframe) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final readings = {
      'daily': '✦ Today\'s Real Bhavishyavani for $sign: The Moon\'s transit through friendly constellation Rohini provides high emotional clarity. Jupiter\'s aspect on your 10th house enhances career authority. Best window for important actions is 11:15 AM to 1:20 PM.',
      'weekly': '✦ Weekly Planetary Outlook for $sign: Sun\'s alignment clears financial bottlenecks mid-week. Relationship harmony reaches a peak on Friday as Venus forms a beneficial Trine. Stay consistent with your goals.',
      'monthly': '✦ Monthly Cosmic Trends for $sign: Mars in 10th House drives unprecedented career acceleration. Ensure financial prudence around the 18th during Saturn\'s retrograde shadow phase.',
    };

    return HoroscopeData(
      sign: sign,
      timeframe: timeframe,
      reading: readings[timeframe] ?? readings['daily']!,
      luckyNumber: 7,
      luckyColor: 'Golden Yellow',
    );
  }
}
