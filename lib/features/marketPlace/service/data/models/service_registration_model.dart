import '../../domain/entities/service_registration_entity.dart';
import 'budget_model.dart';


import 'service_model.dart';

class ServiceRegistrationModel extends ServiceRegistrationEntity {
  ServiceRegistrationModel({
    super.selectedService,
    super.selectedServiceDetails,

    super.questionAnswers,

    super.budget,
    required super.professionalId,
  });

  // factory ServiceRegistrationModel.fromEntity(ServiceRegistrationEntity entity) {
  //   return ServiceRegistrationModel(
  //     selectedService: entity.selectedService,
  //     selectedServiceDetails: entity.selectedServiceDetails != null
  //         ? ServiceModel.fromEntity(entity.selectedServiceDetails!)
  //         : null,
  //     availability: entity.availability != null
  //         ? BusinessAvailabilityModel.fromEntity(entity.availability!)
  //         : null,
  //     questionAnswers: entity.questionAnswers,
  //     location: entity.location != null
  //         ? LocationModel.fromEntity(entity.location!)
  //         : null,
  //     budget: entity.budget != null
  //         ? BudgetModel.fromEntity(entity.budget!)
  //         : null,
  //     professionalId: entity.professionalId,
  //   );
  // }

  Map<String, dynamic> toJson() {
    // Transform to match backend professional_services schema
    return {
      'professional_id': professionalId,
      'service_id': selectedService,

      // Location data - backend will save this first
   
      // Business hours data


      // Answers data
      'answers': _transformAnswersForService(),

      // Pricing and availability

      'pricing_type': _getPricingType(),

      // Budget related fields
      'maximum_price': budget?.weeklyBudget,
      'minimum_price': 0, // You can set a minimum or calculate
      // Optional fields
      'description': 'Professional service for $selectedService',

      // Default fields
      'service_status': true,
      'completed_tasks': 0,
    };
  }



   
  List<Map<String, dynamic>> _transformAnswersForService() {
    if (questionAnswers == null || questionAnswers!.isEmpty) {
      return [];
    }

    return questionAnswers!.entries.map((entry) {
      return {'question_id': entry.key, 'answer': entry.value};
    }).toList();
  }



  String _getPricingType() {
    if (budget == null) return 'fixed';
    return budget!.limitBudget ? 'hourly' : 'fixed';
  }
}
