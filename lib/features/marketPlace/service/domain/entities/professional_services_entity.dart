import 'package:yelpax_pro/features/marketPlace/service/domain/entities/pro_service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/subcategory_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/question_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/answer_entity.dart';

class ProfessionalServicesEntity {
  final String professionalServiceId;
  final ServiceEntity serviceEntity;
  final SubCategoryEntity subCategoryEntity;
  final List<LocationDataEntity> locationDataEntities;
  final List<QuestionEntity> questionEntities;
  final ProServiceEntity proServiceEntity;

  const ProfessionalServicesEntity({
    required this.professionalServiceId,
    required this.serviceEntity,
    required this.subCategoryEntity,
    required this.locationDataEntities,
    required this.questionEntities,
    required this.proServiceEntity,
  });
}
