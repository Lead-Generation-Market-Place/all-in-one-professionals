
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';

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
  });

  factory LocationDataEntity.fromJson(Map<String, dynamic> json) {
    // Get the mile value from JSON - it can be in different formats
    final mileId = json['mile_id'] ?? '';
    final mileValue = json['mile'] ?? 0;

    // If mile is directly provided in JSON, use it
    // Otherwise, we'll need to get it from the miles list later
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
      mileEntity: MileEntity(
        id: mileId,
        mile: mileValue is int ? mileValue : (mileValue as num).toInt(),
      ),
    );
  }

  // Alternative factory method that accepts the full miles list
  factory LocationDataEntity.fromJsonWithMiles(
      Map<String, dynamic> json,
      List<MileEntity> availableMiles
      ) {
    final mileId = json['mile_id'] ?? '';
    final mileValue = json['mile'];

    MileEntity mileEntity;
late final mileValueInt;
    // If we have a mile_id, try to find the matching mile from available miles
    if (mileId.isNotEmpty) {
      try {
        mileEntity = availableMiles.firstWhere((mile) => mile.id == mileId);
      } catch (e) {
        // If not found, create a temporary one with the provided values
        mileEntity = MileEntity(
          id: mileId,
          mile: mileValue is int ? mileValue : (mileValue as num?)?.toInt() ?? 0,
        );
      }
    } else if (mileValue != null) {
      // If we have a mile value but no ID, try to find matching mile by value
      try {
         mileValueInt = mileValue is int ? mileValue : (mileValue as num).toInt();
        mileEntity = availableMiles.firstWhere((mile) => mile.mile == mileValueInt);
      } catch (e) {
        // If not found, create a temporary one
        mileEntity = MileEntity(
          id: '',
          mile: mileValueInt,
        );
      }
    } else {
      // No mile data available
      mileEntity = MileEntity(id: '', mile: 0);
    }

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
      mileEntity: mileEntity,
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
      'mile_id': mileEntity.id,
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
    MileEntity? mileEntity
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
        mileEntity: mileEntity ?? this.mileEntity
    );
  }

  @override
  String toString() {
    return 'LocationDataEntity(id:$id, type: $type, userId: $userId, professionalId: $professionalId, '
        'serviceId: $serviceId, leadId: $leadId, projectId: $projectId, country: $country, '
        'state: $state, city: $city, zipcode: $zipcode, addressLine: $addressLine, '
        'coordinates: $coordinates, serviceArea: $serviceArea  , mileEntity: $mileEntity)';
  }
}

/// Represents geographical coordinates in GeoJSON format.
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

/// Represents a service area radius in multiple units.
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
