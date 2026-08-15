import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';

class MapGeneralCard extends StatelessWidget {
  final VoidCallback onTap;

  const MapGeneralCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/mapa.svg',
                width: 18,
                colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
              ),
              const SizedBox(width: 8),
              const Text(
                'VISTA DE RED SOBRE MAPA',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),

               Container(
                 padding: const EdgeInsets.all(6),
                 decoration: BoxDecoration(
                   border: Border.all(color: AppColors.borderSubtle),
                   borderRadius: BorderRadius.circular(12)
                 ),
                 child: Row(
                   children: [
                   const Text(
                   'Nodos: TGZ / SCH',
                   style: TextStyle(
                     fontSize: 10,
                     fontWeight: FontWeight.w600,
                     color: AppColors.textSecondary,
                   ),
                 ),
               ])
               )],
          ),
          const SizedBox(height: 12),
          const Text(
            'Consulte la ubicación geográfica de todas las incidencias y centrales registradas sobre la traza regional.',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceMuted,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
              minimumSize: const Size(double.infinity, 48),
              side: const BorderSide(color: AppColors.borderSubtle),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/mapa.svg',
                  width: 18,
                  colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Abrir Mapa General de Eventos',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
