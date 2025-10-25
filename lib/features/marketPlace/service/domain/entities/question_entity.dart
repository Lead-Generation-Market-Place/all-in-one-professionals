import 'package:flutter/foundation.dart';

class QuestionEntity {
  final String id;
  final String serviceId;
  final String questionName;
  final String formType;
  final List<String> options;
  final dynamic answer;
  final bool required;
  final int order;
  final bool active;

  QuestionEntity({
    required this.id,
    required this.serviceId,
    required this.questionName,
    required this.formType,
    required this.options,
    this.answer,
    required this.required,
    required this.order,
    required this.active,
  });

  factory QuestionEntity.fromJson(Map<String, dynamic> json) {
    return QuestionEntity(
      id: json['_id'] ?? '',
      serviceId: json['service_id'] ?? '',
      questionName: json['question_name'] ?? '',
      formType: json['form_type'] ?? '',
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      answer: json['answer'],
      required: json['required'] ?? false,
      order: json['order'] ?? 0,
      active: json['active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'service_id': serviceId,
      'question_name': questionName,
      'form_type': formType,
      'options': options,
      if (answer != null) 'answer': answer,
      'required': required,
      'order': order,
      'active': active,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QuestionEntity &&
        other.id == id &&
        other.serviceId == serviceId &&
        other.questionName == questionName &&
        other.formType == formType &&
        listEquals(other.options, options) &&
        other.required == required &&
        other.order == order &&
        other.active == active;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      serviceId,
      questionName,
      formType,
      Object.hashAll(options),
      required,
      order,
      active,
    );
  }

  QuestionEntity copyWith({
    String? id,
    String? serviceId,
    String? questionName,
    String? formType,
    List<String>? options,
    dynamic answer,
    bool? required,
    int? order,
    bool? active,
  }) {
    return QuestionEntity(
      id: id ?? this.id,
      serviceId: serviceId ?? this.serviceId,
      questionName: questionName ?? this.questionName,
      formType: formType ?? this.formType,
      options: options ?? this.options,
      answer: answer ?? this.answer,
      required: required ?? this.required,
      order: order ?? this.order,
      active: active ?? this.active,
    );
  }
}
