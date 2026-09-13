import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_cortes_fibra/main.dart';
import 'package:sistema_cortes_fibra/src/core/app_routes.dart';
import 'package:sistema_cortes_fibra/src/core/theme/app_theme.dart';
import 'package:sistema_cortes_fibra/src/core/theme/theme_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'FiberTech Ops',
      themeMode: themeProvider.themeMode,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}
