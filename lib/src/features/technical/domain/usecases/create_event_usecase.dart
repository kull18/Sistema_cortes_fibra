import '../../domain/entities/fiber_event.dart';
import '../repositories/technical_repository.dart';

class CreateEventUseCase {
  final TechnicalRepository repository;

  CreateEventUseCase(this.repository);

  Future<FiberEvent> execute({
    required int originOfficeId,
    required int destinationOfficeId,
    required double latitude,
    required double longitude,
    required String locationMethod,
    double? accuracy,
    String? fieldReference,
    required String description,
  }) {
    return repository.createEvent(
      originOfficeId: originOfficeId,
      destinationOfficeId: destinationOfficeId,
      latitude: latitude,
      longitude: longitude,
      locationMethod: locationMethod,
      accuracy: accuracy,
      fieldReference: fieldReference,
      description: description,
    );
  }
}
