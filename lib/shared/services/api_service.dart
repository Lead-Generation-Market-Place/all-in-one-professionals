import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;
  String? _authToken;

  ApiService._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: "https://reqres.in/api/users",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: "application/json",
    );

    _dio = Dio(options);

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers[HttpHeaders.authorizationHeader] = "Bearer $_authToken";
        }
        return handler.next(options);
      },
    ));

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => debugPrint(obj.toString()),
      ));
    }
  }

  void setToken(String token) {
    _authToken = token;
  }

  void clearToken() {
    _authToken = null;
  }

  Future<Response> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(endpoint, queryParameters: queryParams);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> post(String endpoint,
      {dynamic data, Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.post(endpoint, data: data, queryParameters: queryParams);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> put(String endpoint,
      {dynamic data, Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.put(endpoint, data: data, queryParameters: queryParams);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<Response> delete(String endpoint,
      {dynamic data, Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.delete(endpoint, data: data, queryParameters: queryParams);
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

      return await _dio.post(endpoint, data: formData);
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

      return await _dio.post(endpoint, data: formData);
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
