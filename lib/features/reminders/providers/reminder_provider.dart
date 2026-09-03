import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';
import '../data/models/reminder_model.dart';

class ReminderState {
  final List<UserReminder> reminders;
  final bool isLoading;
  final bool morningScoreNotification;
  final bool rahuKaalNotification;
  final bool shubhMuhuratNotification;
  final String morningScoreTime;

  ReminderState({
    this.reminders = const [],
    this.isLoading = false,
    this.morningScoreNotification = true,
    this.rahuKaalNotification = true,
    this.shubhMuhuratNotification = true,
    this.morningScoreTime = '07:00 AM',
  });

  ReminderState copyWith({
    List<UserReminder>? reminders,
    bool? isLoading,
    bool? morningScoreNotification,
    bool? rahuKaalNotification,
    bool? shubhMuhuratNotification,
    String? morningScoreTime,
  }) {
    return ReminderState(
      reminders: reminders ?? this.reminders,
      isLoading: isLoading ?? this.isLoading,
      morningScoreNotification: morningScoreNotification ?? this.morningScoreNotification,
      rahuKaalNotification: rahuKaalNotification ?? this.rahuKaalNotification,
      shubhMuhuratNotification: shubhMuhuratNotification ?? this.shubhMuhuratNotification,
      morningScoreTime: morningScoreTime ?? this.morningScoreTime,
    );
  }
}

class ReminderNotifier extends StateNotifier<ReminderState> {
  ReminderNotifier() : super(ReminderState()) {
    _initDefaultSampleReminders();
  }

  void _initDefaultSampleReminders() {
    final now = DateTime.now();
    final sampleList = [
      UserReminder(
        id: 'sample-1',
        userId: 'primary',
        title: 'Executive Client Contract Signing',
        category: EventCategory.contract,
        eventTime: DateTime(now.year, now.month, now.day, 10, 45),
        astroScore: 9.2,
        astroRecommendation: '✦ Peak Alignment. Mercury & Jupiter in benefic trine favorable for deals.',
        reminderEnabled: true,
        leadTimeMinutes: 20,
      ),
      UserReminder(
        id: 'sample-2',
        userId: 'primary',
        title: 'Strategic Partnership Discussion',
        category: EventCategory.business,
        eventTime: DateTime(now.year, now.month, now.day + 1, 14, 0),
        astroScore: 8.5,
        astroRecommendation: 'Auspicious timing. Moon in 10th house favors executive authority.',
        reminderEnabled: true,
        leadTimeMinutes: 20,
      ),
    ];

    state = state.copyWith(reminders: sampleList);
  }

  Future<void> addReminder({
    required String title,
    required EventCategory category,
    required DateTime eventTime,
    String? notes,
    int leadTimeMinutes = 20,
  }) async {
    final score = _calculateLocalAstroScore(category, eventTime);
    final rec = _generateLocalRecommendation(category, score);

    final newReminder = UserReminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'primary',
      title: title,
      category: category,
      eventTime: eventTime,
      notes: notes,
      astroScore: score,
      astroRecommendation: rec,
      reminderEnabled: true,
      leadTimeMinutes: leadTimeMinutes,
    );

    state = state.copyWith(reminders: [...state.reminders, newReminder]);

    // Schedule local push notification
    final scheduledDate = eventTime.subtract(Duration(minutes: leadTimeMinutes));
    await NotificationService.instance.scheduleNotification(
      id: newReminder.id.hashCode,
      title: '✦ Astro Reminder: $title',
      body: 'Scheduled in $leadTimeMinutes mins. Astro Score: $score/10. $rec',
      scheduledDate: scheduledDate,
    );
  }

  Future<void> toggleReminder(String id) async {
    final updatedList = state.reminders.map((r) {
      if (r.id == id) {
        final nextState = !r.reminderEnabled;
        if (!nextState) {
          NotificationService.instance.cancelNotification(r.id.hashCode);
        } else {
          final scheduledDate = r.eventTime.subtract(Duration(minutes: r.leadTimeMinutes));
          NotificationService.instance.scheduleNotification(
            id: r.id.hashCode,
            title: '✦ Astro Reminder: ${r.title}',
            body: 'Scheduled in ${r.leadTimeMinutes} mins. Astro Score: ${r.astroScore}/10.',
            scheduledDate: scheduledDate,
          );
        }
        return r.copyWith(reminderEnabled: nextState);
      }
      return r;
    }).toList();

    state = state.copyWith(reminders: updatedList);
  }

  Future<void> deleteReminder(String id) async {
    NotificationService.instance.cancelNotification(id.hashCode);
    final updatedList = state.reminders.where((r) => r.id != id).toList();
    state = state.copyWith(reminders: updatedList);
  }

  void updateSettings({
    bool? morningScore,
    bool? rahuKaal,
    bool? shubhMuhurat,
    String? morningTime,
  }) {
    state = state.copyWith(
      morningScoreNotification: morningScore ?? state.morningScoreNotification,
      rahuKaalNotification: rahuKaal ?? state.rahuKaalNotification,
      shubhMuhuratNotification: shubhMuhurat ?? state.shubhMuhuratNotification,
      morningScoreTime: morningTime ?? state.morningScoreTime,
    );
  }

  double _calculateLocalAstroScore(EventCategory cat, DateTime dt) {
    final hour = dt.hour;
    double score = 7.8;
    if (hour >= 10 && hour <= 12) score += 1.4;
    else if (hour >= 13 && hour <= 15) score -= 1.2;
    else if (hour >= 16 && hour <= 18) score += 0.8;
    return min(10.0, max(4.0, double.parse(score.toStringAsFixed(1))));
  }

  String _generateLocalRecommendation(EventCategory cat, double score) {
    if (score >= 8.5) return '✦ Peak Astrological Alignment (${score}/10). Ideal timing for ${cat.label.toLowerCase()} success.';
    if (score >= 6.5) return 'Favorable alignment (${score}/10). Good window for ${cat.label.toLowerCase()}.';
    return '⚠️ Caution Window (${score}/10). Consider shifting time by 30 mins to avoid Rahu Kaal.';
  }
}

final reminderProvider = StateNotifierProvider<ReminderNotifier, ReminderState>((ref) {
  return ReminderNotifier();
});
