import 'package:flutter/material.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/technical/presentation/screens/home_screen.dart';
import '../features/technical/presentation/screens/reportar_evento_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String reportarEvento = '/reportar-evento';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    home: (context) => const HomeScreen(),
    reportarEvento: (context) => const ReportarEventoScreen(),
  };
}
