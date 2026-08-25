import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../providers/home_provider.dart';
import '../providers/central_office_provider.dart';

class MapaGeneralScreen extends StatefulWidget {
  const MapaGeneralScreen({super.key});

  @override
  State<MapaGeneralScreen> createState() => _MapaGeneralScreenState();
}

class _MapaGeneralScreenState extends State<MapaGeneralScreen> {
  bool _showCentrales = true;
  bool _showCortes = true;
  bool _isSatellite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CentralOfficeProvider>().loadOffices();
      context.read<HomeProvider>().fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final officeProvider = context.watch<CentralOfficeProvider>();

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              children: [
                _buildStatsRow(officeProvider.offices.length, homeProvider.events.where((e) => e.status.name == 'activo').length),
                const SizedBox(height: 20),
                _buildLayersSection(),
                const SizedBox(height: 16),
                _buildTogglesSection(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildMapView(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildTechnicalSheet(),
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
    );
  }

  Widget _buildStatsRow(int centralCount, int activeCuts) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/ic_building.svg', width: 14, colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn)),
                    const SizedBox(width: 6),
                    const Text('CENTRALES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('$centralCount', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: AppColors.primaryBlueSoft, borderRadius: BorderRadius.circular(4)),
                      child: const Text('TGZ-SCH-SCL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF1F2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset('assets/icons/ic_alarm.svg', width: 14, colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn)),
                    const SizedBox(width: 6),
                    const Text('CORTES ACTIVOS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFFE11D48))),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('$activeCuts', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFFE11D48))),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(4)),
                      child: const Text('CRÍTICO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLayersSection() {
    return Row(
      children: [
        SvgPicture.asset('assets/icons/ic_layers.svg', width: 18, colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn)),
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
          boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))] : null,
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

  Widget _buildTogglesSection() {
    return Row(
      children: [
        Expanded(
          child: _toggleItem('Centrales (3)', _showCentrales, AppColors.primaryBlue, (val) => setState(() => _showCentrales = val)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _toggleItem('Cortes Activos (2)', _showCortes, Colors.red, (val) => setState(() => _showCortes = val)),
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
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.3)),
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
              activeColor: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 320,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF1E293B),
        image: const DecorationImage(
          image: AssetImage('assets/images/map_dummy.png'), // Asumiendo que existe o similar
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          // Dummy UI over map
          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/ic_map.svg', width: 14, colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn)),
                  const SizedBox(width: 6),
                  const Text('Traza Backbone TGZ \u2192 SCH \u2192 SCL', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                ],
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
              child: const Text('Zoom 100%', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ),
          // Zoom controls dummy
          Positioned(
            top: 60,
            right: 16,
            child: Column(
              children: [
                _mapCircleButton(Icons.add),
                const SizedBox(height: 8),
                _mapCircleButton(Icons.remove),
                const SizedBox(height: 8),
                _mapCircleButton(Icons.my_location, color: AppColors.primaryBlue),
              ],
            ),
          ),
          // Selected info overlay dummy
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Corte Activo: EV-041 (TGZ \u2192 SCH)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                        Text('Ubicación: Km 14.2 - Cañón del Sumidero', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: AppColors.primaryBlueSoft, borderRadius: BorderRadius.circular(10)),
                    child: const Row(
                      children: [
                        Text('Ver Ficha', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
                        Icon(Icons.arrow_downward, size: 12, color: AppColors.primaryBlue),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapCircleButton(IconData icon, {Color? color}) {
    return Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Icon(icon, size: 18, color: color ?? AppColors.textPrimary),
    );
  }

  Widget _buildTechnicalSheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.3)),
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
                      Text('Ficha Técnica de Elemento Seleccionado', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900)),
                      Text('Resumen de parámetros de red y acciones de campo', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                const Icon(Icons.keyboard_arrow_up, color: AppColors.textSecondary),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    _tabButton('Cortes Activos (2)', true),
                    const SizedBox(width: 12),
                    _tabButton('Centrales (3)', false),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _chipSelector('EV-041 (TGZ \u2192 SCH)', true),
                    const SizedBox(width: 8),
                    _chipSelector('EV-022 (SCH \u2192 SCL)', false),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderSubtle.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('EV-2025-041', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFE11D48))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFFFF1F2), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.withOpacity(0.2))),
                            child: const Row(
                              children: [
                                Icon(Icons.circle, size: 6, color: Colors.red),
                                SizedBox(width: 4),
                                Text('Crítica', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text('Corte Total de Fibra Monomodo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/ic_compass.svg', width: 14, colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn)),
                          const SizedBox(width: 6),
                          const Text('Tramo TGZ \u2192 SCH', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primaryBlue)),
                          const SizedBox(width: 4),
                          const Text('(Km 14.2)', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Ref. Ubicación: Cañón del Sumidero, Caja N3 (Poste #P-142)',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.near_me_outlined, size: 18),
                  label: const Text('Navegar GPS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
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

  Widget _tabButton(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE11D48) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? const Color(0xFFE11D48) : AppColors.borderSubtle.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            isSelected ? 'assets/icons/ic_bolt.svg' : 'assets/icons/ic_compass.svg',
            width: 14,
            colorFilter: ColorFilter.mode(isSelected ? Colors.white : AppColors.textSecondary, BlendMode.srcIn),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: isSelected ? Colors.white : AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _chipSelector(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFFFF1F2) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSelected ? const Color(0xFFE11D48) : AppColors.borderSubtle.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600, color: isSelected ? const Color(0xFFE11D48) : AppColors.textPrimary),
      ),
    );
  }
}
