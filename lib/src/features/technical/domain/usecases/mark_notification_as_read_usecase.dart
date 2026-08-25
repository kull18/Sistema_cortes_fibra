import '../repositories/technical_repository.dart';

class MarkNotificationAsReadUseCase {
  final TechnicalRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  Future<void> execute(int notificationId) {
    return repository.markNotificationAsRead(notificationId);
  }
}
