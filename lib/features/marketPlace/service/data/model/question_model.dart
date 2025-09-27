// lib/features/marketPlace/service/data/models/question_model.dart

import 'package:yelpax_pro/features/marketPlace/service/domain/entitiies/question_entity.dart';

class QuestionModel {
  final String id;
  final String serviceId;
  final String questionName;
  final String formType;
  final List<String> options;
  final bool required;
  final int order;
  final bool active;
  final DateTime createdAt;
  final DateTime updatedAt;

  const QuestionModel({
    required this.id,
    required this.serviceId,
    required this.questionName,
    required this.formType,
    required this.options,
    required this.required,
    required this.order,
    required this.active,
    required this.createdAt,
    required this.updatedAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id']?.toString() ?? '',
      serviceId: json['service_id']?.toString() ?? '',
      questionName: json['question_name']?.toString() ?? '',
      formType: json['form_type']?.toString() ?? '',
      options: List<String>.from(json['options'] ?? []),
      required: json['required'] ?? false,
      order: (json['order'] as num?)?.toInt() ?? 0,
      active: json['active'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt']?.toString() ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt']?.toString() ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  QuestionEntity toEntity() {
    return QuestionEntity(
      id: id,
      serviceId: serviceId,
      questionName: questionName,
      formType: formType,
      options: List.from(options),
      required: required,
      order: order,
      active: active,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
