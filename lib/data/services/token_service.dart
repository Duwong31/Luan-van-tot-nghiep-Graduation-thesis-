import 'package:Celes/data/services/auth_service.dart';
import 'package:Celes/utils/hive_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service để quản lý token (access token và refresh token)
class TokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenExpiryKey = 'token_expiry';

  final AuthService _authService = AuthService();

  /// Lưu tokens vào local storage
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    int? expiresIn, // Thời gian hết hạn tính bằng giây
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);

    if (expiresIn != null) {
      final expiryTime = DateTime.now().add(Duration(seconds: expiresIn));
      await prefs.setString(_tokenExpiryKey, expiryTime.toIso8601String());
    }
  }

  /// Lấy access token
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Lấy refresh token
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Kiểm tra xem token có hết hạn không
  Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryString = prefs.getString(_tokenExpiryKey);

    if (expiryString == null) return true;

    final expiryTime = DateTime.parse(expiryString);
    return DateTime.now().isAfter(expiryTime);
  }

  /// Refresh access token sử dụng refresh token
  Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await getRefreshToken();

      if (refreshToken == null) {
        throw Exception('No refresh token found');
      }

      final response = await _authService.refreshToken(
        refreshToken: refreshToken,
      );

      if (response.success && response.data != null) {
        final newAccessToken = response.data!['access_token'] as String?;
        final newRefreshToken = response.data!['refresh_token'] as String?;
        final expiresIn = response.data!['expires_in'] as int?;

        if (newAccessToken != null && newRefreshToken != null) {
          await saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
            expiresIn: expiresIn,
          );

          return newAccessToken;
        }
      }

      return null;
    } catch (e) {
      print('Error refreshing token: $e');
      return null;
    }
  }

  /// Lấy access token hợp lệ (tự động refresh nếu hết hạn)
  Future<String?> getValidAccessToken() async {
    final isExpired = await isTokenExpired();

    if (isExpired) {
      // Token hết hạn, thử refresh
      return await refreshAccessToken();
    } else {
      // Token còn hạn, trả về luôn
      return await getAccessToken();
    }
  }

  /// Xóa tất cả tokens (logout)
  Future<void> clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_tokenExpiryKey);

    // ✅ FIX: Also clear authentication status in Hive
    HiveUtils.setUserIsAuthenticated(false);
  }

  /// Kiểm tra xem user đã đăng nhập chưa
  Future<bool> isLoggedIn() async {
    final accessToken = await getAccessToken();
    return accessToken != null;
  }
}
