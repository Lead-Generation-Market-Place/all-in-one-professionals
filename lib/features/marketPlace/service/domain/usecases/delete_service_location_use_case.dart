import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class DeleteServiceLocationUseCase{
  final ServiceRepository repository;

  DeleteServiceLocationUseCase(this.repository);
  Future<void> call(String? id)async{
    return await repository.deleteServiceLocation(id);
  }
}