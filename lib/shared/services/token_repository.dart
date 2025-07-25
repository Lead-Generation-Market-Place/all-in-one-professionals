import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yelpax_pro/shared/services/api_service.dart';

class TokenRepository {
  final _storage = const FlutterSecureStorage();
  final _accessTokenKey = 'access_token';
  final _refreshTokenKey = 'refresh_token';
  final _tokenExpiryKey = 'token_expiry';

  Future<void> persistTokens(String accessToken, String refreshToken, int expiresIn) async {
    final expiryTime = DateTime.now().add(Duration(seconds: expiresIn)).millisecondsSinceEpoch;
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
      _storage.write(key: _tokenExpiryKey, value: expiryTime.toString()),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(key: _refreshTokenKey);
  
  Future<bool> hasValidToken() async {
    final expiry = await _storage.read(key: _tokenExpiryKey);
    if (expiry == null) return false;
    return DateTime.now().millisecondsSinceEpoch < int.parse(expiry);
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }
}

