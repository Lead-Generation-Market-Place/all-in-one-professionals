import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class UpdateServiceUsecase {
  final ServiceRepository repository;

  UpdateServiceUsecase(this.repository);

  Future<Map<String, dynamic>> call(
    String proServiceId,
    String serviceId,
  ) async {
    return await repository.updateService(proServiceId, serviceId);
  }
}
