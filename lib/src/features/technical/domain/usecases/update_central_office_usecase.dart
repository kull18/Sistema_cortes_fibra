import '../entities/central_office_entity.dart';
import '../repositories/technical_repository.dart';

class UpdateCentralOfficeUseCase {
  final TechnicalRepository repository;

  UpdateCentralOfficeUseCase(this.repository);

  Future<CentralOfficeEntity> execute({
    required int officeId,
    String? prefix,
    String? name,
    String? city,
    double? latitude,
    double? longitude,
  }) {
    return repository.updateCentralOffice(
      officeId: officeId,
      prefix: prefix,
      name: name,
      city: city,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
