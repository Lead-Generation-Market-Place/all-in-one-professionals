

import 'package:yelpax_pro/features/marketPlace/service/domain/entities/mile_entity.dart';

class MileModel extends MileEntity {
  const MileModel({required super.id, required super.mile});

  factory MileModel.fromJson(Map<String, dynamic> json) {
    return MileModel(id: json['_id'] ?? '', mile: json['mile'] ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'mile': mile};
  }


}
