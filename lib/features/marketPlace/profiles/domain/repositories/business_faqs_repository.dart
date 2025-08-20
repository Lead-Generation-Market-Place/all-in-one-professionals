// domain/repositories/basic_info_repository.dart
import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/business_faqs_entities.dart';

abstract class BusinessFaqsRepository {
  Future<BusinessFaqsEntities> getBusinessFaqs(int id);
  Future<void> updateBusinessFaqs(BusinessFaqsEntities basicInfo);
}
