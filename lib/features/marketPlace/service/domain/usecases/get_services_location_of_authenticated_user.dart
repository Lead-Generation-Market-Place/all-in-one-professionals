import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class GetServicesLocationOfAuthenticatedUser {
  final ServiceRepository repository;
  GetServicesLocationOfAuthenticatedUser(this.repository);

  Future<List<LocationDataEntity>> call(String professionalId,String serviceId) async {
    return await repository.getServiceLocationsOfAuthenticatedUser(
      professionalId,
      serviceId
    );
  }
}
