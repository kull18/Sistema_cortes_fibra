import 'package:flutter/material.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../domain/entities/fiber_event.dart';
import '../widgets/confirmation_success_header.dart';
import '../widgets/event_identifier_card.dart';
import '../widgets/confirmation_summary_section.dart';
import '../widgets/confirmation_actions.dart';

class ConfirmacionRegistroScreen extends StatelessWidget {
  const ConfirmacionRegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Extraer argumentos. Esperamos un Map con 'event' y 'reportedByName'
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    final event = args?['event'] as FiberEvent?;
    final reportedByName = args?['reportedByName'] as String? ?? 'Técnico de Guardia';

    if (event == null) {
      return const Scaffold(
        body: Center(child: Text('No se recibió la información del evento')),
      );
    }

    // Formatear Folio: Si es numérico, agregar prefijo. Si es UUID, mostrarlo tal cual.
    final String folio = event.id.length > 10 ? 'TEMP-${event.id.substring(0, 8)}' : 'EV-2025-${event.id.padLeft(4, '0')}';
    
    final String tramo = '${event.originPrefix} → ${event.destinationPrefix}';
    
    return AppScaffold(
      currentTab: AppTab.reportar,
      onTabSelected: (tab) {
        if (tab == AppTab.inicio) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
        } else if (tab == AppTab.eventos) {
          Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.eventos, (route) => false);
        }
      },
      appBar: DetailTopBar(
        title: 'Confirmación de Registro',
        onBack: () => Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const ConfirmationSuccessHeader(),
            const SizedBox(height: 32),
            EventIdentifierCard(
              folio: folio,
              onCopy: () {
                // TODO: Implement copy to clipboard
              },
              onShare: () {
                // TODO: Implement share
              },
            ),
            const SizedBox(height: 24),
            ConfirmationSummarySection(
              tramo: tramo,
              ubicacion: event.location.isNotEmpty ? event.location : event.kmReference,
              tipoIncidente: 'Corte de Fibra', // Por ahora estático según el diseño
              reportadoPor: reportedByName,
              horaRegistro: event.timeLabel.isNotEmpty ? event.timeLabel : 'Recién registrado',
            ),
            const SizedBox(height: 32),
            ConfirmationActions(
              onVerEventos: () {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.eventos, (route) => false);
              },
              onVolverInicio: () {
                Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
              },
              onReportarOtro: () {
                Navigator.of(context).pushReplacementNamed(AppRoutes.reportarEvento);
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
