import '../repositories/technical_repository.dart';

class CreateEventCommentUseCase {
  final TechnicalRepository repository;

  CreateEventCommentUseCase(this.repository);

  Future<Map<String, dynamic>> execute(int eventId, String content) {
    return repository.createEventComment(eventId, content);
  }
}
