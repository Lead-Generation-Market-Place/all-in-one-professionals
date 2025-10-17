import 'package:yelpax_pro/features/marketPlace/service/data/models/location_data_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/question_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/professional_services_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';

class ProfessionalServicesModel extends ProfessionalServicesEntity {
  ProfessionalServicesModel({
    required String id,
    required String professionalId,
    required ServiceEntity service,
    required List<LocationDataEntity> locations,
    required bool serviceStatus,
    required String pricingType,
    required int completedTasks,
    required List<QuestionEntity> questions,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super(
         id: id,
         professionalId: professionalId,
         service: service,
         locations: locations,
         serviceStatus: serviceStatus,
         pricingType: pricingType,
         completedTasks: completedTasks,
         questions: questions,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory ProfessionalServicesModel.fromJson(Map<String, dynamic> json) {
    final serviceModel = ServiceModel.fromJson(json['service_id']);
    final locationModels = (json['location_ids'] as List)
        .map((loc) => LocationDataModel.fromJson(loc))
        .toList();
    final questionModels = (json['question_ids'] as List)
        .map((q) => QuestionModel.fromJson(q))
        .toList();

    return ProfessionalServicesModel(
      id: json['_id'],
      professionalId: json['professional_id'],
      service: serviceModel.toEntity(), // Convert model to entity here
      locations: locationModels
          .map(
            (locationModel) => locationModel.toEntityWithStoredValues(),
          ) // Convert each model to entity
          .toList(),
      serviceStatus: json['service_status'],
      pricingType: json['pricing_type'],
      completedTasks: json['completed_tasks'],
      questions: questionModels
          .map((q) => q)
          .toList(), // Assuming QuestionModel has toEntity()
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
