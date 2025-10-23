import 'package:yelpax_pro/features/marketPlace/service/domain/repositories/service_repository.dart';

class UpdatePricingUsecase {
  final ServiceRepository repository;

  UpdatePricingUsecase(this.repository);

  Future<void> call({
    required String professionalId,
    required String serviceId,
    required double maxPrice,
    required double minPrice,
    required String description,
    required String pricingType,
    required int completedTasks,
  }) {
    return repository.updatePricing(
      professionalId: professionalId,
      serviceId: serviceId,
      maxPrice: maxPrice,
      minPrice: minPrice,
      description: description,
      pricingType: pricingType,
      completedTasks: completedTasks,
    );
  }
}
