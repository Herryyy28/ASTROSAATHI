import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/matchmaking_models.dart';
import '../network/api_result.dart';
import 'repository_providers.dart';

const _historyKey = 'matchmaking_history_v1';

@immutable
class MatchmakingState {
  final AsyncValue<CompatibilityResult?> currentResult;
  final List<CompatibilityResult> history;
  final bool isSaving;

  const MatchmakingState({
    this.currentResult = const AsyncValue.data(null),
    this.history = const [],
    this.isSaving = false,
  });

  MatchmakingState copyWith({
    AsyncValue<CompatibilityResult?>? currentResult,
    List<CompatibilityResult>? history,
    bool? isSaving,
  }) {
    return MatchmakingState(
      currentResult: currentResult ?? this.currentResult,
      history: history ?? this.history,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class MatchmakingNotifier extends StateNotifier<MatchmakingState> {
  final Ref _ref;

  MatchmakingNotifier(this._ref) : super(const MatchmakingState()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_historyKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw) as List<dynamic>;
        final list = decoded
            .map((e) => CompatibilityResult.fromJson(e as Map<String, dynamic>))
            .toList();
        state = state.copyWith(history: list);
      }
    } catch (e) {
      debugPrint('Error loading matchmaking history: $e');
    }
  }

  Future<void> _persistHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(state.history.map((m) => m.toJson()).toList());
      await prefs.setString(_historyKey, encoded);
    } catch (e) {
      debugPrint('Error persisting matchmaking history: $e');
    }
  }

  Future<CompatibilityResult?> calculateMatch({
    required MatchProfile first,
    required MatchProfile second,
  }) async {
    state = state.copyWith(currentResult: const AsyncValue.loading());
    try {
      final repo = _ref.read(matchmakingRepoProvider);
      final result = await repo.calculateCompatibility(first: first, second: second);

      if (result is Success<CompatibilityResult>) {
        state = state.copyWith(currentResult: AsyncValue.data(result.data));
        return result.data;
      } else if (result is Failure<CompatibilityResult>) {
        state = state.copyWith(
          currentResult: AsyncValue.error(result.exception.message, StackTrace.current),
        );
        return null;
      }
      return null;
    } catch (e, st) {
      state = state.copyWith(currentResult: AsyncValue.error(e, st));
      return null;
    }
  }

  Future<bool> saveCurrentMatch() async {
    final current = state.currentResult.valueOrNull;
    if (current == null) return false;

    // Check if duplicate already exists
    final alreadyExists = state.history.any((item) =>
        item.firstProfile.name == current.firstProfile.name &&
        item.secondProfile.name == current.secondProfile.name &&
        item.totalScore == current.totalScore);

    if (alreadyExists) return true;

    final updated = [current, ...state.history];
    state = state.copyWith(history: updated);
    await _persistHistory();
    return true;
  }

  Future<void> deleteFromHistory(int index) async {
    if (index < 0 || index >= state.history.length) return;
    final updated = List<CompatibilityResult>.from(state.history)..removeAt(index);
    state = state.copyWith(history: updated);
    await _persistHistory();
  }

  Future<void> clearHistory() async {
    state = state.copyWith(history: []);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}

final matchmakingProvider =
    StateNotifierProvider<MatchmakingNotifier, MatchmakingState>((ref) {
  return MatchmakingNotifier(ref);
});

final matchmakingHistoryProvider = Provider<List<CompatibilityResult>>((ref) {
  return ref.watch(matchmakingProvider).history;
});
