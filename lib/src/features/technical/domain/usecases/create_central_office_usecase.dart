import '../entities/central_office_entity.dart';
import '../repositories/technical_repository.dart';

class CreateCentralOfficeUseCase {
  final TechnicalRepository repository;

  CreateCentralOfficeUseCase(this.repository);

  Future<CentralOfficeEntity> execute({
    required String prefix,
    required String name,
    required String city,
    required double latitude,
    required double longitude,
  }) {
    return repository.createCentralOffice(
      prefix: prefix,
      name: name,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
