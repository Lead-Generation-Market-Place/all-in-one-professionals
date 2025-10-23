class SubCategoryEntity {
  final String id;
  final String name;
  final String slug;
  final bool isActive;
  final String categoryId;
  final String? description;
  final String? subcategoryImageUrl;

  SubCategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    required this.isActive,
    required this.categoryId,
    this.description,
    this.subcategoryImageUrl,
  });

  factory SubCategoryEntity.fromJson(Map<String, dynamic> json) {
    return SubCategoryEntity(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      isActive: json['is_active'] ?? true,
      categoryId: json['category_id'] ?? '',
      description: json['description'], // nullable, so no fallback
      subcategoryImageUrl: json['subcategory_image_url'], // nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'slug': slug,
      'is_active': isActive,
      'category_id': categoryId,
      if (description != null) 'description': description,
      if (subcategoryImageUrl != null)
        'subcategory_image_url': subcategoryImageUrl,
    };
  }

@override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubCategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;



  SubCategoryEntity copyWith({
    String? id,
    String? name,
    String? slug,
    bool? isActive,
    String? categoryId,
    String? description,
    String? subcategoryImageUrl,
  }) {
    return SubCategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      isActive: isActive ?? this.isActive,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      subcategoryImageUrl: subcategoryImageUrl ?? this.subcategoryImageUrl,
    );
  }
}
