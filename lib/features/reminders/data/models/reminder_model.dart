import 'package:flutter/material.dart';

enum EventCategory {
  business('Business', Icons.business_center_rounded, Color(0xFFD9901A)),
  meeting('Meeting', Icons.groups_rounded, Color(0xFF45A77D)),
  travel('Travel', Icons.flight_takeoff_rounded, Color(0xFF70A0D4)),
  investment('Investment', Icons.trending_up_rounded, Color(0xFF45A77D)),
  contract('Contract', Icons.description_rounded, Color(0xFFD6A044)),
  marriage('Marriage', Icons.favorite_rounded, Color(0xFFE5A63C)),
  property('Property', Icons.home_work_rounded, Color(0xFF70A0D4)),
  medical('Medical', Icons.local_hospital_rounded, Color(0xFFDE6B6B)),
  personal('Personal', Icons.person_rounded, Color(0xFFAAB3C2));

  final String label;
  final IconData icon;
  final Color color;

  const EventCategory(this.label, this.icon, this.color);
}

class UserReminder {
  final String id;
  final String userId;
  final String title;
  final EventCategory category;
  final DateTime eventTime;
  final String? notes;
  final double astroScore;
  final String astroRecommendation;
  final bool reminderEnabled;
  final int leadTimeMinutes;

  UserReminder({
    required this.id,
    required this.userId,
    required this.title,
    required this.category,
    required this.eventTime,
    this.notes,
    this.astroScore = 8.0,
    required this.astroRecommendation,
    this.reminderEnabled = true,
    this.leadTimeMinutes = 20,
  });

  factory UserReminder.fromJson(Map<String, dynamic> json) {
    EventCategory cat;
    try {
      cat = EventCategory.values.firstWhere(
        (c) => c.label.toLowerCase() == (json['category'] as String? ?? '').toLowerCase(),
        orElse: () => EventCategory.business,
      );
    } catch (_) {
      cat = EventCategory.business;
    }

    return UserReminder(
      id: json['id'] as String? ?? UniqueKey().toString(),
      userId: json['userId'] as String? ?? 'guest-user',
      title: json['title'] as String? ?? 'Untitled Event',
      category: cat,
      eventTime: json['eventTime'] != null ? DateTime.parse(json['eventTime']) : DateTime.now(),
      notes: json['notes'] as String?,
      astroScore: (json['astroScore'] as num?)?.toDouble() ?? 8.0,
      astroRecommendation: json['astroRecommendation'] as String? ?? 'Favorable planetary alignment.',
      reminderEnabled: json['reminderEnabled'] as bool? ?? true,
      leadTimeMinutes: json['leadTimeMinutes'] as int? ?? 20,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'category': category.label,
      'eventTime': eventTime.toIso8601String(),
      'notes': notes,
      'astroScore': astroScore,
      'astroRecommendation': astroRecommendation,
      'reminderEnabled': reminderEnabled,
      'leadTimeMinutes': leadTimeMinutes,
    };
  }

  UserReminder copyWith({
    String? id,
    String? userId,
    String? title,
    EventCategory? category,
    DateTime? eventTime,
    String? notes,
    double? astroScore,
    String? astroRecommendation,
    bool? reminderEnabled,
    int? leadTimeMinutes,
  }) {
    return UserReminder(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      category: category ?? this.category,
      eventTime: eventTime ?? this.eventTime,
      notes: notes ?? this.notes,
      astroScore: astroScore ?? this.astroScore,
      astroRecommendation: astroRecommendation ?? this.astroRecommendation,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      leadTimeMinutes: leadTimeMinutes ?? this.leadTimeMinutes,
    );
  }
}
