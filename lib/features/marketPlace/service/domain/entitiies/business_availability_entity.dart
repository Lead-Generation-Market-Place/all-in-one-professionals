// lib/features/business_availability/domain/entities/business_availability_entity.dart

class BusinessAvailabilityEntity {
  final bool availableAnytime;
  final List<BusinessHoursEntity>? businessHours;

  const BusinessAvailabilityEntity({
    required this.availableAnytime,
    this.businessHours,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BusinessAvailabilityEntity) return false;

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
    return 'BusinessAvailabilityEntity(availableAnytime: $availableAnytime, businessHours: $businessHours)';
  }
}

class BusinessHoursEntity {
  final String status; // 'open' or 'close'
  final DateTime? startTime;
  final DateTime? endTime;
  final int day; // 0-6 (0=Sunday, 1=Monday, ..., 6=Saturday)

  const BusinessHoursEntity({
    required this.status,
    this.startTime,
    this.endTime,
    required this.day,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BusinessHoursEntity) return false;

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
    return 'BusinessHoursEntity(status: $status, startTime: $startTime, endTime: $endTime, day: $day)';
  }
}
