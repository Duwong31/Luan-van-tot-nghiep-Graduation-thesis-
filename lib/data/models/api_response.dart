/// Generic API Response Model
class ApiResponse<T> {
  final bool success;
  final String code;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    required this.code,
    required this.message,
    this.data,
    this.errors,
  });

  /// Parse từ JSON với custom data parser
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }

  /// Convert sang JSON
  Map<String, dynamic> toJson(Object? Function(T)? toJsonT) {
    return {
      'success': success,
      'code': code,
      'message': message,
      'data': data != null && toJsonT != null ? toJsonT(data as T) : data,
      'errors': errors,
    };
  }
}
