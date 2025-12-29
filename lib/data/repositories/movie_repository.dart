import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/movie_detail_model.dart';
import 'package:Celes/utils/api.dart';

class MovieRepository {
  Future<ApiResponse<MovieDetail>> getMovieDetail(int movieId) async {
    Map<String, dynamic> response = await Api.get(
      url: Api.movieDetail(movieId),
    );

    return ApiResponse.fromJson(
      response,
      (data) => MovieDetail.fromJson(data as Map<String, dynamic>),
    );
  }
}
