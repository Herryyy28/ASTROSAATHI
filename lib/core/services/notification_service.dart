import 'package:flutter/foundation.dart';

/// Platform-agnostic Notification Service for AstroSaathi.
/// Manages scheduled alerts, morning score push notifications, and local timers.
class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  bool _isInitialized = false;
  final Map<int, DateTime> _scheduledTimers = {};

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    debugPrint('✦ NotificationService initialized successfully.');
  }

  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    debugPrint('🔔 [Astro Notification #$id] $title — $body (Payload: $payload)');
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (scheduledDate.isBefore(DateTime.now())) return;

    _scheduledTimers[id] = scheduledDate;
    debugPrint(
      '⏰ [Scheduled Notification #$id] "$title" set for ${scheduledDate.toIso8601String()}',
    );
  }

  Future<void> cancelNotification(int id) async {
    _scheduledTimers.remove(id);
    debugPrint('🚫 [Cancelled Notification #$id]');
  }

  bool isScheduled(int id) {
    return _scheduledTimers.containsKey(id);
  }
}
