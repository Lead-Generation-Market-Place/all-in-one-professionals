import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/basic_info_entity.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/screens/professional_license.dart';

abstract class ProfessionalRepository {
  Future<ProfessionalLicense> getProfessional(int id);
  Future<void> updateProfessional(BasicInfoEntity entitiy);
}
