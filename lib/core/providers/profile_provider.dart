import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _profilesKey = 'birth_profiles_v1';

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'relationship': relationship,
        'dob': dob,
        'birthTime': birthTime,
        'birthPlace': birthPlace,
        'latitude': latitude,
        'longitude': longitude,
        'timezone': timezone,
        'isPrimary': isPrimary,
      };

  factory BirthProfileData.fromJson(Map<String, dynamic> json) {
    return BirthProfileData(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      relationship: json['relationship'] as String? ?? 'Self',
      dob: json['dob'] as String? ?? '',
      birthTime: json['birthTime'] as String? ?? '12:00',
      birthPlace: json['birthPlace'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 28.6139,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 77.2090,
      timezone: json['timezone'] as String? ?? '5.5',
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }

  BirthProfileData copyWith({
    String? id,
    String? name,
    String? relationship,
    String? dob,
    String? birthTime,
    String? birthPlace,
    double? latitude,
    double? longitude,
    String? timezone,
    bool? isPrimary,
  }) {
    return BirthProfileData(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      dob: dob ?? this.dob,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      isPrimary: isPrimary ?? this.isPrimary,
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
        dob: dob,
        birthTime: prefs.getString('user_time') ?? '12:00',
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
  }

  Future<void> upsertPrimaryProfile({
    required String name,
    required String dob,
    required String birthTime,
    required String birthPlace,
    required double latitude,
    required double longitude,
    required String timezone,
  }) async {
    final existing = state.where((p) => p.isPrimary).toList();
    if (existing.isNotEmpty) {
      state = state.map((p) {
        if (p.isPrimary) {
          return p.copyWith(
            name: name,
            dob: dob,
            birthTime: birthTime,
            birthPlace: birthPlace,
            latitude: latitude,
            longitude: longitude,
            timezone: timezone,
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
          dob: dob,
          birthTime: birthTime,
          birthPlace: birthPlace,
          latitude: latitude,
          longitude: longitude,
          timezone: timezone,
          isPrimary: true,
        ),
        ...state.map((p) => p.copyWith(isPrimary: false)),
      ];
    }
    await _persist();
  }

  static const int maxProfiles = 5;

  Future<bool> addProfile(BirthProfileData profile, {bool isPremium = false}) async {
    if (!isPremium && state.length >= maxProfiles) {
      return false;
    }
    state = [...state, profile];
    await _persist();
    return true;
  }

  Future<void> setPrimary(String id) async {
    state = state
        .map((p) => p.copyWith(isPrimary: p.id == id))
        .toList();
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
}

final profilesListProvider =
    StateNotifierProvider<ProfilesNotifier, List<BirthProfileData>>((ref) {
  return ProfilesNotifier();
});

final canAddMoreProfilesProvider = Provider<bool>((ref) {
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
  dob: '',
  birthTime: '12:00 AM',
  birthPlace: '',
  latitude: 28.6139,
  longitude: 77.2090,
  timezone: '5.5',
  isPrimary: true,
);

final activeProfileProvider = Provider<BirthProfileData>((ref) {
  final profiles = ref.watch(profilesListProvider);
  if (profiles.isEmpty) return _emptyProfile;
  return profiles.firstWhere(
    (p) => p.isPrimary,
    orElse: () => profiles.first,
  );
});

final hasBirthProfileProvider = Provider<bool>((ref) {
  final profile = ref.watch(activeProfileProvider);
  return profile.dob.isNotEmpty && profile.name.isNotEmpty;
});

final activeProfileIndexProvider = StateProvider<int>((ref) => 0);

