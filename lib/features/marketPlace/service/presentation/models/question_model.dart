// features/marketPlace/service/data/model/question_model.dart
import 'package:flutter/foundation.dart';

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

  QuestionModel({
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
      id: json['_id'] ?? '',
      serviceId: json['service_id'] ?? '',
      questionName: json['question_name'] ?? '',
      formType: json['form_type'] ?? 'text',
      options: List<String>.from(json['options'] ?? []),
      required: json['required'] ?? false,
      order: json['order'] ?? 0,
      active: json['active'] ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
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
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Convert to entity
  QuestionEntity toEntity() {
    return QuestionEntity(
      id: id,
      serviceId: serviceId,
      questionName: questionName,
      formType: formType,
      options: options,
      required: required,
      order: order,
      active: active,
    );
  }
}
// features/marketPlace/service/domain/entities/question_entity.dart
class QuestionEntity {
  final String id;
  final String serviceId;
  final String questionName;
  final String formType;
  final List<String> options;
  final bool required;
  final int order;
  final bool active;

  QuestionEntity({
    required this.id,
    required this.serviceId,
    required this.questionName,
    required this.formType,
    required this.options,
    required this.required,
    required this.order,
    required this.active,
  });

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
      required: required ?? this.required,
      order: order ?? this.order,
      active: active ?? this.active,
    );
  }
}
