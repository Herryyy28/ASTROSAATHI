import '../errors/app_exceptions.dart';

/// Type-safe Result monad for API & repository operations.
/// Guarantees compile-time exhaustiveness and prevents unhandled exceptions in UI widgets.
sealed class ApiResult<T> {
  const ApiResult();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get dataOrNull => switch (this) {
        Success(data: final d) => d,
        Failure() => null,
      };

  AppException? get errorOrNull => switch (this) {
        Success() => null,
        Failure(exception: final e) => e,
      };

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException exception) failure,
  }) {
    return switch (this) {
      Success(data: final d) => success(d),
      Failure(exception: final e) => failure(e),
    };
  }
}

class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';
}

class Failure<T> extends ApiResult<T> {
  final AppException exception;
  const Failure(this.exception);

  @override
  String toString() => 'Failure(exception: $exception)';
}
