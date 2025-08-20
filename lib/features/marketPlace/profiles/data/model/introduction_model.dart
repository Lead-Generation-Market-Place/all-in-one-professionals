import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/your_introduction_entity.dart';

class IntroductionModel extends YourIntroductionEntity {
  IntroductionModel({required int id, required String introduction})
    : super(id: id, introduction: introduction);

  factory IntroductionModel.fromJson(Map<String, dynamic> json) {
    return IntroductionModel(
      id: json['id'],
      introduction: json['introduction'],
    );
  }

  factory IntroductionModel.fromEntity(YourIntroductionEntity entity) {
    return IntroductionModel(id: entity.id, introduction: entity.introduction);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'introduction': introduction};
  }
}
