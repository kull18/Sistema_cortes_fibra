import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const String _keyToken = 'auth_token';
  static const String _keyDeviceToken = 'device_token';
  static const String _keyTechnicianId = 'saved_technician_id';

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

  // Saved Technician ID (Ficha de Técnico)
  Future<void> saveTechnicianId(String technicianId) async {
    await _storage.write(key: _keyTechnicianId, value: technicianId);
  }

  Future<String?> getTechnicianId() async {
    return await _storage.read(key: _keyTechnicianId);
  }

  Future<void> clearTechnicianId() async {
    await _storage.delete(key: _keyTechnicianId);
  }

  // Alias for compatibility
  Future<void> deleteToken() => clearToken();
}
