// lib/features/marketPlace/service/domain/entities/question_entity.dart

class QuestionEntity {
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

  const QuestionEntity({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! QuestionEntity) return false;

    return id == other.id &&
        serviceId == other.serviceId &&
        questionName == other.questionName &&
        formType == other.formType &&
        _listEquals(options, other.options) &&
        required == other.required &&
        order == other.order &&
        active == other.active &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        serviceId.hashCode ^
        questionName.hashCode ^
        formType.hashCode ^
        options.hashCode ^
        required.hashCode ^
        order.hashCode ^
        active.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  bool _listEquals(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }
    return true;
  }

  @override
  String toString() {
    return 'QuestionEntity(id: $id, serviceId: $serviceId, questionName: $questionName, formType: $formType, options: $options, required: $required, order: $order, active: $active, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
