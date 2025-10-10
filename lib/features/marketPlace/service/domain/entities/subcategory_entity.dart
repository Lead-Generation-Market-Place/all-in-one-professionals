class SubCategoryEntity {
  final String id;
  final String name;
  final String status;
  final String categoryId;

  SubCategoryEntity({
    required this.id,
    required this.name,
    required this.status,
    required this.categoryId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SubCategoryEntity &&
        other.id == id &&
        other.name == name &&
        other.status == status &&
        other.categoryId == categoryId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      status,
      categoryId,
    );
  }

  SubCategoryEntity copyWith({
    String? id,
    String? name,
    String? status,
    String? categoryId,
  }) {
    return SubCategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
    );
  }
}
