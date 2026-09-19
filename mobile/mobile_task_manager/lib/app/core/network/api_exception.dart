class ApiException implements Exception {
  const ApiException(this.message, {
    this.statusCode,
    this.validationErrors = const {},
  });
  final String message;
  final int? statusCode;
  final Map<String, String> validationErrors;

  @override
  String toString() => message;
}
