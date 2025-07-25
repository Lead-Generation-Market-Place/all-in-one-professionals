import 'package:yelpax_pro/features/authentication/data/repositoriesImpl/auth_user_repository_impl.dart';
import 'package:yelpax_pro/features/authentication/domain/entities/auth_user_entity.dart';

class AuthUserUsecase {

  final AuthUserRepositoryImpl authUserRepository;
  AuthUserUsecase(this.authUserRepository);

  Future<AuthUserEntity> call(
    String email,
    String password,
 
  ) async {
    return await authUserRepository.login(email, password);
  }
}