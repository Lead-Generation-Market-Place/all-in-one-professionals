import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';

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
  final int? mileValue; // Add this field to store the actual mile value
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
    this.mileValue, // Initialize this
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert from JSON to Model
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
        radiusMeters: json['service_area']['radius_meters'].toDouble(),
        radiusKilometers: json['service_area']['radius_kilometers']
            .toDouble(),
      )
          : null,
      mileId: json['mile_id'] ?? '',
      mileValue: json['mile'] is int ? json['mile'] : (json['mile'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (userId != null) 'user_id': userId,
      if (professionalId != null) 'professional_id': professionalId,
      if (serviceId != null) 'service_id': serviceId,
      if (leadId != null) 'lead_id': leadId,
      if (projectId != null) 'project_id': projectId,
      'mile_id': mileId,
      'country': country,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (zipcode != null) 'zipcode': zipcode,
      if (addressLine != null) 'address_line': addressLine,
      'coordinates': coordinates.toJson(),
      if (serviceArea != null) 'service_area': serviceArea!.toJson(),
    };
  }

  // Convert from Entity to Model
  factory LocationDataModel.fromEntity(
      LocationDataEntity entity, {
        String? id,
      }) {
    return LocationDataModel(
      id: id ?? '',
      type: entity.type,
      userId: entity.userId,
      professionalId: entity.professionalId,
      serviceId: entity.serviceId,
      leadId: entity.leadId,
      projectId: entity.projectId,
      mileId: entity.mileEntity.id,
      mileValue: entity.mileEntity.mile,
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

  LocationDataEntity toEntity({required MileEntity mileEntity}) {
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
    );
  }

  // Alternative method that uses the stored mileValue if available
  LocationDataEntity toEntityWithStoredMile() {
    final mileEntity = MileEntity(
      id: mileId,
      mile: mileValue ?? 0,
    );

    return toEntity(mileEntity: mileEntity);
  }
}