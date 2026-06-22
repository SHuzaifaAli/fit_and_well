/// Base exception class for FitAI Coach
/// All custom exceptions extend this base class
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  /// User-friendly message for display in UI
  String get userMessage => message;

  /// Developer message for logging
  String get devMessage =>
      '[${runtimeType}] Code: $code | Message: $message | Original: $originalError';

  @override
  String toString() => devMessage;
}

// ─── Network Exceptions ───────────────────────────────────────────────────────

class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory NetworkException.noInternet() => const NetworkException(
        message: 'No internet connection. Please check your network settings.',
        code: 'NO_INTERNET',
      );

  factory NetworkException.timeout() => const NetworkException(
        message: 'Request timed out. Please try again.',
        code: 'TIMEOUT',
      );

  factory NetworkException.serverError([String? detail]) => NetworkException(
        message: detail ?? 'Server error. Please try again later.',
        code: 'SERVER_ERROR',
      );

  factory NetworkException.badRequest([String? detail]) => NetworkException(
        message: detail ?? 'Invalid request. Please check your input.',
        code: 'BAD_REQUEST',
      );

  factory NetworkException.unauthorized() => const NetworkException(
        message: 'Your session has expired. Please log in again.',
        code: 'UNAUTHORIZED',
      );

  factory NetworkException.forbidden() => const NetworkException(
        message: 'You do not have permission to perform this action.',
        code: 'FORBIDDEN',
      );

  factory NetworkException.notFound([String? resource]) => NetworkException(
        message: '${resource ?? 'Resource'} not found.',
        code: 'NOT_FOUND',
      );

  factory NetworkException.rateLimited() => const NetworkException(
        message: 'Too many requests. Please wait a moment and try again.',
        code: 'RATE_LIMITED',
      );

  factory NetworkException.unknown([dynamic error]) => NetworkException(
        message: 'An unexpected network error occurred.',
        code: 'UNKNOWN',
        originalError: error,
      );
}

// ─── Authentication Exceptions ────────────────────────────────────────────────

class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AuthException.invalidCredentials() => const AuthException(
        message: 'Invalid email or password. Please try again.',
        code: 'INVALID_CREDENTIALS',
      );

  factory AuthException.emailAlreadyInUse() => const AuthException(
        message: 'An account with this email already exists.',
        code: 'EMAIL_IN_USE',
      );

  factory AuthException.weakPassword() => const AuthException(
        message: 'Password is too weak. Please use at least 8 characters.',
        code: 'WEAK_PASSWORD',
      );

  factory AuthException.userNotFound() => const AuthException(
        message: 'No account found with this email address.',
        code: 'USER_NOT_FOUND',
      );

  factory AuthException.sessionExpired() => const AuthException(
        message: 'Your session has expired. Please log in again.',
        code: 'SESSION_EXPIRED',
      );

  factory AuthException.emailNotVerified() => const AuthException(
        message: 'Please verify your email address before logging in.',
        code: 'EMAIL_NOT_VERIFIED',
      );

  factory AuthException.googleSignInFailed([dynamic error]) => AuthException(
        message: 'Google sign-in failed. Please try again.',
        code: 'GOOGLE_SIGN_IN_FAILED',
        originalError: error,
      );

  factory AuthException.appleSignInFailed([dynamic error]) => AuthException(
        message: 'Apple sign-in failed. Please try again.',
        code: 'APPLE_SIGN_IN_FAILED',
        originalError: error,
      );

  factory AuthException.unknown([dynamic error]) => AuthException(
        message: 'Authentication error. Please try again.',
        code: 'AUTH_UNKNOWN',
        originalError: error,
      );
}

// ─── Database Exceptions ──────────────────────────────────────────────────────

class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory DatabaseException.notFound([String? entity]) => DatabaseException(
        message: '${entity ?? 'Record'} not found.',
        code: 'DB_NOT_FOUND',
      );

  factory DatabaseException.duplicateEntry([String? field]) =>
      DatabaseException(
        message: '${field ?? 'Record'} already exists.',
        code: 'DB_DUPLICATE',
      );

  factory DatabaseException.writeError([dynamic error]) => DatabaseException(
        message: 'Failed to save data. Please try again.',
        code: 'DB_WRITE_ERROR',
        originalError: error,
      );

  factory DatabaseException.readError([dynamic error]) => DatabaseException(
        message: 'Failed to load data. Please try again.',
        code: 'DB_READ_ERROR',
        originalError: error,
      );

  factory DatabaseException.unknown([dynamic error]) => DatabaseException(
        message: 'Database error. Please try again.',
        code: 'DB_UNKNOWN',
        originalError: error,
      );
}

// ─── AI Exceptions ────────────────────────────────────────────────────────────

class AIException extends AppException {
  const AIException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory AIException.quotaExceeded() => const AIException(
        message:
            'Daily AI request limit reached. Upgrade to Premium for unlimited access.',
        code: 'AI_QUOTA_EXCEEDED',
      );

  factory AIException.apiError([dynamic error]) => AIException(
        message: 'AI service is temporarily unavailable. Please try again.',
        code: 'AI_API_ERROR',
        originalError: error,
      );

  factory AIException.invalidResponse() => const AIException(
        message: 'Received an invalid response from AI. Please try again.',
        code: 'AI_INVALID_RESPONSE',
      );

  factory AIException.contextTooLong() => const AIException(
        message: 'Request is too long. Please shorten your input.',
        code: 'AI_CONTEXT_TOO_LONG',
      );

  factory AIException.unknown([dynamic error]) => AIException(
        message: 'AI error. Please try again.',
        code: 'AI_UNKNOWN',
        originalError: error,
      );
}

// ─── Payment Exceptions ───────────────────────────────────────────────────────

class PaymentException extends AppException {
  const PaymentException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory PaymentException.paymentFailed([String? detail]) => PaymentException(
        message: detail ?? 'Payment failed. Please check your payment details.',
        code: 'PAYMENT_FAILED',
      );

  factory PaymentException.subscriptionExpired() => const PaymentException(
        message: 'Your subscription has expired. Please renew to continue.',
        code: 'SUBSCRIPTION_EXPIRED',
      );

  factory PaymentException.purchaseCancelled() => const PaymentException(
        message: 'Purchase was cancelled.',
        code: 'PURCHASE_CANCELLED',
      );

  factory PaymentException.alreadySubscribed() => const PaymentException(
        message: 'You already have an active subscription.',
        code: 'ALREADY_SUBSCRIBED',
      );

  factory PaymentException.restoreFailed([dynamic error]) => PaymentException(
        message: 'Failed to restore purchases. Please try again.',
        code: 'RESTORE_FAILED',
        originalError: error,
      );

  factory PaymentException.unknown([dynamic error]) => PaymentException(
        message: 'Payment error. Please try again.',
        code: 'PAYMENT_UNKNOWN',
        originalError: error,
      );
}

// ─── Storage Exceptions ───────────────────────────────────────────────────────

class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  factory StorageException.uploadFailed([dynamic error]) => StorageException(
        message: 'Failed to upload file. Please try again.',
        code: 'UPLOAD_FAILED',
        originalError: error,
      );

  factory StorageException.downloadFailed([dynamic error]) => StorageException(
        message: 'Failed to download file. Please try again.',
        code: 'DOWNLOAD_FAILED',
        originalError: error,
      );

  factory StorageException.fileTooLarge() => const StorageException(
        message: 'File is too large. Maximum size is 10MB.',
        code: 'FILE_TOO_LARGE',
      );

  factory StorageException.invalidFileType() => const StorageException(
        message: 'Invalid file type. Please use JPG, PNG, or WEBP.',
        code: 'INVALID_FILE_TYPE',
      );

  factory StorageException.unknown([dynamic error]) => StorageException(
        message: 'Storage error. Please try again.',
        code: 'STORAGE_UNKNOWN',
        originalError: error,
      );
}

// ─── Validation Exceptions ────────────────────────────────────────────────────

class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
    this.fieldErrors,
  });

  factory ValidationException.invalidInput(String field, String reason) =>
      ValidationException(
        message: '$field: $reason',
        code: 'VALIDATION_ERROR',
        fieldErrors: {field: reason},
      );

  factory ValidationException.multipleErrors(Map<String, String> errors) =>
      ValidationException(
        message: 'Please fix the validation errors.',
        code: 'MULTIPLE_VALIDATION_ERRORS',
        fieldErrors: errors,
      );
}

// ─── Unknown Exception ────────────────────────────────────────────────────────

class UnknownException extends AppException {
  const UnknownException({
    super.message = 'An unexpected error occurred. Please try again.',
    super.code = 'UNKNOWN',
    super.originalError,
    super.stackTrace,
  });
}
