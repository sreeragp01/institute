import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _accessKey = 'jwt_access_token';
  static const _refreshKey = 'jwt_refresh_token';
  static const _roleKey = 'user_role';

  static Future<void> saveTokens({required String accessToken, required String refreshToken, String? role}) async {
    await _storage.write(key: _accessKey, value: accessToken);
    await _storage.write(key: _refreshKey, value: refreshToken);
    if (role != null) {
      await _storage.write(key: _roleKey, value: role);
    }
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessKey);
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshKey);
  }

  static Future<String?> getUserRole() async {
    return await _storage.read(key: _roleKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
