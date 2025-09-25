import 'package:logger/logger.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/subCategory.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/subcategory_entity.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

abstract class SubcategoryDataSource {
  Future<List<SubCategoryEntity>> getAllSubcategories();
  Future<void> addSubcategory(Map<String, dynamic> subcategoryData);
  Future<void> updateSubcategory(int id, Map<String, dynamic> subcategoryData);
  Future<SubCategoryEntity> getSubcategoryById(String id);
  Future<void> deleteSubcategory(int id);

}

class SubcategoryRemoteDataSourceImpl implements SubcategoryDataSource {
  final ApiService apiService;
  SubcategoryRemoteDataSourceImpl(this.apiService);
  @override
  Future<void> addSubcategory(Map<String, dynamic> subcategoryData) async {
    try {
      final response = await apiService.post(
        '/subcategories',
        data: subcategoryData,
      );
      Logger().d(response);
      if (response.statusCode == 201) {
        Logger().d(response.data);
        return response.data;

      } else {
        throw Exception("Failed to add subcategory");
      }
    } catch (e) {
      throw Exception("Failed to add subcategory");
    }
  }

  @override
  Future<void> updateSubcategory(
    int id,
    Map<String, dynamic> subcategoryData,
  ) async {
    try {
      final response = await apiService.put(
        '/subcategories/$id',
        data: subcategoryData,
      );
      if (response.statusCode == 200) {
        Logger().d(response.data);
        return response.data;
      } else {
        throw Exception("Failed to update subcategory");
      }
    } catch (e) {
      throw Exception("Failed to update subcategory");
    }
  }

  @override
  Future<void> deleteSubcategory(int id) async {
    try {
      final response = await apiService.delete('/subcategories/$id');
      if (response.statusCode == 204) {
        Logger().d("Subcategory deleted");
        return;
      } else {
        throw Exception("Failed to delete subcategory");
      }
    } catch (e) {
      throw Exception("Failed to delete subcategory");
    }
  }

  @override
  Future<List<SubCategoryEntity>> getAllSubcategories() async {
    try {
      final response = await apiService.get('/subcategories');
      if (response.statusCode == 200) {
        Logger().d(response.data);
        return (response.data['data'] as List)
            .map((json) => SubCategory.fromJson(json).toEntity())
            .toList();

      } else {
        throw Exception("Failed to get subcategories");
      }
    } catch (e) {
      throw Exception("Failed to get subcategories");
    }
  }

 

  @override
  Future<SubCategoryEntity> getSubcategoryById(String id) async{

    try {
      final response = await apiService.get('/subcategories/$id');
      if (response.statusCode == 200) {
        Logger().d(response.data);
        return response.data;
      } else {
        throw Exception("Failed to get subcategory by id");
      }
    } catch (e) {
      throw Exception("Failed to get subcategory by id");
    }
  }
}
