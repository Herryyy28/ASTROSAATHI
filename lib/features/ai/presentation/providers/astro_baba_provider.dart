import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/profile_provider.dart';
import '../../../../core/engine/models/ai_data.dart';

class AstroBabaNotifier extends StateNotifier<List<ChatMessage>> {
  AstroBabaNotifier(this.ref) : super([]) {
    _loadHistoryOrInitGreeting();
  }

  final Ref ref;
  static const String _storageKey = 'astrobaba_chat_history_v1';

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

  Future<void> _loadHistoryOrInitGreeting() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null && raw.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        final loaded = decoded
            .map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
            .toList();
        if (loaded.isNotEmpty) {
          state = loaded;
          return;
        }
      }
    } catch (_) {}

    _initGreeting();
  }

  void _initGreeting() {
    final lang = ref.read(localeProvider);
    state = [ChatMessage(text: _getGreeting(lang), isUser: false)];
    _persistHistory();
  }

  Future<void> _persistHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Keep up to 50 recent messages
      final toSave =
          state.length > 50 ? state.sublist(state.length - 50) : state;
      final encoded = jsonEncode(toSave.map((m) => m.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (_) {}
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    _initGreeting();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    state = [...state, ChatMessage(text: text, isUser: true)];

    // Mark loading
    ref.read(astroBabaLoadingProvider.notifier).state = true;
    _persistHistory();

    try {
      final engine = ref.read(astrologyEngineProvider);
      final lang = ref.read(localeProvider);
      final profile = ref.read(activeProfileProvider);
      final location =
          '${profile.latitude},${profile.longitude},${profile.timezone}';
      final date = DateTime.now().toIso8601String();

      final response = await engine.askAstroBaba(text, date, location,
          languageCode: lang.code);

      state = [
        ...state,
        ChatMessage(
          text: response.answer,
          isUser: false,
          aiData: response,
        )
      ];
    } catch (e) {
      final lang = ref.read(localeProvider);
      String errorMsg;
      if (lang == AppLanguage.hindi) {
        errorMsg =
            'क्षमा करें, वर्तमान में नक्षत्र धुंधले हैं। नीचे "पुनः प्रयास करें" दबाएँ।';
      } else if (lang == AppLanguage.gujarati) {
        errorMsg =
            'માફ કરશો, અત્યારે ગ્રહો સ્પષ્ટ નથી. નીચે "ફરી પ્રયાસ" ટૅપ કરો.';
      } else {
        errorMsg =
            'The stars are cloudy right now. Tap "Retry" to try again.';
      }
      state = [
        ...state,
        ChatMessage(
          text: errorMsg,
          isUser: false,
          isError: true,
          retryQuery: text,
        )
      ];
    } finally {
      ref.read(astroBabaLoadingProvider.notifier).state = false;
      _persistHistory();
    }
  }

  /// Removes the last error message and re-sends its query.
  Future<void> retryLastError() async {
    final last = state.isNotEmpty ? state.last : null;
    if (last == null || !last.isError || last.retryQuery == null) return;
    // Drop the error bubble
    state = state.sublist(0, state.length - 1);
    // Also drop the original user message that precedes it (last user msg)
    if (state.isNotEmpty && state.last.isUser) {
      state = state.sublist(0, state.length - 1);
    }
    await sendMessage(last.retryQuery!);
  }
}

final astroBabaProvider =
    StateNotifierProvider<AstroBabaNotifier, List<ChatMessage>>((ref) {
  return AstroBabaNotifier(ref);
});

/// True while Astro Baba is awaiting an AI response.
final astroBabaLoadingProvider = StateProvider<bool>((ref) => false);
