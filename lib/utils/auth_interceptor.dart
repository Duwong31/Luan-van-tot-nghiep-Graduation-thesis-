import 'package:Celes/data/repositories/auth_repository.dart';
import 'package:Celes/utils/constant.dart';
import 'package:Celes/utils/helper_utils.dart';
import 'package:Celes/utils/hive_utils.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;
  final List<_RetryRequest> _requestQueue = [];

  AuthInterceptor(this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (HiveUtils.isUserAuthenticated()) {
      final token = HiveUtils.getJWT();
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      print('401 Error detected - Attempting to refresh token...');

      if (_isRefreshing) {
        print('Token refresh in progress, queueing request...');
        _queueRequest(err, handler);
        return;
      }

      _isRefreshing = true;

      try {
        final refreshToken = HiveUtils.getRefreshToken();

        if (refreshToken == null) {
          print('No refresh token available - Logging out user');
          _logoutUser();
          handler.next(err);
          return;
        }

        print('Refreshing token...');
        final authRepo = AuthRepository();
        final response = await authRepo.refreshToken(
          refreshToken: refreshToken,
        );

        if (response.success && response.data != null) {
          final newAccessToken = response.data!['access_token'] as String?;

          if (newAccessToken != null) {
            print('Token refreshed successfully!');

            // Retry original request với token mới
            final retryResponse = await _retry(err.requestOptions);
            handler.resolve(retryResponse);

            // Process queued requests
            _processQueue(newAccessToken);
            return;
          }
        }

        print('Token refresh failed - Logging out user');
        _logoutUser();
        handler.next(err);
      } catch (e) {
        print('Error during token refresh: $e');
        _logoutUser();
        handler.next(err);
      } finally {
        _isRefreshing = false;
        _clearQueue();
      }
    } else {
      handler.next(err);
    }
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    // Get new token from Hive
    final newToken = HiveUtils.getJWT();

    // Update authorization header
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newToken',
      },
    );

    print('🔁 Retrying original request: ${requestOptions.path}');

    return _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  void _queueRequest(DioException err, ErrorInterceptorHandler handler) {
    _requestQueue.add(_RetryRequest(
      requestOptions: err.requestOptions,
      handler: handler,
    ));
  }

  void _processQueue(String newToken) async {
    print('📋 Processing ${_requestQueue.length} queued requests...');

    for (var request in List.from(_requestQueue)) {
      try {
        final response = await _retry(request.requestOptions);
        request.handler.resolve(response);
      } catch (e) {
        request.handler.reject(
          DioException(
            requestOptions: request.requestOptions,
            error: e,
          ),
        );
      }
    }
  }

  void _clearQueue() {
    _requestQueue.clear();
  }

  void _logoutUser() {
    HelperUtils.showSnackBarMessage(
      Constant.navigatorKey.currentContext!,
      'Session expired. Please login again.',
      messageDuration: 3,
    );

    Future.delayed(const Duration(seconds: 2), () {
      HiveUtils.clear();
      HiveUtils.logoutUser(
        Constant.navigatorKey.currentContext!,
        onLogout: () {},
      );
    });
  }
}

class _RetryRequest {
  final RequestOptions requestOptions;
  final ErrorInterceptorHandler handler;

  _RetryRequest({
    required this.requestOptions,
    required this.handler,
  });
}
