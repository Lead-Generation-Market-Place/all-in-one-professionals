class ProfessionalLicense {
  final int? id;
  final List<String> states;
  final List<String> businessTypes;
  final String licenseNumber;

  ProfessionalLicense({
    this.id,
    required this.states,
    required this.businessTypes,
    required this.licenseNumber,
  });
}
