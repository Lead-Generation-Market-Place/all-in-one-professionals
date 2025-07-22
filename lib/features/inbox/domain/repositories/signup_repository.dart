import 'package:yelpax_pro/features/inbox/domain/entities/signup_entity.dart';

abstract class SignupRepository {
  Future<void> addUsers(String firstName,String lastName,String email,String password,String confirmPassword);

}
