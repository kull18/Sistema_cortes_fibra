import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/central_office_entity.dart';
import '../providers/home_provider.dart';

class FichaCentralScreen extends StatelessWidget {
  final CentralOfficeEntity office;

  const FichaCentralScreen({super.key, required this.office});

  LatLng get _position {
    final lat = office.latitude != 0.0 ? office.latitude : 16.7528;
    final lng = office.longitude != 0.0 ? office.longitude : -93.1152;
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final homeProvider = context.watch<HomeProvider>();
    final user = authProvider.user;

    final pos = _position;
    final latFormatted = pos.latitude.toStringAsFixed(4);
    final lngFormatted = pos.longitude.toStringAsFixed(4);

    return AppScaffold(
      currentTab: null,
      onTabSelected: (_) {},
      showDivider: true,
      padding: EdgeInsets.zero,
      appBar: DetailTopBar(
        title: 'Ficha de Central',
        subtitle: '[${office.prefix}] · Nodo ID #${office.id}',
        notificationCount: homeProvider.unreadCount,
        avatarUrl: user?.profilePhotoUrl,
        onNotificationTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
        onAvatarTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.perfil),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card 1: Header / Resumen Principal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderSubtle.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueSoft,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '[${office.prefix}]',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle_outline, size: 14, color: AppColors.statusGreen),
                            SizedBox(width: 4),
                            Text(
                              'Activa',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.statusGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    office.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_location.svg',
                        width: 14,
                        colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        office.city,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card 2: Especificaciones e Infraestructura
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderSubtle.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ESPECIFICACIONES DEL NODO',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondary,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildSpecRow('Prefijo de Red', office.prefix),
                  const Divider(height: 20, thickness: 0.5),
                  _buildSpecRow('ID de Sistema', '#${office.id}'),
                  const Divider(height: 20, thickness: 0.5),
                  _buildSpecRow('Ciudad / Municipio', office.city),
                  const Divider(height: 20, thickness: 0.5),
                  _buildSpecRow('Coordenadas GPS', '$latFormatted° N, $lngFormatted° W'),
                  const Divider(height: 20, thickness: 0.5),
                  _buildSpecRow('Tipo de Instalación', 'Central Troncal Monomodo'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Card 3: Mapa Preview
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderSubtle.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: Text(
                      'GEOLOCALIZACIÓN',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                  Container(
                    height: 180,
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: pos,
                        zoom: 15,
                      ),
                      onMapCreated: (_) {},
                      markers: {
                        Marker(
                          markerId: MarkerId('central_${office.id}'),
                          position: pos,
                          infoWindow: InfoWindow(title: office.name, snippet: office.city),
                        ),
                      },
                      zoomControlsEnabled: false,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Acciones principales
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.verMapaCentral,
                        arguments: office,
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/icons/ic_map.svg',
                      width: 18,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    label: const Text(
                      'Ver Mapa Completo',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
