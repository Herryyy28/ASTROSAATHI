import 'models/game_plan_data.dart';
import 'models/panchang_data.dart';
import 'models/muhurat_data.dart';
import 'models/ai_data.dart';
import 'models/horoscope_data.dart';
import 'astrology_engine.dart';

class MockAstrologyEngine implements AstrologyEngine {
  @override
  Future<GamePlanData> calculateDailyGamePlan(String date, String location, {String languageCode = 'en'}) async {
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
  Future<PanchangData> calculatePanchang(String date, String location, {String languageCode = 'en'}) async {
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
  Future<MuhuratResult> calculateMuhurat(MuhuratInput input, {String languageCode = 'en'}) async {
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
  Future<AstroBabaResponse> askAstroBaba(String question, String date, String location, {String languageCode = 'en'}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final q = question.toLowerCase();
    String answer;
    List<String> actions;
    List<String> warnings;

    final lang = languageCode.toLowerCase();

    if (lang == 'hi' || q.contains('करियर') || q.contains('नौकरी') || q.contains('पैसा') || q.contains('दिन कैसा')) {
      if (q.contains('job') || q.contains('career') || q.contains('promotion') || q.contains('करियर') || q.contains('नौकरी')) {
        answer = '✦ वैदिक भविष्यवाणी विश्लेषण: आपकी कुंडली के 10वें कर्म भाव पर गुरु (बृहस्पति) का शुभ गोचर हो रहा है, जिससे महाभाग्य योग बन रहा है। यह करियर में उन्नति, नए अवसरों और पद-प्रतिष्ठा की उच्च संभावना दर्शाता है। आपका आज का शुभ मुहूर्त सुबह 11:15 से दोपहर 1:20 तक है।';
        actions = [
          'अभिजीत मुहूर्त (11:15 AM - 1:20 PM) के दौरान महत्वपूर्ण व्यावसायिक बैठकें रखें',
          'गुरु ग्रह की शुभता बढ़ाने के लिए गुरुवार को पीले वस्त्र या हल्दी का उपयोग करें',
          'सूर्योदय के समय सूर्य देव को जल अर्पित करें',
        ];
        warnings = ['राहु काल (1:30 PM - 3:00 PM) के दौरान किसी महत्वपूर्ण अनुबंध पर हस्ताक्षर करने से बचें'];
      } else if (q.contains('love') || q.contains('marriage') || q.contains('शादी') || q.contains('प्रेम')) {
        answer = '✦ वैदिक संबंध विश्लेषण: शुक्र (शुक्र ग्रह) आपके 7वें भाव में रोहिणी नक्षत्र के चंद्रमा के साथ विराजमान है। यह योग आपसी समझ, प्रेम में प्रगाढ़ता और संबंधों में मधुरता लाता है।';
        actions = [
          'संध्याकाल के समय अपने जीवनसाथी या साथी के प्रति आभार व्यक्त करें',
          'शुक्र बीज मंत्र (ॐ द्रां द्रीं द्रौं सः शुक्रાય नमः) का जाप करें',
          'शुक्रवार को सफेद या हल्के रंग के वस्त्र धारण करें',
        ];
        warnings = ['चंद्रमा के 6ठे/8वें भाव गोचर के समय बहस से बचें'];
      } else {
        answer = '✦ वैदिक आकाशीय गणना: आज रोहिणी नक्षत्र में सिद्धि योग सक्रिय है। आपकी कॉस्मिक ऊर्जा 8.7/10 पर है। यह समय नए कार्यों की शुरुआत और सफलता के लिए अत्यंत शुभ है।';
        actions = [
          'सुबह 11:15 से 1:20 के बीच के स्वर्णिम समय का लाभ उठाएं',
          'प्रातः काल 5 मिनट प्राणायाम करें',
          'सौभाग्य के लिए पीले रंग का रुमाल पास रखें',
        ];
        warnings = ['संध्या के समय अनावश्यक खर्चों से बचें'];
      }
    } else if (lang == 'gu' || q.contains('કારકિર્દી') || q.contains('દિવસ') || q.contains('કેવો') || q.contains('પ્રેમ')) {
      if (q.contains('job') || q.contains('career') || q.contains('promotion') || q.contains('કારકિર્દી') || q.contains('નોકરી')) {
        answer = '✦ વૈદિક ભવિષ્યવાણી વિશ્લેષણ: તમારી કુંડળીના 10મા કર્મ સ્થાન પર ગુરુનું શુભ ભ્રમણ થઈ રહ્યું છે, જે મહાભાગ્ય યોગ બનાવી રહ્યું છે. આ કરિયરમાં પ્રગતિ અને નવું પદ મેળવવાની ઉત્તમ સંભાવના દર્શાવે છે. તમારો આજનો શુભ સમય સવારે 11:15 થી બપોરે 1:20 નો છે.';
        actions = [
          'અભિજીત મુહૂર્ત (11:15 AM - 1:20 PM) દરમિયાન મહત્વની મીટિંગ્સનું આયોજન કરો',
          'ગુરુ ગ્રહના શુભ પ્રભાવ માટે ગુરુવારે પીળા વસ્ત્રો પહેરો',
          'સૂર્યોદય સમયે સૂર્યદેવને જળ અર્પિત કરો',
        ];
        warnings = ['રાહુ કાળ (1:30 PM - 3:00 PM) દરમિયાન કરાર સાઇન કરવાનું ટાળો'];
      } else if (q.contains('love') || q.contains('marriage') || q.contains('લગ્ન') || q.contains('પ્રેમ')) {
        answer = '✦ વૈદિક સંબંધ વિશ્લેષણ: શુક્ર ગ્રહ તમારા 7મા ભાવમાં રોહિણી નક્ષત્રના ચંદ્ર સાથે સ્થિત છે. આ યોગ પરસ્પર પ્રેમ, લાગણીઓની હૂંફ અને સંબંધોમાં સદભાવના લાવે છે.';
        actions = [
          'સાંજના સમયે તમારા જીવનસાથી પ્રત્યે આદર વ્યક્ત કરો',
          'શુક્ર બીજ મંત્રનો જાપ કરો',
          'શુક્રવારે સફેદ કે આછા રંગના કપડાં પહેરો',
        ];
        warnings = ['ચંદ્રના અશુભ ભ્રમણ સમયે ઉગ્ર દલીલો ટાળો'];
      } else {
        answer = '✦ વૈદિક આકાશી ગણતરી: આજે રોહિણી નક્ષત્રમાં સિદ્ધિ યોગ સક્રિય છે. તમારો ઊર્જા સ્કોર 8.7/10 છે. આ સમય નવા કાર્યોના પ્રારંભ માટે અત્યંત ઉત્તમ છે.';
        actions = [
          'સવારે 11:15 થી 1:20 વચ્ચેના ગોલ્ડન ટાઇમનો લાભ લો',
          'પ્રાતઃકાળે પ્રણાયામ કરો',
          'ભાગ્યવૃદ્ધિ માટે પીળો રૂમાલ સાથે રાખો',
        ];
        warnings = ['સાંજના સમયે બિનજરૂરી ખર્ચ ટાળો'];
      }
    } else {
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
    }

    return AstroBabaResponse(
      answer: answer,
      confidence: '94% Authentic Astrological Match',
      actions: actions,
      warnings: warnings,
    );
  }

  @override
  Future<HoroscopeData> getHoroscope(String sign, String timeframe, {String languageCode = 'en'}) async {
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
