import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/user.dart';
import 'package:Celes/settings.dart';
import 'package:Celes/utils/api.dart' hide ApiException;
import 'package:Celes/utils/api_exception.dart';
import 'package:Celes/utils/hive_utils.dart';
import 'package:dio/dio.dart';

/// Repository xử lý các API liên quan đến Authentication
/// Đây là tầng trung gian giữa UI và Data Source
class AuthRepository {
  late final Dio _dio;

  /// API Key bắt buộc cho mọi request
  static const String apiKey = "SKT-T1";

  /// Language mặc định
  static const String defaultLanguage = "vi";

  AuthRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppSettings.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: _getHeaders(),
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

  /// Headers cơ bản
  Map<String, String> _getHeaders() => {
        'X-Api-Key': apiKey,
        'Language': defaultLanguage,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  /// Headers khi đã đăng nhập (có token)
  Map<String, String> _getAuthHeaders(String token) => {
        ..._getHeaders(),
        'Authorization': 'Bearer $token',
      };

  /// Đăng ký tài khoản mới
  Future<ApiResponse<User>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await _dio.post(
        Api.authRegister,
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
        },
      );

      final result = _handleResponse(response);
      return ApiResponse.fromJson(
        result,
        (data) => User.fromJson(data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Xác thực OTP
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
    String type = 'register',
  }) async {
    try {
      final response = await _dio.post(
        Api.authVerifyOtp,
        data: {
          'email': email,
          'otp_code': otp,
          'type': type,
        },
      );

      final result = _handleResponse(response);
      return ApiResponse.fromJson(
        result,
        (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Gửi lại OTP
  Future<ApiResponse<dynamic>> resendOtp({
    required String email,
    String type = 'register',
  }) async {
    try {
      final response = await _dio.post(
        Api.authResendOtp,
        data: {
          'email': email,
          'type': type,
        },
      );

      final result = _handleResponse(response);
      return ApiResponse.fromJson(result, (data) => data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Đăng nhập
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        Api.authLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      final result = _handleResponse(response);
      final apiResponse = ApiResponse.fromJson(
        result,
        (data) => data as Map<String, dynamic>,
      );

      // Lưu token vào Hive nếu đăng nhập thành công
      if (apiResponse.success && apiResponse.data != null) {
        final accessToken = apiResponse.data!['access_token'] as String?;
        final refreshToken = apiResponse.data!['refresh_token'] as String?;
        final expiresIn = apiResponse.data!['expires_in'] as int?;

        if (accessToken != null) {
          await _saveTokens(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresIn: expiresIn,
          );

          // Lưu thông tin user nếu có
          if (apiResponse.data!['user'] != null) {
            final userData = apiResponse.data!['user'] as Map<String, dynamic>;
            final user = User.fromJson(userData);
            await HiveUtils.setUserData(user.toJson());
          }

          await HiveUtils.setUserIsAuthenticated(true);
        }
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Quên mật khẩu
  Future<ApiResponse<dynamic>> forgotPassword({
    required String email,
  }) async {
    try {
      final response = await _dio.post(
        Api.authForgotPassword,
        data: {
          'email': email,
        },
      );

      final result = _handleResponse(response);
      return ApiResponse.fromJson(result, (data) => data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Đặt lại mật khẩu
  Future<ApiResponse<dynamic>> resetPassword({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dio.post(
        Api.authResetPassword,
        data: {
          'email': email,
          'reset_token': resetToken,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      final result = _handleResponse(response);
      return ApiResponse.fromJson(result, (data) => data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Đổi mật khẩu (yêu cầu đăng nhập)
  Future<ApiResponse<dynamic>> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final token = await getValidAccessToken();
      if (token == null) {
        throw ApiException(
          code: 'UNAUTHORIZED',
          message: 'Please login to change password',
        );
      }

      final response = await _dio.post(
        Api.authChangePassword,
        data: {
          'current_password': currentPassword,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
        options: Options(
          headers: _getAuthHeaders(token),
        ),
      );

      final result = _handleResponse(response);
      return ApiResponse.fromJson(result, (data) => data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Refresh token
  Future<ApiResponse<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) async {
    try {
      final response = await _dio.post(
        Api.authRefreshToken,
        data: {
          'refresh_token': refreshToken,
        },
      );

      final result = _handleResponse(response);
      final apiResponse = ApiResponse.fromJson(
        result,
        (data) => data as Map<String, dynamic>,
      );

      // Lưu token mới vào Hive
      if (apiResponse.success && apiResponse.data != null) {
        final newAccessToken = apiResponse.data!['access_token'] as String?;
        final newRefreshToken = apiResponse.data!['refresh_token'] as String?;
        final expiresIn = apiResponse.data!['expires_in'] as int?;

        if (newAccessToken != null) {
          await _saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            expiresIn: expiresIn,
          );
        }
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Đăng xuất
  Future<ApiResponse<dynamic>> logout() async {
    try {
      final token = HiveUtils.getJWT();

      final response = await _dio.post(
        Api.authLogout,
        options: Options(
          headers: _getAuthHeaders(token),
        ),
      );

      final result = _handleResponse(response);

      // Xóa tất cả dữ liệu đã lưu
      await _clearTokens();
      await HiveUtils.clear();

      return ApiResponse.fromJson(result, (data) => data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Lấy thông tin profile của user hiện tại
  Future<ApiResponse<User>> getProfile() async {
    try {
      final token = await getValidAccessToken();
      if (token == null) {
        throw ApiException(
          code: 'UNAUTHORIZED',
          message: 'Please login to get profile',
        );
      }

      final response = await _dio.get(
        Api.authGetProfile,
        options: Options(
          headers: _getAuthHeaders(token),
        ),
      );

      final result = _handleResponse(response);
      final apiResponse = ApiResponse.fromJson(
        result,
        (data) => User.fromJson(data as Map<String, dynamic>),
      );

      // Cập nhật user data vào Hive nếu thành công
      if (apiResponse.success && apiResponse.data != null) {
        await HiveUtils.setUserData(apiResponse.data!.toJson());
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Cập nhật thông tin profile
  Future<ApiResponse<User>> updateProfile({
    required String name,
    int? avatarId,
    String? phone,
    String? dateOfBirth,
    String? gender,
    String? address,
  }) async {
    try {
      final token = await getValidAccessToken();
      if (token == null) {
        throw ApiException(
          code: 'UNAUTHORIZED',
          message: 'Please login to update profile',
        );
      }

      final Map<String, dynamic> data = {'name': name};
      if (avatarId != null) data['avatar_id'] = avatarId;
      if (phone != null) data['phone'] = phone;
      if (dateOfBirth != null) data['date_of_birth'] = dateOfBirth;
      if (gender != null) data['gender'] = gender;
      if (address != null) data['address'] = address;

      final response = await _dio.put(
        Api.authUpdateProfile,
        data: data,
        options: Options(
          headers: _getAuthHeaders(token),
        ),
      );

      final result = _handleResponse(response);
      final apiResponse = ApiResponse.fromJson(
        result,
        (data) => User.fromJson(data as Map<String, dynamic>),
      );

      // Cập nhật user data vào Hive nếu thành công
      if (apiResponse.success && apiResponse.data != null) {
        await HiveUtils.setUserData(apiResponse.data!.toJson());
      }

      return apiResponse;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload ảnh
  Future<ApiResponse<Map<String, dynamic>>> uploadImage(
    String imagePath,
  ) async {
    try {
      final token = await getValidAccessToken();
      if (token == null) {
        throw ApiException(
          code: 'UNAUTHORIZED',
          message: 'Please login to upload image',
        );
      }

      final formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(imagePath),
      });

      final response = await _dio.post(
        Api.mediaUploadImage,
        data: formData,
        options: Options(
          headers: {
            ..._getAuthHeaders(token),
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      final result = _handleResponse(response);
      return ApiResponse.fromJson(
        result,
        (data) => data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Lấy access token hợp lệ (tự động refresh nếu hết hạn)
  Future<String?> getValidAccessToken() async {
    final isExpired = await _isTokenExpired();

    if (isExpired) {
      // Token hết hạn, thử refresh
      final refreshTokenValue = HiveUtils.getRefreshToken();
      if (refreshTokenValue == null) return null;

      try {
        final response = await refreshToken(refreshToken: refreshTokenValue);
        if (response.success && response.data != null) {
          return response.data!['access_token'] as String?;
        }
        return null;
      } catch (e) {
        print('Error refreshing token: $e');
        return null;
      }
    } else {
      // Token còn hạn, trả về luôn
      return HiveUtils.getJWT();
    }
  }

  /// Kiểm tra xem user đã đăng nhập chưa
  bool isLoggedIn() {
    return HiveUtils.isUserAuthenticated();
  }

  // ==================== PRIVATE METHODS ====================

  /// Lưu tokens vào Hive
  Future<void> _saveTokens({
    required String accessToken,
    String? refreshToken,
    int? expiresIn,
  }) async {
    await HiveUtils.setJWT(accessToken);

    if (refreshToken != null) {
      await HiveUtils.setRefreshToken(refreshToken);
    }

    if (expiresIn != null) {
      final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
      await HiveUtils.setTokenExpiry(expiryTime);
    }
  }

  /// Kiểm tra xem token có hết hạn không
  Future<bool> _isTokenExpired() async {
    final expiryTime = HiveUtils.getTokenExpiry();
    if (expiryTime == null) return true;
    return DateTime.now().isAfter(expiryTime);
  }

  /// Xóa tất cả tokens
  Future<void> _clearTokens() async {
    await HiveUtils.clearTokens();
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
