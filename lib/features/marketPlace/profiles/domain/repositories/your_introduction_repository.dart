import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/your_introduction_entity.dart';

abstract class YourIntroductionRepository {
  Future<YourIntroductionEntity> getIntrduction(int id);
  Future<void> updateIntroduction(YourIntroductionEntity yourIntroduction);
}
