import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class GetAllServices {
  final ServiceRepository repository;

  GetAllServices(this.repository);

  Future<List<ServiceEntity>> call() async {
    return await repository.getAllServices();
  }
}
