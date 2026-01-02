import 'package:Celes/data/repositories/auth_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordInProgress extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {
  final String message;

  ResetPasswordSuccess({required this.message});
}

class ResetPasswordFailure extends ResetPasswordState {
  final String errorMessage;
  final String? errorCode;

  ResetPasswordFailure({
    required this.errorMessage,
    this.errorCode,
  });
}

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final AuthRepository _authRepository = AuthRepository();

  ResetPasswordCubit() : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String email,
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ResetPasswordInProgress());

    try {
      final response = await _authRepository.resetPassword(
        email: email,
        resetToken: resetToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (response.success) {
        emit(ResetPasswordSuccess(message: response.message));
      } else {
        emit(ResetPasswordFailure(
          errorMessage: response.message,
        ));
      }
    } on ApiException catch (e) {
      emit(ResetPasswordFailure(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(ResetPasswordFailure(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  void resetState() {
    emit(ResetPasswordInitial());
  }
}
