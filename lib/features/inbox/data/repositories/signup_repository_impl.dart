import 'package:yelpax_pro/features/inbox/data/datasources/signup_datasouce.dart';
import 'package:yelpax_pro/features/inbox/domain/entities/signup_entity.dart';
import 'package:yelpax_pro/features/inbox/domain/repositories/signup_repository.dart';

class SignupRepositoryImp implements SignupRepository {
  final SignupDatasouce signupDatasouce;

  SignupRepositoryImp(this.signupDatasouce);

  @override
  Future<SignupEntity> addUsers(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      return await signupDatasouce.signUp(
        firstName,
        lastName,
        email,
        password,
        confirmPassword,
      );
    } catch (e) {
      throw Exception(e);
    }
  }
}
