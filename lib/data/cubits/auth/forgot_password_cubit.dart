import 'package:Celes/data/repositories/auth_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordInProgress extends ForgotPasswordState {}

class ForgotPasswordSuccess extends ForgotPasswordState {
  final String message;
  final String email;

  ForgotPasswordSuccess({
    required this.message,
    required this.email,
  });
}

class ForgotPasswordFailure extends ForgotPasswordState {
  final String errorMessage;
  final String? errorCode;

  ForgotPasswordFailure({
    required this.errorMessage,
    this.errorCode,
  });
}

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  final AuthRepository _authRepository = AuthRepository();

  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  Future<void> sendResetLink({
    required String email,
  }) async {
    emit(ForgotPasswordInProgress());

    try {
      final response = await _authRepository.forgotPassword(
        email: email,
      );

      if (response.success) {
        emit(ForgotPasswordSuccess(
          message: response.message,
          email: email,
        ));
      } else {
        emit(ForgotPasswordFailure(
          errorMessage: response.message,
        ));
      }
    } on ApiException catch (e) {
      emit(ForgotPasswordFailure(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(ForgotPasswordFailure(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  void resetState() {
    emit(ForgotPasswordInitial());
  }
}
