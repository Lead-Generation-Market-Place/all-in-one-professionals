import '../../domain/entitiies/service_entity.dart';

class Services extends ServiceEntity {
  Services({
    required String id,
    required String serviceName,
    required String subCategoryId,
    bool serviceStatus = true,
  }) : super(
         id: id,
         serviceName: serviceName,
         subCategoryId: subCategoryId,
         serviceStatus: serviceStatus,
       );

  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      id: json['_id'] as String,
      serviceName: json['service_name'] as String,
      subCategoryId: json['subcategory_id'] as String,
      serviceStatus: json['service_status'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'service_name': serviceName,
      'subcategory_id': subCategoryId,
      'service_status': serviceStatus,
    };
  }

  factory Services.fromEntity(ServiceEntity entity) {
    return Services(
      id: entity.id,
      serviceName: entity.serviceName,
      subCategoryId: entity.subCategoryId,
      serviceStatus: entity.serviceStatus,
    );
  }
}
