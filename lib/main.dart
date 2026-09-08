import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_cortes_fibra/my_app.dart';
import 'package:sistema_cortes_fibra/src/core/api/api_service.dart';
import 'package:sistema_cortes_fibra/src/core/app_colors.dart';
import 'package:sistema_cortes_fibra/src/core/app_routes.dart';
import 'package:sistema_cortes_fibra/src/core/deeplink/deep_link_service.dart';
import 'package:sistema_cortes_fibra/src/core/di/app_container.dart';
import 'package:sistema_cortes_fibra/src/core/preferences/app_preferences.dart';
import 'package:sistema_cortes_fibra/src/core/preferences/user_preferences.dart';
import 'package:sistema_cortes_fibra/src/features/auth/di/auth_module.dart';
import 'package:sistema_cortes_fibra/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/di/technical_module.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/home_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/mis_eventos_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/central_office_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/report_event_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/event_detail_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/notifications_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

bool _isHandling401 = false;

void _handleUnauthorized(AppContainer container) async {
  if (_isHandling401) return;
  _isHandling401 = true;

  try {
    await container.storage.clearToken();
    await UserPreferences.clear();
    container.userService.clear();
    if (container.api is ApiService) {
      (container.api as ApiService).setAuthToken(null);
    }

    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      AppRoutes.login,
      (route) => false,
    );

    final context = navigatorKey.currentContext;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tu sesión ha expirado. Por favor, inicia sesión nuevamente.'),
          backgroundColor: AppColors.statusRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  } finally {
    Future.delayed(const Duration(seconds: 2), () {
      _isHandling401 = false;
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Inicializar Preferencias
  await AppPreferences.init();

  // 2. Inicializar Contenedor de Dependencias
  final container = AppContainer();
  if (container.api is ApiService) {
    (container.api as ApiService).onUnauthorized = () {
      _handleUnauthorized(container);
    };
  }
  await container.init();

  final authModule = AuthModule(container);
  final technicalModule = TechnicalModule(container);

  // 3. Inicializar Servicio de Deep Links
  final deepLinkService = DeepLinkService();
  deepLinkService.initDeepLinks(
    onEventLinkTapped: (eventId) {
      navigatorKey.currentState?.pushNamed(
        AppRoutes.eventDetail,
        arguments: eventId,
      );
    },
  );
  
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
            updateEventUseCase: technicalModule.provideUpdateEventUseCase(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => MisEventosProvider(
            getEventsUseCase: technicalModule.provideGetEventsUseCase(),
            updateEventUseCase: technicalModule.provideUpdateEventUseCase(),
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
