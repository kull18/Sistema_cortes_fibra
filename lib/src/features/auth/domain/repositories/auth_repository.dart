import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String technicianCode,
    required String password,
  });

  Future<void> logout();

  Future<void> changePassword({required String newPassword});

  Future<void> forgotPassword({required String technicianCode});

  Future<String> registerDevice({String? deviceLabel});

  Future<UserEntity> deviceLogin({required String deviceToken});

  /// Obtiene una URL prefirmada para subir la foto de perfil.
  Future<Map<String, dynamic>> getProfilePhotoUploadUrl({required String filename});

  /// Completa los datos faltantes del perfil del técnico tras su primer ingreso.
  Future<UserEntity> completeProfile({
    required String fullName,
    String? email,
    String? jobTitle,
    String? profilePhotoKey,
  });
}
