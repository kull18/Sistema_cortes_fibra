import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/theme_extensions.dart';

class IncidenciasSummaryCard extends StatelessWidget {
  final int total;
  final int activos;
  final int cerrados;

  const IncidenciasSummaryCard({
    super.key,
    required this.total,
    required this.activos,
    required this.cerrados,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.borderSubtle.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colors.primaryBlueSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/ic_vital_signs.svg',
                    width: 22,
                    colorFilter: ColorFilter.mode(colors.primaryBlue, BlendMode.srcIn),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bitácora de Incidencias',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Red de Fibra Óptica · TGZ · SCH · SCL',
                      style: TextStyle(
                        fontSize: 12,
                        color: colors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _buildStatItem(
                context: context,
                label: 'TOTAL',
                value: total.toString(),
                isSelected: true,
              ),
              const SizedBox(width: 12),
              _buildStatItem(
                context: context,
                label: 'ACTIVOS',
                value: activos.toString(),
                isSelected: false,
                valueColor: colors.statusRed,
              ),
              const SizedBox(width: 12),
              _buildStatItem(
                context: context,
                label: 'CERRADOS',
                value: cerrados.toString(),
                isSelected: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required BuildContext context,
    required String label,
    required String value,
    required bool isSelected,
    Color? valueColor,
  }) {
    final colors = context.colors;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? colors.primaryBlueSoft : colors.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? colors.primaryBlue : colors.borderSubtle.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? colors.primaryBlue : colors.textSecondary,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: valueColor ?? colors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
