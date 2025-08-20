import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/your_introduction_entity.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/your_introduction_repository.dart';

class UpdateYourIntroductionUseCase {
  final YourIntroductionRepository repository;
  UpdateYourIntroductionUseCase(this.repository);

  Future<void> call(YourIntroductionEntity yourIntroduction) async {
    await repository.updateIntroduction(yourIntroduction);
  }
}
