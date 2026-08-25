import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/models/user_model.dart';
import '../datasources/mappers/user_mapper.dart';
import '../../../../core/api/i_api.dart';
import '../../../../core/api/api_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/user_service.dart';
import '../../../../core/preferences/user_preferences.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final StorageService storageService;
  final UserService userService;
  final IApi api;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.storageService,
    required this.userService,
    required this.api,
  });

  @override
  Future<UserEntity> login({
    required String technicianCode,
    required String password,
  }) async {
    final UserModel model = await remoteDataSource.login(
      technicianCode: technicianCode,
      password: password,
    );

    await _handleAuthSuccess(model);
    return UserMapper.toEntity(model);
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {}
    
    userService.clear();
    if (api is ApiService) {
      (api as ApiService).setAuthToken(null);
    }
    
    await UserPreferences.clear();
    await storageService.clearToken();
  }

  @override
  Future<void> changePassword({required String newPassword}) async {
    await remoteDataSource.changePassword(newPassword: newPassword);
    
    // Actualizar estado local: ya no requiere cambio de contraseña
    final currentUser = userService.currentUser;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(mustChangePassword: false);
      userService.setCurrentUser(updatedUser);
      // Persistir el cambio en disco
      await UserPreferences.saveUser(UserMapper.fromEntity(updatedUser));
    }
  }

  @override
  Future<void> forgotPassword({required String technicianCode}) async {
    await remoteDataSource.forgotPassword(technicianCode: technicianCode);
  }

  @override
  Future<String> registerDevice({String? deviceLabel}) async {
    final result = await remoteDataSource.registerDevice(deviceLabel: deviceLabel);
    final deviceToken = result['device_token'] as String;
    await storageService.saveDeviceToken(deviceToken);
    return deviceToken;
  }

  @override
  Future<UserEntity> deviceLogin({required String deviceToken}) async {
    final UserModel model = await remoteDataSource.deviceLogin(deviceToken: deviceToken);
    await _handleAuthSuccess(model);
    return UserMapper.toEntity(model);
  }

  @override
  Future<Map<String, dynamic>> getProfilePhotoUploadUrl({required String filename}) async {
    return await api.getProfilePhotoUploadUrl(filename: filename);
  }

  @override
  Future<UserEntity> completeProfile({
    required String fullName,
    String? email,
    String? jobTitle,
    String? profilePhotoKey,
  }) async {
    final UserModel model = await remoteDataSource.completeProfile(
      fullName: fullName,
      email: email,
      jobTitle: jobTitle,
      profilePhotoKey: profilePhotoKey,
    );

    // Al completar perfil, el backend retorna el usuario con profile_completed: true
    await _handleAuthSuccess(model);
    return UserMapper.toEntity(model);
  }

  Future<void> _handleAuthSuccess(UserModel model) async {
    if (model.accessToken != null) {
      await storageService.saveToken(model.accessToken!);
      if (api is ApiService) {
        (api as ApiService).setAuthToken(model.accessToken!);
      }
    }
    await UserPreferences.saveUser(model);
    final entity = UserMapper.toEntity(model);
    userService.setCurrentUser(entity);
  }
}
