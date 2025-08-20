// domain/repositories/basic_info_repository.dart
import '../entities/basic_info_entity.dart';

abstract class BasicInfoRepository {
  Future<BasicInfoEntity> getBasicInfo(int id);
  Future<void> updateBasicInfo(BasicInfoEntity basicInfo);
}
