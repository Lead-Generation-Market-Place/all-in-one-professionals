import 'package:yelpax_pro/features/marketPlace/service/data/models/pro_service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/pro_service_entity.dart';
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
    required ProServiceEntity proServiceEntity,
  }) : super(
         professionalServiceId: professionalServiceId,
         serviceEntity: serviceEntity,
         subCategoryEntity: subCategoryEntity,
         locationDataEntities: locationDataEntities,
         questionEntities: questionEntities,
         proServiceEntity: proServiceEntity,
       );

  /// Factory constructor from JSON
  factory ProfessionalServicesModel.fromJson(Map<String, dynamic> json) {
    final details = json['professionalServiceDetails'] ?? {};

    return ProfessionalServicesModel(
      professionalServiceId: json['professionalServiceId'] as String,
      serviceEntity: ServiceEntity.fromJson(json['service']),
      subCategoryEntity: SubCategoryEntity.fromJson(json['subcategory']),
      locationDataEntities: (details['locations'] as List<dynamic>? ?? [])
          .map((loc) => LocationDataEntity.fromJson(loc))
          .toList(),
      questionEntities: (json['questions'] as List<dynamic>? ?? [])
          .map((q) => QuestionEntity.fromJson(q))
          .toList(),
      proServiceEntity: ProServiceModel.fromJson(details),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final proServiceJson = ProServiceModel.toJsonFrom(
      proServiceEntity as ProServiceModel,
    );

    return {
      'professionalServiceId': professionalServiceId,
      'service': serviceEntity.toJson(),
      'subcategory': subCategoryEntity.toJson(),
      'professionalServiceDetails': {
        'locations': locationDataEntities.map((loc) => loc.toJson()).toList(),
        // Merge ProServiceModel fields into details
        ...proServiceJson,
      },
      'questions': questionEntities.map((q) => q.toJson()).toList(),
    };
  }

  /// Copy with optional updates
  ProfessionalServicesModel copyWith({
    String? professionalServiceId,
    ServiceEntity? serviceEntity,
    SubCategoryEntity? subCategoryEntity,
    List<LocationDataEntity>? locationDataEntities,
    List<QuestionEntity>? questionEntities,
    ProServiceEntity? proServiceEntity,
  }) {
    return ProfessionalServicesModel(
      professionalServiceId:
          professionalServiceId ?? this.professionalServiceId,
      serviceEntity: serviceEntity ?? this.serviceEntity,
      subCategoryEntity: subCategoryEntity ?? this.subCategoryEntity,
      locationDataEntities: locationDataEntities ?? this.locationDataEntities,
      questionEntities: questionEntities ?? this.questionEntities,
      proServiceEntity: proServiceEntity ?? this.proServiceEntity,
    );
  }

  @override
  String toString() {
    return 'ProfessionalServicesModel(professionalServiceId: $professionalServiceId, '
        'serviceEntity: $serviceEntity, '
        'subCategoryEntity: $subCategoryEntity, '
        'locationDataEntities: $locationDataEntities, '
        'questionEntities: $questionEntities, '
        'proServiceEntity: $proServiceEntity)';
  }
}
