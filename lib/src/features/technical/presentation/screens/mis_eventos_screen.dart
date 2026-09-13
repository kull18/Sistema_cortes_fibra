import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../providers/mis_eventos_provider.dart';
import '../../domain/entities/fiber_event.dart';
import '../widgets/detailed_event_card.dart';
import '../widgets/incidencias_summary_card.dart';
import '../widgets/event_filter_chips.dart';

class MisEventosScreen extends StatefulWidget {
  const MisEventosScreen({super.key});

  @override
  State<MisEventosScreen> createState() => _MisEventosScreenState();
}

class _MisEventosScreenState extends State<MisEventosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MisEventosProvider>().fetchMyEvents();
    });
  }

  void _onTabSelected(AppTab tab) {
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
        Navigator.of(context).pushReplacementNamed(AppRoutes.perfil);
        break;
    }
  }

  Future<void> _handleMarcarAtendido(FiberEvent event) async {
    final eventId = event.rawId ?? int.tryParse(event.id.split('-').last);
    if (eventId == null) return;

    final provider = context.read<MisEventosProvider>();
    final success = await provider.markAsResolved(eventId);

    if (mounted) {
      final colors = context.colors;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Evento marcado como Atendido'),
            backgroundColor: colors.statusGreen,
          ),
        );
      } else if (provider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: colors.statusRed,
          ),
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

    return Consumer<MisEventosProvider>(
      builder: (context, provider, child) {
        final showSkeleton = provider.isLoading && provider.events.isEmpty;
        final events = provider.events;

        final activosCount = showSkeleton ? 0 : events.where((e) => e.status == FiberEventStatus.activo).length;
        final cerradosCount = showSkeleton ? 0 : events.where((e) => e.status == FiberEventStatus.cerrado || e.status == FiberEventStatus.atendido).length;

        return AppScaffold(
          currentTab: AppTab.eventos,
          onTabSelected: _onTabSelected,
          showDivider: true,
          padding: EdgeInsets.zero,
          isScrollable: false,
          appBar: DetailTopBar(
            title: 'Mis Publicaciones',
            subtitle: 'Eventos reportados por ti',
            notificationCount: homeProvider.unreadCount,
            avatarUrl: user?.profilePhotoUrl,
            onNotificationTap: () => Navigator.of(context).pushNamed(AppRoutes.notifications),
            onAvatarTap: () => Navigator.of(context).pushReplacementNamed(AppRoutes.perfil),
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.fetchMyEvents(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                Skeletonizer(
                  enabled: showSkeleton,
                  child: IncidenciasSummaryCard(
                    total: events.length,
                    activos: activosCount,
                    cerrados: cerradosCount,
                  ),
                ),
                const SizedBox(height: 20),

                // Filtros
                Row(
                  children: [
                    Text(
                      'Estado:',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colors.textSecondary),
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
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'HISTORIAL PERSONAL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: colors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colors.primaryBlueSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${events.length} Reportes',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: colors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                if (provider.errorMessage != null && provider.events.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Text(
                        provider.errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: colors.statusRed),
                      ),
                    ),
                  )
                else if (events.isEmpty && !showSkeleton)
                  _buildEmptyState(context)
                else
                  Skeletonizer(
                    enabled: showSkeleton,
                    child: Column(
                      children: events.map((event) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DetailedEventCard(
                          event: event,
                          showMarcarAtendido: true,
                          onMarcarAtendido: () => _handleMarcarAtendido(event),
                          onVerDetalle: () {
                            Navigator.of(context).pushNamed(AppRoutes.eventDetail, arguments: event);
                          },
                        ),
                      )).toList(),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.history_outlined, size: 40, color: colors.placeholder),
            ),
            const SizedBox(height: 16),
            Text(
              'Aún no has publicado eventos',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tus reportes aparecerán listados aquí.',
              style: TextStyle(
                fontSize: 12,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
