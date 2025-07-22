import 'package:yelpax_pro/features/inbox/data/models/signup_model.dart';
import 'package:yelpax_pro/features/inbox/data/repositories/signup_repository_impl.dart';
import 'package:yelpax_pro/features/inbox/domain/entities/signup_entity.dart';
import 'package:yelpax_pro/features/inbox/domain/repositories/signup_repository.dart';

class SignupUsecase {
  final SignupRepositoryImp signupRepository;

  SignupUsecase(this.signupRepository);

  Future<SignupEntity> call(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
  return await signupRepository.addUsers(
      firstName,
      lastName,
      email,
      password,
      confirmPassword,
    );
  }
}
