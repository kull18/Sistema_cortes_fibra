import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../app_colors.dart';

/// Tarjeta con encabezado numerado ("1. Selección de Tramo de Red", etc.),
/// usada en todos los formularios multi-paso (Reportar, Confirmar, etc.).
class NumberedSectionCard extends StatelessWidget {
  final int stepNumber;
  final String title;
  final String subtitle;
  final String iconAssetPath;
  final Widget? trailing;
  final Widget child;
  final Color? iconColor;
  final Color? iconBackgroundColor;

  const NumberedSectionCard({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.subtitle,
    required this.iconAssetPath,
    required this.child,
    this.trailing,
    this.iconColor,
    this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? AppColors.primaryBlue;
    final effectiveBgColor = iconBackgroundColor ?? AppColors.primaryBlueSoft;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.5)),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: effectiveBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    iconAssetPath,
                    colorFilter: ColorFilter.mode(
                      effectiveIconColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$stepNumber. $title',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: AppColors.borderSubtle.withOpacity(0.3),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}
