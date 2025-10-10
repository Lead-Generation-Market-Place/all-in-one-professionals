import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class GetServicesBySubCategory {
  final ServiceRepository repository;

  GetServicesBySubCategory(this.repository);

  Future<List<ServiceEntity>> call(String subCategoryId) async {
    return await repository.getServicesBySubCategory(subCategoryId);
  }
}
