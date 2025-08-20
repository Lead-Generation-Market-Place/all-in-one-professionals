
import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/business_faqs_entities.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/business_faqs_repository.dart';

class GetBuinessFaqsUseCase{
  final BusinessFaqsRepository repository;

  GetBuinessFaqsUseCase(this.repository);

  Future<BusinessFaqsEntities> call(int id)async{
    return await repository.getBusinessFaqs(id);
  }
}