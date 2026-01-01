import 'dart:io';

import 'package:Celes/settings.dart';
import 'package:Celes/utils/constant.dart';
import 'package:Celes/utils/helper_utils.dart';
import 'package:Celes/utils/hive_utils.dart';
import 'package:Celes/utils/network_request.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ApiException implements Exception {
  ApiException(this.errorMessage);

  dynamic errorMessage;

  @override
  String toString() {
    return errorMessage.toString();
  }
}

class Api {
  /// API Key - Import từ AppSettings
  static String get apiKey => AppSettings.apiKey;

  static Map<String, dynamic> headers() {
    // Base headers - luôn có X-Api-Key và Accept
    Map<String, dynamic> baseHeaders = {
      "X-Api-Key": apiKey,
      "Accept": "application/json",
    };

    if (HiveUtils.isUserAuthenticated()) {
      String? jwtToken = HiveUtils.getJWT();
      debugPrint('Bearer token: $jwtToken');
      baseHeaders["Authorization"] = "Bearer $jwtToken";
    }

    final language = HiveUtils.getLanguage();
    if (language != null && language['code'] != null) {
      baseHeaders["Language"] = language['code'];
    }

    return baseHeaders;
  }

  // ==================== API ENDPOINTS ====================

  // Authentication APIs
  static const String authRegister = 'auth/register';
  static const String authLogin = 'auth/login';
  static const String authVerifyOtp = 'auth/verify-otp';
  static const String authResendOtp = 'auth/resend-otp';
  static const String authForgotPassword = 'auth/forgot-password';
  static const String authResetPassword = 'auth/reset-password';
  static const String authChangePassword = 'auth/change-password';
  static const String authRefreshToken = 'auth/refresh';
  static const String authLogout = 'auth/logout';
  static const String authGetProfile = 'auth/me';
  static const String authUpdateProfile = 'auth/me';
  static const String authFcmToken = 'auth/fcm-token';

  // Media APIs
  static const String mediaUploadImage = 'media/upload-image';

  // Home APIs
  static const String home = 'home';
  static const String movieSearch = 'movies/search';

  // Movie APIs
  static String movieDetail(int movieId) => 'movies/$movieId';
  static String movieShowtimes(int movieId) => 'movies/$movieId/showtimes';

  // Showtime APIs
  static String showtimeSeats(int showtimeId) => 'showtimes/$showtimeId/seats';

  // Booking APIs
  static const String bookingCalculatePrice = 'bookings/calculate-price';
  static const String bookingCreate = 'bookings';
  static String bookingDetail(int bookingId) => 'bookings/$bookingId';

  // Favorite APIs
  static String favoriteAdd(int movieId) => 'favorites/$movieId';
  static String favoriteRemove(int movieId) => 'favorites/$movieId';
  static const String favoritesList = 'favorites';

  static Future<Map<String, dynamic>> post({
    required String url,
    dynamic parameter,
    Options? options,
    bool? useBaseUrl,
  }) async {
    try {
      final Dio dio = Dio();
      dio.interceptors.add(NetworkRequestInterceptor());

      Map<String, dynamic> formMap = {};

      if (parameter is Map) {
        parameter.forEach((key, value) {
          if (value is File) {
            formMap[key.toString()] = MultipartFile.fromFileSync(value.path,
                filename: value.path.split('/').last);
          } else if (value is List<File>) {
            formMap[key.toString()] = value
                .map((file) => MultipartFile.fromFileSync(file.path,
                    filename: file.path.split('/').last))
                .toList();
          } else {
            formMap[key.toString()] = value;
          }
        });
      }

      final formData = FormData.fromMap(
        formMap,
        ListFormat.multiCompatible,
      );

      final response = await dio.post(
        ((useBaseUrl ?? true) ? Constant.baseUrl : "") + url,
        data: formData,
        options: Options(
          contentType: "multipart/form-data",
          headers: headers(),
        ),
      );

      var resp = response.data;

      if (resp['error'] ?? false) {
        throw ApiException(resp['message'].toString());
      }

      return Map.from(resp);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        userExpired();
      }

      if (e.response?.statusCode == 503) {
        throw "server-not-available";
      }

      throw ApiException(
        e.error is SocketException
            ? "no-internet"
            : "Something went wrong with error ${e.response?.statusCode}",
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  static void userExpired() {
    HelperUtils.showSnackBarMessage(
        Constant.navigatorKey.currentContext!, "User is deactivated",
        messageDuration: 3);
    Future.delayed(Duration(seconds: 2), () {
      HiveUtils.clear();
      // Constant.favoriteItemList.clear();
      // Constant.navigatorKey.currentContext!.read<UserDetailsCubit>().clear();
      // Constant.navigatorKey.currentContext!.read<FavoriteCubit>().resetState();
      HiveUtils.logoutUser(
        Constant.navigatorKey.currentContext!,
        onLogout: () {},
      );
    });
  }

  static Future<Map<String, dynamic>> put({
    required String url,
    dynamic parameter,
    Options? options,
    bool? useBaseUrl,
  }) async {
    try {
      final Dio dio = Dio();
      dio.interceptors.add(NetworkRequestInterceptor());

      // late FormData formData;

      // if (parameter is Map<String, dynamic>) {
      //   Map<String, dynamic> formMap = {};

      //   parameter.forEach((key, value) {
      //     if (value is File) {
      //       formMap[key] = MultipartFile.fromFileSync(value.path,
      //           filename: value.path.split('/').last);
      //     } else if (value is List<File>) {
      //       formMap[key] = value
      //           .map((file) => MultipartFile.fromFileSync(file.path,
      //               filename: file.path.split('/').last))
      //           .toList();
      //     } else {
      //       formMap[key] = value;
      //     }
      //   });

      //   formData = FormData.fromMap(
      //     formMap,
      //     ListFormat.multiCompatible,
      //   );
      // } else {
      //   throw ArgumentError(
      //       'Invalid parameter type. Expected Map<String, dynamic>.');
      // }

      // final response = await dio.put(
      //   ((useBaseUrl ?? true) ? Constant.baseUrl : "") + url,
      //   data: formData,
      //   options: Options(
      //     contentType: "multipart/form-data",
      //     headers: headers(),
      //   ),
      // );

      final response = await dio.put(
        ((useBaseUrl ?? true) ? Constant.baseUrl : "") + url,
        data: parameter,
        options: Options(
          contentType: "application/json",
          headers: headers(),
        ),
      );

      var resp = response.data;

      if (resp['error'] ?? false) {
        throw ApiException(resp['message'].toString());
      }

      return Map.from(resp);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        userExpired();
      }

      if (e.response?.statusCode == 503) {
        throw "server-not-available";
      }

      throw ApiException(
        e.error is SocketException
            ? "no-internet"
            : "Something went wrong with error ${e.response?.statusCode}",
      );
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  static Future<Map<String, dynamic>> delete(
      {required String url,
      Map<String, dynamic>? queryParameters,
      bool? useBaseUrl}) async {
    try {
      final Dio dio = Dio();
      dio.interceptors.add(NetworkRequestInterceptor());

      final response = await dio.delete(
          ((useBaseUrl ?? true) ? Constant.baseUrl : "") + url,
          queryParameters: queryParameters,
          options: Options(headers: headers()));

      if (response.data['error'] == true) {
        throw ApiException(response.data['message'].toString());
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        userExpired();
      }
      if (e.response?.statusCode == 503) {
        throw "server-not-available";
      }

      throw ApiException(e.error is SocketException
          ? "no-internet"
          : "Something went wrong with error ${e.response?.statusCode}");
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e, st) {
      throw ApiException(st.toString());
    }
  }

  static Future<Map<String, dynamic>> get(
      {required String url,
      Map<String, dynamic>? queryParameters,
      bool? useBaseUrl}) async {
    try {
      final Dio dio = Dio();
      dio.interceptors.add(NetworkRequestInterceptor());
      String mainurl = ((useBaseUrl ?? true) ? Constant.baseUrl : "") + url;
      final response = await dio.get(mainurl,
          queryParameters: queryParameters,
          options: Options(headers: headers()));

      if (response.data['error'] == true) {
        throw ApiException(response.data['message'].toString());
      }
      return Map.from(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        userExpired();
      }
      if (e.response?.statusCode == 503) {
        throw "server-not-available";
      }

      throw ApiException(e.error is SocketException
          ? "no-internet"
          : "Something went wrong with error ${e.response?.statusCode}");
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e, st) {
      throw ApiException(st.toString());
    }
  }
}
