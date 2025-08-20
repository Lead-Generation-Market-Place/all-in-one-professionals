
import '../../entities/basic_info_entity.dart';
import '../../repositories/basic_info_repository.dart';

class UpdateBasicInfo {
  final BasicInfoRepository repository;

  UpdateBasicInfo(this.repository);

  Future<void> call(BasicInfoEntity basicInfo) async {
    await repository.updateBasicInfo(basicInfo);
  }
}
