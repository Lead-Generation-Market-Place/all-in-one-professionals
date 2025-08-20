// data/repositories/basic_info_repository_impl.dart
import '../../domain/entities/basic_info_entity.dart';
import '../../domain/repositories/basic_info_repository.dart';

import '../datasources/basic_info_data_source.dart';
import '../model/basic_info_model.dart';

class BasicInfoRepositoryImpl implements BasicInfoRepository {
  final BasicInfoRemoteDataSource remoteDataSource;

  BasicInfoRepositoryImpl(this.remoteDataSource);

  @override
  Future<BasicInfoEntity> getBasicInfo(int id) async {
    final model = await remoteDataSource.getBasicInfo(id);
    return model; // model extends entity
  }

  @override
  Future<void> updateBasicInfo(BasicInfoEntity basicInfo) async {
    final model = BasicInfoModel.fromEntity(basicInfo);
    await remoteDataSource.saveBasicInfo(model);
  }
}
