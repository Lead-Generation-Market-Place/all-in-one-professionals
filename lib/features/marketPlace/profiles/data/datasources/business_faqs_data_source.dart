

import 'package:yelpax_pro/features/marketPlace/profiles/data/model/business_faqs_model.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

abstract class BusinessFaqsDataSource {
  Future<BusinessFaqsModel> getBusinessFaqs(int id);
  Future<BusinessFaqsModel> saveBusinessFaqs(BusinessFaqsModel model);
}

class BusinessFaqsRemoteDataSourceImpl implements BusinessFaqsDataSource {
  final ApiService apiService;
  BusinessFaqsRemoteDataSourceImpl(this.apiService);
  @override
  Future<BusinessFaqsModel> getBusinessFaqs(int id) async {
    final response = await apiService.get('/buiness-faq/$id');
    if (response.statusCode == 200) {
      return BusinessFaqsModel.fromJson(response.data);
    } else {
      throw Exception('Failed to load business Faqs');
    }
  }

  @override
  Future<BusinessFaqsModel> saveBusinessFaqs(BusinessFaqsModel model) async {
    final response = await apiService.put(
      '/business-faq/${model.id}',
      data: model.toJson(),
    );

    if (response.statusCode == 200) {
      return BusinessFaqsModel.fromJson(response.data);
    } else {
      throw Exception('Failed to update business Faqs.');
    }
  }
}
