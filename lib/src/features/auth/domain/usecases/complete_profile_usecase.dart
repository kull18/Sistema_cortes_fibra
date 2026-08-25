import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class CompleteProfileUseCase {
  final AuthRepository repository;

  CompleteProfileUseCase(this.repository);

  Future<UserEntity> call({
    required String fullName,
    String? email,
    String? jobTitle,
    String? profilePhotoKey,
  }) {
    return repository.completeProfile(
      fullName: fullName,
      email: email,
      jobTitle: jobTitle,
      profilePhotoKey: profilePhotoKey,
    );
  }
}
