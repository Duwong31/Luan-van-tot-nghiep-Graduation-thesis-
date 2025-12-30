import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/booking_model.dart';
import 'package:Celes/data/repositories/booking_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== BOOKING STATES ====================

abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingCreated extends BookingState {
  final BookingData bookingData;
  final String message;

  BookingCreated({
    required this.bookingData,
    required this.message,
  });

  /// Get booking info
  Booking get booking => bookingData.booking;

  /// Get payment info
  PaymentInfo get payment => bookingData.payment;

  /// Get checkout URL for VNPay
  String? get checkoutUrl => bookingData.checkoutUrl;

  /// Get client secret for Stripe
  String? get clientSecret => bookingData.clientSecret;

  /// Get booking code
  String get bookingCode => bookingData.bookingCode;

  /// Check if VNPay payment
  bool get isVnpay => payment.isVnpay;

  /// Check if Stripe payment
  bool get isStripe => payment.isStripe;
}

class BookingError extends BookingState {
  final String errorMessage;
  final String? errorCode;

  BookingError({
    required this.errorMessage,
    this.errorCode,
  });
}

class BookingDetailLoading extends BookingState {}

class BookingDetailLoaded extends BookingState {
  final Booking booking;
  final String message;

  BookingDetailLoaded({
    required this.booking,
    required this.message,
  });
}

class BookingDetailError extends BookingState {
  final String errorMessage;
  final String? errorCode;

  BookingDetailError({
    required this.errorMessage,
    this.errorCode,
  });
}

// ==================== BOOKING CUBIT ====================

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _bookingRepository = BookingRepository();

  BookingCubit() : super(BookingInitial());

  /// Create booking
  Future<void> createBooking({
    required int showtimeId,
    required List<int> seatIds,
    required String paymentMethod,
    String? voucherCode,
  }) async {
    emit(BookingLoading());

    try {
      final ApiResponse<BookingData> response =
          await _bookingRepository.createBooking(
        showtimeId: showtimeId,
        seatIds: seatIds,
        paymentMethod: paymentMethod,
        voucherCode: voucherCode,
      );

      if (response.success && response.data != null) {
        emit(BookingCreated(
          bookingData: response.data!,
          message: response.message,
        ));
      } else {
        emit(BookingError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(BookingError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(BookingError(
        errorMessage: 'Có lỗi xảy ra: ${e.toString()}',
      ));
    }
  }

  /// Get booking detail
  Future<void> getBookingDetail(int bookingId) async {
    emit(BookingDetailLoading());

    try {
      final ApiResponse<Booking> response =
          await _bookingRepository.getBookingDetail(bookingId);

      if (response.success && response.data != null) {
        emit(BookingDetailLoaded(
          booking: response.data!,
          message: response.message,
        ));
      } else {
        emit(BookingDetailError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(BookingDetailError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(BookingDetailError(
        errorMessage: 'Có lỗi xảy ra: ${e.toString()}',
      ));
    }
  }

  /// Reset state
  void resetState() {
    emit(BookingInitial());
  }
}
