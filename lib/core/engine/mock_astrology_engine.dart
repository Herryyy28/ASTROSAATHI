import 'models/game_plan_data.dart';
import 'models/panchang_data.dart';
import 'models/muhurat_data.dart';
import 'models/ai_data.dart';
import 'models/horoscope_data.dart';
import 'astrology_engine.dart';

class MockAstrologyEngine implements AstrologyEngine {
  @override
  Future<GamePlanData> calculateDailyGamePlan(String date, String location) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return GamePlanData(
      date: date,
      dayScore: 8.4,
      doList: [
        'Have important conversations today',
        'Start planned work — energy is aligned',
        'Focus on creative projects',
      ],
      beCarefulList: [
        'Avoid rushed decisions before 2 PM',
        'Double-check financial details',
      ],
      avoidList: [
        'Unnecessary arguments or confrontations',
        'Starting new ventures after sunset',
      ],
      bestWindow: TimeWindow(start: '11:15 AM', end: '1:20 PM'),
      categories: {
        'Career': 8.8,
        'Love': 7.4,
        'Money': 8.1,
      },
    );
  }

  @override
  Future<PanchangData> calculatePanchang(String date, String location) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PanchangData(
      tithi: 'Shukla Paksha Dashami',
      vara: 'Wednesday',
      nakshatra: 'Rohini',
      yoga: 'Shiva',
      karana: 'Taitila',
      sunrise: '06:12 AM',
      sunset: '06:45 PM',
      rahuKaal: TimeWindow(start: '12:00 PM', end: '01:30 PM'),
    );
  }

  @override
  Future<MuhuratResult> calculateMuhurat(MuhuratInput input) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return MuhuratResult(
      category: input.category,
      bestWindow: TimeWindow(start: '11:15 AM', end: '01:20 PM'),
      strength: 'Excellent',
      bestFor: 'Important professional discussions and decisions',
      avoidWindow: TimeWindow(start: '02:10 PM', end: '03:25 PM'),
    );
  }

  @override
  Future<AstroBabaResponse> askAstroBaba(String question, String date, String location) async {
    await Future.delayed(const Duration(seconds: 1));

    String answer;
    List<String> actions;

    if (question.toLowerCase().contains('job') || question.toLowerCase().contains('career')) {
      answer = 'The stars show a strong career alignment today. With your energy score at 8.4 and career aspect at 8.8, this is an excellent time to discuss promotions or new opportunities. The best window is between 11:15 AM and 1:20 PM.';
      actions = ['Schedule important meetings during the best window', 'Update your resume or portfolio', 'Network with influential colleagues'];
    } else if (question.toLowerCase().contains('meeting') || question.toLowerCase().contains('today')) {
      answer = 'Today\'s planetary alignment favors productive discussions. Mercury\'s position strengthens communication — your words will carry more weight than usual. Use the morning hours wisely.';
      actions = ['Prepare talking points before 11 AM', 'Listen more than you speak', 'Follow up by end of day'];
    } else {
      answer = 'Based on today\'s celestial map, the overall energy is highly favorable at 8.4/10. Rohini nakshatra brings stability and growth. Focus on what matters most to you and trust your intuition during the golden window of 11:15 AM to 1:20 PM.';
      actions = ['Meditate for 5 minutes during sunrise', 'Journal your intentions for the day', 'Practice gratitude before bed'];
    }

    return AstroBabaResponse(
      answer: answer,
      confidence: 'high',
      actions: actions,
      warnings: ['Avoid major decisions during Rahu Kaal (12:00 PM – 1:30 PM)'],
    );
  }

  @override
  Future<HoroscopeData> getHoroscope(String sign, String timeframe) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final readings = {
      'daily': 'Today brings a powerful surge of energy for $sign. The moon\'s transit emphasizes your career sector, pushing you to take bold steps. Trust your instincts — the stars are aligned in your favor for important conversations and decisions.',
      'weekly': 'This week, $sign will find balance in personal relationships. A planetary shift on Wednesday clears up misunderstandings. Financial prospects look promising towards the weekend — stay open to unexpected opportunities.',
      'monthly': 'This month highlights financial growth and stability for $sign. Keep an eye out for long-term investments around the 15th. Romantic energy peaks mid-month, making it ideal for deepening connections or meeting someone special.',
    };

    return HoroscopeData(
      sign: sign,
      timeframe: timeframe,
      reading: readings[timeframe] ?? readings['daily']!,
      luckyNumber: 7,
      luckyColor: 'Gold',
    );
  }
}
