import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../domain/entities/fiber_event.dart';
import 'event_status_chip.dart';

class DetailedEventCard extends StatelessWidget {
  final FiberEvent event;
  final VoidCallback onVerDetalle;
  final VoidCallback? onMarcarAtendido;
  final bool showMarcarAtendido;

  const DetailedEventCard({
    super.key,
    required this.event,
    required this.onVerDetalle,
    this.onMarcarAtendido,
    this.showMarcarAtendido = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.surfaceMuted,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  event.id,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${event.originPrefix} \u2192 ${event.destinationPrefix}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: colors.textSecondary,
                  ),
                ),
              ),
              EventStatusChip(status: event.status),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: colors.borderSubtle),
          const SizedBox(height: 12),
          Text(
            event.description,
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              height: 1.4,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_clock.svg',
                  width: 14,
                  height: 14,
                  colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.timeLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ic_user.svg',
                    width: 14,
                    colorFilter: ColorFilter.mode(colors.textSecondary, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    event.reporterDisplay,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onVerDetalle,
                child: Row(
                  children: [
                    Text(
                      'Ver detalle',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colors.primaryBlue,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 16,
                      color: colors.primaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (showMarcarAtendido && event.status == FiberEventStatus.activo && onMarcarAtendido != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onMarcarAtendido,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.statusGreen,
                  side: BorderSide(color: colors.statusGreen),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.check_circle_outline, size: 16),
                label: const Text(
                  'Marcar como Atendido',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
