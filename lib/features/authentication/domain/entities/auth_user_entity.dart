class AuthUserEntity {
  final String email;
  final String password;
  final String? accessToken;
  final String? refreshToken;

  AuthUserEntity({
    required this.email,
    required this.password,
    this.accessToken,
    this.refreshToken,
  });
}