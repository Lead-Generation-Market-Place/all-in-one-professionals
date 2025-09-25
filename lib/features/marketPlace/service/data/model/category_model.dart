import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/category_entity.dart';

class Category extends CategoryEntity {
  Category({required String id, String? name, String status = 'active'})
    : super(id: id, name: name, status: status);

  factory Category.fromJson(dynamic json) {
    if (json is String) {
      // If json is just a string (category_id), create with only id
      return Category(id: json);
    } else if (json is Map<String, dynamic>) {
      return Category(
        id: json['_id'] as String,
        name: json['name'] as String?,
        status: json['status'] ?? 'active',
      );
    } else {
      throw Exception("Invalid category json");
    }
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, if (name != null) 'name': name, 'status': status};
  }

  factory Category.fromEntity(CategoryEntity entity) {
    return Category(id: entity.id, name: entity.name, status: entity.status);
  }

  CategoryEntity toEntity() {
    return CategoryEntity(id: id, name: name, status: status);
  }


}
