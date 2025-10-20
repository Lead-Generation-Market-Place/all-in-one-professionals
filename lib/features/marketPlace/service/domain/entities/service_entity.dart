

class ServiceEntity {
  final String id;
  final String name;
  final String slug;
  final String subcategoryId;
  final String description;
  final String imageUrl;
  final bool isActive;
  final bool isFeatured;
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
    required this.isFeatured,
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
        other.isFeatured == isFeatured &&
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
      isFeatured,
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
    bool? isFeatured,
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
      isFeatured: isFeatured ?? this.isFeatured,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Optional: Add toString for debugging
  @override
  String toString() {
    return 'ServiceEntity(id: $id, name: $name, subcategoryId: $subcategoryId)';
  }

  factory ServiceEntity.fromJson(Map<String, dynamic> json) {
    return ServiceEntity(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      subcategoryId: json['subcategory_id'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      isActive: json['is_active'] ?? false,
      isFeatured: json['is_featured'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
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
}
