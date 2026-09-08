import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/responsive/responsive_extensions.dart';

class ReportarHeroBanner extends StatelessWidget {
  const ReportarHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerHeight = context.responsiveValue<double>(
      small: 120.0,
      medium: 150.0,
      large: 170.0,
    );

    return Container(
      height: bannerHeight,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/fondo-red.png',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E3A8A), Color(0xFF3B0764)],
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.center,
                colors: [
                  AppColors.background.withValues(alpha: 0.95),
                  AppColors.background.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Text(
              'Reporte de un evento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
