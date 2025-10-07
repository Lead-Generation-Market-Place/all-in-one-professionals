import 'package:yelpax_pro/features/marketPlace/service/presentation/models/budget_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/business_availability.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/location_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/models/service_model.dart';

class ServiceRegistrationModel {
  String? selectedService;
  ServiceModel? selectedServiceDetails;
  BusinessAvailabilityModel? availability;
  Map<String, dynamic>? questionAnswers;
  LocationModel? location;
  BudgetModel? budget;
  String professionalId; // Add professional ID

  ServiceRegistrationModel({
    this.selectedService,
    this.selectedServiceDetails,
    this.availability,
    this.questionAnswers,
    this.location,
    this.budget,
   required this.professionalId,
  });

  Map<String, dynamic> toJson() {
    // Transform to match backend professional_services schema
    return {
      'professional_id': professionalId, // You need to set this from auth
      'service_id': selectedService,

      // Location data - backend will save this first
      'location': _transformLocationForService(),

      // Business hours data
      'business_hours': _transformBusinessHours(),

      // Answers data
      'answers': _transformAnswersForService(),

      // Pricing and availability
      'service_availability': availability?.availableAnytime ?? true,
      'pricing_type': _getPricingType(),

      // Budget related fields
      'maximum_price': budget?.weeklyBudget,
      'minimum_price': 0, // You can set a minimum or calculate
      // Optional fields
      'description': 'Professional service for ${selectedService}',

      // Default fields
      'service_status': true,
      'completed_tasks': 0,
    };
  }

  List<Map<String, dynamic>> _transformBusinessHours() {
    if (availability == null || availability!.availableAnytime) {
      return [];
    }

    return availability!.businessHours?.map((hour) {
          return {
            'day': hour.day,
            'status': hour.status,
            'start_time': hour.startTime?.toIso8601String(),
            'end_time': hour.endTime?.toIso8601String(),
          };
        }).toList() ??
        [];
  }

  List<Map<String, dynamic>> _transformAnswersForService() {
    if (questionAnswers == null || questionAnswers!.isEmpty) {
      return [];
    }

    return questionAnswers!.entries.map((entry) {
      return {'question_id': entry.key, 'answer': entry.value};
    }).toList();
  }

  Map<String, dynamic> _transformLocationForService() {
    if (location == null) {
      throw Exception('Location data is required');
    }

    // Send complete location data - backend will save and link
    return location!.toJson();
  }

  String _getPricingType() {
    if (budget == null) return 'fixed';
    return budget!.limitBudget ? 'hourly' : 'fixed';
  }

  // ServiceRegistrationModel copyWith({
  //   ServiceModel? selectedService,
  //   BusinessAvailabilityModel? availability,
  //   Map<String, dynamic>? questionAnswers,
  //   LocationModel? location,
  //   BudgetModel? budget,
  //   String? professionalId,
  // }) {
  //   return ServiceRegistrationModel(
  //     selectedService: selectedService?,
  //     availability: availability ?? this.availability,
  //     questionAnswers: questionAnswers ?? this.questionAnswers,
  //     location: location ?? this.location,
  //     budget: budget ?? this.budget,
  //     professionalId: professionalId ?? this.professionalId,
  //   );
  // }
}
