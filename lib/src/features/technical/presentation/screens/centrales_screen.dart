import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../providers/central_office_provider.dart';
import '../../domain/entities/central_office_entity.dart';

class CentralesScreen extends StatefulWidget {
  const CentralesScreen({super.key});

  @override
  State<CentralesScreen> createState() => _CentralesScreenState();
}

class _CentralesScreenState extends State<CentralesScreen> {
  String _searchQuery = '';

  // Datos fake para el esqueleto
  final List<CentralOfficeEntity> _fakeOffices = List.generate(
    5,
    (index) => CentralOfficeEntity(
      id: index,
      prefix: 'XXX',
      name: 'Nombre de la Central de Fibra',
      city: 'Ciudad del Nodo',
      latitude: 0.0,
      longitude: 0.0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CentralOfficeProvider>().loadOffices();
    });
  }

  void _onTabSelected(AppTab tab) {
    if (tab == AppTab.centrales) return;

    switch (tab) {
      case AppTab.inicio:
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        break;
      case AppTab.centrales:
        break;
      case AppTab.reportar:
        Navigator.of(context).pushNamed(AppRoutes.reportarEvento);
        break;
      case AppTab.eventos:
        Navigator.of(context).pushReplacementNamed(AppRoutes.eventos);
        break;
      case AppTab.perfil:
        Navigator.of(context).pushReplacementNamed(AppRoutes.perfil);
        break;
    }
  }

  Future<void> _deleteOffice(CentralOfficeEntity office) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Central'),
        content: Text('¿Está seguro de que desea eliminar la central "${office.name}"? Esta acción no se puede deshacer.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCELAR'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('ELIMINAR'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await context.read<CentralOfficeProvider>().deleteOffice(office.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Central eliminada correctamente')),
        );
      } else if (mounted) {
        final error = context.read<CentralOfficeProvider>().error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error ?? 'Error al eliminar central')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final homeProvider = context.watch<HomeProvider>();
    final user = authProvider.user;

    return AppScaffold(
      currentTab: AppTab.centrales,
      onTabSelected: _onTabSelected,
      showDivider: true,
      padding: EdgeInsets.zero,
      isScrollable: false,
      appBar: DetailTopBar(
        title: 'Directorio de Centrales',
        subtitle: 'Nodos de Fibra Óptica Regional',
        notificationCount: homeProvider.unreadCount,
        avatarUrl: user?.profilePhotoUrl,
        onNotificationTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
        onAvatarTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.perfil),
      ),
      body: Consumer<CentralOfficeProvider>(
        builder: (context, provider, child) {
          final showSkeleton = provider.isLoading && provider.offices.isEmpty;
          final displayedOffices = showSkeleton 
              ? _fakeOffices 
              : provider.offices.where((o) {
                  final query = _searchQuery.toLowerCase();
                  return o.name.toLowerCase().contains(query) ||
                      o.prefix.toLowerCase().contains(query) ||
                      o.city.toLowerCase().contains(query);
                }).toList();

          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: provider.loadOffices,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  children: [
                    Skeletonizer(
                      enabled: showSkeleton,
                      child: _buildSummaryCard(showSkeleton ? 0 : provider.offices.length),
                    ),
                    const SizedBox(height: 20),
                    _buildSearchBar(),
                    const SizedBox(height: 24),
                    if (provider.error != null && provider.offices.isEmpty)
                      Center(child: Text(provider.error!))
                    else ...[
                      Skeletonizer(
                        enabled: showSkeleton,
                        child: Text(
                          'Mostrando ${displayedOffices.length} de ${provider.offices.length} centrales',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Skeletonizer(
                        enabled: showSkeleton,
                        child: Column(
                          children: displayedOffices.map((office) => _buildCentralCard(office)).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
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
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(int count) {
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
                      'Red Troncal Activa',
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
              children: [
                const Text(
                  'CENTRALES ACTIVAS:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count Nodos',
                  style: const TextStyle(
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
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Buscar por prefijo, ciudad o nombre...',
          hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.4), fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCentralCard(CentralOfficeEntity office) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '[${office.prefix}]',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
                onSelected: (value) {
                  if (value == 'ficha') {
                    Navigator.of(context).pushNamed(AppRoutes.fichaCentral, arguments: office);
                  } else if (value == 'mapa') {
                    Navigator.of(context).pushNamed(AppRoutes.verMapaCentral, arguments: office);
                  } else if (value == 'delete') {
                    _deleteOffice(office);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'ficha',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 18, color: AppColors.primaryBlue),
                        SizedBox(width: 8),
                        Text('Ver Ficha'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'mapa',
                    child: Row(
                      children: [
                        Icon(Icons.map_outlined, size: 18, color: AppColors.primaryBlue),
                        SizedBox(width: 8),
                        Text('Ver en Mapa'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Eliminar Central', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            office.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            office.city,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
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
                  '${office.latitude.toStringAsFixed(4)}° N, ${office.longitude.toStringAsFixed(4)}° W',
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
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.fichaCentral,
                      arguments: office,
                    );
                  },
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
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.verMapaCentral,
                        arguments: office,
                      );
                    },
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
