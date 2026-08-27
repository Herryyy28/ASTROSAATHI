import 'package:flutter_riverpod/flutter_riverpod.dart';

class BirthProfileData {
  final String id;
  final String name;
  final String relationship;
  final String dob;
  final String birthTime;
  final String birthPlace;
  final double latitude;
  final double longitude;
  final String timezone;
  final bool isPrimary;

  BirthProfileData({
    required this.id,
    required this.name,
    required this.relationship,
    required this.dob,
    required this.birthTime,
    required this.birthPlace,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    this.isPrimary = false,
  });
}

class ProfilesNotifier extends StateNotifier<List<BirthProfileData>> {
  ProfilesNotifier()
      : super([
          BirthProfileData(
            id: 'p1',
            name: 'My Kundli (Self)',
            relationship: 'Self',
            dob: '1996-08-15',
            birthTime: '07:30',
            birthPlace: 'New Delhi, India',
            latitude: 28.6139,
            longitude: 77.2090,
            timezone: '5.5',
            isPrimary: true,
          ),
          BirthProfileData(
            id: 'p2',
            name: 'Priya (Partner)',
            relationship: 'Partner',
            dob: '1998-05-20',
            birthTime: '14:15',
            birthPlace: 'Mumbai, India',
            latitude: 19.0760,
            longitude: 72.8777,
            timezone: '5.5',
            isPrimary: false,
          ),
        ]);

  void addProfile(BirthProfileData profile) {
    state = [...state, profile];
  }

  void setPrimary(String id) {
    state = state.map((p) {
      if (p.id == id) {
        return BirthProfileData(
          id: p.id,
          name: p.name,
          relationship: p.relationship,
          dob: p.dob,
          birthTime: p.birthTime,
          birthPlace: p.birthPlace,
          latitude: p.latitude,
          longitude: p.longitude,
          timezone: p.timezone,
          isPrimary: true,
        );
      } else {
        return BirthProfileData(
          id: p.id,
          name: p.name,
          relationship: p.relationship,
          dob: p.dob,
          birthTime: p.birthTime,
          birthPlace: p.birthPlace,
          latitude: p.latitude,
          longitude: p.longitude,
          timezone: p.timezone,
          isPrimary: false,
        );
      }
    }).toList();
  }

  void deleteProfile(String id) {
    state = state.where((p) => p.id != id).toList();
  }
}

final profilesListProvider = StateNotifierProvider<ProfilesNotifier, List<BirthProfileData>>((ref) {
  return ProfilesNotifier();
});

final activeProfileProvider = Provider<BirthProfileData>((ref) {
  final profiles = ref.watch(profilesListProvider);
  return profiles.firstWhere((p) => p.isPrimary, orElse: () => profiles.first);
});
