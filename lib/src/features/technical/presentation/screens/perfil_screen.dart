import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_cortes_fibra/src/core/app_routes.dart';
import 'package:sistema_cortes_fibra/src/core/preferences/app_preferences.dart';
import 'package:sistema_cortes_fibra/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/providers/home_provider.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/widgets/build_info_card.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/widgets/build_setting_section.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/widgets/logout_button.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/widgets/security_section.dart';
import 'package:sistema_cortes_fibra/src/features/technical/presentation/widgets/user_header.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  late bool _notificaciones;
  late bool _sincronizacion;
  late bool _gpsAltaPrecision;
  late bool _modoOscuro;

  @override
  void initState() {
    super.initState();
    _notificaciones = AppPreferences.notificationsEnabled;
    _sincronizacion = AppPreferences.offlineSyncEnabled;
    _gpsAltaPrecision = AppPreferences.highPrecisionGpsEnabled;
    _modoOscuro = AppPreferences.darkModeEnabled;
  }

  void _onTabSelected(AppTab tab) {
    if (tab == AppTab.perfil) return;
    
    switch (tab) {
      case AppTab.inicio:
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        break;
      case AppTab.centrales:
        Navigator.of(context).pushReplacementNamed(AppRoutes.centrales);
        break;
      case AppTab.reportar:
        Navigator.of(context).pushNamed(AppRoutes.reportarEvento);
        break;
      case AppTab.eventos:
        Navigator.of(context).pushReplacementNamed(AppRoutes.eventos);
        break;
      case AppTab.perfil:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final homeProvider = context.watch<HomeProvider>();
    final user = authProvider.user;

    return AppScaffold(
      currentTab: AppTab.perfil,
      onTabSelected: _onTabSelected,
      appBar: AppTopBar(
        appTitle: 'Perfil Técnico',
        notificationCount: homeProvider.unreadCount,
        avatarUrl: user?.profilePhotoUrl,
        onNotificationTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
        onAvatarTap: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            UserHeader(
              name: user?.fullName ?? 'Técnico SCF',
              id: user?.technicianCode ?? 'FT-0000',
              imageUrl: user?.profilePhotoUrl,
            ),
            const SizedBox(height: 24),
            
            BuildInfoCard(
              role: user?.role ?? 'Personal Técnico',
              phone: '+52 --- --- ----',
              email: user?.email ?? 'Sin correo asignado',
            ),
            const SizedBox(height: 24),

            _buildActivitySection(),
            const SizedBox(height: 24),

            BuildSettingSection(
              notificaciones: _notificaciones,
              sincronizacion: _sincronizacion,
              gpsAltaPrecision: _gpsAltaPrecision,
              modoOscuro: _modoOscuro,
              onNotificacionesChanged: (v) async {
                await AppPreferences.setNotificationsEnabled(v);
                setState(() => _notificaciones = v);
              },
              onSincronizacionChanged: (v) async {
                await AppPreferences.setOfflineSyncEnabled(v);
                setState(() => _sincronizacion = v);
              },
              onGpsAltaPrecisionChanged: (v) async {
                await AppPreferences.setHighPrecisionGpsEnabled(v);
                setState(() => _gpsAltaPrecision = v);
              },
              onModoOscuroChanged: (v) async {
                await AppPreferences.setDarkModeEnabled(v);
                setState(() => _modoOscuro = v);
              },
            ),
            const SizedBox(height: 24),

            SecuritySection(
              onChangePassword: () {
                Navigator.of(context).pushNamed(AppRoutes.changePassword);
              },
            ),
            const SizedBox(height: 32),

            LogoutButton(
              onLogout: () async {
                await authProvider.logout();
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                }
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActivitySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle.withAlpha(50)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).pushNamed(AppRoutes.misEventos),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlueSoft,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.assignment_ind_outlined, 
                    color: AppColors.primaryBlue, 
                    size: 22
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Mis Publicaciones',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Ver eventos reportados por ti',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
