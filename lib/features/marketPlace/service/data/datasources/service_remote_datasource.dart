import 'package:yelpax_pro/features/marketPlace/service/domain/entities/answer_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/professional_services_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';

import '../../domain/entities/question_entity.dart';
import '../../domain/entities/service_entity.dart';

import '../../domain/entities/subcategory_entity.dart';

abstract class ServiceRemoteDataSource {
  Future<List<SubCategoryEntity>> getAllSubCategories();
  Future<List<ServiceEntity>> getAllServices();
  Future<List<ServiceEntity>> getServicesBySubCategory(String subCategoryId);
  Future<List<QuestionEntity>> getQuestionsForService(String serviceId);

  Future<String> addLocationData(LocationDataEntity locationDataEntity);

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

  Future<Map<String, dynamic>> sendAnswers(List<AnswerEntity> answerEntities);
  Future<List<ProfessionalServicesEntity>>
  fetchAllServicesRelatedToProfessional(String professionalId);
}
