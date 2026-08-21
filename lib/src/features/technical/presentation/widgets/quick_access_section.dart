import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import 'quick_access_button.dart';

class QuickAccessSection extends StatelessWidget {
  final VoidCallback onMapaGeneral;
  final VoidCallback onCentrales;
  final VoidCallback onHistorial;
  final VoidCallback onMisPublicaciones;

  const QuickAccessSection({
    super.key,
    required this.onMapaGeneral,
    required this.onCentrales,
    required this.onHistorial,
    required this.onMisPublicaciones,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'ACCESOS RÁPIDOS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: QuickAccessButton(
                iconPath: 'assets/icons/ic_map.svg',
                label: 'Mapa General',
                onTap: onMapaGeneral,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickAccessButton(
                iconPath: 'assets/icons/ic_compass.svg',
                label: 'Centrales',
                onTap: onCentrales,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: QuickAccessButton(
                iconPath: 'assets/icons/ic_file.svg',
                label: 'Historial',
                onTap: onHistorial,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickAccessButton(
                iconPath: 'assets/icons/ic_user.svg', // Usamos el de usuario para "Mis..."
                label: 'Mis Reportes',
                onTap: onMisPublicaciones,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
