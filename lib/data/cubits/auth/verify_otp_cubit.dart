import 'package:Celes/data/repositories/auth_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpInProgress extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  final Map<String, dynamic> data;
  final String message;

  VerifyOtpSuccess({
    required this.data,
    required this.message,
  });
}

class VerifyOtpFailure extends VerifyOtpState {
  final String errorMessage;
  final String? errorCode;

  VerifyOtpFailure({
    required this.errorMessage,
    this.errorCode,
  });
}

class ResendOtpInProgress extends VerifyOtpState {}

class ResendOtpSuccess extends VerifyOtpState {
  final String message;

  ResendOtpSuccess({required this.message});
}

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final AuthRepository _authRepository = AuthRepository();

  VerifyOtpCubit() : super(VerifyOtpInitial());

  Future<void> verifyOtp({
    required String email,
    required String otp,
    String type = 'register',
  }) async {
    emit(VerifyOtpInProgress());

    try {
      final response = await _authRepository.verifyOtp(
        email: email,
        otp: otp,
        type: type,
      );

      if (response.success && response.data != null) {
        emit(VerifyOtpSuccess(
          data: response.data!,
          message: response.message,
        ));
      } else {
        emit(VerifyOtpFailure(
          errorMessage: response.message,
        ));
      }
    } on ApiException catch (e) {
      emit(VerifyOtpFailure(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(VerifyOtpFailure(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  Future<void> resendOtp({
    required String email,
    String type = 'register',
  }) async {
    emit(ResendOtpInProgress());

    try {
      final response = await _authRepository.resendOtp(
        email: email,
        type: type,
      );

      if (response.success) {
        emit(ResendOtpSuccess(message: response.message));
      } else {
        emit(VerifyOtpFailure(
          errorMessage: response.message,
        ));
      }
    } on ApiException catch (e) {
      emit(VerifyOtpFailure(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(VerifyOtpFailure(
        errorMessage: 'Failed to resend OTP. Please try again.',
      ));
    }
  }

  void resetState() {
    emit(VerifyOtpInitial());
  }
}
