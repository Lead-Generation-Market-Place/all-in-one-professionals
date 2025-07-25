import 'package:yelpax_pro/features/authentication/domain/entities/auth_user_entity.dart';

class AuthUserModel extends AuthUserEntity {
  AuthUserModel({required String email, required String password})
    : super(email: email, password: password);

  factory AuthUserModel.fromEntity(AuthUserEntity entity) {
    return AuthUserModel(email: entity.email, password: entity.password);
  }

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = {'email': email, 'password': password};

    return data;
  }
}
