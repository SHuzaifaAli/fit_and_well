import 'app_exceptions.dart';

/// Failure sealed class for functional error handling
/// Used with dartz Either<Failure, T> pattern
abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});

  factory NetworkFailure.fromException(NetworkException e) =>
      NetworkFailure(message: e.message, code: e.code);
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});

  factory AuthFailure.fromException(AuthException e) =>
      AuthFailure(message: e.message, code: e.code);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure({required super.message, super.code});

  factory DatabaseFailure.fromException(DatabaseException e) =>
      DatabaseFailure(message: e.message, code: e.code);
}

class AIFailure extends Failure {
  const AIFailure({required super.message, super.code});

  factory AIFailure.fromException(AIException e) =>
      AIFailure(message: e.message, code: e.code);
}

class PaymentFailure extends Failure {
  const PaymentFailure({required super.message, super.code});

  factory PaymentFailure.fromException(PaymentException e) =>
      PaymentFailure(message: e.message, code: e.code);
}

class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.code});

  factory StorageFailure.fromException(StorageException e) =>
      StorageFailure(message: e.message, code: e.code);
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code,
    this.fieldErrors,
  });

  factory ValidationFailure.fromException(ValidationException e) =>
      ValidationFailure(
        message: e.message,
        code: e.code,
        fieldErrors: e.fieldErrors,
      );
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'An unexpected error occurred.',
    super.code = 'UNKNOWN',
  });
}
