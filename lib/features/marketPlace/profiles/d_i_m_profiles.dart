import 'package:http/http.dart' as http;
import 'package:yelpax_pro/features/marketPlace/profiles/data/datasources/basic_info_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/data/datasources/business_information_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/data/repositoriesImpl/basic_info_repository_impl.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/data/repositoriesImpl/business_information_repository_impl.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/business_information_repository.dart';

import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/basic_info/get_basic_info_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/basic_info/update_basic_info_use_case.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/business_information/update_business_information_use_case.dart';

import 'package:yelpax_pro/features/marketPlace/profiles/domain/usecases/professional_license/get_business_information_use_case.dart';

import 'package:yelpax_pro/features/marketPlace/profiles/presentation/controllers/profile_provider.dart';


ProfileProvider createProfileProvider() {
  final client = http.Client();

  // repositories
  final basicInfoRepository = BasicInfoRepositoryImpl(client as BasicInfoRemoteDataSource);
  final businessInfoRepository = BusinessInformationImpl(client as BusinessInformationDataSource);

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
