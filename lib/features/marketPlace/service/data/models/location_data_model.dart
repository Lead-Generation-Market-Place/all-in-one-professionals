import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';

class LocationDataModel extends LocationDataEntity {
  final DateTime createdAt;
  final DateTime updatedAt;

  LocationDataModel({
    required String? id,
    required String type,
    String? userId,
    String? professionalId,
    String? serviceId,
    String? leadId,
    String? projectId,
    required String country,
    String? state,
    String? city,
    String? zipcode,
    String? addressLine,
    required LocationCoordinates coordinates,
    ServiceArea? serviceArea,
    required MileEntity mileEntity,
    required MinuteEntity minuteEntity,
    VehicleTypeEntity? vehicleTypeEntity,
    required this.createdAt,
    required this.updatedAt,
  }) : super(
         id: id,
         type: type,
         userId: userId,
         professionalId: professionalId,
         serviceId: serviceId,
         leadId: leadId,
         projectId: projectId,
         country: country,
         state: state,
         city: city,
         zipcode: zipcode,
         addressLine: addressLine,
         coordinates: coordinates,
         serviceArea: serviceArea,
         mileEntity: mileEntity,
         minuteEntity: minuteEntity,
         vehicleTypeEntity: vehicleTypeEntity,
       );

  /// Convert from JSON to Model
  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    final entity = LocationDataEntity.fromJson(json);

    return LocationDataModel(
      id: entity.id,
      type: entity.type,
      userId: entity.userId,
      professionalId: entity.professionalId,
      serviceId: entity.serviceId,
      leadId: entity.leadId,
      projectId: entity.projectId,
      country: entity.country,
      state: entity.state,
      city: entity.city,
      zipcode: entity.zipcode,
      addressLine: entity.addressLine,
      coordinates: entity.coordinates,
      serviceArea: entity.serviceArea,
      mileEntity: entity.mileEntity,
      minuteEntity: entity.minuteEntity,
      vehicleTypeEntity: entity.vehicleTypeEntity,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['createdAt'] = createdAt.toIso8601String();
    json['updatedAt'] = updatedAt.toIso8601String();
    return json;
  }

  /// Convert from Entity to Model
  factory LocationDataModel.fromEntity(
    LocationDataEntity entity, {
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return LocationDataModel(
      id: entity.id,
      type: entity.type,
      userId: entity.userId,
      professionalId: entity.professionalId,
      serviceId: entity.serviceId,
      leadId: entity.leadId,
      projectId: entity.projectId,
      country: entity.country,
      state: entity.state,
      city: entity.city,
      zipcode: entity.zipcode,
      addressLine: entity.addressLine,
      coordinates: entity.coordinates,
      serviceArea: entity.serviceArea,
      mileEntity: entity.mileEntity,
      minuteEntity: entity.minuteEntity,
      vehicleTypeEntity: entity.vehicleTypeEntity,
      createdAt: createdAt ?? DateTime.now(),
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Convert Model back to Entity
  LocationDataEntity toEntity() {
    return LocationDataEntity(
      id: id,
      type: type,
      userId: userId,
      professionalId: professionalId,
      serviceId: serviceId,
      leadId: leadId,
      projectId: projectId,
      country: country,
      state: state,
      city: city,
      zipcode: zipcode,
      addressLine: addressLine,
      coordinates: coordinates,
      serviceArea: serviceArea,
      mileEntity: mileEntity,
      minuteEntity: minuteEntity,
      vehicleTypeEntity: vehicleTypeEntity,
    );
  }
}
