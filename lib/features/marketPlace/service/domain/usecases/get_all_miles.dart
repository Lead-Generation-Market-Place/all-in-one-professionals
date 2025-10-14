import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/screens/service_location_screens/travel_time.dart';

class GetAllMilesUseCase {
  final ServiceRepository repository;
  GetAllMilesUseCase(this.repository);

  Future<List<MileEntity>> call() async {
    return await repository.getAllMiles();
  }
}
