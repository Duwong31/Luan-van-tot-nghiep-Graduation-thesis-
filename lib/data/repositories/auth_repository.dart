import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/user_model.dart';
import 'package:Celes/utils/api.dart';
import 'package:Celes/utils/hive_utils.dart';

/// Repository xử lý các API liên quan đến Authentication
/// Đây là tầng trung gian giữa UI và Data Source
class AuthRepository {
  /// Đăng ký tài khoản mới
  Future<ApiResponse<User>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    Map<String, dynamic> parameters = {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'address': address,
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.authRegister,
      parameter: parameters,
    );

    return ApiResponse.fromJson(
      response,
      (data) => User.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Xác thực OTP
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
    String type = 'register',
  }) async {
    Map<String, dynamic> parameters = {
      'email': email,
      'otp_code': otp,
      'type': type,
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.authVerifyOtp,
      parameter: parameters,
    );

    return ApiResponse.fromJson(
      response,
      (data) => data as Map<String, dynamic>,
    );
  }

  /// Gửi lại OTP
  Future<ApiResponse<dynamic>> resendOtp({
    required String email,
    String type = 'register',
  }) async {
    Map<String, dynamic> parameters = {
      'email': email,
      'type': type,
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.authResendOtp,
      parameter: parameters,
    );

    return ApiResponse.fromJson(response, (data) => data);
  }

  /// Đăng nhập
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    Map<String, dynamic> parameters = {
      'email': email,
      'password': password,
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.authLogin,
      parameter: parameters,
    );

    final apiResponse = ApiResponse.fromJson(
      response,
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
  }

  /// Quên mật khẩu
  Future<ApiResponse<dynamic>> forgotPassword({
    required String email,
  }) async {
    Map<String, dynamic> parameters = {
      'email': email,
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.authForgotPassword,
      parameter: parameters,
    );

    return ApiResponse.fromJson(response, (data) => data);
  }

  /// Đặt lại mật khẩu
  Future<ApiResponse<dynamic>> resetPassword({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    Map<String, dynamic> parameters = {
      'email': email,
      'reset_token': resetToken,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.authResetPassword,
      parameter: parameters,
    );

    return ApiResponse.fromJson(response, (data) => data);
  }

  /// Đổi mật khẩu (yêu cầu đăng nhập)
  Future<ApiResponse<dynamic>> changePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    final token = await getValidAccessToken();
    if (token == null) {
      throw ApiException('Please login to change password');
    }

    Map<String, dynamic> parameters = {
      'current_password': currentPassword,
      'password': password,
      'password_confirmation': passwordConfirmation,
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.authChangePassword,
      parameter: parameters,
    );

    return ApiResponse.fromJson(response, (data) => data);
  }

  /// Refresh token
  Future<ApiResponse<Map<String, dynamic>>> refreshToken({
    required String refreshToken,
  }) async {
    Map<String, dynamic> parameters = {
      'refresh_token': refreshToken,
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.authRefreshToken,
      parameter: parameters,
    );

    final apiResponse = ApiResponse.fromJson(
      response,
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
  }

  /// Đăng xuất
  Future<ApiResponse<dynamic>> logout() async {
    Map<String, dynamic> response = await Api.post(
      url: Api.authLogout,
      parameter: <String, dynamic>{},
    );

    // Xóa tất cả dữ liệu đã lưu
    await _clearTokens();
    await HiveUtils.clear();

    return ApiResponse.fromJson(response, (data) => data);
  }

  /// Lấy thông tin profile của user hiện tại
  Future<ApiResponse<User>> getProfile() async {
    final token = await getValidAccessToken();
    if (token == null) {
      throw ApiException('Please login to get profile');
    }

    Map<String, dynamic> response = await Api.get(
      url: Api.authGetProfile,
    );

    final apiResponse = ApiResponse.fromJson(
      response,
      (data) => User.fromJson(data as Map<String, dynamic>),
    );

    // Cập nhật user data vào Hive nếu thành công
    if (apiResponse.success && apiResponse.data != null) {
      await HiveUtils.setUserData(apiResponse.data!.toJson());
    }

    return apiResponse;
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
    final token = await getValidAccessToken();
    if (token == null) {
      throw ApiException('Please login to update profile');
    }

    final Map<String, dynamic> parameters = {'name': name};
    if (avatarId != null) parameters['avatar_id'] = avatarId;
    if (phone != null) parameters['phone'] = phone;
    if (dateOfBirth != null) parameters['date_of_birth'] = dateOfBirth;
    if (gender != null) parameters['gender'] = gender;
    if (address != null) parameters['address'] = address;

    Map<String, dynamic> response = await Api.put(
      url: Api.authUpdateProfile,
      parameter: parameters,
    );

    final apiResponse = ApiResponse.fromJson(
      response,
      (data) => User.fromJson(data as Map<String, dynamic>),
    );

    // Cập nhật user data vào Hive nếu thành công
    if (apiResponse.success && apiResponse.data != null) {
      await HiveUtils.setUserData(apiResponse.data!.toJson());
    }

    return apiResponse;
  }

  /// Upload ảnh
  Future<ApiResponse<Map<String, dynamic>>> uploadImage(
    String imagePath,
  ) async {
    final token = await getValidAccessToken();
    if (token == null) {
      throw ApiException('Please login to upload image');
    }

    Map<String, dynamic> parameters = {
      'image': imagePath,
    };

    Map<String, dynamic> response = await Api.post(
      url: Api.mediaUploadImage,
      parameter: parameters,
    );

    return ApiResponse.fromJson(
      response,
      (data) => data as Map<String, dynamic>,
    );
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
}
