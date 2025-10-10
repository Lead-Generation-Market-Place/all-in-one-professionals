// lib/features/marketPlace/service/data/entities/location_entity.dart

import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationDataEntity {
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

  LocationDataEntity({
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
  });

  Map<String, dynamic> toJson() {
    return {
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
    };
  }

  // Copy with method for updates
  LocationDataEntity copyWith({
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
  }) {
    return LocationDataEntity(
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
    );
  }
}

class LocationCoordinates {
  final String type;
  final List<double> coordinates;

  LocationCoordinates({this.type = 'Point', required this.coordinates});

  Map<String, dynamic> toJson() {
    return {'type': type, 'coordinates': coordinates};
  }

  // Helper method to create from LatLng
  factory LocationCoordinates.fromLatLng(LatLng latLng) {
    return LocationCoordinates(
      coordinates: [
        latLng.longitude,
        latLng.latitude,
      ], // MongoDB uses [longitude, latitude]
    );
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
}
