import 'package:yelpax_pro/features/authentication/domain/entities/auth_user_entity.dart';

abstract class AuthUserRepository {
  Future<AuthUserEntity> login(String email, String password);
}