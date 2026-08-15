import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class ReportarHeroBanner extends StatelessWidget {
  const ReportarHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
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
          // Desvanecimiento consistente con WelcomeHeroCard
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.center,
                colors: [
                  AppColors.background.withOpacity(0.95),
                  AppColors.background.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const Positioned(
            left: 16,
            bottom: 16,
            child: Text(
              'Reporte de un evento',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
