import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';

class ConfirmationSummarySection extends StatelessWidget {
  final String tramo;
  final String tipoIncidente;
  final String reportadoPor;
  final String horaRegistro;

  const ConfirmationSummarySection({
    super.key,
    required this.tramo,
    required this.tipoIncidente,
    required this.reportadoPor,
    required this.horaRegistro,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/ic_cable.svg',
              width: 18,
              colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Resumen de Datos Confirmados',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Divider(color: AppColors.borderSubtle, height: 1),
        ),
        _buildSummaryItem('assets/icons/ic_alarm.svg', 'Tramo Principal:', tramo),
        _buildSummaryItem(
          'assets/icons/ic_sparkles.svg',
          'Tipo de Incidente:',
          tipoIncidente,
          isBadge: true,
        ),
        _buildSummaryItem('assets/icons/ic_user.svg', 'Reportado Por:', reportadoPor),
        _buildSummaryItem('assets/icons/ic_clock.svg', 'Hora de Registro:', horaRegistro),
      ],
    );
  }

  Widget _buildSummaryItem(String icon, String label, String value, {bool isBadge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            width: 16,
            colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: isBadge
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.connectivityBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        value,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : Text(
                      value,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
