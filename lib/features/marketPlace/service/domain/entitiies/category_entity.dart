class CategoryEntity {
  final String id;
  final String? name;
  final String status;

  CategoryEntity({required this.id, this.name, this.status = 'active'});
}
