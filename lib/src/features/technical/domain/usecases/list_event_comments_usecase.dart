import '../repositories/technical_repository.dart';

class ListEventCommentsUseCase {
  final TechnicalRepository repository;

  ListEventCommentsUseCase(this.repository);

  Future<List<Map<String, dynamic>>> execute(int eventId) {
    return repository.listEventComments(eventId);
  }
}
