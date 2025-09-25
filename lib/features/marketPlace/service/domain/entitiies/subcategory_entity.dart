import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/category_entity.dart';

class SubCategoryEntity {
  final String id;
  final String name;
  final String status;
  final CategoryEntity category;

  SubCategoryEntity({
    required this.id,
    required this.name,
    this.status = 'active',
    required this.category,
  });
}
