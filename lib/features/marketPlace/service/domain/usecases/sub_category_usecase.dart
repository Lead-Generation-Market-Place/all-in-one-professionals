import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/subcategory_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/subcategory_repository.dart';

class SubCategoryUsecase {
  final SubcategoryRepository subcategoryRepository;
  SubCategoryUsecase(this.subcategoryRepository);

  Future<List<SubCategoryEntity>> call(Map<String, dynamic> subcategoryData) async {
    return await subcategoryRepository.getSubcategories();
  }

}