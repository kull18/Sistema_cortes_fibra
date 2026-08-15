import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../models/fiber_event.dart';
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
  EventFilter _selectedFilter = EventFilter.todos;

  // TODO: reemplazar por datos reales desde el backend (GET /eventos)
  final List<FiberEvent> _events = const [
    FiberEvent(
      id: 'EV-2025-041',
      title: 'Corte Total de Fibra Monomodo',
      description: 'Se reporta pérdida total de señal en tramo principal.',
      originPrefix: 'TGZ',
      destinationPrefix: 'SCH',
      kmReference: 'Km 14.2',
      location: 'Tuxtla Gutiérrez - Berriozábal',
      timeLabel: 'Hace 25 min',
      reporterName: 'Carlos Mendoza',
      status: FiberEventStatus.activo,
    ),
    FiberEvent(
      id: 'EV-2025-039',
      title: 'Atenuación Severa en Empalme',
      description: 'Niveles de potencia por debajo del estándar en OLT.',
      originPrefix: 'SCH',
      destinationPrefix: 'SCL',
      kmReference: 'Km 22.1',
      location: 'San Cristóbal de las Casas',
      timeLabel: 'Hace 1 hora',
      reporterName: 'Ana Laura Gómez',
      status: FiberEventStatus.activo,
    ),
    FiberEvent(
      id: 'EV-2025-035',
      title: 'Fusiones y Reparación de Anillo',
      description: 'Trabajos de mantenimiento preventivo en infraestructura.',
      originPrefix: 'TGZ',
      destinationPrefix: 'SCL',
      kmReference: 'Km 41.8',
      location: 'Socoltenango',
      timeLabel: 'Hoy, 10:15 AM',
      reporterName: 'Roberto Solís',
      status: FiberEventStatus.atendido,
    ),
  ];

  void _onTabSelected(AppTab tab) {
    switch (tab) {
      case AppTab.inicio:
        break;
      case AppTab.reportar:
        Navigator.of(context).pushNamed('/reportar-evento');
        break;
      case AppTab.eventos:
        Navigator.of(context).pushReplacementNamed('/eventos');
        break;
      case AppTab.perfil:
        // Navigator.of(context).pushNamed('/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentTab: AppTab.inicio,
      onTabSelected: _onTabSelected,
      appBar: AppTopBar(
        notificationCount: 3,
        onNotificationTap: () {
          // TODO: navegar a notificaciones
        },
        onAvatarTap: () {
          // TODO: navegar a Perfil
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeHeroCard(
            technicianName: 'Carlos Mendoza',
          ),
          const SizedBox(height: 24),
          QuickAccessSection(
            onMapaGeneral: () {
              // TODO: navegar a Mapa General
            },
            onCentrales: () {
              // TODO: navegar a Directorio de Centrales
            },
            onHistorial: () {
              Navigator.of(context).pushNamed('/eventos');
            },
          ),
          const SizedBox(height: 24),
          EventsSection(
            events: _events,
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() => _selectedFilter = filter);
            },
            onVerTodos: () {
              Navigator.of(context).pushNamed('/eventos');
            },
            onEventTap: (event) {
              // TODO: navegar al Detalle del Evento
            },
          ),
        ],
      ),
    );
  }
}
