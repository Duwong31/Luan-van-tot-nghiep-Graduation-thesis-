import 'package:Celes/data/services/token_service.dart';
import 'package:Celes/data/api_client.dart';

/// Example: Cách sử dụng TokenService và tự động refresh token
///
/// TokenService giúp:
/// 1. Lưu access_token và refresh_token vào SharedPreferences
/// 2. Tự động kiểm tra token hết hạn
/// 3. Tự động refresh token khi cần
/// 4. Cung cấp token hợp lệ cho API calls

class TokenUsageExample {
  final TokenService _tokenService = TokenService();
  final ApiClient _apiClient = ApiClient();

  /// Example 1: Sau khi login thành công
  Future<void> afterLoginSuccess({
    required String accessToken,
    required String refreshToken,
    int? expiresIn,
  }) async {
    // Lưu tokens
    await _tokenService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn, // Thời gian hết hạn (giây), ví dụ: 3600 = 1 giờ
    );

    print('✅ Tokens saved successfully');
  }

  /// Example 2: Lấy token để gọi API
  Future<void> makeApiCallWithToken() async {
    // Lấy token hợp lệ (tự động refresh nếu hết hạn)
    final token = await _tokenService.getValidAccessToken();

    if (token != null) {
      // Sử dụng token để gọi API
      final response = await _apiClient.get(
        'user/profile',
        token: token,
      );

      print('API Response: $response');
    } else {
      print('❌ No valid token, user needs to login again');
      // Navigate to login screen
    }
  }

  /// Example 3: Kiểm tra user đã login chưa
  Future<void> checkLoginStatus() async {
    final isLoggedIn = await _tokenService.isLoggedIn();

    if (isLoggedIn) {
      print('✅ User is logged in');
      // Navigate to home screen
    } else {
      print('❌ User is not logged in');
      // Navigate to login screen
    }
  }

  /// Example 4: Logout
  Future<void> logout() async {
    // Xóa tất cả tokens
    await _tokenService.clearTokens();

    print('✅ User logged out');
    // Navigate to login screen
  }

  /// Example 5: Manual refresh token
  Future<void> manualRefreshToken() async {
    final newToken = await _tokenService.refreshAccessToken();

    if (newToken != null) {
      print('✅ Token refreshed successfully');
      print('New Access Token: ${newToken.substring(0, 20)}...');
    } else {
      print('❌ Failed to refresh token');
      // Navigate to login screen
    }
  }

  /// Example 6: Kiểm tra token có hết hạn không
  Future<void> checkTokenExpiry() async {
    final isExpired = await _tokenService.isTokenExpired();

    if (isExpired) {
      print('⚠️ Token expired, refreshing...');
      await _tokenService.refreshAccessToken();
    } else {
      print('✅ Token is still valid');
    }
  }
}

/// ============================================
/// CÁCH SỬ DỤNG TRONG APP
/// ============================================

/// 1. Sau khi login thành công (trong LoginScreen):
/// ```dart
/// final tokenService = TokenService();
/// 
/// // Lưu tokens
/// await tokenService.saveTokens(
///   accessToken: response.data!['access_token'],
///   refreshToken: response.data!['refresh_token'],
///   expiresIn: response.data!['expires_in'],
/// );
/// ```

/// 2. Khi gọi API cần authentication:
/// ```dart
/// final tokenService = TokenService();
/// final token = await tokenService.getValidAccessToken();
/// 
/// if (token != null) {
///   final response = await apiClient.get('endpoint', token: token);
/// } else {
///   // Navigate to login
/// }
/// ```

/// 3. Kiểm tra login status khi mở app:
/// ```dart
/// final tokenService = TokenService();
/// final isLoggedIn = await tokenService.isLoggedIn();
/// 
/// if (isLoggedIn) {
///   // Go to home
/// } else {
///   // Go to login
/// }
/// ```

/// 4. Logout:
/// ```dart
/// final tokenService = TokenService();
/// await tokenService.clearTokens();
/// // Navigate to login screen
/// ```

/// ============================================
/// API REFRESH TOKEN
/// ============================================

/// Endpoint: POST api/auth/refresh
/// Request Body:
/// ```json
/// {
///   "refresh_token": "eyJ0eXAiOiJKV1QiLCJhbGc..."
/// }
/// ```

/// Response:
/// ```json
/// {
///   "success": true,
///   "code": "TOKEN_REFRESHED",
///   "message": "Token refreshed successfully",
///   "data": {
///     "access_token": "new_access_token_here",
///     "refresh_token": "new_refresh_token_here",
///     "token_type": "Bearer",
///     "expires_in": 3600
///   }
/// }
/// ```

/// ============================================
/// LƯU Ý
/// ============================================

/// 1. TokenService tự động refresh token khi:
///    - Token hết hạn (dựa vào expires_in)
///    - Gọi getValidAccessToken()

/// 2. Nếu refresh token cũng hết hạn:
///    - API sẽ trả về lỗi
///    - User cần đăng nhập lại

/// 3. Tokens được lưu trong SharedPreferences:
///    - access_token
///    - refresh_token
///    - token_expiry (thời gian hết hạn)

/// 4. Để xóa tokens khi logout:
///    - Gọi tokenService.clearTokens()
///    - Navigate về login screen
