import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
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
    final colors = context.colors;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: colors.surface,
        title: Text('Eliminar Central', style: TextStyle(color: colors.textPrimary)),
        content: Text(
          '¿Está seguro de que desea eliminar la central "${office.name}"? Esta acción no se puede deshacer.',
          style: TextStyle(color: colors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('CANCELAR', style: TextStyle(color: colors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: colors.statusRed),
            child: Text('ELIMINAR', style: TextStyle(color: colors.statusRed)),
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
    final colors = context.colors;
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
                      child: _buildSummaryCard(context, showSkeleton ? 0 : provider.offices.length),
                    ),
                    const SizedBox(height: 20),
                    _buildSearchBar(context),
                    const SizedBox(height: 24),
                    if (provider.error != null && provider.offices.isEmpty)
                      Center(child: Text(provider.error!, style: TextStyle(color: colors.statusRed)))
                    else ...[
                      Skeletonizer(
                        enabled: showSkeleton,
                        child: Text(
                          'Mostrando ${displayedOffices.length} de ${provider.offices.length} centrales',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Skeletonizer(
                        enabled: showSkeleton,
                        child: Column(
                          children: displayedOffices.map((office) => _buildCentralCard(context, office)).toList(),
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
                  backgroundColor: colors.primaryBlue,
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

  Widget _buildSummaryCard(BuildContext context, int count) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.borderSubtle.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
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
                  color: colors.primaryBlueSoft,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_building.svg',
                  width: 24,
                  colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Centrales de Fibra Óptica',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Red Troncal Activa',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
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
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CENTRALES ACTIVAS:',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$count Nodos',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle.withOpacity(0.3)),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        style: TextStyle(color: colors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Buscar por prefijo, ciudad o nombre...',
          hintStyle: TextStyle(color: colors.textSecondary, fontSize: 13),
          prefixIcon: Icon(Icons.search, color: colors.textSecondary, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildCentralCard(BuildContext context, CentralOfficeEntity office) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.borderSubtle.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
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
                  color: colors.primaryBlueSoft,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '[${office.prefix}]',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: colors.primaryBlue,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: colors.textSecondary),
                color: colors.surface,
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
                  PopupMenuItem(
                    value: 'ficha',
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, size: 18, color: colors.primaryBlue),
                        const SizedBox(width: 8),
                        Text('Ver Ficha', style: TextStyle(color: colors.textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'mapa',
                    child: Row(
                      children: [
                        Icon(Icons.map_outlined, size: 18, color: colors.primaryBlue),
                        const SizedBox(width: 8),
                        Text('Ver en Mapa', style: TextStyle(color: colors.textPrimary)),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 18, color: colors.statusRed),
                        const SizedBox(width: 8),
                        Text('Eliminar Central', style: TextStyle(color: colors.statusRed)),
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
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            office.city,
            style: TextStyle(
              fontSize: 13,
              color: colors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: colors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colors.borderSubtle.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'COORDENADAS GPS',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: colors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${office.latitude.toStringAsFixed(4)}° N, ${office.longitude.toStringAsFixed(4)}° W',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: colors.textPrimary,
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
                    side: BorderSide(color: colors.borderSubtle.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.info_outline, size: 18, color: colors.primaryBlue),
                      const SizedBox(width: 8),
                      Text(
                        'Ficha',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: colors.textPrimary,
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
                    color: colors.surfaceMuted,
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
                          colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ver Mapa',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: colors.textPrimary,
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
