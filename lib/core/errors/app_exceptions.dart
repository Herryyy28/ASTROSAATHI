/// Base exception class for all AstroSaathi domain & network errors.
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

/// Thrown when a network connectivity failure or timeout occurs.
class NetworkException extends AppException {
  const NetworkException([
    super.message = 'Network connection unavailable. Please check your internet.',
    String? code,
  ]) : super(code: code ?? 'NETWORK_ERROR');
}

/// Thrown when the backend server responds with an HTTP error.
class ServerException extends AppException {
  final int? statusCode;

  // ignore: use_super_parameters
  const ServerException({
    String message = 'Server error occurred. Please try again later.',
    String? code,
    this.statusCode,
    dynamic details,
  }) : super(message, code: code ?? 'SERVER_ERROR', details: details);
}

/// Thrown during authentication or authorization failures.
class AuthException extends AppException {
  const AuthException(super.message, {String? code})
      : super(code: code ?? 'AUTH_ERROR');
}

/// Thrown when input validation fails (e.g., invalid DOB, coordinates, or time).
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(
    super.message, {
    String? code,
    this.fieldErrors,
  }) : super(code: code ?? 'VALIDATION_ERROR', details: fieldErrors);
}

/// Thrown when an expected resource is not found.
class NotFoundException extends AppException {
  const NotFoundException([
    super.message = 'The requested resource was not found.',
    String? code,
  ]) : super(code: code ?? 'NOT_FOUND');
}
