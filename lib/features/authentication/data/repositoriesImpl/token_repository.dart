abstract class TokenRepository {
  Future<void> persistTokens(
    String accessToken,
    String refreshToken,
    int expiresIn,
  );
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<bool> hasValidToken();
  Future<void> clearTokens();
}
