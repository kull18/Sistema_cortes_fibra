import '../../domain/entities/fiber_event.dart';
import '../repositories/technical_repository.dart';

class GetEventUseCase {
  final TechnicalRepository repository;

  GetEventUseCase(this.repository);

  Future<FiberEvent> execute(int eventId) {
    return repository.getEvent(eventId);
  }
}
