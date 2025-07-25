import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:yelpax_pro/core/error/exceptions/exceptions.dart';
import 'package:yelpax_pro/features/authentication/data/model/refresh_token_response.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio dio;
  String? _authToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  bool _isRefreshing = false;
  final List<({RequestOptions options, Completer<Response> completer})> _requestQueue = [];

  void setTokens({String? accessToken, String? refreshToken, int? expiresIn}) {
    _authToken = accessToken;
    _refreshToken = refreshToken;
    if (expiresIn != null) {
      _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));
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
      item.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $_authToken';
      dio.fetch(item.options).then(item.completer.complete).catchError(item.completer.completeError);
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
      baseUrl: "http://192.168.0.178:8000/api/v1/",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      contentType: "application/json",
      validateStatus: (status) => status! < 500,
    );

    dio = Dio(options);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Skip for refresh token request
        if (options.path == 'auth/refresh') {
          return handler.next(options);
        }

        // Check if token is expired or about to expire (within 30 seconds)
        if (_tokenExpiry != null && 
            _tokenExpiry!.isBefore(DateTime.now().add(Duration(seconds: 30)))) {
          
          if (!_isRefreshing) {
            _isRefreshing = true;
            try {
              await refreshToken();
            } catch (e) {
              handler.reject(DioException(
                requestOptions: options,
                error: 'Token refresh failed',
              ));
              return;
            } finally {
              _isRefreshing = false;
            }
          } else {
            // Queue the request while refreshing
            final completer = Completer<Response>();
            _requestQueue.add((options: options, completer: completer));
            return completer.future.then(handler.resolve).catchError(handler.reject);
          }
        }

        if (_authToken != null) {
          options.headers[HttpHeaders.authorizationHeader] = "Bearer $_authToken";
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401 && 
            error.requestOptions.path != 'auth/refresh' &&
            _refreshToken != null) {
          
          try {
            await refreshToken();
            
            // Retry the original request
            final retryOptions = error.requestOptions
              ..headers[HttpHeaders.authorizationHeader] = 'Bearer $_authToken';
            
            return handler.resolve(await dio.fetch(retryOptions));
          } catch (e) {
            return handler.next(error);
          }
        }
        return handler.next(error);
      },
    ));

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  void setToken(String token) {
    _authToken = token;
  }

  void clearTokens() {
    _authToken = null;
    _refreshToken = null;
    _tokenExpiry = null;
  }

  Future<Response> get(String endpoint, {Map<String, dynamic>? queryParams}) async {
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
        throw ValidationException(e.response?.data['message'] ?? 'Invalid request');
      }
      rethrow;
    } catch (e) {
      throw ServerException('Unexpected server error');
    }
  }

  Future<Response> put(String endpoint, {dynamic data, Map<String, dynamic>? queryParams}) async {
    try {
      return await dio.put(endpoint, data: data, queryParameters: queryParams);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> delete(String endpoint, {dynamic data, Map<String, dynamic>? queryParams}) async {
    try {
      return await dio.delete(endpoint, data: data, queryParameters: queryParams);
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
      List<MultipartFile> multipartFiles = await Future.wait(files.map(
        (file) async {
          String fileName = file.path.split('/').last;
          return await MultipartFile.fromFile(file.path, filename: fileName);
        },
      ));

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
      data: {
        "error": true,
        "message": "Unexpected error: $error",
      },
    );
  }
}