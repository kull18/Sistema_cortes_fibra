import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/models/central.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/numbered_section_card.dart';
import 'central_chip_selector.dart';

class NetworkSegmentSection extends StatelessWidget {
  final List<Central> centrales;
  final Central? origin;
  final Central? destination;
  final double? estimatedDistanceKm;
  final ValueChanged<Central> onOriginSelected;
  final ValueChanged<Central> onDestinationSelected;
  final VoidCallback onSwap;

  const NetworkSegmentSection({
    super.key,
    required this.centrales,
    required this.origin,
    required this.destination,
    required this.estimatedDistanceKm,
    required this.onOriginSelected,
    required this.onDestinationSelected,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    return NumberedSectionCard(
      stepNumber: 1,
      title: 'Selección de Tramo de Red',
      subtitle: 'Elija la central de origen y destino',
      iconAssetPath: 'assets/icons/ic_building.svg',
      trailing: (origin != null && destination != null)
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(color: AppColors.borderSubtle),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    origin!.prefix,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  SvgPicture.asset(
                    'assets/icons/ic_arrow_left_right_simple.svg',
                    width: 12,
                    height: 12,
                    colorFilter: const ColorFilter.mode(
                      AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    destination!.prefix,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _label('Central de Origen (A)', AppColors.primaryBlue),
          const SizedBox(height: 8),
          CentralChipSelector(
            options: centrales,
            selected: origin,
            accentColor: AppColors.primaryBlue,
            onSelected: onOriginSelected,
          ),
          const SizedBox(height: 12),
          Stack(
            alignment: Alignment.center,
            children: [
              const Divider(color: AppColors.borderSubtle),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: OutlinedButton.icon(
                  onPressed: onSwap,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    side: const BorderSide(color: AppColors.borderSubtle),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  icon: SvgPicture.asset(
                    'assets/icons/ic_swap_horizontal.svg',
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryBlue,
                      BlendMode.srcIn,
                    ),
                  ),
                  label: const Text(
                    'Invertir Origen / Destino',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _label('Central de Destino (B)', const Color(0xFF00ACC1)),
          const SizedBox(height: 8),
          CentralChipSelector(
            options: centrales,
            selected: destination,
            accentColor: const Color(0xFF00ACC1),
            onSelected: onDestinationSelected,
          ),
        ],
      ),
    );
  }

  Widget _label(String text, Color dotColor) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
