import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/calculate_price_model.dart';
import 'package:Celes/data/repositories/booking_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== CALCULATE PRICE STATES ====================

abstract class CalculatePriceState {}

class CalculatePriceInitial extends CalculatePriceState {}

class CalculatePriceLoading extends CalculatePriceState {}

class CalculatePriceLoaded extends CalculatePriceState {
  final CalculatePriceData priceData;
  final String message;

  CalculatePriceLoaded({
    required this.priceData,
    required this.message,
  });

  /// Get movie title
  String get movieTitle => priceData.movieTitle;

  /// Get genre
  String get genre => priceData.genre;

  /// Get seat labels
  String get seatLabels => priceData.seatLabels;

  /// Get seat count
  int get seatCount => priceData.seatCount;

  /// Get original price
  int get price => priceData.price;

  /// Get discount
  int get discount => priceData.voucherDiscount ?? 0;

  /// Get total price
  int get totalPrice => priceData.totalPrice;

  /// Check if voucher is applied
  bool get hasVoucher => priceData.hasVoucher;

  /// Get voucher code
  String? get voucherCode => priceData.voucherCode;

  /// Get formatted price
  String get formattedPrice => priceData.formattedPrice;

  /// Get formatted discount
  String get formattedDiscount => priceData.formattedDiscount;

  /// Get formatted total price
  String get formattedTotalPrice => priceData.formattedTotalPrice;
}

class CalculatePriceError extends CalculatePriceState {
  final String errorMessage;
  final String? errorCode;

  CalculatePriceError({
    required this.errorMessage,
    this.errorCode,
  });
}

// ==================== CALCULATE PRICE CUBIT ====================

class CalculatePriceCubit extends Cubit<CalculatePriceState> {
  final BookingRepository _bookingRepository = BookingRepository();

  // Store current params for re-calculation with voucher
  int? _currentShowtimeId;
  List<int>? _currentSeatIds;
  String? _currentVoucherCode;

  CalculatePriceCubit() : super(CalculatePriceInitial());

  /// Calculate price for selected seats
  Future<void> calculatePrice({
    required int showtimeId,
    required List<int> seatIds,
    String? voucherCode,
  }) async {
    emit(CalculatePriceLoading());

    // Store params
    _currentShowtimeId = showtimeId;
    _currentSeatIds = seatIds;
    _currentVoucherCode = voucherCode;

    try {
      final ApiResponse<CalculatePriceData> response =
          await _bookingRepository.calculatePrice(
        showtimeId: showtimeId,
        seatIds: seatIds,
        voucherCode: voucherCode,
      );

      if (response.success && response.data != null) {
        emit(CalculatePriceLoaded(
          priceData: response.data!,
          message: response.message,
        ));
      } else {
        emit(CalculatePriceError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(CalculatePriceError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(CalculatePriceError(
        errorMessage: 'Có lỗi xảy ra: ${e.toString()}',
      ));
    }
  }

  /// Apply voucher code (re-calculate with voucher)
  Future<void> applyVoucher(String voucherCode) async {
    if (_currentShowtimeId == null || _currentSeatIds == null) {
      emit(CalculatePriceError(
        errorMessage: 'Vui lòng chọn ghế trước khi áp dụng mã giảm giá',
      ));
      return;
    }

    await calculatePrice(
      showtimeId: _currentShowtimeId!,
      seatIds: _currentSeatIds!,
      voucherCode: voucherCode,
    );
  }

  /// Remove voucher (re-calculate without voucher)
  Future<void> removeVoucher() async {
    if (_currentShowtimeId == null || _currentSeatIds == null) {
      return;
    }

    _currentVoucherCode = null;

    await calculatePrice(
      showtimeId: _currentShowtimeId!,
      seatIds: _currentSeatIds!,
    );
  }

  /// Get current voucher code
  String? get currentVoucherCode => _currentVoucherCode;

  /// Reset state
  void resetState() {
    _currentShowtimeId = null;
    _currentSeatIds = null;
    _currentVoucherCode = null;
    emit(CalculatePriceInitial());
  }
}
