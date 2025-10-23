import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:logger/logger.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/datasources/service_remote_datasource.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/mile_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/minute_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/professional_services_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/question_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/subcategory_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/vehicle_type_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/answer_entity.dart';

import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/professional_services_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';

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

  @override
  Future<Map<String, dynamic>> sendAnswers(
    List<AnswerEntity> answerEntities,
  ) async {
    try {
      final answersData = answerEntities.map((a) => a.toJson()).toList();

      final response = await apiService.post(
        '/answers/answers',
        data: {'answers': answersData},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Logger().d('-=-===-==-=-=-=$response');
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('Failed to send answers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to send answers: $e');
    }
  }

  @override
  Future<List<ProfessionalServicesEntity>>
  fetchAllServicesRelatedToProfessional(String professionalId) async {
    try {
      final response = await apiService.get('/services/pro/$professionalId');
      Logger().d('Response status: ${response.statusCode}');
      Logger().d('Response data: ${response.data}');

      if (response.statusCode == 400) {
        throw Exception('Bad request from frontend');
      } else if (response.statusCode == 200 || response.statusCode == 201) {
        Logger().i("Fetched services: ${response.data}");

        // Extract the data array from the response
        final responseData = response.data as Map<String, dynamic>;

        if (responseData['success'] == true) {
          final dataList = responseData['data'] as List<dynamic>;

          // Convert each item in the list to ProfessionalServicesModel
          final services = dataList.map((item) {
            return ProfessionalServicesModel.fromJson(
              item as Map<String, dynamic>,
            );
          }).toList();

          Logger().i("Converted ${services.length} services");
          return services;
        } else {
          throw Exception(
            'API returned unsuccessful response: ${responseData['message']}',
          );
        }
      } else {
        throw Exception('Unexpected response status: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      Logger().e('Error fetching services: $e\n$stackTrace');
      throw Exception('Failed to load services of professional.');
    }
  }

  @override
  Future<Map<String, dynamic>> updateService(
    String serviceId,
    String proServiceId,
  ) async {
    try {
      Logger().d(
        'Updating service: serviceId=$serviceId, proServiceId=$proServiceId',
      );

      final response = await apiService.put(
        '/services/professional-service/update',
        data: {"_id": proServiceId, "serviceId": serviceId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        // Return error response in map format
        return {
          "success": false,
          "statusCode": response.statusCode,
          "data": response.data,
        };
      }
    } catch (e) {
      Logger().e('Failed to update service: $e');
      throw Exception('Failed to update service: $e');
    }
  }

  @override
  Future<bool> deleteProService(String proServiceId) async {
    try {
      final response = await apiService.delete(
        '/services/pro-service/delete/$proServiceId',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchAllServicesRelatedToProfessional(proServiceId);
        Logger().d('Service deleted successfully: $response');
        return response.data;
      } else {
        Logger().e(
          'Failed to delete service. Status: ${response.statusCode}, Response: $response',
        );
        return false;
      }
    } catch (e) {
      Logger().e('Error deleting service: $e');
      return false;
    }
  }

  @override
  Future<void> addServicePricing({
    required String professionalId,
    required String serviceId,
    required double maxPrice,
    required double minPrice,
    required String description,
    required String pricingType,
    required int completedTasks,
  }) async {
    try {
      final response = await apiService.post(
        '/services/pricing',
        data: {
          'professional_id': professionalId,
          'service_id': serviceId,
          'maximum_price': maxPrice,
          'minimum_price': minPrice,
          'description': description,
          'pricing_type': pricingType,
          'completed_tasks': completedTasks,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Logger().d('Service pricing added successfully: $response');
      } else {
        throw Exception(
          'Failed to add service pricing. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      Logger().e('Error adding service pricing: $e');
      throw Exception('Failed to add service pricing: $e');
    }
  }

  @override
  Future<void> updatePricing({
    required String professionalId,
    required String serviceId,
    required double maxPrice,
    required double minPrice,
    required String description,
    required String pricingType,
    required int completedTasks,
  }) {
    try {
      return apiService.put(
        '/services/pricing/update',
        data: {
          'professional_id': professionalId,
          'service_id': serviceId,
          'maximum_price': maxPrice,
          'minimum_price': minPrice,
          'description': description,
          'pricing_type': pricingType,
          'completed_tasks': completedTasks,
        },
      );
    } catch (e) {
      Logger().e('Error updating service pricing: $e');
      throw Exception('Failed to update service pricing: $e');
    }
  } 
}
