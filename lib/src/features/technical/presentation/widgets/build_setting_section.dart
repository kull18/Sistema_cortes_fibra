import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/widgets/build_setting_title.dart';
import '../../../../core/app_colors.dart';

class BuildSettingSection extends StatelessWidget {
  final bool notificaciones;
  final bool sincronizacion;
  final bool gpsAltaPrecision;
  final bool modoOscuro;
  final ValueChanged<bool> onNotificacionesChanged;
  final ValueChanged<bool> onSincronizacionChanged;
  final ValueChanged<bool> onGpsAltaPrecisionChanged;
  final ValueChanged<bool> onModoOscuroChanged;

  const BuildSettingSection({
    super.key,
    required this.notificaciones,
    required this.sincronizacion,
    required this.gpsAltaPrecision,
    required this.modoOscuro,
    required this.onNotificacionesChanged,
    required this.onSincronizacionChanged,
    required this.onGpsAltaPrecisionChanged,
    required this.onModoOscuroChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_bolt.svg',
                  width: 20,
                  colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Configuración de la Aplicación',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Ajustes de telemetría y sincronización en terreno',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.borderSubtle, thickness: 0.5),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                BuildSettingTitle(
                  icon: 'ic_bell.svg',
                  title: 'Notificaciones de Alerta',
                  subtitle: 'Alertas inmediatas ante eventos recientes.',
                  value: notificaciones,
                  onChanged: onNotificacionesChanged,
                ),
                const SizedBox(height: 12),
                BuildSettingTitle(
                  icon: 'ic_refresh.svg',
                  title: 'Sincronización Offline Automática',
                  subtitle: 'Cargar reportes al recuperar cobertura móvil.',
                  value: sincronizacion,
                  onChanged: onSincronizacionChanged,
                ),
                const SizedBox(height: 12),
                BuildSettingTitle(
                  icon: 'ic_locate_fixed.svg',
                  title: 'GPS de Alta Precisión',
                  subtitle: 'Uso continuo de GPS para fijar coordenadas de falla.',
                  value: gpsAltaPrecision,
                  onChanged: onGpsAltaPrecisionChanged,
                ),
                const SizedBox(height: 12),
                BuildSettingTitle(
                  icon: 'ic_device.svg',
                  title: 'Modo claro / oscuro',
                  subtitle: 'Cambiar el tema visual de la interfaz.',
                  value: modoOscuro,
                  onChanged: onModoOscuroChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
