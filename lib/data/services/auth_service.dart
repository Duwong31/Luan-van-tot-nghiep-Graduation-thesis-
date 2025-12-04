import 'package:Celes/data/api_client.dart';
import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/user.dart';

/// Service xử lý các API liên quan đến Authentication
class AuthService {
  final ApiClient _apiClient;

  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  Future<ApiResponse<User>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await _apiClient.post(
        'auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
        },
      );

      return ApiResponse.fromJson(
        response,
        (data) => User.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
    String type = 'register', // Default type for registration
  }) async {
    try {
      final response = await _apiClient.post(
        'auth/verify-otp',
        data: {
          'email': email,
          'otp_code': otp, // Changed from 'otp' to 'otp_code'
          'type': type, // Added required 'type' field
        },
      );

      return ApiResponse.fromJson(
          response, (data) => data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<dynamic>> resendOtp({
    required String email,
    String type = 'register', // Default type for registration
  }) async {
    try {
      final response = await _apiClient.post(
        'auth/resend-otp',
        data: {
          'email': email,
          'type': type, // Added required 'type' field
        },
      );

      return ApiResponse.fromJson(response, (data) => data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        'auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      return ApiResponse.fromJson(
          response, (data) => data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await _apiClient.post(
        'auth/forgot-password',
        data: {
          'email': email,
        },
      );

      return ApiResponse.fromJson(response, (data) => data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<dynamic>> resetPassword({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiClient.post(
        'auth/reset-password',
        data: {
          'email': email,
          'reset_token': resetToken,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      return ApiResponse.fromJson(response, (data) => data);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _apiClient.post(
        'auth/refresh',
        data: {
          'refresh_token': refreshToken,
        },
      );

      return ApiResponse.fromJson(
          response, (data) => data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse<dynamic>> logout({
    required String token,
  }) async {
    try {
      final response = await _apiClient.post(
        'auth/logout',
        token: token,
      );

      return ApiResponse.fromJson(response, (data) => data);
    } catch (e) {
      rethrow;
    }
  }
}
