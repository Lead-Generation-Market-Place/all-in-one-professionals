
abstract class SignupRepository {
  Future<void> addUsers(String firstName,String lastName,String email,String password,String confirmPassword);

}
