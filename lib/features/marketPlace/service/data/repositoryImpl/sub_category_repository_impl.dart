import 'package:yelpax_pro/features/marketPlace/service/data/datasource/subcategory_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/subCategory.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/subcategory_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/subcategory_repository.dart';

class SubCategoryRepositoryImpl implements SubcategoryRepository {
  final SubcategoryDataSource subCategoryDataSource;

  SubCategoryRepositoryImpl(this.subCategoryDataSource);

  @override
  Future<List<SubCategoryEntity>> getSubcategories( ) {
    return subCategoryDataSource.getAllSubcategories();
  }

  @override
  Future<SubCategoryEntity> getSubcategoryById(String id) {
    return subCategoryDataSource.getSubcategoryById(id);
  }

Future<void> createSubcategory(SubCategoryEntity subcategory) {
    final model = SubCategory.fromEntity(subcategory);
    return subCategoryDataSource.addSubcategory(model.toJson());
  }

 Future<void> updateSubcategory(SubCategoryEntity subcategory) {
    final model = SubCategory.fromEntity(subcategory);
    return subCategoryDataSource.updateSubcategory(
      int.parse(subcategory.id),
      model.toJson(),
    );
  }


  @override
  Future<void> deleteSubcategory(String id) {
    return subCategoryDataSource.deleteSubcategory(int.parse(id));
  }


}