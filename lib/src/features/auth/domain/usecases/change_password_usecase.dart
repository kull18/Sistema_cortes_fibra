import '../repositories/auth_repository.dart';

class ChangePasswordUseCase {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<void> call({required String newPassword}) {
    return repository.changePassword(newPassword: newPassword);
  }
}
