class ServiceQuestion {
  final int formId;
  final int serviceId;
  final int step;
  final String formType;
  final String question;
  final List<String> options;
  final String formGroup;

  ServiceQuestion({
    required this.formId,
    required this.serviceId,
    required this.step,
    required this.formType,
    required this.question,
    required this.options,
    required this.formGroup,
  });

  factory ServiceQuestion.fromMap(Map<String, dynamic> map) {
    return ServiceQuestion(
      formId: map['form_id'],
      serviceId: map['service_id'],
      step: map['step'],
      formType: map['form_type'],
      question: map['question'],
      options: List<String>.from(map['options']),
      formGroup: map['form_group'],
    );
  }
}