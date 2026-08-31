import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_cortes_fibra/my_app.dart';
import 'package:sistema_cortes_fibra/src/core/di/app_container.dart';
import 'package:sistema_cortes_fibra/src/core/preferences/app_preferences.dart';
import 'package:sistema_cortes_fibra/src/features/auth/di/auth_module.dart';
import 'package:sistema_cortes_fibra/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/di/technical_module.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/home_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/central_office_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/report_event_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/event_detail_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/notifications_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inicializar Preferencias
  await AppPreferences.init();

  // 2. Inicializar Contenedor de Dependencias
  final container = AppContainer();
  await container.init();

  final authModule = AuthModule(container);
  final technicalModule = TechnicalModule(container);
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            loginUseCase: authModule.provideLoginUseCase(),
            logoutUseCase: authModule.provideLogoutUseCase(),
            changePasswordUseCase: authModule.provideChangePasswordUseCase(),
            deviceLoginUseCase: authModule.provideDeviceLoginUseCase(),
            registerDeviceUseCase: authModule.provideRegisterDeviceUseCase(),
            forgotPasswordUseCase: authModule.provideForgotPasswordUseCase(),
            completeProfileUseCase: authModule.provideCompleteProfileUseCase(),
            getProfilePhotoUploadUrlUseCase: authModule.provideGetProfilePhotoUploadUrlUseCase(),
            storageService: container.storage,
            userService: container.userService,
            biometricAuthService: container.biometricAuth,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            getEventsUseCase: technicalModule.provideGetEventsUseCase(),
            getUnreadNotificationsCountUseCase: technicalModule.provideGetUnreadNotificationsCountUseCase(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => CentralOfficeProvider(
            listCentralOfficesUseCase: technicalModule.provideListCentralOfficesUseCase(),
            getCentralOfficeUseCase: technicalModule.provideGetCentralOfficeUseCase(),
            createCentralOfficeUseCase: technicalModule.provideCreateCentralOfficeUseCase(),
            updateCentralOfficeUseCase: technicalModule.provideUpdateCentralOfficeUseCase(),
            deleteCentralOfficeUseCase: technicalModule.provideDeleteCentralOfficeUseCase(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ReportEventProvider(
            createEventUseCase: technicalModule.provideCreateEventUseCase(),
            getEventPhotoUploadUrlUseCase: technicalModule.provideGetEventPhotoUploadUrlUseCase(),
            createEventPhotoUseCase: technicalModule.provideCreateEventPhotoUseCase(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => EventDetailProvider(
            getEventUseCase: technicalModule.provideGetEventUseCase(),
            updateEventUseCase: technicalModule.provideUpdateEventUseCase(),
            listEventPhotosUseCase: technicalModule.provideListEventPhotosUseCase(),
            listEventCommentsUseCase: technicalModule.provideListEventCommentsUseCase(),
            createEventCommentUseCase: technicalModule.provideCreateEventCommentUseCase(),
            deleteEventCommentUseCase: technicalModule.provideDeleteEventCommentUseCase(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationsProvider(
            listNotificationsUseCase: technicalModule.provideListNotificationsUseCase(),
            markNotificationAsReadUseCase: technicalModule.provideMarkNotificationAsReadUseCase(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}