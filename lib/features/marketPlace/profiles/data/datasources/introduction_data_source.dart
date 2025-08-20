import 'package:yelpax_pro/features/marketPlace/profiles/data/model/introduction_model.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

abstract class IntroductionDataSource {
  Future<IntroductionModel> getIntroductions(int id);
  Future<IntroductionModel> updateIntroduction(IntroductionModel model);
}

class IntroductionRemoteDataSource implements IntroductionDataSource {
  final ApiService apiService;
  IntroductionRemoteDataSource(this.apiService);
  @override
  Future<IntroductionModel> getIntroductions(int id) async {
    final response = await apiService.get('/introduction/$id');
    if (response.statusCode == 200) {
      return IntroductionModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load basic info");
    }
  }

  @override
  Future<IntroductionModel> updateIntroduction(IntroductionModel model) async {
    final response = await apiService.put('update-introduction/${model.id}');

    if (response.statusCode == 200) {
      return IntroductionModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update introduction.');
    }
  }
}
