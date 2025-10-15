import 'package:yelpax_pro/features/marketPlace/service/domain/entities/vehicle_type_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class GetAllVehicleTypeUseCase {
  final ServiceRepository repository;
  GetAllVehicleTypeUseCase(this.repository);

  Future<List<VehicleTypeEntity>> call() async {
    return await repository.getAllVehicleTypes();
  }
}
