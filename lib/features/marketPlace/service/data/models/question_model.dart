import 'package:flutter/foundation.dart';
import '../../domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.id,
    required super.serviceId,
    required super.questionName,
    required super.formType,
    required super.options,
    required super.required,
    required super.order,
    required super.active,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['_id'] ?? '',
      serviceId: json['service_id'] ?? '',
      questionName: json['question_name'] ?? '',
      formType: json['form_type'] ?? 'text',
      options: List<String>.from(json['options'] ?? []),
      required: json['required'] ?? false,
      order: json['order'] ?? 0,
      active: json['active'] ?? true,
    );
  }

  factory QuestionModel.fromEntity(QuestionEntity entity) {
    return QuestionModel(
      id: entity.id,
      serviceId: entity.serviceId,
      questionName: entity.questionName,
      formType: entity.formType,
      options: entity.options,
      required: entity.required,
      order: entity.order,
      active: entity.active,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'service_id': serviceId,
      'question_name': questionName,
      'form_type': formType,
      'options': options,
      'required': required,
      'order': order,
      'active': active,
    };
  }
}
