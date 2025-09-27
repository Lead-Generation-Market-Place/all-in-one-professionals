// lib/features/business_availability/data/models/business_availability_model.dart

import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/business_availability_entity.dart';

class BusinessAvailabilityModel {
  final bool availableAnytime;
  final List<BusinessHoursModel>? businessHours;

  const BusinessAvailabilityModel({
    required this.availableAnytime,
    this.businessHours,
  });

  // Convert to JSON for backend
  Map<String, dynamic> toJson() {
    return {
      'available_anytime': availableAnytime,
      'business_hours': businessHours?.map((hour) => hour.toJson()).toList(),
    };
  }

  // Convert from JSON (if needed for receiving data)
  factory BusinessAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return BusinessAvailabilityModel(
      availableAnytime: json['available_anytime'] ?? false,
      businessHours: json['business_hours'] != null
          ? (json['business_hours'] as List)
                .map((e) => BusinessHoursModel.fromJson(e))
                .toList()
          : null,
    );
  }

  // Convert Entity to Model
  factory BusinessAvailabilityModel.fromEntity(
    BusinessAvailabilityEntity entity,
  ) {
    return BusinessAvailabilityModel(
      availableAnytime: entity.availableAnytime,
      businessHours: entity.businessHours
          ?.map((hour) => BusinessHoursModel.fromEntity(hour))
          .toList(),
    );
  }

  // Convert Model to Entity
  BusinessAvailabilityEntity toEntity() {
    return BusinessAvailabilityEntity(
      availableAnytime: availableAnytime,
      businessHours: businessHours?.map((hour) => hour.toEntity()).toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BusinessAvailabilityModel) return false;

    // Compare businessHours lists
    if (businessHours == null && other.businessHours == null) {
      return availableAnytime == other.availableAnytime;
    }
    if (businessHours == null || other.businessHours == null) return false;
    if (businessHours!.length != other.businessHours!.length) return false;

    for (int i = 0; i < businessHours!.length; i++) {
      if (businessHours![i] != other.businessHours![i]) return false;
    }

    return availableAnytime == other.availableAnytime;
  }

  @override
  int get hashCode {
    int hash = availableAnytime.hashCode;
    if (businessHours != null) {
      for (var hour in businessHours!) {
        hash = hash ^ hour.hashCode;
      }
    }
    return hash;
  }

  @override
  String toString() {
    return 'BusinessAvailabilityModel(availableAnytime: $availableAnytime, businessHours: $businessHours)';
  }
}

class BusinessHoursModel {
  final String status; // 'open' or 'close'
  final DateTime? startTime;
  final DateTime? endTime;
  final int day; // 0-6 (0=Sunday, 1=Monday, ..., 6=Saturday)

  const BusinessHoursModel({
    required this.status,
    this.startTime,
    this.endTime,
    required this.day,
  });

  // Convert to JSON for backend
  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'day': day,
    };
  }

  // Convert from JSON
  factory BusinessHoursModel.fromJson(Map<String, dynamic> json) {
    return BusinessHoursModel(
      status: json['status'] ?? 'close',
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'])
          : null,
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'])
          : null,
      day: json['day'] ?? 0,
    );
  }

  // Convert Entity to Model
  factory BusinessHoursModel.fromEntity(BusinessHoursEntity entity) {
    return BusinessHoursModel(
      status: entity.status,
      startTime: entity.startTime,
      endTime: entity.endTime,
      day: entity.day,
    );
  }

  // Convert Model to Entity
  BusinessHoursEntity toEntity() {
    return BusinessHoursEntity(
      status: status,
      startTime: startTime,
      endTime: endTime,
      day: day,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BusinessHoursModel) return false;

    return status == other.status &&
        startTime == other.startTime &&
        endTime == other.endTime &&
        day == other.day;
  }

  @override
  int get hashCode {
    return status.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        day.hashCode;
  }

  @override
  String toString() {
    return 'BusinessHoursModel(status: $status, startTime: $startTime, endTime: $endTime, day: $day)';
  }
}
