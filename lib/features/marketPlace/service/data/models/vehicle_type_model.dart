import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';

class VehicleTypeModel extends VehicleTypeEntity {
  const VehicleTypeModel({required super.id, required super.vehicle_type});

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypeModel(
      id: json['_id'] ?? '',
      vehicle_type: json['vehicle_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'vehicle_type': vehicle_type};
  }
}
