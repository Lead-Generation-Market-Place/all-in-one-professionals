class ServiceModel {
  final String id;
  final String serviceName;
  final String subcategoryId;
  final bool serviceStatus;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.serviceName,
    required this.subcategoryId,
    required this.serviceStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'],
      serviceName: json['service_name'],
      subcategoryId: json['subcategory_id'],
      serviceStatus: json['service_status'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
