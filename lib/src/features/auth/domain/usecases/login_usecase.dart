import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call({
    required String technicianCode,
    required String password,
  }) {
    return repository.login(
      technicianCode: technicianCode,
      password: password,
    );
  }
}
