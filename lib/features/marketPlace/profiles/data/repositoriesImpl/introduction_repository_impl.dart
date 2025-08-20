import 'package:yelpax_pro/features/marketPlace/profiles/data/datasources/introduction_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/data/model/introduction_model.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/your_introduction_entity.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/your_introduction_repository.dart';

class IntroductionRepositoryImpl implements YourIntroductionRepository {
  final IntroductionDataSource introductionDataSource;
  IntroductionRepositoryImpl(this.introductionDataSource);
  @override
  Future<YourIntroductionEntity> getIntrduction(int id) async {
    final model = await introductionDataSource.getIntroductions(id);
    return model;
  }

  @override
  Future<void> updateIntroduction(
    YourIntroductionEntity yourIntroduction,
  ) async {
    final model = IntroductionModel.fromEntity(yourIntroduction);
    await introductionDataSource.updateIntroduction(model);
  }
}
