class SubCategory {
  final String id;
  final String name;
  final String status;
  final String categoryId;

  SubCategory({
    required this.id,
    required this.name,
    required this.status,
    required this.categoryId,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      categoryId: json['category_id'] ?? '',
    );
  }
}
