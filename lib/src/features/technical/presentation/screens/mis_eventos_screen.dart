import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../domain/entities/fiber_event.dart';
import '../widgets/detailed_event_card.dart';
import '../widgets/incidencias_summary_card.dart';

class MisEventosScreen extends StatefulWidget {
  const MisEventosScreen({super.key});

  @override
  State<MisEventosScreen> createState() => _MisEventosScreenState();
}

class _MisEventosScreenState extends State<MisEventosScreen> {
  // Datos locales filtrados por el usuario (en este caso dummy)
  final List<FiberEvent> _misEventos = const [
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
      currentTab: AppTab.eventos, // Resaltamos la pestaña de eventos ya que es contenido relacionado
      onTabSelected: _onTabSelected,
      showDivider: true,
      padding: EdgeInsets.zero,
      isScrollable: false,
      appBar: DetailTopBar(
        title: 'Mis Publicaciones',
        subtitle: 'Eventos reportados por ti',
        notificationCount: 2,
        onNotificationTap: () => Navigator.of(context).pushNamed('/notifications'),
        onAvatarTap: () => Navigator.of(context).pushReplacementNamed('/perfil'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                IncidenciasSummaryCard(
                  total: _misEventos.length,
                  activos: _misEventos.where((e) => e.status == FiberEventStatus.activo).length,
                  cerrados: _misEventos.where((e) => e.status == FiberEventStatus.cerrado).length,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'HISTORIAL PERSONAL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlueSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_misEventos.length} Reportes',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (_misEventos.isEmpty)
                  _buildEmptyState()
                else
                  ..._misEventos.map((event) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: DetailedEventCard(
                          event: event,
                          onVerDetalle: () {
                            Navigator.of(context).pushNamed('/event-detail', arguments: event);
                          },
                        ),
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.history_outlined, size: 40, color: AppColors.placeholder),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aún no has publicado eventos',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Tus reportes aparecerán listados aquí.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
