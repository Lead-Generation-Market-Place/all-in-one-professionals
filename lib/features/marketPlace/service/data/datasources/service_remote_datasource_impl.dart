import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/datasources/service_remote_datasource.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/mile_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/minute_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/question_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/subcategory_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/vehicle_type_model.dart';

import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_registration_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/subcategory_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';
import 'package:yelpax_pro/shared/widgets/custom_flutter_toast.dart';

class ServiceRemoteDataSourceImpl implements ServiceRemoteDataSource {
  final ApiService apiService;

  ServiceRemoteDataSourceImpl({required this.apiService});

  @override
  Future<List<SubCategoryEntity>> getAllSubCategories() async {
    try {
      final response = await apiService.get('/subcategories');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        Logger().d("--asdfasdf -----------$response");
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
        return data
            .map<QuestionEntity>(
              (json) => QuestionModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
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
      Logger().i('-------------$locationDataEntity');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
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

  Future<List<LocationDataEntity>> getServiceLocationsOfAuthenticatedUser(
    String professionalId,
    String serviceId,
  ) async {
    try {
      final response = await apiService.get(
        '/location/pro/$professionalId/${serviceId}',
      );

      Logger().d('getServiceLocationsOfAuthenticatedUser----------$response');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> data = response.data;
        return data.map((item) => LocationDataEntity.fromJson(item)).toList();
      } else {
        throw Exception(
          'Failed to fetch service locations by professional id. Status: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      CustomFlutterToast.showErrorToast("Error getting location.");
      // Optional: log error or rethrow for debugging
      print('Error: $e\n$stackTrace');
      return []; // Return an empty list to satisfy return type
    }
  }

  @override
  Future<String> updateLocation(LocationDataEntity locationDataEntity) async {
    try {
      final payload = locationDataEntity.toJson();
      Logger().d('-------------$payload');
      final response = await apiService.put(
        '/location/${locationDataEntity.id}/update',
        data: payload,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        final locationId =
            data['locationId']?.toString() ?? 'Location updated successfully';
        print('--------------------------$locationId');
        return locationId;
      } else {
        throw Exception(
          'Failed to update location. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFlutterToast.showErrorToast('Error updating location.');
      print('Error updating location: $e');
      return 'Error updating location'; // ✅ Add a fallback return
    }
  }

  @override
  Future<List<MileEntity>> getAllMiles() async {
    try {
      final response = await apiService.get('/location/miles');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final mileList = (response.data as List)
            .map((json) => MileModel.fromJson(json))
            .toList();
        Logger().d('---=-=-=-=-=-=-=-=$mileList');
        return mileList;
      } else {
        throw Exception(
          'Failed to update location. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFlutterToast.showErrorToast('Error fetching miles.');

      return [];
    }
  }

  @override
  Future<void> deleteServiceLocation(String? id) async {
    try {
      final response = await apiService.delete('/location/delete/$id');
      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomFlutterToast.showSuccessToast(
          'Service location deleted successfully.',
        );
      }
    } catch (e) {
      CustomFlutterToast.showErrorToast('Error deleting service location.');
    }
  }

  @override
  Future<List<MinuteEntity>> getAllMinutes() async {
    try {
      final response = await apiService.get('/location/minute');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final miuteList = (response.data as List)
            .map((json) => MinuteModel.fromJson(json))
            .toList();
        Logger().d('---=-=-=-=-=-=-=-=$miuteList');
        return miuteList;
      } else {
        throw Exception(
          'Failed to update location. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFlutterToast.showErrorToast('Error getting minute data.');
      return [];
    }
  }

  @override
  Future<List<VehicleTypeEntity>> getAllVehicleTypes() async {
    try {
      final response = await apiService.get('/location/vehicle_type');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final vehicleTypeList = (response.data as List)
            .map((json) => VehicleTypeModel.fromJson(json))
            .toList();
        Logger().d('---=-=-=-=-=-=-=-=$vehicleTypeList');
        return vehicleTypeList;
      } else {
        throw Exception(
          'Failed to update location. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      CustomFlutterToast.showErrorToast('Error getting vehicle type data.');
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> addService(
    String serviceId,
    String professionalId,
  ) async {
    try {
      final response = await apiService.post(
        '/services/asp',
        data: {'service_id': serviceId, 'professional_id': professionalId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        // Return error response in map format
        return response.data;
      }
    } catch (e) {
      throw Exception('Failed to add service: $e');
    }
  }
}
