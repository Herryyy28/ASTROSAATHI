import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/engine/models/ai_data.dart';

class AstroBabaNotifier extends StateNotifier<List<ChatMessage>> {
  AstroBabaNotifier(this.ref) : super([]) {
    _initGreeting();
  }

  final Ref ref;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  static String _getGreeting(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hindi:
        return 'प्रणाम! मैं एस्ट्रो बाबा हूँ, आपका व्यक्तिगत ज्योतिषी। आज आप अपने भविष्य या राशिफल के बारे में क्या जानना चाहते हैं?';
      case AppLanguage.gujarati:
        return 'પ્રણામ! હું એસ્ટ્રો બાબા છું, તમારો વ્યક્તિગત જ્યોતિષી. આજે તમે તમારા ભવિષ્ય વિશે શું જાણવા માંગો છો?';
      case AppLanguage.english:
        return 'I am Astro Baba, your personal astrologer. What would you like to know today?';
    }
  }

  void _initGreeting() {
    final lang = ref.read(localeProvider);
    state = [ChatMessage(text: _getGreeting(lang), isUser: false)];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    state = [...state, ChatMessage(text: text, isUser: true)];
    _isLoading = true;

    try {
      final engine = ref.read(astrologyEngineProvider);
      final lang = ref.read(localeProvider);
      final profile = ref.read(activeProfileProvider);
      final location = '${profile.latitude},${profile.longitude},${profile.timezone}';
      final date = DateTime.now().toIso8601String();
      
      final response = await engine.askAstroBaba(text, date, location, languageCode: lang.code);
      
      state = [...state, ChatMessage(
        text: response.answer,
        isUser: false,
        aiData: response,
      )];
    } catch (e) {
      final lang = ref.read(localeProvider);
      String errorMsg;
      if (lang == AppLanguage.hindi) {
        errorMsg = 'क्षमा करें, वर्तमान में नक्षत्र धुंधले हैं। कृपया कुछ समय बाद पुनः प्रयास करें। ($e)';
      } else if (lang == AppLanguage.gujarati) {
        errorMsg = 'માફ કરશો, અત્યારે ગ્રહો સ્પષ્ટ નથી. કૃપા કરીને થોડી વાર પછી ફરી પ્રયાસ કરો. ($e)';
      } else {
        errorMsg = 'I\'m sorry, the stars are cloudy right now. Please try again later. ($e)';
      }
      state = [...state, ChatMessage(
        text: errorMsg,
        isUser: false,
      )];
    } finally {
      _isLoading = false;
    }
  }
}

final astroBabaProvider = StateNotifierProvider<AstroBabaNotifier, List<ChatMessage>>((ref) {
  return AstroBabaNotifier(ref);
});

final astroBabaLoadingProvider = StateProvider<bool>((ref) => false);
