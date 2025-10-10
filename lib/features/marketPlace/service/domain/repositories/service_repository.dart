import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';

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
  Future<bool> submitServiceRegistration(
    ServiceRegistrationEntity registration,
  );
  Future<String> addLocation(LocationDataEntity locationDataEntity);
}
