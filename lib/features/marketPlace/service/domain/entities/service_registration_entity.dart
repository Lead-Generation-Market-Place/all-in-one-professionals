import 'budget_entity.dart';


import 'service_entity.dart';

class ServiceRegistrationEntity {
  final String? selectedService;
  final ServiceEntity? selectedServiceDetails;

  final Map<String, dynamic>? questionAnswers;

  final BudgetEntity? budget;
  final String professionalId;

  ServiceRegistrationEntity({
    this.selectedService,
    this.selectedServiceDetails,

    this.questionAnswers,

    this.budget,
    required this.professionalId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceRegistrationEntity &&
        other.selectedService == selectedService &&
        other.selectedServiceDetails == selectedServiceDetails &&

        _mapEquals(other.questionAnswers, questionAnswers) &&
      other.budget == budget &&
        other.professionalId == professionalId;
  }

  @override
  int get hashCode {
    return Object.hash(
      selectedService,
      selectedServiceDetails,

      Object.hashAll(questionAnswers?.entries ?? []),

      budget,
      professionalId,
    );
  }

  bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (final key in a.keys) {
      if (!b.containsKey(key) || a[key] != b[key]) return false;
    }
    return true;
  }

  ServiceRegistrationEntity copyWith({
    String? selectedService,
    ServiceEntity? selectedServiceDetails,

    Map<String, dynamic>? questionAnswers,

    BudgetEntity? budget,
    String? professionalId,
  }) {
    return ServiceRegistrationEntity(
      selectedService: selectedService ?? this.selectedService,
      selectedServiceDetails: selectedServiceDetails ?? this.selectedServiceDetails,

      questionAnswers: questionAnswers ?? this.questionAnswers,

      budget: budget ?? this.budget,
      professionalId: professionalId ?? this.professionalId,
    );
  }
}
