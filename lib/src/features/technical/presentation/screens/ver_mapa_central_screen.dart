import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/central_office_entity.dart';
import '../providers/home_provider.dart';

class VerMapaCentralScreen extends StatefulWidget {
  final CentralOfficeEntity office;

  const VerMapaCentralScreen({super.key, required this.office});

  @override
  State<VerMapaCentralScreen> createState() => _VerMapaCentralScreenState();
}

class _VerMapaCentralScreenState extends State<VerMapaCentralScreen> {
  GoogleMapController? _mapController;

  LatLng get _position {
    final lat = widget.office.latitude != 0.0 ? widget.office.latitude : 16.7528;
    final lng = widget.office.longitude != 0.0 ? widget.office.longitude : -93.1152;
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
      isScrollable: false,
      appBar: DetailTopBar(
        title: 'Mapa de Central',
        subtitle: '[${widget.office.prefix}] ${widget.office.name}',
        notificationCount: homeProvider.unreadCount,
        avatarUrl: user?.profilePhotoUrl,
        onNotificationTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
        onAvatarTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.perfil),
      ),
      body: Stack(
        children: [
          // Google Map Full View
          GoogleMap(
            gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
              Factory<OneSequenceGestureRecognizer>(
                () => EagerGestureRecognizer(),
              ),
            },
            initialCameraPosition: CameraPosition(
              target: pos,
              zoom: 16,
            ),
            onMapCreated: (controller) => _mapController = controller,
            markers: {
              Marker(
                markerId: MarkerId('central_office_${widget.office.id}'),
                position: pos,
                infoWindow: InfoWindow(
                  title: widget.office.name,
                  snippet: 'Prefijo: ${widget.office.prefix} · ${widget.office.city}',
                ),
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          ),

          // Overlay GPS superior izquierda
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xB3000000),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.gps_fixed, size: 14, color: AppColors.statusGreen),
                  const SizedBox(width: 6),
                  Text(
                    'GPS: $latFormatted° N, $lngFormatted° W',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Botones de Zoom en mapa
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'btn_zoom_in',
                  onPressed: () => _mapController?.animateCamera(CameraUpdate.zoomIn()),
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: 'btn_zoom_out',
                  onPressed: () => _mapController?.animateCamera(CameraUpdate.zoomOut()),
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.remove, color: AppColors.textPrimary),
                ),
              ],
            ),
          ),

          // Card flotante inferior con información de la central
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderSubtle.withOpacity(0.3)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '[${widget.office.prefix}]',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.office.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.office.city,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed(
                              AppRoutes.fichaCentral,
                              arguments: widget.office,
                            );
                          },
                          icon: const Icon(Icons.info_outline, size: 16, color: AppColors.primaryBlue),
                          label: const Text(
                            'Ver Ficha',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: AppColors.borderSubtle.withOpacity(0.4)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _mapController?.animateCamera(
                              CameraUpdate.newLatLngZoom(pos, 17),
                            );
                          },
                          icon: const Icon(Icons.my_location, size: 16, color: Colors.white),
                          label: const Text(
                            'Centrar',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
