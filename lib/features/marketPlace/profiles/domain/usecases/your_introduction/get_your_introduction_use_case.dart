import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/your_introduction_entity.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/your_introduction_repository.dart';

class GetYourIntroductionUseCase {
  final YourIntroductionRepository repository;
  GetYourIntroductionUseCase(this.repository);

  Future<YourIntroductionEntity> call(int id) async {
    return await repository.getIntrduction(id);
  }
}
