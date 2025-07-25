import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/web.dart';

import 'package:yelpax_pro/features/authentication/domain/usecases/auth_user_usecase.dart';
import 'package:yelpax_pro/features/authentication/presentation/service/auth_service.dart';

class AuthUserController extends ChangeNotifier {
  final AuthUserUsecase authUserUsecase;
  final AuthService authService;

  AuthUserController(this.authUserUsecase, this.authService);

  bool isLoading = false;
  String? errorMessage;
  final authUserId = ValueNotifier<String?>(null);
  final isAuthenticated = ValueNotifier<bool>(false);
  final _storage = FlutterSecureStorage();
  Future<void> login({
    required String email,
    required String password,
    required VoidCallback onSuccess,
    required VoidCallback onFailure,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      Logger().d('Controler is here');
      final user = await authUserUsecase.call(email, password);

      if (user != null) {
        await _storage.write(key: 'isAuthenticated', value: true.toString());
        isAuthenticated.value = true;
        onSuccess();
      } else {
        isAuthenticated.value = false;
        await _storage.delete(key: 'isAuthenticated');
        errorMessage = 'Login failed. Invalid credentials.';
        onFailure();
      }
    } catch (e) {
      errorMessage = 'An error occurred. Please try again.';
      onFailure();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await authService.logout();
    isAuthenticated.value = false;
    await _storage.delete(key: 'isAuthenticated');
    authUserId.value = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    String? authValue = await _storage.read(key: 'isAuthenticated');

    Logger().d(authValue);
    isAuthenticated.value = authValue == true;
    notifyListeners();
  }
}
