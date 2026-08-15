import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';

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
    return Column(
      children: [
        ElevatedButton(
          onPressed: onVerEventos,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/signos_vitales.svg',
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
            'assets/icons/casa.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(AppColors.textSecondary, BlendMode.srcIn),
          ),
          label: const Text('Volver a Inicio'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            minimumSize: const Size(double.infinity, 50),
            side: const BorderSide(color: AppColors.borderSubtle),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: onReportarOtro,
          icon: SvgPicture.asset(
            'assets/icons/mas.svg',
            width: 20,
            colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
          ),
          label: const Text('Reportar Otro Corte de Fibra'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }
}
