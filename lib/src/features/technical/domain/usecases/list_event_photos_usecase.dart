import '../repositories/technical_repository.dart';

class ListEventPhotosUseCase {
  final TechnicalRepository repository;

  ListEventPhotosUseCase(this.repository);

  Future<List<Map<String, dynamic>>> execute(int eventId) {
    return repository.listEventPhotos(eventId);
  }
}
