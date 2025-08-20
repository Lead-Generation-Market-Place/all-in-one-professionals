import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/business_information_entity.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/business_information_repository.dart';

class UpdateBusinessFaqsUseCase {
  final BusinessInformationRepository repository;

  UpdateBusinessFaqsUseCase(this.repository);

  Future<void> call(BusinessInformationEntity businessInfo) async {
    await repository.updateBusinessInfo(businessInfo);
  }
}
