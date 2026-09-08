import 'package:flutter/material.dart';
import 'breakpoints.dart';

typedef ResponsiveWidgetBuilder = Widget Function(
  BuildContext context,
  BoxConstraints constraints,
);

/// Widget reutilizable que usa [LayoutBuilder] para elegir qué builder ejecutar
/// según el ancho disponible en los [BoxConstraints] locales del widget padre.
class ResponsiveBuilder extends StatelessWidget {
  final ResponsiveWidgetBuilder? smallBuilder;
  final ResponsiveWidgetBuilder? mediumBuilder;
  final ResponsiveWidgetBuilder? largeBuilder;
  final ResponsiveWidgetBuilder builder;

  const ResponsiveBuilder({
    super.key,
    this.smallBuilder,
    this.mediumBuilder,
    this.largeBuilder,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Breakpoints.small && smallBuilder != null) {
          return smallBuilder!(context, constraints);
        }
        if (constraints.maxWidth >= Breakpoints.large && largeBuilder != null) {
          return largeBuilder!(context, constraints);
        }
        if (mediumBuilder != null) {
          return mediumBuilder!(context, constraints);
        }
        return builder(context, constraints);
      },
    );
  }
}
