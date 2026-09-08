import '../entities/central_office_entity.dart';
import '../repositories/technical_repository.dart';

class ListCentralOfficesUseCase {
  final TechnicalRepository repository;

  ListCentralOfficesUseCase(this.repository);

  Future<List<CentralOfficeEntity>> execute() {
    return repository.listCentralOffices();
  }
}
