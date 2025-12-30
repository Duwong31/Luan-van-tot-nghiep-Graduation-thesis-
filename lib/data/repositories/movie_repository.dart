import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/movie_detail_model.dart';
import 'package:Celes/data/models/movie_showtimes_model.dart';
import 'package:Celes/utils/api.dart';

class MovieRepository {
  /// Lấy chi tiết phim
  Future<ApiResponse<MovieDetail>> getMovieDetail(int movieId) async {
    Map<String, dynamic> response = await Api.get(
      url: Api.movieDetail(movieId),
    );

    return ApiResponse.fromJson(
      response,
      (data) => MovieDetail.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Lấy lịch chiếu phim (không nhóm)
  /// GET /api/movies/{movieId}/showtimes
  Future<ApiResponse<MovieShowtimesData>> getMovieShowtimes(int movieId) async {
    Map<String, dynamic> response = await Api.get(
      url: Api.movieShowtimes(movieId),
    );

    return ApiResponse.fromJson(
      response,
      (data) => MovieShowtimesData.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Lấy lịch chiếu phim nhóm theo ngày
  /// GET /api/movies/{movieId}/showtimes?group_by_date=true
  Future<ApiResponse<MovieShowtimesGroupedData>> getShowtimesGroupedByDate(
      int movieId) async {
    Map<String, dynamic> response = await Api.get(
      url: Api.movieShowtimes(movieId),
      queryParameters: {'group_by_date': 'true'},
    );

    return ApiResponse.fromJson(
      response,
      (data) =>
          MovieShowtimesGroupedData.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Lấy lịch chiếu phim theo ngày cụ thể
  /// GET /api/movies/{movieId}/showtimes?date=2025-12-29
  /// [date] định dạng: yyyy-MM-dd
  Future<ApiResponse<MovieShowtimesData>> getShowtimesByDate(
    int movieId,
    String date,
  ) async {
    Map<String, dynamic> response = await Api.get(
      url: Api.movieShowtimes(movieId),
      queryParameters: {'date': date},
    );

    return ApiResponse.fromJson(
      response,
      (data) => MovieShowtimesData.fromJson(data as Map<String, dynamic>),
    );
  }

  /// Lấy lịch chiếu phim theo ngày (DateTime)
  /// Tự động format DateTime thành yyyy-MM-dd
  Future<ApiResponse<MovieShowtimesData>> getShowtimesByDateTime(
    int movieId,
    DateTime date,
  ) async {
    final dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return getShowtimesByDate(movieId, dateString);
  }
}
