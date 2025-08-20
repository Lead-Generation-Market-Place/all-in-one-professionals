class BusinessInformationEntity {
  final int id;
  final int yearFounded;
  final int? numberOfEmployees;
  final String phoneNumber;
  final String address;
  final String suit;
  final String zipCode;
  final String website;
  final List<String> paymentMethods; // selected methods
  final String facebook;
  final String twitter;
  final String instagram;

  BusinessInformationEntity({
    required this.id,
    required this.yearFounded,
    this.numberOfEmployees,
    required this.phoneNumber,
    required this.address,
    required this.suit,
    required this.zipCode,
    required this.website,
    required this.paymentMethods, // pass subset of availablePaymentMethods
    required this.facebook,
    required this.twitter,
    required this.instagram,
  });
}
