import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/detail_top_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../widgets/confirmation_success_header.dart';
import '../widgets/event_identifier_card.dart';
import '../widgets/confirmation_summary_section.dart';
import '../widgets/confirmation_actions.dart';

class ConfirmacionRegistroScreen extends StatelessWidget {
  const ConfirmacionRegistroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentTab: AppTab.reportar,
      onTabSelected: (tab) {
        if (tab == AppTab.inicio) {
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        }
      },
      appBar: DetailTopBar(
        title: 'Confirmación de Registro',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const ConfirmationSuccessHeader(),
          const SizedBox(height: 32),
          EventIdentifierCard(
            folio: 'EV-2025-0984',
            onCopy: () {
              // TODO: Implement copy to clipboard
            },
            onShare: () {
              // TODO: Implement share
            },
          ),
          const SizedBox(height: 24),
          const ConfirmationSummarySection(
            tramo: 'TGZ → SCH',
            ubicacion: 'Km 18.5 - Carretera Panamericana',
            tipoIncidente: 'Corte de Fibra',
            reportadoPor: 'Ing. Carlos Mendoza (Cuadrilla Sur)',
            horaRegistro: 'Hoy, 11:45 AM',
          ),
          const SizedBox(height: 32),
          ConfirmationActions(
            onVerEventos: () {
              // TODO: Navegar a lista de eventos
            },
            onVolverInicio: () {
              Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            },
            onReportarOtro: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
