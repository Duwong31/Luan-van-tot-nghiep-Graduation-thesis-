import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/notification_model.dart';
import 'package:Celes/data/repositories/notification_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== NOTIFICATION STATES ====================

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final NotificationListData notificationData;
  final String message;

  NotificationLoaded({
    required this.notificationData,
    required this.message,
  });

  /// Get unread count
  int get unreadCount => notificationData.unreadCount;

  /// Get all notifications
  List<NotificationItem> get notifications => notificationData.notifications;

  /// Get only unread notifications
  List<NotificationItem> get unreadNotifications =>
      notificationData.notifications.where((n) => !n.isRead).toList();

  /// Get only read notifications
  List<NotificationItem> get readNotifications =>
      notificationData.notifications.where((n) => n.isRead).toList();
}

class NotificationError extends NotificationState {
  final String errorMessage;
  final String? errorCode;

  NotificationError({
    required this.errorMessage,
    this.errorCode,
  });
}

// ==================== NOTIFICATION CUBIT ====================

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _notificationRepository =
      NotificationRepository();

  NotificationCubit() : super(NotificationInitial());

  /// Fetch notifications from API
  Future<void> fetchNotifications() async {
    emit(NotificationLoading());

    try {
      final ApiResponse<NotificationListData> response =
          await _notificationRepository.getNotifications();

      if (response.success && response.data != null) {
        emit(NotificationLoaded(
          notificationData: response.data!,
          message: response.message,
        ));
      } else {
        emit(NotificationError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(NotificationError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(NotificationError(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  /// Refresh notifications
  Future<void> refreshNotifications() async {
    await fetchNotifications();
  }

  /// Reset state to initial
  void resetState() {
    emit(NotificationInitial());
  }

  /// Mark notification as read locally (update state)
  void markAsReadLocally(int notificationId) {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      final updatedNotifications =
          currentState.notifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(
            isRead: true,
            readAt: DateTime.now().toString(),
          );
        }
        return notification;
      }).toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      emit(NotificationLoaded(
        notificationData: NotificationListData(
          unreadCount: unreadCount,
          notifications: updatedNotifications,
        ),
        message: currentState.message,
      ));
    }
  }

  /// Remove notification locally (update state)
  void removeNotificationLocally(int notificationId) {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      final updatedNotifications = currentState.notifications
          .where((notification) => notification.id != notificationId)
          .toList();

      final unreadCount = updatedNotifications.where((n) => !n.isRead).length;

      emit(NotificationLoaded(
        notificationData: NotificationListData(
          unreadCount: unreadCount,
          notifications: updatedNotifications,
        ),
        message: currentState.message,
      ));
    }
  }
}
