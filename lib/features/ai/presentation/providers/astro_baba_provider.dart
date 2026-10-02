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
        return 'à¤ªà¥à¤°à¤£à¤¾à¤®! à¤®à¥ˆà¤‚ à¤à¤¸à¥à¤Ÿà¥à¤°à¥‹ à¤¬à¤¾à¤¬à¤¾ à¤¹à¥‚à¤, à¤†à¤ªà¤•à¤¾ à¤µà¥à¤¯à¤•à¥à¤¤à¤¿à¤—à¤¤ à¤œà¥à¤¯à¥‹à¤¤à¤¿à¤·à¥€à¥¤ à¤†à¤œ à¤†à¤ª à¤…à¤ªà¤¨à¥‡ à¤­à¤µà¤¿à¤·à¥à¤¯ à¤¯à¤¾ à¤°à¤¾à¤¶à¤¿à¤«à¤² à¤•à¥‡ à¤¬à¤¾à¤°à¥‡ à¤®à¥‡à¤‚ à¤•à¥à¤¯à¤¾ à¤œà¤¾à¤¨à¤¨à¤¾ à¤šà¤¾à¤¹à¤¤à¥‡ à¤¹à¥ˆà¤‚?';
      case AppLanguage.gujarati:
        return 'àªªà«àª°àª£àª¾àª®! àª¹à«àª‚ àªàª¸à«àªŸà«àª°à«‹ àª¬àª¾àª¬àª¾ àª›à«àª‚, àª¤àª®àª¾àª°à«‹ àªµà«àª¯àª•à«àª¤àª¿àª—àª¤ àªœà«àª¯à«‹àª¤àª¿àª·à«€. àª†àªœà«‡ àª¤àª®à«‡ àª¤àª®àª¾àª°àª¾ àª­àªµàª¿àª·à«àª¯ àªµàª¿àª¶à«‡ àª¶à«àª‚ àªœàª¾àª£àªµàª¾ àª®àª¾àª‚àª—à«‹ àª›à«‹?';
      case AppLanguage.english:
      default:
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
            'à¤•à¥à¤·à¤®à¤¾ à¤•à¤°à¥‡à¤‚, à¤µà¤°à¥à¤¤à¤®à¤¾à¤¨ à¤®à¥‡à¤‚ à¤¨à¤•à¥à¤·à¤¤à¥à¤° à¤§à¥à¤‚à¤§à¤²à¥‡ à¤¹à¥ˆà¤‚à¥¤ à¤¨à¥€à¤šà¥‡ "à¤ªà¥à¤¨à¤ƒ à¤ªà¥à¤°à¤¯à¤¾à¤¸ à¤•à¤°à¥‡à¤‚" à¤¦à¤¬à¤¾à¤à¤à¥¤';
      } else if (lang == AppLanguage.gujarati) {
        errorMsg =
            'àª®àª¾àª« àª•àª°àª¶à«‹, àª…àª¤à«àª¯àª¾àª°à«‡ àª—à«àª°àª¹à«‹ àª¸à«àªªàª·à«àªŸ àª¨àª¥à«€. àª¨à«€àªšà«‡ "àª«àª°à«€ àªªà«àª°àª¯àª¾àª¸" àªŸà«…àªª àª•àª°à«‹.';
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

