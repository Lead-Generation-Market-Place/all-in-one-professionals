import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';

class LocationDataModel {
  final String id;
  final String type;
  final String? userId;
  final String? professionalId;
  final String? serviceId;
  final String? leadId;
  final String? projectId;
  final String country;
  final String? state;
  final String? city;
  final String? zipcode;
  final String? addressLine;
  final LocationCoordinates coordinates;
  final ServiceArea? serviceArea;

  final String mileId;
  final int? mileValue;

  final String minuteId;
  final int? minuteValue;

  final String vehicleTypeId;
  final String? vehicleTypeValue;

  final DateTime createdAt;
  final DateTime updatedAt;

  LocationDataModel({
    required this.id,
    required this.type,
    this.userId,
    this.professionalId,
    this.serviceId,
    this.leadId,
    this.projectId,
    required this.country,
    this.state,
    this.city,
    this.zipcode,
    this.addressLine,
    required this.coordinates,
    this.serviceArea,
    required this.mileId,
    this.mileValue,
    required this.minuteId,
    this.minuteValue,
    required this.vehicleTypeId,
    this.vehicleTypeValue,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert from JSON to Model
  factory LocationDataModel.fromJson(Map<String, dynamic> json) {
    return LocationDataModel(
      id: json['_id'] ?? json['id'],
      type: json['type'],
      userId: json['user_id'],
      professionalId: json['professional_id'],
      serviceId: json['service_id'],
      leadId: json['lead_id'],
      projectId: json['project_id'],
      country: json['country'] ?? 'USA',
      state: json['state'],
      city: json['city'],
      zipcode: json['zipcode'],
      addressLine: json['address_line'],
      coordinates: LocationCoordinates(
        type: json['coordinates']['type'] ?? 'Point',
        coordinates: List<double>.from(json['coordinates']['coordinates']),
      ),
      serviceArea: json['service_area'] != null
          ? ServiceArea(
              radiusMiles: json['service_area']['radius_miles'],
              radiusMeters: (json['service_area']['radius_meters'] ?? 0)
                  .toDouble(),
              radiusKilometers: (json['service_area']['radius_kilometers'] ?? 0)
                  .toDouble(),
            )
          : null,
      mileId: json['mile_id'] ?? '',
      mileValue: json['mile'] is int
          ? json['mile']
          : (json['mile'] as num?)?.toInt(),
      minuteId: json['minute_id'] ?? '',
      minuteValue: json['minute'] is int
          ? json['minute']
          : (json['minute'] as num?)?.toInt(),
      vehicleTypeId: json['vehicle_type_id'] ?? '',
      vehicleTypeValue: json['vehicle_type'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (userId != null) 'user_id': userId,
      if (professionalId != null) 'professional_id': professionalId,
      if (serviceId != null) 'service_id': serviceId,
      if (leadId != null) 'lead_id': leadId,
      if (projectId != null) 'project_id': projectId,
      'mile_id': mileId,
      'minute_id': minuteId,
      'vehicle_type_id': vehicleTypeId,
      'country': country,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (zipcode != null) 'zipcode': zipcode,
      if (addressLine != null) 'address_line': addressLine,
      'coordinates': coordinates.toJson(),
      if (serviceArea != null) 'service_area': serviceArea!.toJson(),
    };
  }

  /// Convert from Entity to Model
  factory LocationDataModel.fromEntity(
    LocationDataEntity entity, {
    String? id,
  }) {
    return LocationDataModel(
      id: id ?? entity.id ?? '',
      type: entity.type,
      userId: entity.userId,
      professionalId: entity.professionalId,
      serviceId: entity.serviceId,
      leadId: entity.leadId,
      projectId: entity.projectId,
      mileId: entity.mileEntity.id,
      mileValue: entity.mileEntity.mile,
      minuteId: entity.minuteEntity.id,
      minuteValue: entity.minuteEntity.minute,
      vehicleTypeId: entity.vehicleTypeEntity?.id ?? '',
      vehicleTypeValue: entity.vehicleTypeEntity?.vehicle_type,
      country: entity.country,
      state: entity.state,
      city: entity.city,
      zipcode: entity.zipcode,
      addressLine: entity.addressLine,
      coordinates: entity.coordinates,
      serviceArea: entity.serviceArea,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Convert Model to Entity using actual entities
  LocationDataEntity toEntity({
    required MileEntity mileEntity,
    required MinuteEntity minuteEntity,
    VehicleTypeEntity? vehicleTypeEntity,
  }) {
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

  /// Convert to Entity using stored mile/minute values
  LocationDataEntity toEntityWithStoredValues() {
    final mileEntity = MileEntity(id: mileId, mile: mileValue ?? 0);

    final minuteEntity = MinuteEntity(id: minuteId, minute: minuteValue ?? 0);
    final vehicleType = vehicleTypeId.isNotEmpty
        ? VehicleTypeEntity(
            id: vehicleTypeId,
            vehicle_type: vehicleTypeValue ?? '',
          )
        : null;

    return toEntity(
      mileEntity: mileEntity,
      minuteEntity: minuteEntity,
      vehicleTypeEntity: vehicleType,
    );
  }
}
