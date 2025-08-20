import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/business_information_entity.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/business_information_repository.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/professional_repository.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/professional_license.dart';



class GetProfessionalLicense {
  final ProfessionalRepository repository;

  GetProfessionalLicense(this.repository);

  Future<ProfessionalLicense> call(int id) async {
    return await repository.getProfessional(id);
  }
}
