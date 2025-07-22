import 'package:yelpax_pro/features/inbox/domain/entities/signup_entity.dart';

class SignupModel extends SignupEntity {
  SignupModel({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String confirmPassword,
  }) : super(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
        );

  /// Factory to convert Entity -> Model
  factory SignupModel.fromEntity(SignupEntity entity) {
    return SignupModel(
      firstName: entity.firstName,
      lastName: entity.lastName,
      email: entity.email,
      password: entity.password,
      confirmPassword: entity.confirmPassword,
    );
  }

  /// Factory to convert JSON -> Model
  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
    );
  }

  /// Method to convert Model -> JSON
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
