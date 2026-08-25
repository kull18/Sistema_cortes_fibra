import 'dart:io';
import '../repositories/technical_repository.dart';

class AttachPhotoUseCase {
  final TechnicalRepository repository;

  AttachPhotoUseCase(this.repository);

  Future<void> execute({
    required File imageFile,
    String? realEventId,
    String? pendingEventLocalId,
    String? label,
  }) {
    return repository.attachPhoto(
      imageFile: imageFile,
      realEventId: realEventId,
      pendingEventLocalId: pendingEventLocalId,
      label: label,
    );
  }
}
