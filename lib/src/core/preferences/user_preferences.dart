import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/auth/data/datasources/models/user_model.dart';

class UserPreferences {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  static const String _keyUser = 'current_user_data';

  /// Guarda el objeto usuario completo (Model) en formato JSON
  static Future<void> saveUser(UserModel user) async {
    final String userJson = jsonEncode(user.toJson());
    await _storage.write(key: _keyUser, value: userJson);
  }

  /// Recupera el usuario persistido
  static Future<UserModel?> getUser() async {
    final String? userJson = await _storage.read(key: _keyUser);
    if (userJson == null || userJson.isEmpty) return null;

    try {
      return UserModel.fromJson(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }

  /// Elimina los datos del usuario (Logout)
  static Future<void> clear() async {
    await _storage.delete(key: _keyUser);
  }

  /// Verifica si hay una sesión activa
  static Future<bool> get hasUser async {
    return await _storage.containsKey(key: _keyUser);
  }
}
