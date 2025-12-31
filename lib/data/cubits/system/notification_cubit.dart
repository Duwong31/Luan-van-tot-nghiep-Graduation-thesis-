import 'package:bloc/bloc.dart';
import 'package:Celes/data/repositories/fcm_repository.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final FcmRepository _fcmRepository;

  NotificationCubit(this._fcmRepository) : super(NotificationInitial());

  /// Gửi FCM token lên server
  Future<void> sendFcmToken(String fcmToken) async {
    try {
      emit(NotificationLoading());
      
      await _fcmRepository.sendFcmToken(fcmToken);
      
      emit(NotificationTokenSent(fcmToken));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  /// Lấy FCM token từ server
  Future<void> getFcmToken() async {
    try {
      emit(NotificationLoading());
      
      final token = await _fcmRepository.getFcmToken();
      
      if (token != null) {
        emit(NotificationTokenLoaded(token));
      } else {
        emit(NotificationError('No FCM token found'));
      }
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  /// Reset state về initial
  void resetState() {
    emit(NotificationInitial());
  }
}

// ==================== STATES ====================

abstract class NotificationState {}

/// Initial state
class NotificationInitial extends NotificationState {}

/// Loading state
class NotificationLoading extends NotificationState {}

/// State khi token đã được gửi thành công
class NotificationTokenSent extends NotificationState {
  final String fcmToken;

  NotificationTokenSent(this.fcmToken);
}

/// State khi token được load từ server
class NotificationTokenLoaded extends NotificationState {
  final String fcmToken;

  NotificationTokenLoaded(this.fcmToken);
}

/// Error state
class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
