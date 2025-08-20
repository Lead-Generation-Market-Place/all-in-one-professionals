
import '../../entities/basic_info_entity.dart';
import '../../repositories/basic_info_repository.dart';

class GetBasicInfo {
  final BasicInfoRepository repository;

  GetBasicInfo(this.repository);

  Future<BasicInfoEntity> call(int id) async {
    return await repository.getBasicInfo(id);
  }
}
