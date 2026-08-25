import '../../../../core/api/i_api.dart';
import 'models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String technicianCode,
    required String password,
  });

  Future<void> logout();

  Future<void> changePassword({required String newPassword});

  Future<void> forgotPassword({required String technicianCode});

  /// Registra el dispositivo actual para permitir acceso biométrico/rápido.
  Future<Map<String, dynamic>> registerDevice({String? deviceLabel});

  /// Inicia sesión usando un token de dispositivo (Biometría).
  Future<UserModel> deviceLogin({required String deviceToken});

  /// Actualiza los datos del perfil del técnico.
  Future<UserModel> completeProfile({
    required String fullName,
    String? email,
    String? jobTitle,
    String? profilePhotoKey,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final IApi api;

  AuthRemoteDataSourceImpl({required this.api});

  @override
  Future<UserModel> login({
    required String technicianCode,
    required String password,
  }) async {
    final response = await api.login(
      technicianCode: technicianCode,
      password: password,
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<void> logout() {
    return api.logout();
  }

  @override
  Future<void> changePassword({required String newPassword}) {
    return api.changePassword(newPassword: newPassword);
  }

  @override
  Future<void> forgotPassword({required String technicianCode}) {
    return api.forgotPassword(technicianCode: technicianCode);
  }

  @override
  Future<Map<String, dynamic>> registerDevice({String? deviceLabel}) async {
    return await api.registerDevice(deviceLabel: deviceLabel);
  }

  @override
  Future<UserModel> deviceLogin({required String deviceToken}) async {
    final response = await api.deviceLogin(deviceToken: deviceToken);
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> completeProfile({
    required String fullName,
    String? email,
    String? jobTitle,
    String? profilePhotoKey,
  }) async {
    final response = await api.completeProfile(
      fullName: fullName,
      email: email,
      jobTitle: jobTitle,
      profilePhotoKey: profilePhotoKey,
    );
    // El endpoint PATCH /users/me/complete-profile retorna el objeto usuario actualizado.
    // UserModel.fromJson espera un Map con 'user' y 'must_change_password'.
    return UserModel.fromJson({
      'user': response, 
      'must_change_password': false,
      'profile_completed': true,
    });
  }
}
