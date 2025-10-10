import 'package:yelpax_pro/features/marketPlace/service/domain/entities/location_data_entity.dart';

import '../repositories/service_repository.dart';

class AddLocationUseCase {
  final ServiceRepository repository;

  AddLocationUseCase(this.repository);

  Future<String> call(LocationDataEntity locationDataEntity) async {
    return await repository.addLocation(locationDataEntity);
  }
}
