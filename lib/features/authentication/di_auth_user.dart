import 'package:yelpax_pro/features/authentication/data/datasources/auth_user_datasource.dart';
import 'package:yelpax_pro/features/authentication/data/repositoriesImpl/auth_user_repository_impl.dart';
import 'package:yelpax_pro/features/authentication/domain/usecases/auth_user_usecase.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/authentication/presentation/service/auth_service.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';
import 'package:yelpax_pro/shared/services/token_repository.dart';

AuthUserController createAuthUserController() {
  final ApiService apiService = ApiService();
  final dataSource = AuthUserDatasource(apiService);

  final repository = AuthUserRepositoryImpl(dataSource);
  final usecase = AuthUserUsecase(repository);
  final _tokenRepo = TokenRepository();
  final authService = AuthService(_tokenRepo, apiService);
  return AuthUserController(usecase, authService);
}
