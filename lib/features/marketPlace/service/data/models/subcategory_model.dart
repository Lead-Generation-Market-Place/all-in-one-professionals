import 'package:yelpax_pro/features/marketPlace/service/domain/entities/subcategory_entity.dart';

class SubCategoryModel {
  final String id;
  final String name;
  final String status;
  final String categoryId;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.status,
    required this.categoryId,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      categoryId: json['category_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'status': status,
      'category_id': categoryId,
    };
  }

  // ✅ Add this
  SubCategoryEntity toEntity() {
    return SubCategoryEntity(
      id: id,
      name: name,
      status: status,
      categoryId: categoryId,
    );
  }
}
