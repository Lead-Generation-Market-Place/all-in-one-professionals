import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/basic_info_entity.dart';

class BasicInfoModel extends BasicInfoEntity {
  BasicInfoModel({
    required int id,
    required String businessName,
    required String businessProfileUrl,
  }) : super(
         id: id,
         businessName: businessName,
         businessProfileUrl: businessProfileUrl,
       );

  factory BasicInfoModel.fromEntity(BasicInfoEntity basicInfoEntity) {
    return BasicInfoModel(
      id: basicInfoEntity.id,
      businessName: basicInfoEntity.businessName,
      businessProfileUrl: basicInfoEntity.businessProfileUrl,
    );
  }

  factory BasicInfoModel.fromJson(Map<String, dynamic> json) {
    return BasicInfoModel(
      id: json['id'] ?? '',
      businessName: json['businessName'] ?? '',
      businessProfileUrl: json['businessProfileUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'id': id,
      'businessName': businessName,
      businessProfileUrl: 'businessProfileUrl',
    };

    return data;
  }
}
