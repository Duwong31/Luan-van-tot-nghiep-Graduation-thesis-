import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/movie_showtimes_model.dart';
import 'package:Celes/data/repositories/movie_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== MOVIE SHOWTIMES STATES ====================

abstract class MovieShowtimesState {}

class MovieShowtimesInitial extends MovieShowtimesState {}

class MovieShowtimesLoading extends MovieShowtimesState {}

class MovieShowtimesLoaded extends MovieShowtimesState {
  final MovieShowtimesData showtimesData;
  final String message;

  MovieShowtimesLoaded({
    required this.showtimesData,
    required this.message,
  });

  /// Check if there are any showtimes
  bool get hasShowtimes => showtimesData.hasShowtimes;

  /// Get movie title
  String get movieTitle => showtimesData.movie.title;

  /// Get all showtimes
  List get showtimes => showtimesData.showtimes;

  /// Get available dates
  List<String> get availableDates => showtimesData.availableDates;

  /// Get available cinemas
  List<String> get availableCinemas => showtimesData.availableCinemas;
}

/// State cho grouped showtimes (group_by_date=true)
class MovieShowtimesGroupedLoaded extends MovieShowtimesState {
  final MovieShowtimesGroupedData groupedData;
  final String message;

  MovieShowtimesGroupedLoaded({
    required this.groupedData,
    required this.message,
  });

  /// Check if there are any schedules
  bool get hasSchedule => groupedData.hasSchedule;

  /// Get movie title
  String get movieTitle => groupedData.movie.title;

  /// Get all schedule items
  List<ScheduleItem> get schedule => groupedData.schedule;

  /// Get available dates
  List<String> get availableDates => groupedData.availableDates;

  /// Get schedule by date
  ScheduleItem? getScheduleByDate(String date) =>
      groupedData.getScheduleByDate(date);
}

class MovieShowtimesEmpty extends MovieShowtimesState {
  final String movieTitle;
  final String message;

  MovieShowtimesEmpty({
    required this.movieTitle,
    required this.message,
  });
}

class MovieShowtimesError extends MovieShowtimesState {
  final String errorMessage;
  final String? errorCode;

  MovieShowtimesError({
    required this.errorMessage,
    this.errorCode,
  });
}

// ==================== MOVIE SHOWTIMES CUBIT ====================

class MovieShowtimesCubit extends Cubit<MovieShowtimesState> {
  final MovieRepository _movieRepository = MovieRepository();

  MovieShowtimesCubit() : super(MovieShowtimesInitial());

  /// Lấy lịch chiếu phim (không nhóm)
  Future<void> fetchMovieShowtimes(int movieId) async {
    emit(MovieShowtimesLoading());

    try {
      final ApiResponse<MovieShowtimesData> response =
          await _movieRepository.getMovieShowtimes(movieId);

      if (response.success && response.data != null) {
        final data = response.data!;

        // Check if there are any showtimes
        if (data.hasShowtimes) {
          emit(MovieShowtimesLoaded(
            showtimesData: data,
            message: response.message,
          ));
        } else {
          emit(MovieShowtimesEmpty(
            movieTitle: data.movie.title,
            message: 'Không có suất chiếu nào cho phim này',
          ));
        }
      } else {
        emit(MovieShowtimesError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(MovieShowtimesError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(MovieShowtimesError(
        errorMessage: 'Có lỗi xảy ra: ${e.toString()}',
      ));
    }
  }

  /// Lấy lịch chiếu phim nhóm theo ngày
  /// GET /api/movies/{movieId}/showtimes?group_by_date=true
  Future<void> fetchShowtimesGroupedByDate(int movieId) async {
    emit(MovieShowtimesLoading());

    try {
      final ApiResponse<MovieShowtimesGroupedData> response =
          await _movieRepository.getShowtimesGroupedByDate(movieId);

      if (response.success && response.data != null) {
        final data = response.data!;

        if (data.hasSchedule) {
          emit(MovieShowtimesGroupedLoaded(
            groupedData: data,
            message: response.message,
          ));
        } else {
          emit(MovieShowtimesEmpty(
            movieTitle: data.movie.title,
            message: 'Không có suất chiếu nào cho phim này',
          ));
        }
      } else {
        emit(MovieShowtimesError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(MovieShowtimesError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(MovieShowtimesError(
        errorMessage: 'Có lỗi xảy ra: ${e.toString()}',
      ));
    }
  }

  /// Lấy lịch chiếu phim theo ngày cụ thể
  /// GET /api/movies/{movieId}/showtimes?date=2025-12-29
  Future<void> fetchShowtimesByDate(int movieId, String date) async {
    emit(MovieShowtimesLoading());

    try {
      final ApiResponse<MovieShowtimesData> response =
          await _movieRepository.getShowtimesByDate(movieId, date);

      if (response.success && response.data != null) {
        final data = response.data!;

        if (data.hasShowtimes) {
          emit(MovieShowtimesLoaded(
            showtimesData: data,
            message: response.message,
          ));
        } else {
          emit(MovieShowtimesEmpty(
            movieTitle: data.movie.title,
            message: 'Không có suất chiếu nào cho ngày này',
          ));
        }
      } else {
        emit(MovieShowtimesError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(MovieShowtimesError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(MovieShowtimesError(
        errorMessage: 'Có lỗi xảy ra: ${e.toString()}',
      ));
    }
  }

  /// Lấy lịch chiếu phim theo ngày (DateTime)
  Future<void> fetchShowtimesByDateTime(int movieId, DateTime date) async {
    final dateString =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return fetchShowtimesByDate(movieId, dateString);
  }

  void resetState() {
    emit(MovieShowtimesInitial());
  }
}
