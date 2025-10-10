import 'package:flutter/foundation.dart';

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
