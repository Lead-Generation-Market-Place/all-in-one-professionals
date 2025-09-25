import 'package:yelpax_pro/features/marketPlace/service/data/datasource/category_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/category_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryDataSource categoryDataSource;

  CategoryRepositoryImpl(this.categoryDataSource);

  @override
  Future<List<CategoryEntity>> getCategories() {
    return categoryDataSource.getAllCategories();
  }
}