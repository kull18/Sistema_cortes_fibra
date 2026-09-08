import '../../../core/di/app_container.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../domain/usecases/change_password_usecase.dart';
import '../domain/usecases/device_login_usecase.dart';
import '../domain/usecases/register_device_usecase.dart';
import '../domain/usecases/forgot_password_usecase.dart';
import '../domain/usecases/complete_profile_usecase.dart';
import '../domain/usecases/get_profile_photo_upload_url_usecase.dart';

class AuthModule {
  final AppContainer container;
  
  AuthModule(this.container);

  AuthRepository provideAuthRepository() => container.authRepository;

  LoginUseCase provideLoginUseCase() {
    return LoginUseCase(provideAuthRepository());
  }

  LogoutUseCase provideLogoutUseCase() {
    return LogoutUseCase(provideAuthRepository());
  }

  ChangePasswordUseCase provideChangePasswordUseCase() {
    return ChangePasswordUseCase(provideAuthRepository());
  }

  DeviceLoginUseCase provideDeviceLoginUseCase() {
    return DeviceLoginUseCase(provideAuthRepository());
  }

  RegisterDeviceUseCase provideRegisterDeviceUseCase() {
    return RegisterDeviceUseCase(provideAuthRepository());
  }

  ForgotPasswordUseCase provideForgotPasswordUseCase() {
    return ForgotPasswordUseCase(provideAuthRepository());
  }

  CompleteProfileUseCase provideCompleteProfileUseCase() {
    return CompleteProfileUseCase(provideAuthRepository());
  }

  GetProfilePhotoUploadUrlUseCase provideGetProfilePhotoUploadUrlUseCase() {
    return GetProfilePhotoUploadUrlUseCase(provideAuthRepository());
  }
}
