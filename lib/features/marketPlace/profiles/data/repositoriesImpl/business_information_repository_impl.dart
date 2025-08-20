// data/repositories/basic_info_repository_impl.dart
import 'package:yelpax_pro/features/marketPlace/profiles/data/datasources/business_information_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/data/model/business_information_model.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/business_information_entity.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/business_information_repository.dart';



class BusinessInformationImpl implements BusinessInformationRepository{
  final BusinessInformationDataSource remoteDataSource;

  BusinessInformationImpl(this.remoteDataSource);

  @override
  Future<BusinessInformationEntity> getBusinessInfo(int id)async {
    final model = await  remoteDataSource.getBusinessInformation(id);
    return model;
  }

  @override
  Future<void> updateBusinessInfo(BusinessInformationEntity businessInfo)async {
    final model = BusinessInformationModel.fromEntity(businessInfo);
    await remoteDataSource.saveBusinessInformation(model);
  }



}