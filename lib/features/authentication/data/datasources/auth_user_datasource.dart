import 'package:yelpax_pro/features/authentication/data/model/auth_user_model.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

class AuthUserDatasource {
  final ApiService apiService;

  AuthUserDatasource(this.apiService);

  Future<AuthUserModel> loginUser(String email, String password) async {
    final response = await apiService.post(
      '/login/',
      data: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      return AuthUserModel.fromJson(response.data);
    } else {
      throw Exception('Login failed: ${response.data['error']}');
    }
  }
}
