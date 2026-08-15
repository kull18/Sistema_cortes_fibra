import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../models/fiber_event.dart';
import '../widgets/incidencias_summary_card.dart';
import '../widgets/event_filter_chips.dart';
import '../widgets/detailed_event_card.dart';
import '../widgets/map_general_card.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  EventFilter _selectedFilter = EventFilter.todos;
  final _searchController = TextEditingController();

  final List<FiberEvent> _events = const [
    FiberEvent(
      id: 'INC-2025-0094',
      title: 'Corte Total de Fibra Óptica',
      description: 'Ruptura física de cable por excavación de terceros en tramo de transporte.',
      originPrefix: 'TGZ-01',
      destinationPrefix: 'SCH-02',
      kmReference: 'Km 14.2',
      location: 'Cañón del Sumidero',
      timeLabel: 'Hace 25 min',
      reporterName: 'Carlos Mendoza',
      status: FiberEventStatus.activo,
    ),
    FiberEvent(
      id: 'INC-2025-0091',
      title: 'Pérdida Elevada de Potencia',
      description: 'Atenuación fuera de rango detectada en caja de registro sobre carretera.',
      originPrefix: 'SCH-02',
      destinationPrefix: 'SCL-01',
      kmReference: 'Km 22.8',
      location: 'Cruce Teopisca',
      timeLabel: 'Hace 1 hora',
      reporterName: 'Ana Laura Gómez',
      status: FiberEventStatus.activo,
    ),
    FiberEvent(
      id: 'INC-2025-0088',
      title: 'Mantenimiento de Empalme N3',
      description: 'Sustitución de manguito termocontráctil y pruebas de continuidad fotométrica.',
      originPrefix: 'TGZ-01',
      destinationPrefix: 'CHI-03',
      kmReference: 'Km 8.5',
      location: 'Chiapa de Corzo',
      timeLabel: 'Hace 3 horas',
      reporterName: 'Roberto Solis',
      status: FiberEventStatus.atendido,
    ),
    FiberEvent(
      id: 'INC-2025-0084',
      title: 'Reparación de Tramo en Poste #142',
      description: 'Fusión finalizada correctamente. Señal de potencia restablecida a -18.4 dBm.',
      originPrefix: 'TGZ-01',
      destinationPrefix: 'SCL-01',
      kmReference: 'Km 41.5',
      location: 'San Fernando',
      timeLabel: 'Ayer, 18:30 hrs',
      reporterName: 'Carlos Mendoza',
      status: FiberEventStatus.cerrado,
    ),
  ];

  void _onTabSelected(AppTab tab) {
    if (tab == AppTab.inicio) Navigator.of(context).pushReplacementNamed('/home');
    if (tab == AppTab.reportar) Navigator.of(context).pushNamed('/reportar-evento');
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentTab: AppTab.eventos,
      onTabSelected: _onTabSelected,
      appBar: AppTopBar(
        appTitle: 'Eventos',
        subtitle: 'Registro de eventos',
        notificationCount: 3,
        onNotificationTap: () {},
        onAvatarTap: () {},
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const IncidenciasSummaryCard(
            total: 6,
            activos: 2,
            cerrados: 4,
          ),
          const SizedBox(height: 20),
          
          // Barra de Búsqueda
          TextField(
            controller: _searchController,
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
          const SizedBox(height: 16),
          
          // Filtros
          Row(
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
                  selected: _selectedFilter,
                  onChanged: (filter) => setState(() => _selectedFilter = filter),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Lista de Eventos usando DetailedEventCard
          ..._events.map((event) => DetailedEventCard(
            event: event,
            onVerDetalle: () {},
          )),
          
          const SizedBox(height: 8),
          MapGeneralCard(onTap: () {}),
        ],
      ),
    );
  }
}
