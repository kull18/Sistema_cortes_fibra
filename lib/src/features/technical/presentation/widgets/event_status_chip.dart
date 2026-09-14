import 'package:flutter/material.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../technical/domain/entities/fiber_event.dart';

class EventStatusChip extends StatelessWidget {
  final FiberEventStatus status;

  const EventStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final config = _configFor(status, colors);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.1),
        border: Border.all(color: config.color.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 12, color: config.color),
          const SizedBox(width: 4),
          Text(
            config.label.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _configFor(FiberEventStatus status, AppColorScheme colors) {
    switch (status) {
      case FiberEventStatus.activo:
        return _StatusConfig('Activo', colors.statusRed, Icons.sensors);
      case FiberEventStatus.atendido:
        return _StatusConfig('Atendido', colors.statusGreen, Icons.check_circle_outline);
      case FiberEventStatus.cerrado:
        return _StatusConfig('Cerrado', colors.textSecondary, Icons.lock_outline);
      case FiberEventStatus.pendiente:
        return _StatusConfig('Pendiente', colors.statusAmber, Icons.schedule);
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;

  _StatusConfig(this.label, this.color, this.icon);
}
