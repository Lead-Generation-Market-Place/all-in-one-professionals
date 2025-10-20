import 'package:yelpax_pro/features/marketPlace/service/domain/entities/professional_services_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/subcategory_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/answer_entity.dart';

class ProfessionalServicesModel extends ProfessionalServicesEntity {
  const ProfessionalServicesModel({
    required String professionalServiceId,
    required ServiceEntity serviceEntity,
    required SubCategoryEntity subCategoryEntity,
    required List<LocationDataEntity> locationDataEntities,
    required List<QuestionEntity> questionEntities,
    required List<AnswerEntity> answerEntities,
  }) : super(
         professionalServiceId: professionalServiceId,
         serviceEntity: serviceEntity,
         subCategoryEntity: subCategoryEntity,
         locationDataEntities: locationDataEntities,
         questionEntities: questionEntities,
         answerEntities: answerEntities,
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
      answerEntities: (json['questions'] as List<dynamic>? ?? [])
          .map((q) => AnswerEntity.fromJson(q['answer']))
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
      // For answers, depends on your backend structure; usually nested inside questions
    };
  }

  ProfessionalServicesModel copyWith({
    String? professionalServiceId,
    ServiceEntity? serviceEntity,
    SubCategoryEntity? subCategoryEntity,
    List<LocationDataEntity>? locationDataEntities,
    List<QuestionEntity>? questionEntities,
    List<AnswerEntity>? answerEntities,
  }) {
    return ProfessionalServicesModel(
      professionalServiceId:
          professionalServiceId ?? this.professionalServiceId,
      serviceEntity: serviceEntity ?? this.serviceEntity,
      subCategoryEntity: subCategoryEntity ?? this.subCategoryEntity,
      locationDataEntities: locationDataEntities ?? this.locationDataEntities,
      questionEntities: questionEntities ?? this.questionEntities,
      answerEntities: answerEntities ?? this.answerEntities,
    );
  }

  @override
  String toString() {
    return 'ProfessionalServicesModel(professionalServiceId: $professionalServiceId, '
        'serviceEntity: $serviceEntity, '
        'subCategoryEntity: $subCategoryEntity, '
        'locationDataEntities: $locationDataEntities, '
        'questionEntities: $questionEntities, '
        'answerEntities: $answerEntities)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProfessionalServicesModel &&
        other.professionalServiceId == professionalServiceId &&
        other.serviceEntity == serviceEntity &&
        other.subCategoryEntity == subCategoryEntity &&
        _listEquals(other.locationDataEntities, locationDataEntities) &&
        _listEquals(other.questionEntities, questionEntities) &&
        _listEquals(other.answerEntities, answerEntities);
  }

  @override
  int get hashCode {
    return professionalServiceId.hashCode ^
        serviceEntity.hashCode ^
        subCategoryEntity.hashCode ^
        locationDataEntities.hashCode ^
        questionEntities.hashCode ^
        answerEntities.hashCode;
  }

  // Helper to compare lists deeply
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
