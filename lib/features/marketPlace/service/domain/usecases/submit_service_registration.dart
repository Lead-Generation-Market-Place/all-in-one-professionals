import '../entities/service_registration_entity.dart';
import '../repositories/service_repository.dart';

class SubmitServiceRegistration {
  final ServiceRepository repository;

  SubmitServiceRegistration(this.repository);

  Future<bool> call(ServiceRegistrationEntity registration) async {
    return await repository.submitServiceRegistration(registration);
  }
}
