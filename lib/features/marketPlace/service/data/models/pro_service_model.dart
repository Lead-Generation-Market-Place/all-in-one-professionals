

import 'package:yelpax_pro/features/marketPlace/service/domain/entities/pro_service_entity.dart';


class ProServiceModel extends ProServiceEntity {
   ProServiceModel({
    double? maximumPrice,
    double? minimumPrice,
    required String pricingType,
    required bool serviceStatus,
    required String description,
    required int completedTasks,
   
  }) : super(
         maximumPrice: maximumPrice,
         minimumPrice: minimumPrice,
         pricingType: pricingType,
         serviceStatus: serviceStatus,
         description: description,
         completedTasks: completedTasks,
       );

  /// Factory constructor to create model from JSON map
  factory ProServiceModel.fromJson(Map<String, dynamic> json) {
    return ProServiceModel(
      maximumPrice: json['maximum_price'] != null
          ? double.tryParse(json['maximum_price'].toString())
          : null,
      minimumPrice: json['minimum_price'] != null
          ? double.tryParse(json['minimum_price'].toString())
          : null,
      pricingType: json['pricing_type'] ?? 'fixed',
      serviceStatus: json['service_status'] ?? true,
      description: json['description'] ?? '',
      completedTasks: json['completed_tasks'] ?? 0,
    );
  }

  /// Converts model instance to JSON map
  Map<String, dynamic> toJson() {
    return {
      'maximum_price': maximumPrice,
      'minimum_price': minimumPrice,
      'pricing_type': pricingType,
      'service_status': serviceStatus,
      'description': description,
      'completed_tasks': completedTasks,
    };
  }

  /// Returns a string representation
  @override
  String toString() {
    return 'ProServiceModel('
        'maximumPrice: $maximumPrice, '
        'minimumPrice: $minimumPrice, '
        'pricingType: $pricingType, '
        'serviceStatus: $serviceStatus, '
        'description: $description, '
        'completedTasks: $completedTasks)';
  }

  /// Creates a copy of the current model with optional new values
  ProServiceModel copyWith({
    double? maximumPrice,
    double? minimumPrice,
    String? pricingType,
    bool? serviceStatus,
    String? description,
    int? completedTasks,
  }) {
    return ProServiceModel(
      maximumPrice: maximumPrice ?? this.maximumPrice,
      minimumPrice: minimumPrice ?? this.minimumPrice,
      pricingType: pricingType ?? this.pricingType,
      serviceStatus: serviceStatus ?? this.serviceStatus,
      description: description ?? this.description,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }

  /// Equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProServiceModel &&
        other.maximumPrice == maximumPrice &&
        other.minimumPrice == minimumPrice &&
        other.pricingType == pricingType &&
        other.serviceStatus == serviceStatus &&
        other.description == description &&
        other.completedTasks == completedTasks;
  }

  /// Hash code generator
  @override
  int get hashCode {
    return maximumPrice.hashCode ^
        minimumPrice.hashCode ^
        pricingType.hashCode ^
        serviceStatus.hashCode ^
        description.hashCode ^
        completedTasks.hashCode;
  }
}
