import 'package:Celes/data/models/api_response.dart';
import 'package:Celes/data/models/home_model.dart';
import 'package:Celes/utils/api.dart';

class HomeRepository {
  Future<ApiResponse<HomeData>> getHomeData() async {
    Map<String, dynamic> response = await Api.get(
      url: Api.home,
    );

    return ApiResponse.fromJson(
      response,
      (data) => HomeData.fromJson(data as Map<String, dynamic>),
    );
  }
}
