import 'package:flutter/material.dart';
import 'breakpoints.dart';

extension ResponsiveExtensions on BuildContext {
  /// Retorna el ancho actual de la pantalla utilizando la API eficiente [MediaQuery.sizeOf].
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Retorna el alto actual de la pantalla utilizando la API eficiente [MediaQuery.sizeOf].
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Retorna si el dispositivo actual es una pantalla compacta (< 360dp).
  bool get isSmallScreen => screenWidth < Breakpoints.small;

  /// Retorna si el dispositivo actual es una pantalla grande (>= 480dp).
  bool get isLargeScreen => screenWidth >= Breakpoints.large;

  /// Retorna el valor genérico correspondiente según el ancho actual de pantalla.
  /// - Si [screenWidth] < 360dp -> [small]
  /// - Si [screenWidth] >= 480dp -> [large] ?? [medium]
  /// - En caso contrario -> [medium]
  T responsiveValue<T>({
    required T small,
    required T medium,
    T? large,
  }) {
    if (screenWidth < Breakpoints.small) {
      return small;
    }
    if (screenWidth >= Breakpoints.large) {
      return large ?? medium;
    }
    return medium;
  }
}
