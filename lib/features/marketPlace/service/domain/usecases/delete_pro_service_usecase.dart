import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class DeleteProServiceUsecase {
  final ServiceRepository repository;
  DeleteProServiceUsecase(this.repository);


  Future<void> call(String proServiceId) async {
    return await repository.deleteProService(proServiceId);
  }
}