import '../repositories/technical_repository.dart';

class GetEventPhotoUploadUrlUseCase {
  final TechnicalRepository repository;

  GetEventPhotoUploadUrlUseCase(this.repository);

  Future<Map<String, dynamic>> execute({
    required int eventId,
    required String filename,
    required String contentHash,
  }) {
    return repository.getEventPhotoUploadUrl(
      eventId: eventId,
      filename: filename,
      contentHash: contentHash,
    );
  }
}
