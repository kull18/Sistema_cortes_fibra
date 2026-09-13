import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/theme/theme_extensions.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/fiber_event.dart';
import '../providers/home_provider.dart';
import '../widgets/welcome_hero_card.dart';
import '../widgets/quick_access_section.dart';
import '../widgets/events_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Datos fake para el esqueleto de eventos
  final List<FiberEvent> _fakeEvents = List.generate(
    3,
    (index) => FiberEvent(
      id: 'EV-2025-000',
      title: 'Corte Total de Fibra Monomodo',
      description: 'Corte detectado en el tramo principal, afectando servicios.',
      originPrefix: 'XXX',
      destinationPrefix: 'YYY',
      kmReference: 'Km 00.0',
      location: 'Ubicación del incidente en carretera',
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

  void _onTabSelected(AppTab tab) {
    if (tab == AppTab.inicio) return;

    switch (tab) {
      case AppTab.inicio:
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

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final authProvider = context.watch<AuthProvider>();
    final homeProvider = context.watch<HomeProvider>();
    final user = authProvider.user;
    final isAdmin = user?.role == 'ADMIN';

    final showSkeleton = homeProvider.isLoading && homeProvider.events.isEmpty;

    return AppScaffold(
      currentTab: AppTab.inicio,
      onTabSelected: _onTabSelected,
      isScrollable: false,
      padding: EdgeInsets.zero,
      appBar: AppTopBar(
        notificationCount: homeProvider.unreadCount,
        avatarUrl: user?.profilePhotoUrl,
        onNotificationTap: () {
          Navigator.of(context).pushNamed(AppRoutes.notifications);
        },
        onAvatarTap: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.perfil);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () => homeProvider.initHome(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WelcomeHeroCard(
                technicianName: user?.fullName ?? 'Técnico',
              ),
              const SizedBox(height: 24),
              QuickAccessSection(
                showCentrales: isAdmin,
                onMapaGeneral: () {
                  Navigator.of(context).pushNamed(AppRoutes.mapaGeneral);
                },
                onCentrales: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.centrales);
                },
                onHistorial: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.eventos);
                },
                onMisPublicaciones: () {
                  Navigator.of(context).pushNamed(AppRoutes.misEventos);
                },
              ),
              const SizedBox(height: 24),
              if (homeProvider.errorMessage != null && homeProvider.events.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(Icons.error_outline, color: colors.statusRed, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          homeProvider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => homeProvider.initHome(),
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Skeletonizer(
                  enabled: showSkeleton,
                  child: EventsSection(
                    events: showSkeleton ? _fakeEvents : homeProvider.events,
                    selectedFilter: homeProvider.selectedFilter,
                    onFilterChanged: (filter) {
                      homeProvider.setFilter(filter);
                    },
                    onVerTodos: () {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.eventos);
                    },
                    onEventTap: (event) {
                      Navigator.of(context).pushNamed(AppRoutes.eventDetail, arguments: event);
                    },
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
