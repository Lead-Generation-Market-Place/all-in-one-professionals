class AnswerEntity {
  final String? id;
  final String questionId;
  final String? leadId;
  final String? professionalId;
  final String? userId;
  final String? serviceId;
  final List<String>? serviceLocationIds; // new field
  final dynamic answers;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AnswerEntity({
    this.id,
    required this.questionId,
    this.leadId,
    required this.professionalId,
    required this.userId,
    this.serviceId,
    this.serviceLocationIds,
    required this.answers,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      if (id != null) '_id': id,
      'question_id': questionId,
      if (leadId != null) 'lead_id': leadId,
      'professional_id': professionalId,
      'user_id': userId,
      'service_id': serviceId,
      'answers': answers,
    };
    if (serviceLocationIds != null) {
      map['service_location_ids'] = serviceLocationIds;
    }
    if (createdAt != null) {
      map['createdAt'] = createdAt!.toIso8601String();
    }
    if (updatedAt != null) {
      map['updatedAt'] = updatedAt!.toIso8601String();
    }
    return map;
  }

  factory AnswerEntity.fromJson(Map<String, dynamic> json) {
    return AnswerEntity(
      id: json['_id'] ?? json['id'],
      questionId: json['question_id'] ?? '',
      leadId: json['lead_id'],
      professionalId: json['professional_id'] ?? '',
      userId: json['user_id'] ?? '',
      serviceId: json['service_id'] ?? '',
      serviceLocationIds: json['service_location_ids'] is List
          ? List<String>.from(json['service_location_ids'])
          : null,
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
