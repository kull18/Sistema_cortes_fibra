import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class DeviceLoginUseCase {
  final AuthRepository repository;

  DeviceLoginUseCase(this.repository);

  Future<UserEntity> call({required String deviceToken}) {
    return repository.deviceLogin(deviceToken: deviceToken);
  }
}