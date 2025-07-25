import 'package:yelpax_pro/features/authentication/domain/entities/auth_user_entity.dart';
import 'package:yelpax_pro/features/authentication/domain/repositories/auth_user_repository.dart';

class LoginUsecase {
  final AuthUserRepository repository;

  LoginUsecase(this.repository);

  Future<AuthUserEntity> execute(String email, String password) async {
    return await repository.login(email, password);
  }
}