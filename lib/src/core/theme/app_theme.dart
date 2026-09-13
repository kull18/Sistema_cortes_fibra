import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColorScheme.light.background,
        colorScheme: ColorScheme.light(
          primary: AppColorScheme.light.primaryBlue,
          surface: AppColorScheme.light.surface,
        ),
        extensions: const [AppColorScheme.light],
      );

  static ThemeData get dark => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColorScheme.dark.background,
        colorScheme: ColorScheme.dark(
          primary: AppColorScheme.dark.primaryBlue,
          surface: AppColorScheme.dark.surface,
        ),
        extensions: const [AppColorScheme.dark],
      );
}
