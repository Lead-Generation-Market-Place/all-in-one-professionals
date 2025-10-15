import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class GetAllMinuteUseCase {
  final ServiceRepository repository;
  GetAllMinuteUseCase(this.repository);

  Future<List<MinuteEntity>> call() async {
    return await repository.getAllMinutes();
  }
}
