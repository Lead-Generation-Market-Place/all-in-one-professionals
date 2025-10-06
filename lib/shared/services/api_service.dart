import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/web.dart';
import 'package:yelpax_pro/core/error/exceptions/exceptions.dart';
import 'package:yelpax_pro/features/authentication/models/token_response.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio dio;
  String? _authToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  bool _isRefreshing = false;
  final List<({RequestOptions options, Completer<Response> completer})>
  _requestQueue = [];

  void setTokens({String? accessToken, String? refreshToken, int? expiresIn}) {
    _authToken = accessToken;
    _refreshToken = refreshToken;
    if (expiresIn != null) {
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
    }

    // Update Dio instance with new token
    if (accessToken != null) {
      dio.options.headers[HttpHeaders.authorizationHeader] =
          "Bearer $accessToken";
    }
  }

  Future<TokenResponse> refreshToken() async {
    if (_refreshToken == null) {
      throw ValidationException('No refresh token available');
    }

    try {
      _isRefreshing = true;

      final response = await dio.post(
        'auth/refresh',
        data: {'refresh_token': _refreshToken},
        options: Options(
          headers: {HttpHeaders.authorizationHeader: 'Bearer $_refreshToken'},
        ),
      );

      final newAccessToken = response.data['access_token'];
      final newRefreshToken = response.data['refresh_token'];
      final expiresIn = response.data['expires_in'];

      // Update internal tokens
      setTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        expiresIn: expiresIn,
      );

      // Retry queued requests
      for (var item in _requestQueue) {
        item.options.headers[HttpHeaders.authorizationHeader] =
            'Bearer $_authToken';
        dio
            .fetch(item.options)
            .then(item.completer.complete)
            .catchError(item.completer.completeError);
      }

      return TokenResponse(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
        expiresIn: expiresIn,
      );
    } finally {
      _isRefreshing = false;
      _requestQueue.clear();
    }
  }

  ApiService._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: "https://servicyee-backend.onrender.com/api/v1/",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: "application/json",
      validateStatus: (status) => status! < 500,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(options);

    // Add interceptors
    _addInterceptors();
  }

  void _addInterceptors() {
    // Request interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Always try to add the token if available
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers[HttpHeaders.authorizationHeader] =
                "Bearer $_authToken";
          }

          Logger().d('''
🌐 API Request:
- URL: ${options.method} ${options.baseUrl}${options.path}
- Headers: ${options.headers}
- Data: ${options.data}
''');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          Logger().d('''
✅ API Response:
- URL: ${response.requestOptions.method} ${response.requestOptions.baseUrl}${response.requestOptions.path}
- Status: ${response.statusCode}
- Data: ${response.data}
''');
          return handler.next(response);
        },
        onError: (error, handler) async {
          Logger().e('''
❌ API Error:
- URL: ${error.requestOptions.method} ${error.requestOptions.baseUrl}${error.requestOptions.path}
- Status: ${error.response?.statusCode}
- Error: ${error.message}
- Response: ${error.response?.data}
''');

          // Handle token refresh for 401 errors
          if (error.response?.statusCode == 401) {
            if (!_isRefreshing && _refreshToken != null) {
              try {
                _isRefreshing = true;
                await refreshToken();

                // Retry the original request with new token
                error.requestOptions.headers[HttpHeaders.authorizationHeader] =
                    'Bearer $_authToken';
                final response = await dio.fetch(error.requestOptions);
                return handler.resolve(response);
              } catch (refreshError) {
                // If refresh fails, clear tokens and throw error
                clearTokens();
                return handler.reject(error);
              } finally {
                _isRefreshing = false;
              }
            }
          }

          return handler.next(error);
        },
      ),
    );

    // Add debug logging in development
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }


  void setToken(String token) {
    _authToken = token;
  }

  void clearTokens() {
    _authToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
    dio.options.headers.remove(HttpHeaders.authorizationHeader);
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return await dio.get(endpoint, queryParameters: queryParams);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      final response = await dio.post(endpoint, data: data);
      return response;
    } on SocketException catch (e) {
      throw NetworkException('No internet connection: ${e.message}');
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw ValidationException(
          e.response?.data['message'] ?? 'Invalid request',
        );
      }
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected server error');
    }
  }

  Future<Response> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return await dio.put(endpoint, data: data, queryParameters: queryParams);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      return await dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParams,
      );
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> uploadFile(
    String endpoint, {
    required File file,
    String fieldName = 'file',
    Map<String, dynamic>? fields,
  }) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        fieldName: await MultipartFile.fromFile(file.path, filename: fileName),
        ...?fields,
      });
      return await dio.post(endpoint, data: formData);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> uploadFiles(
    String endpoint, {
    required List<File> files,
    String fieldName = 'files',
    Map<String, dynamic>? fields,
  }) async {
    try {
      List<MultipartFile> multipartFiles = await Future.wait(
        files.map((file) async {
          String fileName = file.path.split('/').last;
          return await MultipartFile.fromFile(file.path, filename: fileName);
        }),
      );

      FormData formData = FormData.fromMap({
        fieldName: multipartFiles,
        ...?fields,
      });

      return await dio.post(endpoint, data: formData);
    } catch (e) {
      return _handleError(e);
    }
  }

  Response _handleError(dynamic error) {
    if (error is DioException) {
      return Response(
        requestOptions: error.requestOptions,
        statusCode: error.response?.statusCode ?? 500,
        data: {
          "error": true,
          "message": error.message,
          "details": error.response?.data,
        },
      );
    }
    return Response(
      requestOptions: RequestOptions(path: ''),
      statusCode: 500,
      data: {"error": true, "message": "Unexpected error: $error"},
    );
  }
}
