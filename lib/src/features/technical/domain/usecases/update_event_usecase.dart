import '../entities/fiber_event.dart';
import '../repositories/technical_repository.dart';

class UpdateEventUseCase {
  final TechnicalRepository repository;

  UpdateEventUseCase(this.repository);

  Future<FiberEvent> execute({
    required int eventId,
    String? status,
    String? description,
    String? fieldReference,
  }) {
    return repository.updateEvent(
      eventId: eventId,
      status: status,
      description: description,
      fieldReference: fieldReference,
    );
  }
}
