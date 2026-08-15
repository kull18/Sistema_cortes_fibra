import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/models/central.dart';
import '../../../../core/app_colors.dart';

/// Placeholder visual del mapa. Reemplazar por flutter_map o
/// google_maps_flutter cuando se integre la selección real de coordenadas.
class MapPreviewCard extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final double gpsPrecisionMeters;
  final double kmOnSegment;
  final Central? origin;
  final Central? destination;
  final double? distanceToOriginKm;
  final double? distanceToDestinationKm;

  const MapPreviewCard({
    super.key,
    required this.latitude,
    required this.longitude,
    required this.gpsPrecisionMeters,
    required this.kmOnSegment,
    required this.origin,
    required this.destination,
    required this.distanceToOriginKm,
    required this.distanceToDestinationKm,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 200,
        color: const Color(0xFF14151A),
        child: Stack(
          children: [
            // TODO: sustituir por el widget de mapa real (FlutterMap / GoogleMap)
            Positioned.fill(
              child: CustomPaint(painter: _GridPainter()),
            ),
            Positioned(
              left: 10,
              top: 10,
              child: _badge(
                icon: null,
                dotColor: const Color(0xFF22C55E),
                text:
                'Precisión RTK: \u00b1${gpsPrecisionMeters.toStringAsFixed(1)}m'
                    '   ${latitude?.toStringAsFixed(4) ?? '--'}\u00b0 N, '
                    '${longitude?.abs().toStringAsFixed(4) ?? '--'}\u00b0 W',
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.statusRed,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.sensors, size: 12, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Corte en Km ${kmOnSegment.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  SvgPicture.asset(
                    'assets/icons/ic_edit_pin.svg',
                    width: 30,
                    height: 30,
                    colorFilter: const ColorFilter.mode(
                      AppColors.statusRed,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _endpointLabel(
                    'Central ${origin?.prefix ?? '--'}: '
                        '${distanceToOriginKm?.toStringAsFixed(1) ?? '--'}',
                  ),
                  const Text(
                    '\u2022 Traza Óptica',
                    style: TextStyle(fontSize: 10, color: Colors.white70),
                  ),
                  _endpointLabel(
                    'Central ${destination?.prefix ?? '--'}: '
                        '${distanceToDestinationKm?.toStringAsFixed(1) ?? '--'}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge({required Color dotColor, required String text, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryBlueSoft.withOpacity(0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 10, color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _endpointLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 10, color: Colors.white70),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = 1;

    const step = 24.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
