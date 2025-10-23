import 'package:yelpax_pro/features/marketPlace/service/domain/entities/answer_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/professional_services_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/subcategory_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/service_remote_datasource.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;

  ServiceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SubCategoryEntity>> getAllSubCategories() async {
    return await remoteDataSource.getAllSubCategories();
  }

  @override
  Future<List<ServiceEntity>> getAllServices() async {
    return await remoteDataSource.getAllServices();
  }

  @override
  Future<List<ServiceEntity>> getServicesBySubCategory(
    String subCategoryId,
  ) async {
    return await remoteDataSource.getServicesBySubCategory(subCategoryId);
  }

  @override
  Future<List<QuestionEntity>> getQuestionsForService(String serviceId) async {
    return await remoteDataSource.getQuestionsForService(serviceId);
  }

  @override
  Future<String> addLocation(LocationDataEntity locationDataEntity) async {
    return await remoteDataSource.addLocationData(locationDataEntity);
  }

  @override
  Future<List<LocationDataEntity>> getServiceLocationsOfAuthenticatedUser(
    String professionalId,
    String serviceId,
  ) async {
    return await remoteDataSource.getServiceLocationsOfAuthenticatedUser(
      professionalId,
      serviceId,
    );
  }

  @override
  Future<String> updateLocation(LocationDataEntity locationDataEntity) async {
    return await remoteDataSource.updateLocation(locationDataEntity);
  }

  @override
  Future<List<MileEntity>> getAllMiles() async {
    return await remoteDataSource.getAllMiles();
  }

  @override
  Future<void> deleteServiceLocation(String? id) async {
    return await remoteDataSource.deleteServiceLocation(id);
  }

  @override
  Future<List<MinuteEntity>> getAllMinutes() async {
    return await remoteDataSource.getAllMinutes();
  }

  @override
  Future<List<VehicleTypeEntity>> getAllVehicleTypes() async {
    return await remoteDataSource.getAllVehicleTypes();
  }

  @override
  Future<Map<String, dynamic>> addService(
    String serviceId,
    String professionalId,
  ) async {
    return await remoteDataSource.addService(serviceId, professionalId);
  }

  @override
  Future<Map<String, dynamic>> sendAnswers(
    List<AnswerEntity> answerEntities,
  ) async {
    return await remoteDataSource.sendAnswers(answerEntities);
  }

  @override
  Future<List<ProfessionalServicesEntity>>
  fetchAllServicesRelatedToProfessional(String professionalId) async {
    return await remoteDataSource.fetchAllServicesRelatedToProfessional(
      professionalId,
    );
  }

  @override
  Future<Map<String, dynamic>> updateService(
    String proServiceId,
    String serviceId,
  ) async {
    return await remoteDataSource.updateService(proServiceId, serviceId);
  }

  @override
  Future<void> deleteProService(String proServiceId) async {
    return await remoteDataSource.deleteProService(proServiceId);
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
    return await remoteDataSource.addServicePricing(
      professionalId: professionalId,
      serviceId: serviceId,
      maxPrice: maxPrice,
      minPrice: minPrice,
      description: description,
      pricingType: pricingType,
      completedTasks: completedTasks,
    );
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
  }) async {
    return await remoteDataSource.updatePricing(
      professionalId: professionalId,
      serviceId: serviceId,
      maxPrice: maxPrice,
      minPrice: minPrice,
      description: description,
      pricingType: pricingType,
      completedTasks: completedTasks,
    );
  }
}
