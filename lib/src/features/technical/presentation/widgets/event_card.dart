import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_color_scheme.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/fiber_event.dart';
import 'event_status_chip.dart';

class EventCard extends StatelessWidget {
  final FiberEvent event;
  final VoidCallback onVerDetalle;

  const EventCard({
    super.key,
    required this.event,
    required this.onVerDetalle,
  });

  Color _borderColor(AppColorScheme colors) {
    switch (event.status) {
      case FiberEventStatus.activo:
        return colors.statusRed;
      case FiberEventStatus.atendido:
        return colors.statusGreen;
      case FiberEventStatus.cerrado:
        return colors.textSecondary;
      case FiberEventStatus.pendiente:
        return colors.statusAmber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: _borderColor(colors), width: 4)),
        boxShadow: [
          BoxShadow(color: colors.shadow, blurRadius: 2, offset: const Offset(0, 1)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                event.id,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colors.primaryBlue,
                  letterSpacing: 0.5,
                ),
              ),
              EventStatusChip(status: event.status),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ic_compass.svg',
                width: 14,
                height: 14,
                colorFilter: ColorFilter.mode(
                  colors.primaryBlue,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Tramo ${event.originPrefix} \u2192 ${event.destinationPrefix}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.primaryBlue,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.5)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1),
                      child: SvgPicture.asset(
                        'assets/icons/ic_file.svg',
                        width: 14,
                        height: 14,
                        colorFilter: ColorFilter.mode(
                          colors.primaryBlue,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Descripción: ${event.description.isNotEmpty ? event.description : 'Sin descripción'}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.textPrimary,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: colors.borderSubtle)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_clock.svg',
                        width: 12,
                        height: 12,
                        colorFilter: ColorFilter.mode(
                          colors.textSecondary,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Fecha: ${event.timeLabel}',
                        style: TextStyle(fontSize: 11, color: colors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Tocar para abrir diagnóstico',
                  style: TextStyle(fontSize: 11, color: colors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: onVerDetalle,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver Detalle',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 4),
                    SvgPicture.asset(
                      'assets/icons/ic_arrow_right.svg',
                      width: 14,
                      height: 14,
                      colorFilter: ColorFilter.mode(
                        colors.primaryBlue,
                        BlendMode.srcIn,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
