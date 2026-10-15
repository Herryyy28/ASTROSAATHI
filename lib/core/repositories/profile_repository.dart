import '../models/birth_details.dart';
import '../network/api_result.dart';

abstract class IProfileRepository {
  /// Fetch all profiles saved on this device or synchronized with backend
  Future<ApiResult<List<BirthDetails>>> getProfiles();

  /// Retrieve the primary active seeker profile
  Future<ApiResult<BirthDetails?>> getPrimaryProfile();

  /// Save or update primary seeker profile
  Future<ApiResult<BirthDetails>> savePrimaryProfile(BirthDetails details);

  /// Add a family or client profile
  Future<ApiResult<BirthDetails>> addProfile(BirthDetails details);

  /// Update an existing profile
  Future<ApiResult<BirthDetails>> updateProfile(String id, BirthDetails details);

  /// Delete a profile
  Future<ApiResult<bool>> deleteProfile(String id);

  /// Set the active primary profile
  Future<ApiResult<void>> setActiveProfile(String id);
}
