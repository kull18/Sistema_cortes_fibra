import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/welcome_hero_card.dart';
import '../widgets/quick_access_section.dart';
import '../widgets/events_section.dart';
import '../widgets/event_filter_chips.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Carga inicial de datos al entrar al Home
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
    final authProvider = context.watch<AuthProvider>();
    final homeProvider = context.watch<HomeProvider>();
    final user = authProvider.user;
    final isAdmin = user?.role == 'ADMIN';

    return AppScaffold(
      currentTab: AppTab.inicio,
      onTabSelected: _onTabSelected,
      appBar: AppTopBar(
        notificationCount: homeProvider.unreadCount,
        avatarUrl: user?.profilePhotoUrl, // Ahora muestra la foto del usuario en el Home
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
              if (homeProvider.isLoading && homeProvider.events.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (homeProvider.errorMessage != null && homeProvider.events.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.statusRed, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          homeProvider.errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.textSecondary),
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
                EventsSection(
                  events: homeProvider.events,
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
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
