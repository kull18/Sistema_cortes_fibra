import '../repositories/technical_repository.dart';

class CreateEventPhotoUseCase {
  final TechnicalRepository repository;

  CreateEventPhotoUseCase(this.repository);

  Future<void> execute({
    required int eventId,
    required String objectKey,
    String? label,
    int? sizeBytes,
  }) {
    return repository.createEventPhoto(
      eventId: eventId,
      objectKey: objectKey,
      label: label,
      sizeBytes: sizeBytes,
    );
  }
}
