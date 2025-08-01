class TokenEntity {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  TokenEntity({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });
}
