import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/datasources/service_remote_datasource.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/question_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/service_registration_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/subcategory_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_registration_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/subcategory_entity.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final ApiService apiService;

  ServiceRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<SubCategoryEntity>> getAllSubCategories() async {
    try {
      final response = await apiService.get('/subcategories');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];

        return data
            .map((e) => SubCategoryModel.fromJson(e).toEntity())
            .toList();
      } else {
        throw Exception(
          'Failed to fetch subcategories. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<ServiceEntity>> getAllServices() async {
    try {
      final response = await apiService.get('/services');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data
            .map(
              (json) => ServiceModel.fromJson(
                json as Map<String, dynamic>,
              ).toEntity(),
            )
            .toList();
      } else {
        throw Exception(
          'Failed to fetch services. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<ServiceEntity>> getServicesBySubCategory(
    String subCategoryId,
  ) async {
    try {
      final response = await apiService.get(
        '/services/subcategory/$subCategoryId',
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data
            .map(
              (json) => ServiceModel.fromJson(
                json as Map<String, dynamic>,
              ).toEntity(),
            )
            .toList();
      } else {
        throw Exception(
          'Failed to fetch services by subcategory. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<List<QuestionEntity>> getQuestionsForService(String serviceId) async {
    try {
      final response = await apiService.get('/questions/service/$serviceId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        // return data;
        // .map((json) => QuestionModel.fromJson(json).toEntity())
        // .toList();
        return response.data;
      } else {
        throw Exception(
          'Failed to fetch questions. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  @override
  Future<bool> submitServiceRegistration(
    ServiceRegistrationEntity registration,
  ) async {
    try {
      // final registrationModel = ServiceRegistrationModel.fromEntity(
      //   registration,
      // );
      final response = await apiService.post(
        '/services/asp',
        // data: registrationModel.toJson(),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      throw Exception(_handleDioError(e));
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.sendTimeout:
        return 'Send timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Bad response: ${e.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      case DioExceptionType.connectionError:
        return 'Connection error';
      case DioExceptionType.badCertificate:
        return 'Bad certificate';
      case DioExceptionType.unknown:
        return 'Unknown error: ${e.message}';
    }
  }

  @override
  Future<String> addLocationData(LocationDataEntity locationDataEntity) async {
    try {
      final response = await apiService.post(
        '/location/create',
        data: locationDataEntity.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // You might want to return a meaningful ID or message from the response body
        final data = response.data;
        // Assuming the response contains something like: { "locationId": "123" }
        final locationId =
            data['locationId']?.toString() ?? 'Location added successfully';
        return locationId;
      } else {
        throw Exception(
          'Failed to add location. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      Logger().e('Error adding location.');
      return Future.error('Failed to add location: $e');
    }
  }

}
