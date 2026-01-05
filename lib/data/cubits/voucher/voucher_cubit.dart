import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/voucher_model.dart';
import 'package:Celes/data/repositories/voucher_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== VOUCHER STATES ====================

abstract class VoucherState {}

class VoucherInitial extends VoucherState {}

class VoucherLoading extends VoucherState {}

class VoucherLoaded extends VoucherState {
  final List<Voucher> vouchers;
  final String message;

  VoucherLoaded({
    required this.vouchers,
    required this.message,
  });

  /// Get active vouchers
  List<Voucher> get activeVouchers =>
      vouchers.where((v) => v.isValid && !v.hasReachedLimit).toList();

  /// Get expired vouchers
  List<Voucher> get expiredVouchers =>
      vouchers.where((v) => !v.isValid).toList();

  /// Get used up vouchers
  List<Voucher> get usedUpVouchers =>
      vouchers.where((v) => v.hasReachedLimit).toList();
}

class VoucherError extends VoucherState {
  final String errorMessage;
  final String? errorCode;

  VoucherError({
    required this.errorMessage,
    this.errorCode,
  });
}

// Voucher validation states
class VoucherValidating extends VoucherState {}

class VoucherValidated extends VoucherState {
  final Voucher voucher;
  final String message;

  VoucherValidated({
    required this.voucher,
    required this.message,
  });
}

class VoucherValidationError extends VoucherState {
  final String errorMessage;

  VoucherValidationError({required this.errorMessage});
}

// ==================== VOUCHER CUBIT ====================

class VoucherCubit extends Cubit<VoucherState> {
  final VoucherRepository _voucherRepository = VoucherRepository();

  VoucherCubit() : super(VoucherInitial());

  /// Fetch all vouchers
  Future<void> fetchVouchers() async {
    emit(VoucherLoading());

    try {
      final ApiResponse<List<Voucher>> response =
          await _voucherRepository.getVouchers();

      if (response.success && response.data != null) {
        emit(VoucherLoaded(
          vouchers: response.data!,
          message: response.message,
        ));
      } else {
        emit(VoucherError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(VoucherError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(VoucherError(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  /// Fetch only active vouchers
  Future<void> fetchActiveVouchers() async {
    emit(VoucherLoading());

    try {
      final ApiResponse<List<Voucher>> response =
          await _voucherRepository.getActiveVouchers();

      if (response.success && response.data != null) {
        emit(VoucherLoaded(
          vouchers: response.data!,
          message: response.message,
        ));
      } else {
        emit(VoucherError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(VoucherError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(VoucherError(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  /// Validate voucher code
  Future<void> validateVoucher(String code) async {
    emit(VoucherValidating());

    try {
      final ApiResponse<Voucher> response =
          await _voucherRepository.validateVoucher(code);

      if (response.success && response.data != null) {
        emit(VoucherValidated(
          voucher: response.data!,
          message: response.message,
        ));
      } else {
        emit(VoucherValidationError(
          errorMessage: response.message,
        ));
      }
    } catch (e) {
      emit(VoucherValidationError(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      ));
    }
  }

  /// Refresh vouchers
  Future<void> refreshVouchers() async {
    await fetchVouchers();
  }

  /// Reset state
  void resetState() {
    emit(VoucherInitial());
  }

  /// Reset validation state back to loaded vouchers
  void resetValidation() {
    if (state is VoucherLoaded) {
      // Keep the loaded state
      return;
    }
    // Otherwise go back to initial
    emit(VoucherInitial());
  }
}
