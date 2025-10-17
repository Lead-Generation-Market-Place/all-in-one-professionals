// features/answers/data/models/answer_model.dart
import 'package:yelpax_pro/features/marketPlace/service/domain/entities/answer_entity.dart';

class AnswerModel extends AnswerEntity {
  AnswerModel({
    super.id,
    required super.questionId,
    super.leadId,
    super.professionalId,
    super.userId,
    super.serviceId,
    required super.answers,
    super.createdAt,
    super.updatedAt,
  });

  // Convert model to JSON for API
  Map<String, dynamic> toApiJson() {
    return {
      'question_id': questionId,
      if (leadId != null) 'lead_id': leadId,
      if (professionalId != null) 'professional_id': professionalId,
      if (userId != null) 'user_id': userId,
      'answers': answers,
    };
  }

  // Create model from JSON
  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['_id'] ?? json['id'],
      questionId: json['question_id'] ?? '',
      leadId: json['lead_id'],
      professionalId: json['professional_id'],
      userId: json['user_id'],
      serviceId: json['service_id'],
      answers: json['answers'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  // Convert entity to model
  factory AnswerModel.fromEntity(AnswerEntity entity) {
    return AnswerModel(
      id: entity.id,
      questionId: entity.questionId,
      leadId: entity.leadId,
      professionalId: entity.professionalId,
      userId: entity.userId,
      serviceId: entity.serviceId,
      answers: entity.answers,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
