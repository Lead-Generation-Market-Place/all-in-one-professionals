import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';

class ServiceModel extends ServiceEntity {
  ServiceModel({
    required String id,
    required String name,
    required String slug,
    required String subcategoryId,
    required String description,
    required String imageUrl,
    required bool isActive,
    required bool isFeatured,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
         id: id,
         name: name,
         slug: slug,
         subcategoryId: subcategoryId,
         description: description,
         imageUrl: imageUrl,
         isActive: isActive,
         isFeatured: isFeatured,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      subcategoryId: json['subcategory_id'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isActive: json['is_active'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'subcategory_id': subcategoryId,
      'description': description,
      'image_url': imageUrl,
      'is_active': isActive,
      'is_featured': isFeatured,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // ✅ From Entity (optional helper)
  factory ServiceModel.fromEntity(ServiceEntity entity) {
    return ServiceModel(
      id: entity.id,
      name: entity.name,
      slug: entity.slug,
      subcategoryId: entity.subcategoryId,
      description: entity.description,
      imageUrl: entity.imageUrl,
      isActive: entity.isActive,
      isFeatured: entity.isFeatured,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // ✅ To Entity (not really needed, ServiceModel *is* a ServiceEntity)
  ServiceEntity toEntity() {
    return this;
  }
}
