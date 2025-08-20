import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/business_information_entity.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/business_information_repository.dart';

class GetBusinessInfo {
  final BusinessInformationRepository repository;

  GetBusinessInfo(this.repository);

  Future<BusinessInformationEntity> call(int id) async {
    return await repository.getBusinessInfo(id);
  }
}
