import 'package:dio/dio.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';
import 'package:yelpax_pro/shared/services/token_repository.dart';

class AuthService {
  final TokenRepository _tokenRepo;
  final ApiService _apiService;

  AuthService(this._tokenRepo, this._apiService);

  Future<String> getValidAccessToken() async {
    if (await _tokenRepo.hasValidToken()) {
      return (await _tokenRepo.getAccessToken())!;
    }
    return await refreshToken();
  }

  Future<String> refreshToken() async {
  final storedRefreshToken = await _tokenRepo.getRefreshToken();
  if (storedRefreshToken == null) {
    throw Exception('No refresh token available');
  }

  try {
    final tokenResponse = await _apiService.refreshToken(); // ← Now returns a proper object

    await _tokenRepo.persistTokens(
      tokenResponse.accessToken,
      tokenResponse.refreshToken,
      tokenResponse.expiresIn,
    );

    return tokenResponse.accessToken;
  } on DioException catch (e) {
    if (e.response?.statusCode == 401) {
      await _tokenRepo.clearTokens();
    }
    rethrow;
  }
}

  Future<void> logout() async {
    await _tokenRepo.clearTokens();
  }

  Future<bool> isLoggedIn() async {
    return await _tokenRepo.hasValidToken();
  }
}
