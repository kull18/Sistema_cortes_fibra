import '../repositories/technical_repository.dart';

class DeleteEventCommentUseCase {
  final TechnicalRepository repository;

  DeleteEventCommentUseCase(this.repository);

  Future<void> execute(int commentId) {
    return repository.deleteEventComment(commentId);
  }
}
