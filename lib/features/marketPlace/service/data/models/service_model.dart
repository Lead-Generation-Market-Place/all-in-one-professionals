import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';

class ServiceModel {
  final String id;
  final String name;
  final String slug;
  final String subcategoryId;
  final String description;
  final String imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.subcategoryId,
    required this.description,
    required this.imageUrl,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      subcategoryId: json['subcategory_id'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isActive: json['is_active'] ?? false,
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // ✅ From Entity
  factory ServiceModel.fromEntity(ServiceEntity entity) {
    return ServiceModel(
      id: entity.id,
      name: entity.name,
      slug: entity.slug,
      subcategoryId: entity.subcategoryId,
      description: entity.description,
      imageUrl: entity.imageUrl,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  // ✅ To Entity
  ServiceEntity toEntity() {
    return ServiceEntity(
      id: id,
      name: name,
      slug: slug,
      subcategoryId: subcategoryId,
      description: description,
      imageUrl: imageUrl,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
