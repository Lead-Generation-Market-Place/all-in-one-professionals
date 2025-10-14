import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class UpdateLocationUseCase {
  final ServiceRepository serviceRepository;

  UpdateLocationUseCase(this.serviceRepository);

  Future<String> call(LocationDataEntity locationDataEntity) async {
    return await serviceRepository.updateLocation(locationDataEntity);
  }
}
