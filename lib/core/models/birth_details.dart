import 'package:flutter/foundation.dart';
import '../errors/app_exceptions.dart';

@immutable
class BirthDetails {
  final String name;
  final String dob; // Format: YYYY-MM-DD
  final String birthTime; // Format: HH:mm (24hr) or hh:mm a
  final String birthPlace;
  final double latitude;
  final double longitude;
  final String timezone; // e.g. "5.5" or "+05:30"
  final String gender; // "male", "female", "other"

  const BirthDetails({
    required this.name,
    required this.dob,
    required this.birthTime,
    required this.birthPlace,
    required this.latitude,
    required this.longitude,
    this.timezone = '5.5',
    this.gender = 'male',
  });

  /// Default Delhi coordinates fallback for initialization
  static const BirthDetails defaultDelhi = BirthDetails(
    name: 'Seeker',
    dob: '1995-01-01',
    birthTime: '12:00',
    birthPlace: 'New Delhi, India',
    latitude: 28.6139,
    longitude: 77.2090,
    timezone: '5.5',
    gender: 'male',
  );

  /// Validates all fields and throws a [ValidationException] if any check fails.
  void validate() {
    final errors = <String, String>{};

    if (name.trim().isEmpty) {
      errors['name'] = 'Name cannot be empty';
    }

    if (!_isValidDateFormat(dob)) {
      errors['dob'] = 'Invalid date of birth. Expected YYYY-MM-DD.';
    }

    if (birthTime.trim().isEmpty) {
      errors['birthTime'] = 'Birth time cannot be empty';
    }

    if (birthPlace.trim().isEmpty) {
      errors['birthPlace'] = 'Birth place cannot be empty';
    }

    if (latitude < -90.0 || latitude > 90.0) {
      errors['latitude'] = 'Latitude must be between -90 and 90';
    }

    if (longitude < -180.0 || longitude > 180.0) {
      errors['longitude'] = 'Longitude must be between -180 and 180';
    }

    if (errors.isNotEmpty) {
      throw ValidationException(
        'Invalid birth details: ${errors.values.join(', ')}',
        fieldErrors: errors,
      );
    }
  }

  bool get isValid {
    try {
      validate();
      return true;
    } catch (_) {
      return false;
    }
  }

  static bool _isValidDateFormat(String value) {
    if (value.trim().isEmpty) return false;
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(value)) return false;
    final parts = value.split('-');
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return false;
    if (year < 1900 || year > 2100) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;
    return true;
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'dob': dob,
        'birthTime': birthTime,
        'birthPlace': birthPlace,
        'latitude': latitude,
        'longitude': longitude,
        'timezone': timezone,
        'gender': gender,
      };

  factory BirthDetails.fromJson(Map<String, dynamic> json) {
    return BirthDetails(
      name: json['name'] as String? ?? '',
      dob: json['dob'] as String? ?? '',
      birthTime: json['birthTime'] as String? ?? '12:00',
      birthPlace: json['birthPlace'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 28.6139,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.2090,
      timezone: json['timezone'] as String? ?? '5.5',
      gender: json['gender'] as String? ?? 'male',
    );
  }

  BirthDetails copyWith({
    String? name,
    String? dob,
    String? birthTime,
    String? birthPlace,
    double? latitude,
    double? longitude,
    String? timezone,
    String? gender,
  }) {
    return BirthDetails(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      gender: gender ?? this.gender,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BirthDetails &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          dob == other.dob &&
          birthTime == other.birthTime &&
          birthPlace == other.birthPlace &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          timezone == other.timezone &&
          gender == other.gender;

  @override
  int get hashCode => Object.hash(
        name,
        dob,
        birthTime,
        birthPlace,
        latitude,
        longitude,
        timezone,
        gender,
      );

  @override
  String toString() =>
      'BirthDetails(name: $name, dob: $dob, time: $birthTime, place: $birthPlace, lat: $latitude, lon: $longitude)';
}
