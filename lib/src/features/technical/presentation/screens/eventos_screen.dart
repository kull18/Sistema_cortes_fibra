import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/fiber_event.dart';
import '../widgets/incidencias_summary_card.dart';
import '../widgets/event_filter_chips.dart';
import '../widgets/detailed_event_card.dart';
import '../widgets/map_general_card.dart';
import '../providers/home_provider.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  final _searchController = TextEditingController();

  // Datos fake para el esqueleto
  final List<FiberEvent> _fakeEvents = List.generate(
    4,
    (index) => FiberEvent(
      id: 'EV-2025-000',
      title: 'Corte Total de Fibra Monomodo',
      description: 'Descripción detallada del incidente para el skeletonizer.',
      originPrefix: 'XXX',
      destinationPrefix: 'YYY',
      kmReference: 'Km 00.0',
      location: 'Ubicación referencial en carretera',
      timeLabel: 'Hace 0 min',
      reporterName: 'Nombre del Técnico',
      status: FiberEventStatus.activo,
    ),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().initHome();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onTabSelected(AppTab tab) {
    if (tab == AppTab.eventos) return;

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
        break;
      case AppTab.perfil:
        Navigator.of(context).pushReplacementNamed(AppRoutes.perfil);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final showSkeleton = provider.isLoading && provider.events.isEmpty;
        
        final filteredEvents = showSkeleton 
            ? _fakeEvents 
            : provider.events.where((event) {
                final query = _searchController.text.toLowerCase();
                return event.id.toLowerCase().contains(query) ||
                    event.description.toLowerCase().contains(query) ||
                    event.location.toLowerCase().contains(query);
              }).toList();

        final activosCount = showSkeleton ? 0 : provider.events.where((e) => e.status == FiberEventStatus.activo).length;
        final cerradosCount = showSkeleton ? 0 : provider.events.where((e) => e.status == FiberEventStatus.cerrado).length;

        return AppScaffold(
          currentTab: AppTab.eventos,
          onTabSelected: _onTabSelected,
          isScrollable: false,
          appBar: AppTopBar(
            appTitle: 'Eventos',
            subtitle: 'Registro de eventos',
            notificationCount: provider.unreadCount,
            avatarUrl: user?.profilePhotoUrl,
            onNotificationTap: () {
              Navigator.of(context).pushNamed(AppRoutes.notifications);
            },
            onAvatarTap: () {
              Navigator.of(context).pushReplacementNamed(AppRoutes.perfil);
            },
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.fetchEvents(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                Skeletonizer(
                  enabled: showSkeleton,
                  child: IncidenciasSummaryCard(
                    total: showSkeleton ? 0 : provider.events.length,
                    activos: activosCount,
                    cerrados: cerradosCount,
                  ),
                ),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Buscar por folio, ubicación o técnico...',
                      prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                      filled: true,
                      fillColor: AppColors.surfaceMuted,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/ic_filter.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Estado:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: EventFilterChips(
                          selected: provider.selectedFilter,
                          onChanged: (filter) => provider.setFilter(filter),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                if (provider.errorMessage != null && provider.events.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  )
                else if (filteredEvents.isEmpty && !showSkeleton)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text('No se encontraron eventos.'),
                    ),
                  )
                else
                  Skeletonizer(
                    enabled: showSkeleton,
                    child: Column(
                      children: filteredEvents.map((event) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: DetailedEventCard(
                          event: event,
                          onVerDetalle: () {
                            Navigator.of(context).pushNamed(AppRoutes.eventDetail, arguments: event);
                          },
                        ),
                      )).toList(),
                    ),
                  ),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Skeletonizer(
                    enabled: showSkeleton,
                    child: MapGeneralCard(onTap: () {
                      Navigator.of(context).pushNamed(AppRoutes.mapaGeneral);
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
