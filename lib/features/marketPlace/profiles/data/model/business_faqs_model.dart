import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/business_faqs_entities.dart';

class BusinessFaqsModel extends BusinessFaqsEntities {
  BusinessFaqsModel({
    required int id,
    required String q1,
    required String q2,
    required String q3,
    required String q4,
    required String q5,
    required String q6,
    required String q7,
    required String q8,
  }) : super(
         id: id,
         q1: q1,
         q2: q2,
         q3: q3,
         q4: q4,
         q5: q5,
         q6: q6,
         q7: q7,
         q8: q8,
       );

  /// ✅ from JSON (API → Model)
  factory BusinessFaqsModel.fromJson(Map<String, dynamic> json) {
    return BusinessFaqsModel(
      id: json['id'] as int,
      q1: json['q1'] ?? '',
      q2: json['q2'] ?? '',
      q3: json['q3'] ?? '',
      q4: json['q4'] ?? '',
      q5: json['q5'] ?? '',
      q6: json['q6'] ?? '',
      q7: json['q7'] ?? '',
      q8: json['q8'] ?? '',
    );
  }

  /// ✅ from Entity (Domain → Model)
  factory BusinessFaqsModel.fromEntity(BusinessFaqsEntities entity) {
    return BusinessFaqsModel(
      id: entity.id,
      q1: entity.q1,
      q2: entity.q2,
      q3: entity.q3,
      q4: entity.q4,
      q5: entity.q5,
      q6: entity.q6,
      q7: entity.q7,
      q8: entity.q8,
    );
  }

  /// ✅ to JSON (Model → API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'q1': q1,
      'q2': q2,
      'q3': q3,
      'q4': q4,
      'q5': q5,
      'q6': q6,
      'q7': q7,
      'q8': q8,
    };
  }
}
