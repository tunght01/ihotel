class BaseError implements Exception {
  const BaseError(this.exceptionType, this.message);

  final ExceptionType exceptionType;
  final String message;
}

enum ExceptionType {
  warning,
  error,
  success,
}

extension ExExceptionType on ExceptionType {
  bool get isWarning => this == ExceptionType.warning;

  bool get isError => this == ExceptionType.error;
}
