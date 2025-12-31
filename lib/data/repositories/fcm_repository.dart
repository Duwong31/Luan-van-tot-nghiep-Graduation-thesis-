import 'package:Celes/utils/api.dart';

class FcmRepository {
  /// Gửi FCM token lên server
  /// POST /api/auth/fcm-token
  /// Body: { "fcm_token": "token_string" }
  Future<Map<String, dynamic>> sendFcmToken(String fcmToken) async {
    try {
      final response = await Api.post(
        url: Api.authFcmToken,
        parameter: {
          'fcm_token': fcmToken,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Lấy FCM token từ server (nếu API hỗ trợ GET)
  /// GET /api/auth/fcm-token
  Future<String?> getFcmToken() async {
    try {
      final response = await Api.get(
        url: Api.authFcmToken,
      );

      if (response['data'] != null && response['data']['fcm_token'] != null) {
        return response['data']['fcm_token'];
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }
}
