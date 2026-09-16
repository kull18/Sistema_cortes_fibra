import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/theme_extensions.dart';

class MapGeneralCard extends StatelessWidget {
  final VoidCallback onTap;

  const MapGeneralCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ic_map.svg',
                width: 18,
                colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              Text(
                'VISTA DE RED SOBRE MAPA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: colors.textSecondary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  border: Border.all(color: colors.borderSubtle.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Text(
                      'Nodos: TGZ / SCH',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Consulte la ubicación geográfica de todas las incidencias y centrales registradas sobre la traza regional.',
            style: TextStyle(
              fontSize: 12,
              color: colors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.surfaceMuted,
              foregroundColor: colors.textPrimary,
              elevation: 0,
              minimumSize: const Size(double.infinity, 48),
              side: BorderSide(color: colors.borderSubtle.withOpacity(0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_map.svg',
                  width: 18,
                  colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
                ),
                const SizedBox(width: 10),
                Text(
                  'Abrir Mapa General de Eventos',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: colors.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
