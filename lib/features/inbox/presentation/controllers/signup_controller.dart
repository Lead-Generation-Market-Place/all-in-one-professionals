import 'package:flutter/material.dart';
import 'package:yelpax_pro/features/inbox/domain/usecases/signup_usecase.dart';

class SignupController extends ChangeNotifier {
  final SignupUsecase signupUsecase;
  SignupController(this.signupUsecase);
  bool isLoading = false;

  Future<void> addUser(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      isLoading = true;
      final user = await signupUsecase.call(
        firstName,
        lastName,
        email,
        password,
        confirmPassword,
      );
    } catch (e) {
      print('$e');
    } finally {
      isLoading = false;
    }
  }
}
