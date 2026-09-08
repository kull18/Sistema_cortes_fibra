import '../entities/notification_entity.dart';
import '../repositories/technical_repository.dart';

class ListNotificationsUseCase {
  final TechnicalRepository repository;

  ListNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> execute() {
    return repository.listNotifications();
  }
}
