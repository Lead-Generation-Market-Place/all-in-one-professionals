import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/subcategory_entity.dart';

abstract class SubcategoryRepository {
  Future<List<SubCategoryEntity>> getSubcategories( );
  Future<SubCategoryEntity> getSubcategoryById(String id);
  Future<void> createSubcategory(SubCategoryEntity subcategory);
  Future<void> updateSubcategory(SubCategoryEntity subcategory);
  Future<void> deleteSubcategory(String id);

}