import '../entities/unread_count_entity.dart';
import '../repositories/technical_repository.dart';

class GetUnreadNotificationsCountUseCase {
  final TechnicalRepository repository;

  GetUnreadNotificationsCountUseCase(this.repository);

  Future<UnreadCountEntity> call() {
    return repository.getUnreadNotificationsCount();
  }
}
