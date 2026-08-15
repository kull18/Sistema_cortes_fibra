import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import 'quick_access_button.dart';

class QuickAccessSection extends StatelessWidget {
  final VoidCallback onMapaGeneral;
  final VoidCallback onCentrales;
  final VoidCallback onHistorial;

  const QuickAccessSection({
    super.key,
    required this.onMapaGeneral,
    required this.onCentrales,
    required this.onHistorial,
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
                iconPath: 'assets/icons/mapa.svg',
                label: 'Mapa General',
                onTap: onMapaGeneral,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickAccessButton(
                iconPath: 'assets/icons/brujula.svg',
                label: 'Centrales',
                onTap: onCentrales,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: QuickAccessButton(
                iconPath: 'assets/icons/archivo.svg',
                label: 'Historial',
                onTap: onHistorial,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
