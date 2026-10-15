import 'package:flutter/foundation.dart';

@immutable
class Astrologer {
  final String id;
  final String name;
  final String title;
  final List<String> specialties; // Vedic, KP, Numerology, Tarot, Vastu
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final double perMinuteRate; // In local currency
  final bool isOnline;
  final List<String> languages;
  final String? avatarUrl;
  final String bio;

  const Astrologer({
    required this.id,
    required this.name,
    required this.title,
    required this.specialties,
    required this.rating,
    required this.reviewCount,
    required this.experienceYears,
    required this.perMinuteRate,
    this.isOnline = true,
    required this.languages,
    this.avatarUrl,
    this.bio = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'specialties': specialties,
        'rating': rating,
        'reviewCount': reviewCount,
        'experienceYears': experienceYears,
        'perMinuteRate': perMinuteRate,
        'isOnline': isOnline,
        'languages': languages,
        'avatarUrl': avatarUrl,
        'bio': bio,
      };

  factory Astrologer.fromJson(Map<String, dynamic> json) {
    return Astrologer(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Acharya Ji',
      title: json['title'] as String? ?? 'Senior Vedic Astrologer',
      specialties: (json['specialties'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Vedic Astrology', 'Kundli Expert'],
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 1250,
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 15,
      perMinuteRate: (json['perMinuteRate'] as num?)?.toDouble() ?? 25.0,
      isOnline: json['isOnline'] as bool? ?? true,
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          ['Hindi', 'English'],
      avatarUrl: json['avatarUrl'] as String?,
      bio: json['bio'] as String? ?? '',
    );
  }
}

enum ConsultationType { chat, call, video }
enum ConsultationStatus { requested, active, completed, cancelled }

@immutable
class ConsultationSession {
  final String id;
  final String astrologerId;
  final String astrologerName;
  final String seekerId;
  final ConsultationType type;
  final ConsultationStatus status;
  final DateTime startTime;
  final int durationSeconds;
  final double totalCost;

  const ConsultationSession({
    required this.id,
    required this.astrologerId,
    required this.astrologerName,
    required this.seekerId,
    required this.type,
    required this.status,
    required this.startTime,
    this.durationSeconds = 0,
    this.totalCost = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'astrologerId': astrologerId,
        'astrologerName': astrologerName,
        'seekerId': seekerId,
        'type': type.name,
        'status': status.name,
        'startTime': startTime.toIso8601String(),
        'durationSeconds': durationSeconds,
        'totalCost': totalCost,
      };

  factory ConsultationSession.fromJson(Map<String, dynamic> json) {
    return ConsultationSession(
      id: json['id'] as String? ?? '',
      astrologerId: json['astrologerId'] as String? ?? '',
      astrologerName: json['astrologerName'] as String? ?? '',
      seekerId: json['seekerId'] as String? ?? '',
      type: ConsultationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ConsultationType.chat,
      ),
      status: ConsultationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ConsultationStatus.completed,
      ),
      startTime: json['startTime'] != null
          ? DateTime.tryParse(json['startTime'] as String) ?? DateTime.now()
          : DateTime.now(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
