
import '../entities/business_information_entity.dart';

abstract class BusinessInformationRepository{
  Future<BusinessInformationEntity> getBusinessInfo(int id);
  Future<void> updateBusinessInfo(BusinessInformationEntity businessInfo);
}