
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/authentication/presentation/service/auth_service.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';
import 'package:yelpax_pro/shared/services/token_repository.dart';

AuthUserController createAuthUserController() {
  final ApiService apiService = ApiService();

  final _tokenRepo = TokenRepository();
  final authService = AuthService(_tokenRepo, apiService);
  return AuthUserController(apiService);
}
