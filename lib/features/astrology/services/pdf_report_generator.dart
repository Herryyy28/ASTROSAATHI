import '../../../l10n/app_language.dart';

class AstrologicalReportData {
  final String userName;
  final String dob;
  final String birthTime;
  final String birthPlace;
  final String sunSign;
  final String moonSign;
  final String ascendant;
  final String mahadasha;
  final String reportTitle;
  final List<String> keyInterpretations;
  final List<String> recommendedRemedies;

  AstrologicalReportData({
    required this.userName,
    required this.dob,
    required this.birthTime,
    required this.birthPlace,
    required this.sunSign,
    required this.moonSign,
    required this.ascendant,
    required this.mahadasha,
    required this.reportTitle,
    required this.keyInterpretations,
    required this.recommendedRemedies,
  });
}

class PdfReportGenerator {
  static AstrologicalReportData generateLocalizedReport({
    required String userName,
    required String dob,
    required String birthTime,
    required String birthPlace,
    required AppLanguage language,
  }) {
    switch (language) {
      case AppLanguage.hindi:
        return AstrologicalReportData(
          userName: userName.isEmpty ? 'उपयोगकर्ता' : userName,
          dob: dob,
          birthTime: birthTime,
          birthPlace: birthPlace,
          sunSign: 'सिंह (Leo)',
          moonSign: 'वृषभ (Taurus)',
          ascendant: 'कर्क (Cancer)',
          mahadasha: 'बृहस्पति (Guru) महादशा',
          reportTitle: 'प्रामाणिक वैदिक जन्म कुंडली एवं भविष्यफल रिपोर्ट',
          keyInterpretations: [
            '10वें कर्म भाव में बृहस्पति का शुभ गोचर करियर में उच्च पद व सफलता दिलाएगा।',
            'रोहिणी नक्षत्र का चंद्रमा मानसिक प्रगाढ़ता और रचनात्मक विचार शक्ति प्रदान करता है।',
            'शनि की साढ़े साती का प्रभाव सीमित है; प्रतिदिन हनुमान चालीसा का पाठ करें।',
          ],
          recommendedRemedies: [
            'पीला पुखराज रत्न तर्जनी उंगली में गुरुवार को धारण करें।',
            'गुरु बीज मंत्र: ॐ ग्रಾಂ ग्रीं ग्रौं सः गुरुवे नमः का 108 बार जाप करें।',
            'गुरुवार को चने की दाल एवं पीले पुष्प भगवान विष्णु को अर्पित करें।',
          ],
        );

      case AppLanguage.gujarati:
        return AstrologicalReportData(
          userName: userName.isEmpty ? 'વપરાશકર્તા' : userName,
          dob: dob,
          birthTime: birthTime,
          birthPlace: birthPlace,
          sunSign: 'સિંહ (Leo)',
          moonSign: 'વૃષભ (Taurus)',
          ascendant: 'કર્ક (Cancer)',
          mahadasha: 'ગુરુ (Jupiter) મહાદશા',
          reportTitle: 'પ્રમાણિક વૈદિક જન્મ કુંડળી અને ભવિષ્યફળ રિપોર્ટ',
          keyInterpretations: [
            '10મા કર્મ સ્થાન પર ગુરુનું શુભ ભ્રમણ કરિયરમાં ઉચ્ચ સફળતા અને પ્રગતિ આપશે.',
            'રોહિણી નક્ષત્રનો ચંદ્ર માનસિક સ્થિરતા અને સર્જનાત્મક વિચારો આપે છે.',
            'શનિનો પ્રભાવ મધ્યમ છે; દરરોજ હનુમાન ચાલીસાનો પાઠ કરો.',
          ],
          recommendedRemedies: [
            'પીળો પોખરાજ રત્ન ગુરુવારે પહેરો.',
            'ગુરુ બીજ મંત્ર: ૐ ગ્રಾಂ ગ્રીં ગ્રોં સઃ ગુરવે નમઃ નો 108 વાર જાપ કરો.',
            'ગુરુવારે ચણાની દાળ અને પીળા ફૂલ ભગવાન વિષ્ણુને અર્પણ કરો.',
          ],
        );

      case AppLanguage.english:
      default:
        return AstrologicalReportData(
          userName: userName.isEmpty ? 'User' : userName,
          dob: dob,
          birthTime: birthTime,
          birthPlace: birthPlace,
          sunSign: 'Leo',
          moonSign: 'Taurus',
          ascendant: 'Cancer',
          mahadasha: 'Jupiter (Guru) Mahadasha',
          reportTitle: 'Authentic Vedic Kundli & Life Forecast Report',
          keyInterpretations: [
            'Benefic transit of Jupiter over 10th Karma house indicates career promotion & success.',
            'Moon in Rohini Nakshatra endows high emotional intelligence & leadership skills.',
            'Saturn transit is well-balanced; daily Hanuman Chalisa recommended.',
          ],
          recommendedRemedies: [
            'Wear Yellow Sapphire (Pukhraj) on index finger on Thursday morning.',
            'Chant Guru Beej Mantra: Om Gram Greem Grom Sah Gurave Namah 108 times.',
            'Offer yellow sweets & chana dal to Lord Vishnu on Thursdays.',
          ],
        );
    }
  }
}
