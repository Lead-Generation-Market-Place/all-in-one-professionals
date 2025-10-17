import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';

class ProfessionalServicesEntity {
  final String id;
  final String professionalId;
  final ServiceEntity service;
  final List<LocationDataEntity> locations;
  final bool serviceStatus;
  final String pricingType;
  final int completedTasks;
  final List<QuestionEntity> questions;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfessionalServicesEntity({
    required this.id,
    required this.professionalId,
    required this.service,
    required this.locations,
    required this.serviceStatus,
    required this.pricingType,
    required this.completedTasks,
    required this.questions,
    required this.createdAt,
    required this.updatedAt,
  });
}
