import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/professional_services_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/subcategory_entity.dart';

class ProfessionalServicesModel extends ProfessionalServicesEntity {
  const ProfessionalServicesModel({
    required String professionalServiceId,
    required ServiceEntity serviceEntity,
    required SubCategoryEntity subCategoryEntity,
    required List<LocationDataEntity> locationDataEntities,
    required List<QuestionEntity> questionEntities,
  }) : super(
         professionalServiceId: professionalServiceId,
         serviceEntity: serviceEntity,
         subCategoryEntity: subCategoryEntity,
         locationDataEntities: locationDataEntities,
         questionEntities: questionEntities,
       );

  factory ProfessionalServicesModel.fromJson(Map<String, dynamic> json) {
    return ProfessionalServicesModel(
      professionalServiceId: json['professionalServiceId'] as String,
      serviceEntity: ServiceEntity.fromJson(json['service']),
      subCategoryEntity: SubCategoryEntity.fromJson(json['subcategory']),
      locationDataEntities:
          (json['professionalServiceDetails']?['locations'] as List<dynamic>? ??
                  [])
              .map((loc) => LocationDataEntity.fromJson(loc))
              .toList(),
      questionEntities: (json['questions'] as List<dynamic>? ?? [])
          .map((q) => QuestionEntity.fromJson(q))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'professionalServiceId': professionalServiceId,
      'service': serviceEntity.toJson(),
      'subcategory': subCategoryEntity.toJson(),
      'professionalServiceDetails': {
        'locations': locationDataEntities.map((loc) => loc.toJson()).toList(),
      },
      'questions': questionEntities.map((q) => q.toJson()).toList(),
    };
  }

  ProfessionalServicesModel copyWith({
    String? professionalServiceId,
    ServiceEntity? serviceEntity,
    SubCategoryEntity? subCategoryEntity,
    List<LocationDataEntity>? locationDataEntities,
    List<QuestionEntity>? questionEntities,
  }) {
    return ProfessionalServicesModel(
      professionalServiceId:
          professionalServiceId ?? this.professionalServiceId,
      serviceEntity: serviceEntity ?? this.serviceEntity,
      subCategoryEntity: subCategoryEntity ?? this.subCategoryEntity,
      locationDataEntities: locationDataEntities ?? this.locationDataEntities,
      questionEntities: questionEntities ?? this.questionEntities,
    );
  }

  // Override == and hashCode if needed, similar to your original code
}
