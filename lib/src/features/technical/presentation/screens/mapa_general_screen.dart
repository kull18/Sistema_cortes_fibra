import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../providers/home_provider.dart';
import '../providers/central_office_provider.dart';
import '../../domain/entities/fiber_event.dart';

class MapaGeneralScreen extends StatefulWidget {
  const MapaGeneralScreen({super.key});

  @override
  State<MapaGeneralScreen> createState() => _MapaGeneralScreenState();
}

class _MapaGeneralScreenState extends State<MapaGeneralScreen> {
  bool _showCentrales = true;
  bool _showCortes = true;
  bool _isSatellite = false;

  GoogleMapController? _mapController;

  FiberEvent? _selectedEvent;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(16.7528, -93.1152),
    zoom: 10,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CentralOfficeProvider>().loadOffices();
      context.read<HomeProvider>().fetchEvents();
    });
  }

  Set<Marker> _buildMarkers(HomeProvider home, CentralOfficeProvider office) {
    final Set<Marker> markers = {};

    if (_showCentrales) {
      for (final c in office.offices) {
        markers.add(
          Marker(
            markerId: MarkerId('office_${c.id}'),
            position: LatLng(c.latitude, c.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
            infoWindow: InfoWindow(
              title: 'Central ${c.prefix}',
              snippet: c.name,
            ),
          ),
        );
      }
    }

    if (_showCortes) {
      final activeEvents = home.events.where((e) => e.status == FiberEventStatus.activo);
      for (final e in activeEvents) {
        if (e.latitude != null && e.longitude != null) {
          markers.add(
            Marker(
              markerId: MarkerId('event_${e.id}'),
              position: LatLng(e.latitude!, e.longitude!),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(
                title: e.id,
                snippet: e.location,
              ),
              onTap: () {
                setState(() {
                  _selectedEvent = e;
                });
              },
            ),
          );
        }
      }
    }

    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final officeProvider = context.watch<CentralOfficeProvider>();
    final activeCuts = homeProvider.events.where((e) => e.status == FiberEventStatus.activo).toList();

    final currentSelection = _selectedEvent ?? (activeCuts.isNotEmpty ? activeCuts.first : null);

    return AppScaffold(
      isScrollable: true,
      padding: EdgeInsets.zero,
      appBar: DetailTopBar(
        title: 'Mapa General',
        subtitle: 'Centrales y Eventos Activos',
        notificationCount: homeProvider.unreadCount,
        onNotificationTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
        onAvatarTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.perfil),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                children: [
                  _buildStatsRow(officeProvider.offices.length, activeCuts.length),
                  const SizedBox(height: 20),
                  _buildLayersSection(),
                  const SizedBox(height: 16),
                  _buildTogglesSection(officeProvider.offices.length, activeCuts.length),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildMapView(homeProvider, officeProvider),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildTechnicalSheet(currentSelection),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.reportarEvento),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/ic_bolt.svg',
                      width: 20,
                      colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Reportar Nuevo Corte de Fibra',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(int centralCount, int activeCuts) {
    return Row(
      children: [
        Expanded(
          child: _statCard('CENTRALES', '$centralCount', 'Activas', AppColors.primaryBlue, 'assets/icons/ic_building.svg'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard('CORTES', '$activeCuts', 'Críticos', const Color(0xFFE11D48), 'assets/icons/ic_alarm.svg'),
        ),
      ],
    );
  }

  Widget _statCard(String label, String value, String sub, Color color, String icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withAlpha(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: 14, colorFilter: ColorFilter.mode(color, BlendMode.srcIn)),
              const SizedBox(width: 6),
              Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: color.withAlpha(25), borderRadius: BorderRadius.circular(4)),
                child: Text(sub, style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLayersSection() {
    return Row(
      children: [
        const Icon(Icons.layers_outlined, color: AppColors.primaryBlue, size: 20),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'Capas del Mapa',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              _layerButton('Esquemático', !_isSatellite),
              _layerButton('Satelital', _isSatellite),
            ],
          ),
        ),
      ],
    );
  }

  Widget _layerButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _isSatellite = label == 'Satelital'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
            color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildTogglesSection(int centralesCount, int cortesCount) {
    return Row(
      children: [
        Expanded(
          child: _toggleItem('Centrales ($centralesCount)', _showCentrales, AppColors.primaryBlue, (val) => setState(() => _showCentrales = val)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _toggleItem('Cortes ($cortesCount)', _showCortes, Colors.red, (val) => setState(() => _showCortes = val)),
        ),
      ],
    );
  }

  Widget _toggleItem(String label, bool value, Color color, ValueChanged<bool> onChanged) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle.withAlpha(76)),
      ),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
          Transform.scale(
            scale: 0.7,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView(HomeProvider home, CentralOfficeProvider office) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle.withAlpha(127)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: GoogleMap(
          initialCameraPosition: _initialPosition,
          mapType: _isSatellite ? MapType.satellite : MapType.normal,
          onMapCreated: (controller) => _mapController = controller,
          markers: _buildMarkers(home, office),
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }

  Widget _buildTechnicalSheet(FiberEvent? selectedEvent) {
    if (selectedEvent == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle.withAlpha(76)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.primaryBlueSoft, borderRadius: BorderRadius.circular(10)),
                  child: SvgPicture.asset('assets/icons/ic_shield.svg', width: 18, colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn)),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Ficha Técnica de Incidencia', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                      Text('Resumen de parámetros de red registrados', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedEvent.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFE11D48))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(12)),
                      child: const Text('ACTIVO', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.red)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 14, color: AppColors.primaryBlue),
                    const SizedBox(width: 6),
                    Text('${selectedEvent.originPrefix} → ${selectedEvent.destinationPrefix}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
                    const SizedBox(width: 4),
                    Text('(${selectedEvent.kmReference})', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Ubicación: ${selectedEvent.location}',
                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushNamed(AppRoutes.eventDetail, arguments: selectedEvent);
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Ver Detalle Completo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    side: const BorderSide(color: AppColors.borderSubtle),
                    foregroundColor: AppColors.textPrimary,
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