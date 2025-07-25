import 'package:dio/dio.dart';
import 'package:yelpax_pro/features/authentication/presentation/service/auth_service.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

class TokenInterceptor extends Interceptor {
  final AuthService _authService;
  final ApiService _apiService;

  TokenInterceptor(this._authService, this._apiService);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _authService.getValidAccessToken();
    options.headers['Authorization'] = 'Bearer $token';
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final newToken = await _authService.refreshToken();
        final retry = err.requestOptions
          ..headers['Authorization'] = 'Bearer $newToken';
        return handler.resolve(await _apiService.dio.fetch(retry));
      } catch (e) {
        await _authService.logout();
        return handler.reject(err);
      }
    }
    return handler.next(err);
  }
}