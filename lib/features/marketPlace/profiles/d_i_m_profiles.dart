import 'package:yelpax_pro/shared/services/api_service.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/data/datasources/basic_info_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/data/datasources/business_information_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/data/repositoriesImpl/basic_info_repository_impl.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/data/repositoriesImpl/business_information_repository_impl.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/basic_info/get_basic_info_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/basic_info/update_basic_info_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/business_information/update_business_information_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/professional_license/get_business_information_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';

ProfileProvider createProfileProvider() {
  // services
  final apiService = ApiService();

  // data sources
  final basicInfoRemoteDataSource = BasicInfoRemoteDataSourceImpl(apiService);
  final businessInformationDataSource = BusinessInformationDataSourceImpl(
    apiService,
  );

  // repositories
  final basicInfoRepository = BasicInfoRepositoryImpl(
    basicInfoRemoteDataSource,
  );
  final businessInfoRepository = BusinessInformationImpl(
    businessInformationDataSource,
  );

  // use cases
  final getBasicInfo = GetBasicInfo(basicInfoRepository);
  final updateBasicInfo = UpdateBasicInfo(basicInfoRepository);
  final getBusinessInfo = GetBusinessInfo(businessInfoRepository);
  final updateBusinessInformation = UpdateBusinessInformation(
    businessInfoRepository,
  );

  // provider
  return ProfileProvider(
    getBasicInfo,
    updateBasicInfo,
    getBusinessInfo,
    updateBusinessInformation,
  );
}
