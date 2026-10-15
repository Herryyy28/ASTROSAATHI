import 'package:flutter/foundation.dart';

@immutable
class AiAstrologerPersona {
  final String id;
  final String name;
  final String title;
  final String description;
  final String avatarAsset;
  final String specialty;

  const AiAstrologerPersona({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.avatarAsset,
    required this.specialty,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'title': title,
        'description': description,
        'avatarAsset': avatarAsset,
        'specialty': specialty,
      };

  factory AiAstrologerPersona.fromJson(Map<String, dynamic> json) {
    return AiAstrologerPersona(
      id: json['id'] as String? ?? 'baba',
      name: json['name'] as String? ?? 'Astro Baba',
      title: json['title'] as String? ?? 'Cosmic Sage',
      description: json['description'] as String? ?? '',
      avatarAsset: json['avatarAsset'] as String? ?? '',
      specialty: json['specialty'] as String? ?? 'General Guidance',
    );
  }
}

@immutable
class AiMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<String> suggestions;

  const AiMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.suggestions = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
        'suggestions': suggestions,
      };

  factory AiMessage.fromJson(Map<String, dynamic> json) {
    return AiMessage(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      isUser: json['isUser'] as bool? ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      suggestions: (json['suggestions'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
