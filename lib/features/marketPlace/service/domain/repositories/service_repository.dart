import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';

import '../entities/question_entity.dart';
import '../entities/service_entity.dart';
import '../entities/service_registration_entity.dart';
import '../entities/subcategory_entity.dart';

abstract class ServiceRepository {
  // Subcategories
  Future<List<SubCategoryEntity>> getAllSubCategories();

  // Services
  Future<List<ServiceEntity>> getAllServices();
  Future<List<ServiceEntity>> getServicesBySubCategory(String subCategoryId);

  // Questions
  Future<List<QuestionEntity>> getQuestionsForService(String serviceId);

  // Service Registration

  Future<String> addLocation(LocationDataEntity locationDataEntity);

  Future<List<LocationDataEntity>> getServiceLocationsOfAuthenticatedUser(
    String professionalId,
    String serviceId,
  );

  Future<String> updateLocation(LocationDataEntity locationDataEntity);

  Future<List<MileEntity>> getAllMiles();

  Future<void> deleteServiceLocation(String? id);

  Future<List<MinuteEntity>> getAllMinutes();

  Future<List<VehicleTypeEntity>> getAllVehicleTypes();

  Future<Map<String, dynamic>> addService(
    String serviceId,
    String professionalId,
  );
}
