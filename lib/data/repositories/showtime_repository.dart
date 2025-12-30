import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/showtime_seats_model.dart';
import 'package:Celes/utils/api.dart';

class ShowtimeRepository {
  /// Lấy danh sách ghế của suất chiếu
  /// GET /api/showtimes/{showtimeId}/seats
  Future<ApiResponse<ShowtimeSeatsData>> getShowtimeSeats(
      int showtimeId) async {
    Map<String, dynamic> response = await Api.get(
      url: Api.showtimeSeats(showtimeId),
    );

    return ApiResponse.fromJson(
      response,
      (data) => ShowtimeSeatsData.fromJson(data as Map<String, dynamic>),
    );
  }
}
