import 'package:Celes/data/models/movie_model.dart';
import 'package:Celes/utils/api.dart';

class FavoriteRepository {
  /// Thêm phim vào danh sách yêu thích
  /// POST /api/favorites/{movieId}
  Future<Map<String, dynamic>> addFavorite(int movieId) async {
    try {
      final response = await Api.post(
        url: Api.favoriteAdd(movieId),
        parameter: <String, dynamic>{},
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Xóa phim khỏi danh sách yêu thích
  /// DELETE /api/favorites/{movieId}
  Future<Map<String, dynamic>> removeFavorite(int movieId) async {
    try {
      final response = await Api.delete(
        url: Api.favoriteRemove(movieId),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Lấy danh sách phim yêu thích
  /// GET /api/favorites
  Future<Map<String, dynamic>> getFavorites({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final response = await Api.get(
        url: Api.favoritesList,
        queryParameters: {
          'page': page,
          'per_page': perPage,
        },
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Parse danh sách phim yêu thích từ response
  List<Movie> parseFavoriteMovies(Map<String, dynamic> response) {
    try {
      if (response['data'] != null && response['data']['data'] != null) {
        List<dynamic> moviesData = response['data']['data'];
        return moviesData.map((json) => Movie.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  /// Get pagination meta từ response
  Map<String, dynamic>? getPaginationMeta(Map<String, dynamic> response) {
    try {
      if (response['data'] != null && response['data']['meta'] != null) {
        return response['data']['meta'];
      }
      return null;
    } catch (e) { 
      return null;
    }
  }
}
