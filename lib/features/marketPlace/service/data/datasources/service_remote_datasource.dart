import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';

import '../../domain/entities/question_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/service_registration_entity.dart';
import '../../domain/entities/subcategory_entity.dart';

abstract class ServiceRemoteDataSource {
  Future<List<SubCategoryEntity>> getAllSubCategories();
  Future<List<ServiceEntity>> getAllServices();
  Future<List<ServiceEntity>> getServicesBySubCategory(String subCategoryId);
  Future<List<QuestionEntity>> getQuestionsForService(String serviceId);
  Future<bool> submitServiceRegistration(
    ServiceRegistrationEntity registration,
  );

  Future<String> addLocationData(LocationDataEntity locationDataEntity);

  Future<List<LocationDataEntity>> getServiceLocationsOfAuthenticatedUser(
    String professionalId,
    String serviceId,
  );

  Future<String> updateLocation(LocationDataEntity locationDataEntity);

  Future<List<MileEntity>> getAllMiles();

  Future<void> deleteServiceLocation(String? id);
}
