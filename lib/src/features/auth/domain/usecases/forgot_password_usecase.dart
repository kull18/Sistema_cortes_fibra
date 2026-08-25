import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> call({required String technicianCode}) {
    return repository.forgotPassword(technicianCode: technicianCode);
  }
}
