import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class UpdateServiceUsecase {
  final ServiceRepository repository;

  UpdateServiceUsecase(this.repository);

  Future<Map<String, dynamic>> call(
    String serviceId,
    String professionalId,
  ) async {
    return await repository.updateService(
       professionalId,
      serviceId
      );
  }
}
