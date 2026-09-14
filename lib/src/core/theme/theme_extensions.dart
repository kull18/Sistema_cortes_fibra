import 'package:flutter/material.dart';
import 'app_color_scheme.dart';

extension AppThemeContext on BuildContext {
  AppColorScheme get colors =>
      Theme.of(this).extension<AppColorScheme>() ?? AppColorScheme.light;
}
