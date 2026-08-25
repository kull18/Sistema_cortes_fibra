import '../repositories/auth_repository.dart';

class RegisterDeviceUseCase {
  final AuthRepository repository;

  RegisterDeviceUseCase(this.repository);

  Future<String> call({String? deviceLabel}) {
    return repository.registerDevice(deviceLabel: deviceLabel);
  }
}