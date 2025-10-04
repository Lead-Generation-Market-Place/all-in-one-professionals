

class BusinessAvailabilityModel {
  final bool availableAnytime;
  final List<BusinessHoursModel>? businessHours;

  BusinessAvailabilityModel({
    required this.availableAnytime,
    this.businessHours,
  });

  Map<String, dynamic> toJson() {
    return {
      'available_anytime': availableAnytime,
      'business_hours': businessHours?.map((e) => e.toJson()).toList(),
    };
  }

  factory BusinessAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return BusinessAvailabilityModel(
      availableAnytime: json['available_anytime'],
      businessHours: json['business_hours'] != null
          ? List<BusinessHoursModel>.from(
              json['business_hours'].map((e) => BusinessHoursModel.fromJson(e)),
            )
          : null,
    );
  }
}

class BusinessHoursModel {
  final String status; // "open" or "close"
  final DateTime? startTime;
  final DateTime? endTime;
  final int day; // 0 (Sunday) to 6 (Saturday)

  BusinessHoursModel({
    required this.status,
    required this.day,
    this.startTime,
    this.endTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'day': day,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
    };
  }

  factory BusinessHoursModel.fromJson(Map<String, dynamic> json) {
    return BusinessHoursModel(
      status: json['status'],
      day: json['day'],
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'])
          : null,
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'])
          : null,
    );
  }
}
