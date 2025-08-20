import '../../../../../shared/services/api_service.dart';
import '../model/business_information_model.dart';

abstract class BusinessInformationDataSource {
  Future<BusinessInformationModel> getBusinessInformation(int id);

  Future<BusinessInformationModel> saveBusinessInformation(
    BusinessInformationModel model,
  );
}

class BusinessInformationDataSourceImpl
    implements BusinessInformationDataSource {
  final ApiService apiService;

  BusinessInformationDataSourceImpl(this.apiService);

  @override
  Future<BusinessInformationModel> getBusinessInformation(int id) async {
    final response = await apiService.get('/basic-info/$id');

    if (response.statusCode == 200) {
      return BusinessInformationModel.fromJson(response.data);
    } else {
      throw Exception("Failed to load basic info");
    }
  }

  @override
  Future<BusinessInformationModel> saveBusinessInformation(
    BusinessInformationModel model,
  ) async {
    final response = await apiService.put(
      '/basic-info/${model.id}',
      data: model.toJson(),
    );

    if (response.statusCode == 200) {
      return BusinessInformationModel.fromJson(response.data);
    } else {
      throw Exception("Failed to update basic info");
    }
  }
}
