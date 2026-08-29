import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/astrology_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/engine/models/ai_data.dart';
import '../../../../l10n/app_language.dart';

class AstroBabaNotifier extends StateNotifier<List<ChatMessage>> {
  AstroBabaNotifier(this.ref) : super([
    ChatMessage(
      text: 'I am Astro Baba, your personal astrologer. What would you like to know today?',
      isUser: false,
    )
  ]);

  final Ref ref;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    state = [...state, ChatMessage(text: text, isUser: true)];
    _isLoading = true;
    
    // Using a ref to notify listeners or just trigger rebuild?
    // Since we can't easily notify listeners for _isLoading without another provider,
    // we'll just use a separate StateProvider for loading state.

    try {
      final engine = ref.read(astrologyEngineProvider);
      final lang = ref.read(localeProvider);
      final response = await engine.askAstroBaba(text, 'Today', 'Current Location', languageCode: lang.code);
      
      state = [...state, ChatMessage(
        text: response.answer,
        isUser: false,
        aiData: response,
      )];
    } catch (e) {
      state = [...state, ChatMessage(
        text: 'I\'m sorry, the stars are cloudy right now. Please try again later. ($e)',
        isUser: false,
      )];
    } finally {
      _isLoading = false;
      // Triggers update for those watching loading state separately if we want to
    }
  }
}

final astroBabaProvider = StateNotifierProvider<AstroBabaNotifier, List<ChatMessage>>((ref) {
  return AstroBabaNotifier(ref);
});

final astroBabaLoadingProvider = StateProvider<bool>((ref) => false);
