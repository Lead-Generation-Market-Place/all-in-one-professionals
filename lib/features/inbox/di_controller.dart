import 'package:yelpax_pro/features/inbox/data/datasources/signup_datasouce.dart';
import 'package:yelpax_pro/features/inbox/data/repositories/signup_repository_impl.dart';
import 'package:yelpax_pro/features/inbox/domain/usecases/signup_usecase.dart';
import 'package:yelpax_pro/features/inbox/presentation/controllers/signup_controller.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

SignupController createController() {
  final ApiService apiService = ApiService();
  final datasource = SignupDatasouce(apiService);
  final repository = SignupRepositoryImp(datasource);
  final signupUsecase = SignupUsecase(repository);
  return SignupController(signupUsecase);
}
