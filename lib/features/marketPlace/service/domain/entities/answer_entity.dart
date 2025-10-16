// features/answers/domain/entities/answer_entity.dart
class AnswerEntity {
  final String? id;
  final String questionId;
  final String? leadId;
  final String? professionalId;
  final String? userId;
  final dynamic answers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AnswerEntity({
    this.id,
    required this.questionId,
    this.leadId,
    required this.professionalId, // Made required
    required this.userId, // Made required
    required this.answers,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'question_id': questionId,
      if (leadId != null) 'lead_id': leadId,
      'professional_id': professionalId, // Always include
      'user_id': userId, // Always include
      'answers': answers,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  factory AnswerEntity.fromJson(Map<String, dynamic> json) {
    return AnswerEntity(
      id: json['_id'] ?? json['id'],
      questionId: json['question_id'] ?? '',
      leadId: json['lead_id'],
      professionalId: json['professional_id'] ?? '',
      userId: json['user_id'] ?? '',
      answers: json['answers'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }
}
