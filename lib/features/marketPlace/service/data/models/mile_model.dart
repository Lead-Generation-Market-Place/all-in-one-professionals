
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';

class MileModel extends MileEntity {
  const MileModel({
    required super.id,
    required super.name,
    required super.miles,
  });

  factory MileModel.fromJson(Map<String, dynamic> json) {
    return MileModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      miles: json['miles'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'miles': miles};
  }

  static List<MileModel> get defaultDistances => [
    const MileModel(id: 1, name: '1 Mile', miles: 1),
    const MileModel(id: 2, name: '5 Miles', miles: 5),
    const MileModel(id: 3, name: '10 Miles', miles: 10),
    const MileModel(id: 4, name: '20 Miles', miles: 20),
    const MileModel(id: 5, name: '50 Miles', miles: 50),
  ];
}
