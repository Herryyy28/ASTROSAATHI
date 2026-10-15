import 'package:flutter/foundation.dart';
import 'birth_details.dart';

@immutable
class MatchProfile {
  final String id;
  final String name;
  final String gender; // 'male' or 'female'
  final BirthDetails birthDetails;

  const MatchProfile({
    required this.id,
    required this.name,
    required this.gender,
    required this.birthDetails,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'gender': gender,
        'birthDetails': birthDetails.toJson(),
      };

  factory MatchProfile.fromJson(Map<String, dynamic> json) {
    return MatchProfile(
      id: json['id'] as String? ?? 'profile_${DateTime.now().millisecondsSinceEpoch}',
      name: json['name'] as String? ?? 'Profile',
      gender: json['gender'] as String? ?? 'male',
      birthDetails: json['birthDetails'] != null
          ? BirthDetails.fromJson(json['birthDetails'] as Map<String, dynamic>)
          : BirthDetails.defaultDelhi,
    );
  }
}

@immutable
class GunaScore {
  final String kootaName; // Varna, Vashya, Tara, Yoni, Graha Maitri, Gana, Bhakoot, Nadi
  final double maxScore; // 1, 2, 3, 4, 5, 6, 7, 8
  final double obtainedScore;
  final String description;
  final String status; // 'Excellent', 'Good', 'Average', 'Dosha'

  const GunaScore({
    required this.kootaName,
    required this.maxScore,
    required this.obtainedScore,
    required this.description,
    this.status = 'Good',
  });

  bool get isPassed => obtainedScore >= (maxScore / 2);

  Map<String, dynamic> toJson() => {
        'kootaName': kootaName,
        'maxScore': maxScore,
        'obtainedScore': obtainedScore,
        'description': description,
        'status': status,
      };

  factory GunaScore.fromJson(Map<String, dynamic> json) {
    return GunaScore(
      kootaName: json['kootaName'] as String? ?? '',
      maxScore: (json['maxScore'] as num?)?.toDouble() ?? 1.0,
      obtainedScore: (json['obtainedScore'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'Good',
    );
  }
}

@immutable
class CompatibilityResult {
  final MatchProfile firstProfile;
  final MatchProfile secondProfile;
  final double totalScore; // e.g., 28.5 / 36
  final double maxScore; // 36.0
  final double percentage;
  final List<GunaScore> gunas;
  final String manglikStatus; // 'Both Non-Manglik', 'Compatible', 'Manglik Dosha Present'
  final String summary;
  final String recommendation; // 'Highly Auspicious', 'Favorable', 'Remedies Required', 'Not Recommended'

  const CompatibilityResult({
    required this.firstProfile,
    required this.secondProfile,
    required this.totalScore,
    this.maxScore = 36.0,
    required this.percentage,
    required this.gunas,
    required this.manglikStatus,
    required this.summary,
    required this.recommendation,
  });

  bool get isCompatible => totalScore >= 18.0;

  Map<String, dynamic> toJson() => {
        'firstProfile': firstProfile.toJson(),
        'secondProfile': secondProfile.toJson(),
        'totalScore': totalScore,
        'maxScore': maxScore,
        'percentage': percentage,
        'gunas': gunas.map((g) => g.toJson()).toList(),
        'manglikStatus': manglikStatus,
        'summary': summary,
        'recommendation': recommendation,
      };

  factory CompatibilityResult.fromJson(Map<String, dynamic> json) {
    return CompatibilityResult(
      firstProfile: json['firstProfile'] != null
          ? MatchProfile.fromJson(json['firstProfile'] as Map<String, dynamic>)
          : const MatchProfile(
              id: 'p1',
              name: 'First Seeker',
              gender: 'male',
              birthDetails: BirthDetails.defaultDelhi,
            ),
      secondProfile: json['secondProfile'] != null
          ? MatchProfile.fromJson(json['secondProfile'] as Map<String, dynamic>)
          : const MatchProfile(
              id: 'p2',
              name: 'Second Seeker',
              gender: 'female',
              birthDetails: BirthDetails.defaultDelhi,
            ),
      totalScore: (json['totalScore'] as num?)?.toDouble() ?? 28.0,
      maxScore: (json['maxScore'] as num?)?.toDouble() ?? 36.0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 77.7,
      gunas: (json['gunas'] as List<dynamic>?)
              ?.map((e) => GunaScore.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      manglikStatus: json['manglikStatus'] as String? ?? 'Compatible',
      summary: json['summary'] as String? ?? 'High spiritual and mental compatibility.',
      recommendation: json['recommendation'] as String? ?? 'Favorable Alliance',
    );
  }
}
