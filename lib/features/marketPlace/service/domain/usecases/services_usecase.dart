import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/service_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class ServicesUsecase {
  final ServiceRepository repository;
  ServicesUsecase(this.repository);

  Future<List<ServiceEntity>> call(Map<String, dynamic> serviceData) async {
    return await repository.fetchServices();
  }
}