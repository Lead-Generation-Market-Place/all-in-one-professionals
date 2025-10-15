import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/minute_entity.dart';

class MinuteModel extends MinuteEntity {
  const MinuteModel({required super.id, required super.minute});

  factory MinuteModel.fromJson(Map<String, dynamic> json) {
    return MinuteModel(id: json['_id'] ?? '', minute: json['minute'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'minute': minute};
  }
}
