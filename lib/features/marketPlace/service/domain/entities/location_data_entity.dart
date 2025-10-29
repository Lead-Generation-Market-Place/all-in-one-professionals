import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';

class LocationDataEntity {
  final String? id;
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
  final MileEntity mileEntity;
  final MinuteEntity minuteEntity;
  final VehicleTypeEntity? vehicleTypeEntity;

  LocationDataEntity({
    this.id,
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
    required this.mileEntity,
    required this.minuteEntity,
    this.vehicleTypeEntity,
  });

  factory LocationDataEntity.fromJson(Map<String, dynamic> json) {
    final mileId = json['mile_id'] ?? '';
    final dynamic rawMile = json['serviceRadiusMiles'] ?? json['mile'] ?? 0;
    final int mileValue = rawMile is int ? rawMile : (rawMile as num).toInt();
    final minuteId = json['minute_id'] ?? '';
    final minuteValue = json['minute'] ?? 0;

    return LocationDataEntity(
      id: json['_id'],
      type: json['type'] ?? '',
      userId: json['user_id'] as String?,
      professionalId: json['professional_id'] as String?,
      serviceId: json['service_id'] as String?,
      leadId: json['lead_id'] as String?,
      projectId: json['project_id'] as String?,
      country: json['country'] ?? '',
      state: json['state'] as String?,
      city: json['city'] as String?,
      zipcode: json['zipcode'] as String?,
      addressLine: json['address_line'] as String?,
      coordinates: json['coordinates'] != null
          ? LocationCoordinates.fromJson(
              json['coordinates'] as Map<String, dynamic>,
            )
          : LocationCoordinates(coordinates: [0.0, 0.0]),
      serviceArea: json['service_area'] != null
          ? ServiceArea.fromJson(json['service_area'] as Map<String, dynamic>)
          : null,
      mileEntity: MileEntity(id: mileId, mile: mileValue),
      minuteEntity: MinuteEntity(
        id: minuteId,
        minute: minuteValue is int ? minuteValue : (minuteValue as num).toInt(),
      ),
      vehicleTypeEntity:
          (json['vehicle_type_id'] != null || json['vehicle_type'] != null)
          ? VehicleTypeEntity(
              id: (json['vehicle_type_id'] ?? '') as String,
              vehicle_type: (json['vehicle_type'] ?? '') as String,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      if (userId != null) 'user_id': userId,
      if (professionalId != null) 'professional_id': professionalId,
      if (serviceId != null) 'service_id': serviceId,
      if (leadId != null) 'lead_id': leadId,
      if (projectId != null) 'project_id': projectId,
      'country': country,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (zipcode != null) 'zipcode': zipcode,
      if (addressLine != null) 'address_line': addressLine,
      'coordinates': coordinates.toJson(),
      if (serviceArea != null) 'service_area': serviceArea!.toJson(),
      // Send the raw miles instead of referencing a Mile document
      'serviceRadiusMiles': mileEntity.mile,
      'minute_id': minuteEntity.id,
      if (vehicleTypeEntity != null) 'vehicle_type_id': vehicleTypeEntity!.id,
    };
  }

  LocationDataEntity copyWith({
    String? id,
    String? type,
    String? userId,
    String? professionalId,
    String? serviceId,
    String? leadId,
    String? projectId,
    String? country,
    String? state,
    String? city,
    String? zipcode,
    String? addressLine,
    LocationCoordinates? coordinates,
    ServiceArea? serviceArea,
    MileEntity? mileEntity,
    MinuteEntity? minuteEntity,
    VehicleTypeEntity? vehicleTypeEntity,
  }) {
    return LocationDataEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      professionalId: professionalId ?? this.professionalId,
      serviceId: serviceId ?? this.serviceId,
      leadId: leadId ?? this.leadId,
      projectId: projectId ?? this.projectId,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      zipcode: zipcode ?? this.zipcode,
      addressLine: addressLine ?? this.addressLine,
      coordinates: coordinates ?? this.coordinates,
      serviceArea: serviceArea ?? this.serviceArea,
      mileEntity: mileEntity ?? this.mileEntity,
      minuteEntity: minuteEntity ?? this.minuteEntity,
      vehicleTypeEntity: vehicleTypeEntity ?? this.vehicleTypeEntity,
    );
  }

  @override
  String toString() {
    return 'LocationDataEntity(id:$id, type: $type, userId: $userId, professionalId: $professionalId, '
        'serviceId: $serviceId, leadId: $leadId, projectId: $projectId, country: $country, '
        'state: $state, city: $city, zipcode: $zipcode, addressLine: $addressLine, '
        'coordinates: $coordinates, serviceArea: $serviceArea, mileEntity: $mileEntity, '
        'minuteEntity: $minuteEntity, vehicleTypeEntity: $vehicleTypeEntity)';
  }
}

class LocationCoordinates {
  final String type;
  final List<double> coordinates;

  LocationCoordinates({this.type = 'Point', required this.coordinates})
    : assert(coordinates.length == 2);

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) {
    final coords = json['coordinates'];
    List<double> coordinates = [];
    if (coords is List && coords.length == 2) {
      coordinates = coords.map((e) => (e as num).toDouble()).toList();
    } else {
      coordinates = [0.0, 0.0];
    }

    return LocationCoordinates(
      type: json['type'] ?? 'Point',
      coordinates: coordinates,
    );
  }

  factory LocationCoordinates.fromLatLng(LatLng latLng) {
    return LocationCoordinates(
      coordinates: [latLng.longitude, latLng.latitude],
    );
  }

  @override
  String toString() {
    return 'LocationCoordinates(type: $type, coordinates: $coordinates)';
  }
}

class ServiceArea {
  final int radiusMiles;
  final double radiusMeters;
  final double radiusKilometers;

  ServiceArea({
    required this.radiusMiles,
    required this.radiusMeters,
    required this.radiusKilometers,
  });

  Map<String, dynamic> toJson() {
    return {
      'radius_miles': radiusMiles,
      'radius_meters': radiusMeters,
      'radius_kilometers': radiusKilometers,
    };
  }

  factory ServiceArea.fromJson(Map<String, dynamic> json) {
    return ServiceArea(
      radiusMiles: json['radius_miles'] is int
          ? json['radius_miles']
          : (json['radius_miles'] ?? 0).toInt(),
      radiusMeters: (json['radius_meters'] ?? 0).toDouble(),
      radiusKilometers: (json['radius_kilometers'] ?? 0).toDouble(),
    );
  }

  @override
  String toString() {
    return 'ServiceArea(radiusMiles: $radiusMiles, radiusMeters: $radiusMeters, radiusKilometers: $radiusKilometers)';
  }
}
