import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CosmicBadge {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;

  const CosmicBadge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
  });

  CosmicBadge copyWith({bool? isUnlocked}) {
    return CosmicBadge(
      id: id,
      title: title,
      description: description,
      icon: icon,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'icon': icon,
        'isUnlocked': isUnlocked,
      };

  factory CosmicBadge.fromJson(Map<String, dynamic> json) => CosmicBadge(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        icon: json['icon'] as String,
        isUnlocked: json['isUnlocked'] as bool? ?? false,
      );
}

class GamificationState {
  final int streakDays;
  final int karmaXp;
  final String lastActiveDate;
  final Set<String> completedTasksToday;
  final List<CosmicBadge> badges;
  final double yesterdayScore;
  final String? todayMood;
  final Map<String, String> moodHistory;

  const GamificationState({
    required this.streakDays,
    required this.karmaXp,
    required this.lastActiveDate,
    required this.completedTasksToday,
    required this.badges,
    required this.yesterdayScore,
    this.todayMood,
    this.moodHistory = const {},
  });

  GamificationState copyWith({
    int? streakDays,
    int? karmaXp,
    String? lastActiveDate,
    Set<String>? completedTasksToday,
    List<CosmicBadge>? badges,
    double? yesterdayScore,
    String? todayMood,
    Map<String, String>? moodHistory,
  }) {
    return GamificationState(
      streakDays: streakDays ?? this.streakDays,
      karmaXp: karmaXp ?? this.karmaXp,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      completedTasksToday: completedTasksToday ?? this.completedTasksToday,
      badges: badges ?? this.badges,
      yesterdayScore: yesterdayScore ?? this.yesterdayScore,
      todayMood: todayMood ?? this.todayMood,
      moodHistory: moodHistory ?? this.moodHistory,
    );
  }
}

class GamificationNotifier extends StateNotifier<GamificationState> {
  GamificationNotifier()
      : super(
          const GamificationState(
            streakDays: 1,
            karmaXp: 15,
            lastActiveDate: '',
            completedTasksToday: {},
            badges: _defaultBadges,
            yesterdayScore: 7.8,
            todayMood: null,
            moodHistory: {},
          ),
        ) {
    loadState();
  }

  static const List<CosmicBadge> _defaultBadges = [
    CosmicBadge(
      id: 'first_light',
      title: 'First Light',
      description: 'Completed your first daily cosmic check-in',
      icon: '🌅',
    ),
    CosmicBadge(
      id: 'japa_devotee',
      title: 'Japa Devotee',
      description: 'Chanted 108 beads on the sacred counter',
      icon: '📿',
    ),
    CosmicBadge(
      id: 'streak_3',
      title: 'Cosmic Discipline',
      description: 'Maintained a 3-day celestial habit streak',
      icon: '🔥',
    ),
    CosmicBadge(
      id: 'streak_7',
      title: 'Astro Master',
      description: 'Maintained a 7-day celestial discipline streak',
      icon: '⭐',
    ),
    CosmicBadge(
      id: 'karma_100',
      title: 'Karma Centurion',
      description: 'Accumulated over 100 Karma XP through mindful rituals',
      icon: '💎',
    ),
  ];

  static String _formatDate(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _formatDate(DateTime.now());
    final yesterday = _formatDate(DateTime.now().subtract(const Duration(days: 1)));

    final lastDate = prefs.getString('game_last_active_date') ?? '';
    int streak = prefs.getInt('game_streak_days') ?? 1;
    int xp = prefs.getInt('game_karma_xp') ?? 15;

    // Check streak continuation across dates
    if (lastDate.isNotEmpty && lastDate != today) {
      if (lastDate == yesterday) {
        // Consecutive day launch: increment streak
        streak += 1;
        await prefs.setInt('game_streak_days', streak);
      } else {
        // Missed one or more days: reset to 1
        streak = 1;
        await prefs.setInt('game_streak_days', streak);
      }
    }
    await prefs.setString('game_last_active_date', today);

    // Load tasks completed today
    final rawTasks = prefs.getStringList('game_tasks_$today') ?? [];
    final completedTasks = rawTasks.toSet();

    // Load badges
    final rawBadges = prefs.getString('game_badges');
    List<CosmicBadge> badges = List.of(_defaultBadges);
    if (rawBadges != null) {
      try {
        final List decoded = jsonDecode(rawBadges);
        final unlockedIds = decoded.where((e) => e['isUnlocked'] == true).map((e) => e['id'] as String).toSet();
        badges = _defaultBadges.map((b) => b.copyWith(isUnlocked: unlockedIds.contains(b.id))).toList();
      } catch (_) {}
    }

    // Load yesterday's recorded score (or fallback to yesterday's stored value)
    final yScore = prefs.getDouble('score_$yesterday') ?? prefs.getDouble('score_latest_yesterday') ?? 7.6;

    // Load today's mood & mood history
    final todayMood = prefs.getString('today_mood_$today');
    Map<String, String> history = {};
    final rawHistory = prefs.getString('user_mood_history');
    if (rawHistory != null) {
      try {
        history = Map<String, String>.from(jsonDecode(rawHistory) as Map);
      } catch (_) {}
    }

    state = GamificationState(
      streakDays: streak,
      karmaXp: xp,
      lastActiveDate: today,
      completedTasksToday: completedTasks,
      badges: badges,
      yesterdayScore: yScore,
      todayMood: todayMood,
      moodHistory: history,
    );

    _evaluateBadges();
  }

  /// Records today's daily cosmic score for yesterday-comparison tracking
  Future<void> recordTodayScore(double score) async {
    final prefs = await SharedPreferences.getInstance();
    final today = _formatDate(DateTime.now());
    final existingTodayScore = prefs.getDouble('score_$today');

    if (existingTodayScore == null) {
      // If setting today's score for the first time, save previous latest as yesterday
      final prevScore = prefs.getDouble('score_latest_today');
      if (prevScore != null) {
        await prefs.setDouble('score_latest_yesterday', prevScore);
      }
      await prefs.setDouble('score_$today', score);
      await prefs.setDouble('score_latest_today', score);
    }
  }

  /// Records today's mood and persists in mood history + awards check-in XP
  Future<void> recordMood(String mood) async {
    final today = _formatDate(DateTime.now());
    final prefs = await SharedPreferences.getInstance();

    final updatedHistory = Map<String, String>.from(state.moodHistory);
    updatedHistory[today] = mood;

    await prefs.setString('today_mood_$today', mood);
    await prefs.setString('user_mood_history', jsonEncode(updatedHistory));

    state = state.copyWith(
      todayMood: mood,
      moodHistory: updatedHistory,
    );

    await completeTask('dailyCheckIn', 5);
  }

  /// Completes a task for today and awards Karma XP (prevents duplicate rewards)
  Future<int> completeTask(String taskId, int xpReward) async {
    final today = _formatDate(DateTime.now());
    if (state.completedTasksToday.contains(taskId)) {
      return 0; // Already completed today, no duplicate XP
    }

    final prefs = await SharedPreferences.getInstance();
    final updatedTasks = Set<String>.from(state.completedTasksToday)..add(taskId);
    final updatedXp = state.karmaXp + xpReward;

    await prefs.setStringList('game_tasks_$today', updatedTasks.toList());
    await prefs.setInt('game_karma_xp', updatedXp);

    state = state.copyWith(
      karmaXp: updatedXp,
      completedTasksToday: updatedTasks,
    );

    _evaluateBadges();
    return xpReward;
  }

  void _evaluateBadges() async {
    final prefs = await SharedPreferences.getInstance();
    final updatedBadges = state.badges.map((badge) {
      bool shouldUnlock = badge.isUnlocked;

      if (badge.id == 'first_light' && state.completedTasksToday.isNotEmpty) {
        shouldUnlock = true;
      }
      if (badge.id == 'japa_devotee' && state.completedTasksToday.contains('japa108')) {
        shouldUnlock = true;
      }
      if (badge.id == 'streak_3' && state.streakDays >= 3) {
        shouldUnlock = true;
      }
      if (badge.id == 'streak_7' && state.streakDays >= 7) {
        shouldUnlock = true;
      }
      if (badge.id == 'karma_100' && state.karmaXp >= 100) {
        shouldUnlock = true;
      }

      return badge.copyWith(isUnlocked: shouldUnlock);
    }).toList();

    state = state.copyWith(badges: updatedBadges);
    await prefs.setString('game_badges', jsonEncode(updatedBadges.map((e) => e.toJson()).toList()));
  }
}

final gamificationProvider = StateNotifierProvider<GamificationNotifier, GamificationState>((ref) {
  return GamificationNotifier();
});
