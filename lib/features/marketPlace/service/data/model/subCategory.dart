import '../../domain/entitiies/subcategory_entity.dart';
import 'category_model.dart';

class SubCategory extends SubCategoryEntity {
  final Category category;

  SubCategory({
    required String id,
    required String name,
    String status = 'active',
    required this.category,
  }) : super(id: id, name: name, status: status, category: category);

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
      status: json['status'] ?? 'active',
      category: Category.fromJson(
        json['category_id'],
      ), // now supports string or object
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'status': status,
      'category_id': category.toJson(),
    };
  }

  factory SubCategory.fromEntity(SubCategoryEntity entity) {
    return SubCategory(
      id: entity.id,
      name: entity.name,
      status: entity.status,
      category: Category.fromEntity(entity.category),
    );
  }

  @override
  SubCategoryEntity toEntity() {
    return SubCategoryEntity(
      id: id,
      name: name,
      status: status,
      category: category.toEntity(),
    );
  }
}
