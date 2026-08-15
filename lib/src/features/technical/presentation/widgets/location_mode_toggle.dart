import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';
import '../../models/location_mode.dart';

class LocationModeToggle extends StatelessWidget {
  final LocationMode selected;
  final ValueChanged<LocationMode> onChanged;

  const LocationModeToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _option(
              icon: 'assets/icons/ic_locate_fixed.svg',
              label: 'GPS Automático',
              mode: LocationMode.gps,
            ),
          ),
          Expanded(
            child: _option(
              icon: 'assets/icons/ic_navigation_pointer.svg',
              label: 'Selección Manual',
              mode: LocationMode.manual,
            ),
          ),
        ],
      ),
    );
  }

  Widget _option({
    required String icon,
    required String label,
    required LocationMode mode,
  }) {
    final isSelected = selected == mode;

    return GestureDetector(
      onTap: () => onChanged(mode),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 16,
              height: 16,
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : AppColors.textSecondary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
