import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/user_model.dart';
import 'package:Celes/data/repositories/auth_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:Celes/utils/hive_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

// ==================== PROFILE STATES ====================

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;

  ProfileLoaded({required this.user});
}

class ProfileError extends ProfileState {
  final String errorMessage;

  ProfileError({required this.errorMessage});
}

// ==================== LOGOUT STATES ====================

class LogoutLoading extends ProfileState {
  final User? user;

  LogoutLoading({this.user});
}

class LogoutSuccess extends ProfileState {}

class LogoutError extends ProfileState {
  final String errorMessage;
  final User? user;

  LogoutError({required this.errorMessage, this.user});
}

// ==================== PROFILE CUBIT ====================

class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository = AuthRepository();
  User? _currentUser;

  ProfileCubit() : super(ProfileInitial());

  /// Get current user
  User? get currentUser => _currentUser;

  /// Load user from cache
  void loadUserFromCache() {
    try {
      final Map<String, dynamic> data =
          Map<String, dynamic>.from(Hive.box(HiveKeys.userDetailsBox).toMap());
      if (data.containsKey('id')) {
        _currentUser = User.fromJson(data);
        emit(ProfileLoaded(user: _currentUser!));
      }
    } catch (e) {
      // Ignore cache errors
    }
  }

  /// Fetch profile from API
  Future<void> fetchProfile() async {
    // Don't show loading if we already have cached user
    if (_currentUser == null) {
      emit(ProfileLoading());
    }

    try {
      final ApiResponse<User> response = await _authRepository.getProfile();

      if (response.success && response.data != null) {
        _currentUser = response.data!;
        emit(ProfileLoaded(user: _currentUser!));
      } else {
        emit(ProfileError(errorMessage: response.message));
      }
    } on ApiException catch (e) {
      emit(ProfileError(errorMessage: e.message));
    } catch (e) {
      emit(ProfileError(errorMessage: 'Có lỗi xảy ra: ${e.toString()}'));
    }
  }

  /// Logout
  Future<void> logout() async {
    final previousUser = _currentUser;
    emit(LogoutLoading(user: previousUser));

    try {
      final response = await _authRepository.logout();

      if (response.success) {
        _currentUser = null;
        emit(LogoutSuccess());
      } else {
        emit(LogoutError(
          errorMessage: response.message,
          user: previousUser,
        ));
      }
    } on ApiException catch (e) {
      emit(LogoutError(
        errorMessage: e.message,
        user: previousUser,
      ));
    } catch (e) {
      emit(LogoutError(
        errorMessage: 'Có lỗi xảy ra: ${e.toString()}',
        user: previousUser,
      ));
    }
  }

  /// Refresh profile
  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  /// Reset state
  void resetState() {
    _currentUser = null;
    emit(ProfileInitial());
  }
}
