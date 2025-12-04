import 'package:Celes/data/api_config.dart';
import 'package:Celes/settings.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:dio/dio.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppSettings.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: ApiConfig.headers,
      ),
    );

    // Add interceptors để log request/response
    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String? token,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: token != null
            ? Options(headers: ApiConfig.getAuthHeaders(token))
            : null,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        options: token != null
            ? Options(headers: ApiConfig.getAuthHeaders(token))
            : null,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        options: token != null
            ? Options(headers: ApiConfig.getAuthHeaders(token))
            : null,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        options: token != null
            ? Options(headers: ApiConfig.getAuthHeaders(token))
            : null,
      );
      return _handleResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Xử lý response
  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data as Map<String, dynamic>;
    } else {
      throw ApiException(
        code: 'HTTP_ERROR',
        message: 'HTTP Error: ${response.statusCode}',
      );
    }
  }

  /// Xử lý error
  ApiException _handleError(DioException error) {
    if (error.response != null && error.response!.data != null) {
      // Server trả về error response
      final data = error.response!.data;
      if (data is Map<String, dynamic>) {
        return ApiException.fromJson(data);
      }
    }

    // Network error hoặc timeout
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          code: 'TIMEOUT_ERROR',
          message: 'Connection timeout. Please try again.',
        );
      case DioExceptionType.connectionError:
        return ApiException(
          code: 'CONNECTION_ERROR',
          message: 'No internet connection. Please check your network.',
        );
      default:
        return ApiException(
          code: 'UNKNOWN_ERROR',
          message: error.message ?? 'An unknown error occurred',
        );
    }
  }
}
