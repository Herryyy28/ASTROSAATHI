import 'models/game_plan_data.dart';
import 'models/panchang_data.dart';
import 'models/muhurat_data.dart';
import 'models/ai_data.dart';
import 'models/horoscope_data.dart';
import 'models/astrology_validation.dart';
import 'astrology_engine.dart';
import '../utils/zodiac_sign_utils.dart';

class MockAstrologyEngine implements AstrologyEngine {
  @override
  Future<GamePlanData> calculateDailyGamePlan(
    String date,
    String location, {
    String languageCode = 'en',
    String? profileName,
    String? dob,
    String? birthTime,
  }) async {
    AstrologyValidator.validateDate(date);

    final name = (profileName != null && profileName.isNotEmpty) ? profileName : 'Herry Prajapati';
    final userDob = (dob != null && dob.isNotEmpty) ? dob : '1998-05-15';
    final userTime = (birthTime != null && birthTime.isNotEmpty) ? birthTime : '07:30 AM';

    final astroProfile = ZodiacSignUtils.calculateAstroProfile(
      name: name,
      dob: userDob,
      birthTime: userTime,
    );

    // Calculate unique, authentic, deterministic day score for THIS profile and THIS date
    final dateHash = date.codeUnits.fold(0, (p, c) => p + c);
    final profileHash = name.toLowerCase().codeUnits.fold(0, (p, c) => p + c);
    final rawScore = 6.8 + (((astroProfile.moonLongitude * 1.73 + dateHash * 3.14 + profileHash) % 30) / 10.0);
    final dayScore = double.parse((rawScore.clamp(6.2, 9.8)).toStringAsFixed(1));

    final careerScore = double.parse((dayScore * 0.98).clamp(6.0, 9.9).toStringAsFixed(1));
    final loveScore = double.parse((dayScore * 0.92).clamp(5.5, 9.7).toStringAsFixed(1));
    final moneyScore = double.parse((dayScore * 0.95).clamp(5.8, 9.8).toStringAsFixed(1));

    final lang = languageCode.toLowerCase();
    List<String> doList;
    List<String> beCarefulList;
    List<String> avoidList;
    String planetFactor;
    String houseFactor;
    String transitFactor;
    String vedicInterpretation;
    String practicalAction;

    if (lang == 'hi') {
      doList = [
        '11:15 AM से 1:20 PM के बीच ${astroProfile.rulingPlanet} के अनुकूल संचरण का लाभ उठाएं',
        'अभिजीत मुहूर्त के दौरान मुख्य करियर लक्ष्यों पर ध्यान केंद्रित करें जब ${astroProfile.lagnaHi} लग्न सक्रिय हो',
        'मानसिक स्पष्टता के लिए प्रातःकाल ध्यान करें एवं ${astroProfile.rulingPlanet} मंत्र का जाप करें',
      ];
      beCarefulList = [
        'राहु काल के समय भावुक होकर निर्णय लेने से बचें',
        'महत्वपूर्ण वित्तीय समझौतों पर हस्ताक्षर करने से पहले नियमों की जांच करें',
      ];
      avoidList = [
        'सहकर्मियों के साथ अनावश्यक बहस या विवाद से बचें',
        'राहु काल के दौरान कोई नया दीर्घकालिक कार्य शुरू न करें',
      ];
      planetFactor = '${astroProfile.rulingPlanet} (स्वामी ग्रह) का शुभ भाव संचरण';
      houseFactor = '${astroProfile.lagnaHi} लग्न एवं ${astroProfile.rashiHi} राशि धुरी';
      transitFactor = '${astroProfile.nakshatra} नक्षत्र (पद ${astroProfile.pada})';
      vedicInterpretation = '${astroProfile.lagnaHi} लग्न धुरी पर ${astroProfile.rulingPlanet} का शुभ गोचर आज आपके निर्णय लेने के आत्मविश्वास और व्यावसायिक सफलता को बढ़ाता है।';
      practicalAction = 'महत्वपूर्ण बैठकों और वित्तीय निर्णयों के लिए अपने स्वर्णिम समय (11:15 AM - 1:20 PM) का उपयोग करें।';
    } else if (lang == 'gu') {
      doList = [
        '11:15 AM થી 1:20 PM વચ્ચે ${astroProfile.rulingPlanet} ના સાનુકૂળ પરિભ્રમણનો લાભ લો',
        'અભિજીત મુહૂર્ત દરમિયાન જ્યારે ${astroProfile.lagnaGu} લગ્ન સક્રિય હોય ત્યારે કરિયર પર ધ્યાન કેન્દ્રિત કરો',
        'માનસિક શાંતિ માટે સવારે ધ્યાન કરો અને ${astroProfile.rulingPlanet} મંત્રનો જાપ કરો',
      ];
      beCarefulList = [
        'રાહુ કાળ દરમિયાન ભાવનાત્મક નિર્ણય લેવાનું ટાળો',
        'નાણાકીય કરારો પર સહી કરતા પહેલા શરતો ચકાસી લો',
      ];
      avoidList = [
        'સહકર્મીઓ સાથે બિનજરૂરી દલીલો ટાળો',
        'રાહુ કાળ દરમિયાન કોઈ નવું મોટું કાર્ય શરૂ ન કરો',
      ];
      planetFactor = '${astroProfile.rulingPlanet} (સ્વામી ગ્રહ) નું શુભ સ્થાન પરિભ્રમણ';
      houseFactor = '${astroProfile.lagnaGu} લગ્ન અને ${astroProfile.rashiGu} રાશિનુ કેન્દ્ર';
      transitFactor = '${astroProfile.nakshatra} નક્ષત્ર (પદ ${astroProfile.pada})';
      vedicInterpretation = '${astroProfile.lagnaGu} લગ્ન પર ${astroProfile.rulingPlanet} નું શુભ ગોચર નિર્ણય લેવાની ક્ષમતા અને વ્યાવસાયિક સફળતા વધારે છે.';
      practicalAction = 'મહત્વની મીટિંગ્સ અને નાણાકીય નિર્ણયો માટે તમારા ગોલ્ડન ટાઇમ (11:15 AM - 1:20 PM) નો ઉપયોગ કરો.';
    } else {
      doList = [
        'Capitalize on favorable ${astroProfile.rulingPlanet} alignment between 11:15 AM and 1:20 PM',
        'Focus on key career goals during Abhijit Muhurat while ${astroProfile.lagnaEn} Lagna is active',
        'Practice morning meditation & chant ${astroProfile.rulingPlanet} mantra for clarity',
      ];
      beCarefulList = [
        'Avoid making emotional commitments during Rahu Kaal window',
        'Verify contract terms before signing key financial agreements',
      ];
      avoidList = [
        'Avoid unnecessary arguments or confrontations with colleagues',
        'Do not initiate major new long-term ventures during Rahu Kaal',
      ];
      planetFactor = '${astroProfile.rulingPlanet} (Ruling Planet) Transiting Benefic House';
      houseFactor = '${astroProfile.lagnaEn} Lagna & ${astroProfile.rashiEn} Rashi Axis';
      transitFactor = '${astroProfile.nakshatra} Nakshatra (Pada ${astroProfile.pada})';
      vedicInterpretation = 'Benefic transit of ${astroProfile.rulingPlanet} over your ${astroProfile.lagnaEn} Lagna axis brings strong decision confidence, executive clarity, and professional alignment today.';
      practicalAction = 'Capitalize on your golden window (11:15 AM - 1:20 PM) for important negotiations, client meetings, or financial decisions.';
    }

    return GamePlanData(
      date: date,
      dayScore: dayScore,
      doList: doList,
      beCarefulList: beCarefulList,
      avoidList: avoidList,
      bestWindow: TimeWindow(start: '11:15 AM', end: '01:20 PM'),
      categories: {
        'Career': careerScore,
        'Love': loveScore,
        'Money': moneyScore,
      },
      planetFactor: planetFactor,
      houseFactor: houseFactor,
      transitFactor: transitFactor,
      vedicInterpretation: vedicInterpretation,
      practicalAction: practicalAction,
    );
  }

  @override
  Future<PanchangData> calculatePanchang(String date, String location, {String languageCode = 'en'}) async {
    final lang = languageCode.toLowerCase();
    if (lang == 'hi') {
      return PanchangData(
        tithi: 'शुक्ल पक्ष दशमी',
        vara: 'गुरुवार',
        nakshatra: 'रोहिणी (चंद्रमा शासित)',
        yoga: 'सिद्धि योग',
        karana: 'तैतिल',
        sunrise: '06:12 AM',
        sunset: '06:45 PM',
        rahuKaal: TimeWindow(start: '01:30 PM', end: '03:00 PM'),
      );
    } else if (lang == 'gu') {
      return PanchangData(
        tithi: 'શુક્લ પક્ષ દશમી',
        vara: 'ગુરુવાર',
        nakshatra: 'રોહિણી (ચંદ્ર શાસિત)',
        yoga: 'સિદ્ધિ યોગ',
        karana: 'તૈતિલ',
        sunrise: '06:12 AM',
        sunset: '06:45 PM',
        rahuKaal: TimeWindow(start: '01:30 PM', end: '03:00 PM'),
      );
    } else {
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
  }

  @override
  Future<MuhuratResult> calculateMuhurat(MuhuratInput input, {String languageCode = 'en'}) async {
    final lang = languageCode.toLowerCase();
    if (lang == 'hi') {
      return MuhuratResult(
        category: input.category,
        bestWindow: TimeWindow(start: '11:15 AM', end: '01:20 PM'),
        strength: 'अभिजीत मुहूर्त (सर्वोच्च प्रभाव)',
        bestFor: 'महत्वपूर्ण व्यावसायिक निर्णय, निवेश और अनुबंध',
        avoidWindow: TimeWindow(start: '01:30 PM', end: '03:00 PM'),
      );
    } else if (lang == 'gu') {
      return MuhuratResult(
        category: input.category,
        bestWindow: TimeWindow(start: '11:15 AM', end: '01:20 PM'),
        strength: 'અભિજીત મુહૂર્ત (સર્વોચ્ચ શક્તિ)',
        bestFor: 'મહત્વપૂર્ણ વ્યવસાયિક નિર્ણયો, રોકાણ અને કરાર',
        avoidWindow: TimeWindow(start: '01:30 PM', end: '03:00 PM'),
      );
    } else {
      return MuhuratResult(
        category: input.category,
        bestWindow: TimeWindow(start: '11:15 AM', end: '01:20 PM'),
        strength: 'Abhijit Muhurat (Highest Strength)',
        bestFor: 'Crucial professional decisions, investments, and contracts',
        avoidWindow: TimeWindow(start: '01:30 PM', end: '03:00 PM'),
      );
    }
  }

  @override
  Future<AstroBabaResponse> askAstroBaba(String question, String date, String location, {String languageCode = 'en'}) async {
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
    final cleanSign = sign.toLowerCase();

    final rashiAttributes = {
      'aries': {'num': 9, 'color': 'Crimson Red', 'planet': 'Mars'},
      'mesha': {'num': 9, 'color': 'Crimson Red', 'planet': 'Mars'},
      'taurus': {'num': 6, 'color': 'Lotus Pink', 'planet': 'Venus'},
      'vrishabha': {'num': 6, 'color': 'Lotus Pink', 'planet': 'Venus'},
      'gemini': {'num': 5, 'color': 'Emerald Green', 'planet': 'Mercury'},
      'mithuna': {'num': 5, 'color': 'Emerald Green', 'planet': 'Mercury'},
      'cancer': {'num': 2, 'color': 'Pearl White', 'planet': 'Moon'},
      'karka': {'num': 2, 'color': 'Pearl White', 'planet': 'Moon'},
      'leo': {'num': 1, 'color': 'Royal Gold', 'planet': 'Sun'},
      'simha': {'num': 1, 'color': 'Royal Gold', 'planet': 'Sun'},
      'virgo': {'num': 5, 'color': 'Olive Green', 'planet': 'Mercury'},
      'kanya': {'num': 5, 'color': 'Olive Green', 'planet': 'Mercury'},
      'libra': {'num': 6, 'color': 'Sky Blue', 'planet': 'Venus'},
      'tula': {'num': 6, 'color': 'Sky Blue', 'planet': 'Venus'},
      'scorpio': {'num': 9, 'color': 'Deep Maroon', 'planet': 'Mars'},
      'vrishchika': {'num': 9, 'color': 'Deep Maroon', 'planet': 'Mars'},
      'sagittarius': {'num': 3, 'color': 'Bright Yellow', 'planet': 'Jupiter'},
      'dhanu': {'num': 3, 'color': 'Bright Yellow', 'planet': 'Jupiter'},
      'capricorn': {'num': 8, 'color': 'Dark Sapphire', 'planet': 'Saturn'},
      'makara': {'num': 8, 'color': 'Dark Sapphire', 'planet': 'Saturn'},
      'aquarius': {'num': 8, 'color': 'Electric Cyan', 'planet': 'Saturn'},
      'kumbha': {'num': 8, 'color': 'Electric Cyan', 'planet': 'Saturn'},
      'pisces': {'num': 3, 'color': 'Sea Green', 'planet': 'Jupiter'},
      'meena': {'num': 3, 'color': 'Sea Green', 'planet': 'Jupiter'},
    };

    Map<String, Object>? foundAttr;
    for (final entry in rashiAttributes.entries) {
      if (cleanSign.contains(entry.key)) {
        foundAttr = entry.value;
        break;
      }
    }

    final luckyNum = (foundAttr?['num'] as int?) ?? 7;
    final luckyColor = (foundAttr?['color'] as String?) ?? 'Golden Yellow';
    final rulingPlanet = (foundAttr?['planet'] as String?) ?? 'Jupiter';

    final readings = {
      'daily': '✦ Today\'s Vedic Bhavishyavani for $sign: Ruled by $rulingPlanet, your cosmic energy is amplified today. Transit Moon enhances intuition and executive focus. Lucky hours are between 11:15 AM and 1:20 PM.',
      'weekly': '✦ Weekly Planetary Outlook for $sign: With $rulingPlanet forming favorable aspects, financial growth accelerates mid-week. Focus on long-term strategy.',
      'yearly': '✦ Yearly Horizon for $sign: Major transits over your key houses bring expansion, spiritual wisdom, and career breakthroughs. Align actions with daily muhurat.',
    };

    return HoroscopeData(
      sign: sign,
      timeframe: timeframe,
      reading: readings[timeframe] ?? readings['daily']!,
      luckyNumber: luckyNum,
      luckyColor: luckyColor,
    );
  }

  @override
  Future<Map<String, dynamic>> getBirthChart(String date, String time, String location, {String languageCode = 'en', String? profileId}) async {
    AstrologyValidator.validateDate(date);
    AstrologyValidator.validateTime(time);

    final name = (profileId != null && profileId.isNotEmpty && profileId != 'default') ? profileId : 'Herry Prajapati';
    final astroProfile = ZodiacSignUtils.calculateAstroProfile(
      name: name,
      dob: date,
      birthTime: time,
    );

    final now = DateTime.now();
    final hStr = now.hour.toString().padLeft(2, '0');
    final mStr = now.minute.toString().padLeft(2, '0');

    final chart = {
      'profileId': profileId ?? 'default',
      'lagna': {
        'rashi': astroProfile.lagnaDisplay,
        'ruler': astroProfile.rulingPlanet,
      },
      'rashi': {
        'name': astroProfile.rashiDisplay,
        'hindiName': astroProfile.rashiHi,
        'rulingPlanet': astroProfile.rulingPlanet,
      },
      'nakshatra': astroProfile.nakshatra,
      'pada': astroProfile.pada,
      'planets': astroProfile.planets,
      'metadata': DataQualityMetadata(
        calculatedAt: 'Calculated at $hStr:$mStr',
        timezone: '+05:30',
        latitude: 28.6139,
        longitude: 77.2090,
        profileId: profileId ?? 'default',
      ).toJson(),
    };

    AstrologyValidator.validateBirthChartOutput(chart);
    return chart;
  }
}

