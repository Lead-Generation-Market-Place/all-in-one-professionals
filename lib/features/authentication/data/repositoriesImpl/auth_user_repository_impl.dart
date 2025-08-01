import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:yelpax_pro/features/authentication/data/datasources/auth_user_datasource.dart';
import 'package:yelpax_pro/features/authentication/data/model/auth_user_model.dart';
import 'package:yelpax_pro/features/authentication/domain/repositories/auth_user_repository.dart';

class AuthUserRepositoryImpl implements AuthUserRepository {
  final AuthUserDatasource authUserDatasource;

  AuthUserRepositoryImpl(this.authUserDatasource);

  @override
  Future<AuthUserModel> login(String email, String password) async {
    try {
      final response = await authUserDatasource.loginUser(email, password);
      return response;
    } on DioException catch (e) {
      Logger().e('Dio error during login', error: e);
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Server is not responding. Please try again later.');
      }
      rethrow;
    } catch (e) {
      Logger().e('Unexpected error during login', error: e);
      throw Exception('Login failed. Please try again.');
    }
  }
}
