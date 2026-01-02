import 'package:Celes/data/models/user_model.dart';
import 'package:Celes/data/repositories/auth_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterInProgress extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final User user;
  final String message;

  RegisterSuccess({
    required this.user,
    required this.message,
  });
}

class RegisterFailure extends RegisterState {
  final String errorMessage;
  final String? errorCode;

  RegisterFailure({
    required this.errorMessage,
    this.errorCode,
  });
}

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository _authRepository = AuthRepository();

  RegisterCubit() : super(RegisterInitial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    emit(RegisterInProgress());

    try {
      final response = await _authRepository.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
      );

      if (response.success && response.data != null) {
        emit(RegisterSuccess(
          user: response.data!,
          message: response.message,
        ));
      } else {
        emit(RegisterFailure(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(RegisterFailure(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(RegisterFailure(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  void resetState() {
    emit(RegisterInitial());
  }
}
