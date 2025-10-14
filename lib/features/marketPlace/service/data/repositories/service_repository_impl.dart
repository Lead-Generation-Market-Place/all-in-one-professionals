import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';

import '../../domain/entities/question_entity.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/service_registration_entity.dart';
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
  Future<bool> submitServiceRegistration(
    ServiceRegistrationEntity registration,
  ) async {
    return await remoteDataSource.submitServiceRegistration(registration);
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
  Future<void> deleteServiceLocation(String? id) async{
      return await remoteDataSource.deleteServiceLocation(id);
  }
}
