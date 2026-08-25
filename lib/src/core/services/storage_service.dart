import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const String _keyToken = 'auth_token';
  static const String _keyDeviceToken = 'device_token';

  // Session Token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _keyToken);
  }

  // Device Token (Biometrics/Quick Login)
  Future<void> saveDeviceToken(String token) async {
    await _storage.write(key: _keyDeviceToken, value: token);
  }

  Future<String?> getDeviceToken() async {
    return await _storage.read(key: _keyDeviceToken);
  }

  Future<void> clearDeviceToken() async {
    await _storage.delete(key: _keyDeviceToken);
  }

  // Alias for compatibility
  Future<void> deleteToken() => clearToken();
}
