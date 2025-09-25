import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories();
}