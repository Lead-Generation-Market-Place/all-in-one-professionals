import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class AddServiceUsecase {
  final ServiceRepository repository;

  AddServiceUsecase(this.repository);

  Future<Map<String,dynamic>> call(String serviceId, String professionalId) async {
    return await repository.addService(serviceId, professionalId);
  }
}
