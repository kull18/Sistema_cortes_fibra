import 'package:flutter/material.dart';
import '../../../../core/models/central.dart';
import '../../../../core/app_colors.dart';

class CentralChipSelector extends StatelessWidget {
  final List<Central> options;
  final Central? selected;
  final Color accentColor;
  final ValueChanged<Central> onSelected;

  const CentralChipSelector({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
    this.accentColor = AppColors.primaryBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options
          .map(
            (central) => Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _buildChip(central),
          ),
        ),
      )
          .toList(),
    );
  }

  Widget _buildChip(Central central) {
    final isSelected = selected?.id == central.id;

    return GestureDetector(
      onTap: () => onSelected(central),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : Colors.white,
          border: Border.all(
            color: isSelected ? accentColor : AppColors.borderSubtle,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              central.prefix,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            Text(
              central.cityLabel,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.white70 : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}