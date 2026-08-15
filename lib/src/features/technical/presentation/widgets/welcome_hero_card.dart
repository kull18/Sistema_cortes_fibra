import 'package:flutter/material.dart';
import '../../../../core/app_colors.dart';

class WelcomeHeroCard extends StatelessWidget {
  final String technicianName;
  final String? backgroundImage;

  const WelcomeHeroCard({
    super.key,
    required this.technicianName,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 144,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            backgroundImage ?? 'assets/images/fondo.webp',
            fit: BoxFit.cover,
            opacity: const AlwaysStoppedAnimation(0.9),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AppColors.background.withOpacity(0.95),
                  AppColors.background.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TÉCNICO',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: AppColors.primaryBlue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '¡Hola, $technicianName! 👋',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
