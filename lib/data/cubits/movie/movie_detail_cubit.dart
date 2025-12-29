import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/movie_detail_model.dart';
import 'package:Celes/data/repositories/movie_repository.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ==================== MOVIE DETAIL STATES ====================

abstract class MovieDetailState {}

class MovieDetailInitial extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movieDetail;
  final String message;

  MovieDetailLoaded({
    required this.movieDetail,
    required this.message,
  });
}

class MovieDetailError extends MovieDetailState {
  final String errorMessage;
  final String? errorCode;

  MovieDetailError({
    required this.errorMessage,
    this.errorCode,
  });
}

// ==================== MOVIE DETAIL CUBIT ====================

class MovieDetailCubit extends Cubit<MovieDetailState> {
  final MovieRepository _movieRepository = MovieRepository();

  MovieDetailCubit() : super(MovieDetailInitial());

  Future<void> fetchMovieDetail(int movieId) async {
    emit(MovieDetailLoading());

    try {
      final ApiResponse<MovieDetail> response =
          await _movieRepository.getMovieDetail(movieId);

      if (response.success && response.data != null) {
        emit(MovieDetailLoaded(
          movieDetail: response.data!,
          message: response.message,
        ));
      } else {
        emit(MovieDetailError(
          errorMessage: response.message,
          errorCode: response.code,
        ));
      }
    } on ApiException catch (e) {
      emit(MovieDetailError(
        errorMessage: e.message,
        errorCode: e.code,
      ));
    } catch (e) {
      emit(MovieDetailError(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      ));
    }
  }

  void resetState() {
    emit(MovieDetailInitial());
  }
}
