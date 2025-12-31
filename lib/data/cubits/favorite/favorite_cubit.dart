import 'package:Celes/data/models/movie_model.dart';
import 'package:Celes/data/repositories/favorite_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// States
abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Movie> movies;
  final int currentPage;
  final int lastPage;
  final int total;
  final bool hasMore;

  FavoriteLoaded({
    required this.movies,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.hasMore,
  });

  FavoriteLoaded copyWith({
    List<Movie>? movies,
    int? currentPage,
    int? lastPage,
    int? total,
    bool? hasMore,
  }) {
    return FavoriteLoaded(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError(this.message);
}

class FavoriteActionLoading extends FavoriteState {}

class FavoriteActionSuccess extends FavoriteState {
  final String message;
  final bool isFavorited;

  FavoriteActionSuccess({
    required this.message,
    required this.isFavorited,
  });
}

class FavoriteActionError extends FavoriteState {
  final String message;

  FavoriteActionError(this.message);
}

// Cubit
class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepository _repository;

  FavoriteCubit(this._repository) : super(FavoriteInitial());

  /// Lấy danh sách phim yêu thích
  Future<void> fetchFavorites({int page = 1, bool loadMore = false}) async {
    try {
      if (loadMore) {
        // Không emit loading state khi load more
      } else {
        emit(FavoriteLoading());
      }

      final response = await _repository.getFavorites(page: page);

      if (response['success'] == true) {
        final movies = _repository.parseFavoriteMovies(response);
        final meta = _repository.getPaginationMeta(response);

        final currentPage = meta?['current_page'] ?? 1;
        final lastPage = meta?['last_page'] ?? 1;
        final total = meta?['total'] ?? 0;
        final hasMore = currentPage < lastPage;

        if (loadMore && state is FavoriteLoaded) {
          final currentState = state as FavoriteLoaded;
          emit(FavoriteLoaded(
            movies: [...currentState.movies, ...movies],
            currentPage: currentPage,
            lastPage: lastPage,
            total: total,
            hasMore: hasMore,
          ));
        } else {
          emit(FavoriteLoaded(
            movies: movies,
            currentPage: currentPage,
            lastPage: lastPage,
            total: total,
            hasMore: hasMore,
          ));
        }
      } else {
        emit(FavoriteError(response['message'] ?? 'Failed to fetch favorites'));
      }
    } catch (e) {
      emit(FavoriteError(e.toString()));
    }
  }

  /// Thêm phim vào yêu thích
  Future<void> addFavorite(int movieId) async {
    try {
      emit(FavoriteActionLoading());

      final response = await _repository.addFavorite(movieId);

      if (response['success'] == true) {
        emit(FavoriteActionSuccess(
          message: response['message'] ?? 'Added to favorites',
          isFavorited: true,
        ));

        // Refresh danh sách favorites
        fetchFavorites();
      } else {
        emit(FavoriteActionError(
            response['message'] ?? 'Failed to add favorite'));
      }
    } catch (e) {
      emit(FavoriteActionError(e.toString()));
    }
  }

  /// Xóa phim khỏi yêu thích
  Future<void> removeFavorite(int movieId) async {
    try {
      emit(FavoriteActionLoading());

      final response = await _repository.removeFavorite(movieId);

      if (response['success'] == true) {
        emit(FavoriteActionSuccess(
          message: response['message'] ?? 'Removed from favorites',
          isFavorited: false,
        ));

        // Refresh danh sách favorites
        fetchFavorites();
      } else {
        emit(FavoriteActionError(
            response['message'] ?? 'Failed to remove favorite'));
      }
    } catch (e) {
      emit(FavoriteActionError(e.toString()));
    }
  }

  /// Toggle favorite status
  Future<void> toggleFavorite(int movieId, bool currentStatus) async {
    if (currentStatus) {
      await removeFavorite(movieId);
    } else {
      await addFavorite(movieId);
    }
  }

  /// Reset state
  void resetState() {
    emit(FavoriteInitial());
  }
}
