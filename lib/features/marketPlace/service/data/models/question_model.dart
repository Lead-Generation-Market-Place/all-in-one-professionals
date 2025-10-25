import 'package:flutter/foundation.dart';
import '../../domain/entities/question_entity.dart';

class QuestionModel extends QuestionEntity {
  QuestionModel({
    required super.id,
    required super.serviceId,
    required super.questionName,
    required super.formType,
    required super.options,
    super.answer,
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
      // preserve 'answer' field if backend supplies it
      // it may be string, list, map, etc.
      // pass it through to the base QuestionEntity which now accepts it
      // via the named parameter `answer`.
      // we rely on the super constructor to accept it.

      // Note: constructor uses `required super...` parameters; to pass
      // `answer` we use the map-style in the call below.
      answer: json['answer'],
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
      answer: entity.answer,
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
      if ((this as QuestionEntity).answer != null)
        'answer': (this as QuestionEntity).answer,
      'required': required,
      'order': order,
      'active': active,
    };
  }
}
