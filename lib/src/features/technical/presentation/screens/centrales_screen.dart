import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/detail_top_bar.dart';

class CentralesScreen extends StatefulWidget {
  const CentralesScreen({super.key});

  @override
  State<CentralesScreen> createState() => _CentralesScreenState();
}

class _CentralesScreenState extends State<CentralesScreen> {
  void _onTabSelected(AppTab tab) {
    if (tab == AppTab.centrales) return;

    switch (tab) {
      case AppTab.inicio:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case AppTab.centrales:
        break;
      case AppTab.reportar:
        Navigator.of(context).pushNamed('/reportar-evento');
        break;
      case AppTab.eventos:
        Navigator.of(context).pushReplacementNamed('/eventos');
        break;
      case AppTab.perfil:
        Navigator.of(context).pushReplacementNamed('/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentTab: AppTab.centrales,
      onTabSelected: _onTabSelected,
      showDivider: true,
      padding: EdgeInsets.zero,
      isScrollable: false, // FIJO: Evita el error de "Vertical viewport was given unbounded height"
      appBar: DetailTopBar(
        title: 'Directorio de Centrales',
        subtitle: 'Nodos de Fibra Óptica Regional',
        notificationCount: 2,
        onNotificationTap: () => Navigator.of(context).pushNamed('/notifications'),
        onAvatarTap: () => Navigator.of(context).pushReplacementNamed('/perfil'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
            children: [
              _buildSummaryCard(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 24),
              const Text(
                'Mostrando 5 de 5 centrales',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _buildCentralCard(
                prefix: 'TGZ-01',
                name: 'Central Tuxtla Gutiérrez',
                location: 'Tuxtla Gutiérrez, Chiapas',
                address: 'Av. Central Poniente #120, Col. Cent',
                gps: '16.7531° N, -93.1151° W',
              ),
              _buildCentralCard(
                prefix: 'SCH-02',
                name: 'Central San Cristóbal',
                location: 'San Cristóbal de las Casas, Chiapas',
                address: 'Calle Real de Guadalupe #10, Col',
                gps: '16.7370° N, -92.6376° W',
              ),
              _buildCentralCard(
                prefix: 'SOL-01',
                name: 'Central Socoltenango',
                location: 'Socoltenango, Chiapas',
                address: 'Carretera panamericana Km 4.5',
                gps: '16.2411° N, -92.3922° W',
              ),
              _buildCentralCard(
                prefix: 'COM-01',
                name: 'Central Comitán',
                location: 'Comitán de Domínguez, Chiapas',
                address: 'Blvd. Belisario Domínguez Km 2.2',
                gps: '16.2525° N, -92.1331° W',
              ),
              _buildCentralCard(
                prefix: 'TAP-01',
                name: 'Central Tapachula',
                location: 'Tapachula, Chiapas',
                address: 'Calle Central Sur #10, Col. Centro',
                gps: '14.9085° N, -92.2618° W',
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.registrarCentral);
              },
              backgroundColor: AppColors.primaryBlue,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
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
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_building.svg',
                  width: 24,
                  colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Centrales de Fibra Óptica',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Red Troncal TGZ - SCH - SCL - TAP - COM',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'CENTRALES ACTIVAS:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '5 Nodos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.3)),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Buscar por prefijo (TGZ, SCH), ciudad o tipo de nod...',
          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.4), fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCentralCard({
    required String prefix,
    required String name,
    required String location,
    required String address,
    required String gps,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primaryBlueSoft,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '[$prefix]',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            location,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity, // Ancho completo
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderSubtle.withOpacity(0.1)),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 18, color: AppColors.primaryBlue),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity, // Ancho completo igual que el de arriba
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderSubtle.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'COORDENADAS GPS',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  gps,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: AppColors.borderSubtle.withOpacity(0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.info_outline, size: 18, color: AppColors.primaryBlue),
                      SizedBox(width: 8),
                      Text(
                        'Ficha',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xFFF1F5F9),
                  ),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_map.svg',
                          width: 18,
                          colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Ver Mapa',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
