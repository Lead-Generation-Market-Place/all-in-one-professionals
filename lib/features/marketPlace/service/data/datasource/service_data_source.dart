import 'package:logger/logger.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/model/service_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/service_entity.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

abstract class ServiceDataSource {
  Future<List<ServiceEntity>> fetchServices();

}

class ServiceRemoteDataSourceImpl implements ServiceDataSource {
  final ApiService apiService;
  ServiceRemoteDataSourceImpl(this.apiService);
  
  @override
  Future<List<ServiceEntity>> fetchServices() async{
  try {
      final response = await apiService.get('/services');
      
      if (response.statusCode == 200) {
        Logger().d(response.data);
        return (response.data['data'] as List)
            .map((json) => Services.fromJson(json))
            .toList();

      } else {
        throw Exception("Failed to get services");
      }
    } catch (e) {
      throw Exception("Failed to get services");
    }
  }
  
}
