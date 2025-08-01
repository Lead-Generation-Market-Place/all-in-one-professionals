import 'package:logger/logger.dart';
import 'package:yelpax_pro/features/inbox/data/models/signup_model.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

class SignupDatasouce {
  final ApiService apiService;
  SignupDatasouce(this.apiService);

  Future<SignupModel> signUp(
    String firstName,
    String lastName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final response = await apiService.post(
      '/signup',
      data: {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
      },
    );
    Logger().d(response);
    return SignupModel.fromJson(response.data);
  }
}
