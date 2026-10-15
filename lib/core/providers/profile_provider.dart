import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/birth_details.dart';

import 'subscription_provider.dart';

const _profilesKey = 'birth_profiles_v1';

class BirthProfileData {
  final String id;
  final String name;
  final String relationship;
  final String gender;
  final String dob;
  final String birthTime;
  final bool birthTimeUnknown;
  final String birthPlace;
  final double latitude;
  final double longitude;
  final String timezone;
  final List<String> focusAreas;
  final bool isPrimary;

  const BirthProfileData({
    required this.id,
    required this.name,
    required this.relationship,
    this.gender = 'Not specified',
    required this.dob,
    required this.birthTime,
    this.birthTimeUnknown = false,
    required this.birthPlace,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    this.focusAreas = const [],
    this.isPrimary = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'relationship': relationship,
    'gender': gender,
    'dob': dob,
    'birthTime': birthTime,
    'birthTimeUnknown': birthTimeUnknown,
    'birthPlace': birthPlace,
    'latitude': latitude,
    'longitude': longitude,
    'timezone': timezone,
    'focusAreas': focusAreas,
    'isPrimary': isPrimary,
  };

  factory BirthProfileData.fromJson(Map<String, dynamic> json) {
    return BirthProfileData(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? 'Self',
      gender: json['gender'] as String? ?? 'Not specified',
      dob: json['dob'] as String? ?? '',
      birthTime: json['birthTime'] as String? ?? '12:00',
      birthTimeUnknown: json['birthTimeUnknown'] as bool? ?? false,
      birthPlace: json['birthPlace'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 28.6139,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.2090,
      timezone: json['timezone'] as String? ?? '5.5',
      focusAreas:
          (json['focusAreas'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }

  BirthProfileData copyWith({
    String? id,
    String? name,
    String? relationship,
    String? gender,
    String? dob,
    String? birthTime,
    bool? birthTimeUnknown,
    String? birthPlace,
    double? latitude,
    double? longitude,
    String? timezone,
    List<String>? focusAreas,
    bool? isPrimary,
  }) {
    return BirthProfileData(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      birthTime: birthTime ?? this.birthTime,
      birthTimeUnknown: birthTimeUnknown ?? this.birthTimeUnknown,
      birthPlace: birthPlace ?? this.birthPlace,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      focusAreas: focusAreas ?? this.focusAreas,
      isPrimary: isPrimary ?? this.isPrimary,
    );
  }

  BirthDetails toBirthDetails() {
    return BirthDetails(
      name: name,
      dob: dob,
      birthTime: birthTime,
      birthPlace: birthPlace,
      latitude: latitude,
      longitude: longitude,
      timezone: timezone,
    );
  }

  factory BirthProfileData.fromBirthDetails(BirthDetails details, {String? id, String relationship = 'Self', bool isPrimary = false}) {
    return BirthProfileData(
      id: id ?? 'profile_${DateTime.now().millisecondsSinceEpoch}',
      name: details.name,
      relationship: relationship,
      dob: details.dob,
      birthTime: details.birthTime,
      birthPlace: details.birthPlace,
      latitude: details.latitude,
      longitude: details.longitude,
      timezone: details.timezone,
      isPrimary: isPrimary,
    );
  }
}

class ProfilesNotifier extends StateNotifier<List<BirthProfileData>> {
  ProfilesNotifier() : super([]) {
    loadProfiles();
  }

  Future<void> loadProfiles() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profilesKey);

    if (raw != null && raw.isNotEmpty) {
      final list = (jsonDecode(raw) as List)
          .map((e) => BirthProfileData.fromJson(e as Map<String, dynamic>))
          .toList();
      if (list.isNotEmpty) {
        state = list;
        return;
      }
    }

    // Migrate legacy onboarding keys into a primary profile
    final name = prefs.getString('user_name') ?? '';
    final dob = prefs.getString('user_dob') ?? '';
    if (name.isNotEmpty && dob.isNotEmpty) {
      final migrated = BirthProfileData(
        id: 'primary',
        name: name,
        relationship: 'Self',
        gender: prefs.getString('user_gender') ?? 'Not specified',
        dob: dob,
        birthTime: prefs.getString('user_time') ?? '12:00',
        birthTimeUnknown: prefs.getBool('user_time_unknown') ?? false,
        birthPlace: prefs.getString('user_place') ?? '',
        latitude: prefs.getDouble('user_lat') ?? 28.6139,
        longitude: prefs.getDouble('user_lon') ?? 77.2090,
        timezone: prefs.getString('user_tz') ?? '5.5',
        isPrimary: true,
      );
      state = [migrated];
      await _persist();
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _profilesKey,
      jsonEncode(state.map((p) => p.toJson()).toList()),
    );
    final primary = state.where((profile) => profile.isPrimary).firstOrNull;
    if (primary != null) {
      await prefs.setString('user_name', primary.name);
      await prefs.setString('user_gender', primary.gender);
      await prefs.setString('user_dob', primary.dob);
      await prefs.setString('user_time', primary.birthTime);
      await prefs.setBool('user_time_unknown', primary.birthTimeUnknown);
      await prefs.setString('user_place', primary.birthPlace);
      await prefs.setDouble('user_lat', primary.latitude);
      await prefs.setDouble('user_lon', primary.longitude);
      await prefs.setString('user_tz', primary.timezone);
    }
  }

  Future<void> upsertPrimaryProfile({
    required String name,
    required String dob,
    required String birthTime,
    required String birthPlace,
    required double latitude,
    required double longitude,
    required String timezone,
    List<String> focusAreas = const [],
    String? gender,
    bool? birthTimeUnknown,
  }) async {
    final existing = state.where((p) => p.isPrimary).toList();
    if (existing.isNotEmpty) {
      state = state.map((p) {
        if (p.isPrimary) {
          return p.copyWith(
            name: name,
            gender: gender,
            dob: dob,
            birthTime: birthTime,
            birthTimeUnknown: birthTimeUnknown,
            birthPlace: birthPlace,
            latitude: latitude,
            longitude: longitude,
            timezone: timezone,
            focusAreas: focusAreas,
          );
        }
        return p;
      }).toList();
    } else {
      state = [
        BirthProfileData(
          id: 'primary',
          name: name,
          relationship: 'Self',
          gender: gender ?? 'Not specified',
          dob: dob,
          birthTime: birthTime,
          birthTimeUnknown: birthTimeUnknown ?? false,
          birthPlace: birthPlace,
          latitude: latitude,
          longitude: longitude,
          timezone: timezone,
          focusAreas: focusAreas,
          isPrimary: true,
        ),
        ...state.map((p) => p.copyWith(isPrimary: false)),
      ];
    }
    await _persist();
  }

  Future<void> updateProfile(BirthProfileData profile) async {
    if (!state.any((item) => item.id == profile.id)) return;
    state = [
      for (final item in state)
        if (item.id == profile.id) profile else item,
    ];
    await _persist();
  }

  static const int maxProfiles = 5;

  Future<bool> addProfile(
    BirthProfileData profile, {
    bool isPremium = false,
  }) async {
    if (!isPremium && state.length >= maxProfiles) {
      return false;
    }
    state = [...state, profile];
    await _persist();
    return true;
  }

  Future<void> setPrimary(String id) async {
    state = state.map((p) => p.copyWith(isPrimary: p.id == id)).toList();
    await _persist();
  }

  Future<void> deleteProfile(String id) async {
    final updated = state.where((p) => p.id != id).toList();
    if (updated.isNotEmpty && !updated.any((p) => p.isPrimary)) {
      updated[0] = updated[0].copyWith(isPrimary: true);
    }
    state = updated;
    await _persist();
  }

  Future<void> clearAllProfiles() async {
    state = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profilesKey);
    await prefs.remove('user_name');
    await prefs.remove('user_gender');
    await prefs.remove('user_dob');
    await prefs.remove('user_time');
    await prefs.remove('user_time_unknown');
    await prefs.remove('user_place');
    await prefs.remove('user_lat');
    await prefs.remove('user_lon');
    await prefs.remove('user_tz');
  }
}

final profilesListProvider =
    StateNotifierProvider<ProfilesNotifier, List<BirthProfileData>>((ref) {
      return ProfilesNotifier();
    });

final canAddMoreProfilesProvider = Provider<bool>((ref) {
  final isPremium = ref.watch(subscriptionProvider).isPremium;
  if (isPremium) return true;
  final profiles = ref.watch(profilesListProvider);
  return profiles.length < ProfilesNotifier.maxProfiles;
});

final profileCapacityTextProvider = Provider<String>((ref) {
  final count = ref.watch(profilesListProvider).length;
  return '$count / ${ProfilesNotifier.maxProfiles} Profiles';
});

/// Default profile used when onboarding has not completed yet.
final _emptyProfile = BirthProfileData(
  id: 'unset',
  name: '',
  relationship: 'Self',
  gender: 'Not specified',
  dob: '',
  birthTime: '12:00 AM',
  birthTimeUnknown: false,
  birthPlace: '',
  latitude: 28.6139,
  longitude: 77.2090,
  timezone: '5.5',
  isPrimary: true,
);

final activeProfileIndexProvider = StateProvider<int>((ref) => 0);

final activeProfileProvider = Provider<BirthProfileData>((ref) {
  final profiles = ref.watch(profilesListProvider);
  if (profiles.isEmpty) return _emptyProfile;
  final index = ref.watch(activeProfileIndexProvider);
  if (index >= 0 && index < profiles.length) {
    return profiles[index];
  }
  return profiles.firstWhere((p) => p.isPrimary, orElse: () => profiles.first);
});

final hasBirthProfileProvider = Provider<bool>((ref) {
  final profile = ref.watch(activeProfileProvider);
  return profile.dob.isNotEmpty && profile.name.isNotEmpty;
});
