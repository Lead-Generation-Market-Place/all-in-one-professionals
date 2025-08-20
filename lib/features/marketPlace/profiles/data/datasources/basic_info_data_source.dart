// data/datasources/basic_info_remote_datasource.dart
import 'package:yelpax_pro/features/marketPlace/profiles/data/model/basic_info_model.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

abstract class BasicInfoRemoteDataSource {
  Future<BasicInfoModel> getBasicInfo(int id);
  Future<BasicInfoModel> saveBasicInfo(BasicInfoModel model);
}

class BasicInfoRemoteDataSourceImpl implements BasicInfoRemoteDataSource {
  final ApiService apiService;

  BasicInfoRemoteDataSourceImpl(this.apiService);

  @override
  Future<BasicInfoModel> getBasicInfo(int id) async {
    final response = await apiService.get('/basic-info/$id');

    if (response.statusCode == 200) {
      return BasicInfoModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load basic info");
    }
  }

  @override
  Future<BasicInfoModel> saveBasicInfo(BasicInfoModel model) async {
    final response = await apiService.put(
      '/basic-info/${model.id}',
      data: model.toJson(),
    );

    if (response.statusCode == 200) {
      return BasicInfoModel.fromJson(response.data);
    } else {
      throw Exception("Failed to update basic info");
    }
  }
}
