import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/repositories/auth_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== LOGIN STATES ====================

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginInProgress extends LoginState {}

class LoginSuccess extends LoginState {
  final Map<String, dynamic> data;
  final String message;

  LoginSuccess({
    required this.data,
    required this.message,
  });
}

class LoginFailure extends LoginState {
  final String errorMessage;
  final String? errorCode;

  LoginFailure({
    required this.errorMessage,
    this.errorCode,
  });
}

// ==================== LOGIN CUBIT ====================

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository _authRepository = AuthRepository();

  LoginCubit() : super(LoginInitial());

  /// Đăng nhập với email và password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(LoginInProgress());

    try {
      final ApiResponse<Map<String, dynamic>> response =
          await _authRepository.login(
        email: email,
        password: password,
      );

      if (response.success && response.data != null) {
        emit(LoginSuccess(
          data: response.data!,
          message: response.message,
        ));
      } else {
        emit(LoginFailure(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(LoginFailure(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(LoginFailure(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  /// Reset state về initial
  void resetState() {
    emit(LoginInitial());
  }
}
