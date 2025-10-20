import 'package:yelpax_pro/features/marketPlace/service/domain/entities/subcategory_entity.dart';



class SubCategoryModel extends SubCategoryEntity {
  SubCategoryModel({
    required String id,
    required String name,
    required String slug,
    required bool isActive,
    required String categoryId,
    String? description,
    String? subcategoryImageUrl,
  }) : super(
         id: id,
         name: name,
         slug: slug,
         isActive: isActive,
         categoryId: categoryId,
         description: description,
         subcategoryImageUrl: subcategoryImageUrl,
       );

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      isActive: json['is_active'] ?? true,
      categoryId: json['category_id'] ?? '',
      description: json['description'],
      subcategoryImageUrl: json['subcategory_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'is_active': isActive,
      'category_id': categoryId,
      'description': description,
      'subcategory_image_url': subcategoryImageUrl,
    };
  }

  SubCategoryEntity toEntity() {
    return SubCategoryEntity(
      id: id,
      name: name,
      slug: slug,
      isActive: isActive,
      categoryId: categoryId,
      description: description,
      subcategoryImageUrl: subcategoryImageUrl,
    );
  }
}
