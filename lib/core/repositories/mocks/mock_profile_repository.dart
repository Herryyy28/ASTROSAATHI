import '../../models/birth_details.dart';
import '../../network/api_result.dart';
import '../profile_repository.dart';

class MockProfileRepository implements IProfileRepository {
  final List<BirthDetails> _profiles = [
    BirthDetails.defaultDelhi,
    const BirthDetails(
      name: 'Priya Sharma',
      dob: '1998-05-15',
      birthTime: '08:30',
      birthPlace: 'Mumbai, Maharashtra',
      latitude: 19.0760,
      longitude: 72.8777,
      timezone: '5.5',
      gender: 'female',
    ),
  ];

  @override
  Future<ApiResult<List<BirthDetails>>> getProfiles() async {
    return Success(List.unmodifiable(_profiles));
  }

  @override
  Future<ApiResult<BirthDetails?>> getPrimaryProfile() async {
    return Success(_profiles.isNotEmpty ? _profiles.first : null);
  }

  @override
  Future<ApiResult<BirthDetails>> savePrimaryProfile(BirthDetails details) async {
    details.validate();
    if (_profiles.isNotEmpty) {
      _profiles[0] = details;
    } else {
      _profiles.add(details);
    }
    return Success(details);
  }

  @override
  Future<ApiResult<BirthDetails>> addProfile(BirthDetails details) async {
    details.validate();
    _profiles.add(details);
    return Success(details);
  }

  @override
  Future<ApiResult<BirthDetails>> updateProfile(String id, BirthDetails details) async {
    details.validate();
    final index = _profiles.indexWhere((p) => p.name == id || p.dob == id);
    if (index != -1) {
      _profiles[index] = details;
    } else {
      _profiles.add(details);
    }
    return Success(details);
  }

  @override
  Future<ApiResult<bool>> deleteProfile(String id) async {
    _profiles.removeWhere((p) => p.name == id);
    return const Success(true);
  }

  @override
  Future<ApiResult<void>> setActiveProfile(String id) async {
    final index = _profiles.indexWhere((p) => p.name == id);
    if (index > 0) {
      final item = _profiles.removeAt(index);
      _profiles.insert(0, item);
    }
    return const Success(null);
  }
}
