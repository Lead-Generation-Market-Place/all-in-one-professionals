
import 'package:yelpax_pro/features/marketPlace/service/data/model/category_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/category_entity.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

abstract class CategoryDataSource {
  Future<List<CategoryEntity>> getAllCategories();
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final ApiService
  apiService; // Assume ApiService is a class that handles API calls
  CategoryDataSourceImpl(this.apiService);
  @override
  Future<List<CategoryEntity>> getAllCategories() async {
    try {
      final categories = await apiService
          .get('/categories');
           return (categories.data['data'] as List)
          .map((json) => Category.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }
}
