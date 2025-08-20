import 'package:yelpax_pro/features/marketPlace/profiles/domain/entities/business_information_entity.dart';

class BusinessInformationModel extends BusinessInformationEntity {
  BusinessInformationModel({
    required int id,
    required int yearFounded,
    int? numberOfEmployees,
    required String phoneNumber,
    required String address,
    required String suit,
    required String zipCode,
    required String website,
    required List<String> paymentMethods,
    required String facebook,
    required String twitter,
    required String instagram,
  }) : super(
         id: id,
         yearFounded: yearFounded,
         numberOfEmployees: numberOfEmployees,
         phoneNumber: phoneNumber,
         address: address,
         suit: suit,
         zipCode: zipCode,
         website: website,
         paymentMethods: paymentMethods,
         facebook: facebook,
         twitter: twitter,
         instagram: instagram,
       );

  /// Create a Model from JSON
  factory BusinessInformationModel.fromJson(Map<String, dynamic> json) {
    return BusinessInformationModel(
      id: json['id'],
      yearFounded: json['yearFounded'],
      numberOfEmployees: json['numberOfEmployees'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      suit: json['suit'],
      zipCode: json['zipCode'],
      website: json['website'],
      paymentMethods: List<String>.from(json['paymentMethods'] ?? []),
      facebook: json['facebook'],
      twitter: json['twitter'],
      instagram: json['instagram'],
    );
  }

  /// Convert Model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'yearFounded': yearFounded,
      'numberOfEmployees': numberOfEmployees,
      'phoneNumber': phoneNumber,
      'address': address,
      'suit': suit,
      'zipCode': zipCode,
      'website': website,
      'paymentMethods': paymentMethods,
      'facebook': facebook,
      'twitter': twitter,
      'instagram': instagram,
    };
  }

  /// Create a Model from an Entity
  factory BusinessInformationModel.fromEntity(
    BusinessInformationEntity entity,
  ) {
    return BusinessInformationModel(
      id: entity.id,
      yearFounded: entity.yearFounded,
      numberOfEmployees: entity.numberOfEmployees,
      phoneNumber: entity.phoneNumber,
      address: entity.address,
      suit: entity.suit,
      zipCode: entity.zipCode,
      website: entity.website,
      paymentMethods: entity.paymentMethods,
      facebook: entity.facebook,
      twitter: entity.twitter,
      instagram: entity.instagram,
    );
  }
}
