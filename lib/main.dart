import 'package:flutter/material.dart';
import 'package:sistema_cortes_fibra/my_app.dart';
import 'package:sistema_cortes_fibra/src/core/app_colors.dart';
import 'package:sistema_cortes_fibra/src/core/app_routes.dart';
import 'package:sistema_cortes_fibra/src/core/preferences/app_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  
  runApp(const MyApp());
}