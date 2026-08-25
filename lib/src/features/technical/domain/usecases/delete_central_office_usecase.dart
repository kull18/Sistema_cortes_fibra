import '../repositories/technical_repository.dart';

class DeleteCentralOfficeUseCase {
  final TechnicalRepository repository;

  DeleteCentralOfficeUseCase(this.repository);

  Future<void> execute(int officeId) {
    return repository.deleteCentralOffice(officeId);
  }
}
