import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
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
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case AppTab.centrales:
        Navigator.of(context).pushReplacementNamed('/centrales');
        break;
      case AppTab.reportar:
        Navigator.of(context).pushNamed('/reportar-evento');
        break;
      case AppTab.eventos:
        break;
      case AppTab.perfil:
        Navigator.of(context).pushReplacementNamed('/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, provider, child) {
        final filteredEvents = provider.events.where((event) {
          final query = _searchController.text.toLowerCase();
          return event.id.toLowerCase().contains(query) ||
              event.description.toLowerCase().contains(query) ||
              event.location.toLowerCase().contains(query);
        }).toList();

        final activosCount = provider.events.where((e) => e.status == FiberEventStatus.activo).length;
        final cerradosCount = provider.events.where((e) => e.status == FiberEventStatus.cerrado).length;

        return AppScaffold(
          currentTab: AppTab.eventos,
          onTabSelected: _onTabSelected,
          isScrollable: false, // IMPORTANTE: Evita el conflicto de scroll con el ListView interno
          appBar: AppTopBar(
            appTitle: 'Eventos',
            subtitle: 'Registro de eventos',
            notificationCount: provider.unreadCount,
            onNotificationTap: () {
              Navigator.of(context).pushNamed('/notifications');
            },
            onAvatarTap: () {
              Navigator.of(context).pushReplacementNamed('/perfil');
            },
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.fetchEvents(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), // Asegura que el RefreshIndicator funcione
              padding: const EdgeInsets.only(bottom: 100),
              children: [
                IncidenciasSummaryCard(
                  total: provider.events.length,
                  activos: activosCount,
                  cerrados: cerradosCount,
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

                if (provider.isLoading && provider.events.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (provider.errorMessage != null && provider.events.isEmpty)
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
                else if (filteredEvents.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text('No se encontraron eventos.'),
                      ),
                    )
                  else
                    ...filteredEvents.map((event) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: DetailedEventCard(
                        event: event,
                        onVerDetalle: () {
                          Navigator.of(context).pushNamed('/event-detail', arguments: event);
                        },
                      ),
                    )),

                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: MapGeneralCard(onTap: () {}),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
