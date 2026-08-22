import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences _prefs;

  // Notificador para cambios reactivos de tema
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  // Keys
  static const String _keyNotifications = 'notifications_enabled';
  static const String _keyOfflineSync = 'offline_sync_enabled';
  static const String _keyHighPrecisionGps = 'high_precision_gps_enabled';
  static const String _keyDarkMode = 'dark_mode_enabled';

  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // Cargar el tema inicial
    themeNotifier.value = darkModeEnabled ? ThemeMode.dark : ThemeMode.light;
  }

  // Getters
  static bool get notificationsEnabled => _prefs.getBool(_keyNotifications) ?? true;
  static bool get offlineSyncEnabled => _prefs.getBool(_keyOfflineSync) ?? true;
  static bool get highPrecisionGpsEnabled => _prefs.getBool(_keyHighPrecisionGps) ?? false;
  static bool get darkModeEnabled => _prefs.getBool(_keyDarkMode) ?? false;

  // Setters
  static Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_keyNotifications, value);
  }

  static Future<void> setOfflineSyncEnabled(bool value) async {
    await _prefs.setBool(_keyOfflineSync, value);
  }

  static Future<void> setHighPrecisionGpsEnabled(bool value) async {
    await _prefs.setBool(_keyHighPrecisionGps, value);
  }

  static Future<void> setDarkModeEnabled(bool value) async {
    await _prefs.setBool(_keyDarkMode, value);
    // Actualizar el notificador global
    themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
  }
}
