import '../entities/central_office_entity.dart';
import '../repositories/technical_repository.dart';

class GetCentralOfficeUseCase {
  final TechnicalRepository repository;

  GetCentralOfficeUseCase(this.repository);

  Future<CentralOfficeEntity> execute(int officeId) {
    return repository.getCentralOffice(officeId);
  }
}
