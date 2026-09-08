import '../../domain/entities/fiber_event.dart';
import '../repositories/technical_repository.dart';

class GetEventsUseCase {
  final TechnicalRepository repository;

  GetEventsUseCase(this.repository);

  Future<List<FiberEvent>> call({String? status, String? reportedBy}) {
    return repository.getEvents(status: status, reportedBy: reportedBy);
  }
}
