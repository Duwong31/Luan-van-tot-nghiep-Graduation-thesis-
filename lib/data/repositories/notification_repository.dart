import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/notification_model.dart';
import 'package:Celes/utils/api.dart';

class NotificationRepository {
  /// Get list of notifications
  Future<ApiResponse<NotificationListData>> getNotifications() async {
    try {
      final response = await Api.get(url: Api.notificationsList);

      return ApiResponse.fromJson(
        response,
        (data) => NotificationListData.fromJson(data as Map<String, dynamic>),
      );
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  /// Mark notification as read (placeholder - implement when API is available)
  Future<ApiResponse<void>> markAsRead(int notificationId) async {
    try {
      // This would be implemented when the mark-as-read API is available
      // final response = await Api.put(
      //   url: 'notifications/$notificationId/read',
      //   parameter: {},
      // );

      throw UnimplementedError('Mark as read API not yet implemented');
    } catch (e) {
      throw Exception('Failed to mark notification as read: $e');
    }
  }

  /// Delete notification (placeholder - implement when API is available)
  Future<ApiResponse<void>> deleteNotification(int notificationId) async {
    try {
      // This would be implemented when the delete API is available
      // final response = await Api.delete(
      //   url: 'notifications/$notificationId',
      // );

      throw UnimplementedError('Delete notification API not yet implemented');
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }
}
