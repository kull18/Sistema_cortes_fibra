import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/theme_extensions.dart';

class ConfirmationActions extends StatelessWidget {
  final VoidCallback onVerEventos;
  final VoidCallback onVolverInicio;
  final VoidCallback onReportarOtro;

  const ConfirmationActions({
    super.key,
    required this.onVerEventos,
    required this.onVolverInicio,
    required this.onReportarOtro,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        ElevatedButton(
          onPressed: onVerEventos,
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/ic_vital_signs.svg',
                width: 20,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
              const SizedBox(width: 12),
              const Text('Ver Lista de Eventos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              const Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onVolverInicio,
          icon: SvgPicture.asset(
            'assets/icons/ic_home.svg',
            width: 20,
            colorFilter: ColorFilter.mode(colors.textSecondary, BlendMode.srcIn),
          ),
          label: const Text('Volver a Inicio'),
          style: OutlinedButton.styleFrom(
            foregroundColor: colors.textSecondary,
            minimumSize: const Size(double.infinity, 50),
            side: BorderSide(color: colors.borderSubtle),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: onReportarOtro,
          icon: SvgPicture.asset(
            'assets/icons/ic_plus.svg',
            width: 20,
            colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
          ),
          label: const Text('Reportar Otro Corte de Fibra'),
          style: TextButton.styleFrom(
            foregroundColor: colors.primaryBlue,
          ),
        ),
      ],
    );
  }
}
