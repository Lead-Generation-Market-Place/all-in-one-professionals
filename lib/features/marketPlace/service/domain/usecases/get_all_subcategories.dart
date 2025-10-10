import '../entities/subcategory_entity.dart';
import '../repositories/service_repository.dart';

class GetAllSubCategories {
  final ServiceRepository repository;

  GetAllSubCategories(this.repository);

  Future<List<SubCategoryEntity>> call() async {
    return await repository.getAllSubCategories();
  }
}
