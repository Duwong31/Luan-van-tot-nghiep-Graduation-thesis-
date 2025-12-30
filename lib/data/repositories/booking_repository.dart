import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/booking_model.dart';
import 'package:Celes/data/models/calculate_price_model.dart';
import 'package:Celes/utils/api.dart';

class BookingRepository {
  /// Tính giá vé
  /// POST /api/bookings/calculate-price
  Future<ApiResponse<CalculatePriceData>> calculatePrice({
    required int showtimeId,
    required List<int> seatIds,
    String? voucherCode,
  }) async {
    final request = CalculatePriceRequest(
      showtimeId: showtimeId,
      seatIds: seatIds,
      voucherCode: voucherCode,
    );

    Map<String, dynamic> response = await Api.post(
      url: Api.bookingCalculatePrice,
      parameter: request.toJson(),
    );

    return ApiResponse.fromJson(
      response,
      (data) => CalculatePriceData.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Tạo booking
  /// POST /api/bookings
  Future<ApiResponse<BookingData>> createBooking({
    required int showtimeId,
    required List<int> seatIds,
    required String paymentMethod,
    String? voucherCode,
  }) async {
    final request = BookingRequest(
      showtimeId: showtimeId,
      seatIds: seatIds,
      paymentMethod: paymentMethod,
      voucherCode: voucherCode,
    );

    Map<String, dynamic> response = await Api.post(
      url: Api.bookingCreate,
      parameter: request.toJson(),
    );

    return ApiResponse.fromJson(
      response,
      (data) => BookingData.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Lấy chi tiết booking
  /// GET /api/bookings/{bookingId}
  Future<ApiResponse<Booking>> getBookingDetail(int bookingId) async {
    Map<String, dynamic> response = await Api.get(
      url: Api.bookingDetail(bookingId),
    );

    return ApiResponse.fromJson(
      response,
      (data) => Booking.fromJson(data as Map<String, dynamic>),
    );
  }
}
