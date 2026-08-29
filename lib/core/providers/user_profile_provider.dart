import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

class UserProfile {
  final String name;
  final String dob;
  final String time;
  final String place;
  final double latitude;
  final double longitude;
  final String timeZone;

  UserProfile({
    required this.name,
    required this.dob,
    required this.time,
    required this.place,
    required this.latitude,
    required this.longitude,
    required this.timeZone,
  });

  UserProfile copyWith({
    String? name,
    String? dob,
    String? time,
    String? place,
    double? latitude,
    double? longitude,
    String? timeZone,
  }) {
    return UserProfile(
      name: name ?? this.name,
      dob: dob ?? this.dob,
      time: time ?? this.time,
      place: place ?? this.place,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timeZone: timeZone ?? this.timeZone,
    );
  }
}

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier()
      : super(UserProfile(
          name: '',
          dob: '',
          time: '',
          place: '',
          latitude: 28.6139, // Default to New Delhi
          longitude: 77.2090,
          timeZone: '5.5',
        )) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    state = UserProfile(
      name: prefs.getString('user_name') ?? '',
      dob: prefs.getString('user_dob') ?? '',
      time: prefs.getString('user_time') ?? '',
      place: prefs.getString('user_place') ?? '',
      latitude: prefs.getDouble('user_lat') ?? 28.6139,
      longitude: prefs.getDouble('user_lon') ?? 77.2090,
      timeZone: prefs.getString('user_tz') ?? '5.5',
    );
  }

  Future<void> updateProfile({
    required String name,
    required String dob,
    required String time,
    required String place,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    double lat = 28.6139;
    double lon = 77.2090;
    
    // Attempt geocoding with timeout
    try {
      if (place.isNotEmpty) {
        List<Location> locations = await locationFromAddress(place).timeout(const Duration(seconds: 2));
        if (locations.isNotEmpty) {
          lat = locations.first.latitude;
          lon = locations.first.longitude;
        }
      }
    } catch (e) {
      // Ignore geocoding errors/timeouts, fallback to default
      print('Geocoding error for place: $place - $e');
    }

    final newProfile = UserProfile(
      name: name,
      dob: dob,
      time: time,
      place: place,
      latitude: lat,
      longitude: lon,
      timeZone: '5.5', // Defaulting to IST for now
    );

    state = newProfile;

    await prefs.setString('user_name', name);
    await prefs.setString('user_dob', dob);
    await prefs.setString('user_time', time);
    await prefs.setString('user_place', place);
    await prefs.setDouble('user_lat', lat);
    await prefs.setDouble('user_lon', lon);
    await prefs.setString('user_tz', '5.5');
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
