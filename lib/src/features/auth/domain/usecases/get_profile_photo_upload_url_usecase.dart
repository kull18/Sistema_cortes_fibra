import '../repositories/auth_repository.dart';

class GetProfilePhotoUploadUrlUseCase {
  final AuthRepository repository;

  GetProfilePhotoUploadUrlUseCase(this.repository);

  Future<Map<String, dynamic>> call({required String filename}) {
    return repository.getProfilePhotoUploadUrl(filename: filename);
  }
}
