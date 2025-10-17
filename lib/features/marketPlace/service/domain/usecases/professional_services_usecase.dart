import 'package:yelpax_pro/features/marketPlace/service/domain/entities/professional_services_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class ProfessionalServicesUsecase {
  final ServiceRepository repository;
  ProfessionalServicesUsecase(this.repository);

  Future<List<ProfessionalServicesEntity>> call(String professionalId) async {
    return await repository.fetchAllServicesRelatedToProfessional(professionalId);
  }
}
