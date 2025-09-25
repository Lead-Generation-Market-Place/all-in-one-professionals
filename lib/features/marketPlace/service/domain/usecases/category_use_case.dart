import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/category_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/category_repository.dart';

class CategoryUsecase {
  final CategoryRepository repository;

  CategoryUsecase(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}
