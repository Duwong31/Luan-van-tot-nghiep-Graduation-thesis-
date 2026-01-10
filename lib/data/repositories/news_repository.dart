import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/news_detail_model.dart';
import 'package:Celes/utils/api.dart';
import 'package:Celes/utils/api_exception.dart' as api_ex;

class NewsRepository {
  /// Get news detail by ID
  Future<ApiResponse<NewsDetail>> getNewsDetail(int newsId) async {
    try {
      final response = await Api.get(
        url: Api.newsDetail(newsId),
      );

      if (response['success'] == true && response['data'] != null) {
        final newsDetail = NewsDetail.fromJson(response['data']);
        return ApiResponse<NewsDetail>(
          success: true,
          message: response['message'] ?? 'News fetched successfully',
          code: response['code'] ?? 'NEWS_FETCHED_SUCCESS',
          data: newsDetail,
        );
      } else {
        return ApiResponse<NewsDetail>(
          success: false,
          message: response['message'] ?? 'Failed to fetch news',
          code: response['code'] ?? 'NEWS_FETCH_FAILED',
        );
      }
    } on api_ex.ApiException catch (e) {
      return ApiResponse<NewsDetail>(
        success: false,
        message: e.message,
        code: e.code,
      );
    } catch (e) {
      return ApiResponse<NewsDetail>(
        success: false,
        message: e.toString(),
        code: 'UNKNOWN_ERROR',
      );
    }
  }
}
