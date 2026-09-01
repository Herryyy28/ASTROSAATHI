import 'package:flutter/foundation.dart';

/// Exception thrown when astrology calculation fails or inputs are invalid.
class AstrologyValidationException implements Exception {
  final String message;
  final String? code;

  const AstrologyValidationException([
    this.message = 'Astrology data could not be calculated.\nPlease check your birth details. Retry',
    this.code,
  ]);

  factory AstrologyValidationException.fromCode(String code) {
    switch (code) {
      case 'FUTURE_DATE':
        return AstrologyValidationException('Birth date cannot be in the future. Please correct the date.', code);
      case 'DATE_OUT_OF_RANGE':
        return AstrologyValidationException('Birth year must be between 1800 and 2100.', code);
      case 'INVALID_LATITUDE':
      case 'INVALID_LONGITUDE':
        return AstrologyValidationException('Please select a valid city/location from the dropdown.', code);
      case 'INVALID_TIME':
      case 'TIME_OUT_OF_RANGE':
        return AstrologyValidationException('Please enter a valid birth time (e.g., 07:30 AM).', code);
      default:
        return AstrologyValidationException('Astrology data could not be calculated.\nPlease check your birth details. Retry', code);
    }
  }

  @override
  String toString() => message;
}

/// System metadata attached to every dynamic astrology result for data quality tracking.
@immutable
class DataQualityMetadata {
  final String source;
  final String calculatedAt;
  final String engineVersion;
  final String timezone;
  final double latitude;
  final double longitude;
  final String profileId;

  const DataQualityMetadata({
    this.source = 'Internal Calculation Engine',
    required this.calculatedAt,
    this.engineVersion = '1.0.0-vedic',
    required this.timezone,
    required this.latitude,
    required this.longitude,
    required this.profileId,
  });

  Map<String, dynamic> toJson() => {
        'source': source,
        'calculatedAt': calculatedAt,
        'engineVersion': engineVersion,
        'timezone': timezone,
        'latitude': latitude,
        'longitude': longitude,
        'profileId': profileId,
      };

  factory DataQualityMetadata.fromJson(Map<String, dynamic> json) {
    return DataQualityMetadata(
      source: json['source'] ?? 'Internal Calculation Engine',
      calculatedAt: json['calculatedAt'] ?? '',
      engineVersion: json['engineVersion'] ?? '1.0.0-vedic',
      timezone: json['timezone'] ?? '+05:30',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 28.6139,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.2090,
      profileId: json['profileId'] ?? 'default',
    );
  }
}

/// Strict input & output validator for Vedic astrology calculations.
class AstrologyValidator {
  static const String defaultErrorMessage =
      'Astrology data could not be calculated.\nPlease check your birth details. Retry';

  /// Robust date parser supporting ISO (YYYY-MM-DD), DD/MM/YYYY, DD-MM-YYYY, etc.
  static DateTime parseDate(String dateStr) {
    final cleaned = dateStr.trim();
    if (cleaned.isEmpty) {
      throw const AstrologyValidationException(defaultErrorMessage, 'EMPTY_DATE');
    }

    // Try standard ISO parsing first
    final parsed = DateTime.tryParse(cleaned);
    if (parsed != null) return parsed;

    // Try parsing DD/MM/YYYY or DD-MM-YYYY or DD.MM.YYYY
    final normalized = cleaned.replaceAll('-', '/').replaceAll('.', '/').replaceAll(' ', '');
    final parts = normalized.split('/');
    if (parts.length == 3) {
      int? d = int.tryParse(parts[0]);
      int? m = int.tryParse(parts[1]);
      int? y = int.tryParse(parts[2]);

      // If YYYY/MM/DD
      if (parts[0].length == 4) {
        y = int.tryParse(parts[0]);
        m = int.tryParse(parts[1]);
        d = int.tryParse(parts[2]);
      }

      if (y != null && m != null && d != null && m >= 1 && m <= 12 && d >= 1 && d <= 31) {
        return DateTime(y, m, d);
      }
    }

    throw const AstrologyValidationException(defaultErrorMessage, 'INVALID_DATE');
  }

  /// Validates date string
  static void validateDate(String dateStr) {
    final parsed = parseDate(dateStr);
    if (parsed.year < 1800 || parsed.year > 2100) {
      throw AstrologyValidationException.fromCode('DATE_OUT_OF_RANGE');
    }
    if (parsed.isAfter(DateTime.now())) {
      throw AstrologyValidationException.fromCode('FUTURE_DATE');
    }
  }

  /// Validates birth time string supporting HH:mm, HH:mm:ss, HH:mm AM/PM
  static void validateTime(String timeStr) {
    final cleaned = timeStr.trim();
    if (cleaned.isEmpty) {
      throw AstrologyValidationException.fromCode('EMPTY_TIME');
    }

    final lower = cleaned.toLowerCase();
    final isPm = lower.contains('pm');
    final isAm = lower.contains('am');
    final digitsOnly = cleaned.replaceAll(RegExp(r'[^0-9:]'), '');
    final parts = digitsOnly.split(':');
    if (parts.length < 2) {
      throw const AstrologyValidationException(defaultErrorMessage, 'INVALID_TIME');
    }

    var hour = int.tryParse(parts[0]);
    final min = int.tryParse(parts[1]);

    if (hour == null || min == null) {
      throw const AstrologyValidationException(defaultErrorMessage, 'INVALID_TIME');
    }

    if (isPm && hour < 12) hour += 12;
    if (isAm && hour == 12) hour = 0;

    if (hour < 0 || hour > 23 || min < 0 || min > 59) {
      throw const AstrologyValidationException(defaultErrorMessage, 'TIME_OUT_OF_RANGE');
    }
  }

  /// Validates coordinates and timezone
  static void validateCoordinates(double lat, double lon, double tz) {
    if (lat < -90.0 || lat > 90.0) {
      throw AstrologyValidationException.fromCode('INVALID_LATITUDE');
    }
    if (lon < -180.0 || lon > 180.0) {
      throw AstrologyValidationException.fromCode('INVALID_LONGITUDE');
    }
    if (tz < -12.0 || tz > 14.0) {
      throw AstrologyValidationException.fromCode('INVALID_TIMEZONE');
    }
  }

  /// Validates birth chart data output structure for integrity
  static void validateBirthChartOutput(Map<String, dynamic> chart) {
    if (chart.isEmpty) {
      throw const AstrologyValidationException(defaultErrorMessage, 'EMPTY_CHART');
    }

    final lagna = chart['lagna'];
    if (lagna == null || lagna.toString().trim().isEmpty) {
      throw const AstrologyValidationException(defaultErrorMessage, 'MISSING_ASCENDANT');
    }

    // Check planetary duplicate anomalies
    final planets = chart['planets'];
    if (planets is List) {
      final names = <String>{};
      for (final p in planets) {
        if (p is Map) {
          final name = p['name']?.toString();
          final house = (p['house'] as num?)?.toInt();
          if (name != null && names.contains(name)) {
            throw const AstrologyValidationException(defaultErrorMessage, 'DUPLICATE_PLANET');
          }
          if (name != null) names.add(name);

          if (house != null && (house < 1 || house > 12)) {
            throw const AstrologyValidationException(defaultErrorMessage, 'INVALID_HOUSE_ASSIGNMENT');
          }
        }
      }
    }
  }
}
