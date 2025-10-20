class ProServiceEntity {
  final double? maximumPrice;
  final double? minimumPrice;
  final String pricingType;
  final bool serviceStatus;
  final String description;
  final int completedTasks;

  const ProServiceEntity({
    this.maximumPrice,
    this.minimumPrice,
    required this.pricingType,
    required this.serviceStatus,
    required this.description,
    required this.completedTasks,
  });
}
