// models/location_model.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  final String? id;
  final String type;
  final String? userId;
  final String? professionalId;
  final String? serviceId;
  final String? leadId;
  final String? projectId;
  final String? country;
  final String? state;
  final String? city;
  final String? zipcode;
  final String? addressLine;
  final LatLng coordinates;

  LocationModel({
    this.id,
    required this.type,
    this.userId,
    this.professionalId,
    this.serviceId,
    this.leadId,
    this.projectId,
    this.country,
    this.state,
    this.city,
    this.zipcode,
    this.addressLine,
    required this.coordinates,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['_id'],
      type: json['type'],
      userId: json['user_id'],
      professionalId: json['professional_id'],
      serviceId: json['service_id'],
      leadId: json['lead_id'],
      projectId: json['project_id'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      zipcode: json['zipcode'],
      addressLine: json['address_line'],
      coordinates: LatLng(
        json['coordinates']['coordinates'][1] ?? 0.0, // latitude
        json['coordinates']['coordinates'][0] ?? 0.0, // longitude
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'user_id': userId,
      'professional_id': professionalId,
      'service_id': serviceId,
      'lead_id': leadId,
      'project_id': projectId,
      'country': country,
      'state': state,
      'city': city,
      'zipcode': zipcode,
      'address_line': addressLine,
      'coordinates': {
        'type': 'Point',
        'coordinates': [coordinates.longitude, coordinates.latitude],
      },
    };
  }

  LocationModel copyWith({
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
    LatLng? coordinates,
  }) {
    return LocationModel(
      id: id,
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
    );
  }
}
