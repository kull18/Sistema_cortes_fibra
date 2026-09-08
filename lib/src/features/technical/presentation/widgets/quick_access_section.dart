import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import 'quick_access_button.dart';

class QuickAccessSection extends StatelessWidget {
  final VoidCallback onMapaGeneral;
  final VoidCallback onCentrales;
  final VoidCallback onHistorial;
  final VoidCallback onMisPublicaciones;
  final bool showCentrales;

  const QuickAccessSection({
    super.key,
    required this.onMapaGeneral,
    required this.onCentrales,
    required this.onHistorial,
    required this.onMisPublicaciones,
    this.showCentrales = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
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
          // Primera Fila
          Row(
            children: [
              Expanded(
                child: QuickAccessButton(
                  iconPath: 'assets/icons/ic_map.svg',
                  label: 'Mapa General',
                  onTap: onMapaGeneral,
                ),
              ),
              // Solo mostramos el separador y el segundo botón si showCentrales es true
              if (showCentrales) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: QuickAccessButton(
                    iconPath: 'assets/icons/ic_building.svg',
                    label: 'Centrales',
                    onTap: onCentrales,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          // Segunda Fila
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
                  iconPath: 'assets/icons/ic_user.svg',
                  label: 'Mis Reportes',
                  onTap: onMisPublicaciones,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}