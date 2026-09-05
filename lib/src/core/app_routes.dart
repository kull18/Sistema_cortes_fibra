import 'package:flutter/material.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/change_password_screen.dart';
import '../features/auth/presentation/screens/complete_profile_screen.dart';
import '../features/technical/presentation/screens/home_screen.dart';
import '../features/technical/presentation/screens/reportar_evento_screen.dart';
import '../features/technical/presentation/screens/confirmacion_registro_screen.dart';
import '../features/technical/presentation/screens/eventos_screen.dart';
import '../features/technical/presentation/screens/perfil_screen.dart';
import '../features/technical/presentation/screens/notifications_screen.dart';
import '../features/technical/presentation/screens/event_detail_screen.dart';
import '../features/technical/presentation/screens/centrales_screen.dart';
import '../features/technical/presentation/screens/registrar_central_screen.dart';
import '../features/technical/presentation/screens/mis_eventos_screen.dart';
import '../features/technical/presentation/screens/mapa_general_screen.dart';
import '../features/technical/domain/entities/fiber_event.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/change-password';
  static const String completeProfile = '/complete-profile';
  static const String home = '/home';
  static const String reportarEvento = '/reportar-evento';
  static const String confirmacionRegistro = '/confirmacion-registro';
  static const String eventos = '/eventos';
  static const String perfil = '/perfil';
  static const String centrales = '/centrales';
  static const String registrarCentral = '/registrar-central';
  static const String misEventos = '/mis-eventos';
  static const String notifications = '/notifications';
  static const String eventDetail = '/event-detail';
  static const String mapaGeneral = '/mapa-general';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    login: (context) => const LoginScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    changePassword: (context) => const ChangePasswordScreen(),
    completeProfile: (context) => const CompleteProfileScreen(),
    home: (context) => const HomeScreen(),
    reportarEvento: (context) => const ReportarEventoScreen(),
    confirmacionRegistro: (context) => const ConfirmacionRegistroScreen(),
    eventos: (context) => const EventosScreen(),
    perfil: (context) => const PerfilScreen(),
    centrales: (context) => const CentralesScreen(),
    registrarCentral: (context) => const RegistrarCentralScreen(),
    misEventos: (context) => const MisEventosScreen(),
    notifications: (context) => const NotificationsScreen(),
    mapaGeneral: (context) => const MapaGeneralScreen(),
    eventDetail: (context) {
      final event = ModalRoute.of(context)!.settings.arguments as FiberEvent;
      return EventDetailScreen(event: event);
    },
  };
}
