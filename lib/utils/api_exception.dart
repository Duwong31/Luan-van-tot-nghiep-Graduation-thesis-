/// Custom exception cho API errors
class ApiException implements Exception {
  final String code;
  final String message;
  final Map<String, dynamic>? errors;

  ApiException({
    required this.code,
    required this.message,
    this.errors,
  });

  @override
  String toString() {
    if (errors != null && errors!.isNotEmpty) {
      return '$message\n${errors!.values.join('\n')}';
    }
    return message;
  }

  /// Parse từ response JSON
  factory ApiException.fromJson(Map<String, dynamic> json) {
    return ApiException(
      code: json['code'] ?? 'UNKNOWN_ERROR',
      message: json['message'] ?? 'An error occurred',
      errors: json['errors'],
    );
  }
}
