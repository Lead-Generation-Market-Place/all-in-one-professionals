import 'package:yelpax_pro/features/marketPlace/service/domain/entities/subcategory_entity.dart';

class ServiceEntity {
  final String id;
  final String name;
  final String slug;
  final String subcategoryId;
  final String description;
  final String imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceEntity({
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

  // Add these methods for proper equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServiceEntity &&
        other.id == id &&
        other.name == name &&
        other.slug == slug &&
        other.subcategoryId == subcategoryId &&
        other.description == description &&
        other.imageUrl == imageUrl &&
        other.isActive == isActive &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      slug,
      subcategoryId,
      description,
      imageUrl,
      isActive,
      createdAt,
      updatedAt,
    );
  }

  // Optional: Add a copyWith method for convenience
  ServiceEntity copyWith({
    String? id,
    String? name,
    String? slug,
    String? subcategoryId,
    String? description,
    String? imageUrl,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ServiceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Optional: Add toString for debugging
  @override
  String toString() {
    return 'ServiceEntity(id: $id, name: $name, subcategoryId: $subcategoryId)';
  }
}
