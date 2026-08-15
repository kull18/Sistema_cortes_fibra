import 'package:flutter/material.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/technical/presentation/screens/home_screen.dart';
import '../features/technical/presentation/screens/reportar_evento_screen.dart';
import '../features/technical/presentation/screens/confirmacion_registro_screen.dart';
import '../features/technical/presentation/screens/eventos_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String reportarEvento = '/reportar-evento';
  static const String confirmacionRegistro = '/confirmacion-registro';
  static const String eventos = '/eventos';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    reportarEvento: (context) => const ReportarEventoScreen(),
    confirmacionRegistro: (context) => const ConfirmacionRegistroScreen(),
    eventos: (context) => const EventosScreen(),
  };
}
