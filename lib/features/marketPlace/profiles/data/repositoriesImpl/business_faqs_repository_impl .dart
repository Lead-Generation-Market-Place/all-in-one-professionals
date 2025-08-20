// data/repositories/basic_info_repository_impl.dart
import 'package:yelpax_pro/features/marketPlace/profiles/data/datasources/business_faqs_data_source.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/data/model/business_faqs_model.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/business_faqs_entities.dart';
import 'package:yelpax_pro/features/marketPlace/profiles/domain/repositories/business_faqs_repository.dart';

class BusinessFaqsRepositoryImpl implements BusinessFaqsRepository {
  final BusinessFaqsRemoteDataSourceImpl remoteDataSource;

  BusinessFaqsRepositoryImpl(this.remoteDataSource);

  @override
  Future<BusinessFaqsEntities> getBusinessFaqs(int id) async {
    final model = await remoteDataSource.getBusinessFaqs(id);
    return model;
  }

  @override
  Future<void> updateBusinessFaqs(BusinessFaqsEntities businessFaqs) async {
    final model = BusinessFaqsModel.fromEntity(businessFaqs);
    await remoteDataSource.saveBusinessFaqs(model);
  }
}
