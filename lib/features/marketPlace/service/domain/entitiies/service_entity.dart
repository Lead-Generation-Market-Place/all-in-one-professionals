import 'subcategory_entity.dart';

class ServiceEntity {
  final String id;
  final String serviceName;
  final String subCategoryId;
  final bool serviceStatus;

  ServiceEntity({
    required this.id,
    required this.serviceName,
    required this.subCategoryId,
    this.serviceStatus = true,
  });
}
