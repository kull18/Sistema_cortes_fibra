import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../models/fiber_event.dart';

class EventStatusChip extends StatelessWidget {
  final FiberEventStatus status;

  const EventStatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _configFor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.15),
        border: Border.all(color: config.color.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 12, color: config.color),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _configFor(FiberEventStatus status) {
    switch (status) {
      case FiberEventStatus.activo:
        return _StatusConfig('Activo', AppColors.statusRed, Icons.sensors);
      case FiberEventStatus.atendido:
        return _StatusConfig('Atendido', AppColors.statusGreen, Icons.build_outlined);
      case FiberEventStatus.pendiente:
        return _StatusConfig('Pendiente', AppColors.statusAmber, Icons.schedule);
    }
  }
}

class _StatusConfig {
  final String label;
  final Color color;
  final IconData icon;

  _StatusConfig(this.label, this.color, this.icon);
}