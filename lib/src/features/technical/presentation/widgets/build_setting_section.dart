import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sistema_cortes_fibra/src/core/theme/theme_extensions.dart';
import 'package:sistema_cortes_fibra/src/core/theme/theme_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/widgets/build_setting_title.dart';

class BuildSettingSection extends StatelessWidget {
  final bool notificaciones;
  final bool sincronizacion;
  final ValueChanged<bool> onNotificacionesChanged;
  final ValueChanged<bool> onSincronizacionChanged;

  const BuildSettingSection({
    super.key,
    required this.notificaciones,
    required this.sincronizacion,
    required this.onNotificacionesChanged,
    required this.onSincronizacionChanged,
  });

  String _getThemeModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
        return 'Sistema';
    }
  }

  void _showThemeSelectorModal(BuildContext context, ThemeProvider themeProvider) {
    final colors = context.colors;

    showModalBottomSheet(
      context: context,
      backgroundColor: colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tema de la Aplicación',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Selecciona la preferencia de tema visual:',
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildThemeOption(
                  context: bottomSheetContext,
                  title: 'Claro',
                  subtitle: 'Fondo claro con alto contraste',
                  icon: Icons.light_mode_outlined,
                  mode: ThemeMode.light,
                  currentMode: themeProvider.themeMode,
                  onSelect: () {
                    themeProvider.setThemeMode(ThemeMode.light);
                    Navigator.pop(bottomSheetContext);
                  },
                ),
                const Divider(height: 1),
                _buildThemeOption(
                  context: bottomSheetContext,
                  title: 'Oscuro',
                  subtitle: 'Fondo oscuro para entornos con poca luz',
                  icon: Icons.dark_mode_outlined,
                  mode: ThemeMode.dark,
                  currentMode: themeProvider.themeMode,
                  onSelect: () {
                    themeProvider.setThemeMode(ThemeMode.dark);
                    Navigator.pop(bottomSheetContext);
                  },
                ),
                const Divider(height: 1),
                _buildThemeOption(
                  context: bottomSheetContext,
                  title: 'Sistema',
                  subtitle: 'Sigue la configuración de tema del dispositivo',
                  icon: Icons.brightness_auto_outlined,
                  mode: ThemeMode.system,
                  currentMode: themeProvider.themeMode,
                  onSelect: () {
                    themeProvider.setThemeMode(ThemeMode.system);
                    Navigator.pop(bottomSheetContext);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildThemeOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
    required ThemeMode currentMode,
    required VoidCallback onSelect,
  }) {
    final colors = context.colors;
    final isSelected = mode == currentMode;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryBlueSoft : colors.surfaceMuted,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isSelected ? colors.primaryBlue : colors.textSecondary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: colors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: colors.textSecondary),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colors.primaryBlue, size: 22)
          : null,
      onTap: onSelect,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final themeProvider = context.watch<ThemeProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.3)),
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
                  colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Configuración de la Aplicación',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colors.textPrimary,
                        ),
                      ),
                      Text(
                        'Ajustes de telemetría y sincronización en terreno',
                        style: TextStyle(
                          fontSize: 11,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.borderSubtle, thickness: 0.5),
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
                InkWell(
                  onTap: () => _showThemeSelectorModal(context, themeProvider),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colors.primaryBlueSoft,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset(
                            'assets/icons/ic_device.svg',
                            width: 20,
                            height: 20,
                            colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tema de la Aplicación',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textPrimary,
                                ),
                              ),
                              Text(
                                'Modo actual: ${_getThemeModeLabel(themeProvider.themeMode)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: colors.surfaceMuted,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colors.borderSubtle.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            _getThemeModeLabel(themeProvider.themeMode),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: colors.primaryBlue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(Icons.chevron_right, size: 20, color: colors.textSecondary),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
